import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationService {
  static const String baseUrl = 'http://localhost:5000'; // Changed from 10.0.2.2 to localhost

  Future<List<Location>> getLocations({String? type}) async {
    final uri = type != null
        ? Uri.parse('$baseUrl/locations?type=$type')
        : Uri.parse('$baseUrl/locations');
    
    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw const SocketException('Connection timed out');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Server returned ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: Please check your internet connection and ensure the backend server is running. Error: $e',
      );
    } on HttpException catch (e) {
      throw Exception('HTTP error: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<Location>> searchLocations(String query) async {
    final uri = Uri.parse('$baseUrl/locations/search?q=$query');
    
    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw const SocketException('Connection timed out');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Server returned ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: Please check your internet connection and ensure the backend server is running. Error: $e',
      );
    } on HttpException catch (e) {
      throw Exception('HTTP error: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Location> getLocation(int id) async {
    final uri = Uri.parse('$baseUrl/locations/$id');
    
    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw const SocketException('Connection timed out');
        },
      );

      if (response.statusCode == 200) {
        return Location.fromJson(json.decode(response.body));
      } else {
        throw HttpException(
          'Server returned ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: Please check your internet connection and ensure the backend server is running. Error: $e',
      );
    } on HttpException catch (e) {
      throw Exception('HTTP error: $e');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
