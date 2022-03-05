import 'package:acservermanager/models/searcheable_element.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class SearchBar<T> extends StatelessWidget {
  final List<T> searchList;
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(top: 16),
      height: 52,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextBox(
        placeholder: hint ?? "search".tr(),
        suffix: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(FluentIcons.search),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
        ],
        onChanged: (term) {
          if (term.isEmpty) {
            onSearch(searchList);
            return;
          }
          List<T> filtered = [];
          try {
            filtered = searchList
                .where((item) =>
                    item.toString().toLowerCase().contains(term.toLowerCase()))
                .toList();
          } catch (e, stacktrace) {
            debugPrint("Error: $e\nStacktrace:\n$stacktrace");
            debugPrint('SearchTerm: $term');
          }
          onSearch(filtered);
        },
      ),
    );
  }
}
