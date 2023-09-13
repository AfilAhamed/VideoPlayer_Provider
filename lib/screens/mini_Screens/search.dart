import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Model/video_model/video_model.dart';
import '../video/video_play.dart';

class VideoSearchScreen extends StatefulWidget {
  const VideoSearchScreen({super.key});

  @override
  VideoSearchScreenState createState() => VideoSearchScreenState();
}

class VideoSearchScreenState extends State<VideoSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoModel> _searchResults = [];

  void _performSearch(String query) {
    final videoBox = Hive.box<VideoModel>('videos');
    final List<VideoModel> allVideos = videoBox.values.toList();

    final List<VideoModel> searchResults = allVideos.where((video) {
      return video.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search Videos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _searchController,
              style: const TextStyle(fontSize: 20),
              onChanged: _performSearch,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 3)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 3)),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: Colors.orange.shade700,
                  size: 30,
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.orange,
                    )),
                hintText: 'Search here...',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final video = _searchResults[index];
                return Card(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(bottom: 2, top: 2),
                      child: SizedBox(
                          height: double.infinity,
                          width: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(
                                video.thumbnailPath!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    horizontalTitleGap: 10,
                    title: Text(video.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerWidget(video),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
