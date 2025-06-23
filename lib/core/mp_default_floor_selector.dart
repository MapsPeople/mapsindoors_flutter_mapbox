part of '../mapsindoors.dart';

class MPDefaultFloorSelector extends StatefulWidget with MPFloorSelector {
  const MPDefaultFloorSelector({super.key});

  static _MPDefaultFloorSelectorState? _currentState;
  static List<MPFloor>? _pendingFloors;
  static OnFloorSelectionChangedListener? _pendingListener;
  static int? _pendingUserPositionFloor;

  @override
  Widget? getWidget() => this;

  @override
  bool get isAutoFloorChangeEnabled => true;

  @override
  set floors(List<MPFloor>? value) {
    if (_currentState == null) {
      _pendingFloors = value;
    } else {
      _currentState!.floors = value;
    }
  }

  @override
  set onFloorSelectionChangedListener(OnFloorSelectionChangedListener value) {
    if (_currentState == null) {
      _pendingListener = value;
    } else {
      _currentState!.onFloorSelectionChangedListener = value;
    }
  }

  @override
  void setSelectedFloor(MPFloor floor) {
    _currentState?.setSelectedFloor(floor);
  }

  @override
  void setSelectedFloorByFloorIndex(int floorIndex) {
    _currentState?.setSelectedFloorByFloorIndex(floorIndex);
  }

  @override
  set userPositionFloor(int value) {
    if (_currentState == null) {
      _pendingUserPositionFloor = value;
    } else {
      _currentState!.userPositionFloor = value;
    }
  }

  @override
  void show(bool show) {
    _currentState?.show(show);
  }

  @override
  void zoomLevelChanged(num newZoomLevel) {
    _currentState?.zoomLevelChanged(newZoomLevel);
  }

  @override
  State<MPDefaultFloorSelector> createState() => _MPDefaultFloorSelectorState();
}

class _MPDefaultFloorSelectorState extends State<MPDefaultFloorSelector>
    implements MPFloorSelectorInterface {
  final List<MPFloor> _floors = <MPFloor>[];
  OnFloorSelectionChangedListener? _listener;
  bool _visible = true;
  int _userPositionFloor = -1;
  MPFloor? _selectedFloor;
  num showOnZoomLevel = 17.0;

  @override
  void initState() {
    super.initState();
    MPDefaultFloorSelector._currentState = this;

    // Handle any pending values
    if (MPDefaultFloorSelector._pendingFloors != null) {
      floors = MPDefaultFloorSelector._pendingFloors;
      MPDefaultFloorSelector._pendingFloors = null;
    }
    if (MPDefaultFloorSelector._pendingListener != null) {
      onFloorSelectionChangedListener =
          MPDefaultFloorSelector._pendingListener!;
      MPDefaultFloorSelector._pendingListener = null;
    }
    if (MPDefaultFloorSelector._pendingUserPositionFloor != null) {
      userPositionFloor = MPDefaultFloorSelector._pendingUserPositionFloor!;
      MPDefaultFloorSelector._pendingUserPositionFloor = null;
    }
  }

  @override
  void dispose() {
    if (MPDefaultFloorSelector._currentState == this) {
      MPDefaultFloorSelector._currentState = null;
    }
    super.dispose();
  }

  @override
  Widget? getWidget() => widget;

  @override
  bool get isAutoFloorChangeEnabled => true;

  @override
  set floors(List<MPFloor>? floors) {
    if (floors == null) return;

    final List<MPFloor> sortedFloors = List<MPFloor>.from(floors)..sort();
    setState(() {
      _floors.clear();
      _floors.addAll(sortedFloors.reversed);
    });
  }

  @override
  set onFloorSelectionChangedListener(
      OnFloorSelectionChangedListener listener) {
    _listener = listener;
  }

  @override
  void setSelectedFloor(MPFloor floor) {
    _listener?.call(floor);
    setState(() {
      _selectedFloor = floor;
    });
  }

  @override
  void setSelectedFloorByFloorIndex(int floorIndex) {
    if (_floors.isEmpty) return;

    for (final floor in _floors) {
      if (floor.floorIndex == floorIndex) {
        setSelectedFloor(floor);
        return;
      }
    }
  }

  @override
  set userPositionFloor(int floorIndex) {
    setState(() {
      _userPositionFloor = floorIndex;
    });
  }

  @override
  void show(bool show) {
    if (_visible != show) {
      setState(() {
        _visible = show;
      });
    }
  }

  @override
  void zoomLevelChanged(num newZoomLevel) {
    show(newZoomLevel >= showOnZoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible || _floors.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 50,
      height: 400,
      child: ListView.builder(
        itemCount: _floors.length,
        itemBuilder: (context, index) {
          final floor = _floors[index];
          final isSelected = floor == _selectedFloor;
          final isUserPositionFloor = _userPositionFloor == floor.floorIndex;

          return ElevatedButton(
            onPressed: () => setSelectedFloor(floor),
            style: isSelected
                ? _buttonStyleWithColor(Colors.green)
                : isUserPositionFloor
                    ? _buttonStyleWithColor(Colors.amber)
                    : null,
            child: Text(floor.displayName),
          );
        },
      ),
    );
  }
}

ButtonStyle _buttonStyleWithColor(Color color) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) => color),
  );
}
