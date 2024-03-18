import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String) onSearchPassword;

  const SearchField({super.key, required this.onSearchPassword});

  @override
  State<SearchField> createState() {
    return _SearchFieldState();
  }
}

class _SearchFieldState extends State<SearchField> {
  final _searchTxtController = TextEditingController();

  @override
  void dispose() {
    _searchTxtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.white),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
      autofocus: true,
      controller: _searchTxtController,
      onChanged: widget.onSearchPassword,
    );
  }
}
