package com.svgnative

import android.content.Context
import android.graphics.drawable.PictureDrawable
import android.os.Handler
import android.os.Looper
import androidx.appcompat.widget.AppCompatImageView
import com.caverock.androidsvg.SVG
import java.net.URL
import java.util.concurrent.Executors

class SvgImageView(context: Context) : AppCompatImageView(context) {

  private val executor = Executors.newSingleThreadExecutor()
  private val handler = Handler(Looper.getMainLooper())

  var cacheTime: Long = 0
  private val svgCache = mutableMapOf<String, Pair<Long, PictureDrawable>>()

  fun setSvgUri(uri: String) {
    val currentTime = System.currentTimeMillis()

    if (svgCache.containsKey(uri)) {
      val (timestamp, drawable) = svgCache[uri]!!
      if (currentTime - timestamp < cacheTime) {
        setImageDrawable(drawable)
        return
      }
    }

    executor.execute {
      try {
        val svg = SVG.getFromInputStream(URL(uri).openStream())
        val picture = svg.renderToPicture()
        val drawable = PictureDrawable(picture)
        svgCache[uri] = currentTime to drawable
        handler.post { setImageDrawable(drawable) }
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
  }
}
