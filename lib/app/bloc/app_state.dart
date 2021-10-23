part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated, inGame }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.gameId = '',
    this.userId = '',
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.inGame(String gameId, String userId)
      : this._(status: AppStatus.inGame, gameId: gameId, userId: userId);

  final AppStatus status;
  final User user;
  final String gameId;
  final String userId;

  @override
  List<Object> get props => [status, user, gameId, userId];
}
