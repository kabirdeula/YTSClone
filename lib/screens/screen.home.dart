import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yts/screens/screen.detail.dart';
import '../models/model.movie.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Movie> _movies = [];
  int _currentPage = 1;
  final int _moviesPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://www.yts.nz/api/v2/list_movies.json?page=$_currentPage&limit=$_moviesPerPage'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> moviesData = jsonData['data']['movies'];
      final List<Movie> movies =
          moviesData.map((movie) => Movie.fromJson(movie)).toList();
      setState(() {
        _movies.addAll(movies);
        _currentPage++;
      });
    } else {
      throw Exception('Failed to load data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YTS',
        ),
      ),
      body: ListView.builder(
        itemCount: _movies.length + 1,
        itemBuilder: (context, index) {
          if (index == _movies.length) {
            return ElevatedButton(
              onPressed: fetchData,
              child: const Text('Load More'),
            );
          } else {
            final movie = _movies[index];
            return ListTile(
              title: Text(movie.title),
              subtitle: Text('ID: ${movie.id}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      selectedMovie: movie,
                      relatedMovies: _movies,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
