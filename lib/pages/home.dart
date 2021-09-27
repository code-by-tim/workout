import 'package:flutter/material.dart';
import 'package:workout/dBService.dart';
import 'package:workout/menus/homeMenu.dart';
import 'package:workout/model/workout.dart';

enum WhyFarther { harder, smarter }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Workout> workouts;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshWorkouts();
  }

  Future refreshWorkouts() async {
    setState(() => isLoading = true);

    this.workouts = await DBService.instance.readAllWorkouts();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guten Abend Tim"),
        automaticallyImplyLeading: false,
        actions: [
          HomeMenu(),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : workouts.isEmpty
              ? Center(child: Text('No workouts yet'))
              : SingleChildScrollView(
                  child: ExpansionPanelList.radio(
                    dividerColor: Color.fromARGB(255, 66, 165, 245),
                    expandedHeaderPadding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                    children: _buildWorkoutTiles(),
                  ),
                ),
    );
  }

  /// Returns a list of expansion panels with the workouts
  List<ExpansionPanel> _buildWorkoutTiles() {
    print('WorkoutTiles generated');
    List<ExpansionPanel> _workoutTiles = [];
    int identifier = -1;

    workouts.forEach((workout) {
      _workoutTiles.add(ExpansionPanelRadio(
          value: ++identifier,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text('${workout.name}'));
          },
          body: Card(child: Text("Its expanded"))));
    });
    return _workoutTiles;
  }
}
