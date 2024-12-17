import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ethriftukm_fyp/pages/onboarding/mainmenu.dart';
import 'package:intl/intl.dart';

class CheckoutProductPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String username;
  final String sellerEmail;
  final String sellerId;
  final String productId;

  const CheckoutProductPage({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.username,
    required this.sellerEmail,
    required this.sellerId,
    required this.productId,
  }) : super(key: key);

  @override
  State<CheckoutProductPage> createState() => _CheckoutProductPageState();
}

final CollectionReference<Map<String, dynamic>> dbEthriftRef =
    FirebaseFirestore.instance.collection('Orders');

class _CheckoutProductPageState extends State<CheckoutProductPage> {
  String selectedPaymentMethod = 'none selected';
  String? selectedDeliveryMethod = 'none selected';

  late String productName;
  late String productDescription;
  late double productPrice;
  late String username;
  late String sellerEmail;
  late String sellerID;
  late String image;

  var currentDateTime;

  @override
  void initState() {
    super.initState();
    productName = widget.productName;
    productPrice = widget.productPrice;
    username = widget.username;
    sellerEmail = widget.sellerEmail;
    sellerID = widget.sellerId;
    image = widget.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   //Get the current user
  //   User? currentUser = FirebaseAuth.instance.currentUser;

  //   if(currentUser != null){
  //     String userId = currentUser.uid;
  //     String userEmail = currentUser.email!;

  //     //Get the current date and time
  //     DateTime now = DateTime.now();
  //     String currentDate = '${now.year}-${now.month}-${now.day}';
  //     String currentTime = '${now.hour}:${now.minute}:${now.second}';

  //     //Define the order data
  //     Map<String, dynamic> orderData = {
  //       'currentDate': currentDate,
  //       'currentTime': currentTime,
  //       'userEmail': userEmail,
  //       'productPrice': productPrice,
  //       'deliveryMethod': selectedDeliveryMethod,
  //       'paymentMethod': selectedPaymentMethod,
  //       'sellerId': username, // Assuming sellerId is the seller's ID
  //     };

  //     try {
  //     // Add the order details to Firestore
  //     FirebaseFirestore.instance
  //         .collection('Orders')
  //         .doc(userId) // Assuming user is authenticated
  //         .collection(username) // Assuming username is the seller's ID
  //         .doc() // Auto-generated ID
  //         .set(orderData)
  //         .then((_) {
  //       // Handle success
  //       Fluttertoast.showToast(
  //         msg: "Order added successfully",
  //         toastLength: Toast.LENGTH_SHORT,
  //       );
  //       // Navigate to the customer home page
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainMenuPage()),
  //       );
  //     }).catchError((error) {
  //       // Handle errors
  //       Fluttertoast.showToast(
  //         msg: "Failed to add order: $error",
  //         toastLength: Toast.LENGTH_SHORT,
  //       );
  //     });
  //   } catch (e) {
  //     // Handle errors
  //     Fluttertoast.showToast(
  //       msg: "Failed to add order: $e",
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //   }
  // } else {
  //   // Show an error message for unsigned-in user
  //   Fluttertoast.showToast(
  //     msg: "User not signed in",
  //     toastLength: Toast.LENGTH_SHORT,
  //   );
  //   // Finish the current activity
  //   Navigator.pop(context);
  // }
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   //onPaymentSuccess();
  //   // Handle payment failure
  //   Fluttertoast.showToast(
  //       msg: "Payment Error", toastLength: Toast.LENGTH_SHORT);
  //   //print("Payment Error");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Handle external wallet
  //   Fluttertoast.showToast(
  //       msg: "External Wallet${response.walletName!}",
  //       toastLength: Toast.LENGTH_SHORT);
  //   //print("External Wallet");
  // }

  List<DropdownMenuItem> paymentMethods = [
    const DropdownMenuItem(
      value: 'Card',
      child: Text(
        'Card',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Cash',
      child: Text(
        'Cash',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d y').format(now);

    String formattedTime = DateFormat('HH:mm').format(now);

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
        title: const Text('Pembayaran Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      'Nama Penjual: $username',
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Text(
                          'Emel: ${widget.sellerEmail}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 50, 38, 38),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 130,
                        margin: const EdgeInsets.only(
                            top: 12, left: 20, bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
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
                              const SizedBox(height: 10),
                              Text(
                                productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'RM $productPrice',
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Text(
                    '$formattedDate',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: Text(
                    '$formattedTime',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Kaedah Penghantaran:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    title: const Text('Delivery'),
                    value: 'delivery',
                    groupValue: selectedDeliveryMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedDeliveryMethod = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Pickup'),
                    value: 'pickup',
                    groupValue: selectedDeliveryMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedDeliveryMethod = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Kaedah Pembayaran:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField(
                  items: paymentMethods,
                  onChanged: (value) {
                    setState(() => selectedPaymentMethod = value);
                  },
                  icon: const Icon(Icons.credit_card_rounded),
                  hint: const Text(
                    'Pilih Kaedah Pembayaran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 189, 132, 128),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jumlah Harga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'RM $productPrice',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      fillColor: const Color.fromARGB(255, 101, 13, 6),
                      elevation: 0.0,
                      padding: const EdgeInsets.all(25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {
                        if (selectedPaymentMethod == 'Card') {
                          PaymentNow(productPrice);
                        } else if (selectedPaymentMethod == 'Cash') {
                          onPaymentSuccess();
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please select a payment method",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      },
                      child: const Text(
                        "TERUSKAN PEMBAYARAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void PaymentNow(double productPrice) {
    try {} catch (e) {
      print(e);
    }
  }

  Future<void> onPaymentSuccess() async {
    String buyerID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(buyerID).get();
    String username = userSnapshot['username'];

    String orderId = FirebaseFirestore.instance.collection('Orders').doc().id;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d y').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    DocumentReference orderRef = FirebaseFirestore.instance
        .collection('Orders')
        .doc(buyerID)
        .collection(sellerID)
        .doc(orderId);
    await FirebaseFirestore.instance
        .collection('AllProducts')
        .doc(widget.productId)
        .update({
      "availability": "not available",
    });

    await FirebaseFirestore.instance
        .collection('Products')
        .doc(sellerID)
        .collection('Products')
        .doc(widget.productId)
        .update({
      "availability": "not available",
    });
    await orderRef.set({
      "productName": productName,
      "productPrice": productPrice,
      "deliveryMethod": selectedDeliveryMethod,
      "paymentMethod": selectedPaymentMethod,
      "sellerName": widget.username,
      "sellerEmail": sellerEmail,
      "buyerName": username,
      "buyerId": buyerID,
      "image": image,
      "currentDate": formattedDate,
      "currentTime": formattedTime,
      "orderId": orderId,
      "productId": widget.productId,
    });
    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .doc(orderId)
        .set({
      "productName": productName,
      "productPrice": productPrice,
      "deliveryMethod": selectedDeliveryMethod,
      "paymentMethod": selectedPaymentMethod,
      "sellerName": widget.username,
      "sellerEmail": sellerEmail,
      "buyerName": username,
      "buyerId": buyerID,
      "image": image,
      "currentDate": formattedDate,
      "currentTime": formattedTime,
      "orderId": orderId,
      "productId": widget.productId,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuPage()),
    );
  }
}
