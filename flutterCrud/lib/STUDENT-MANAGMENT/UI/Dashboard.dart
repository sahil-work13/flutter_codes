import 'package:flutter/material.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/StudentController/StudentController.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/AddStudent.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/DisplayStudent.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/UI/Profile.dart';
import 'package:fluttercrud/STUDENT-MANAGMENT/model/StudentModel.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final Studentcontroller controller = Get.put(Studentcontroller());

  // --- OFFICIAL PRODUCTION PALETTE ---
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  final List<String> _pageTitles = [
    "Dashboard Overview",
    "Student Registration",
    "Student Directory",
    "My Profile"
  ];

  List<Widget> _getPages(bool isMobile) {
    return [
      _buildHomeContent(isMobile),
      const AddStudentPage(),
      Displaystudent(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

      return Scaffold(
        backgroundColor: scaffoldBg,
        body: Row(
          children: [
            if (!isMobile) _buildSidebar(isTablet),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(isMobile),
                  Expanded(child: _getPages(isMobile)[_selectedIndex]),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: isMobile ? _buildBottomNav() : null,
      );
    });
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40, vertical: 24),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pageTitles[_selectedIndex], // Dynamic Title based on index
            style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: slate900
            ),
          ),
          const SizedBox(height: 4),
          Text(
              _selectedIndex == 0
                  ? "Real-time performance metrics"
                  : "Manage your system records",
              style: TextStyle(color: slate500, fontSize: 14)
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(bool isMobile) {
    return Obx(() {
      final students = controller.students;

      // DYNAMIC STATS
      final total = students.length;
      final graduated = students.where((s) => s.isGraduated).length;
      final activeSubjects = students.expand((s) => s.subjects).toSet().length;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
        child: Column(
          children: [
            // Dynamic Cards with proper sizing
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildStatCard("Total Students", total.toString(), Icons.people_rounded, isMobile),
                _buildStatCard("Active Subjects", activeSubjects.toString(), Icons.auto_awesome_mosaic_rounded, isMobile),
                _buildStatCard("Success Rate", "${total == 0 ? 0 : ((graduated/total)*100).toInt()}%", Icons.insights_rounded, isMobile),
              ],
            ),
            const SizedBox(height: 40),
            // Corrected Aesthetic Line Chart
            _buildAestheticLineChart(isMobile, students),
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isMobile) {
    final isHovered = false.obs;
    return Obx(() => MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isMobile ? double.infinity : 280,
        padding: const EdgeInsets.all(24),
        transform: isHovered.value ? (Matrix4.identity()..translate(0, -10, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isHovered.value ? primaryColor.withOpacity(0.1) : Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor, size: 32),
            const SizedBox(height: 20),
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: slate900)),
            Text(title, style: TextStyle(color: slate500, fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        ),
      ),
    ));
  }

  // --- DYNAMIC LINE CHART (Corrected & Aesthetic) ---
  Widget _buildAestheticLineChart(bool isMobile, List<StudentModel> students) {
    // Generate Last 6 Months Labels and Data
    List<DateTime> months = List.generate(6, (i) => DateTime.now().subtract(Duration(days: i * 30))).reversed.toList();
    List<FlSpot> spots = [];

    for (int i = 0; i < months.length; i++) {
      double count = students.where((s) => s.joinedAt.month == months[i].month && s.joinedAt.year == months[i].year).length.toDouble();
      spots.add(FlSpot(i.toDouble(), count));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 32, 20), // Added padding for labels
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text("Registration Trends", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: slate900)),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey[100], strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: TextStyle(color: slate500, fontSize: 12)),
                      )
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (val, meta) {
                        int idx = val.toInt();
                        if (idx < 0 || idx >= months.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(DateFormat('MMM').format(months[idx]), style: TextStyle(color: slate500, fontWeight: FontWeight.bold, fontSize: 12)),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isEmpty ? [const FlSpot(0,0)] : spots,
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isTablet) {
    return Container(
      width: isTablet ? 80 : 250,
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[100]!))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: primaryColor, size: 40),
                if (!isTablet) ...[
                  const SizedBox(height: 8),
                  Text("STUDENT", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: slate900, letterSpacing: 1.5)),
                  Text("MANAGEMENT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor)),
                ]
              ],
            ),
          ),
          Expanded(
            child: NavigationRail(
              extended: !isTablet,
              backgroundColor: Colors.white,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_rounded), label: Text("Dashboard")),
                NavigationRailDestination(icon: Icon(Icons.person_add_rounded), label: Text("Registration")),
                NavigationRailDestination(icon: Icon(Icons.view_list_rounded), label: Text("Directory")),
                NavigationRailDestination(icon: Icon(Icons.account_circle_rounded), label: Text("Profile")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: primaryColor,
      unselectedItemColor: slate500,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person_add_rounded), label: "Add"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list_rounded), label: "List"),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Me"),
      ],
    );
  }
}