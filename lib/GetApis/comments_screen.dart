import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_apis/Models/comments_model.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<CommentsModel> commentsList = [];

  Future<List<CommentsModel>> getCommentsApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      commentsList.clear();
      for (Map<String, dynamic> i in data) {
        commentsList.add(CommentsModel.fromJson(i));
      }
      return commentsList;
    } else {
      return commentsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getCommentsApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: const Color.fromARGB(255, 19, 18, 18),
                      size: 200,
                    ),
                  );
                } else {
                  return ListView.builder(
                      //?snapshot contains data return from methods called in fututr builder
                      //! we can also use snapshot length because the whole data is one list
                      // itemCount: snapshot.data!.length,
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email\n${commentsList[index].email}'),
                            ],
                          ),
                        ));
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
