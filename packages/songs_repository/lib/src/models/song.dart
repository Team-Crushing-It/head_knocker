import 'package:equatable/equatable.dart';
import 'package:songs_repository/songs_repository.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Song extends Equatable {
  const Song({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  List<Object> get props => [title, url];

  Song copyWith({String? url, String? title}) {
    return Song(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  @override
  String toString() {
    return 'Song{title: $title}';
  }

  SongEntity toEntity() {
    return SongEntity(title, url);
  }

  static Song fromEntity(SongEntity entity) {
    return Song(
      title: entity.title,
      url: entity.url,
    );
  }
}
