import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inbox.dart';

class InboxItemScreen extends StatelessWidget {
  static const route = '/inbox-item';

  const InboxItemScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as InboxItemDetailsArguments;
    final item = context.watch<Inbox>().findItemById(args.itemId);

    return Scaffold(
      body: Image.network(
        item.imageUrl,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

class InboxItemDetailsArguments {
  final String itemId;

  InboxItemDetailsArguments(this.itemId);
}
