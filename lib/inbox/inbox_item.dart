import 'package:flutter/cupertino.dart';

class InboxItem with ChangeNotifier {
  final String id;
  final String imageUrl;
  final DateTime createdDate;
  String? _tag;
  bool _isCompleted;

  InboxItem({
    required this.id,
    required this.imageUrl,
    required this.createdDate,
    String? tag,
    var isCompleted = false,
  })  : _tag = tag,
        _isCompleted = isCompleted;

  String? get tag => _tag;

  set tag(String? tag) {
    _tag = tag;
    notifyListeners();
  }

  bool get isCompleted => _isCompleted;

  set isCompleted(bool isCompleted) {
    _isCompleted = isCompleted;
    notifyListeners();
  }
}
