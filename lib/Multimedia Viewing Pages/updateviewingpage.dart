import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

class UpdateViewing extends StatefulWidget {
  final String imageUrl;  // The image URL passed from the previous page
  final String Name;

  const UpdateViewing({super.key, required this.imageUrl,required this.Name});

  @override
  State<UpdateViewing> createState() => _UpdateViewingState();
}

class _UpdateViewingState extends State<UpdateViewing> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  double _progress = 0.0;

  // List of story images (we initialize this in initState)
  late List<String> _stories;

  @override
  void initState() {
    super.initState();
    _stories = [widget.imageUrl]; // Initialize the list with the passed image URL
    _startTimer();
  }

  // Start the timer for progressing the story
  void _startTimer() {
    _progress = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_progress >= 1.0) {
        _nextStory();
      } else {
        setState(() {
          _progress += 0.01;
        });
      }
    });
  }

  // Move to the next story
  void _nextStory() {
    if (_currentPage < _stories.length - 1) {
      // There's another story, so navigate to the next
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // No more stories left, end and pop the view
      _timer.cancel();  // Cancel the timer to stop further updates
      Navigator.pop(context); // Go back to the previous page
    }
  }

  // Move to the previous story
  void _previousStory() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _progress = 0.0; // Reset the progress for the next story
                });
                _startTimer(); // Restart the timer for the next story
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Displaying story image from network
                    Image.network(
                      _stories[index],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Row(
                        children: [
                          // Profile image
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('https://g1uudlawy6t63z36.public.blob.vercel-storage.com/e64edd025438449584ac6c481eafa22d.png'), // Display the passed network image
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.Name, // You can replace this with dynamic data
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      right: 20,
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildStoryIndicators(),
        ],
      ),
    );
  }

  // Build indicators for the stories (like dots below each story)
  Widget _buildStoryIndicators() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _stories.length,
              (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CircleAvatar(
              radius: 5,
              backgroundColor: _currentPage == index
                  ? Colors.green
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
