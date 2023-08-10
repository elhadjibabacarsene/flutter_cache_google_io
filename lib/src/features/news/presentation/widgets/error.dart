import 'package:flutter/material.dart';
import 'package:flutter_gallery_cache/src/constants/colors/app_colors.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: gray03,
            size: 80,
          ),
          SizedBox(height: 10,),
          Text('Une erreur est survenue.', style: TextStyle(fontSize: 16),)
        ],
      ),
    );
  }
}
