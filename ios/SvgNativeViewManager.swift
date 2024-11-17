import UIKit
import SVGKit

@objc(SvgNativeViewManager)
class SvgNativeViewManager: RCTViewManager {

    override func view() -> (SvgNativeView) {
        return SvgNativeView()
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
}

class SvgNativeView: UIView {

    private var svgImageView: SVGKFastImageView?

    @objc var uri: String = "" {
        didSet {
            loadSvg()
        }
    }

    @objc var defaultSize: CGSize = CGSize(width: 100, height: 100)

    @objc var cacheTime: TimeInterval = 0 {
        didSet {
            loadSvg()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        svgImageView = SVGKFastImageView(svgkImage: nil)
        if let svgImageView = svgImageView {
            svgImageView.contentMode = .scaleAspectFit
            svgImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(svgImageView)

            NSLayoutConstraint.activate([
                svgImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                svgImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                svgImageView.topAnchor.constraint(equalTo: topAnchor),
                svgImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    private func loadSvg() {
        guard let url = URL(string: uri) else {
            return
        }

        // Adjust the cache expiration based on the passed cacheTime
        if let cachedSVG = SvgCacheManager.shared.getSVG(forKey: uri, cacheTime: cacheTime) {
            updateImageView(with: cachedSVG)
            return
        }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let svgImage = SVGKImage(data: data) {
                    DispatchQueue.main.async {
                        // Check if the SVG has no internal size or a viewBox
                        if svgImage.size == .zero {
                            if let svgDocument = svgImage.domDocument, svgDocument.documentElement?.getAttribute("viewBox") == nil {
                                // Apply default size if no viewBox found
                                svgImage.size = self.defaultSize
                            }
                        }
                        
                        // Now svgImage should have a valid size (either from the SVG or default size)
                        SvgCacheManager.shared.saveSVG(svgImage, forKey: self.uri, cacheTime: self.cacheTime)
                        self.updateImageView(with: svgImage)
                    }
                } else {
                    print("Failed to parse SVG data.")
                }
            } catch {
                print("Error loading SVG: \(error)")
            }
        }
    }

    private func updateImageView(with svgImage: SVGKImage) {
        svgImageView?.image = svgImage
        svgImageView?.frame = CGRect(origin: .zero, size: svgImage.size)
    }
}
