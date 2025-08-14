// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aflam/features/marked/view/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/features/marked/view/widgets/empty_faviorite.dart';
import 'package:aflam/features/marked/view/widgets/faviorite_listview.dart';

class MarkedFaveroitsMoviesScreen extends StatelessWidget {
  const MarkedFaveroitsMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: Hive.box('favorites').listenable(),
          builder: (context, Box<dynamic> box, _) {
            return Text("Favorites (${box.length})");
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('favorites').listenable(),
              builder: (context, Box<dynamic> box, _) {
                if (box.values.isEmpty) {
                  return EmptyFaviroiteCustom();
                }
                final favoriteMovies = box.values.cast<Results>().toList();
                return FavioriteListview(favoriteMovies: favoriteMovies);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, Box<dynamic> box, _) {
          if (box.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () async {
              final shouldClear = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialogCustom(
                  title: "Are you sure you want to clear all favorites?",
                  buttonText: "Clear All",
                  text: "Remove All From Favorites.",
                ),
              );

              if (shouldClear == true) {
                box.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("All favorites cleared"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.clear_all),
            label: const Text("Clear All"),
            backgroundColor: Colors.red,
          );
        },
      ),
    );
  }
}
