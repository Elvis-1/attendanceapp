import 'dart:async';

import 'package:attendanceapp/controllers/check_controller.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String checkIn = '--/--';
  String checkOut = '--/--';

  String location = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<CheckController>().getUserRecords();
    getRecords();
  }

  final userId = GlobalService.sharedPreferencesManager.getUserId();
  final userEmail = GlobalService.sharedPreferencesManager.getUserEmail();
  // void _getLocation() async {
  //   List<Placemark> placemark =
  //       await placemarkFromCoordinates(UserModel.lat, UserModel.long);
  //   setState(() {
  //     location =
  //         "${placemark[0].street} ${placemark[0].administrativeArea} ${placemark[0].postalCode} ${placemark[0].country}}";
  //   });
  // }
  final GlobalKey<SlideActionState> key = GlobalKey();
  void getRecords() async {
    await _getRecord();
  }

  _getRecord() async {
    try {
      //  key.currentState!.reset();
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: userId)
          .get();

      print('--- current user id');
      print('this is user email $userEmail');
      print(snap.docs[0]['id']);
      // print(DateFormat("dd MMMM yyyy").format(DateTime.now()));

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(snap.docs[0]['id'])
          .collection('Record')
          .doc(DateFormat("dd MMMM yyyy").format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snapshot['checkIn'];
        checkOut = snapshot['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = const Color(0xFFeef444c);
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(body: GetBuilder<CheckController>(
      builder: (checkController) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth / 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  "Employee  ${userId}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  "Today's status",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              GetBuilder<CheckController>(
                builder: (checkController) {
                  checkIn = checkController.checkIn;
                  checkOut = checkController.checkOut;
                  return Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 25),
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
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                    fontSize: screenWidth / 20,
                                    color: Colors.black12),
                              ),
                              Text(
                                checkIn,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                    fontSize: screenWidth / 20,
                                    color: Colors.black12),
                              ),
                              Text(
                                checkOut,
                                style: TextStyle(
                                    fontSize: screenWidth / 18,
                                    color: Colors.black54),
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  );
                },
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style:
                          TextStyle(color: primary, fontSize: screenWidth / 18),
                      children: [
                        TextSpan(
                            text:
                                DateFormat(" MMMM yyyy").format(DateTime.now()),
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: screenWidth / 20))
                      ]),
                ),
              ),
              StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.only(top: 24, bottom: 12),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DateFormat('hh:mm:ss a').format(DateTime.now()),
                        style: TextStyle(
                            fontSize: screenWidth / 18, color: Colors.black54),
                      ),
                    );
                  }),
              checkController.checkOut == "--/--"
                  ? Container(
                      margin: EdgeInsets.only(top: 24),
                      child:
                          // GetBuilder<CheckController>(builder: (check) {
                          //   final GlobalKey<SlideActionState> key = GlobalKey();
                          // checkIn = check.checkIn;
                          //  checkOut = check.checkOut;
                          SlideAction(
                        text: checkController.checkIn == "--/--"
                            ? "Slide to check In"
                            : "Slide to check Out",
                        textStyle: TextStyle(
                            color: Colors.black54, fontSize: screenWidth / 20),
                        outerColor: Colors.white,
                        innerColor: primary,
                        key: key,
                        onSubmit: () async {
                          if (checkIn == '--/--') {
                            await checkController.checkInUser();
                          } else {
                            await checkController.checkOutUser();
                          }

                          // if (UserModel.lat != 0) {
                          //   _getLocation();
                          //   Timer(Duration(seconds: 2), () {
                          //     key.currentState!.reset();
                          //   });
                          //   QuerySnapshot snap = await FirebaseFirestore.instance
                          //       .collection("Employee")
                          //       .where('id', isEqualTo: userId)
                          //       .get();

                          //   // print(snap.docs[0]['id']);
                          //   // print(DateFormat("dd MMMM yyyy").format(DateTime.now()));

                          //   DocumentSnapshot snapshot = await FirebaseFirestore
                          //       .instance
                          //       .collection('Employee')
                          //       .doc(snap.docs[0]['id'])
                          //       .collection('Record')
                          //       .doc(DateFormat("dd MMMM yyyy")
                          //           .format(DateTime.now()))
                          //       .get();

                          //   try {
                          //     //  print(snapshot['checkIn']);
                          //     String checkIn = snapshot['checkIn'];
                          //     setState(() {
                          //       checkOut = DateFormat('hh:mm:ss a')
                          //           .format(DateTime.now());
                          //     });
                          //     await FirebaseFirestore.instance
                          //         .collection('Employee')
                          //         .doc(snap.docs[0]['id'])
                          //         .collection('Record')
                          //         .doc(DateFormat("dd MMMM yyyy")
                          //             .format(DateTime.now()))
                          //         .update({
                          //       'date': Timestamp.now(),
                          //       'checkIn': checkIn,
                          //       'checkOut': DateFormat('hh:mm:ss a')
                          //           .format(DateTime.now()),
                          //       'checkOutlocation': location
                          //     });
                          //   } catch (e) {
                          //     setState(() {
                          //       checkIn = DateFormat('hh:mm:ss a')
                          //           .format(DateTime.now());
                          //     });
                          //     await FirebaseFirestore.instance
                          //         .collection('Employee')
                          //         .doc(snap.docs[0]['id'])
                          //         .collection('Record')
                          //         .doc(DateFormat("dd MMMM yyyy")
                          //             .format(DateTime.now()))
                          //         .set({
                          //       'date': Timestamp.now(),
                          //       'checkIn': DateFormat('hh:mm:ss a')
                          //           .format(DateTime.now()),
                          //       'checkOut': '--/--',
                          //       'checkInlocation': location
                          //     });
                          //     setState(() {});
                          //   }
                          // } else {
                          //   Timer(Duration(seconds: 2), () async {
                          //     _getLocation();
                          //     key.currentState!.reset();

                          //     QuerySnapshot snap = await FirebaseFirestore
                          //         .instance
                          //         .collection("Employee")
                          //         .where('id', isEqualTo: userId)
                          //         .get();

                          //     // print(snap.docs[0]['id']);
                          //     // print(DateFormat("dd MMMM yyyy").format(DateTime.now()));

                          //     DocumentSnapshot snapshot = await FirebaseFirestore
                          //         .instance
                          //         .collection('Employee')
                          //         .doc(snap.docs[0]['id'])
                          //         .collection('Record')
                          //         .doc(DateFormat("dd MMMM yyyy")
                          //             .format(DateTime.now()))
                          //         .get();

                          //     try {
                          //       //  print(snapshot['checkIn']);
                          //       String checkIn = snapshot['checkIn'];
                          //       setState(() {
                          //         checkOut = DateFormat('hh:mm:ss a')
                          //             .format(DateTime.now());
                          //       });
                          //       await FirebaseFirestore.instance
                          //           .collection('Employee')
                          //           .doc(snap.docs[0]['id'])
                          //           .collection('Record')
                          //           .doc(DateFormat("dd MMMM yyyy")
                          //               .format(DateTime.now()))
                          //           .update({
                          //         'date': Timestamp.now(),
                          //         'checkIn': checkIn,
                          //         'checkOut': DateFormat('hh:mm:ss a')
                          //             .format(DateTime.now()),
                          //         'checkInlocation': location
                          //       });
                          //     } catch (e) {
                          //       setState(() {
                          //         checkIn = DateFormat('hh:mm:ss a')
                          //             .format(DateTime.now());
                          //       });
                          //       await FirebaseFirestore.instance
                          //           .collection('Employee')
                          //           .doc(snap.docs[0]['id'])
                          //           .collection('Record')
                          //           .doc(DateFormat("dd MMMM yyyy")
                          //               .format(DateTime.now()))
                          //           .set({
                          //         'date': Timestamp.now(),
                          //         'checkIn': DateFormat('hh:mm:ss a')
                          //             .format(DateTime.now()),
                          //         'checkOut': '--/--',
                          //         'checkOutlocation': location
                          //       });
                          //       setState(() {});
                          //     }
                          //   });
                          // }
                        },
                      ))
                  : Container(
                      margin: EdgeInsets.only(top: 32, bottom: 32),
                      child: Text(
                        "You have completed your day",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenWidth / 20,
                        ),
                      )),
              SizedBox(
                height: 30,
              ),
              location != ""
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              blurRadius: 0.3,
                              color: Colors.black.withOpacity(0.2),
                            )
                          ]),
                      child: Text(
                        "Location " + location,
                        style: TextStyle(),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      },
    ));
  }
}
