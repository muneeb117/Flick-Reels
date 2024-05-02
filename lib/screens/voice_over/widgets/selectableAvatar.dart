import 'package:flutter/material.dart';

class SelectableAvatar extends StatefulWidget {
  final ImageProvider imageProvider;
  final bool isSelected;
  final Function onTap;
  final Color backgroundColor;

  SelectableAvatar({
    required this.imageProvider,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  _SelectableAvatarState createState() => _SelectableAvatarState();
}

class _SelectableAvatarState extends State<SelectableAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: widget.backgroundColor,

          backgroundImage: widget.imageProvider,
          radius: 40,
        ),
      ),
    );
  }
}
