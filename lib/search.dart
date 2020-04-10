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
    final textEditingController = Provider.of<TextEditingController>(context);

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            PopupMenuButton<_Item>(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 16),
                      Text('Settings'),
                    ],
                  ),
                  value: _Item.settings,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 16),
                      Text('About'),
                    ],
                  ),
                  value: _Item.about,
                ),
              ],
              onSelected: (v) {
                switch (v) {
                  case _Item.settings:
                    Navigator.of(context).pushNamed('/settings');
                    return;
                  case _Item.about:
                    showAboutDialog(context: context);
                    return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum _Item {
  settings,
  about,
}
