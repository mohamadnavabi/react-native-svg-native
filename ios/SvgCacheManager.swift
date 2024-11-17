import SVGKit

class SvgCacheManager {
    static let shared = SvgCacheManager()

    private var cache: NSCache<NSString, CachedSVG>

    private init() {
        self.cache = NSCache<NSString, CachedSVG>()
    }

    // Pass the cacheTime in milliseconds
    func getSVG(forKey key: String, cacheTime: TimeInterval) -> SVGKImage? {
        guard let cachedSVG = cache.object(forKey: key as NSString),
              Date().timeIntervalSince(cachedSVG.timestamp) < cacheTime / 1000 else { // Convert milliseconds to seconds
            return nil
        }
        return cachedSVG.svgImage
    }

    func saveSVG(_ svgImage: SVGKImage, forKey key: String, cacheTime: TimeInterval) {
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
