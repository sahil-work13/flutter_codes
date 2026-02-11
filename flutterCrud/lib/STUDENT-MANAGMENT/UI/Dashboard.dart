import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Production Palette
  final Color primaryColor = const Color(0xFF6366F1);
  final Color slate900 = const Color(0xFF0F172A);
  final Color slate500 = const Color(0xFF64748B);
  final Color scaffoldBg = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine layout based on screen width
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
        final isDesktop = constraints.maxWidth >= 1200;

        if (isMobile) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopTabletLayout(isTablet);
        }
      },
    );
  }

  // --- MOBILE LAYOUT (Bottom Navigation) ---
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile: true),
              const SizedBox(height: 24),
              _buildStatCards(isMobile: true),
              const SizedBox(height: 24),
              _buildChartsSection(isMobile: true),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: slate500,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }

  // --- TABLET/DESKTOP LAYOUT (Side Navigation) ---
  Widget _buildDesktopTabletLayout(bool isTablet) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebar(isTablet),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 20.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isMobile: false),
                    const SizedBox(height: 32),
                    _buildStatCards(isMobile: false, isTablet: isTablet),
                    const SizedBox(height: 32),
                    _buildChartsSection(isMobile: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSidebar(bool isTablet) {
    return NavigationRail(
      backgroundColor: Colors.white,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
      labelType: isTablet
          ? NavigationRailLabelType.selected
          : NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: primaryColor, size: 24),
      unselectedIconTheme: IconThemeData(color: slate500, size: 22),
      minWidth: isTablet ? 60 : 80,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_add),
          label: Text('Add'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text('Students'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_circle),
          label: Text('Profile'),
        ),
      ],
    );
  }

  Widget _buildHeader({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "System Overview",
          style: TextStyle(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: slate900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Welcome back, Admin",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: slate500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards({required bool isMobile, bool isTablet = false}) {
    final stats = [
      {"title": "Total Students", "value": "1,284", "icon": Icons.people, "color": Colors.blue},
      {"title": "Graduated", "value": "450", "icon": Icons.school, "color": Colors.green},
      {"title": "Attendance", "value": "92%", "icon": Icons.check_circle, "color": Colors.orange},
    ];

    if (isMobile) {
      // Stack vertically on mobile
      return Column(
        children: stats
            .map((stat) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSingleStatCard(
            stat["title"] as String,
            stat["value"] as String,
            stat["icon"] as IconData,
            stat["color"] as Color,
            isMobile: true,
          ),
        ))
            .toList(),
      );
    } else if (isTablet) {
      // 2 columns on tablet with wrap
      final cardWidth = (MediaQuery.of(context).size.width - 120) / 2 - 16;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: stats
            .map((stat) => SizedBox(
          width: cardWidth,
          child: IntrinsicHeight(
            child: _buildSingleStatCard(
              stat["title"] as String,
              stat["value"] as String,
              stat["icon"] as IconData,
              stat["color"] as Color,
              isMobile: false,
            ),
          ),
        ))
            .toList(),
      );
    } else {
      // Row layout for desktop
      return Row(
        children: stats
            .map((stat) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildSingleStatCard(
              stat["title"] as String,
              stat["value"] as String,
              stat["icon"] as IconData,
              stat["color"] as Color,
              isMobile: false,
            ),
          ),
        ))
            .toList(),
      );
    }
  }

  Widget _buildSingleStatCard(
      String title,
      String value,
      IconData icon,
      Color color, {
        required bool isMobile,
      }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: isMobile ? 18 : 20,
            child: Icon(icon, color: color, size: isMobile ? 18 : 20),
          ),
          SizedBox(height: isMobile ? 8 : 10),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: slate900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: slate500,
              fontSize: isMobile ? 11 : 12,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection({required bool isMobile}) {
    return Container(
      height: isMobile ? 250 : 300,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enrollment Trends",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: slate900,
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => primaryColor.withOpacity(0.8),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2, 5),
                      FlSpot(4, 4),
                      FlSpot(6, 8),
                      FlSpot(8, 6),
                      FlSpot(10, 9),
                    ],
                    isCurved: true,
                    color: primaryColor,
                    barWidth: isMobile ? 3 : 4,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryColor.withOpacity(0.1),
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
}