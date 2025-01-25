import 'package:flutter/material.dart';
import '../../theme/bloc/bloc.dart';
import '../../theme/bloc/state.dart';
import '../../utils/sharedpref.dart';
import '../../widgets/interactive_image_viewer.dart';
import '../../widgets/show_adoption_popup.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import your theme bloc

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.petDetails, this.onAdopt});
  final Map<String, dynamic> petDetails;
  final VoidCallback? onAdopt;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> adoptedPetsIDS = [];

  @override
  void initState() {
    getListString();
    super.initState();
  }

  getListString() {
    adoptedPetsIDS = SharedPref.getListString(SharedPref.adoptedPetsIds);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          // Use the current theme state to determine the button's appearance
          return FloatingActionButton.extended(
            onPressed: () {
              if (adoptedPetsIDS.contains(widget.petDetails['id'])) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Already adopted")),
                );
                return;
              }
              widget.onAdopt?.call();
              adoptedPetsIDS.insert(0, widget.petDetails['id']);
              SharedPref.setListString(SharedPref.adoptedPetsIds, adoptedPetsIDS);
              showAdoptionPopup(
                context,
                {'name': widget.petDetails['name']}, // Replace 'Buddy' with the adopted pet's name.
              );
              setState(() {});
            },
            label: Text(
              adoptedPetsIDS.contains(widget.petDetails['id'])
                  ? 'Adopted'
                  : "Adopt Me",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: adoptedPetsIDS.contains(widget.petDetails['id'])
                ? Colors.grey
                : Colors.orange,
            icon: const Icon(Icons.pets),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView( // Added SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.73),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.petDetails['description'],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: size.height * 0.7,
              width: size.width,
              decoration: BoxDecoration(
                color: Color(
                  int.parse(widget.petDetails['color'].replaceFirst('#', '0xff')),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InteractiveImageViewer(
                                  imageUrl: widget.petDetails['imageUrl']!,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: widget.petDetails['imageUrl'],
                            child: Image.network(
                              widget.petDetails['imageUrl'],
                              height: size.height * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ageSexOrigin(widget.petDetails['age'], "Age"),
                            ageSexOrigin(widget.petDetails['price'], "Price"),
                            ageSexOrigin(widget.petDetails['name'], "Name"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container ageSexOrigin(value, name) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}

