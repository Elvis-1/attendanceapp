import 'dart:io';
import 'package:attendanceapp/controllers/user_controller.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/utils/snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color primary = const Color(0xFFeef444c);
  double screenWidth = 0;
  double screenHeight = 0;
  String userEmail = GlobalService.sharedPreferencesManager.getUserEmail();
  String userId = GlobalService.sharedPreferencesManager.getUserId();
  String birth = "Date of Birth";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<void> pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
        source: ImageSource.gallery);
// Create a storage reference from our app

    Reference ref = FirebaseStorage.instance.ref();

    final fileName = image!.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    // final uploadRef =
    //     ref.child("${UserModel.id!}/uploads/$timestamp-$fileName");

    // await uploadRef.putFile(File(image.path));

    // ref.getDownloadURL().then((value) {
    //   setState(() {
    //     UserModel.profilePiclink = value;
    //   });
    // });
  }

  // Future<void> pickUploadProfilePic1() async {
  //   final image = await ImagePicker().pickImage(
  //     // maxHeight: 512,
  //     // maxWidth: 512,
  //     // imageQuality: 90,
  //     source: ImageSource.gallery,
  //   );

  //   if (image == null) {
  //     // User cancelled image selection
  //     return;
  //   }

  //   try {
  //     // Upload the selected image file to Firebase Storage
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child("${}_profilePic.jpg");
  //     Directory appDocDir = await getApplicationDocumentsDirectory();
  //     String filePath = '${appDocDir.absolute}/$image';
  //     File file = await File(filePath).create(recursive: true);
  //     await ref.putFile(file);

  //     // Once upload is successful, retrieve the download URL
  //     String downloadURL = await ref.getDownloadURL();

  //     // Update profile pic link in UserModel
  //     setState(() {
  //       UserModel.profilePiclink = downloadURL;
  //     });
  //   } catch (e) {
  //     // Handle upload errors
  //     print('Error uploading profile picture: $e');
  //     // Optionally, display an error message to the user
  //   }
  // }

  void uploadPic() async {
    final image = await ImagePicker().pickImage(
      // maxHeight: 512,
      // maxWidth: 512,
      // imageQuality: 90,
      source: ImageSource.gallery,
    );

    if (image == null) {
      print('---- $image');
      return;
    }

    print("This is the image file $image");

    final storageRef = FirebaseStorage.instance.ref();

    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //  String filePath = '${appDocDir.absolute}/$image';
    File file = File(image.path);
    print("This is the image file path ${image.path}");
    if (file.existsSync()) {
// Create a reference to "mountains.jpg"
      print('--- any string ---');

      final mountainsRef = storageRef.child("file").child('images');
      try {
        await mountainsRef.putFile(file);
      } on FirebaseException catch (e) {
        // ...
        print("This is the error $e");
      }
    } else {
      print("Ref does not exist");
    }
  }

  UserModel? userDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userDetails = GlobalService.sharedPreferencesManager.getUserDetails();

    // firstNameController.text = userDetails?.firstName ?? '';
    // lastNameController.text = userDetails?.lastName ?? '';
    // birthController.text = userDetails?.birthDate ?? '';
    // addressController.text = userDetails?.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await pickUploadProfilePic();
              //  uploadPic();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 80, bottom: 20),
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primary,
              ),
              child: Center(
                child: Container(),
                // UserModel.profilePiclink == ""
                //     ? const Icon(
                //         Icons.person,
                //         color: Colors.white,
                //         size: 80,
                //       )
                //     : Image.network(UserModel.profilePiclink!),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Employee ${userEmail}",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          textField('First Name', 'First Name', firstNameController),
          const SizedBox(
            height: 24,
          ),
          textField('Last Name', 'Last Name', lastNameController),
          const SizedBox(
            height: 24,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Date of Birth",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                            primary: primary,
                            secondary: primary,
                            onSecondary: Colors.white),
                        textButtonTheme:
                            TextButtonThemeData(style: TextButton.styleFrom()),
                      ),
                      child: child!);
                },
              ).then((value) => setState(() {
                    birth = DateFormat('MM/dd/yyyy').format(value!);
                  }));
            },
            child: Container(
              height: kToolbarHeight,
              width: screenWidth,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black54),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 11),
                alignment: Alignment.centerLeft,
                child: Text(
                  textAlign: TextAlign.center,
                  birth,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          textField("Address", "Address", addressController),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<UserController>(
            builder: (userController) {
              return userController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () async {
                        String firstName = firstNameController.text.trim();
                        String lastName = lastNameController.text.trim();
                        String address = addressController.text.trim();
                        String birthDate = birth;

                        // if (UserModel.canEdit) {
                        if (firstName.isEmpty) {
                          showErrorSnackBar('Please enter your first name');
                          // showSnackBar("Please enter your first name");
                        } else if (lastName.isEmpty) {
                          showErrorSnackBar('Please enter your last name');
                        } else if (birthDate.isEmpty) {
                          showErrorSnackBar('Please enter your birth date');
                        } else if (address.isEmpty) {
                          showErrorSnackBar('Please enter your address');
                        } else {
                          Map<String, dynamic> body = {
                            "firstName": firstName,
                            "lastName": lastName,
                            "birthDate": birthDate,
                            "address": address,
                            "canEdit": false,
                          };
                          await userController.saveUserDetails(body);
                        }
                        // } else {
                        //   showSnackBar(
                        //       "You can't edit, you need to contact th support the support team");
                        // }
                      },
                      child: Container(
                        height: kToolbarHeight,
                        width: screenWidth,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: primary,
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Save",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    ));
  }

  Widget textField(
      String hint, String title, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black54),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54)),
            ),
          ),
        ),
      ],
    );
  }
}
