import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
            decoration: InputDecoration(
              filled: true, // Make the background color of the TextField
              fillColor: const Color(
                0xFF2F1F1A,
              ), // Set background color similar to the image
              hintText: 'Search', // Placeholder text
              hintStyle: const TextStyle(
                color: Color(0xFFB6A09A), // Color for the hint text
              ),
              prefixIcon: const Icon(
               CupertinoIcons.search,
                color: Color(0xFFB6A09A), // Icon color
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                borderSide: BorderSide.none, // No border line
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
            ),
            onTapOutside: (event) => FocusScope.of(context).requestFocus( FocusNode()),
          );
  }
}