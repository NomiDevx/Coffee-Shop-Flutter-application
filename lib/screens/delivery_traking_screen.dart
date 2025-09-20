// screens/delivery_tracking_screen.dart
import 'dart:async';
import 'package:cafeshop/screens/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/provider/delivery_provider.dart';
import 'package:cafeshop/theme/theme.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  final String orderId;
  final String deliveryPersonName;
  final String estimatedTime;

  const DeliveryTrackingScreen({
    super.key,
    required this.orderId,
    required this.deliveryPersonName,
    required this.estimatedTime,
  });

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  GoogleMapController? _mapController;
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.5,
  );

  final List<LatLng> _route = const [
    LatLng(37.42796133580664, -122.085749655962), // Start
    LatLng(37.426, -122.086), // Point 1
    LatLng(37.424, -122.0855), // Point 2
    LatLng(37.4225, -122.0845), // Point 3
    LatLng(37.421, -122.084), // Point 4
    LatLng(37.4220, -122.0841), // Destination
  ];

  int _currentIndex = 0;
  Timer? _movementTimer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDeliveryMovement();
    });
  }

  void _startDeliveryMovement() {
    final provider = Provider.of<DeliveryProvider>(context, listen: false);

    // Initialize courier at starting point
    provider.updateDeliveryPersonLocation(_route.first);

    _movementTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_currentIndex < _route.length - 1) {
        _currentIndex++;

        final newPos = _route[_currentIndex];
        provider.updateDeliveryPersonLocation(newPos);

        // Calculate progress
        _progress = _currentIndex / (_route.length - 1);

        // Smooth camera animation following courier
        if (_mapController != null) {
          await _mapController!.animateCamera(CameraUpdate.newLatLng(newPos));
        }

        // Update polylines to show progress
        provider.createRoutePolyline();

        setState(() {}); // Update UI with new progress
      } else {
        timer.cancel();
        // Delivery completed
        // _showDeliveryCompletedDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DeliveryProvider>(
        builder: (context, deliveryProvider, child) {
          return Stack(
            children: [
              /// Google Map
              GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _controller.complete(controller);
                },
                markers: deliveryProvider.markers,
                polylines: deliveryProvider.polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),

              /// Back Button on Top
              Positioned(
                top: 50,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavBarScreen(),
                      ),
                    ),
                  ),
                ),
              ),

              /// Bottom Card with Progress Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Progress Bar
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Progress',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${(_progress * 100).toStringAsFixed(0)}% Complete',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            color: AppColors.primary,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      /// Estimated Time and Address
                      Text(
                        "${widget.estimatedTime} left",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Delivery to Jl. Kpg Sutoyo",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),

                      /// Status with delivery icon
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delivery_dining,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getDeliveryStatus(_progress),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  _getDeliveryMessage(_progress),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Courier Info
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.deliveryPersonName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  "Personal Courier",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                // Call courier functionality
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getDeliveryStatus(double progress) {
    if (progress < 0.3) return "Order Preparing";
    if (progress < 0.6) return "On the Way";
    if (progress < 0.9) return "Almost There";
    return "Arriving Soon";
  }

  String _getDeliveryMessage(double progress) {
    if (progress < 0.3) return "Your order is being prepared for delivery";
    if (progress < 0.6) return "Your delivery is on the way to you";
    if (progress < 0.9) return "Your delivery is nearby";
    return "Your delivery will arrive shortly";
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
