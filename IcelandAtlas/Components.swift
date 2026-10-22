import SwiftUI

struct Landscape: View {
    let name: String
    var body: some View {
        GeometryReader { geometry in
            Image(name).resizable().scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .accessibilityHidden(true)
    }
}

struct Eyebrow: View {
    let text: String
    var body: some View {
        Text(text).font(.system(size: 11, weight: .semibold, design: .monospaced))
            .tracking(2.5)
    }
}

struct SaveButton: View {
    @Environment(TravelJournal.self) private var journal
    let destination: Destination
    var body: some View {
        Button {
            withAnimation(.snappy) { journal.toggleSaved(destination) }
        } label: {
            Image(systemName: journal.saved.contains(destination.id) ? "heart.fill" : "heart")
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(Palette.ink)
                .frame(width: 46, height: 46)
                .background(.regularMaterial, in: Circle())
        }
        .accessibilityLabel(journal.saved.contains(destination.id) ? "取消收藏" : "收藏景點")
        .accessibilityIdentifier("save-\(destination.id)")
    }
}

struct DestinationRow: View {
    let destination: Destination
    var body: some View {
        HStack(spacing: 16) {
            Landscape(name: destination.id).frame(width: 88, height: 96).clipShape(.rect(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 7) {
                Text(destination.region).font(.caption).foregroundStyle(Palette.muted)
                Text(destination.name).font(.system(size: 18, weight: .semibold)).foregroundStyle(Palette.ink)
                Text(destination.localName).font(.system(size: 12, design: .serif)).foregroundStyle(Palette.muted)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.up.right").font(.system(size: 15)).foregroundStyle(Palette.ink)
        }
        .padding(12).background(.white, in: .rect(cornerRadius: 22))
    }
}
