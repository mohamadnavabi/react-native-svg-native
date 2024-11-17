import SDWebImage

class SvgCacheManager {
    static let shared = SvgCacheManager()

    private var cache: NSCache<NSString, CachedSVG>

    private init() {
        self.cache = NSCache<NSString, CachedSVG>()
    }

    func getSVG(forKey key: String, cacheTime: TimeInterval) -> UIImage? {
        guard let cachedSVG = cache.object(forKey: key as NSString),
            Date().timeIntervalSince(cachedSVG.timestamp) < cacheTime / 1000 else {
            print("Cache expired or not found for key: \(key)")
            return nil
        }
        print("Returning cached SVG for key: \(key)")
        return cachedSVG.svgImage
    }

    func saveSVG(_ svgImage: UIImage, forKey key: String, cacheTime: TimeInterval) {
        let cachedSVG = CachedSVG(svgImage: svgImage, timestamp: Date())
        cache.setObject(cachedSVG, forKey: key as NSString)
        print("Saved SVG to cache with key: \(key)")
    }
}

class CachedSVG {
    let svgImage: UIImage
    let timestamp: Date

    init(svgImage: UIImage, timestamp: Date) {
        self.svgImage = svgImage
        self.timestamp = timestamp
    }
}
