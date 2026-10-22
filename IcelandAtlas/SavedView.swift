import SwiftUI

struct SavedView: View {
    @Environment(TravelJournal.self) private var journal
    private var destinations: [Destination] { Destination.all.filter { journal.saved.contains($0.id) } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Eyebrow(text: "PLACES CLOSE TO YOUR HEART").foregroundStyle(Palette.muted)
                HStack {
                    Text("收藏的風景").font(.system(size: 32, weight: .bold))
                    Spacer()
                    Text(String(format: "%02d", destinations.count))
                        .font(.system(size: 30, weight: .light, design: .serif)).foregroundStyle(Palette.muted)
                }
                Text("先把心動留住，總有一天會抵達。")
                    .font(.system(size: 15)).foregroundStyle(Palette.muted)
                if destinations.isEmpty {
                    ContentUnavailableView {
                        Label("你的風景收藏冊", systemImage: "heart")
                    } description: {
                        Text("在景點頁點一下愛心，\n將想念的冰島放進口袋。")
                    }.padding(.top, 100)
                } else {
                    ForEach(destinations) { destination in
                        NavigationLink(value: destination) {
                            ZStack(alignment: .bottomLeading) {
                                Landscape(name: destination.id)
                                LinearGradient(colors: [.clear, Palette.ink.opacity(0.85)], startPoint: .center, endPoint: .bottom)
                                VStack(alignment: .leading, spacing: 8) {
                                    Eyebrow(text: destination.localName.uppercased()).foregroundStyle(Palette.lime)
                                    Text(destination.name).font(.system(size: 25, weight: .semibold))
                                }.foregroundStyle(.white).padding(24)
                            }
                            .frame(height: 285).clipShape(.rect(cornerRadius: 24))
                        }
                        .buttonStyle(.plain)
                        .overlay(alignment: .topTrailing) { SaveButton(destination: destination).padding(16) }
                    }
                }
            }.padding(24)
        }
        .background(Palette.paper).foregroundStyle(Palette.ink)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Destination.self) { DestinationDetail(destination: $0) }
    }
}
