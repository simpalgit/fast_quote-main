import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureCapturePage extends StatefulWidget {
  const SignatureCapturePage({super.key});

  @override
  _SignatureCapturePageState createState() => _SignatureCapturePageState();
}

class _SignatureCapturePageState extends State<SignatureCapturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5, // Customize the stroke width as needed
    penColor: Colors.black, // Customize the pen color
    exportBackgroundColor: Colors.white, // Customize the background color
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature Capture'),
      ),
      body: Column(
        children: [
          // Signature Pad Widget
          Signature(
            controller: _controller,
            height: 300, // Set the desired height
            backgroundColor: Colors.white, // Customize the background color
          ),
          const SizedBox(height: 20),
          // Save Button
          ElevatedButton(
            onPressed: () async {
              // Capture the signature as an image
              final signatureImage = await _controller.toPngBytes();

              if (signatureImage != null) {
                // Save the image to a file or do something else with it
                // In this example, we are just displaying it as an image
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Captured Signature'),
                      content: Image.memory(signatureImage),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Save Signature'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignatureCapturePage(),
  ));
}
