import 'dart:io';

import 'package:acservermanager/common/inherited_widgets/selected_server_inherited.dart';
import 'package:acservermanager/models/layout.dart';
import 'package:acservermanager/models/track.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TrackBottomSheetWidget extends StatefulWidget {
  final Track track;
  const TrackBottomSheetWidget({
    Key? key,
    required this.track,
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

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _layouts = [];
    final int skinDiff = (MediaQuery.of(context).size.height ~/ 3) ~/ 26;
    //Creates the list of list of skins
    for (int i = 0; i < widget.track.layouts.length; i += skinDiff) {
      if (i + skinDiff > widget.track.layouts.length) {
        _layouts.add(widget.track.layouts.sublist(i));
        break;
      } else {
        _layouts.add(widget.track.layouts.sublist(i, i + skinDiff));
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
        widget.track.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectedSkin(),
              _buildSkins(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSkin() {
    return Image.file(
      File(_selectedLayout.previewImagePath),
      height: MediaQuery.of(context).size.height / _kImageWidthDiv,
      width: MediaQuery.of(context).size.height / _kImageWidthDiv,
    );
  }

  Widget _buildSkins() {
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
                  return Row(
                    children: [
                      Checkbox(
                        checked: _addedLayout == layout,
                        onChanged: (value) {
                          if (value!) {
                            _addSkinToServer(layout);
                          } else {
                            _removeSkinFromServer(layout);
                          }
                        },
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
  void _addSkinToServer(Layout layout) {
    setState(() {
      _addedLayout = layout;
    });
  }

  //Removes the skin (and the car if it has no more skins) from the selected cars in the server
  void _removeSkinFromServer(Layout layout) {
    setState(() {
      _addedLayout = null;
    });
  }
}
