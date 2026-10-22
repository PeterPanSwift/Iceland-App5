import SwiftUI

@main
struct IcelandAtlasApp: App {
    @State private var journal = TravelJournal()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(journal)
                .tint(Palette.ink)
                .preferredColorScheme(.light)
        }
    }
}

enum Palette {
    static let ink = Color(red: 0.07, green: 0.20, blue: 0.22)
    static let paper = Color(red: 0.96, green: 0.97, blue: 0.94)
    static let lime = Color(red: 0.85, green: 0.92, blue: 0.64)
    static let muted = Color(red: 0.39, green: 0.46, blue: 0.45)
}

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { ExploreView() }
                .tabItem { Label("探索", systemImage: "safari") }
            NavigationStack { JourneyView() }
                .tabItem { Label("行程", systemImage: "point.topleft.down.to.point.bottomright.curvepath") }
            NavigationStack { SavedView() }
                .tabItem { Label("收藏", systemImage: "heart") }
        }
    }
}
