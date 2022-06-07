import 'package:acservermanager/common/logger.dart';
import 'package:acservermanager/models/searcheable_element.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class SearchBar<T> extends StatefulWidget {
  final List<SearcheableElement> searchList;
  final String? hint;
  final Function(List<T>) onSearch;
  final double? width;

  const SearchBar({
    Key? key,
    required this.searchList,
    this.hint,
    this.width,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<SearchBar<T>> createState() => _SearchBarState<T>();
}

class _SearchBarState<T> extends State<SearchBar<T>> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    widget.onSearch(widget.searchList as List<T>);
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        setState(() {});
      } else if (_textController.text.length == 1) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(top: 16),
      height: 52,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextBox(
        controller: _textController,
        placeholder: widget.hint ?? "search".tr(),
        suffix: _textController.text.isEmpty
            ? const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(FluentIcons.search),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(FluentIcons.clear),
                  onPressed: () {
                    _textController.clear();
                    widget.onSearch(widget.searchList as List<T>);
                  },
                ),
              ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
        onChanged: (term) {
          if (term.isEmpty) {
            widget.onSearch(widget.searchList as List<T>);
            return;
          }
          List<SearcheableElement> filtered = [];
          try {
            filtered = widget.searchList
                .where((item) =>
                    item.searchTerm.toLowerCase().contains(term.toLowerCase()))
                .toList();
          } catch (e, stacktrace) {
            Logger()
                .log("Error: $e\nStacktrace:\n$stacktrace", name: "search_bar");
            Logger().log('SearchTerm: $term', name: "search_bar");
          }
          widget.onSearch(filtered as List<T>);
        },
      ),
    );
  }
}
