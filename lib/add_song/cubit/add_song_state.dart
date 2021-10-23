part of 'add_song_cubit.dart';

enum CollectionStatus {
  firstTime,
  returned,
}

class AddSongState extends Equatable {
  const AddSongState._({
    this.link = const Link.pure(),
    this.status = FormzStatus.pure,
    this.cStatus = CollectionStatus.firstTime,
    this.songs = const [Song(title: 'No Alarm Set', url: 'url')],
  });

  const AddSongState.init() : this._();

  const AddSongState.collectionExists()
      : this._(cStatus: CollectionStatus.returned);

  const AddSongState.update(List<Song> songs)
      : this._(songs: songs, cStatus: CollectionStatus.returned);

  final Link? link;
  final FormzStatus? status;
  final CollectionStatus? cStatus;
  final List<Song>? songs;

  @override
  List<Object?> get props => [link, status, songs, cStatus];

  AddSongState copyWith({
    Link? link,
    FormzStatus? status,
    List<Song>? songs,
    CollectionStatus? cStatus,
  }) {
    return AddSongState._(
      link: link ?? this.link,
      status: status ?? this.status,
      songs: songs ?? this.songs,
      cStatus: cStatus ?? this.cStatus,
    );
  }
}
