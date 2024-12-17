import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/profile/crudProduct.dart';
import 'package:ethriftukm_fyp/pages/profile/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

@override
class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  Map<String, dynamic>? _userData;
  late Future<List<DocumentSnapshot>> _productsFuture;
  final Map<String, bool> _isOrderAccepted = {};
  final Map<String, bool> _isOrderRejected = {};

  @override
  void initState() {
    super.initState();

    _fetchUserData().then((userData) {
      setState(() {
        _userData = userData;
      });
    });
    _productsFuture = _fetchProducts();

    _fetchUserData();
    _fetchOrders();
    _fetchProducts();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();
    return userSnapshot.data() ?? {};
  }

  Future<List<QueryDocumentSnapshot<Object?>>> _fetchProducts() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(userID)
        .collection('Products')
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot<Object?>>> _fetchOrders() async {
    String sellerID = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot salesSnapshot = await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .get();

    return salesSnapshot.docs;
  }

  Future<DocumentSnapshot?> getUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      return userData;
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

  Future<void> navigateToCrudProductPage(
      BuildContext context, int index) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .doc(userId)
        .collection('Products')
        .get();

    var products = productSnapshot.docs;

    if (products.isNotEmpty) {
      var product = products[index];
      var productData = product.data() as Map<String, dynamic>;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CrudProductPage(
            productId: product.id,
            imageUrl: productData['image'],
            productName: productData['name'],
            productPrice: productData['price'].toDouble(),
            productCategory: productData['category'],
            productDesc: productData['description'],
          ),
        ),
      );
    }
  }

  Future<void> _setOrderState(String orderId, bool isAccepted) async {
    final prefs = await SharedPreferences.getInstance();
    if (isAccepted) {
      await prefs.setBool('accepted_$orderId', true);
      setState(() {
        _isOrderAccepted[orderId] = true;
      });
    } else {
      await prefs.setBool('rejected_$orderId', true);
      setState(() {
        _isOrderRejected[orderId] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

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
        title: Text(
          'Profil',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User data not found'));
          } else {
            var userData = snapshot.data!;
            var profileImageUrl = userData['profileImageUrl'];
            bool displayProfilePicture =
                profileImageUrl != null && profileImageUrl.isNotEmpty;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: displayProfilePicture
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 70,
                            )
                          : Image.asset(
                              'lib/images/default-profilephoto.jpeg',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userData?['username'] ?? 'Username not found',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _userData?['phone'] ?? 'Phone number not found',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateProfile(),
                              ),
                            ),
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 101, 13, 6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(0),
                            child: const Center(
                              child: Text(
                                'Kemaskini Profil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )),
                    Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                            labelPadding:
                                const EdgeInsets.only(left: 30, right: 80),
                            controller: tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: CircleTabIndicator(
                                color: Colors.black, radius: 4),
                            tabs: const [
                              Tab(text: "Produk"),
                              Tab(text: "Jualan"),
                            ]),
                      ),
                    ),
                    Container(
                      height: 500,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          FutureBuilder<List<DocumentSnapshot>>(
                            future: _productsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<DocumentSnapshot> products =
                                    snapshot.data ?? [];
                                products = products
                                    .where((product) =>
                                        product['availability'] == 'available')
                                    .toList();
                                if (products.isEmpty) {
                                  return const Center(
                                      child: Text('Tiada Produk Dijumpai'));
                                } else {
                                  return GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.68,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      for (int i = 0; i < products.length; i++)
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 10),
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    navigateToCrudProductPage(
                                                        context, i),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.network(
                                                    products[i]['image'],
                                                    height: 170,
                                                    width: 170,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    products[i]['name'],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "RM ${products[i]['price']}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                }
                              }
                            },
                          ),
                          FutureBuilder<List<DocumentSnapshot>>(
                              future: _fetchOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else {
                                  List<DocumentSnapshot> orders =
                                      snapshot.data ?? [];
                                  if (orders.isEmpty) {
                                    return const Center(
                                        child: Text('Tiada Jualan Dijumpai'));
                                  } else {
                                    return ListView.builder(
                                        itemCount: orders.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> orderData =
                                              orders[index].data()
                                                  as Map<String, dynamic>;

                                          String orderId = orderData['orderId'];
                                          _isOrderAccepted.putIfAbsent(
                                              orderId,
                                              () =>
                                                  orderData['status'] ==
                                                  'accepted');

                                          _isOrderRejected.putIfAbsent(
                                              orderId,
                                              () =>
                                                  orderData['status'] ==
                                                  'rejected');

                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                                  child: Text(
                                                    'Maklumat Pesanan',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      height: 120,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              left: 20,
                                                              bottom: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              orderData[
                                                                  'image']),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                20, 0, 20, 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 20),
                                                            Text(
                                                              orderData[
                                                                  'currentDate'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              orderData[
                                                                  'currentTime'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              orderData[
                                                                      'productName'] ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "RM ${orderData['productPrice'] ?? ''}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  if (orderData[
                                                                              'status'] !=
                                                                          'accepted' &&
                                                                      orderData[
                                                                              'status'] !=
                                                                          'rejected')
                                                                    RawMaterialButton(
                                                                      fillColor:
                                                                          Colors
                                                                              .lightBlueAccent,
                                                                      elevation:
                                                                          0.0,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(150),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        onAcceptOrder(
                                                                            orderData);
                                                                        onAcceptOrder(
                                                                            orderData);
                                                                        await _setOrderState(
                                                                            orderId,
                                                                            true);
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "ACCEPT",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (orderData[
                                                                              'status'] !=
                                                                          'accepted' &&
                                                                      orderData[
                                                                              'status'] !=
                                                                          'rejected')
                                                                    RawMaterialButton(
                                                                      fillColor:
                                                                          Colors
                                                                              .red,
                                                                      elevation:
                                                                          0.0,
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(150),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        onRejectOrder(
                                                                            orderData);
                                                                        await _setOrderState(
                                                                            orderId,
                                                                            false);
                                                                      },
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16,
                                                                          vertical:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "REJECT",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14,
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
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> onAcceptOrder(Map<String, dynamic> orderData) async {
    String sellerID = FirebaseAuth.instance.currentUser!.uid;

    String orderId = orderData['orderId'];
    String buyerId = orderData['buyerId'];
    String productId = orderData['productId'];

    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .doc(orderId)
        .update({
      'status': 'accepted',
    });
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(sellerID)
        .collection('Products')
        .doc(productId)
        .update({"availability": "not available"});
    await FirebaseFirestore.instance
        .collection('AllProducts')
        .doc(productId)
        .update({"availability": "not available"});

    await FirebaseFirestore.instance
        .collection('Products')
        .doc(sellerID)
        .collection('Products')
        .get();

    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .doc(orderId)
        .get();

    await FirebaseFirestore.instance
        .collection('History')
        .doc(buyerId)
        .collection('HistoryDetails')
        .doc(orderId)
        .set({
      "status": "ACCEPTED",
      "sellerId": sellerID,
      "productName": orderSnapshot['productName'],
      "productPrice": orderSnapshot['productPrice'],
      "deliveryMethod": orderSnapshot['deliveryMethod'],
      "paymentMethod": orderSnapshot['paymentMethod'],
      "sellerName": orderSnapshot['sellerName'],
      "sellerEmail": orderSnapshot['sellerEmail'],
      "buyerName": orderSnapshot['buyerName'],
      "buyerId": orderSnapshot['buyerId'],
      "image": orderSnapshot['image'],
      "currentDate": orderSnapshot['currentDate'],
      "currentTime": orderSnapshot['currentTime'],
      "orderId": orderId,
      "statusReview": "Not Review",
    });
  }

  Future<void> onRejectOrder(Map<String, dynamic> orderData) async {
    String sellerID = FirebaseAuth.instance.currentUser!.uid;

    String orderId = orderData['orderId'];
    String buyerId = orderData['buyerId'];
    String productId = orderData['productId'];

    await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .doc(orderId)
        .update({'status': 'rejected'});
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('Sales')
        .doc(sellerID)
        .collection('Orders')
        .doc(orderId)
        .get();
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(sellerID)
        .collection('Products')
        .doc(productId)
        .update({"availability": "available"});
    await FirebaseFirestore.instance
        .collection('AllProducts')
        .doc(productId)
        .update({"availability": "available"});
    await FirebaseFirestore.instance
        .collection('History')
        .doc(buyerId)
        .collection('HistoryDetails')
        .doc(orderId)
        .set({
      "status": "REJECTED",
      "productName": orderSnapshot['productName'],
      "productPrice": orderSnapshot['productPrice'],
      "deliveryMethod": orderSnapshot['deliveryMethod'],
      "paymentMethod": orderSnapshot['paymentMethod'],
      "sellerName": orderSnapshot['sellerName'],
      "sellerEmail": orderSnapshot['sellerEmail'],
      "buyerName": orderSnapshot['buyerName'],
      "buyerId": orderSnapshot['buyerId'],
      "image": orderSnapshot['image'],
      "currentDate": orderSnapshot['currentDate'],
      "currentTime": orderSnapshot['currentTime'],
      "orderId": orderId,
    });
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;
  const CircleTabIndicator({required this.color, required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint _paint = Paint();
    _paint.color = color;
    _paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius);

    canvas.drawCircle(offset + circleOffset, radius, _paint);
  }
}
