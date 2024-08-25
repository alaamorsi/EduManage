import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:mr_mm/modules/notes/notes_screen.dart';
import 'package:mr_mm/shared/components.dart';

class UpdateNoteScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  final String title;
  final String body;
  var formKey = GlobalKey<FormState>();

  UpdateNoteScreen({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    ThemeData theme = Theme.of(context);
    titleController.text = title;
    bodyController.text = body;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateNoteSuccessState) {
          showToast(text: 'Updated successfully!', state: ToastStates.SUCCESS);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            cubit.getNotes();
            navigateTo(context, const NotesScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              cubit.getNotes();
              navigateTo(context, const NotesScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      style:  TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: theme.unselectedWidgetColor),
                      cursorColor: Colors.orange,
                      validator: (String? value) {
                        if (value!.isEmpty) return 'Title can\'t be empty';
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            fontSize: 24.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '${DateFormat.MMMM().format(DateTime.now()).toString()} ${DateTime.now().day}',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade700.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: TextFormField(
                        controller: bodyController,
                        style:  TextStyle(
                            fontSize: 21.0, color: theme.unselectedWidgetColor),
                        cursorColor: Colors.orange,
                        maxLines: null,
                        // Allows the text to wrap and grow with the content
                        validator: (String? value) {
                          if (value!.isEmpty) return 'can\'t be empty';
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start typing',
                          hintStyle: TextStyle(
                              fontSize: 21.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.updateNote(
                    sTitle: title,
                    title: titleController.text,
                    body: bodyController.text,
                    time:
                        '${DateFormat.MMMM().format(DateTime.now()).toString()} ${DateTime.now().day}');
              }
            },
            backgroundColor: Colors.orange,
            tooltip: 'Update',
            child: (state is! UpdateNoteLoadingState)
                ?  Icon(
                    Icons.save,
                    size: 40.0,
                    color: theme.primaryColor,
                  )
                :  CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
          ),
        );
      },
    );
  }
}
