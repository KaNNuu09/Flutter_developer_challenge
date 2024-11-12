// lib/controllers/carbon_controller.dart
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CarbonController extends GetxController {
  // API data variables
  var carbonIntensity = ''.obs;
  var intensityLevel = ''.obs;
  var carbonValues = <FlSpot>[].obs; // Use FlSpot for chart points

  // Loading state
  var isLoading = false.obs;

  // Fetch data from the API
  Future<void> fetchCarbonIntensityData() async {
    isLoading.value = true;

    try {
      // Fetching current intensity
      final response = await http.get(
        Uri.parse('https://api.carbonintensity.org.uk/intensity'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final intensityData = data['data'][0];

        carbonIntensity.value =
            '${intensityData['intensity']['actual']} gCO₂/kWh';
        intensityLevel.value =
            _getIntensityLevel(intensityData['intensity']['actual']);
      } else if (response.statusCode == 400) {
        Get.snackbar("Error", "Bad Request: Invalid parameters provided.");
      } else if (response.statusCode == 500) {
        Get.snackbar("Error", "Internal Server Error: Please try again later.");
      } else {
        Get.snackbar("Error",
            "Failed to fetch data with status code ${response.statusCode}");
      }

      // Fetching half-hourly intensity data for the current day
      final timeSeriesResponse = await http.get(
        Uri.parse('https://api.carbonintensity.org.uk/intensity/date'),
      );

      if (timeSeriesResponse.statusCode == 200) {
        final timeSeriesData = json.decode(timeSeriesResponse.body)['data'];

        // Clear previous data and populate chart data
        carbonValues.clear();
        for (var i = 0; i < timeSeriesData.length; i++) {
          double intensity =
              timeSeriesData[i]['intensity']['actual']?.toDouble() ?? 0.0;
          carbonValues.add(FlSpot(i.toDouble(), intensity));
        }
      } else if (timeSeriesResponse.statusCode == 400) {
        Get.snackbar(
            "Error", "Bad Request: Invalid parameters for time series data.");
      } else if (timeSeriesResponse.statusCode == 500) {
        Get.snackbar("Error",
            "Internal Server Error: Unable to fetch time series data.");
      } else {
        Get.snackbar("Error",
            "Failed to fetch time series data with status code ${timeSeriesResponse.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Determine intensity level based on value
  String _getIntensityLevel(int actualValue) {
    if (actualValue > 200) {
      return 'HIGH';
    } else if (actualValue > 100) {
      return 'MEDIUM';
    } else {
      return 'LOW';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCarbonIntensityData(); // Fetch data when the controller is initialized
  }
}
