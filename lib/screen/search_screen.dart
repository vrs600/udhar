import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:udhar/other/styling.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Styling styling = Styling();

  TextEditingController searchPeopleTEC = TextEditingController();

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
                      controller: searchPeopleTEC,
                      onChanged: (searchQuery) {
                        setState(() {});
                      },
                      minLines: 1,
                      decoration:
                          styling.getTFFInputDecoration(label: "Search People"),
                    ),
                  ),
                ),
              ),
            ),
            (searchPeopleTEC.text.isEmpty)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                          "lib/asset/image/undraw_people_search.svg"),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListView();
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
