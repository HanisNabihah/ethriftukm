import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ethriftukm_fyp/pages/onboarding/mainmenu.dart';
import 'package:intl/intl.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class checkoutProductPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String username;
  final String sellerEmail;
  final String sellerId;
  final String productId;

  const checkoutProductPage({
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
  State<checkoutProductPage> createState() => _checkoutProductPageState();
}

final CollectionReference<Map<String, dynamic>> dbEthriftRef =
    FirebaseFirestore.instance.collection('Orders');

class _checkoutProductPageState extends State<checkoutProductPage> {
  String selectedPaymentMethod = 'none selected';
  String? selectedDeliveryMethod = 'none selected';

  late String productName;
  late String productDescription;
  late double productPrice;
  late String username;
  late String sellerEmail;
  late String sellerID;
  late String image;

  // Razorpay _razorpay = Razorpay();

  var currentDateTime;

  @override
  void initState() {
    super.initState();

    //_razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Set the product details using passed arguments
    productName = widget.productName;
    productPrice = widget.productPrice;
    username = widget.username; //seller username
    sellerEmail = widget.sellerEmail;
    sellerID = widget.sellerId;
    image = widget.imageUrl; // pass gambar product
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear(); //remove al listeners
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
          color: Colors.black, // Set text color to black
        ),
      ),
    ),
    const DropdownMenuItem(
      value: 'Cash',
      child: Text(
        'Cash',
        style: TextStyle(
          color: Colors.black, // Set text color to black
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // Format the date and time separately
    String formattedDate = DateFormat('EEEE, MMMM d y')
        .format(now); // Example: Monday, January 1 2024

    String formattedTime = DateFormat('HH:mm').format(now); // Example: 14:30

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
                      'Nama Penjual: ${username}',
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
                            image: NetworkImage(widget
                                .imageUrl), // Use the passed image URL here
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

            //date
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

            //delivery method
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

            // Radio buttons for delivery method
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

            // payment method
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                      color: Colors.white, // Set text color to white
                      fontSize: 16, // Set text size to 20
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

            // total price
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

            //button checkout
            // Button
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
                          // Pass the amount as per your requirement
                        } else if (selectedPaymentMethod == 'Cash') {
                          // Generate a custom payment ID for cash payment
                          onPaymentSuccess();

                          // Show payment success message

                          // Navigate back to the main menu
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => MainMenuPage()),
                          // );
                        } else {
                          // Handle case where payment method is not selected
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
    // Convert product price to the smallest currency unit (e.g., paise, cents)
    int amountInPaise = (productPrice * 100)
        .round(); // Assuming the currency is in RM (Malaysian Ringgit)

    // Generate a custom payment ID for cash payment
    String paymentId = 'cash_${DateTime.now().millisecondsSinceEpoch}';

    var options = {
      'key': 'rzp_test_b51VPQzfFPzvwD', // aqil punya razorpay key id
      //'key': 'rzp_test_rQw0BYEcOhy8Bj', // Replace with your Razorpay key
      'amount': amountInPaise,
      'name': 'eThrift UKM',
      'description': 'Reference No. #123456',
      'prefill': {'email': 'anis.biha88@gmail.com', 'contact': '0196773641'},
      // 'external': {
      //   'wallets': ['paytm']
      // },
      'currency': 'MYR', // Set the currency here
      'paymentId': paymentId,
      //'image': 'lib/images/e-thrift.png', // URL to your logo image
    };

    try {
      // _razorpay.open(options);
    } catch (e) {
      // debugPrint('Error in starting Razorpay Checkout: $e');
    }
  }

  //if the transaction is success

  Future<void> onPaymentSuccess() async {
    // Get the current user
    String buyerID = FirebaseAuth.instance.currentUser!.uid;

    // Get the name of the buyer
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(buyerID).get();
    String username = userSnapshot['username'];

    // Generate order id
    String orderId = FirebaseFirestore.instance.collection('Orders').doc().id;

    // Get the current date and time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d y')
        .format(now); // Example: Monday, January 1 2024
    String formattedTime = DateFormat('HH:mm').format(now);

    // Define the order reference
    DocumentReference orderRef = FirebaseFirestore.instance
        .collection('Orders')
        .doc(buyerID)
        .collection(sellerID)
        .doc(orderId);

    // Update product availability to "not available" for the purchased product
    await FirebaseFirestore.instance
        .collection('AllProducts')
        .doc(widget.productId) // Access productId from widget
        .update({
      "availability": "not available",
    });

    // Update product availability to "not available" (pov seller)
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(sellerID)
        .collection('Products')
        .doc(widget.productId) // Access productId from widget
        .update({
      "availability": "not available",
    });

    // Store order details in Firestore under "Orders"
    await orderRef.set({
      "productName": productName,
      "productPrice": productPrice,
      "deliveryMethod": selectedDeliveryMethod,
      "paymentMethod": selectedPaymentMethod,
      "sellerName": widget
          .username, // Assuming sellerName is stored in Products collection
      "sellerEmail":
          sellerEmail, // Assuming sellerEmail is stored in Products collection
      "buyerName": username,
      "buyerId": buyerID, // Assuming buyer name is stored in Users collection
      "image": image,
      "currentDate": formattedDate,
      "currentTime": formattedTime, // Add current time
      "orderId": orderId,
      "productId": widget.productId,
      // You can add more fields here if needed
    });

    // Store order details in Firestore under "Sales"
    // Store product details in the "AllProducts" collection
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
      "sellerName": widget
          .username, // Assuming sellerName is stored in Products collection
      "sellerEmail":
          sellerEmail, // Assuming sellerEmail is stored in Products collection
      "buyerName": username,
      "buyerId": buyerID,
      "image": image,
      "currentDate": formattedDate,
      "currentTime": formattedTime,
      "orderId": orderId,
      "productId": widget.productId,
    });

    // Navigate back to the main menu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuPage()),
    );
  }
}
