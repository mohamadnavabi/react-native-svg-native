import UIKit
import SDWebImage
import SDWebImageSVGCoder

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

        if cacheTime == 0 {
            cache.removeImage(forKey: cacheKey, fromDisk: true, withCompletion: nil)
        }

        if let cachedImage = cache.imageFromCache(forKey: cacheKey) {
            imageView?.image = cachedImage
            return
        } else {
            print("No cached image found for key: \(cacheKey)")
        }

        let placeholder = UIImage(systemName: "photo")

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load SVG image: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No image data found.")
                return
            }

            if let svgString = String(data: data, encoding: .utf8) {
                if let base64Image = self.extractBase64Image(from: svgString) {
                    if let imageData = Data(base64Encoded: base64Image, options: .ignoreUnknownCharacters),
                       let decodedImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.imageView?.image = decodedImage
                            cache.store(decodedImage, forKey: cacheKey, toDisk: true, completion: nil)
                        }
                    }
                } else {
                    if let svgImage = SDImageSVGCoder.shared.decodedImage(with: data, options: nil) {
                        DispatchQueue.main.async {
                            self.imageView?.image = svgImage
                            cache.store(svgImage, forKey: cacheKey, toDisk: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.imageView?.image = placeholder
                        }
                    }
                }
            }
        }.resume()
    }

    private func extractBase64Image(from svgString: String) -> String? {
        let pattern = #"<image[^>]*xlink:href=\"data:image/[^;]+;base64,([^"]+)\"[^>]*>"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsRange = NSRange(svgString.startIndex..<svgString.endIndex, in: svgString)

        if let match = regex?.firstMatch(in: svgString, options: [], range: nsRange) {
            let base64Range = match.range(at: 1)
            if let base64StringRange = Range(base64Range, in: svgString) {
                return String(svgString[base64StringRange])
            }
        }
        return nil
    }
}
