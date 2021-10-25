import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;
import 'package:songs_repository/songs_repository.dart';

part 'add_song_state.dart';

class AddSongCubit extends Cubit<AddSongState> {
  AddSongCubit(
      {required FirestoreSongsRepository repository, required String id})
      : _repository = repository,
        _id = id,
        super(const AddSongState.init());

  final FirestoreSongsRepository _repository;
  final String _id;
  late final StreamSubscription _firestoreSubscription;

  void streamSongs() {
    _firestoreSubscription = _repository.songs(_id).listen(
          (songStream) => {
            // ignore: avoid_print
            print('streaming'),
            emit(AddSongState.update(songStream)),
          },
        );
  }

  Future<void> checkId() async {
    final exists = await _repository.checkId(_id);

    if (exists) {
      streamSongs();

      emit(const AddSongState.collectionExists());
    }
  }

  Future<void> updateLink() async {
    emit(state);
  }

  Future<void> addSong() async {
    Map<String, dynamic> jsonTitle;
    String title;

    final response = await http.get(Uri.parse(
        'https://www.youtube.com/oembed?url=${state.link!.value}&format=json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonTitle = jsonDecode(response.body) as Map<String, dynamic>;

      title = jsonTitle['title'].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    final output = Song(title: title, url: state.link!.value);

    await _repository.addDocument(_id, output.toEntity().toJson());

    if (state.cStatus == CollectionStatus.firstTime) {
      emit(const AddSongState.collectionExists());
      await checkId();
    }
  }

  Future<void> addSong2(String url) async {
    Map<String, dynamic> jsonTitle;
    String title;

    final response = await http.get(
        Uri.parse('https://www.youtube.com/oembed?url=${url}&format=json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      jsonTitle = jsonDecode(response.body) as Map<String, dynamic>;

      title = jsonTitle['title'].toString();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    final output = Song(title: title, url: url);

    await _repository.addDocument(_id, output.toEntity().toJson());

    if (state.cStatus == CollectionStatus.firstTime) {
      emit(const AddSongState.collectionExists());
      await checkId();
    }
  }

  void linkChanged(String value) {
    final link = Link.dirty(value);
    emit(state.copyWith(
      link: link,
      status: Formz.validate([link]),
    ));
  }

  @override
  Future<void> close() {
    _firestoreSubscription.cancel();

    // _gameRepository.removeUser(state.userId, state.game);

    return super.close();
  }
}
