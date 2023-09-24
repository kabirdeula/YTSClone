import 'package:flutter/material.dart';
import 'package:yts/models/model.movie.dart';

class DetailScreen extends StatelessWidget {
  final Movie selectedMovie;
  final List<Movie> relatedMovies;

  const DetailScreen({
    required this.selectedMovie,
    required this.relatedMovies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMovie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedMovie.title,
                  ),
                  Text(
                    'Description: ${selectedMovie.summary ?? "Sorry, no description available."}',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Related Movies',
              ),
            ),
            SizedBox(
              height: 700,
              child: ListView.builder(
                itemCount: relatedMovies.length,
                itemBuilder: (context, index) {
                  final movie = relatedMovies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(
                      'ID: ${movie.id}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            selectedMovie: movie,
                            relatedMovies: relatedMovies,
                          ),
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
