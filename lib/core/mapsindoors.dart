part of '../mapsindoors.dart';

/// gets the platform name and build version
Future<String?> getPlatformVersion() =>
    UtilPlatform.instance.getPlatformVersion();

/// Loads content from the MapsIndoors solution matching the given API [key].
///
/// Use the [MPError] to determine if the SDK has loaded successfully.
Future<MPError?> loadMapsIndoors(String key) =>
    MapsindoorsPlatform.instance.load(key);

/// Loads content from the MapsIndoors solution matching the given API [key].
///
/// Loads a subset of [MPVenue]s defined in the [venueIds] parameter.
///
/// Throws an [MPError] if loading fails.
Future<void> loadMapsIndoorsWithVenues(String key, List<String> venueIds) =>
    MapsindoorsPlatform.instance.loadWithVenues(key, venueIds);

/// Adds a collection of venues to be synchronized. All non-synchronized venues will be unloaded.
///
/// This will irreversably change the current loaded SDK to venue-sync mode.
Future<void> addVenuesToSync(List<String> venueIds) =>
    MapsindoorsPlatform.instance.addVenuesToSync(venueIds);

/// Removes a collection of venues from active synchronization.
Future<void> removeVenuesToSync(List<String> venueIds) =>
    MapsindoorsPlatform.instance.removeVenuesToSync(venueIds);

/// Fetches all actively synchronized venues.
Future<List<String>> getSyncedVenues() =>
    MapsindoorsPlatform.instance.getSyncedVenues();

/// Retrieve the default display rule (hardcoded display rule in the SDK).
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDefaultDisplayRule() => Future.value(
    MapsindoorsPlatform.instance.createDisplayRuleWithName("default"));

/// Retrieve the main display rule (can be configured in the CMS).
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getMainDisplayRule() => Future.value(
    MapsindoorsPlatform.instance.createDisplayRuleWithName("main"));

/// Retrieve the display rule for the given [location]
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDisplayRuleByLocation(
    FutureOr<MPLocation> location) async {
  final exists = await MapsindoorsPlatform.instance
      .locationDisplayRuleExists((await location).id);
  if (exists == true) {
    return MapsindoorsPlatform.instance
        .createDisplayRuleWithName((await location).id.value);
  } else {
    return null;
  }
}

/// Retrieve the display rule with a given [name].
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDisplayRuleByName(String name) async {
  final typeExists =
      await MapsindoorsPlatform.instance.displayRuleNameExists(name);

  if (typeExists == true) {
    return MapsindoorsPlatform.instance.createDisplayRuleWithName(name);
  }

  final location = await getLocationById(name);
  if (location != null) {
    return getDisplayRuleByLocation(location);
  }

  return null;
}

/// Retrieve the corresponding display rule for the given [MPSolutionDisplayRuleEnum].
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getSolutionDisplayRule(
        MPSolutionDisplayRuleEnum solutionDisplayRule) =>
    Future.value(MapsindoorsPlatform.instance
        .createDisplayRuleWithName(solutionDisplayRule.name));

/// Add a one time [listener] to be invoked when MapsIndoors is ready
void addOnMapsIndoorsReadyListener(OnMapsIndoorsReadyListener listener) =>
    MapsindoorsPlatform.instance.addOnMapsIndoorsReadyListener(listener);

/// Remove a MapsIndoors ready [listener]
void removeOnMapsIndoorsReadyListener(OnMapsIndoorsReadyListener listener) =>
    MapsindoorsPlatform.instance.removeOnMapsIndoorsReadyListener(listener);

/// Add a [listener] that is invoked when the loading status changes for a venue.
void addOnVenueStatusChangedListener(MPVenueStatusListener listener) =>
    MapsindoorsPlatform.instance.addOnVenueStatusChangedListener(listener);

/// Remove a venue status [listener]
void removeOnVenueStatusChangedListener(MPVenueStatusListener listener) =>
    MapsindoorsPlatform.instance.removeOnVenueStatusChangedListener(listener);

/// Checks if there is on device data (embedded/locally stored) available. For this to return true,
/// data has to be available for all solution data types ([MPLocation], [MPBuilding]...)
///
/// Returns true if data is available, otherwise returns false
Future<bool?> checkOfflineDataAvailability() =>
    MapsindoorsPlatform.instance.checkOfflineDataAvailability();

/// Clears the internal state of MapsIndoors SDK. Any loaded content is purged from memory.
///
/// Invoke [loadMapsIndoors] to start the SDK anew.
void destroyMapsIndoors() => MapsindoorsPlatform.instance.destroy();

