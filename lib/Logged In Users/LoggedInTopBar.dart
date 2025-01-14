import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Logged%20In%20Users/callpage.dart';
import 'package:pingstar/Logged%20In%20Users/updatespage.dart';
import 'package:pingstar/Utils/colors.dart';

class Loggedinusertopbar extends StatefulWidget {
  const Loggedinusertopbar({super.key});

  @override
  State<Loggedinusertopbar> createState() => _LoggedinusertopbarState();
}

class _LoggedinusertopbarState extends State<Loggedinusertopbar> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    Center(
      child: Text(
        'Chats Page',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    const UpdatesPage(),
    const CallPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhatsAppColors.darkGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: WhatsAppColors.darkGreen,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
        title: Text(
          'Connect',
          style: GoogleFonts.actor(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: WhatsAppColors.primaryGreen,
        child: const Icon(Icons.add_comment, color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Center(
                  child: Text(
                    'Ask AI or Search',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPageIndex = 0;
                    });
                  },
                  child: Text(
                    'Chats',
                    style: GoogleFonts.poppins(
                      color: currentPageIndex == 0
                          ? Colors.green
                          : Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPageIndex = 1;
                    });
                  },
                  child: Text(
                    'Updates',
                    style: GoogleFonts.poppins(
                      color: currentPageIndex == 1
                          ? Colors.green
                          : Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPageIndex = 2;
                    });
                  },
                  child: Text(
                    'Calls',
                    style: GoogleFonts.poppins(
                      color: currentPageIndex == 2
                          ? Colors.green
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: pages[currentPageIndex],
          ),
        ],
      ),
    );
  }
}
