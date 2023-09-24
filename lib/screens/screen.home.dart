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
  List<Movie> _filteredMovies = [];
  int _currentPage = 1;
  final int _moviesPerPage = 10;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _runFilter(String enteredKeyword) {
    List<Movie> results = [];
    if (enteredKeyword.isEmpty) {
      results = [..._movies];
    } else {
      results = _movies
          .where((movie) =>
              movie.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredMovies = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YTS',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _runFilter(_searchController.text);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
                prefixIconConstraints: BoxConstraints(
                  maxHeight: 20,
                  minWidth: 25,
                ),
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMovies.length + 1,
              itemBuilder: (context, index) {
                if (index == _filteredMovies.length) {
                  return ElevatedButton(
                    onPressed: fetchData,
                    child: const Text('Load More'),
                  );
                } else {
                  final movie = _filteredMovies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text('ID: ${movie.id}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            selectedMovie: movie,
                            relatedMovies: _filteredMovies,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