/// [disable] SDK event logging through MapsIndoors. No logs will be created or send with this disabled.
///
/// By default it is enabled. But disabled in the CMS meaning logs will be created but never uploaded.
Future<void> disableMapsIndoorsEventLogging(bool disable) =>
    MapsindoorsPlatform.instance.disableEventLogging(disable);

/// Retrieves the API key that was set by using [loadMapsIndoors]
///
/// Returns the API key, or "" if no key has been set
Future<String?> getAPIKey() => MapsindoorsPlatform.instance.getAPIKey();

/// Returns a list of the current solution's available languages
Future<List<String>?> getMapsIndoorsAvailableLanguages() =>
    MapsindoorsPlatform.instance.getAvailableLanguages();

/// Gets a collection of all buildings for the current API key
Future<MPBuildingCollection?> getBuildings() =>
    MapsindoorsPlatform.instance.getBuildings();

/// Gets a collection of all categories for the current API key
Future<MPCategoryCollection?> getCategories() =>
    MapsindoorsPlatform.instance.getCategories();

/// Returns the current solution's default language
Future<String?> getMapsIndoorsDefaultLanguage() =>
    MapsindoorsPlatform.instance.getDefaultLanguage();

/// Gets the current SDK language
Future<String?> getMapsIndoorsLanguage() =>
    MapsindoorsPlatform.instance.getLanguage();

/// Retrieves a [MPLocation] by its [id]
Future<MPLocation?> getLocationById(String id) =>
    MapsindoorsPlatform.instance.getLocationById(id);

/// Gets all locations (a list of [MPLocation] objects) for the current API Key
Future<List<MPLocation>?> getLocations() =>
    MapsindoorsPlatform.instance.getLocations();

/// Runs a query on all the available [MPLocation]s with an optional [MPQuery] and/or [MPFilter]
///
/// Selecting one of the returned locations afterwards is reported to MapsIndoors Insights as a search-driven selection (`location_searched`) alongside the plain selection event, but only when the [query] carries search text. A query without it marks nothing, and on Android it also clears the marks left by the previous text search, so the next selection is reported as a plain one. A location the app found by searching its own data outside this call is never reported as search-driven.
Future<List<MPLocation>?> getLocationsByQuery(
        {MPQuery? query, MPFilter? filter}) =>
    MapsindoorsPlatform.instance.getLocationsByQuery(query, filter);

/// Retrieves a list of [MPLocation]s by external [ids]
Future<List<MPLocation>?> getLocationsByExternalIds(List<String> ids) =>
    MapsindoorsPlatform.instance.getLocationsByExternalIds(ids);

/// Gets a list of available map styles
Future<List<MPMapStyle>?> getMapStyles() =>
    MapsindoorsPlatform.instance.getMapStyles();

/// Returns the current position provider, if any is set
MPPositionProviderInterface? getPositionProvider() =>
    MapsindoorsPlatform.instance.getPositionProvider();

/// Set a new position provider, or pass null to remove the current one
///
/// Positioning starts as soon as the provider is set and has produced a position
void setPositionProvider(MPPositionProviderInterface? provider) =>
    MapsindoorsPlatform.instance.setPositionProvider(provider);

/// Gets the [MPSolution] for the current API key
Future<MPSolution?> getSolution() => MapsindoorsPlatform.instance.getSolution();

/// Gets a collection of all venues for the current API key
Future<MPVenueCollection?> getVenues() =>
    MapsindoorsPlatform.instance.getVenues();

/// Check if the current API key is valid
Future<bool?> isAPIKeyValid() => MapsindoorsPlatform.instance.isAPIKeyValid();

/// Check if [loadMapsIndoors] has been called
Future<bool?> isMapsIndoorsInitialized() =>
    MapsindoorsPlatform.instance.isInitialized();

/// Check if the SDK is initialized and ready for use
Future<bool?> isMapsIndoorsReady() => MapsindoorsPlatform.instance.isReady();

/// Sets the SDK's internal language.
///
/// By default, the SDK language can be:
/// <ul>
/// <li>the solution's default language ([MPSolution.defaultLanguage])</li>
/// <li>the current device language, if the MapsIndoors data isn't available (ie: first app run without network access)</li>
/// </ul>
///
/// [language] must resolve to one of [getMapsIndoorsAvailableLanguages].
///
/// It can be changed at any time, before or after [loadMapsIndoors]. Content then reloads asynchronously, so [getLocations] can briefly return stale or empty results afterwards.
///
/// The result is Android-only; iOS always resolves to null.
Future<bool?> setMapsIndoorsLanguage(String language) =>
    MapsindoorsPlatform.instance.setLanguage(language);

/// Main data synchronization method
///
/// If not manually invoked, [MapsIndoorsWidget] will invoke it when built
Future<MPError?> synchronizeMapsIndoorsContent() =>
    MapsindoorsPlatform.instance.synchronizeContent();

