import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          'About',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: const SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Text(
            '''Welcome to our simple video player app named  "Infinity Video Player", we are dedicated to bringing you a straightforward and enjoyable video playback experience. Our mission is to create a user-friendly platform that allows you to watch your favorite videos with ease.
      
      With a clean and intuitive interface, our video player app ensures that you can quickly navigate through your video library and start watching your desired content in no time. We believe in simplicity without compromising on functionality, making it perfect for users of all ages and tech-savviness levels.
      
      Seamless video playback is our priority. Our app leverages the latest technologies to deliver smooth streaming, ensuring you can enjoy your videos without any interruptions or buffering issues. Whether you're streaming online content or playing videos from your device, we've got you covered.
      
      We understand that everyone has their preferences when it comes to video settings. That's why our video player app comes with adjustable playback controls, allowing you to customize the viewing experience to suit your comfort, such as adjusting playback speed and screen orientation.
      
      Your convenience matters to us, and we have included features to make your video-watching experience more enjoyable. You can create playlists to organize your videos, and with the auto-play feature, you can seamlessly binge-watch your favorite series or videos without any hassle.
      
      Rest assured that your privacy and security are of utmost importance to us. Our app adheres to strict data protection standards to safeguard your personal information, ensuring a safe and secure environment for all users.
      
      We are thrilled to have you on board as we continue to enhance and refine our simple video player app. Your feedback is invaluable in shaping the future of our app, and we look forward to providing you with an even better video-watching experience. Thank you for choosing the X-Video PLayer as your go-to video player!
                
      
Sincerely,
      
   Developer Afil Ahamed''',
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
