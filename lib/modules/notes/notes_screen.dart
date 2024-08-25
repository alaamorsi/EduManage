import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:mr_mm/model/note_model.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/modules/notes/update_note_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';

import 'add_note_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    ThemeData theme = Theme.of(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            navigateAndFinish(context, const HomeScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              navigateAndFinish(context, const HomeScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is GetNotesLoadingState)
                    const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                      color: Colors.orange,
                    ))),
                  state is GetNotesEmptyState
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No notes found',
                              style: TextStyle(
                                  color: theme.unselectedWidgetColor
                                      .withOpacity(0.8),
                                  fontSize: 18.0),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => buildNoteItem(
                                cubit.notesList.reversed.toList()[index],
                                context,
                                theme),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5.0,
                            ),
                            itemCount: cubit.notesList.length,
                          ),
                        ),
                ],
              ),
            ),
          ),
          floatingActionButton:
              defaultFloatingActionButton('Add a new note', context, theme, () {
            navigateTo(context, AddNoteScreen());
          }),
        );
      },
    );
  }
}

Widget buildNoteItem(NoteModel item, BuildContext context, ThemeData theme) {
  return SizedBox(
    width: double.infinity,
    height: 100,
    child: InkWell(
      onTap: () {
        navigateTo(
            context, UpdateNoteScreen(title: item.title, body: item.body));
      },
      child: Card(
        elevation: 10.0,
        color: Colors.orange.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor),
              ),
              Text(
                item.body,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0, color: theme.primaryColor),
              ),
              Text(
                item.time,
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
