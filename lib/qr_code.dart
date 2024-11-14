import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _controller.analyzeImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Qrcode'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _scanFromGallery,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            child: MobileScanner(
              controller: _controller,
              onDetect: (result) {
                List<Barcode> results = result.barcodes;
                final Uint8List? image = result.image;

                for (final barcode in results) {
                  print(barcode.rawValue);
                }
                if (image != null) {
                  _showImage(results.first.rawValue, image: image);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImage(String? value, {required Uint8List image}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(value ?? '-'),
          content: Image(
            image: MemoryImage(image),
          ),
        );
      },
    );
  }
}
