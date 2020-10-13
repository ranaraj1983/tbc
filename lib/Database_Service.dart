
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database_Service{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore dbInstance = FirebaseFirestore.instance;

  void login() async{

    final User user = (await _auth.signInWithEmailAndPassword(
      email: "r@1.co",
      password: "123456",
    )).user;
    print(user);
    getUserDetails();
  }

  void getUserDetails(){
    dbInstance.collection("User").get().then((value) {
      value.docs.forEach((element) {
        print(element.id);

        print(element.get("name"));
      });

    });
  }
}