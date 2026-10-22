#!/bin/bash
set -euo pipefail
mkdir -p media
xcodebuild -version | tee media/environment.txt
xcrun simctl list devices available -j > media/devices.json
SIM_UDID=$(python3 - <<'PY'
import json
data=json.load(open('media/devices.json'))
for runtime,devices in data['devices'].items():
    if 'iOS-27-0' in runtime:
        for device in devices:
            if device['name']=='iPhone 18 Pro Max':
                print(device['udid']);raise SystemExit
raise SystemExit('Required iPhone 18 Pro Max / iOS 27.0 simulator is unavailable')
PY
)
echo "iPhone 18 Pro Max / iOS 27.0 / $SIM_UDID" | tee -a media/environment.txt
xcrun simctl boot "$SIM_UDID" || true
xcrun simctl bootstatus "$SIM_UDID" -b
xcrun simctl status_bar "$SIM_UDID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
xcrun simctl ui "$SIM_UDID" appearance light
xcodebuild build-for-testing -project IcelandAtlas.xcodeproj -scheme IcelandAtlas -destination "platform=iOS Simulator,id=$SIM_UDID" -derivedDataPath DerivedData CODE_SIGNING_ALLOWED=NO > media/build.log 2>&1 || { tail -100 media/build.log; exit 1; }
xcrun simctl install "$SIM_UDID" DerivedData/Build/Products/Debug-iphonesimulator/IcelandAtlas.app
xcrun simctl launch "$SIM_UDID" com.peterpanswift.IcelandAtlas --reset-journal
python3 -c 'import time;print(time.time())' > media/recording-start.txt
xcrun simctl io "$SIM_UDID" recordVideo --codec=h264 --force media/raw-demo.mp4 > media/recording.log 2>&1 &
RECORD_PID=$!
trap 'kill -INT "$RECORD_PID" 2>/dev/null || true' EXIT
set +e
xcodebuild test-without-building -project IcelandAtlas.xcodeproj -scheme IcelandAtlas -destination "platform=iOS Simulator,id=$SIM_UDID" -derivedDataPath DerivedData -parallel-testing-enabled NO -only-testing:IcelandAtlasUITests/DemoTests/testRecordTravelExperience -resultBundlePath media/Demo.xcresult CODE_SIGNING_ALLOWED=NO > media/demo-test.log 2>&1
TEST_EXIT=$?
set -e
kill -INT "$RECORD_PID" || true
wait "$RECORD_PID" || true
trap - EXIT
xcrun xcresulttool export attachments --path media/Demo.xcresult --output-path media/attachments
if [ "$TEST_EXIT" -ne 0 ]; then tail -120 media/demo-test.log; exit "$TEST_EXIT"; fi
ffprobe -v quiet -show_format -of json media/raw-demo.mp4 > media/raw-video-metadata.json
python3 - <<'PY'
import re,json,pathlib,datetime
log=pathlib.Path('media/demo-test.log').read_text()
start=re.findall(r'DEMO_START_EPOCH=([0-9.]+)',log)
end=re.findall(r'DEMO_END_EPOCH=([0-9.]+)',log)
if start and end:
    timing={'start':float(start[-1]),'end':float(end[-1])}
else:
    timing=None
    for p in pathlib.Path('media/attachments').rglob('*'):
        if p.is_file() and p.suffix in ('.txt','.json'):
            try:
                v=json.loads(p.read_text())
                if isinstance(v,dict) and 'start' in v and 'end' in v:timing=v
            except Exception:pass
    if not timing:raise RuntimeError('Missing exact demo timing; refusing to deliver untrimmed recording')
# simctl may take several seconds to begin capturing. The movie's actual
# creation time is more accurate than the shell command's invocation time.
metadata=json.loads(pathlib.Path('media/raw-video-metadata.json').read_text())
created=metadata['format']['tags']['creation_time']
recording=datetime.datetime.fromisoformat(created.replace('Z','+00:00')).timestamp()
pathlib.Path('media/trim.txt').write_text(f"{max(0,timing['start']-recording):.3f} {max(0,timing['end']-timing['start']-1):.3f}")
PY
read -r TRIM_START TRIM_LENGTH < media/trim.txt || true
ffmpeg -y -ss "$TRIM_START" -i media/raw-demo.mp4 -t "$TRIM_LENGTH" -vf 'scale=886:-2' -r 30 -c:v libx264 -preset medium -crf 24 -pix_fmt yuv420p -an -movflags +faststart media/Iceland-App-Demo.mp4 > media/compression.log 2>&1
ffprobe -v quiet -show_format -show_streams -of json media/Iceland-App-Demo.mp4 > media/video-metadata.json
set +e
xcodebuild test-without-building -project IcelandAtlas.xcodeproj -scheme IcelandAtlas -destination "platform=iOS Simulator,id=$SIM_UDID" -derivedDataPath DerivedData -parallel-testing-enabled NO -only-testing:IcelandAtlasUITests/DemoTests/testSearchAndPersistence -resultBundlePath media/Validation.xcresult CODE_SIGNING_ALLOWED=NO > media/validation.log 2>&1
VERIFY_EXIT=$?
set -e
ditto -c -k --sequesterRsrc --keepParent DerivedData/Build/Products/Debug-iphonesimulator/IcelandAtlas.app media/IcelandAtlas-Simulator.app.zip
if [ "$VERIFY_EXIT" -ne 0 ]; then tail -100 media/validation.log; exit "$VERIFY_EXIT"; fi
# Retain the original recording in the artifact for frame-level review.
