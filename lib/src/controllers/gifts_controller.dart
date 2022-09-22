import '../models/gift.dart';
import '../repository/gifts_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class GiftsController extends ControllerMVC {
  Gift? gift;
  bool isLoading = true;
  bool showError = false;
  GiftsController() {
    listenForGifts();
  }

  void listenForGifts() async {
    try {
      showError = false;
      gift = await getGifts();
    } catch (e) {
      print(e);
      showError = true;
    }
    setState(() {
      isLoading = false;
    });
  }
}
