import Foundation
import Observation

struct Destination: Identifiable, Hashable {
    let id: String
    let name: String
    let localName: String
    let region: String
    let category: String
    let subtitle: String
    let story: String
    let duration: String
    let season: String
    let tip: String
    let latitude: Double
    let longitude: Double
    let photographer: String
    let photoID: String

    static let all: [Destination] = [
        .init(id: "kirkjufell", name: "教會山", localName: "Kirkjufell", region: "斯奈山半島", category: "山巒", subtitle: "一座山，收藏冰島所有的想像。", story: "如教堂尖塔般的山峰，靜靜立在格倫達菲厄澤小鎮旁。沿著教會山瀑布的步道散步，水流、草地與山形在眼前交織成冰島最經典的風景。\n\n不必攀上山頂，從瀑布旁的觀景步道，就能感受這座山令人屏息的輪廓。", duration: "1–2 小時", season: "四季皆宜", tip: "沿標示步道欣賞山形。山頂路線陡峭，請勿將一般觀景散步當作登頂行程。", latitude: 64.927, longitude: -23.307, photographer: "Frugal Flyer", photoID: "AsMSF6fkIaA"),
        .init(id: "skogafoss", name: "斯科加瀑布", localName: "Skógafoss", region: "冰島南岸", category: "瀑布", subtitle: "走進水霧，遇見自己的彩虹。", story: "斯科加瀑布從約 60 公尺高的斷崖直落，水聲在寬闊的河谷迴盪。陽光穿過水霧時，彩虹常在瀑布前悄悄出現。\n\n在步道上慢慢靠近，感受冰島南岸最直接的生命力；也可以沿階梯前往上方觀景台，換個角度看河流奔向遠方。", duration: "1–2 小時", season: "四季皆宜", tip: "帶上防水外套與防滑鞋。瀑布旁水霧濃，冬季步道可能結冰，請遵守現場封閉標示。", latitude: 63.532, longitude: -19.511, photographer: "Katarzyna Gonsior", photoID: "YQ2v5Sx6ZMk"),
        .init(id: "lagoon", name: "傑古沙龍冰河湖", localName: "Jökulsárlón", region: "瓦特納冰川地區", category: "冰川", subtitle: "讓千年的冰，替時間留白。", story: "冰川崩解的浮冰，在冰河湖中緩緩漂移。藍、白與火山灰的紋理，記錄著冰層走過的歲月。留一點時間在岸邊，看光影穿透冰塊，也留意水中探頭的海豹。\n\n鄰近的鑽石沙灘，偶爾可見被海浪推回岸邊的透明冰塊，映著黑色沙粒，像散落的微光。", duration: "2–3 小時", season: "四季皆宜", tip: "留在岸邊，勿踏上浮冰。若想搭船或走訪冰洞，請預約合格業者並確認當日營運狀況。", latitude: 64.048, longitude: -16.179, photographer: "Cai Photography", photoID: "_BFAOAzwc-s"),
        .init(id: "beach", name: "雷尼斯黑沙灘", localName: "Reynisfjara", region: "維克小鎮附近", category: "海岸", subtitle: "黑色沙岸，與北大西洋的低語。", story: "火山岩化作黑色沙粒，玄武岩柱沿著崖壁排列，遠方的雷尼斯岩柱從海中升起。這裡的風景有一種原始而安靜的力量。\n\n在安全開放的區域觀景，聽浪聲、看海鳥，讓冰島的海岸留在記憶裡。沙岸會隨季節與海況改變。", duration: "約 1 小時", season: "依海況開放", tip: "此處有危險的突襲浪。遠離水線、勿背對海洋，遵循現場警示燈與封閉規定，不進入海水。", latitude: 63.404, longitude: -19.045, photographer: "With Paul", photoID: "IT6MIkeDr3o")
    ]
}

@MainActor @Observable
final class TravelJournal {
    var saved: Set<String> { didSet { UserDefaults.standard.set(Array(saved), forKey: "saved") } }
    var route: [String] { didSet { UserDefaults.standard.set(route, forKey: "route") } }

    init() {
        saved = Set(UserDefaults.standard.stringArray(forKey: "saved") ?? [])
        route = UserDefaults.standard.stringArray(forKey: "route") ?? []
        if ProcessInfo.processInfo.arguments.contains("--reset-journal") {
            saved = []
            route = []
        }
    }

    func toggleSaved(_ destination: Destination) {
        if saved.contains(destination.id) { saved.remove(destination.id) }
        else { saved.insert(destination.id) }
    }

    func toggleRoute(_ destination: Destination) {
        if route.contains(destination.id) { route.removeAll { $0 == destination.id } }
        else { route.append(destination.id) }
    }

    var planned: [Destination] { route.compactMap { id in Destination.all.first { $0.id == id } } }
}
