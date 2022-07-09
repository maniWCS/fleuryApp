import 'package:fleury_app/screens/fresques.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class FresquesPage extends StatefulWidget {
  final Fresque fresque;
  const FresquesPage({Key? key, required this.fresque}) : super(key: key);

  @override
  State<FresquesPage> createState() => _FresquesPageState();
}

class _FresquesPageState extends State<FresquesPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarker(LatLng(widget.fresque.coords[0], widget.fresque.coords[1]));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
          infoWindow: InfoWindow(title: widget.fresque.name),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.fresque.name),
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
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text('Localisation'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${widget.fresque.numvoie.toString()}, ${widget.fresque.adresse}, ${widget.fresque.commune}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text('Artiste'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(widget.fresque.artiste,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text('Date de création'),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.fresque.dateCreation,
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
            target: LatLng(widget.fresque.coords[0], widget.fresque.coords[1]),
            zoom: 16.0),
        zoomGesturesEnabled: true,
      ),
    );
  }
}
