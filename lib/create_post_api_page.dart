
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class CreatePostApiPage extends StatefulWidget {
  const CreatePostApiPage({Key? key}) : super(key: key);

  @override
  State<CreatePostApiPage> createState() => _CreatePostApiPageState();
}

class _CreatePostApiPageState extends State<CreatePostApiPage> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _collegecontroller = TextEditingController();

  Future<Post>? _futureUser;

  List<Post> samplePosts = [];
  List<Post> samplePostsdisp = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Aboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: buildColumn(),
                ),
              ),

            
      Flexible(
        flex: 1,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Container(
                  child: Expanded(
                    flex: 1,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: samplePostsdisp.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            child: ListTile(
                              minLeadingWidth: 10,
                              minVerticalPadding: 10,
                              contentPadding: const EdgeInsets.all(10),
                              tileColor: Colors.cyan,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      style: BorderStyle.solid,
                                      width: 1.0,
                                      color: Colors.grey)),

                              title: Text(
                                samplePostsdisp[index].name!,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              subtitle: Text(
                                samplePostsdisp[index].title!,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.black),
                              ),
                              trailing: Text(samplePostsdisp[index].college!),
                            ),
                          );
                        }),
                  )

              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }

        ),
      ),
          ],
        ),
      ),
    );
  }
  FutureBuilder<Post> buildFutureBuilder() {
    return FutureBuilder<Post>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.data!.name}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _namecontroller,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        TextField(
          controller: _titlecontroller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        TextField(
          controller: _collegecontroller,
          decoration: const InputDecoration(hintText: 'Enter College'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureUser = createAlbum(
                  _namecontroller.text, _titlecontroller.text,
                  _collegecontroller.text);

              _namecontroller.clear();
              _titlecontroller.clear();
              _collegecontroller.clear();
              samplePostsdisp.length+1;
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );

  }
  Future<Post> createAlbum(String name, String title, String college) async {
    final response = await http.post(
      Uri.parse('https://crudcrud.com/api/4cc9ae5f9f3a4b7c905251ec218bc40b/trial'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'title': title,
        'college': college,
      }),
    );

    print("stastus code "+response.statusCode.toString());
    if (response.statusCode == 201) {
      samplePostsdisp.clear();
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<List<Post>> getData() async {
    final response =
    await http.get(Uri.parse('https://crudcrud.com/api/4cc9ae5f9f3a4b7c905251ec218bc40b/trial'));
    var data = jsonDecode(response.body.toString());
print("got data ");
samplePostsdisp.clear();
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        samplePostsdisp.add(Post.fromJson(index));
      }
      return samplePostsdisp;
    } else {
      return samplePostsdisp;
    }
  }
}
