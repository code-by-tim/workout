import 'package:flutter/material.dart';
import 'package:workout/dBService.dart';
import 'package:workout/menus/homeMenu.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/widgets/workoutTile.dart';

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
              : ListView(
                  children: _buildWorkoutTiles(),
                ),
    );
  }

  /// Returns a list of WorkoutTiles
  List<WorkoutTile> _buildWorkoutTiles() {
    List<WorkoutTile> _workoutTiles = [];

    workouts.forEach((workout) {
      _workoutTiles.add(WorkoutTile(workout: workout));
    });
    return _workoutTiles;
  }
}
