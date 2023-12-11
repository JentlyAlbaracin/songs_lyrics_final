import 'dart:math';

import 'package:flutter/material.dart';
import 'package:song_lyrics_final/constants/colors.dart';
import 'package:song_lyrics_final/models/song.dart';
import 'package:song_lyrics_final/screens/edit.dart';
import 'package:http/http.dart' as http;
import 'package:song_lyrics_final/constants/constants.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> filteredSongs = [];
  List<Song> songs = [];
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    filteredSongs = songs;
    fetchSongsFromApi();
  }

  List<Song> sortSongsByModifiedTime(List<Song> song) {
    if (sorted) {
      song.sort((a, b) => a.title.compareTo(b.title));
    } else {
      song.sort((b, a) => a.title.compareTo(b.title));
    }

    sorted = !sorted;

    return song;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredSongs = songs
          .where((songSong) =>
              songSong.content.toLowerCase().contains(searchText.toLowerCase()) ||
              songSong.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteSong(int index) {
    setState(() {
      Song songSong = filteredSongs[index];
      songs.remove(songSong);
      filteredSongs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lyrics Composition',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        filteredSongs = sortSongsByModifiedTime(filteredSongs);
                      });
                    },
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search songs...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.only(top: 30),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final title = song.title;
                final content = song.content;
                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  color: getRandomColor(),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                EditScreen(song: songs[index]),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            int originalIndex =
                                songs.indexOf(filteredSongs[index]);

                            songs[originalIndex] = Song(
                                id: songs[originalIndex].id,
                                title: result[0],
                                content: result[1],
                               );

                            filteredSongs[index] = Song(
                                id: filteredSongs[index].id,
                                title: result[0],
                                content: result[1],
                               );
                          });
                        }
                      },
                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: '$title \n',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5),
                            children: [
                              TextSpan(
                                text: content,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.5),
                              )
                            ]),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          final result = await confirmDialog(context);
                          if (result != null && result) {
                            deleteSong(index);
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              songs.add(Song(
                  id: songs.length,
                  title: result[0],
                  content: result[1]));
              filteredSongs = songs;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: const Text(
              'Are you sure you want to delete this song?',
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }


  void fetchSongsFromApi() async {
    try {
      const url = '${baseURL}songs';
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          // 'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        final results = json['data'] as List<dynamic>;
        final transformed = results.map((e) {
          return Song(
            id: e['id'],
            title: e['title'],
            content: e['content'],
          );
        }).toList();

        setState(() {
          songs = transformed;
        });

        print('Success: Songs fetched from API');
      } else {
        print('Failed to fetch songs: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching songs: $error');
    }
  }
}
