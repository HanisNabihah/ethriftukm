// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// import '../screenBuyer/history.dart';
// import '../screenBuyer/reviews.dart';
// import '../screenSeller/uploadProduct.dart';
// import 'mainmenu.dart';
// import 'profile/profile.dart';

//   @override
//   Widget build(BuildContext context) {
    

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(15),
//                 child: Row(
//                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                   children: [
//      //bottom navigation bar (home, history, add product, comment, profile)
//       Container(
//         color: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        
//           child: GNav(
//             backgroundColor: Colors.black,
//             color: Colors.white,
//             activeColor: Colors.white,
//             tabBackgroundColor: Colors.grey.shade800,
//             onTabChange: (index){
//               switch(index){
//                 case 0:
//                 // Navigate to the Home page
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => MainMenuPage()));
//                   break;

//                 case 1:
//                 // Navigate to the History page
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => HistoryPage()));
//                   break;
//                 case 2:
//                 // Navigate to the Sell Product page
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => uploadProductPage()));
//                   break;
//                 case 3:
//                 // Navigate to the Comment page
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => ReviewPage()));
//                   break;
//                 case 4:
//                 // Navigate to the Profile page
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => ProfilePage()));
//                   break;  
//               }
//             },

//             tabs: const [
//               GButton(
//                 icon: Icons.home, 
//             //text: 'Home'
//               ),

//               GButton(icon: Icons.history),

//               GButton(icon: Icons.add_box, text: 'Sell'),

//               GButton(icon: Icons.mode_comment),

//               GButton(icon: Icons.account_circle),
//             ],
//           ),
//           ),
//        ),
//                      ],
//           ),
//           ),
//             ],
//        ),
//         ),
//       ),

      

//     );

    
//   }