import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cooptourism/data/models/listing.dart';
import 'package:cooptourism/widgets/display_image.dart';
import 'package:flutter/material.dart';

class ListingImageSlider extends StatefulWidget {
  final ListingModel listing;
  const ListingImageSlider({super.key, required this.listing});

  @override
  State<ListingImageSlider> createState() => _ListingImageSliderState();
}

class _ListingImageSliderState extends State<ListingImageSlider> {
  int currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // final decorator = DotsDecorator(
    //   activeColor: Colors.orange[700],
    //   size: const Size.square(7.5),
    //   activeSize: const Size.square(10.0),
    //   activeShape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(20.0),
    //   ),
    //   spacing: const EdgeInsets.all(2.5),
    // );
    int maxImageIndex = widget.listing.images!.length;
    CarouselController carouselController = CarouselController();

    return Stack(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.9,
                  child: GridView.count(
                    crossAxisCount: 1,
                    children: widget.listing.images!
                        .map<Widget>((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DisplayImage(
                                path:
                                    "${widget.listing.cooperativeOwned}/listingImages/$e",
                                height: 250,
                                width: double.infinity,
                                radius: BorderRadius.zero,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            );
          },
          child: SizedBox(
            height: 250,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: 250.0,
                enlargeFactor: 0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
              ),
              items: widget.listing.images!
                  .map<Widget>((e) => DisplayImage(
                        path:
                            "${widget.listing.cooperativeOwned}/listingImages/$e",
                        height: 250,
                        width: double.infinity,
                        radius: BorderRadius.zero,
                      ))
                  .toList(),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text(
                '${currentImageIndex + 1} / $maxImageIndex',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
