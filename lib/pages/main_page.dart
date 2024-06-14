import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:movie_app/widget/animated_card_widget.dart';
import 'package:movie_app/widget/bottom_rounded_corners.dart';
import 'movie_detail_page.dart';

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

  // Fetch top 5 movies
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

  // Fetch latest movies for grid display
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
      backgroundColor: const Color(0xFF360568),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 90.0, // Height for AppBar space
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF5d1ca4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 35, 18, 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 70, 19, 124), // Darker color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(156, 255, 255, 255)),
                          border: InputBorder.none,
                          icon: Icon(Icons.search,
                              color: Color.fromARGB(234, 255, 255, 255)),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // ! Label above Carousel
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
                // ! Carousel
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.35,
                    child: movies == null
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Loading indicator
                        : movies!.isEmpty
                            ? const Center(
                                child: Text(
                                    'Error: Unable to load movies')) // Error message
                            : CarouselSlider.builder(
                                itemCount: movies!.length,
                                itemBuilder: (context, index, realIndex) {
                                  final movie = movies![index];
                                  return Hero(
                                    tag: movie.title,
                                    child: AnimatedCardWidget(
                                      image: Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailPage(movie: movie),
                                          ),
                                        );
                                      },
                                    ),
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
                //! Label above grid
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Newest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                // ! Table Grid
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: gridMovies.isEmpty
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Loading indicator
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                                child: Hero(
                                  tag: movie.title,
                                  child: AnimatedCardWidget(
                                    image: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailPage(movie: movie),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          ClipPath(
            clipper: BottomRoundedAppBarClipper(),
            child: Container(
              height: 120.0,
              color: const Color(0xFF5d1ca4),
              child: AppBar(
                toolbarHeight: 80,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(12),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                    const Spacer(),
                    const Text('Movie Search App'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Icon(
                        color: Colors.deepPurple.shade300,
                        Icons.notifications_none_outlined,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                foregroundColor: const Color(0xFFF9FBF2),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: const Color(0xFF5d1ca4),
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
