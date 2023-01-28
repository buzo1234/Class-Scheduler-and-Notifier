import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('classes');

class FirebaseCrud {
//CRUD method here
//create
  static Future<Response> addClasses({
    required String date,
    required List<dynamic> entries,
  }) async {
    print("ent 1 $date");
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(date);
    String dateid = DateFormat('dd-MM-yyyy').format(parseDate);
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(dateid);

    Map<String, dynamic> data = <String, dynamic>{
      "date": date,
      "Entries": FieldValue.arrayUnion(entries),
    };

    var result = await documentReferencer
        .set(data, SetOptions(merge: true))
        .whenComplete(() {
      print("ent 2");
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      print(e);
      response.code = 500;
      response.message = e;
    });

    return response;
  }

//read
  static Stream<QuerySnapshot> readClasses() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

//update
  static Future<Response> updateEmployee({
    required String name,
    required String position,
    required String contactno,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "employee_name": name,
      "position": position,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  //delete
  static Future<Response> deleteEmployee({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
