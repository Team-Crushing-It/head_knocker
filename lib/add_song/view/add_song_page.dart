import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:head_knocker/add_song/add_song.dart';
import 'package:songs_repository/songs_repository.dart';

class AddSong extends StatelessWidget {
  const AddSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddSongCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final output = await Navigator.of(context).push(
            _createDialog(context),
          );

          if (output.toString() == 'cancelled' || output == null) {
            // reset link state
            context.read<AddSongCubit>().linkReset();
          } else {
            await cubit.addSong();
          }
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 1000,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(Icons.arrow_back_ios, color: Colors.white),
              Text(
                'Back',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: _AddSongView(list: context.watch<AddSongCubit>().state.songs),
      ),
    );
  }
}

class _AddSongView extends StatelessWidget {
  const _AddSongView({Key? key, required this.list}) : super(key: key);

  final List<Song>? list;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddSongCubit, AddSongState>(
      listener: (context, state) {
        if (state.status!.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Link Failure')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                'Current Alarm Song',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                list!.last.title,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'Recents',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 24),
              ),
            ),
            if (list!.length == 1)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'no recents',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 16),
                ),
              )
            else
              ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list!.length - 1,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      context.read<AddSongCubit>().addSong2(list![index].url);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 24),
                      child: Text(
                        list![index].title,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}

Route<Object?> _createDialog(BuildContext context) {
  return DialogRoute<void>(
    context: context,
    builder: (context) => const StatefulDialog(),
  );
}

class StatefulDialog extends StatefulWidget {
  const StatefulDialog({Key? key}) : super(key: key);

  @override
  _StatefulDialogState createState() => _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  @override
  void initState() {
    super.initState();
  }

  String test = '';
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Text(
                    'Please enter the link',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 20, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _LinkInput(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: _AddSongButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'cancelled');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(Colors.teal),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _LinkInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSongCubit, AddSongState>(
      buildWhen: (previous, current) => previous.link != current.link,
      builder: (context, state) {
        return TextField(
          // key: const Key('addSongForm_linkInput_textField'),
          onChanged: (link) => context.read<AddSongCubit>().linkChanged(link),
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: 'Youtube Link',
            helperText: '',
            errorText: state.link!.invalid ? 'invalid link' : null,
          ),
        );
      },
    );
  }
}

class _AddSongButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddSongCubit, AddSongState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status!.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                // key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  primary: Colors.blueGrey,
                ),
                onPressed: state.status!.isValidated
                    ? () => {Navigator.pop(context, 'test')}
                    : null,
                child:
                    const Text('Upload', style: TextStyle(color: Colors.black)),
              );
      },
    );
  }
}
