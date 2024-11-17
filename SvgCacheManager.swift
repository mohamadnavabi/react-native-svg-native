import SVGKit

class SvgCacheManager {
    static let shared = SvgCacheManager()

    private var cache: NSCache<NSString, CachedSVG>
    private let expirationTime: TimeInterval = 3600 // 1 hour in seconds

    private init() {
        self.cache = NSCache<NSString, CachedSVG>()
    }

    func getSVG(forKey key: String) -> SVGKImage? {
        guard let cachedSVG = cache.object(forKey: key as NSString),
              Date().timeIntervalSince(cachedSVG.timestamp) < expirationTime else {
            // Cache expired or not available
            return nil
        }
        return cachedSVG.svgImage
    }

    func saveSVG(_ svgImage: SVGKImage, forKey key: String) {
        let cachedSVG = CachedSVG(svgImage: svgImage, timestamp: Date())
        cache.setObject(cachedSVG, forKey: key as NSString)
    }
}

class CachedSVG {
    let svgImage: SVGKImage
    let timestamp: Date

    init(svgImage: SVGKImage, timestamp: Date) {
        self.svgImage = svgImage
        self.timestamp = timestamp
    }
}
