import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/model/schedule_model.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/modules/schedule/add_schedule_screen.dart';
import 'package:intl/intl.dart';
import 'package:mr_mm/modules/schedule/update_schedule_screen.dart';
import '../../shared/components.dart';

class ScheduleScreen extends StatelessWidget {
  String getDayName(int day, int month, {int year = 2024}) {
    DateTime date = DateTime(year, month, day);

    String dayName = DateFormat('EEEE').format(date);

    return dayName;
  }

  ScheduleScreen({super.key});

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
            onWillPop: ()async{
              navigateAndFinish(context, const HomeScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Column(
                children: [
                  if (state is GetSchedulesLoadingState)
                    const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                      color: Colors.orange,
                    ))),
                  const SizedBox(
                    height: 30.0,
                  ),
                  state is GetSchedulesEmptyState
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No schedules found',
                              style: TextStyle(
                                  color: theme.unselectedWidgetColor
                                      .withOpacity(0.8),
                                  fontSize: 18.0),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      buildScheduleItem(
                                        cubit.scheduleList[index],
                                        theme,
                                        context,
                                      ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                  itemCount: cubit.scheduleList.length),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          floatingActionButton: defaultFloatingActionButton(
              'Add a new schedule', context, theme, () {
            navigateTo(context, AddScheduleScreen());
          }),
        );
      },
    );
  }
}

Widget buildScheduleItem(ScheduleModel list, ThemeData theme, context) {
  DateTime date = DateTime(2024, int.parse(list.month), int.parse(list.day));
  String dayName = DateFormat('EEEE').format(date);
  return InkWell(
    onTap: () {
      navigateTo(
          context,
          UpdateScheduleScreen(
              subject: list.subject,
              month: list.month,
              day: list.day,
              hour: list.hour.toString(),
              minute: list.minute.toString(),
              type: list.type));
    },
    child: Row(
      children: [
        Expanded(
          child: Card(
            color: theme.primaryColor,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.orange, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.subject_sharp,
                    color: Colors.orange.shade600,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        list.subject,
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: theme.unselectedWidgetColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0), // Add some spacing between the cards
        Expanded(
          child: Card(
            color: theme.primaryColor,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.orange, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.orange.shade600,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      //  if(list.minute == 0|1|2|3|4|5|6|7|8|9 )
                      child: list.minute < 10
                          ? Text(
                              '$dayName, ${list.day} / ${list.month}, ${list.hour}:0${list.minute} ${list.type}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.unselectedWidgetColor),
                            )
                          : Text(
                              '$dayName, ${list.day} / ${list.month}, ${list.hour}:${list.minute} ${list.type}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.unselectedWidgetColor),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
