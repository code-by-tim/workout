import 'package:flutter/material.dart';

class EditWorkout extends StatefulWidget {
  const EditWorkout({Key? key}) : super(key: key);

  @override
  _EditWorkoutState createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  List _exerciseControllers = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          IconButton(onPressed: _addExercise, icon: Icon(Icons.add)),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel)),
          IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  //Save the workout in the db and return to homescreen
                }
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Workout title
            TextFormField(
              style: TextStyle(fontSize: 30),
              decoration: const InputDecoration(hintText: 'New workout'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a workout name';
                }
                return null;
              },
            ),
            // Give note when no exercises yet
            _exerciseControllers.length == 0
                ? Expanded(
                    child: Center(
                      child:
                          Text("No exercises created yet. Click + to add one."),
                    ),
                  )
                :
                // Exercises
                Expanded(
                    child: ReorderableListView.builder(
                      itemBuilder: _buildExerciseListTile,
                      itemCount: _exerciseControllers.length,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          var item = _exerciseControllers.removeAt(oldIndex);
                          _exerciseControllers.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// Returns an editable ListTile.
  /// The keys of the tiles start from 1 (not 0)!
  Widget _buildExerciseListTile(context, index) {
    int shownIndex = index + 1;
    return Card(
      key: Key('$index'),
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$shownIndex.', style: TextStyle(fontSize: 20)),
            SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: _exerciseControllers[index],
                decoration: InputDecoration(
                  hintText: 'Exercise $index',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 15),
            IconButton(
                onPressed: () {
                  setState(() {
                    _exerciseControllers.removeAt(index);
                  });
                },
                icon: Icon(Icons.delete)),
            SizedBox(width: 15),
            Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }

  /// Adds one element to _exerciseControllers
  void _addExercise() {
    setState(() {
      _exerciseControllers.add(TextEditingController());
    });
  }
}
