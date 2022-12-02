import 'package:flutter/cupertino.dart';

import 'inbox_item.dart';

class Inbox with ChangeNotifier {
  var _isShowAllMode = true;
  final List<InboxItem> _items = [
    InboxItem(
      '1',
      'https://images.pexels.com/photos/14127944/pexels-photo-14127944.jpeg',
      DateTime(2022, 12, 1),
      isCompleted: true,
    ),
    InboxItem(
      '2',
      'https://images.pexels.com/photos/13870995/pexels-photo-13870995.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(2022, 11, 30),
    ),
    InboxItem(
      '3',
      'https://images.pexels.com/photos/14417238/pexels-photo-14417238.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(2021, 11, 9),
    ),
    InboxItem(
      '4',
      'https://images.pexels.com/photos/13984654/pexels-photo-13984654.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '5',
      'https://images.pexels.com/photos/13959380/pexels-photo-13959380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '6',
      'https://images.pexels.com/photos/12216995/pexels-photo-12216995.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '7',
      'https://images.pexels.com/photos/14534676/pexels-photo-14534676.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '8',
      'https://images.pexels.com/photos/9553449/pexels-photo-9553449.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '9',
      'https://images.pexels.com/photos/13415559/pexels-photo-13415559.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '10',
      'https://images.pexels.com/photos/13221455/pexels-photo-13221455.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
    InboxItem(
      '11',
      'https://images.pexels.com/photos/14156051/pexels-photo-14156051.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      DateTime(1989, 11, 9),
    ),
  ];

  set isShowAllMode(bool isShowAllMode) {
    _isShowAllMode = isShowAllMode;
    notifyListeners();
  }

  bool get isShowAllMode => _isShowAllMode;

  List<InboxItem> get items => List.unmodifiable(_items);

  InboxItem findItemById(String itemId) =>
      items.firstWhere((item) => item.id == itemId);

  void toggleItemCompleted(String itemId) {
    final item = findItemById(itemId);
    item.isCompleted = !item.isCompleted;
    if (!_isShowAllMode) {
      notifyListeners();
    }
  }
}
