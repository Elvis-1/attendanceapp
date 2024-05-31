import 'package:attendanceapp/data/global_service.dart';
import 'package:attendanceapp/screens/calendar_screen.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/screens/profile_screen.dart';
import 'package:attendanceapp/data/api/services/location_services.dart';
import 'package:attendanceapp/screens/today_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = const Color(0xFFeef444c);

  int currentIndex = 0;
  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    // _getCredentials();
    // startLocationServices();
  }

  // void _getCredentials() async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance
  //       .collection("Employee")
  //       .doc(UserModel.id)
  //       .get();

  //   setState(() {
  //     UserModel.canEdit = doc["canEdit"];
  //     UserModel.firstName = doc["firstName"];
  //     UserModel.lastName = doc["lastName"];
  //     UserModel.birtDate = doc["birthDate"];
  //     UserModel.address = doc["address"];
  //   });
  // }

  // void startLocationServices() async {
  //   await LocationServices().initialize();

  //   final lat = await LocationServices().getLongitude();
  //   setState(() {
  //     UserModel.long = lat!;
  //   });

  //   final long = await LocationServices().getLatitude();
  //   setState(() {
  //     UserModel.lat = long!;
  //   });
  // }

  void getId() async {
    String userId = GlobalService.sharedPreferencesManager.getUserId();

    print("This is user id $userId");
    QuerySnapshot userDetails = await FirebaseFirestore.instance
        .collection("Employee")
        .where('id', isEqualTo: userId)
        .get();
  }

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.userAlt
  ];
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [CalendarScreen(), TodayScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 12, right: 12, bottom: 24),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                    child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          navigationIcons[i],
                          color: currentIndex == i ? primary : Colors.black54,
                          size: i == currentIndex ? 30 : 26,
                        ),
                        i == currentIndex
                            ? Container(
                                margin: EdgeInsets.only(top: 6),
                                height: 3,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ))
              }
            ],
          ),
        ),
      ),
    );
  }
}
