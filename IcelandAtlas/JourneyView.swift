import SwiftUI

struct JourneyView: View {
    @Environment(TravelJournal.self) private var journal
    @State private var editing = false
    @State private var showsGuide = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Eyebrow(text: "THE ROAD IS YOURS").foregroundStyle(Palette.muted)
                        Text("我的冰島慢旅").font(.system(size: 32, weight: .bold))
                    }
                    Spacer()
                    Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                        .font(.system(size: 28, weight: .light))
                }
                ZStack(alignment: .bottomLeading) {
                    Landscape(name: "lagoon")
                    LinearGradient(colors: [.clear, Palette.ink.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 10) {
                        Eyebrow(text: "SOUTH COAST / 3 DAYS").foregroundStyle(Palette.lime)
                        Text("沿著南岸，\n走向冰與海。").font(.system(size: 29, weight: .semibold)).lineSpacing(4)
                        Text("斯科加瀑布 → 黑沙灘 → 冰河湖").font(.system(size: 12))
                    }.foregroundStyle(.white).padding(24)
                }.frame(height: 272).clipShape(.rect(cornerRadius: 26))
                HStack {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("口袋裡的路線").font(.system(size: 23, weight: .semibold))
                        Text("\(journal.route.count) 個停留點 · 按加入順序排列")
                            .font(.system(size: 12)).foregroundStyle(Palette.muted)
                    }
                    Spacer()
                    if !journal.route.isEmpty {
                        Button(editing ? "完成" : "編輯") { withAnimation { editing.toggle() } }
                            .font(.system(size: 14, weight: .medium))
                            .accessibilityIdentifier("edit-route")
                    }
                }
                if journal.route.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("從一個心動的地方開始。").font(.system(size: 17, weight: .medium))
                        Text("在景點頁加入想去的地方，或先收下我們的南岸路線，再安排自己的旅行節奏。")
                            .font(.system(size: 14)).lineSpacing(6).foregroundStyle(Palette.muted)
                        Button {
                            withAnimation { journal.route = ["skogafoss", "beach", "lagoon"] }
                        } label: {
                            Label("使用推薦路線", systemImage: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.horizontal, 20).padding(.vertical, 14)
                                .background(Palette.ink, in: Capsule()).foregroundStyle(.white)
                        }.accessibilityIdentifier("use-recommended-route")
                    }.padding(22).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: .rect(cornerRadius: 22))
                } else {
                    ForEach(Array(journal.planned.enumerated()), id: \.element.id) { index, destination in
                        HStack(alignment: .center, spacing: 12) {
                            Text(String(format: "%02d", index + 1))
                                .font(.system(size: 17, weight: .regular, design: .monospaced))
                                .foregroundStyle(Palette.muted).frame(width: 30)
                            NavigationLink(value: destination) { DestinationRow(destination: destination) }
                                .buttonStyle(.plain)
                            if editing {
                                VStack(spacing: 16) {
                                    if index > 0 {
                                        Button { journal.route.swapAt(index, index - 1) } label: { Image(systemName: "arrow.up") }
                                            .accessibilityLabel("將\(destination.name)上移")
                                    }
                                    Button(role: .destructive) { withAnimation { journal.toggleRoute(destination) } } label: { Image(systemName: "minus.circle.fill") }
                                        .accessibilityLabel("移除\(destination.name)")
                                }.frame(width: 30)
                            }
                        }
                    }
                }
                Button { showsGuide = true } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "text.book.closed").font(.title2)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("出發前的冰島手冊").font(.system(size: 16, weight: .semibold))
                            Text("季節、穿搭與旅行提醒").font(.caption).foregroundStyle(Palette.muted)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }.padding(20).background(Palette.lime.opacity(0.4), in: .rect(cornerRadius: 20))
                }.buttonStyle(.plain)
                Text("推薦路線為旅行靈感，並非即時導航。請依天候、路況與住宿位置安排每日行程。")
                    .font(.caption).lineSpacing(5).foregroundStyle(Palette.muted)
            }.padding(24)
        }
        .background(Palette.paper).foregroundStyle(Palette.ink)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Destination.self) { DestinationDetail(destination: $0) }
        .sheet(isPresented: $showsGuide) { FieldGuideView() }
    }
}
