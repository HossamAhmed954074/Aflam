import 'package:aflam/features/home/view/widgets/home_section/custom_text_field.dart';
import 'package:flutter/cupertino.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onClear});
  final Function() onClear;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        children: [
          Text(
            "Movie Catalog",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Plus Jakarta Sans",
            ),
          ),
          SizedBox(height: 16),
          CustomSearchTextField(onClear: onClear),
        ],
      ),
    );
  }
}