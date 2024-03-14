import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SpotterApp());
}

class SpotterApp extends StatelessWidget {
  const SpotterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/main': (context) => MainPage(),
        '/output': (context) => const OutputPage(
              exercises: {},
              age: 0,
              height: 0,
              weight: 0, sets: 0, reps: 0,
            ),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Spotter',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.blue[900]!, Colors.blue[300]!],
                  ).createShader(
                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                  ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to your new gym regiment today',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String selectedGoal = '';
    String selectedEquip = '';
    String selectedExp = '';
    double age = 0;
    double height = 0;
    double weight = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Spotter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Age',
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                onChanged: (value) {
                  age = double.parse(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Height (cm)',
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                onChanged: (value) {
                  height = double.parse(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your height in cms',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Weight (kg)',
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                onChanged: (value) {
                  weight = double.parse(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your weight in kgs',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select your Gender',
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Goals',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select your Goal',
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'bodyrecomp',
                      child: Text('Body Recomposition')),
                  DropdownMenuItem(
                      value: 'bulk', child: Text('Mass Gain')),
                  DropdownMenuItem(value: 'shred', child: Text('Fat Loss')),
                  DropdownMenuItem(value: 'maintain', child: Text('Maintain')),
                ],
                onChanged: (value) {
                  selectedGoal = value as String;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Experience',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select your Experience Level',
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Beginner', child: Text('Beginner')),
                  DropdownMenuItem(
                      value: 'Intermediate', child: Text('Intermediate')),
                  DropdownMenuItem(
                      value: 'Advanced', child: Text('Advanced')),
                ],
                onChanged: (value) {
                  selectedExp = value as String; 
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Equipment',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Select your Equipment type',
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Body Weight', child: Text('Body Weight')),
                  DropdownMenuItem(
                      value: 'Home Gym', child: Text('Home Gym')),
                  DropdownMenuItem(value: 'Gym', child: Text('Gym')),
                ],
                onChanged: (value) {
                  selectedEquip = value as String; 
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final exercisesData = await getRoutineFromBackend(
            selectedGoal,
            selectedEquip,
            selectedExp,
          );
          if (exercisesData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutputPage(
                  exercises: exercisesData,
                  age: age,
                  height: height,
                  weight: weight, 
                  sets: 0, 
                  reps: 0,
                ),
              ),
            );
          } else {
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class OutputPage extends StatelessWidget {
  final Map<String, List<String>> exercises;
  final double age;
  final double height;
  final double weight;
  final int sets;
  final int reps;

  const OutputPage({
    Key? key,
    required this.exercises,
    required this.age,
    required this.height,
    required this.weight,
    required this.sets,
    required this.reps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Spotter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'BMI',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Your BMI: ${(weight / ((height / 100) * (height / 100))).toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your new Workout Regiment',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final day = exercises.keys.elementAt(index);
                final dayExercises = exercises[day] ?? [];
                return ExpansionTile(
                  title: Text(
                    day,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: dayExercises
                      .map((exercise) => ListTile(
                            title: Text(
                              exercise,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


Future<Map<String, List<String>>?> getRoutineFromBackend(
    String selectedGoal, String selectedEquip, String selectedExp) async {
  const url = 'http://127.0.0.1:8000/api/routine';
  try {
    final response = await http.get(
      Uri.parse('$url?goal=$selectedGoal&equip=$selectedEquip&exp=$selectedExp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Request successful
      print('Routine received successfully');

      final Map<String, dynamic>? data = jsonDecode(response.body);



      if (data != null &&
          data.containsKey('MONDAY') && data['MONDAY'] is List<dynamic> &&
          data.containsKey('TUESDAY') && data['TUESDAY'] is List<dynamic> &&
          data.containsKey('WEDNESDAY') && data['WEDNESDAY'] is List<dynamic> &&
          data.containsKey('THURSDAY') && data['THURSDAY'] is List<dynamic> &&
          data.containsKey('FRIDAY') && data['FRIDAY'] is List<dynamic> &&
          data.containsKey('SATURDAY') && data['SATURDAY'] is List<dynamic>&&
          data.containsKey('sets') && data['sets'] is List<dynamic>&&
          data.containsKey('reps') && data['reps'] is List<dynamic>&&
          data.containsKey('progover') && data['progover'] is List<dynamic>) {
        final Map<String, List<String>> exercisesData = {
'MONDAY': (data['MONDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),


          'TUESDAY': (data['TUESDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),

          'WEDNESDAY': (data['WEDNESDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),

          'THURSDAY': (data['THURSDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),

          'FRIDAY': (data['FRIDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),

          'SATURDAY': (data['SATURDAY'] as List<dynamic>).map<String>((exerciseData) {
  final String exerciseName = exerciseData['exercise'] ?? '';
  final String muscle = exerciseData['muscle_id'] ?? '';

  final List<dynamic> setsList = data['sets'] as List<dynamic>;
  final List<dynamic> repsList = data['reps'] as List<dynamic>;
  final List<dynamic> progoverList = data['progover'] as List<dynamic>;

  final String sets = setsList.isNotEmpty ? (setsList[0]['sets'] ?? '').toString() : '';
  final String reps = repsList.isNotEmpty ? (repsList[0]['reps'] ?? '').toString() : '';
  final String progover = progoverList.isNotEmpty ? (progoverList[0]['progover'] ?? '').toString() : '';

  return '$exerciseName for your $muscle, for $sets sets, $reps reps each. Progressive Overload?: $progover';
}).toList(),

        };

        return exercisesData;
      } else {
 
        print('Unexpected data format: $data');
        return null;
      }
    } else {

      print('Failed to get routine');

      return null;
    }
  } catch (e) {

    print('Error: $e');

    return null;
  }
}

