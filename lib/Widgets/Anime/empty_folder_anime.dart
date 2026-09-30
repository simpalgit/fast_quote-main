import 'package:flutter/material.dart';

class AnimatedFolder extends StatefulWidget {
  final bool isOpen;
  final Duration duration;
  final Color folderColor;
  final Color iconColor;

  const AnimatedFolder({
    super.key,
    required this.isOpen,
    required this.duration,
    required this.folderColor,
    required this.iconColor,
  });

  @override
  _AnimatedFolderState createState() => _AnimatedFolderState();
}

class _AnimatedFolderState extends State<AnimatedFolder> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      width: widget.isOpen ? 100 : 50,
      height: 70,
      decoration: BoxDecoration(
        color: widget.folderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isOpen ? Icons.folder_open : Icons.folder,
            color: widget.iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            widget.isOpen ? 'Open' : 'Closed',
            style: TextStyle(color: widget.iconColor),
          ),
        ],
      ),
    );
  }
}
