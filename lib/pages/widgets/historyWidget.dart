//page untuk design kotak for history
//tak jadi lagi

import 'package:flutter/material.dart';

class historyWidgetPage extends StatefulWidget {
  const historyWidgetPage({super.key});

  @override
  State<historyWidgetPage> createState() => _historyWidgetPageState();
}

class _historyWidgetPageState extends State<historyWidgetPage> {
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
        title: const Text('History'),
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Seller Name',
                      style: TextStyle(
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
                        margin: const EdgeInsets.only(
                            top: 12, left: 20, bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/images/nana.png'), // Use the passed image URL here
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
                              //date Time
                              const SizedBox(height: 20),
                              const Text(
                                'Date Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),

                              //Product Name
                              const SizedBox(height: 10),
                              const Text(
                                'productName',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),

                              //Product Price
                              const SizedBox(height: 10),
                              const Text(
                                'product Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),

                              //Button Rate
                              //Button Rate
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end, // Align to the end
                                  children: [
                                    RawMaterialButton(
                                      fillColor:
                                          const Color.fromARGB(255, 101, 13, 6),
                                      elevation: 0.0,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                      ),
                                      onPressed: () {
                                        // Handle button press
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8), // Add padding here
                                        child: Text(
                                          "RATE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
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
            ),
          ],
        ),
      ),
    );
  }
}
