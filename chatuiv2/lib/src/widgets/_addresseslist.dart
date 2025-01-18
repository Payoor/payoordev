import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import 'package:chatuiv2/src/classes/_appcolors.dart';

import 'package:chatuiv2/src/providers/_googleplaces.dart';

class AddressesList extends StatefulWidget {
  final Function(Map<String, String> addressData) onAddressSelected;
  final Function(String updatedAddress) onLocationSelected;

  const AddressesList({
    Key? key,
    required this.onLocationSelected,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  State<AddressesList> createState() => _AddressesListState();
}

class _AddressesListState extends State<AddressesList> {
  bool isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      final geolocation = html.window.navigator.geolocation;

      await geolocation.getCurrentPosition().then((position) async {
        final num? lat = position.coords?.latitude;
        final num? lng = position.coords?.longitude;

        if (lat != null && lng != null) {
          final address = '$lat, $lng';

          await context
              .read<GooglePlaces>()
              .getAddressFromCoordinates(address, lat, lng);

          final updatedAddress = context.read<GooglePlaces>().address;

          widget.onLocationSelected(updatedAddress);
        }
      }).catchError((error) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error getting location. Please ensure location permissions are enabled.'),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing location services')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GooglePlaces>(
      builder: (context, googlePlaces, child) {
        return Stack(
          children: [
            Container(
              height: 600, // Fixed height for the container
              color: AppColors.primaryColorDark,
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        _getCurrentLocation();
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.navigation,
                                color: AppColors.primaryColor,
                                size: 15,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Use your current location',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ))),
                  Expanded(
                    // Ensures ListView takes only available space
                    child: ListView.builder(
                      itemCount: googlePlaces.predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = googlePlaces.predictions[index];
                        return GestureDetector(
                          onTap: () {
                            widget.onAddressSelected({
                              'address': prediction['formatted_address'],
                              'icon': prediction['icon'],
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.primaryColor,
                                  size: 15,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    prediction['formatted_address'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (googlePlaces.isLoading || isLoading)
              Positioned(
                top: 0, // Half of container height (600/2)
                left: 0,
                right: 0,
                child: Center(
                  // Additional Center widget
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
