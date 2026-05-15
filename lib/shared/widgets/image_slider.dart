import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyImageCarousel extends StatefulWidget {
  const MyImageCarousel({super.key});

  @override
  State<MyImageCarousel> createState() => _MyImageCarouselState();
}

class _MyImageCarouselState extends State<MyImageCarousel> {
  final List<String> imgList = [
    'assets/images/ban-1.png',
    'assets/images/ban-2.png',
  ];

  int _current = 0;

  final GlobalKey<CarouselSliderState> _carouselKey =
      GlobalKey<CarouselSliderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider.builder(
              key: _carouselKey,
              itemCount: imgList.length,
              itemBuilder: (context, index, realIndex) {
                final item = imgList[index];
                return Image.asset(
                  item,
                  fit: BoxFit.contain,
                  width: double.infinity,
                );
              },
              options: CarouselOptions(
                height: 70,

                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),

            // DOT INDICATORS overlay
            Positioned(
              bottom: 2, // 8 pixels from bottom
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imgList.length,
                  (index) => Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Colors
                                .orange // Active dot color
                          : Colors.grey.shade400, // Inactive dot color
                      boxShadow: [BoxShadow(color: Colors.black)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
