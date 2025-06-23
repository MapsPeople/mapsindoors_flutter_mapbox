part of '../mapsindoors.dart';

class MPDefaultFloorSelector extends StatefulWidget with MPFloorSelector {
  const MPDefaultFloorSelector({super.key});

  @override
  Widget? getWidget() => this;

  @override
  bool get isAutoFloorChangeEnabled => true;

  @override
  set floors(List<MPFloor>? value) {
    // Find the current state using the widget's key
    final state = _findCurrentState();
    state?.floors = value;
  }

  @override
  set onFloorSelectionChangedListener(OnFloorSelectionChangedListener value) {
    final state = _findCurrentState();
    state?.onFloorSelectionChangedListener = value;
  }

  @override
  void setSelectedFloor(MPFloor floor) {
    final state = _findCurrentState();
    state?.setSelectedFloor(floor);
  }

  @override
  void setSelectedFloorByFloorIndex(int floorIndex) {
    final state = _findCurrentState();
    state?.setSelectedFloorByFloorIndex(floorIndex);
  }

  @override
  set userPositionFloor(int value) {
    final state = _findCurrentState();
    state?.userPositionFloor = value;
  }

  @override
  void show(bool show) {
    final state = _findCurrentState();
    state?.show(show);
  }

  @override
  void zoomLevelChanged(num newZoomLevel) {
    final state = _findCurrentState();
    state?.zoomLevelChanged(newZoomLevel);
  }

  /// Safely finds the current state instance via the widget's [GlobalKey].
  _MPDefaultFloorSelectorState? _findCurrentState() {
    final state = (key as GlobalKey?)?.currentState;
    if (state is _MPDefaultFloorSelectorState) {
      return state;
    }
    return null;
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
  }

  @override
  void dispose() {
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
