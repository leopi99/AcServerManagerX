import 'dart:io';

import 'package:acservermanager/models/layout.dart';
import 'package:acservermanager/models/track.dart';
import 'package:acservermanager/presentation/skeleton/presentation/bloc/session_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TrackBottomSheetWidget extends StatefulWidget {
  final Track track;
  final Function(Track) onSelect;
  final SessionBloc bloc;
  const TrackBottomSheetWidget({
    Key? key,
    required this.track,
    required this.onSelect,
    required this.bloc,
  }) : super(key: key);

  @override
  State<TrackBottomSheetWidget> createState() => _TrackBottomSheetWidgetState();
}

class _TrackBottomSheetWidgetState extends State<TrackBottomSheetWidget> {
  static const double _kImageWidthDiv = 2;
  late Layout _selectedLayout;

  Layout? _addedLayout;
  List<List<Layout>> _layouts = [];

  @override
  void initState() {
    _selectedLayout = widget.track.layouts.first;
    if (widget.bloc.currentSession.selectedTrack?.path == widget.track.path) {
      _addedLayout = widget.bloc.currentSession.selectedTrack!.layouts.first;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _layouts = [];
    final int layoutDiff = (MediaQuery.of(context).size.height ~/ 3) ~/ 26;
    //Creates the list of list of skins
    for (int i = 0; i < widget.track.layouts.length; i += layoutDiff) {
      if (i + layoutDiff > widget.track.layouts.length) {
        _layouts.add(widget.track.layouts.sublist(i));
        break;
      } else {
        _layouts.add(widget.track.layouts.sublist(i, i + layoutDiff));
      }
    }
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDivider: false,
      showHandle: false,
      description: Text(
        widget.track.circuitName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectedLayout(),
              _buildLayouts(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedLayout() {
    final double imageSize =
        MediaQuery.of(context).size.height / _kImageWidthDiv;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Opacity(
          opacity: .3,
          child: Image.file(
            File(_selectedLayout.previewImagePath),
            height: imageSize,
            width: imageSize,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.file(
            File(_selectedLayout.outlineImagePath),
            height: imageSize,
            width: imageSize,
          ),
        )
      ],
    );
  }

  Widget _buildLayouts() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: LimitedBox(
        maxWidth: MediaQuery.of(context).size.width -
            32 -
            MediaQuery.of(context).size.height / _kImageWidthDiv,
        maxHeight: MediaQuery.of(context).size.height / 2.7,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _layouts.map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: e.map<Widget>((layout) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RadioButton(
                            checked: _addedLayout?.path == layout.path,
                            onChanged: (value) {
                              if (value) {
                                _changeSelectedLayout(layout);
                                return;
                              }
                              _removeSelectedLayout(layout);
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLayout = layout;
                            });
                          },
                          child: Text(layout.name),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //Adds the skin (if the car is not already present, adds that too) to the selected cars in the server
  void _changeSelectedLayout(Layout layout) {
    widget.onSelect(widget.track.copyWith(layouts: [layout]));
    setState(() {
      _addedLayout = layout;
    });
  }

  //Removes the skin (and the car if it has no more skins) from the selected cars in the server
  void _removeSelectedLayout(Layout layout) {
    widget.bloc.add(SessionUnselectTrackEvent(context));
    setState(() {
      _addedLayout = null;
    });
  }
}
