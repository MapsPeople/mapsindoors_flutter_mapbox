# Changelog

## 4.0.0

See the [migration guide](https://docs.mapsindoors.com/sdks-and-frameworks/flutter/migration-guide).

### Added

* Added `initialCameraPosition: MPCameraPosition` to the `MapWidget` constructor. If set, the initial position of the camera will be moved to the given `MPCameraPosition`.

### Changed

* Changed all uses of color `Strings` to use `dart:ui` `Color` instead.
* Updated Mapsindoors SDKs:
  * Android to 4.9.0
  * iOS to 4.7.0

### Removed

 * `DirectionsService` `ClearWayType` has been removed, use `ClearAvoidWayType` instead.

## 3.1.3

### Fixed

* Fixed custom floorselectors not working properly on iOS

### Changed

* Updated Mapsindoors SDKs:
  * Android to 4.8.12
  * iOS to 4.6.2

## 3.1.2

### Fixed

* Fixed issue where camera events would not be propagated to the Flutter layer on iOS
* Fixed behavior where iOS would throw an error when `getLocationById` could not find a location, it now returns null like on Android
* Fixed `setCollisionHandling` on `MPSolutionConfig` causing a crash
* Fixed `moveCamera`/`AnimateCamera` from a `MPCameraPosition` would not work on iOS

### Changed

* Updated Mapsindoors SDKs:
  * Android to 4.8.11

## 3.1.1

### Fixed

* Fixed issue where camera events would not be propagated to the Flutter layer
* Fixed issue on iOS where setting a floor selector
* Fixed issue on Android where goTo MPLocation did not function properly
* Fixed tilt not being applied when moving the camera using a MPCameraUpdate on iOS
* Fixed blank screen on Android when not using MapsindoorsStyle

### Changed

* Updated Mapsindoors SDKs:
  * iOS to 4.6.1

## 3.1.0

### Added

* Added functionality for Android to update the map whenever a Display Rule is changed
* Added method on MapsIndoorsWidget to disable built-in compass

### Changed

* Disabled Mapbox Attributions button on Android as it would crash when clicked
* Updated Mapsindoors SDKs:
  * Android to 4.8.9
  * iOS to 4.5.14

## 3.0.2

### Fixed

* Fixed issues where updating display rules would not trigger a refresh on iOS

### Changed

* Updated Mapsindoors SDKs:
  * Android to 4.8.8
  * iOS to 4.5.12

## 3.0.1

* No changes

## 3.0.0

### Added

* Added `setHighlight` and `clearHighlight` to `MapControlWidget` which allows you to highlight a list of locations
* Added new `MPCameraViewFitMode`: `none`, which will disable automatic camera movement when changing legs
* Added `addExcludeWayType`, `clearExcludeWayType` to `MPDirectionsService` to allow the user to exclude specific `MPHighway`s when querying for a route.
* Added two new `MPSolutionDisplayRuleEnum`s `selection` and `highlight` that allows you to modify the look of highlighted and selected Locations.
* Added support for Flat and Graphic labels, as well as 3D models
* Added new setters and getters to `MPDisplayRule`:
  * `LabelStyleGraphic`
  * `LabelType`
  * `IconScale`
  * `IconPlacement`
  * `PolygonLightnessFactor`
  * `WallLightnessFactor`
  * `ExtrusionLightnessFactor`
  * `LabelStyleTextSize`
  * `LabelStyleTextColor`
  * `LabelStyleTextOpacity`
  * `LabelStyleHaloOpacity`
  * `LabelStyleHaloWidth`
  * `LabelStyleHaloBlur`
  * `LabelStyleBearing`
  * `BadgeVisibile`
  * `BadgeZoomFrom`
  * `BadgeZoomTo`
  * `BadgeRadius`
  * `BadgeStrokeWidth`
  * `BadgeStrokeColor`
  * `BadgeFillColor`
  * `BadgePosition`
  * `Model3DModel`
  * `Model3DRotationX`
  * `Model3DRotationY`
  * `Model3DrotationZ`
  * `Model3DScale`
  * `Model3DZoomFrom`
  * `Model3DZoomTo`
  * `Model3DVisible`
* Added functionality to hide specific features from the map
  * `setHiddenFeatures` set a list of `MPFeatureType` to be hidden from the map
  * `getHiddenFeatures` get a list of currently hidden `MPFeatureType`
* Added optional venue loading, use loadMapsIndoorsWithVenues(key, venueIds) to load a specific set of venues
  * Venues can be added and removed from load at any time by using `addVenueToSync(venueId)` and `removeVenueToSync(venueId)`
  * Track the status of venues by adding a listener with `addOnVenueStatusChangedListener(MPVenueStatusListener)`
  * Get a list of synced venues with `getSyncedVenues()`
* Added functionality to disable automatic floor and building selection when moving the map
  * `setBuildingSelectionMode` set a Selection mode for Buildings on the map with `MPSelectionMode` (`automatic` or `manual`)
  * `setFloorSelectionMode` set a Selection mode for Floors on the map with `MPSelectionMode` (`automatic` or `manual`)
* Added functionality to make locations `selectable`.
  * This setting can be found on `MPLoction`, `MPPOIType` and `MPSolutionConfig`
  * Added `MPPOIType` which can be fetched from `MPSolution`
* Added `mapsIndoorsTransitionLevel` to MapsIndoorsWidget ctor
  * Sets the zoom level at which the MapsIndoors data should show, instead of extruded buildings on Mapbox Maps. Can be set to 0, if extruded buildings should not show.
* Added multi-stop navigation: It is now possible to add multiple stops to routes.
  * The existing `getRoute` method gets two optional parameters `stops` and `optimize`
  * `stops` will add the stops to the route between the `origin` and `destination`
  * `optimize` will rearrange the `stops` to make a more optimal route, but `origin` and `destination` will stay the same.
* Updated Mapsindoors SDKs:
  * Android to 4.8.5
  * iOS to 4.5.7

### Deprecated

* Deprecated `clearWayType`: use `clearAvoidWayType` instead

## 2.1.6

* Updated to Mapsindoors iOS SDK 4.3.11 with proper Privacy Manifests

## 2.1.5

* Updated Mapsindoors SDKs
  * Android to 4.4.1
  * iOS to 4.3.8

## 2.1.4

* Fixed issue with not being able to always get a correct route involving one way paths.

## 2.1.3

* Fixed issue with `MapsIndoorsWidget.readyListener` not being called on very initial load of MapsIndoors.

## 2.1.2

* Updated Mapsindoors SDKs
  * Android to 4.2.12
  * iOS to 4.2.14

## 2.1.1

* Fixed issue where `OnMapReadyListener` would not be invoked during the initial load on iOS.

## 2.1.0

* Updated Mapsindoors SDKs
  * Android to 4.2.10
  * iOS to 4.2.13
* Added `showRouteLegButtons` to `MPDirectionsRenderer`
* Added `setLabelOptions` to `MapsindoorsWidget`

## 2.0.1

* RETRACTED

## 2.0.0

* Moved from mapsindoors to allow for multiple map providers
* Changes to classes:
  * MapControl
    * MapControl has merged with the MapsIndoorsWidget, combining them into a single entity. the Widget will still be built in the build tree, and accepts a listener as a parameter to wait for the MapControl part to be initialized.
* MapsIndoors
  * Has been split up into functions on the namespace to align better with dart language standards. Some methods have changed naming to avoid collision with popular method and parameter naming (eg. MapsIndoors.load() is now loadMapsIndoors())
* Changes to the Widget
  * The MapsIndoorsWidget has been changed to be a UniqueWidget, this is to ensure that the underlying MapsIndoors in the platform code can function normally.
  