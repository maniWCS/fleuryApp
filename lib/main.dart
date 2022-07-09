import 'package:flutter/material.dart';
import 'package:fleury_app/screens/fresques.dart';
import 'package:fleury_app/screens/jardins_ephemeres.dart';
import 'package:fleury_app/screens/jeux_enfant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white,
              indicator: ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                          style: BorderStyle.solid)),
                  gradient: LinearGradient(
                      colors: [Color(0xd697dbff), Color(0xd126e0)])),
              tabs: [
                Tab(
                  icon: Icon(Icons.child_care),
                  child: Text('Jeux'),
                ),
                Tab(
                  icon: Icon(Icons.museum),
                  child: Text('Fresques'),
                ),
                Tab(
                  icon: Icon(Icons.forest),
                  child: Text('Jardins'),
                ),
              ],
            ),
            title: const Text('MyOrléans'),
            backgroundColor: Colors.purple[900],
          ),
          body: const TabBarView(
            children: [
              JeuxEnfants(),
              FresquesMusee(),
              JardinsEphemeres(),
            ],
          ),
        ),
      ),
    );
  }
}
