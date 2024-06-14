import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/usermodel.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usercollection =
      FirebaseFirestore.instance.collection('users');

  Future<UserCredential?> RegisterUser(UserModel user) async {
    UserCredential Userdata = await _auth.createUserWithEmailAndPassword(
        email: user.email.toString(), password: user.password.toString());

    if (Userdata != null) {
      _usercollection.doc(Userdata.user!.uid).set({
        "name": user.name,
        "email": Userdata.user!.email,
        "uid": Userdata.user!.uid,
        "status": user.status,
        "createdAt": user.createdAt
      });
      return Userdata;
    }
  }

//login/////////////////////////

  Future<DocumentSnapshot?> loginUser(UserModel user) async {
    DocumentSnapshot? snap;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email.toString(), password: user.password.toString());
    String? token = await userCredential.user!.getIdToken();

    if (userCredential != null) {
      snap = await _usercollection.doc(userCredential.user!.uid).get();
      await _pref.setString('token', token!);
      await _pref.setString('name', snap['name']);
      await _pref.setString('email', snap['email']);
      return snap;
    
    }
    Future<void>logout()async{
      SharedPreferences _pref=await SharedPreferences.getInstance();
      await _pref.clear();
      await _auth.signOut();
    }

    Future<bool>isloggedin()async{
      SharedPreferences _pref =await SharedPreferences.getInstance();
      String? _token=await _pref.getString('token');
    if(_token==null){
      return false;
    }
    else{
      return true;
    }
    
    }




  }
}
