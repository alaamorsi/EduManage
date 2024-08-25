import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/modules/schedule/schedule_screen.dart';
import 'package:mr_mm/shared/components.dart';

class UpdateScheduleScreen extends StatelessWidget {
  TextEditingController subjectController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  final String subject;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String type;
  var formKey = GlobalKey<FormState>();

  UpdateScheduleScreen(
      {super.key,
      required this.subject,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute,
      required this.type});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    subjectController.text = subject;
    monthController.text = month;
    dayController.text = day;
    hourController.text = hour;
    minuteController.text = minute;
    typeController.text = type;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateScheduleSuccessState) {
          showToast(text: 'Updated successfully!', state: ToastStates.SUCCESS);
          return;
        }
      },
      builder: (context, state) {
        ThemeData theme = Theme.of(context);
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            cubit.getSchedules();
            navigateTo(context, ScheduleScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              cubit.getSchedules();
              navigateTo(context, ScheduleScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                            theme: theme,
                            formName: 'Schedule subject',
                            controller: subjectController,
                            onValidate: (String? value) {
                              if (value!.isEmpty)
                                return 'Subject can\'t be empty!';
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Schedule history',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.unselectedWidgetColor),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: defaultDropdownFormField(
                                  theme: theme,
                                  formName: 'Month',
                                  controller: monthController,
                                  list: [
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    '11',
                                    '12',
                                  ]),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: defaultDropdownFormField(
                                  theme: theme,
                                  formName: 'Day',
                                  controller: dayController,
                                  list: [
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    '11',
                                    '12',
                                    '13',
                                    '14',
                                    '15',
                                    '16',
                                    '17',
                                    '18',
                                    '19',
                                    '20',
                                    '21',
                                    '22',
                                    '23',
                                    '24',
                                    '25',
                                    '26',
                                    '27',
                                    '28',
                                    '29',
                                    '30',
                                    '31',
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Schedule time',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: defaultDropdownFormField(
                                  theme: theme,
                                  formName: 'Hour',
                                  controller: hourController,
                                  list: [
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10',
                                    '11',
                                    '12',
                                  ]),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                  theme: theme,
                                  formName: 'Minute',
                                  controller: minuteController,
                                  onValidate: (String? value) {
                                    if (value!.isEmpty)
                                      return 'Minute can\'t be empty!';
                                    if (value.contains('.'))
                                      return 'Invalid value';
                                    if (int.parse(value) < 0 ||
                                        int.parse(value) > 59)
                                      return 'Invalid, must between 0-59';
                                  }),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: defaultDropdownFormField(
                                  theme: theme,
                                  formName: 'Type',
                                  controller: typeController,
                                  list: [
                                    'am',
                                    'pm',
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.updateSchedule(
                                    sSubject: subject,
                                    nSubject: subjectController.text,
                                    nMonth: monthController.text,
                                    nDay: dayController.text,
                                    nHour: int.parse(hourController.text),
                                    nMinute: int.parse(minuteController.text),
                                    nType: typeController.text);
                              }
                            },
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(10.0),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.orange),
                            ),
                            child: (state is! UpdateScheduleLoadingState)
                                ? Text(
                                    'Update',
                                    style: TextStyle(
                                        fontSize: 21.0,
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                : CircularProgressIndicator(
                                    color: theme.primaryColor,
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}