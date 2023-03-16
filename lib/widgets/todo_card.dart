import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class todocard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateedit;
  final Function(String) deleteById;
  const todocard({
    required this.index,
    required this.item,
    required this.navigateedit,
    required this.deleteById,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
            key: UniqueKey(),
            onDismissed: () {
              deleteById(id);
            }),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteById(id);
            },
            backgroundColor: Color.fromARGB(255, 80, 80, 80),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              navigateedit(item);
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(item['title']),
          subtitle: Text(item['description']),
        ),
      ),
    );
  }
}
