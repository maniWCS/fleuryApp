import 'package:fleury_app/screens/jardins_ephemeres.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class JardinsPage extends StatefulWidget {
  final Jardin jardin;
  const JardinsPage({Key? key, required this.jardin}) : super(key: key);

  @override
  State<JardinsPage> createState() => _JardinsPageState();
}

class _JardinsPageState extends State<JardinsPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarker(LatLng(widget.jardin.coords[1], widget.jardin.coords[0]));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
          infoWindow: InfoWindow(title: widget.jardin.name),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.jardin.name),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, right: 25.0),
        child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color(0xff757575),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                child: Image.network(widget.jardin.imageurl)),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text('Créateur'),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              widget.jardin.createur,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.jardin.coords[1], widget.jardin.coords[0]),
            zoom: 16.0),
        zoomGesturesEnabled: true,
      ),
    );
  }
}
