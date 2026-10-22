"""Draw the original Ísland mountain-and-water app mark at 1024 px."""
from PIL import Image, ImageDraw
from pathlib import Path
import json
import math

size = 1024
scale = 3
image = Image.new('RGB', (size * scale, size * scale))
draw = ImageDraw.Draw(image)
for y in range(size * scale):
    t = y / (size * scale)
    color = tuple(round(a + (b-a)*t) for a,b in zip((10,39,47),(27,80,79)))
    draw.line((0,y,size*scale,y), fill=color)
def polygon(points, fill):
    draw.polygon([(int(x*scale), int(y*scale)) for x,y in points], fill=fill)
def ellipse(box, fill):
    draw.ellipse(tuple(int(x*scale) for x in box), fill=fill)

ellipse((660,196,778,314), '#DCEBA7')
polygon([(170,664),(424,292),(634,664)], '#F2F5E7')
polygon([(424,292),(634,664),(480,664)], '#AEC9BD')
polygon([(392,664),(598,400),(850,664)], '#82B6AD')
polygon([(598,400),(850,664),(675,664)], '#518D89')
polygon([(424,292),(358,389),(413,365),(454,401)], '#FFFFFF')
for offset, color in [(0,'#DCEBA7'),(64,'#9AC9B8')]:
    points=[]
    for x in range(184,841):
        y=735+offset+16*math.sin((x-184)/656*math.pi*2)
        points.append((int(x*scale),int(y*scale)))
    draw.line(points,fill=color,width=14*scale)
image = image.resize((size,size), Image.Resampling.LANCZOS)
folder=Path(__file__).resolve().parents[1]/'IcelandAtlas/Assets.xcassets/AppIcon.appiconset'
folder.mkdir(parents=True,exist_ok=True)
image.save(folder/'AppIcon.png')
(folder/'Contents.json').write_text(json.dumps({'images':[{'filename':'AppIcon.png','idiom':'universal','platform':'ios','size':'1024x1024'}],'info':{'author':'xcode','version':1}},indent=2))
