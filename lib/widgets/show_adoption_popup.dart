import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_assets.dart';

class AdoptionPopup extends StatelessWidget {
  final Map<String, String> petDetails;

  const AdoptionPopup({super.key, required this.petDetails});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            AppAsset.adoptMeShower,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            "You’ve now\nadopted ${petDetails['name']}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Example usage in your app:
void showAdoptionPopup(BuildContext context, Map<String, String> petDetails) {
  showDialog(
    context: context,
    builder: (context) => AdoptionPopup(petDetails: petDetails),
  );
}
