import SwiftUI

struct ExploreView: View {
    @State private var category = "全部"
    @State private var query = ""
    @State private var showsGuide = false
    private let categories = ["全部", "瀑布", "冰川", "山巒", "海岸"]

    private var filtered: [Destination] {
        Destination.all.filter {
            (category == "全部" || $0.category == category) &&
            (query.isEmpty || "\($0.name) \($0.localName) \($0.region)".localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                hero
                VStack(alignment: .leading, spacing: 22) {
                    HStack(alignment: .lastTextBaseline) {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: "FIND YOUR WONDER").foregroundStyle(Palette.muted)
                            Text("下一站，心之所向").font(.system(size: 26, weight: .bold))
                        }
                        Spacer()
                        Text("04 處風景").font(.caption).foregroundStyle(Palette.muted)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { item in
                                Button { withAnimation { category = item } } label: {
                                    Text(item).font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 22).padding(.vertical, 12)
                                        .background(category == item ? Palette.ink : .white, in: Capsule())
                                        .foregroundStyle(category == item ? .white : Palette.ink)
                                }
                                .accessibilityIdentifier("category-\(item)")
                                .accessibilityAddTraits(category == item ? .isSelected : [])
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                        TextField("搜尋景點或地區", text: $query)
                            .accessibilityIdentifier("destination-search")
                        if !query.isEmpty {
                            Button { query = "" } label: { Image(systemName: "xmark.circle.fill") }
                                .accessibilityLabel("清除搜尋")
                        }
                    }
                    .font(.system(size: 15)).foregroundStyle(Palette.muted)
                    .padding(16).background(.white, in: .rect(cornerRadius: 16))
                    if filtered.isEmpty {
                        ContentUnavailableView.search(text: query)
                    } else {
                        ForEach(filtered) { destination in
                            NavigationLink(value: destination) {
                                DestinationRow(destination: destination)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("destination-\(destination.id)")
                        }
                    }
                    HStack(spacing: 14) {
                        Image(systemName: "sparkles").font(.title2)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("留一點空白，給意料之外。").font(.system(size: 15, weight: .medium))
                            Text("冰島的美，值得慢慢走。 ").font(.caption).foregroundStyle(Palette.muted)
                        }
                    }.padding(.vertical, 12)
                }
                .foregroundStyle(Palette.ink).padding(24)
            }
        }
        .background(Palette.paper)
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Destination.self) { DestinationDetail(destination: $0) }
        .sheet(isPresented: $showsGuide) { FieldGuideView() }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Landscape(name: "kirkjufell")
            LinearGradient(colors: [.black.opacity(0.22), .clear, Palette.ink.opacity(0.92)], startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack(spacing: 9) {
                        Image(systemName: "mountain.2").font(.system(size: 25, weight: .light))
                        Text("ÍSLAND").font(.system(size: 22, weight: .medium, design: .serif)).tracking(4)
                    }
                    Spacer()
                    Button { showsGuide = true } label: {
                        Image(systemName: "text.book.closed").font(.system(size: 19))
                            .frame(width: 44, height: 44).background(.white.opacity(0.16), in: Circle())
                    }
                    .accessibilityLabel("冰島旅行手冊")
                }
                Spacer()
                Eyebrow(text: "A LITTLE CLOSER TO THE WILD")
                    .foregroundStyle(Palette.lime).padding(.bottom, 16)
                Text("在世界盡頭\n遇見心動。")
                    .font(.system(size: 43, weight: .semibold)).lineSpacing(5)
                    .padding(.bottom, 14)
                Text("冰川、瀑布、黑沙岸。\n把日常留在身後，向冰島出發。")
                    .font(.system(size: 15)).lineSpacing(5).foregroundStyle(.white.opacity(0.85))
                    .padding(.bottom, 24)
                HStack {
                    Text("64°08′ N  21°56′ W")
                        .font(.system(size: 10, weight: .medium, design: .monospaced)).tracking(1.3)
                    Spacer()
                    NavigationLink(value: Destination.all[0]) {
                        HStack(spacing: 10) {
                            Text("探索教會山").font(.system(size: 13, weight: .semibold))
                            Image(systemName: "arrow.up.right")
                        }
                        .padding(.horizontal, 18).padding(.vertical, 14)
                        .background(Palette.lime, in: Capsule()).foregroundStyle(Palette.ink)
                    }
                    .accessibilityIdentifier("hero-explore")
                }
            }
            .foregroundStyle(.white).padding(.horizontal, 26).padding(.top, 68).padding(.bottom, 30)
        }
        .frame(height: 550)
    }
}
