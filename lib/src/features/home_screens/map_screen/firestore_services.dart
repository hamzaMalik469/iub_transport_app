import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:transport_app_iub/src/features/authentication/firebase_authentication/firebase_service.dart';
import 'package:transport_app_iub/src/features/home_screens/model/bus_model.dart';

class FirestoreServices extends GetxController {
  RxList busesList = <Buses>[].obs;

  RxBool isLoading = true.obs; // Loading state

  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String error = '';

  Future<void> fetchBuses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('buses').get();

      for (var doc in querySnapshot.docs) {
        Buses bus = Buses();
        bus.fromJson(doc.data() as Map<String, dynamic>);
        busesList.add(bus);
        update();
      }

      isLoading = false as RxBool;
      update();
    } catch (e) {
      // You may want to set an error state here
      error = 'Error fetching buses:$e';
    }
  }

  Future<void> sigOut() async {
    await _auth.signOut();
  }
}
