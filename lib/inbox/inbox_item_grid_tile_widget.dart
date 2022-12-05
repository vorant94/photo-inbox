import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inbox.dart';
import 'inbox_item.dart';
import 'inbox_item_screen.dart';

class InboxItemGridTileWidget extends StatefulWidget {
  final InboxItem item;

  const InboxItemGridTileWidget({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<InboxItemGridTileWidget> createState() =>
      _InboxItemGridTileWidgetState();
}

class _InboxItemGridTileWidgetState extends State<InboxItemGridTileWidget> {
  void _toggleCompleted(BuildContext context) {
    final inbox = Provider.of<Inbox>(context, listen: false);
    setState(() {
      inbox.toggleItemCompleted(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          InboxItemScreen.route,
          arguments: InboxItemDetailsArguments(widget.item.id),
        );
      },
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            child: Image.network(
              widget.item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, -0.25),
                colors: [Colors.grey, Colors.transparent],
              ),
            ),
            constraints: const BoxConstraints.expand(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.circle_outlined),
              selectedIcon: const Icon(Icons.check_circle),
              isSelected: widget.item.isCompleted,
              onPressed: () => _toggleCompleted(context),
              style: IconButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }
}
