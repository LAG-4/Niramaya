import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:niramaya/login.dart';
import 'package:niramaya/tracker.dart';
import 'package:niramaya/youtube.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat.dart';
import 'diary_entry.dart';
import 'detect_emo_web.dart';
import 'home.dart';
import 'helpline.dart';
import 'profile.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  signOutUser() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f4f3),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOutUser();
        },
        child: Icon(Icons.logout_sharp),
      ),
      body: Container(
        color: Color(0xFFFFF8DB), // Set background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1 / 1,
            ),
            itemCount: 8, // Total number of buttons
            itemBuilder: (context, index) {
              // Titles and destinations for each button
              final titles = [
                'Chat with Dawn',
                'Diary Analysis',
                'Guess My Mood',
                'Survey Based Diagnosis',
                'Helpline Numbers',
                'Profile Page',
                'Tracker',
                'Exercises',
              ];
              final destinations = [
                ChatPage(),
                DiaryEntryScreen(),
                DetectEmotion(),
                HomeScreen(),
                Helpline(),
                ProfilePage(testName: 'Bipolar Test'),
                TrackerPage(),
                YouTubeScreen(),
              ];

              return _buildGridButton(
                context,
                titles[index],
                destinations[index],
                index, // Pass the index
              );
            },
          ),

        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, Widget? destination, int index) {
    // Define the alternating colors
    final colors = [Color(0xFF9BB168), Color(0xFFEE7E1C), Color(0xFFA18FFF)];
    final backgroundColor = colors[index % colors.length]; // Alternate colors based on index

    // List of images corresponding to each button
    final images = [
      'assets/Chatbot.png',
      'assets/Diary.png',
      'assets/Mood.png',
      'assets/Survey.png',
      'assets/Helpline.png',
      'assets/Profileimg.png',
      'assets/Tracker.png',
      'assets/Exercise.png',

    ];

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Set the alternating background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(16.0), // Adjust padding
      ),
      onPressed: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          // Show a message if the screen is not available
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Screen not available')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            images[index], // Use the corresponding image
            height: 150, // Set the height of the image
            width: 150, // Set the width of the image
          ),
          const SizedBox(height: 10), // Add spacing between image and text
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16, // Adjust text size
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }


}
