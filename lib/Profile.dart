import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:auction_app_for_ostad/main.dart';

class Profile extends StatefulWidget {

  late GoogleSignInAccount userObj;
  Profile({required this.userObj});

  @override
  State<Profile> createState() => Profile_State();
}

class Profile_State extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.userObj.photoUrl!),
            const SizedBox(height: 20,),
            Text(widget.userObj.displayName!),
            const SizedBox(height: 20,),
            Text(widget.userObj.email),
            const SizedBox(height: 20,),
            MaterialButton(
              onPressed: () {
                GoogleSignIn().signOut().then((value) {
                  setState(() {

                  });
                }).catchError((e) {});

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginIn(),
                  ),
                );
              },
              height: 50,
              minWidth: 100,
              color: Colors.red,
              child: const Text('Logout',style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ) ,
    );
  }
}
