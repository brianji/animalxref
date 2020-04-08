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
                  hintText: 'Search fish',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (q) => textEditingController.text = q.trim(),
              ),
            ),
            if (textEditingController.text.isNotEmpty)
              CloseButton(onPressed: textEditingController.clear),
          ],
        ),
      ),
    );
  }
}
