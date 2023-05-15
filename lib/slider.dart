import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AutoplayListView extends StatefulWidget {
  final List<Map<String, dynamic>> imageList;
  final double itemWidth;
  final double itemHeight;

  AutoplayListView({
    required this.imageList,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  _AutoplayListViewState createState() => _AutoplayListViewState();
}

class _AutoplayListViewState extends State<AutoplayListView> {
  final _controller = CarouselController();
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  @override
  void dispose() {
    _stopAutoplay();
    super.dispose();
  }

  void _startAutoplay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      final newIndex = (_currentIndex + 1) % widget.imageList.length;
      _controller.animateToPage(newIndex);
    });
  }

  void _stopAutoplay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: widget.imageList.length,
                    itemBuilder: (context, index, _) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        width: widget.itemWidth,
                        height: widget.itemHeight,
                        child: Image.asset(
                          widget.imageList[index]['image_path'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enableInfiniteScroll: true,
                      autoPlay: false,
                      viewportFraction: 0.4,
                      aspectRatio: 5,
                      initialPage: _currentIndex,
                      onPageChanged: (index, _) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.imageList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: _currentIndex == entry.key ? 17 : 7,
                            height: 7.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _currentIndex == entry.key ? Colors.red : Colors.teal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