/// Gets the User Roles for the current solution
///
/// Note that role names are localized
Future<MPUserRoleCollection?> getUserRoles() =>
    MapsindoorsPlatform.instance.getUserRoles();

/// Returns the list of [MPUserRole] that is currently applied
Future<List<MPUserRole>?> getAppliedUserRoles() =>
    MapsindoorsPlatform.instance.getAppliedUserRoles();

/// Applies a list of [MPUserRole]s to the SDK which will get the UserRole specific locations.
Future<void> applyUserRoles(List<MPUserRole> userRoles) =>
    MapsindoorsPlatform.instance.applyUserRoles(userRoles);

/// Get a [MPGeocodeResult] that contains lists of [MPLocation] (grouped by [MPLocationType]),
/// where the [point] is inside the locations geometry. When no floor index is set, locations on all floors are queried.
Future<MPGeocodeResult?> reverseGeoCode(MPPoint point) =>
    MapsindoorsPlatform.instance.reverseGeoCode(point);

/// Gets the default venue for this solution
///
/// This is the venue set as the solution's default in the MapsIndoors CMS. When none is set, the platforms differ: Android returns the solution's first venue, while iOS returns null.
Future<MPVenue?> getDefaultVenue() =>
    MapsindoorsPlatform.instance.getDefaultVenue();

/// Enables or disables debug logging for the MapsIndoors SDK.
Future<void> enableMapsIndoorsDebugLogging(bool enable) =>
    MapsindoorsPlatform.instance.enableDebugLogging(enable);

/// Whether the active map provider can cache base-map tiles for offline use.
///
/// Returns true on the Mapbox flavour and false on the Google Maps flavour, which has no offline tile store to cache into. When this is false, [enableBaseMapCaching] and [synchronizeBaseMapTiles] both return an [MPError] with code [MPError.baseMapCachingNotSupported] and no tiles are downloaded.
Future<bool> isBaseMapCachingSupported() =>
    DataSetCachePlatform.instance.isBaseMapCachingSupported();

/// Enables caching of the map provider's own base-map tiles for the loaded dataset, so the base map underneath MapsIndoors still renders while the device is offline.
///
/// Call this after [loadMapsIndoors] and after a [MapsIndoorsWidget] has been built: the dataset is identified by the loaded API key, and the map provider registers the cache implementation when the map view is created. Called earlier, it returns an [MPError] with code [MPError.baseMapCachingNotRegistered].
///
/// This only sets the flag. Nothing is downloaded until [synchronizeBaseMapTiles] is called.
///
/// [styleSource] must be the Mapbox style the live map renders, because caching one style while displaying another fails silently and only shows up as a blank base map when the device goes offline. It is read on Android only. On iOS the SDK caches the style the map is set up to render, including one set with [MapsIndoorsWidget.mapStyleUri], so [styleSource] is ignored there and the same call works on both platforms.
///
/// [scope] governs how much MapsIndoors *content* is cached, and applies only when the dataset is not already being managed - which it usually is, because [loadMapsIndoors] registers it. It has no effect on which base-map tiles are downloaded.
///
/// Returns null on success, otherwise an [MPError].
Future<MPError?> enableBaseMapCaching(
        {MPMapboxStyleSource styleSource =
            const MPMapboxStyleSource.mapsIndoorsDefault(),
        MPDataSetCachingScope scope = MPDataSetCachingScope.full}) =>
    DataSetCachePlatform.instance.enableBaseMapCaching(styleSource, scope);

/// Downloads the base-map tiles for every dataset that [enableBaseMapCaching] has been called for, one region per venue.
///
/// The dataset's venues must already be on the device, which [loadMapsIndoors] takes care of for the loaded solution. A download covers a whole venue and can take several minutes; calling this again for an already-cached dataset refreshes it rather than duplicating it.
///
/// [onProgress] reports a fraction from 0.0 to 1.0 while the download runs, ending at 1.0 on success. It is never invoked on the Google Maps flavour. Only one synchronization can run at a time - starting a second before the first completes throws a [StateError].
///
/// Update frequency differs by platform: Android reports continuously through the download, while iOS reports once per cached venue region. On a five-venue solution that measured 627 updates on Android against 5 on iOS. The fraction is accurate on both, so a progress bar bound to it is correct either way - just coarser on iOS, where a single-venue solution may report nothing before the final 1.0.
///
/// On Android, [destroyMapsIndoors] cancels a download in flight; already-cached tiles are kept.
///
/// Returns null once every region has been cached, otherwise an [MPError].
Future<MPError?> synchronizeBaseMapTiles(
        {OnBaseMapCacheProgressListener? onProgress}) =>
    DataSetCachePlatform.instance.synchronizeBaseMapTiles(onProgress);
