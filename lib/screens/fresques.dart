import 'package:fleury_app/screens/fresques_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FresquesMusee extends StatefulWidget {
  const FresquesMusee({Key? key}) : super(key: key);

  @override
  State<FresquesMusee> createState() => _FresquesMuseeState();
}

class _FresquesMuseeState extends State<FresquesMusee> {
  Future<List<Fresque>> getRequest() async {
    var url = Uri.parse(
        'https://data.orleans-metropole.fr/api/records/1.0/search/?dataset=fresques-du-musee-a-ciel-ouvert-de-fleury-les-aubrais&q=');

    final response = await http.get(url);

    var responseData = jsonDecode(response.body)['records'];

    //print(responseData);

    List<Fresque> fresques = [];
    for (var u in responseData) {
      Fresque fresque = Fresque(
          name: u['fields']['nom_fresque'],
          adresse: u['fields']['adr_voie'],
          numvoie: u['fields']['adr_num'],
          coords: u['fields']['coordonnees_geo'],
          commune: u['fields']['com_nom'],
          artiste: u['fields']['nom_artiste'],
          dateCreation: u['fields']['date_creation']);

      //Adding user to the list.
      fresques.add(fresque);
    }
    return fresques;
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
                final fresque = snapshot.data[index];
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
                        subtitle: Text(snapshot.data[index].adresse),
                        leading: const Icon(
                          Icons.palette_outlined,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FresquesPage(
                                        fresque: fresque,
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
class Fresque {
  final String name;
  final String adresse;
  final int numvoie;
  final String commune;
  final List coords;
  final String artiste;
  final String dateCreation;

  Fresque({
    required this.name,
    required this.adresse,
    required this.numvoie,
    required this.commune,
    required this.coords,
    required this.artiste,
    required this.dateCreation,
  });
}
