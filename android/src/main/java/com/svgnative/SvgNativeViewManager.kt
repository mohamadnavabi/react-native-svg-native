package com.svgnative

import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class SvgNativeViewManager : SimpleViewManager<SvgImageView>() {

    override fun getName() = "SvgNativeView"

    override fun createViewInstance(reactContext: ThemedReactContext): SvgImageView {
        return SvgImageView(reactContext)
    }

    @ReactProp(name = "uri")
    fun setUri(view: SvgImageView, uri: String?) {
        if (uri != null) {
            view.setSvgUri(uri)
        }
    }

    @ReactProp(name = "cacheTime")
    fun setCacheTime(view: SvgImageView, cacheTime: Int) {
        view.cacheTime = cacheTime.toLong()
    }
}
