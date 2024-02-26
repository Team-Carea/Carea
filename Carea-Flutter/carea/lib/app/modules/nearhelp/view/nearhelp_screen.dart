import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/modules/nearhelp/view/check_near_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:carea/app/modules/nearhelp/controller/google_map_controller.dart';
import 'package:kpostal/kpostal.dart';

class NearhelpScreen extends StatefulWidget {
  const NearhelpScreen({
    Key? key,
  }) : super(
          key: key,
        );
  @override
  State<NearhelpScreen> createState() => _NearhelpScreenState();
}

class _NearhelpScreenState extends State<NearhelpScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  late GoogleMapController mapController;
  late LocationService locationService;
  LatLng? userLocation;
  List<Map<String, dynamic>> places = [];
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String roadAddress = 'Not selected';

  void _sendData() async {
    String title = _titleController.text;
    String content = _contentController.text;
    String address = _addressController.text;

    await sendData(title, content, address);
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
    locationService = LocationService();
    _getUserLocation();
    _fetchPlaces();
    _loadUserDetails();
  }

  Future<void> _getUserLocation() async {
    var locationData = await locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    }
  }

  void _fetchPlaces() async {
    places = await getHelpData();
    setState(() {});
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20, 20)),
            "asset/img/redpin.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  Future<void> showNearHelpDialog(BuildContext context, int markerId) async {
    final data = await getHelpDataDetail(markerId);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: AppColors.white,
          child: NearHelpCheck(data: data),
        );
      },
    );
  }

  Future<void> _loadUserDetails() async {
    var details = await getUserDetail();
    if (mounted) {
      setState(() {
        userDetails = details;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움찾기'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              userLocation ?? const LatLng(37.5465, 126.9648), // 기본 위치: 숙명여자대학교
          zoom: 18,
        ),
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: Set<Marker>.of(
          places.map((place) {
            return Marker(
                markerId: MarkerId(place['id']),
                position: LatLng(place['latitude'], place['longitude']),
                icon: markerIcon,
                onTap: () {
                  showNearHelpDialog(context, int.parse(place['id']));
                });
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHelpDialog(context),
        backgroundColor: AppColors.white,
        child: const Icon(
          Icons.add,
          color: AppColors.greenPrimaryColor,
        ),
      ),
    );
  }

  void _showAddHelpDialog(BuildContext context) {
    _titleController.clear();
    _contentController.clear();
    _addressController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.clear),
                ),
                const SizedBox(
                  width: 25,
                ),
                const Text(
                  "새 도움 추가하기",
                  style: TextStyle(fontSize: 20, color: AppColors.black),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(userDetails?['profileImageUrl']),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    userDetails?['nickname'],
                    style:
                        const TextStyle(fontSize: 20, color: AppColors.black),
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 450,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          hintText: '제목을 작성해주세요.',
                        ),
                        _buildTextField(
                          controller: _addressController,
                          hintText: '주소를 선택해주세요.',
                          readOnly: true,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.map),
                            onPressed: () async {
                              final Kpostal result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KpostalView(
                                        useLocalServer: true, localPort: 1024)),
                              );
                              setState(
                                () {
                                  _addressController.text = result.address;
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: _contentController,
                            hintText: '내용을 작성해주세요.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      _sendData();
                    },
                    child: const Text('등록하기',
                        style: TextStyle(color: AppColors.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Widget? suffixIcon,
    bool? readOnly,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
            color: AppColors.lightGray,
            fontWeight: FontWeight.normal,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
        maxLines: null,
      ),
    );
  }
}
