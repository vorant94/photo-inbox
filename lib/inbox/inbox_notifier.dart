import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

class InboxNotifier extends StateNotifier<List<Todo>> {
  InboxNotifier()
      : super([
          Todo(
            id: '1',
            imageUrl:
                'https://images.pexels.com/photos/14127944/pexels-photo-14127944.jpeg',
            createdDate: DateTime(2022, 12, 1),
            isCompleted: true,
          ),
          Todo(
            id: '2',
            imageUrl:
                'https://images.pexels.com/photos/13870995/pexels-photo-13870995.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(2022, 11, 30),
          ),
          Todo(
            id: '3',
            imageUrl:
                'https://images.pexels.com/photos/14417238/pexels-photo-14417238.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(2021, 11, 9),
          ),
          Todo(
            id: '4',
            imageUrl:
                'https://images.pexels.com/photos/13984654/pexels-photo-13984654.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '5',
            imageUrl:
                'https://images.pexels.com/photos/13959380/pexels-photo-13959380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '6',
            imageUrl:
                'https://images.pexels.com/photos/12216995/pexels-photo-12216995.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '7',
            imageUrl:
                'https://images.pexels.com/photos/14534676/pexels-photo-14534676.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '8',
            imageUrl:
                'https://images.pexels.com/photos/9553449/pexels-photo-9553449.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '9',
            imageUrl:
                'https://images.pexels.com/photos/13415559/pexels-photo-13415559.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '10',
            imageUrl:
                'https://images.pexels.com/photos/13221455/pexels-photo-13221455.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
          Todo(
            id: '11',
            imageUrl:
                'https://images.pexels.com/photos/14156051/pexels-photo-14156051.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            createdDate: DateTime(1989, 11, 9),
          ),
        ]);

  void toggleTodoCompleted(String todoId) {
    final prev = state.firstWhere((element) => element.id == todoId);
    final curr = prev.copyWith(isCompleted: !prev.isCompleted);

    state =
        state.map((element) => element.id == todoId ? curr : element).toList();
  }
}

final inboxProvider = StateNotifierProvider<InboxNotifier, List<Todo>>((ref) {
  return InboxNotifier();
});
