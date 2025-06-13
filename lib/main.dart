import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin_panel/views/dashboard_screens/dashboard_screens.dart';
import 'package:web_admin_panel/views/screens/buyers_screen.dart';
import 'package:web_admin_panel/views/screens/category_screen.dart';
import 'package:web_admin_panel/views/screens/order_screen.dart';
import 'package:web_admin_panel/views/screens/product_screen.dart';
import 'package:web_admin_panel/views/screens/upload_banner_screen.dart';
import 'package:web_admin_panel/views/screens/vendors_screen.dart';
import 'package:web_admin_panel/views/screens/withdrawal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
          apiKey: "AIzaSyCfLhXARl8G8gjGxc3kS0kCG_-UoAu4BII",
          authDomain: "sam-multi-store.firebaseapp.com",
          projectId: "sam-multi-store",
          storageBucket: "sam-multi-store.firebasestorage.app",
          messagingSenderId: "52631389824",
          appId: "1:52631389824:web:4ba75da5817f3b24a94865")
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Web Panel',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}

class SideMenu extends StatefulWidget {
  static const String id = '/sideMenu';

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashboardScreen();
  final TextEditingController _searchController = TextEditingController();

  screnSelectore(item) {
    switch (item.route) {
      case DashboardScreen.id:
        setState(() {
          _selectedScreen = DashboardScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
        break;
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case WithrawalScreen.id:
        setState(() {
          _selectedScreen = WithrawalScreen();
        });
        break;
      case OrderScreen.routeName:
        setState(() {
          _selectedScreen = OrderScreen();
        });
        break;
      case UploadBanners.id:
        setState(() {
          _selectedScreen = UploadBanners();
        });
        break;
      case ProductScreen.routeName:
        setState(() {
          _selectedScreen = ProductScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SAM ADMIN PANEL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Withdrawal',
            route: WithrawalScreen.id,
            icon: CupertinoIcons.money_dollar,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrderScreen.routeName,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category_rounded,
            route: CategoryScreen.id,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            icon: CupertinoIcons.add,
            route: UploadBanners.id,
          ),
          AdminMenuItem(
            title: 'Products',
            icon: CupertinoIcons.shopping_cart,
            route: ProductScreen.routeName,
          ),
        ],
        selectedRoute: DashboardScreen.id,
        onSelected: (item) {
          screnSelectore(item);
        },
        header: Container(
          height: 100,
          width: double.infinity,
          color: Colors.yellow.shade700,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'SAM ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: Container(
          height: 60,
          width: double.infinity,
          color: const Color(0xff444444),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '© 2025 SAM Multi Store. All Rights Reserved',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      body: _selectedScreen,
    );
  }
}