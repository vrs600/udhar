import 'package:flutter/material.dart';
import 'package:udhar/other/styling.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Styling styling = Styling();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      onChanged: (searchQuery) {
                        setState(() {});
                      },
                      minLines: 1,
                      decoration:
                          styling.getTFFInputDecoration(label: "Search"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
