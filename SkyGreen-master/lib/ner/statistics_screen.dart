import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
class StatisticsScreen extends StatefulWidget {
  final String userId; // Assurez-vous de passer l'ID de l'utilisateur à cette page

  StatisticsScreen({required this.userId});
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<Map<String, dynamic>> statistics;
  @override
  void initState() {
    super.initState();
    statistics = fetchStatistics();
  }

  Future<Map<String, dynamic>> fetchStatistics() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/statistics/${widget.userId}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load statistics');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildStatisticsContent();
          }
        },
      ),
    );
  }

  // Widget _buildStatisticsContent() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SizedBox(height: 16),
  //         CircleAvatar(
  //           backgroundImage: AssetImage('assets/images/nn.jpg'), // Remplacez par le chemin de votre image de profil
  //           radius: 60,
  //         ),
  //         SizedBox(height: 16),
  //         _buildUserStatistics(),
  //         SizedBox(height: 16),
  //         _buildCharts(),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildStatisticsContent() {
    Map<String, dynamic> statisticsData = {};
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/nn.jpg'),
            radius: 60,
          ),
          SizedBox(height: 16),
          _buildUserStatistics(),
          SizedBox(height: 16),
          _buildCharts(),
        ],
      ),
    );
  }

  Widget _buildUserStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard("Vues de profil", "500", Icons.visibility),
        _buildStatCard("Likes", "300", Icons.thumb_up),
        _buildStatCard("Commentaires", "150", Icons.comment),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Column(
      children: [
        Text(
          'Activité récente',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildBarChart(),
        SizedBox(height: 16),
        _buildPieChart(),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 20,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(y: 5, width: 16)],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(y: 8, width: 16)],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [BarChartRodData(y: 6, width: 16)],
              showingTooltipIndicators: [0],
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true),
            bottomTitles: SideTitles(showTitles: true),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 30,
              color: Colors.blue,
              title: 'Likes',
              radius: 40,
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.green,
              title: 'Commentaires',
              radius: 50,
            ),
            PieChartSectionData(
              value: 50,
              color: Colors.orange,
              title: 'Vues',
              radius: 60,
            ),
          ],
        ),
      ),
    );
  }
}
