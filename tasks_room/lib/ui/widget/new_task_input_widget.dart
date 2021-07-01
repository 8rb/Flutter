import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_room/data/moor_database.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({
    Key? key,
  }) : super(key: key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  late DateTime newTaskDate;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Task Name'),
        onSubmitted: (inputName) {
          final database = Provider.of<AppDatabase>(context, listen: false);
          final task = Task(
            name: inputName,
            dueDate: newTaskDate,
          );
          database.insertTask(task);
          resetValuesAfterSubmit();
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        ))!;
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null as DateTime;
      controller.clear();
    });
  }
}
