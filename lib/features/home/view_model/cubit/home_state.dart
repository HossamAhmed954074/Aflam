part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeLoaded extends HomeState {
  final MovieModel movieModel;

  HomeLoaded(this.movieModel);
}
final class HomeSearchLoaded extends HomeState {
  final MovieModel movieModel;

  HomeSearchLoaded(this.movieModel);
}
final class HomeLoadedAllMovies extends HomeState {
  final MovieModel movieModel;

  HomeLoadedAllMovies(this.movieModel);
}
final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}


