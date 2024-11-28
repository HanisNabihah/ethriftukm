import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class listUser extends StatefulWidget {
  const listUser({Key? key});

  @override
  State<listUser> createState() => _listUserState();
}

class _listUserState extends State<listUser> {
  //fetch users data
  Future<List<Map<String, dynamic>>> _fetchUsersData() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      List<Map<String, dynamic>> usersData = userSnapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['userId'] = doc.id; // Assign userId to each user data
        return userData;
      }).toList();
      return usersData;
    } catch (error) {
      // Handle error
      print('Error fetching users data: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate back to the main menu
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          'Senarai Pengguna',
          // style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error: Unable to fetch users data'));
          } else {
            List<Map<String, dynamic>> usersData = snapshot.data ?? [];
            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: ListView.builder(
                itemCount: usersData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> userData = usersData[index];
                  // Return a ListTile or any other widget to display user data
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Nama : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal)),
                                Text(userData['username'] ?? 'Unknown'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Emel : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal)),
                                Text(userData['email'] ?? 'Unknown'),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("No Telefon : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal)),
                                Text(userData['phone'] ?? 'Unknown'),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 0,
                                  child: Text(
                                    "Kolej : ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    userData['college'] ?? 'Unknown',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Implement delete functionality here
                                    _showDeleteDialog(userData['userId']);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Sebab:"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add your reasons for deletion here
                ListTile(
                  title: const Text("Pengguna Tidak Aktif"),
                  onTap: () {
                    // Implement the delete logic for reason 1
                    Navigator.pop(context);
                    _showConfirmationDialog(userId); // Close the dialog
                  },
                ),
                ListTile(
                  title: const Text("Lain-Lain"),
                  onTap: () {
                    // Implement the delete logic for reason 2
                    Navigator.pop(context); // Close the dialog
                    _showConfirmationDialog(userId);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement cancel logic
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adakah Anda Pasti?"),
          content: const Text("Adakah anda pasti mahu memadam pengguna ini?"),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Get a reference to the user document in Firestore
                  final userDocRef = FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId);
                  // Delete the user document
                  await userDocRef.delete();
                  // Inform the user that deletion was successful
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Pengguna berjaya dipadam.'),
                  ));
                  // Refresh the user list
                  setState(() {});
                  // Close the confirmation dialog
                  Navigator.pop(context);
                } catch (error) {
                  // Handle errors if deletion fails
                  print('Error deleting user: $error');
                  // Inform the user about the error
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Ralat: Gagal memadam pengguna.'),
                  ));
                }
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: const Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}
