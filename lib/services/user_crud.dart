import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('users');

class UserCrud {
//CRUD method here
//create
  static Future<Response> addUsers(
      {required String name,
      required String phone,
      required List<String?> deviceToken}) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(phone);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "phone": phone,
      "role": 'student',
      "belong": false,
      "token": deviceToken
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      print("ent 2");
      response.code = 200;
      response.message = "Sucessfully registered the user";
    }).catchError((e) {
      print(e);
      response.code = 500;
      response.message = e;
    });

    return response;
  }

//read
  static Future<DocumentSnapshot> readUser({required String phoneNum}) {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.doc(phoneNum).get();
  }

//reading all users
  static Stream<QuerySnapshot> readUsers() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  static Future<String> getUserToken(String? phone) async {
    DocumentReference notesItemCollection = _Collection.doc(phone);
    var docSnapShot = await notesItemCollection.get();
    if (docSnapShot.exists) {
      Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
      var value = data['token'][data['token'].length - 1];
      return value;
    }
    return 'NOT-FOUND';
  }

  static Future<Response> updateUserToken(
      {required String? deviceToken, required String phone}) async {
    Response response = Response();
    DocumentReference documentReference = _Collection.doc(phone);

    await documentReference.update({
      'token': FieldValue.arrayUnion([deviceToken])
    }).whenComplete(() {
      response.code = 200;
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  //update
  static Future<Response> updateUser({
    required String name,
    required String phone,
    required String role,
    required bool belong,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(phone);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "phone": phone,
      "role": role,
      "belong": belong,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readClassUsers() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.where('belong', isEqualTo: true).snapshots();
  }
}
