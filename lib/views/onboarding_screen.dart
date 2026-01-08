import 'package:flutter/material.dart';
import 'package:myapp/views/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "icon": "lightbulb_outline",
      "title": "Welcome to BibleScroll",
      "text": "Discover a new way to engage with the Bible through immersive visuals and a vibrant community.",
    },
    {
      "icon": "video_library_outlined",
      "title": "Watch Inspiring Videos",
      "text": "Explore a library of curated short-form videos that bring the scriptures to life.",
    },
    {
      "icon": "book_outlined",
      "title": "Create Reading Plans",
      "text": "Personalize your journey through the Bible with custom reading plans tailored to your needs.",
    },
    {
      "icon": "people_outline",
      "title": "Connect with Community",
      "text": "Join a community of believers to share insights, find encouragement, and grow together.",
    }
  ];

  final Map<String, IconData> _icons = {
    'lightbulb_outline': Icons.lightbulb_outline,
    'video_library_outlined': Icons.video_library_outlined,
    'book_outlined': Icons.book_outlined,
    'people_outline': Icons.people_outline,
  };


  void _navigateToAuth() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
             PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return _buildPage(
                  icon: _icons[onboardingData[index]['icon']!]!,
                  title: onboardingData[index]['title']!,
                  text: onboardingData[index]['text']!,
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: _navigateToAuth,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) => _buildDot(index: index)),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: _currentPage == onboardingData.length - 1
                        ? ElevatedButton(
                            onPressed: _navigateToAuth,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ElevatedButton(
                           onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                             style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                               backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Next',
                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                        )
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildPage({required IconData icon, required String title, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120), // Space for the buttons and indicator
        ],
      ),
    );
  }


  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentPage == index ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
