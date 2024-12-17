import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/onboarding/mainmenu.dart';

class ReviewSubmitPage extends StatefulWidget {
  final Map<String, dynamic> historyData;
  final VoidCallback onReviewSubmitted;

  const ReviewSubmitPage({
    Key? key,
    required this.historyData,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  State<ReviewSubmitPage> createState() => _ReviewSubmitPageState();
}

@override
class _ReviewSubmitPageState extends State<ReviewSubmitPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text('Hantar Komen dan Tanda Suka'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.network(
                    widget.historyData['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return const Text("");
                }
              },
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 350,
              height: 200,
              child: TextFormField(
                controller: _commentController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Komen',
                  alignLabelWithHint: true,
                  hintText: 'Isi komen anda.',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                minLines: 7,
                maxLines: 10,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 101, 13, 6),
                elevation: 0.0,
                padding: const EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {
                  submitReview();
                },
                child: const Center(
                  child: Text(
                    "HANTAR KOMEN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitReview() async {
    String buyerID = FirebaseAuth.instance.currentUser!.uid;
    String sellerID = widget.historyData['sellerId'];
    DocumentReference reviewRef = FirebaseFirestore.instance
        .collection('Reviews')
        .doc(sellerID)
        .collection('reviewsDetails')
        .doc();
    Map<String, dynamic> reviewData = {
      'productName': widget.historyData['productName'],
      'image': widget.historyData['image'],
      'price': widget.historyData['productPrice'],
      'buyerName': widget.historyData['buyerName'],
      'emailBuyer': FirebaseAuth.instance.currentUser!.email,
      'comment': _commentController.text,
      'rate': _rating,
      'orderId': widget.historyData['orderId'],
    };
    DocumentReference historyRef = FirebaseFirestore.instance
        .collection('History')
        .doc(buyerID)
        .collection('HistoryDetails')
        .doc(widget.historyData['orderId']);

    await historyRef.update({'statusReview': "submitted"});
    await reviewRef.set(reviewData);
    widget.onReviewSubmitted();
    Fluttertoast.showToast(
      msg: "Komen Berjaya Dihantar",
      toastLength: Toast.LENGTH_SHORT,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuPage()),
    );
  }
}
