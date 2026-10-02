part of '../mapsindoors.dart';

class MPDirectionsRenderer {
  /// Set a route to be rendered. This also resets the selected leg and step indices to 0.
  Future<void> setRoute(MPRoute? route,
      {Map<num, MPRouteStopIconConfigInterface>? stopIcons}) {
    return DirectionsRendererPlatform.instance.setRoute(route, stopIcons);
  }

  /// Change the default route stop icon.
  Future<void> setDefaultRouteStopIcon(MPRouteStopIconConfigInterface icon) {
    return DirectionsRendererPlatform.instance.setDefaultRouteStopIcon(icon);
  }

  /// Clears the route from the map
  Future<void> clear() => DirectionsRendererPlatform.instance.clear();

  /// Reports that the user has finished following the rendered route, so MapsIndoors Insights records it as a completed route (`directions_completed`).
  ///
  /// Call it when the user ends guidance themselves, for example from a Finish button. The route is also completed when it is cleared with [clear], so this is only needed for an explicit finish while the route stays on the map. Replacing a route with [setRoute] completes the previous one on both platforms, so it is not needed for that. Call it before [setRoute] only when you want to report your own [usagePercentage] for the route being replaced, rather than let the platform derive one. Calling it again for the same route, or with no route set, does nothing.
  ///
  /// [usagePercentage] is how much of the route the user covered, from 0 to 100. Leave it null to let the SDK estimate it from how far the user got, which is coarse and differs by platform: Android uses the furthest leg reached, so a single-leg route reports 0, while iOS uses the furthest step reached. Pass your own value whenever the app tracks progress. Values outside 0 to 100 are clamped, and a non-finite value is treated as null.
  Future<void> finishGuidance({double? usagePercentage}) =>
      DirectionsRendererPlatform.instance.finishGuidance(usagePercentage);

  /// Selects the next leg if possible.
  ///
  /// Has no effect if the last leg is selected
  Future<void> nextLeg() => DirectionsRendererPlatform.instance.nextLeg();

  /// Selects the previous leg if possible.
  ///
  /// Has no effect if the first leg is selected
  Future<void> previousLeg() =>
      DirectionsRendererPlatform.instance.previousLeg();

  /// Enable/Disable the polyline animation when displaying a route element on the map
  ///
  /// **Has no effect on iOS**, and only affects routes rendered after the call on Android. Use [setOptions] instead, which works on both platforms: [MPDirectionsRendererOptions.animationType] set to [MPRouteAnimationType.none] replaces passing false for [animated], [MPDirectionsRendererOptions.animationRepeating] replaces [repeating], and [MPDirectionsRendererOptions.animationSpeed] with [MPDirectionsRendererOptions.animationMinDuration] replace [durationMs], timing the animation from the route's length rather than a fixed duration.
  @Deprecated(
      'Has no effect on iOS. Use setOptions(MPDirectionsRendererOptions(...)) with animationType, animationRepeating, animationSpeed and animationMinDuration instead')
  Future<void> setAnimatedPolyline(
          bool animated, bool repeating, int durationMs) =>
      DirectionsRendererPlatform.instance
          .setAnimatedPolyline(animated, repeating, durationMs);

  /// Applies a set of style and behaviour options to the rendered route.
  ///
  /// Only the properties set on [options] are applied; the rest keep inheriting the solution-level wayfinding style configured in the MapsIndoors CMS, or the SDK's built-in default. If a route is already rendered, the new style is applied to it immediately.
  ///
  /// This replaces any options applied by an earlier call rather than merging with them. Read [getOptions] and use `copyWith` to change one property of an override you already applied, and [clearOptions] to drop it entirely.
  ///
  /// Several properties behave differently on the two platforms — see [MPDirectionsRendererOptions] for the details.
  Future<void> setOptions(MPDirectionsRendererOptions options) =>
      DirectionsRendererPlatform.instance.setOptions(options);

  /// Returns the options applied by the most recent [setOptions] call, or null if none has been applied, or if they were dropped by [clearOptions].
  ///
  /// This reports only the runtime override. It does not report the CMS solution-level style or the SDK's built-in defaults, so a property that was never set through [setOptions] reads back as null even though the route is drawn with a concrete value for it.
  ///
  /// Do not rely on an override outliving the map. Whether it survives the map widget being disposed and recreated is platform-dependent, because the underlying route renderer is rebuilt on Android and reused on iOS. Apply the options again after recreating the map.
  Future<MPDirectionsRendererOptions?> getOptions() =>
      DirectionsRendererPlatform.instance.getOptions();

  /// Drops the runtime override applied by [setOptions], so the route falls back to the CMS solution-level wayfinding style, or to the SDK's built-in default where the solution configures nothing.
  ///
  /// On iOS `fitBounds`, `fitBoundsPadding` and `animationRepeating` return to their built-in defaults rather than to a CMS value, because the iOS SDK cannot express them as unset. On Android `animationRepeating` is not affected at all, and keeps the value last set: restoring it would mean re-applying the whole options object natively, which carries the lasting side effect described on [MPDirectionsRendererOptions.animationRepeating].
  Future<void> clearOptions() =>
      DirectionsRendererPlatform.instance.clearOptions();

  /// Set the colors of the polyline
  @Deprecated('Use setOptions(MPDirectionsRendererOptions(...)) instead')
  Future<void> setPolyLineColors(Color foreground, Color background) =>
      DirectionsRendererPlatform.instance
          .setPolyLineColors(foreground, background);

  /// Manually set the selected leg index on the route.
  ///
  /// This may throw an exception if the resulting internal state is invalid (parsed index is out of bounds)
  Future<void> selectLegIndex(int legIndex) =>
      DirectionsRendererPlatform.instance.selectLegIndex(legIndex);

  /// Gets the currently selected leg's floor index.
  Future<int?> getSelectedLegFloorIndex() =>
      DirectionsRendererPlatform.instance.getSelectedLegFloorIndex();

  /// Set the duration of camera animations (ms).
  ///
  /// If a duration &#60; 0 then camera animations are disabled, and the camera will move instantly.
  ///
  /// The value is 1000 ms by default
  Future<void> setCameraAnimationDuration(int durationMs) =>
      DirectionsRendererPlatform.instance
          .setCameraAnimationDuration(durationMs);

  /// Set the [MPCameraViewFitMode] of the camera, when displaying route elements on the map.
  ///
  /// The camera may be aligned to north, aligned with the first step, or aligned from
  /// start point to end point.
  Future<void> setCameraViewFitMode(MPCameraViewFitMode mpCameraViewFitMode) =>
      DirectionsRendererPlatform.instance
          .setCameraViewFitMode(mpCameraViewFitMode);

  /// Set a listener, which will be invoked when a new leg has been selected
  ///
  /// This is used for when the forward/back markers are selected on the map
  Future<void> setOnLegSelectedListener(
          OnLegSelectedListener? onLegSelectedListener) =>
      DirectionsRendererPlatform.instance
          .setOnLegSelectedListener(onLegSelectedListener);

  /// Enable/Disable route leg buttons that are shown at the start and end of each leg.
  ///
  /// It is recommended to only disable these buttons in the case alternative UI has been created to allow for switching route legs.
  Future<void> showRouteLegButtons(bool show) =>
      DirectionsRendererPlatform.instance.showRouteLegButtons(show);
}
