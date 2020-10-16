import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textEditingController = context.watch<TextEditingController>();

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: _focusNode.requestFocus,
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: textEditingController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (q) => textEditingController.text = q.trim(),
              ),
            ),
            if (textEditingController.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: textEditingController.clear,
                tooltip: 'Clear',
              ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
