import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/widget/animated_card_widget.dart';

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
  late PageController _pageController;
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageController = PageController(viewportFraction: 0.6);
    _fetchMovies();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search App'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4A2574),
      ),
      backgroundColor: const Color(0xFF4A2574),
      body: movies == null
          ? const Center(child: CircularProgressIndicator())
          : movies!.isEmpty
              ? Center(child: Text('Error: Unable to load movies'))
              : Center(
                  heightFactor: 1,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollUpdateNotification) {
                        setState(() {
                          _pageOffset = _pageController.page!;
                        });
                      }
                      return true;
                    },
                    child: CarouselSlider.builder(
                      itemCount: movies!.length,
                      itemBuilder: (context, index, realIndex) {
                        final movie = movies![index];
                        double relativeIndex = index - _pageOffset;
                        double angle = relativeIndex * 0.15;

                        if (angle > 0.3) {
                          angle = 0.3;
                        } else if (angle < -0.3) {
                          angle = -0.3;
                        }

                        return Transform.rotate(
                          angle: angle,
                          child: AnimatedCardWidget(
                            image: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.6,
                        enlargeCenterPage: true,
                        height: 300,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index % movies!.length;
                            _controller.forward(
                                from: 0); // Запуск анімації при зміні сторінки
                          });
                        },
                      ),
                    ),
                  ),
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
