import 'package:aflam/core/models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.result});
  final Results? result;
  String get imageUrl {
    try {
      if (result!.posterPath != null &&
          result!.posterPath!.isNotEmpty &&
          result!.posterPath!.trim().isNotEmpty) {
        return "https://image.tmdb.org/t/p/w500${result!.posterPath}";
      }
    } catch (e) {
      debugPrint('Error constructing image URL: $e');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result?.title ?? 'Movie Details'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag:
                      'grid_${result?.id}_${imageUrl.hashCode}', // Match the hero tag from home screen
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  result?.title ?? 'Unknown Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Plus Jakarta Sans",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Release Date: ${result?.releaseDate ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.redAccent,
                    fontFamily: "Plus Jakarta Sans",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result?.overview ?? 'No Overview Available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: "Plus Jakarta Sans",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Rating: "),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.star,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        Text(
                          ' ${result?.voteAverage?.toStringAsFixed(1) ?? 'Unknown'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontFamily: "Plus Jakarta Sans",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (result?.adult == true)
                  Text(
                    "for Adults Only",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontFamily: "Plus Jakarta Sans",
                    ),
                  ),
                const SizedBox(height: 16),
                // add to favorites button
                ElevatedButton(
                  onPressed: () {
                    try {
                      final favoritesBox = Hive.box('favorites');

                      // Check if movie is already in favorites
                      bool isAlreadyFavorite = false;
                      for (var item in favoritesBox.values) {
                        if (item is Results && item.id == result?.id) {
                          isAlreadyFavorite = true;
                          break;
                        }
                      }

                      if (isAlreadyFavorite) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Movie is already in favorites!"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      } else {
                        favoritesBox.add(result);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added to Favorites"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        print(
                          "Added to Favorites: ${favoritesBox.length} items",
                        );
                      }
                    } catch (e) {
                      print("Error adding to favorites: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error adding to favorites"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("Add to Favorites"),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
