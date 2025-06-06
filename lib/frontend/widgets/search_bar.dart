import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:my_gym/utils/debug/debug_print.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  const CustomSearchBar({super.key, required this.onSearch});

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    // Cancel the previous timer if still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onSearch(text); // Call the callback after debounce
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onTapUpOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _searchController,
        onChanged: (text) {
          _onSearchChanged(text);
        },
        cursorColor: Theme.of(context).highlightColor,
        decoration: InputDecoration(
          hintText: 'Search customers...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).highlightColor,
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).highlightColor.withAlpha(150),
          ),
        ),
        style: TextStyle(color: Theme.of(context).highlightColor),
      ),
    );
  }
}
