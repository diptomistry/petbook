import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({Key? key}) : super(key: key);

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  List<CameraDescription> cameras = [];
  late CameraController controller;
  bool _isCameraReady = false;
  late XFile? _imageFile;

  static ResolutionPreset resolutionPreset = ResolutionPreset.high;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      controller = CameraController(cameras[0], resolutionPreset);
      // Initialize the camera (usually use cameras[0] for the back camera)
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isCameraReady = true;
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _takePhoto() async {
    if (!_isCameraReady) return;
    try {
      final XFile? file = await controller.takePicture();
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  void _savePhoto() {
    // Implement photo saving logic here.
    // You can use the _imageFile variable to access the captured image.
    // For example, you can copy it to a desired location.
    // Make sure to check if _imageFile is not null before saving.
  }

  void _toggleCameraDirection() {
    // Toggle between front and back cameras.
    final CameraLensDirection newDirection =
        controller.description.lensDirection == CameraLensDirection.front
            ? CameraLensDirection.back
            : CameraLensDirection.front;
    for (final camera in cameras) {
      if (camera.lensDirection == newDirection) {
        controller = CameraController(camera, resolutionPreset);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Update the camera direction.
          });
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          _isCameraReady
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: CameraPreview(controller),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _takePhoto,
                iconSize: 48,
              ),
              IconButton(
                icon: Icon(Icons.save_as_outlined),
                onPressed: () {
                  // if (_imageFile != null) {
                  //   _savePhoto;
                  // }
                },
                //_imageFile != null ? _savePhoto
                // : null,
                iconSize: 48,
              ),
              IconButton(
                icon: Icon(Icons.switch_camera_outlined),
                onPressed: () {
                  if (_isCameraReady) _toggleCameraDirection();
                },

                //  : null,
                iconSize: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
