import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fleury_app/screens/jeux_enfant_details.dart';

class JeuxEnfants extends StatefulWidget {
  const JeuxEnfants({Key? key}) : super(key: key);

  @override
  State<JeuxEnfants> createState() => _JeuxEnfantsState();
}

class _JeuxEnfantsState extends State<JeuxEnfants> {
  Future<List<Jeu>> getRequest() async {
    var url = Uri.parse(
        'https://data.orleans-metropole.fr/api/records/1.0/search/?dataset=aires-de-jeux-pour-enfants-a-fleury-les-aubrais&q=&facet=adr_commune&facet=equp_acces_lib&facet=equip_email&facet=equip_marque&facet=equip_instal');

    final response = await http.get(url);

    var responseData = jsonDecode(response.body)['records'];

    //print(responseData);

    List<Jeu> jeux = [];
    for (var u in responseData) {
      Jeu jeu = Jeu(
          name: u['fields']['equip_site'],
          adresse: u['fields']['adr_nomvoie'],
          categorie: u['fields']['equip_cat_age'],
          sol: u['fields']['equip_sol'],
          coords: u['fields']['coordonnees_geo'],
          nomVoie: u['fields']['adr_nomvoie'],
          commune: u['fields']['adr_commune']);
      //Adding user to the list.
      jeux.add(jeu);
    }
    return jeux;
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
                final jeu = snapshot.data[index];
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
                  //height: 150,
                  child: Card(
                    // elevation: 10,
                    // shadowColor: Colors.purple,
                    child: Center(
                      child: ListTile(
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].adresse),
                        leading: const Icon(
                          Icons.child_care_sharp,
                          color: Colors.black,
                        ),
                        //contentPadding: EdgeInsets.only(bottom: 20.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JeuxPage(
                                        jeu: jeu,
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
class Jeu {
  final String name;
  final String adresse;
  final String categorie;
  final String sol;
  final List coords;
  final String nomVoie;
  final String commune;

  Jeu({
    required this.name,
    required this.adresse,
    required this.categorie,
    required this.sol,
    required this.coords,
    required this.nomVoie,
    required this.commune,
  });
}
