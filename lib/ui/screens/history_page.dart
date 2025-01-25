import 'package:flutter/material.dart';

import '../../utils/data.dart';
import '../../utils/sharedpref.dart';
import '../../widgets/custom_image.dart';

class AdoptionHistoryScreen extends StatefulWidget {

  const AdoptionHistoryScreen({super.key});

  @override
  State<AdoptionHistoryScreen> createState() => _AdoptionHistoryScreenState();
}

class _AdoptionHistoryScreenState extends State<AdoptionHistoryScreen> {
  List<String> adoptedPetsIDS = [];
  List<Map<String, dynamic>> adoptedPets = [];
  @override
  void initState() {
    getListString();
    super.initState();
  }
  getListString(){
    var adoptedPetsIDS = SharedPref.getListString(SharedPref.adoptedPetsIds);
     adoptedPets = pets
        .where((pet) => adoptedPetsIDS.contains(pet['id']))
        .toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
          title: const Text("Adoption History"),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
      ),
      body: SafeArea(

        child: adoptedPets.isNotEmpty
            ? ListView.builder(
          itemCount: adoptedPets.length,
          itemBuilder: (context, index) {
            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImage(index),
            );
          },
        )
            : const Center(child: Text("No pets adopted yet.")),
      ),
    );
  }

  Widget _buildImage(int index) {
    return CustomImage(
      adoptedPets[index]['image'],
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
        bottom: Radius.zero,
      ),
      isShadow: false,
      width: double.infinity,
      height: 350,
    );
  }
}