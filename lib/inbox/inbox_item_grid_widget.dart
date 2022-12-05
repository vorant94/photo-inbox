import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'inbox_item.dart';
import 'inbox_item_grid_tile_widget.dart';

class InboxItemGridWidget extends StatelessWidget {
  final DateTime createdDate;
  final List<InboxItem> items;

  const InboxItemGridWidget({
    required this.createdDate,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMEd().format(createdDate),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: items
              .map((item) => InboxItemGridTileWidget(
                    item: item,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
