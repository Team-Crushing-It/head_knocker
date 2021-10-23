import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:songs_repository/songs_repository.dart';
import 'entities/entities.dart';
import 'package:cache/cache.dart';
import 'package:meta/meta.dart';

/// Thrown during check game if no game exists
class JoinGameFailure implements Exception {}

/// {@template firestore_game_repository}
/// Repository which manages the game in firestore.
/// {@endtemplate}
class FirestoreSongsRepository {
  /// {@macro authentication_repository}
  FirestoreSongsRepository({
    CacheClient? cache,
  }) : _cache = cache ?? CacheClient();

  final CacheClient _cache;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const gameCacheKey = '__game_cache_key__';

  final alarmsCollection = FirebaseFirestore.instance.collection('alarms');

  Stream<List<Song>> songs(String id) {
    return FirebaseFirestore.instance
        .collection(id)
        .orderBy('created')
        .snapshots()
        .map((query) {
      return query.docs.map((song) {
        final songs = Song.fromEntity(SongEntity.fromSnapshot(song));
        return songs;
      }).toList();
    });
  }

  Future<bool> checkId(String id) async {
    final check = await FirebaseFirestore.instance
        .collection(id)
        .limit(1)
        .get()
        .then((query) => query.size);

    final output = check > 0 ? true : false;

    return output;
  }

  Future<void> createCollection(String id, Song song) async {
    print('id create collection: $id');
    // FirebaseFirestore.instance.collection(id).add(
    //       song.toEntity().toJson(Timestamp.now().toString()),
    //     );
  }

  Future<void> addDocument(
      String collection, Map<String, Object?> object) async {
    //TODO: scrape actual title

    final timeStamp = Timestamp.now().toString();

    object['created'] = timeStamp;

    print(object);

    FirebaseFirestore.instance.collection(collection).add(object);
  }
}
