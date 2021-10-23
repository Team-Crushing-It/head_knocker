part of 'home_cubit.dart';

enum HomeStatus { init, loaded, firstTime, returned }

class HomeState extends Equatable {
  const HomeState._({
    this.status = HomeStatus.init,
  });

  const HomeState.init() : this._(status: HomeStatus.init);

  const HomeState.loaded() : this._(status: HomeStatus.loaded);

  final HomeStatus status;

  @override
  List<Object> get props => [status];
}
