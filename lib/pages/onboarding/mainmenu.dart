import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ethriftukm_fyp/pages/onboarding/navBar.dart';
import 'package:ethriftukm_fyp/pages/products/beautySkincare.dart';
import 'package:ethriftukm_fyp/pages/products/computerTech.dart';
import 'package:ethriftukm_fyp/pages/products/likes.dart';
import 'package:ethriftukm_fyp/pages/products/mensFashion.dart';
import 'package:ethriftukm_fyp/pages/products/searchResults.dart';
import 'package:ethriftukm_fyp/pages/products/womensFashion.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../firestore/productWidgetFirestore.dart';
import '../../firestore/uploadProductFirestore.dart';
import '../../screenBuyer/history.dart';
import '../profile/profile.dart';
import '../../screenSeller/reviews.dart';
import '../../screenSeller/product.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage>
    with TickerProviderStateMixin {
  String selectedProductName = '';
  double selectedProductPrice = 0.0;
  String selectedImageUrl = '';

  late List<Product> availableProducts = [];

  void handleProductSelected(
      String productName, double productPrice, String imageUrl) {
    setState(() {
      selectedProductName = productName;
      selectedProductPrice = productPrice;
      selectedImageUrl = imageUrl;
    });
  }

  List<Product> productList = [];
  late String _username = 'Users';

  Future<void> fetchAvailableProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Products')
        .where('availability', isEqualTo: 'available')
        .get();

    List<Product> products =
        querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

    setState(() {
      availableProducts = products;
    });
  }

  Future<void> _refreshData(bool reload) async {
    if (reload) {
      await fetchUsername();
      await fetchAvailableProducts();
      setState(() {});
    }
  }

  String searchQuery = '';
  // }
  List<DocumentSnapshot> searchResults = [];

  Future<void> searchProduct(String query) async {
    // Clear previous search results
    setState(() {
      searchResults = [];
    });

    // Query Firestore for products matching the search term
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('AllProducts')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        searchResults = querySnapshot.docs;
      });
    } catch (error) {
      print('Error searching for products: $error');
    }
  }

  void navigateToCategoryLocation(int index) {
    setState(() {});
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WomensFashionPage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MensFashionPage()));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BeautySkincarePage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ComputerTechPage()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData(true);
  }

  Future<void> fetchUsername() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    setState(() {
      _username = userSnapshot['username'];
    });
  }

  List<String> images = [
    'lib/images/womens-fashion.png',
    'lib/images/mens-fashion.png',
    'lib/images/beauty-skincare.png',
    'lib/images/computer-tech.png',
  ];

  List<String> categoryNames = [
    "Fesyen Wanita",
    "Fesyen Lelaki",
    "Alat Solek",
    "Komputer Teknologi",
  ];

  @override
  Widget build(BuildContext context) {
    // TabController _tabController = TabController(length: 4, vsync: this);

    return Scaffold(
      drawer: const navBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Welcoming The user
                      Text(
                        'Selamat Datang $_username!',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      //tempat favourite/likes macam add to cart
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the selected page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LikesPage(
                                        productName: selectedProductName,
                                        productPrice: selectedProductPrice,
                                        imageUrl: selectedImageUrl,
                                      )),
                            );
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //search box
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          onSubmitted: (value) {
                            //searchProduct(value);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchResultsPage(query: value),
                              ),
                            );
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Carian',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //searchProduct(searchQuery);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultsPage(query: searchQuery),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.search,
                          size: 27,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //list of category (tabbar)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the desired location based on the category index
                            navigateToCategoryLocation(index);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                // Placeholder for the image or photo
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                  height: 8), // Adjust spacing as needed
                              Text(
                                categoryNames[
                                    index], // Replace with actual category name
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                //gambar product (gambar, nama, harga)
                ProductsWidgetFirestore(
                  products: availableProducts,
                  onProductSelected: handleProductSelected,
                ),
              ],
            ),
          ),
        ),
      ),

      //bottom navigation bar (home, history, add product, comment, profile)
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            onTabChange: (index) {
              switch (index) {
                case 0:
                  // Navigate to the Home page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainMenuPage()));
                  break;

                case 1:
                  // Navigate to the History page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryPage()));
                  break;
                case 2:
                  // Navigate to the Sell Product page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => uploadProductPage()));
                          builder: (context) =>
                              const UploadProductFirestorePage()));
                  break;
                case 3:
                  // Navigate to the Comment page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReviewPage()));
                  break;
                case 4:
                  // Navigate to the Profile page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  break;
              }
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                //text: 'Home'
              ),
              GButton(icon: Icons.history),
              GButton(icon: Icons.add_box),
              GButton(icon: Icons.mode_comment),
              GButton(icon: Icons.account_circle),
            ],
          ),
        ),
      ),
    );
  }
}

//untuk category punya custom
class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;
  CircleTabIndicator({required this.color, required this.radius});
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
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
        configuration.size!.width / 2 - radius / 2,
        configuration.size!.height - radius);

    canvas.drawCircle(offset + circleOffset, radius, paint);
  }
}
