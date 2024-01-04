import 'package:flutter/material.dart';
import 'package:song_lyrics_final/constants/constants.dart';
import 'package:song_lyrics_final/models/song.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(.8),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
          Expanded(
              child: ListView(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 30),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title of song',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
              ),
              TextField(
                controller: _contentController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Compose a song',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ],
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createSongs();
          Navigator.of(context).pop();
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _createSongs() async {
    final title = _titleController.text;
    final content = _contentController.text;
    final song = Song(
      title: title,
      content: content,
    );

    const url = '${baseURL}songs';

    try {
      const url = '${baseURL}songs';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(song.toJson()),
      );

      if (response.statusCode == 201) {
        final body = response.body;
        final json = jsonDecode(body);

        // final newRecipe = Song(
        //   id: json['id'],
        //   title: json['title'],
        //   content: json['content'],
        // );

        // setState(() {
        //   songs.add(newRecipe);
        // });

        print('Success recipe saved');
      } else {
        print('Failed to save recipe');
      }
    } catch (error) {
      print('Error saving recipe');
    }
  }
}
