import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingstar/Utils/colors.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  bool statusseen = false;
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
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
        title: Text(
          'Updates',
          style: GoogleFonts.actor(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              statusseen = true;
                            });
                          },
                          child: Container(
                            height: 250,
                            width: 180,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),

                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration:  BoxDecoration(
                                color:statusseen?Colors.grey: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://g1uudlawy6t63z36.public.blob.vercel-storage.com/e64edd025438449584ac6c481eafa22d.png'),
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                        ),
                        const Positioned(
                            left: 40,
                            top: 40,
                            child: CircleAvatar(
                              backgroundColor: WhatsAppColors.primaryGreen,
                              radius: 10,
                              child: Icon(Icons.add,color: Colors.black,size:15,),
                            )),
                        Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              'My Status',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
