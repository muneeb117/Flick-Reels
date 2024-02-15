import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../utils/app_constraints.dart';

class SerchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  final RxBool _hasSearched = RxBool(
      false); // Flag to track if a search has been made

  List<User> get searchedUsers => _searchedUsers.value;

  bool get hasSearched =>
      _hasSearched.value; // Getter to access _hasSearched outside

  void resetSearch() {
    _searchedUsers.value = []; // Clear the search results
    _hasSearched.value = false; // Reset the search flag
  }

  void searchUser(String typedUser) async {
    if (typedUser.isNotEmpty) {
      _hasSearched.value = true;
      String searchKey = typedUser.toLowerCase();

      FirebaseFirestore.instance
          .collection('users')
          .snapshots().listen((QuerySnapshot query) {
        List<User> retVal = [];
        for (var elem in query.docs) {
          User user = User.fromSnap(elem);
          // Perform a case-insensitive check on the client side
          if (user.name.toLowerCase().contains(searchKey)) {
            retVal.add(user);
          }
        }
        _searchedUsers.value = retVal;
      });
    } else {
      resetSearch();
    }
  }
}