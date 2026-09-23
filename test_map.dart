import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
void test(MapController mc) {
  mc.fitCamera(CameraFit.bounds(bounds: LatLngBounds(LatLng(0,0), LatLng(1,1))));
}
