import 'package:carbon_intensity/controller/carbon_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Carbon Intensity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  final CarbonController carbonController = Get.put(CarbonController());

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carbon Intensity',
          style: TextStyle(color: Colors.blueAccent),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (carbonController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 15, vertical: 5), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reload text and button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reload the data',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: width * 0.04,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          carbonController.fetchCarbonIntensityData(),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.blueAccent,
                        size: width * 0.06,
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.02),

                // Carbon Intensity Card
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 2)),
                  padding: EdgeInsets.all(width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'National Carbon Intensity',
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.05),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        carbonController.carbonIntensity.value,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          thickness: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Carbon intensity is high!\nMaybe take a break and read a book instead 📖',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: width * 0.04),
                            ),
                          ),
                          CircleAvatar(
                            radius: width * 0.12,
                            backgroundColor: Colors.black,
                            child: Text(
                              carbonController.intensityLevel.value,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),

                // Chart Title
                Text(
                  'National half-hourly carbon intensity for the current day.',
                  style: TextStyle(
                      color: Colors.blueAccent, fontSize: width * 0.045),
                ),
                SizedBox(height: height * 0.02),

                // Chart
                SizedBox(
                  height: height * 0.4, // Fixed height for the chart
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: carbonController.carbonValues,
                            isCurved: false,
                            color: Colors.blueAccent,
                            dotData: FlDotData(show: false),
                            isStrokeCapRound: false,
                            isStrokeJoinRound: false,
                          ),
                        ],
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.white24),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: width * 0.1,
                              // textStyle: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              // textStyle: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              // textStyle: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              // textStyle: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
