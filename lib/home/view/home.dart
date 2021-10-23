// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:head_knocker/add_song/add_song.dart';
import 'package:head_knocker/home/cubit/home_cubit.dart';
import 'package:head_knocker/home/flows/flows.dart';
import 'package:head_knocker/home/widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loaded) {
          return const HomePage();
        }
        return const HNLoad();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var alarmSelect = false;
  var lockSelect = true;

  @override
  Widget build(BuildContext context) {
    final songs = context.watch<AddSongCubit>().state.songs;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.black12,
        elevation: 0,
        onPressed: () {},
        child: const Icon(Icons.settings),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
            height: 420,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFF343434),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Connected BUtton =======================
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[500],
                      elevation: 3,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Connected',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Lexus ES',
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Image.asset(
                      'assets/lexus.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              alarmSelect = !alarmSelect;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 3,
                              color: Colors.grey[500]!,
                            ),
                            elevation: alarmSelect ? 0 : 3,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            primary: alarmSelect
                                ? Colors.transparent
                                : Colors.grey[500], // <-- Button color
                            onPrimary: Colors.red, // <-- Splash color
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color:
                                alarmSelect ? Colors.grey[500] : Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              lockSelect = !lockSelect;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              width: 3,
                              color: Colors.grey[500]!,
                            ),
                            elevation: lockSelect ? 0 : 3,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            primary: lockSelect
                                ? Colors.transparent
                                : Colors.grey[500], // <-- Button color
                            onPrimary: Colors.red, // <-- Splash color
                          ),
                          child: Icon(
                            Icons.vpn_key,
                            color: lockSelect ? Colors.grey[500] : Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications_active,
                      size: 32, color: Theme.of(context).highlightColor),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ALARM',
                          style: Theme.of(context).textTheme.headline1),
                      if (songs!.isEmpty)
                        Text('No alarm songs set',
                            style: Theme.of(context).textTheme.headline2)
                      else
                        Text(
                            context
                                .watch<AddSongCubit>()
                                .state
                                .songs!
                                .last
                                .title,
                            style: Theme.of(context).textTheme.headline2),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Theme.of(context).highlightColor),
                  onTap: () {
                    Navigator.of(context).pushNamed('/addSong');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.vpn_key,
                      size: 32, color: Theme.of(context).highlightColor),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOCK',
                          style: Theme.of(context).textTheme.headline1),
                      Text('Locked',
                          style: Theme.of(context).textTheme.headline2),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Theme.of(context).highlightColor),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(Icons.alarm,
                      size: 32, color: Theme.of(context).highlightColor),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SOFTWARE UPDATE',
                          style: Theme.of(context).textTheme.headline1),
                      Text('Up-to-date',
                          style: Theme.of(context).textTheme.headline2),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Theme.of(context).highlightColor),
                  onTap: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
