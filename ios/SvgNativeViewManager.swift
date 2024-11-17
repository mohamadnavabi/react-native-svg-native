import UIKit
import SDWebImage
import SDWebImageSVGCoder

@objc(SvgNativeViewManager)
class SvgNativeViewManager: RCTViewManager {

    override init() {
        super.init()

        let svgCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)
    }

    override func view() -> SvgNativeView {
        return SvgNativeView()
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

@objc(SvgNativeView)
class SvgNativeView: UIView {

    private var imageView: UIImageView?

    @objc var cacheTime: Double = 0
    @objc var uri: String = "" {
        didSet {
            loadSvg()
        }
    }

    @objc var defaultSize: CGSize = CGSize(width: 100, height: 100)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView!)

        NSLayoutConstraint.activate([
            imageView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView!.topAnchor.constraint(equalTo: topAnchor),
            imageView!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func loadSvg() {
        guard let url = URL(string: uri) else {
            print("Invalid URL: \(uri)")
            return
        }

        let cacheKey = uri
        let cache = SDImageCache.shared

        if let cachedImage = cache.imageFromCache(forKey: cacheKey) {
            imageView?.image = cachedImage
            return
        }

        let placeholder = UIImage(systemName: "photo")

        imageView?.sd_setImage(with: url, placeholderImage: placeholder, options: [.retryFailed]) { [weak self] image, error, _, _ in
            if let error = error {
                print("Failed to load SVG image: \(error.localizedDescription)")
            } else if let image = image {
                cache.store(image, forKey: cacheKey, toDisk: true, completion: nil)
            } else {
                print("No image loaded.")
            }
        }
    }
}
