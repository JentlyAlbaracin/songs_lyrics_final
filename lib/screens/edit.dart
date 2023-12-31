import 'package:flutter/material.dart';
import 'package:song_lyrics_final/constants/constants.dart';
import 'package:song_lyrics_final/models/song.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song_lyrics_final/screens/home.dart';

class EditScreen extends StatefulWidget {
  final Song? song;
  const EditScreen({super.key, this.song});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.song != null) {
      _titleController = TextEditingController(text: widget.song!.title);
      _contentController = TextEditingController(text: widget.song!.content);
    }

    super.initState();
  }

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
          Song updatedSong = Song(
            id: widget.song!.id,
            title: _titleController.text,
            content: _contentController.text,
          );
          _editSongs(updatedSong);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      updatedSong: updatedSong,
                    )),
          );
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _editSongs(Song song) async {
    print(song.id);
    try {
      final url = '${baseURL}songs/${song.id}';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(song.toJson()),
      );

      if (response.statusCode == 201) {
        final body = response.body;
        final json = jsonDecode(body);

        print('Success recipe updated');
      } else {
        print('Failed to update recipe');
      }
    } catch (error) {
      print('Error updating recipe');
    }
  }
}
