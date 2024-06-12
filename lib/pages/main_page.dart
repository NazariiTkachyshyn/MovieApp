import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/widget/animated_card_widget.dart';
import 'package:movie_app/widget/bottom_rounded_corners.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  List<Movie>? movies;
  int _currentIndex = 0;
  late AnimationController _controller;
  double _pageOffset = 0;
  List<Movie> gridMovies = []; // List for grid movies

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fetchMovies();
    _fetchGridMovies(); // Fetch movies for grid
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchMovies() async {
    try {
      final fetchedMovies = await apiService.fetchTop5Movies();
      setState(() {
        movies = fetchedMovies;
      });
    } catch (error) {
      setState(() {
        movies = [];
      });
    }
  }

  Future<void> _fetchGridMovies() async {
    try {
      final fetchedMovies = await apiService.fetchLatestMovies();
      setState(() {
        gridMovies = fetchedMovies;
      });
    } catch (error) {
      setState(() {
        gridMovies = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: ClipPath(
          clipper: BottomRoundedAppBarClipper(),
          child: AppBar(
            title: const Text('Movie Search App'),
            foregroundColor: const Color(0xFFF9FBF2),
            backgroundColor: const Color.fromARGB(154, 121, 40, 203),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF360568),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 18, 0, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top of all time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.scale(
                scale: 1.35,
                child: movies == null
                    ? const Center(child: CircularProgressIndicator())
                    : movies!.isEmpty
                        ? const Center(
                            child: Text('Error: Unable to load movies'))
                        : CarouselSlider.builder(
                            itemCount: movies!.length,
                            itemBuilder: (context, index, realIndex) {
                              final movie = movies![index];
                              return AnimatedCardWidget(
                                image: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                ),
                                onTap: () {},
                              );
                            },
                            options: CarouselOptions(
                              padEnds: true,
                              enlargeCenterPage: true,
                              height: 300,
                              autoPlay: true,
                              viewportFraction: 0.5,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                  _controller.forward(from: 0);
                                });
                              },
                            ),
                          ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: gridMovies.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: gridMovies.length,
                      itemBuilder: (context, index) {
                        final movie = gridMovies[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: GridTile(
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: const Color.fromARGB(154, 121, 40, 203),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            child: GNav(
              color: Color.fromARGB(152, 173, 96, 255),
              activeColor: Color(0xFFF9FBF2),
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
