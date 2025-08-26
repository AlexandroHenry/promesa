import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 장소 및 위치 선택 뷰
class LocationView extends StatelessWidget {
  final TextEditingController placeController;
  final LatLng? selectedLatLng;
  final VoidCallback onMapPickerTap;

  const LocationView({
    super.key,
    required this.placeController,
    required this.selectedLatLng,
    required this.onMapPickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '장소',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: '장소명',
                  hintText: '만날 장소를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onMapPickerTap,
              icon: const Icon(Icons.location_on),
              label: const Text('지도 선택'),
            ),
          ],
        ),
        if (selectedLatLng != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: selectedLatLng!,
                  zoom: 12,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('picked'),
                    position: selectedLatLng!,
                  ),
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 지도 선택 페이지
class MapPickerPage extends StatefulWidget {
  final LatLng initial;
  
  const MapPickerPage({
    super.key,
    required this.initial,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 선택'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_picked ?? widget.initial);
            },
            child: const Text('완료'),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initial,
          zoom: 14,
        ),
        onTap: (pos) => setState(() => _picked = pos),
        markers: {
          Marker(
            markerId: const MarkerId('marker'),
            position: _picked ?? widget.initial,
          ),
        },
        myLocationButtonEnabled: true,
      ),
    );
  }
}
