import 'package:flutter/material.dart';

class ProfileImageSelector extends StatelessWidget {
  final image;
  final String title;
  const ProfileImageSelector(
      {super.key, required this.image, required this.title, });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
            child: image,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(title),
      ],
    );
  }
}
