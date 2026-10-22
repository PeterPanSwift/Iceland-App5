import SwiftUI

struct FieldGuideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    Eyebrow(text: "BEFORE YOU GO").foregroundStyle(Palette.muted)
                    Text("你好，冰島。").font(.system(size: 34, weight: .semibold))
                    Text("北大西洋上的島嶼，讓火山與冰川共享同一片土地。從雷克雅維克出發，每一段路都通往不同的驚喜。")
                        .font(.system(size: 16)).lineSpacing(7).foregroundStyle(Palette.muted)
                    guide("sun.max", "選一個喜歡的季節", "夏季日照長，適合慢慢探索；冬季夜色長，有機會看見極光。極光是自然現象，能否看見仍取決於天候與活動狀況。")
                    guide("cloud.rain", "把四季穿在身上", "採用分層穿搭，準備防風防水外套、保暖中層與防滑鞋。即使在夏天，也要預留應對風雨的裝備。")
                    guide("car", "讓路況決定步調", "出發前查看道路與天氣資訊。高地道路有季節限制，部分道路需使用適合的四輪傳動車，勿離開道路駕駛。")
                    guide("leaf", "把美好留在原地", "走在標示步道上，不踩踏脆弱的苔原與苔蘚；尊重野生動物，帶走垃圾，留下回憶。")
                    VStack(alignment: .leading, spacing: 16) {
                        Text("旅行時的可靠夥伴").font(.headline)
                        Link("SafeTravel · 旅遊安全與警示 ↗", destination: URL(string: "https://safetravel.is")!)
                        Link("Umferðin · 道路狀況 ↗", destination: URL(string: "https://umferdin.is/en")!)
                        Link("冰島氣象局 · 天氣預報 ↗", destination: URL(string: "https://en.vedur.is")!)
                        Link("Visit Iceland · 官方旅遊資訊 ↗", destination: URL(string: "https://www.visiticeland.com")!)
                    }.font(.system(size: 14)).padding(22).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: .rect(cornerRadius: 20))
                    Text("影像來自 Unsplash，攝影者與原始照片連結詳見各景點頁。主要內容與收藏可離線使用；外部連結需要網路。")
                        .font(.caption).lineSpacing(5).foregroundStyle(Palette.muted)
                }.padding(26)
            }
            .background(Palette.paper).foregroundStyle(Palette.ink)
            .navigationTitle("旅行手冊").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { dismiss() } } }
        }
    }

    private func guide(_ icon: String, _ title: String, _ copy: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon).font(.system(size: 23, weight: .light)).frame(width: 32)
            VStack(alignment: .leading, spacing: 10) {
                Text(title).font(.system(size: 18, weight: .semibold))
                Text(copy).font(.system(size: 14)).lineSpacing(6).foregroundStyle(Palette.muted)
            }
        }
    }
}
