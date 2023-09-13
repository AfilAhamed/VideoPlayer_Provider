import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videoplayer_miniproject/screens/settings/about.dart';
import 'package:videoplayer_miniproject/screens/settings/reset.dart';
import 'package:videoplayer_miniproject/screens/settings/terms_condition.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  //Exit from app function
  void closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Settings'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const About(),
                      ));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.orange.shade700, size: 33),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'About',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsConditon()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sticky_note_2_outlined,
                          color: Colors.orange.shade700, size: 33),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text(
                        'Terms & Condition',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  resetDB(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restart_alt_outlined,
                          color: Colors.orange.shade700, size: 33),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Reset Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  closeApp();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout,
                          color: Colors.orange.shade700, size: 33),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Exit',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
