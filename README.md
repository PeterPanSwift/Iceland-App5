# Ísland 冰島

以 SwiftUI 製作的繁體中文冰島旅行指南，支援 iOS 17 以上的 iPhone。

## 功能

- 大幅景點攝影、四個景點的中文介紹、在地名稱與旅行提醒。
- 景點分類、名稱／地區搜尋。
- 收藏、加入行程、移除與調整停留點順序；內容儲存在裝置上。
- 旅行手冊、Apple Maps 與冰島官方資訊連結。
- 離線照片與主要內容、原創 1024 × 1024 App Icon。

## 開啟專案

已附上 `IcelandAtlas.xcodeproj` 時，可直接以 Xcode 開啟。
若從原始碼重新產生專案：

```sh
brew install xcodegen
xcodegen generate
open IcelandAtlas.xcodeproj
```

選取 `IcelandAtlas` scheme 與 iPhone 模擬器。模擬器建置不需要簽章。
若要安裝到實體裝置或上架，請設定自己的 Development Team、Bundle Identifier 與簽章。

## GitHub 錄影與截圖

Repository：<https://github.com/PeterPanSwift/Iceland-App5>

Actions 的 **Build, Record and Capture App Store Screenshots** 使用 `xcode-27` runner、Xcode 27.0、iOS 27.0 與 **iPhone 18 Pro Max**。

流程會建置 App，執行實際 UI 操作，匯出六張原始 PNG 截圖，以操作時間標記裁掉前後等待，再以 H.264 壓縮 MP4。影片沒有加入桌面、模擬器視窗邊框或音軌。

另外驗證搜尋、收藏與行程在重新啟動後仍會保留。執行結果與建置紀錄包含於 Actions artifact。

## 照片來源

照片來自 [Unsplash](https://unsplash.com/license)，各景點內含攝影者及原始照片連結，完整清單見 `PHOTO_CREDITS.json`。

- 教會山：Frugal Flyer
- 斯科加瀑布：Katarzyna Gonsior
- 傑古沙龍冰河湖：Cai Photography
- 雷尼斯黑沙灘：With Paul

App Icon 是專案內程式繪製的原創山峰與水紋圖案。

## App Store 素材

匯出的 PNG 為模擬器中的真實 App 畫面。上傳前請依 App Store Connect 當下要求選取對應的顯示尺寸，規格參考 [Apple Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)。

此專案不包含 App Store Connect 上傳、正式簽章、隱私權政策網站或發佈操作。
