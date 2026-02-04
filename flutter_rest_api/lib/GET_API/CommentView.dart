import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rest_api/models/CommentModel.dart';

class Commentview extends StatefulWidget {
  const Commentview({super.key});

  @override
  State<Commentview> createState() => _CommentviewState();
}

class _CommentviewState extends State<Commentview> {
  TextEditingController idController = TextEditingController();
  Future<List<Commentmodel>>? commentsFuture;

  Future<List<Commentmodel>> getComments(String id) async {
    final response = await http.get(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/comments?postId=$id',
      ),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((json) => Commentmodel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load comments");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Post ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (idController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter an ID"),
                    ),
                  );
                  return;
                }

                setState(() {
                  commentsFuture = getComments(idController.text);
                });
              },
              child: const Text("Fetch Comment"),
            ),
            const SizedBox(height: 20),

            /// RESULT AREA
            Expanded(
              child: commentsFuture == null
                  ? const Center(
                child: Text("Enter ID and fetch comments"),
              )
                  : FutureBuilder<List<Commentmodel>>(
                future: commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No comments found for this ID",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final comments = snapshot.data!;

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index].id.toString()),
                        subtitle: Text(comments[index].userId.toString()),
                        trailing: Text(
                          comments[index].body.toString(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
