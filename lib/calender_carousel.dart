import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/models/meeting_calender.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/society.dart';

// Example holidays
class CarouselCalender extends StatefulWidget {
  @override
  _CarouselCalenderState createState() => _CarouselCalenderState();
}

class _CarouselCalenderState extends State<CarouselCalender>
    with SingleTickerProviderStateMixin {
  //Map<DateTime, List> _events = new Map<DateTime, List>();
  late AnimationController _animationController;
  Map<DateTime, List> _holidays = new Map<DateTime, List>();
  // CalendarController _calendarController = CalendarController();
  String _selectedDay = '';
  List<Society> societies = List.empty(growable: true);
  Society selectedSociety = new Society(name: 'Choose Society');
  List<int> yearList = List.empty(growable: true);
  int selectedYear = DateTime.now().year;
  DateTime today = DateTime.now(), focusedDay = DateTime.now();
  List<MeetingDate> meetingDates = List.empty(growable: true);
  List<DateTime> meetingDateTimes = List.empty(growable: true);
  bool isLoading = false, isFiltered = false, isCalenderView = false;

  @override
  void initState() {
    super.initState();
    //final _selectedDay = DateTime.now();
    _animationController = AnimationController(vsync: this);
    // _calendarController = CalendarController();

    yearList.add(selectedYear);
    (ApiBaseHelper().getYears()).then((value) {
      if (value.success) {
        setState(() {
          value.data?.remove(selectedYear);
          yearList.addAll(value.data!.cast());
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });

    societies.add(selectedSociety);
    (LocalStorage().getSocieties()).then((value) {
      setState(() {
        societies.addAll(value ?? []);
      });
    });

    // Future.delayed(Duration(milliseconds: 1000), () {
    //   _animationController.forward();
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibleDaysChanged(DateTime date) {
    // MapEntry<DateTime, List<dynamic>>? entry = _holidays.entries.firstWhere((element) => (element.key.month == first.month && element.key.year==first.year));
    int pos = meetingDateTimes.indexWhere(
        (element) => element.year == date.year && element.month == date.month);
    if (pos < 0) {
      setState(() {
        _selectedDay = 'No Date Found';
      });
    } else {
      setState(() {
        _selectedDay = Jiffy([
          meetingDateTimes[pos].year,
          meetingDateTimes[pos].month,
          meetingDateTimes[pos].day
        ]).format('EEEE, do MMMM, yyyy');
      });
    }

    setState(() {
      focusedDay = date;
    });

//    entry!=null? print(entry.key):print('No Item Found');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        iconTheme: const IconThemeData(color: MyColor.navy),
        title: Text(
          'Calender',
          style: TextStyle(color: MyColor.navy, fontSize: 18),
        ),
        actions: [
          IconButton(
              icon: isCalenderView
                  ? Icon(Icons.list_outlined)
                  : Icon(Icons.grid_view),
              onPressed: () {
                setState(() {
                  isCalenderView = !isCalenderView;
                });
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: SocietyDropDown(
                    societies: societies,
                    selectedSociety: selectedSociety,
                    onChangeValue: (value) {
                      setState(() {
                        selectedSociety = value;
                      });
                      if (selectedYear == 0 ||
                          selectedSociety.name == 'Choose Society') return;
                      getMeetingDates();
                    },
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                YearDropDown(
                  yearList: yearList,
                  selectedYear: selectedYear,
                  onChangeValue: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                    if (selectedSociety.name == 'Choose Society') return;
                    getMeetingDates();
                  },
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
//          const SizedBox(height: 16.0),
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
//          _buildTableCalendar(),
          buildBody()
        ],
      ),
    );
  }

  Widget buildBody() {
    if (isFiltered && !isLoading) {
      return isCalenderView
          ? Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTableCalendarWithBuilders(),
                    //_buildButtons(),
                    const SizedBox(height: 16.0),
                    //Expanded(child: _buildEventList()),
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.lightBlueAccent.shade100,
                                  Colors.blue
                                ]),
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        padding: EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$_selectedDay',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )
          : buildList();
    } else if (isLoading) {
      return Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      return Expanded(
          child: Center(
        child: Text(
          'Please select the society and year you wish to view',
          style: TextStyle(color: Colors.blue),
        ),
      ));
    }
  }

  Widget buildList() {
    return Flexible(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          shrinkWrap: true,
          itemCount: meetingDates.length,
          itemBuilder: (context, index) {
            List<String> dates = parseDateStr(meetingDates[index].meetingDate!);
            Jiffy jiffy = Jiffy([
              int.parse(dates[0]),
              int.parse(dates[1]),
              int.parse(dates[2])
            ]);
            return Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 20.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      5.0, // Move to bottom 10 Vertically
                    ),
                  ),
                ],
              ),
              child: Row(
                children: [
//                  Container(margin: EdgeInsets.only(right: 8), width: 3, height: 65, color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jiffy.format('do'),
                                style: TextStyle(
                                    color: MyColor.navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text(jiffy.format('EEEE'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 18),
                          width: 1,
                          height: 35,
                          color: Colors.grey.shade400,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jiffy.format('MMMM, yyyy'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MyColor.navy)),
//                            Text('2021',style: TextStyle(fontSize: 16, )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  void getMeetingDates() {
    setState(() {
      isLoading = true;
      isFiltered = true;
    });
    (ApiBaseHelper().getMeetingCalender(
            selectedSociety.id.toString(), selectedYear.toString()))
        .then((value) {
      if (value.success) {
        meetingDates.clear();
        meetingDateTimes.clear();
        List<MapEntry<DateTime, List<dynamic>>> entries =
            List.empty(growable: true);
        List<DateTime> dates = List.empty(growable: true);
        value.data!.forEach((e) {
          List<String> listDate = parseDateStr(e.meetingDate!);
          DateTime date = DateTime(int.parse(listDate[0]),
              int.parse(listDate[1]), int.parse(listDate[2]));
          dates.add(date);
          entries.add(MapEntry(date, ['']));
        });
        setState(() {
          meetingDates.addAll(value.data ?? []);
          meetingDateTimes.addAll(dates);
          _holidays.addEntries(entries.cast());
          focusedDay = DateTime(selectedYear, today.month, today.day);
          isLoading = false;
        });
        _onVisibleDaysChanged(
            DateTime(selectedYear, DateTime.now().month, DateTime.now().day));
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
//      locale: 'pl_PL',
      locale: 'en_US', //      events: _events,
      // holidays: _holidays,
      // initialCalendarFormat: CalendarFormat.month,
      // formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onPageChanged: (date) {
        _onVisibleDaysChanged(date);
      },
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        // weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        // holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        // centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      // eventLoader: (date){
      //
      // },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return Container(
//            margin: const EdgeInsets.all(4.0),
//            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.white10,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//            color: Colors.white10,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey, width: 2)),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (meetingDateTimes.indexWhere((element) =>
                  (element.year == date.year &&
                      element.month == date.month &&
                      element.day == date.day)) >=
              0) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//            color: Colors.white10,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.lightBlue, width: 3)),
              child: Text(
                '${date.day}',
                style:
                    TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
              ),
            );
          }
          return Container();
        },
      ),
      // onDaySelected: (date, events) {
      //   _onDaySelected(date, events, holidays);
      //   _animationController.forward(from: 0.0);
      // },
      lastDay: DateTime(selectedYear, 12, 31),
      focusedDay: focusedDay,
      firstDay: DateTime(selectedYear, 1, 1),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // decoration: BoxDecoration(
      //   shape: BoxShape.rectangle,
      //   color: _calendarController.isSelected(date)
      //       ? Colors.brown[500]
      //       : _calendarController.isToday(date)
      //       ? Colors.brown[300]
      //       : Colors.blue[400],
      // ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(DateTime date) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(4))),
//      width: 200,
//      height: 200,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  List<String> parseDateStr(String dateStr) {
    String subString = dateStr.substring(0, dateStr.indexOf(' '));
    return subString.split('-');
  }
}
