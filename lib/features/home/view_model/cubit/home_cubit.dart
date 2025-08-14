import 'package:aflam/core/models/movie_model.dart';
import 'package:aflam/core/services/api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> fetchTopRatedMovies() async {
    emit(HomeLoading());
    try {
      final movieModel = await Api().getTopRatedMovies();
      emit(HomeLoaded(movieModel));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }


  // get all movies by page
  Future<void> fetchAllMovies({int page = 1}) async {
    emit(HomeLoading());
    try {
      final movieModel = await Api().getAllMovies(page: page);
      emit(HomeLoadedAllMovies(movieModel));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // search for movies
  Future<void> searchMovies(String query) async {
    emit(HomeLoading());
    try {
      final movieModel = await Api().searchMovies(query);
      emit(HomeSearchLoaded(movieModel));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
