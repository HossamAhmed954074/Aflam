import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/features/marked/view/widgets/faviorite_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavioriteListview extends StatelessWidget {
  const FavioriteListview({super.key, required this.favoriteMovies});

  final List<Results> favoriteMovies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = favoriteMovies[index];
        return Dismissible(
          key: Key('movie_${movie.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 24),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Remove from Favorites"),
                content: Text(
                  "Are you sure you want to remove '${movie.title}' from favorites?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Remove",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            // Handle removal from favorites
            final box = Hive.box('favorites');

            // Find the correct key for this movie
            dynamic keyToDelete;
            for (var key in box.keys) {
              var item = box.get(key);
              if (item is Results && item.id == movie.id) {
                keyToDelete = key;
                break;
              }
            }

            // Delete the movie if found
            if (keyToDelete != null) {
              box.delete(keyToDelete);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${movie.title} removed from favorites"),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.white,
                    onPressed: () {
                      // Re-add the movie to favorites
                      box.add(movie);
                      // No need for setState - ValueListenableBuilder handles it
                    },
                  ),
                ),
              );
            }
          },
          child: FavoriteItem(movie: movie),
        );
      },
    );
  }
}
