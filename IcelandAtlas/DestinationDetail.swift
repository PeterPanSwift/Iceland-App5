import SwiftUI
import MapKit

struct DestinationDetail: View {
    @Environment(TravelJournal.self) private var journal
    @Environment(\.dismiss) private var dismiss
    let destination: Destination

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Landscape(name: destination.id)
                    LinearGradient(colors: [.clear, Palette.ink.opacity(0.8)], startPoint: .center, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 10) {
                        Eyebrow(text: destination.region.uppercased()).foregroundStyle(Palette.lime)
                        Text(destination.localName).font(.system(size: 41, weight: .regular, design: .serif)).minimumScaleFactor(0.7).lineLimit(1)
                        Text(destination.name).font(.system(size: 23, weight: .medium))
                    }.foregroundStyle(.white).padding(26).padding(.bottom, 8)
                }
                .frame(height: 450)
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 0) {
                        fact("clock", label: "建議停留", value: destination.duration)
                        Spacer()
                        Rectangle().fill(Palette.muted.opacity(0.2)).frame(width: 1, height: 40)
                        Spacer()
                        fact("sun.max", label: "旅行季節", value: destination.season)
                    }
                    .padding(20).background(.white, in: .rect(cornerRadius: 20))
                    VStack(alignment: .leading, spacing: 15) {
                        Text(destination.subtitle).font(.system(size: 23, weight: .semibold)).fixedSize(horizontal: false, vertical: true)
                        Text(destination.story).font(.system(size: 16)).lineSpacing(8).foregroundStyle(Palette.muted)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Label("出發前的小提醒", systemImage: "leaf").font(.system(size: 16, weight: .semibold))
                        Text(destination.tip).font(.system(size: 14)).lineSpacing(6)
                    }
                    .padding(20).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Palette.lime.opacity(0.4), in: .rect(cornerRadius: 20))
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Eyebrow(text: "ON THE MAP")
                            Text(String(format: "%.3f° N  ·  %.3f° W", destination.latitude, -destination.longitude))
                                .font(.system(size: 12, design: .monospaced))
                        }
                        Spacer()
                        Link(destination: URL(string: "https://maps.apple.com/?ll=\(destination.latitude),\(destination.longitude)&q=\(destination.localName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Iceland")")!) {
                            Label("查看地圖", systemImage: "arrow.up.right").font(.system(size: 13, weight: .semibold))
                        }
                    }
                    Link("攝影 \(destination.photographer) / Unsplash ↗", destination: URL(string: "https://unsplash.com/photos/\(destination.photoID)")!)
                        .font(.caption).foregroundStyle(Palette.muted)
                }.padding(24)
            }
        }
        .background(Palette.paper).ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .top) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 18, weight: .medium))
                        .frame(width: 46, height: 46).background(.regularMaterial, in: Circle())
                }
                .accessibilityLabel("返回探索").accessibilityIdentifier("detail-back")
                Spacer()
                SaveButton(destination: destination)
            }.padding(.horizontal, 24).padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                withAnimation(.snappy) { journal.toggleRoute(destination) }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: journal.route.contains(destination.id) ? "checkmark" : "plus")
                    Text(journal.route.contains(destination.id) ? "已加入行程 · 點按移除" : "加入我的行程")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white).frame(maxWidth: .infinity).padding(18)
                .background(Palette.ink, in: Capsule())
            }
            .accessibilityIdentifier("route-\(destination.id)")
            .padding(.horizontal, 24).padding(.vertical, 12).background(.regularMaterial)
        }
        .foregroundStyle(Palette.ink)
    }

    private func fact(_ icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 21, weight: .light))
            VStack(alignment: .leading, spacing: 6) {
                Text(label).font(.system(size: 11)).foregroundStyle(Palette.muted)
                Text(value).font(.system(size: 14, weight: .semibold))
            }
        }
    }
}
