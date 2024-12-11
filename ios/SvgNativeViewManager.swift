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
