import 'package:aflam/features/home/view_model/cubit/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchTextField extends StatelessWidget {
   CustomSearchTextField({super.key, required this.onClear});
final Function() onClear;
final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
            onSubmitted: (value) {
              if (value.isEmpty) {
                onClear();
              } else {
                context.read<HomeCubit>().searchMovies(value);
              } 
            },
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
              suffixIcon:  IconButton(
                onPressed:(){
                   onClear();
                   FocusScope.of(context).unfocus();
                   controller.clear();
                   controller.dispose();
                },
                icon: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Color(0xFFB6A09A), // Clear icon color
                ),
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