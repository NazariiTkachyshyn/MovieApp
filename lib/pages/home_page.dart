// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A2574),
      appBar: AppBar(
        title: const Text('Movie Search App'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4A2574),
      ),
      body: FutureBuilder<List<Movie>>(
        future: apiService.fetchTop5Movies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  child: ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.overview),
                    leading: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                    onTap: () {
                      // Навігація на детальну сторінку
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: const Color(0xFF7338A0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: GNav(
              backgroundColor: Color(0xFF7338A0),
              color: Color.fromARGB(255, 214, 166, 254),
              activeColor: Color.fromARGB(255, 250, 220, 255),
              //tabBackgroundColor: Color.fromARGB(97, 196, 40, 227),
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.bookmark,
                  text: 'Bookmark',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
