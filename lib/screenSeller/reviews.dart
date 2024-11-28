import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

@override
class _ReviewPageState extends State<ReviewPage> {
  //late Future<List<DocumentSnapshot>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    // _reviewsFuture = _fetchReview();
  }

  Future<List<DocumentSnapshot>> _fetchReview() async {
    String sellerID = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Reviews')
        .doc(sellerID)
        .collection('reviewsDetails')
        .get();
    return querySnapshot.docs;
  }

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
        title: const Text('Komen dan Tanda Suka'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchReview(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('Tiada Komen Dijumpai'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var reviewData =
                      snapshot.data![index].data() as Map<String, dynamic>;
                  return _buildReviewItem(reviewData);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> reviewData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              reviewData['buyerName'] ?? '', // Email of the buyer
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: 130,
                margin: const EdgeInsets.only(top: 12, left: 20, bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(reviewData['image'] ?? ''), // Image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        reviewData['comment'] ?? '', // Comment
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rate: ${reviewData['rate'] ?? ''}', // Rate
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
