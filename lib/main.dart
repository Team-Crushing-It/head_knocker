import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:songs_repository/songs_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:head_knocker/app/app.dart';
import 'package:head_knocker/app/app_bloc_observer.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  final songsRepository = FirestoreSongsRepository();

  runZonedGuarded(
    () => runApp(App(
      authenticationRepository: authenticationRepository,
      songsRepository: songsRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
