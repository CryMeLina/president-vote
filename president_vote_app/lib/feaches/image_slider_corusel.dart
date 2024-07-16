import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:president_vote_app/classes/Candidate.dart';
import 'package:president_vote_app/main.dart';

late List<String> imageList = [];
List<Candidate> candidates = [];

class ImageCorusel extends StatelessWidget {
  final Candidate arguments;

  ImageCorusel({required this.arguments});
  // Candidate currentCandidat;
  // ImageCorusel({Key? key}, required:Candidate current) : super(key: key)
  // {
  //   this.currentCandidat = current;
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    imageList = arguments.pictUrl;
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
      items: imageList
          .map((e) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      e,
                      height: 270,
                      width: 900,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
