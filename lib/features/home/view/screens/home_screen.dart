import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/core/router/app_router.dart';
import 'package:aflam/features/home/view/widgets/home_section/home_header.dart';
import 'package:aflam/features/home/view_model/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieModel? topRatedMovies;
  MovieModel? allMovies;
  MovieModel? searchResults;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          try {
            if (state is HomeLoaded) {
              topRatedMovies = state.movieModel;
            }
            if (state is HomeLoadedAllMovies) {
              allMovies = state.movieModel;
            }
            if (state is HomeError) {
              // Handle error state
              debugPrint('Home error: ${state.message}');
            }
            if (state is HomeSearchLoaded) {
              // Handle search results
              searchResults = state.movieModel;
            }
          } catch (e) {
            debugPrint('Error in BlocConsumer listener: $e');
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      onClear: () {
                        // Clear search results
                        setState(() {
                          searchResults = null;
                        });
                      },
                    ),
                  ),
                  if (state is HomeSearchLoaded && searchResults != null) ...[
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Text("Search Results"),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: NewestMovies(movieModel: searchResults!),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Newest Movies Section Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Newest Movies",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Plus Jakarta Sans",
                        ),
                      ),
                    ),
                  ),
                  // Newest Movies Horizontal List
                  SliverToBoxAdapter(
                    child: NewestMovies(
                      movieModel: topRatedMovies ?? MovieModel(),
                    ),
                  ),
                  // All Movies Section Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "All Movies",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Plus Jakarta Sans",
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Page ${allMovies?.page ?? 1}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontFamily: "Plus Jakarta Sans",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // Extra safety check to prevent index out of bounds
                        if (allMovies?.results == null ||
                            index >= (allMovies?.results?.length ?? 0)) {
                          return const SizedBox.shrink();
                        }

                        return MovieItem(
                          result: allMovies!.results![index],
                         
                        );
                      }, childCount: allMovies?.results?.length ?? 0),
                    ),
                  ),

                  // Add some bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: MoviesPagesFooter(
                      movieModel: allMovies ?? MovieModel(),
                      onPageChanged: () {
                        // Handle page change
                        scrollController.jumpTo(0);
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                ],
              ),
              // Show loading indicator while fetching movies
              if (state is HomeLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}

class MoviesPagesFooter extends StatelessWidget {
  const MoviesPagesFooter({
    super.key,
    required this.movieModel,
    required this.onPageChanged,
  });
  final MovieModel movieModel;
  final Function() onPageChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("Pages"),
          Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              if (movieModel.page! > 1) {
                // Handle previous page action
                context.read<HomeCubit>().fetchAllMovies(
                  page: movieModel.page! - 1,
                );
                onPageChanged();
              }
            },
          ),
          Text("${movieModel.page}"),

          Text(".... ${movieModel.totalPages}"),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              // Handle next page action
              context.read<HomeCubit>().fetchAllMovies(
                page: movieModel.page! + 1,
              );
              onPageChanged();
            },
          ),
        ],
      ),
    );
  }
}

class NewestMovies extends StatelessWidget {
  const NewestMovies({super.key, required this.movieModel});
  final MovieModel movieModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: (movieModel.results?.isEmpty ?? true)
          ? const Center(
              child: Text(
                'No movies available',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 8),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movieModel.results?.length ?? 0,
              itemBuilder: (context, index) {
                // Extra safety check to prevent crashes
                if (movieModel.results == null ||
                    index >= (movieModel.results?.length ?? 0)) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: MovieItem(
                    result: movieModel.results![index],
                   
                  ),
                );
              },
            ),
    );
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({super.key, required this.result});
  
  final Results result;

  String get imageUrl {
    try {
      if (result.posterPath != null &&
          result.posterPath!.isNotEmpty &&
          result.posterPath!.trim().isNotEmpty) {
        return "https://image.tmdb.org/t/p/w500${result.posterPath}";
      }
    } catch (e) {
      debugPrint('Error constructing image URL: $e');
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        context.push(AppRouter.details,extra: result);
      },
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        key: ValueKey(
                          imageUrl,
                        ), // Add key to prevent widget conflicts
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        // Reduced memory cache to prevent crashes
                        memCacheWidth: 300,
                        memCacheHeight: 450,
                        // Add timeout to prevent hanging
                        httpHeaders: const {'Connection': 'keep-alive'},
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          // Log error for debugging
                          debugPrint(
                            'Image loading error: $error for URL: $url',
                          );
                          return _buildErrorWidget();
                        },
                      )
                    : _buildErrorWidget(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.title ?? "Movie Title",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: "Plus Jakarta Sans",
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey[600], size: 30),
          const SizedBox(height: 4),
          Text(
            "No Image",
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }
}
