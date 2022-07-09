import 'package:fleury_app/screens/jardins_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JardinsEphemeres extends StatefulWidget {
  const JardinsEphemeres({Key? key}) : super(key: key);

  @override
  State<JardinsEphemeres> createState() => _JardinsEphemeresState();
}

class _JardinsEphemeresState extends State<JardinsEphemeres> {
  Future<List<Jardin>> getRequest() async {
    var url = Uri.parse(
        'https://data.orleans-metropole.fr/api/records/1.0/search/?dataset=environnementjardins_ephemeres&q=&facet=categorie&facet=emplacement');

    final response = await http.get(url);

    var responseData = jsonDecode(response.body)['records'];

    //print(responseData);

    List<Jardin> jardins = [];
    for (var u in responseData) {
      Jardin jardin = Jardin(
        name: u['fields']['nom'],
        imageurl: u['fields']['image'],
        coords: u['fields']['geo_shape']['coordinates'],
        createur: u['fields']['societe'],
      );
      //Adding user to the list.
      jardins.add(jardin);
    }
    return jardins;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5.0),
      child: FutureBuilder(
        future: getRequest(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              //child: CircularProgressIndicator(),
              child: SpinKitFadingCube(
                color: Colors.deepPurple,
                duration: Duration(seconds: 10),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                final jardin = snapshot.data[index];
                return Container(
                  margin: const EdgeInsets.only(
                      left: 10, top: 10, right: 10, bottom: 10),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(8, 8),
                    ),
                  ]),
                  child: Card(
                    child: Center(
                      child: ListTile(
                        title: Text(snapshot.data[index].name),
                        //subtitle: Text(snapshot.data[index].adresse),
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(snapshot.data[index].imageurl),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JardinsPage(
                                        jardin: jardin,
                                      )));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

//Creating a class user to store the data;
class Jardin {
  final String name;
  final String imageurl;
  final List coords;
  final String createur;

  Jardin({
    required this.name,
    required this.imageurl,
    required this.coords,
    required this.createur,
  });
}
