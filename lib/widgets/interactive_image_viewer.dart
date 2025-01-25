import 'package:flutter/material.dart';

class InteractiveImageViewer extends StatefulWidget {
  final String imageUrl;

  const InteractiveImageViewer({super.key, required this.imageUrl});

  @override
  State<InteractiveImageViewer> createState() => _InteractiveImageViewerState();
}

class _InteractiveImageViewerState extends State<InteractiveImageViewer> {
  final TransformationController _transformationController =
  TransformationController();
  bool _isZoomedIn = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_isZoomedIn) {
      _transformationController.value = Matrix4.identity();
    } else {
      _transformationController.value = Matrix4.identity()
        ..scale(2.0); // Zoom in by a factor of 2
    }
    setState(() {
      _isZoomedIn = !_isZoomedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: widget.imageUrl,
          child: GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.network(widget.imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}