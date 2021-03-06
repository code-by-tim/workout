import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/menus/home_main_menu.dart';
import 'package:workout/state/session_model.dart';
import 'package:workout/widgets/workout_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshWorkouts();
  }

  Future refreshWorkouts() async {
    setState(() => isLoading = true);

    await Provider.of<SessionModel>(context, listen: false).loadWorkouts();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guten Abend Tim"),
        automaticallyImplyLeading: false,
        actions: [
          HomeMenu(
            refreshWorkouts: refreshWorkouts,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Provider.of<SessionModel>(context).workouts.isEmpty
              ? Center(child: Text('No workouts yet'))
              : ListView(
                  children: _buildWorkoutTiles(),
                ),
    );
  }

  /// Returns a list of WorkoutTiles
  List<WorkoutTile> _buildWorkoutTiles() {
    List<WorkoutTile> _workoutTiles = [];

    Provider.of<SessionModel>(context).workouts.forEach((workout) {
      _workoutTiles.add(WorkoutTile(
        workout: workout,
        refreshWorkouts: refreshWorkouts,
      ));
    });
    return _workoutTiles;
  }
}
