import 'package:flutter/material.dart';
import 'package:fleury_app/screens/jeux_enfant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class JeuxPage extends StatefulWidget {
  final Jeu jeu;
  const JeuxPage({Key? key, required this.jeu}) : super(key: key);

  @override
  State<JeuxPage> createState() => _JeuxPageState();
}

class _JeuxPageState extends State<JeuxPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarker(LatLng(widget.jeu.coords[0], widget.jeu.coords[1]));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
          infoWindow: InfoWindow(title: widget.jeu.name),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.jeu.name),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, right: 25.0),
        child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height / 3,
                  color: const Color(0xff757575),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Catégorie âge'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.jeu.categorie,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text('Type de sol'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.jeu.sol,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text('Emplacement'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${widget.jeu.nomVoie}, ${widget.jeu.commune}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.jeu.coords[0], widget.jeu.coords[1]),
            zoom: 16.0),
        zoomGesturesEnabled: true,
      ),
    );
  }
}
