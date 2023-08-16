package com.mapspeople.mapsindoors

import java.lang.reflect.Type

import android.content.Context
import android.graphics.Typeface

import com.google.gson.reflect.TypeToken
import com.mapbox.maps.CameraOptions

import com.mapbox.maps.CameraState
import com.mapbox.maps.CoordinateBounds
import com.mapbox.maps.EdgeInsets
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapsindoors.core.MPFloorSelectorInterface
import com.mapsindoors.core.MPPoint
import com.mapsindoors.mapbox.MPMapConfig
import com.mapsindoors.mapbox.converters.toPoint
import com.mapspeople.mapsindoors.core.models.*
import com.mapspeople.mapsindoors.core.models.CameraUpdateMode.*




inline fun <reified T> type(): Type = object: TypeToken<T>() {}.type

fun CameraState.toCameraPosition() : CameraPosition {
    return CameraPosition(
        zoom = zoom.toFloat(),
        tilt = pitch.toFloat(),
        bearing = bearing.toFloat(),
        target = MPPoint(center.latitude(), center.longitude())
    )
}

fun CameraPosition.toCameraState() : CameraState {
    return CameraState(
        target!!.latLng.toPoint(),
        EdgeInsets(0.0,0.0,0.0,0.0),
        zoom!!.toDouble(),
        bearing!!.toDouble(),
        tilt!!.toDouble()
    )
}


fun CameraUpdate.toCameraOptions(map: MapboxMap) : CameraOptions = when (mode) {
    FROMPOINT -> CameraOptions.Builder().center(point?.latLng?.toPoint()).build()

    FROMBOUNDS -> if (width != null && height != null) {
        bounds!!.let {
            val coordinateBounds = CoordinateBounds(it.southWest.latLng.toPoint(), it.northEast.latLng.toPoint())
            map.cameraForCoordinateBounds(coordinateBounds, EdgeInsets(height.toDouble(), width.toDouble(), height.toDouble(), width.toDouble()))
        }
    } else {
        bounds!!.let {
            val coordinateBounds = CoordinateBounds(it.southWest.latLng.toPoint(), it.northEast.latLng.toPoint())
            val doublePadding = padding!!.toDouble()
            map.cameraForCoordinateBounds(coordinateBounds, EdgeInsets(doublePadding, doublePadding, doublePadding, doublePadding))
        }
    }

    ZOOMBY -> CameraOptions.Builder().zoom(map.cameraState.zoom + zoom!!).build()

    ZOOMTO -> CameraOptions.Builder().zoom(zoom!!.toDouble()).build()

    FROMCAMERAPOSITION -> {
        position!!.let {
            CameraOptions.Builder().center(it.target!!.latLng.toPoint()).zoom(it.zoom!!.toDouble() - 1).bearing(it.bearing!!.toDouble()).pitch(it.tilt!!.toDouble()).build()
        }
    }

}


fun MapConfig.makeMPMapConfig(context: Context, map: MapboxMap, mapView: MapView, apiKey: String, floorSelector: MPFloorSelectorInterface?) : MPMapConfig {
    val builder = MPMapConfig.Builder(context, map, mapView, apiKey, useDefaultMapsIndoorsStyle)

    typeface?.let {
        val tf = Typeface.create(it, Typeface.NORMAL)
        builder.setMapLabelFont(tf, color!!, showHalo!!)
    }
    showFloorSelector?.let {
        builder.setShowFloorSelector(it)
    }
    textSize?.let {
        builder.setMapLabelTextSize(it.toInt())
    }
    showInfoWindowOnLocationClicked?.let {
        builder.setShowInfoWindowOnLocationClicked(it)
    }
    showUserPosition?.let {
        builder.setShowUserPosition(it)
    }
    tileFadeInEnabled?.let {
        builder.setTileFadeInEnabled(it)
    }
    floorSelector?.let {
        builder.setFloorSelector(it)
    }
    return builder.build()
}