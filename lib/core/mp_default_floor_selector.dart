part of '../mapsindoors.dart';

/// Controller that provides the MPFloorSelectorInterface to the platform while delegating to the state
class MPDefaultFloorSelectorController implements MPFloorSelectorInterface {
  _MPDefaultFloorSelectorState? _state;

  // Hold values until state is attached
  List<MPFloor>? _pendingFloors;
  OnFloorSelectionChangedListener? _pendingListener;
  int? _pendingUserPositionFloor;
  bool _pendingShow = true;

  void _attachState(_MPDefaultFloorSelectorState state) {
    _state = state;

    // Apply any pending operations
    if (_pendingFloors != null) {
      state.floors = _pendingFloors;
      _pendingFloors = null;
    }
    if (_pendingListener != null) {
      state.onFloorSelectionChangedListener = _pendingListener!;
      _pendingListener = null;
    }
    if (_pendingUserPositionFloor != null) {
      state.userPositionFloor = _pendingUserPositionFloor!;
      _pendingUserPositionFloor = null;
    }
    state.show(_pendingShow);
  }

  void _detachState() {
    _state = null;
  }

  @override
  Widget? getWidget() => _state?.widget;

  @override
  bool get isAutoFloorChangeEnabled => true;

  @override
  set floors(List<MPFloor>? value) {
    if (_state != null) {
      _state!.floors = value;
    } else {
      _pendingFloors = value;
    }
  }

  @override
  set onFloorSelectionChangedListener(OnFloorSelectionChangedListener value) {
    if (_state != null) {
      _state!.onFloorSelectionChangedListener = value;
    } else {
      _pendingListener = value;
    }
  }

  @override
  void setSelectedFloor(MPFloor floor) {
    _state?.setSelectedFloor(floor);
  }

  @override
  void setSelectedFloorByFloorIndex(int floorIndex) {
    _state?.setSelectedFloorByFloorIndex(floorIndex);
  }

  @override
  set userPositionFloor(int value) {
    if (_state != null) {
      _state!.userPositionFloor = value;
    } else {
      _pendingUserPositionFloor = value;
    }
  }

  @override
  void show(bool show) {
    if (_state != null) {
      _state!.show(show);
    } else {
      _pendingShow = show;
    }
  }

  @override
  void zoomLevelChanged(num newZoomLevel) {
    _state?.zoomLevelChanged(newZoomLevel);
  }
}

class MPDefaultFloorSelector extends StatefulWidget {
  const MPDefaultFloorSelector({
    super.key,
    required this.controller,
  });

  final MPDefaultFloorSelectorController controller;

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
    widget.controller._attachState(this);
  }

  @override
  void dispose() {
    widget.controller._detachState();
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
