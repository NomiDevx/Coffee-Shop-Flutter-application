// provider/delivery_provider.dart
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cafeshop/theme/theme.dart';

class DeliveryProvider with ChangeNotifier {
  LatLng _deliveryPersonLocation = const LatLng(
    37.42796133580664,
    -122.085749655962,
  );
  LatLng _userLocation = const LatLng(37.4219999, -122.0840575);
  LatLng _destination = const LatLng(37.4220, -122.0841);
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  // Custom marker icons
  BitmapDescriptor? _bikeMarker;
  BitmapDescriptor? _userMarker;
  BitmapDescriptor? _destinationMarker;

  LatLng get deliveryPersonLocation => _deliveryPersonLocation;
  LatLng get userLocation => _userLocation;
  LatLng get destination => _destination;
  Set<Polyline> get polylines => _polylines;
  Set<Marker> get markers => _markers;

  DeliveryProvider() {
    _createCustomMarkers().then((_) {
      _updateMarkers();
      createRoutePolyline();
    });
  }

  // Create custom markers programmatically
  Future<void> _createCustomMarkers() async {
    // Bike marker for delivery person (blue)
    _bikeMarker = await _createMarkerFromIcon(
      Icons.directions_bike,
      AppColors.primary,
      size: 80,
    );

    // User marker (green)
    _userMarker = await _createMarkerFromIcon(
      Icons.person_pin_circle,
      Colors.green,
      size: 70,
    );

    // Destination marker (red)
    _destinationMarker = await _createMarkerFromIcon(
      Icons.location_on,
      Colors.red,
      size: 70,
    );
  }

  // Helper method to create custom marker from icon
  Future<BitmapDescriptor> _createMarkerFromIcon(
    IconData icon,
    Color color, {
    required int size,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw background circle with shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      Offset(size / 2 + 2, size / 2 + 2),
      size / 2,
      shadowPaint,
    );

    // Draw main circle
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 1.5, borderPaint);

    // Draw icon
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.5,
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void updateDeliveryPersonLocation(LatLng newLocation) {
    _deliveryPersonLocation = newLocation;
    _updateMarkers();
    notifyListeners();
  }

  void updateUserLocation(LatLng newLocation) {
    _userLocation = newLocation;
    _updateMarkers();
    notifyListeners();
  }

  void createRoutePolyline() {
    // Create a route from delivery person to destination
    final List<LatLng> routeCoordinates = [
      _deliveryPersonLocation,
      LatLng(
        (_deliveryPersonLocation.latitude + _destination.latitude) / 2,
        (_deliveryPersonLocation.longitude + _destination.longitude) / 2,
      ),
      _destination,
    ];

    _polylines = {
      Polyline(
        polylineId: const PolylineId('delivery_route'),
        points: routeCoordinates,
        color: AppColors.primary,
        width: 5,
        patterns: [PatternItem.dash(15), PatternItem.gap(3)],
      ),
      Polyline(
        polylineId: const PolylineId('remaining_route'),
        points: [_deliveryPersonLocation, _destination],
        color: AppColors.primary.withOpacity(0.3),
        width: 3,
        patterns: [PatternItem.dash(5), PatternItem.gap(3)],
      ),
    };
  }

  void _updateMarkers() {
    // Use custom markers if available, otherwise fallback to default markers
    final deliveryIcon =
        _bikeMarker ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    final userIcon =
        _userMarker ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    final destinationIcon =
        _destinationMarker ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

    _markers = {
      Marker(
        markerId: const MarkerId('delivery_person'),
        position: _deliveryPersonLocation,
        icon: deliveryIcon,
        anchor: const Offset(0.5, 0.5), // Center the marker
        infoWindow: const InfoWindow(title: 'Delivery Partner'),
      ),
      Marker(
        markerId: const MarkerId('user_location'),
        position: _userLocation,
        icon: userIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _destination,
        icon: destinationIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Delivery Destination'),
      ),
    };
  }

  // Calculate progress percentage (0.0 to 1.0)
  double get deliveryProgress {
    final totalDistance = _calculateDistance(
      _deliveryPersonLocation,
      _destination,
    );
    final initialDistance = _calculateDistance(
      const LatLng(37.42796133580664, -122.085749655962),
      _destination,
    );

    if (initialDistance == 0) return 0.0;

    return 1.0 - (totalDistance / initialDistance);
  }

  // Helper method to calculate distance between two points
  double _calculateDistance(LatLng start, LatLng end) {
    final latDiff = start.latitude - end.latitude;
    final lngDiff = start.longitude - end.longitude;
    return math.sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }
}
