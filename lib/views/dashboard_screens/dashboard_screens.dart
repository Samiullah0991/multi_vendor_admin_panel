import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = '/dashboard';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Stats Cards Row
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard(
                      context,
                      title: "Total Orders",
                      value: "1,245",
                      icon: Iconsax.shopping_cart,
                      color: Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      title: "Active Buyers",
                      value: "856",
                      icon: Iconsax.profile_2user,
                      color: Colors.green,
                    ),
                    _buildStatCard(
                      context,
                      title: "Total Vendors",
                      value: "128",
                      icon: Iconsax.shop,
                      color: Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      title: "Categories",
                      value: "24",
                      icon: Iconsax.category,
                      color: Colors.purple,
                    ),
                    _buildStatCard(
                      context,
                      title: "Products",
                      value: "2,456",
                      icon: Iconsax.box,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Charts Section
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildChartCard(
                      title: "Orders Overview",
                      child: Container(
                        height: 300,
                        color: Colors.white,
                        child: Center(child: Text("Orders Chart Here")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: _buildChartCard(
                      title: "Top Categories",
                      child: Container(
                        height: 300,
                        color: Colors.white,
                        child: Center(child: Text("Categories Chart Here")),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Recent Orders Table
              _buildChartCard(
                title: "Recent Orders",
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Customer")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Amount")),
                  ],
                  rows: List.generate(5, (index) => DataRow(
                    cells: [
                      DataCell(Text("#ORD${1000 + index}")),
                      DataCell(Text("Customer ${index + 1}")),
                      DataCell(
                        Chip(
                          label: Text(
                            ["Completed", "Processing", "Shipped"][index % 3],
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                          ["Completed", "Processing", "Shipped"][index % 3] == "Completed"
                              ? Colors.green
                              : (["Completed", "Processing", "Shipped"][index % 3] == "Processing"
                              ? Colors.orange
                              : Colors.blue),
                        ),
                      ),
                      DataCell(Text("\$${(index + 1) * 25}.00")),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 15),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const Icon(Icons.more_vert, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }
}