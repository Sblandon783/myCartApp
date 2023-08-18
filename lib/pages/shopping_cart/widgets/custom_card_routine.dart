import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../user_preferences.dart';
import '../models/routine_model.dart';

class CustomCardRoutine extends StatefulWidget {
  final RoutineModel routine;
  final UserPreferences prefs;
  final Function deleteTeam;

  const CustomCardRoutine({
    super.key,
    required this.routine,
    required this.prefs,
    required this.deleteTeam,
  });

  @override
  CustomCardRoutineState createState() => CustomCardRoutineState();
}

class CustomCardRoutineState extends State<CustomCardRoutine> {
  final Gradient _gradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: const [
      0.01,
      0.4,
      0.5,
      0.6,
      0.9,
    ],
    colors: [
      Colors.purple,
      Colors.blue.shade600,
      Colors.blue.shade500,
      Colors.blue.shade500,
      Colors.blue.shade600,
      Colors.purple,
    ],
  );

  final bool _revertCard = false;

  @override
  Widget build(BuildContext context) => _generateCardTeam();

  Widget _generateCardTeam() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Container(
        height: 150.0,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.01,
              0.4,
              0.5,
              0.6,
              0.9,
            ],
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
              Colors.blue.shade400,
              Colors.blue.shade500,
              Colors.blue.shade900,
            ],
          ),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 100.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            GestureDetector(
              onTap: _routineSelected,
              child: _generateContentCard(),
            )
          ],
        ),
      ),
    );
  }

  void _routineSelected() {
    print(widget.routine.id);
    print(widget.routine.dateHistory);
    /*
    final route = MaterialPageRoute(
        builder: (context) => RoutineView()); //routine: widget.routine));
    Navigator.push(context, route);
    */
  }

  Widget _generateContentCard() => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150.0,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: const [
                      0.01,
                      0.4,
                      0.5,
                      0.6,
                      0.9,
                    ],
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade400,
                      Colors.blue.shade300,
                      Colors.blue.shade400,
                      Colors.blue.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _generateRoutine(
                        name: widget.routine.name, image: widget.routine.image),
                    if (_revertCard && widget.prefs.isLogin)
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.black.withOpacity(0.8)),
                        child: GestureDetector(
                          onTap: () => widget.deleteTeam(),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _generateRoutine({required String name, required String image}) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _generateText(text: name, fontSize: 12.0),
          ),
          Container(
            width: double.infinity,
            height: 50.0,
            padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: _generateText(
                      text: 'exercise.name'.toUpperCase(), fontSize: 12.0),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CART VALUE".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "c2000".toUpperCase(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _generateText({required String text, double fontSize = 12.0}) => Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      );

  Image imageFromBase64String() => Image.memory(
        base64Decode(widget.routine.image),
        fit: BoxFit.cover,
        height: 90.0,
      );

  Uint8List dataFromBase64String(String base64String) =>
      base64Decode(base64String);

  String base64String(Uint8List data) => base64Encode(data);
}
