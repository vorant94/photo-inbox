import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inbox.dart';
import 'inbox_item.dart';
import 'inbox_item_grid_widget.dart';

class InboxScreen extends StatelessWidget {
  static const route = '/inbox';

  const InboxScreen({
    Key? key,
  }) : super(key: key);

  Map<DateTime, List<InboxItem>> _groupItemsByDate(BuildContext context) {
    final inbox = Provider.of<Inbox>(context, listen: false);
    final isShowAllMode = inbox.isShowAllMode;
    final items = inbox.items;

    final filteredItems =
        isShowAllMode ? items : items.where((item) => !item.isCompleted);
    return groupBy(filteredItems, (item) => item.createdDate);
  }

  void _onPopupMenuSelected(BuildContext context, InboxPopupMenuActions value) {
    switch (value) {
      case InboxPopupMenuActions.toggleShowAllMode:
        final inbox = Provider.of<Inbox>(context, listen: false);
        inbox.isShowAllMode = !inbox.isShowAllMode;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inbox = Provider.of<Inbox>(context);
    final isShowAllMode = inbox.isShowAllMode;
    final itemGroups = _groupItemsByDate(context);
    final groupKeys = itemGroups.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: InboxPopupMenuActions.toggleShowAllMode,
                child:
                    Text(isShowAllMode ? 'Show uncompleted only' : 'Show all'),
              )
            ],
            onSelected: (value) => _onPopupMenuSelected(context, value),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: groupKeys.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (_, index) {
            final createdDate = groupKeys[index];
            final items = itemGroups[groupKeys[index]]!;
            return InboxItemGridWidget(createdDate, items);
          },
        ),
      ),
    );
  }
}

enum InboxPopupMenuActions { toggleShowAllMode }
