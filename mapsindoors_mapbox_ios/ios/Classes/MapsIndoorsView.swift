import Flutter
import MapboxMaps
import MapsIndoors
import MapsIndoorsCore
import MapsIndoorsMapbox

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var mapsIndoorsData: MapsIndoorsData

    init(
        messenger: FlutterBinaryMessenger,
        mapsIndoorsData: MapsIndoorsData
    ) {
        self.messenger = messenger
        self.mapsIndoorsData = mapsIndoorsData
        super.init()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            arguments: args,
            binaryMessenger: messenger,
            mapsIndoorsData: mapsIndoorsData)
    }
}

class FLNativeView: NSObject, FlutterPlatformView, MPMapControlDelegate, FlutterMapView {
    
    private var _MapView: MapView?
    private let MP_APIKEY = "mapspeople"
    private var mapsIndoorsData: MapsIndoorsData? = nil
    private var args: Any? = nil

    init(
        frame: CGRect,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        mapsIndoorsData: MapsIndoorsData
    ) {
        super.init()

        self.args = args
        self.mapsIndoorsData = mapsIndoorsData;
        let mapInitOptions = MapInitOptions(resourceOptions: ResourceOptions(accessToken: Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String ?? ""))
        _MapView = MapView(frame: frame, mapInitOptions: mapInitOptions)

        if (MPMapsIndoors.shared.ready) {
            mapsIndoorsIsReady();
        }else {
            mapsIndoorsData.delegate.append(MIReadyDelegate(view: self))
        }
        
        mapsIndoorsData.mapView = self
    }

    func view() -> UIView {
        return _MapView!
    }
    
    func mapsIndoorsIsReady() {
        if (mapsIndoorsData?.mapView != nil) {
            DispatchQueue.main.async { [self] in
                let config = MPMapConfig.init(mapBoxView: _MapView!, accessToken: Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String ?? "")
                let mapControl = MPMapsIndoors.createMapControl(mapConfig: config)
                if (mapControl != nil) {
                    //TODO: parse config
                    mapControl?.showUserPosition = true
                    //pretend config^
                    mapsIndoorsData!.mapControl = mapControl
                    mapsIndoorsData?.mapControlMethodChannel?.invokeMethod("create", arguments: nil)
                    mapsIndoorsData?.directionsRenderer = nil
                }else {
                    mapsIndoorsData?.mapControlMethodChannel?.invokeMethod("create", arguments: MPError.unknownError)
                }
            }
        }
    }
    
    func animateCamera(cameraUpdate: CameraUpdate, duration: Int) throws {
        guard let update = makeMBCameraUpdate(cameraUpdate: cameraUpdate) else {
            throw MPError.unknownError
        }
        
        DispatchQueue.main.async {
            self._MapView?.mapboxMap.setCamera(to: update)
        }
    }
    
    func moveCamera(cameraUpdate: CameraUpdate) throws {
        guard let update = makeMBCameraUpdate(cameraUpdate: cameraUpdate) else {
            throw MPError.unknownError
        }
        
        DispatchQueue.main.async {
        }
    }
    
    func makeMBCameraUpdate(cameraUpdate: CameraUpdate) -> CameraOptions? {
        var update: CameraOptions
        switch cameraUpdate.mode {
        case "fromPoint":
            guard let point = cameraUpdate.point else {
                return nil
            }
            let camera = _MapView!.mapboxMap.cameraState
            
            update = CameraOptions(cameraState: camera)
            update.center = point.coordinate
        case "fromBounds":
            guard let bounds = cameraUpdate.bounds else {
                return nil
            }
            let camera = _MapView!.mapboxMap.cameraState

            let camerabounds = CameraBoundsOptions(bounds: CoordinateBounds(southwest: bounds.southWest, northeast: bounds.northEast))
            
            update = CameraOptions(cameraState: camera)
            update.center = camerabounds.bounds?.center
        case "zoomBy":
            let camera = _MapView!.mapboxMap.cameraState
            
            update = CameraOptions(cameraState: camera)
            update.zoom = CGFloat(cameraUpdate.zoom!)
        case "zoomTo":
            let camera = _MapView!.mapboxMap.cameraState
            
            update = CameraOptions(cameraState: camera)
            update.zoom = CGFloat(cameraUpdate.zoom!)
        case "fromCameraPosition":
            guard let position = cameraUpdate.position else {
                return nil
            }
            let camera = _MapView!.mapboxMap.cameraState
            
            update = CameraOptions(cameraState: camera)
            update.center = position.target.coordinate
            update.bearing = CLLocationDirection(position.bearing)
            if let zoom = cameraUpdate.zoom {
                update.zoom = CGFloat(zoom)
            }
        default:
            return nil
        }

        
        return update
    }
}

class MIReadyDelegate: MapsIndoorsReadyDelegate {
    let view: FLNativeView
    
    init(view: FLNativeView) {
        self.view = view
    }
    
    func isReady(error: MPError?) {
        if (error == MPError.invalidApiKey || error == MPError.networkError || error == MPError.unknownError ) {
            //TODO: Do nothing i guees?
        }else {
            view.mapsIndoorsIsReady()
        }
    }
}
