import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/features/marked/view/widgets/alert_dailog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({super.key, required this.movie});

  final Results movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        movie.title ?? "Unknown Title",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        movie.overview ?? "No Description",
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(CupertinoIcons.delete, size: 20, color: Colors.red),
        onPressed: () async {
          // Show confirmation dialog
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialogCustom(
              title:
                  "Are you sure you want to remove '${movie.title}' from favorites?",
              buttonText: "Remove",
              text: "Remove From Favorites.",
            ),
          );

          if (shouldDelete == true) {
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${movie.title} removed from favorites"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Movie not found in favorites"),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            }
          }
        },
      ),
      leading: movie.posterPath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                width: 50,
                height: 75,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            )
          : Container(
              width: 50,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie),
            ),
    );
  }
}
