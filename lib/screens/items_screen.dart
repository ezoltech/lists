import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> items = [];
  bool isLoading = false; // Define isLoading state variable

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching starts
    });

    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];

        setState(() {
          items = products
              .map((product) => product['title']?.toString() ?? 'Unknown')
              .toList();
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false when fetching completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Items'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show CircularProgressIndicator while loading
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              ),
      ),
    );
  }
}
