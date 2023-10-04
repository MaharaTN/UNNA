import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/userController.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    _userController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/images/logo.png",
              width: MediaQuery.of(context).size.width / 3.5,
            ),
            SizedBox(
              height: 15,
            ),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }
}


/*class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
        // Get.put<CourseController>(CourseController(), permanent: true);
      },
      builder: (_) {
        if (Get.find<AuthController>().user != null) {
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}*/
