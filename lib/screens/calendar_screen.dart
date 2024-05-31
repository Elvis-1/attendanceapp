import 'package:attendanceapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = const Color(0xFFeef444c);

  String _month = DateFormat("MMMM").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              "My Attendance",
              style: TextStyle(
                color: Colors.black54,
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  _month,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  print('--- picking month ----');
                  final month = await showMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2099),
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primary,
                                secondary: primary,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom())),
                          child: child!);
                    },
                  );

                  if (month != null) {
                    setState(() {
                      _month = DateFormat("MMMM").format(month);
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    "Pick a Month",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: screenHeight / 1.5,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Employee")
                      .doc()
                      .collection("Record")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            return DateFormat("MMMM")
                                        .format(snap[index]['date'].toDate()) ==
                                    _month
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: index > 0 ? 12 : 0,
                                        right: 6,
                                        left: 6),
                                    height: 150,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Center(
                                              child: Text(
                                            DateFormat("EE \ndd").format(
                                                snap[index]['date'].toDate()),
                                            style: TextStyle(
                                                fontSize: screenWidth / 20,
                                                color: Colors.white),
                                          )),
                                        )),
                                        Expanded(
                                            child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Check In",
                                                style: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                    color: Colors.black12),
                                              ),
                                              Text(
                                                snap[index]["checkIn"],
                                                style: TextStyle(
                                                    fontSize: screenWidth / 18,
                                                    color: Colors.black54),
                                              )
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Check Out",
                                                style: TextStyle(
                                                    fontSize: screenWidth / 20,
                                                    color: Colors.black12),
                                              ),
                                              Text(
                                                snap[index]['checkOut'],
                                                style: TextStyle(
                                                    fontSize: screenWidth / 18,
                                                    color: Colors.black54),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink();
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
