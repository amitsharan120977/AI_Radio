import 'package:ai_news/app/api/speech_api.dart';
import 'package:ai_news/app/data/radio.dart';
import 'package:ai_news/app/extras/utils/ai_utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var radios = <MyRadio>[].obs;
  var selectedRadio = Rx<MyRadio?>(null);
  var selectedColor = Rx<Color>(AIColor.primaryColors1);
  var isPlaying = false.obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  var text = 'Press the button and start speaking'.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRadios();

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
    });
  }

  changeIcon() {
    isPlaying.value = !isPlaying.value;
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios.value = MyRadioList.fromJson(radioJson).radio;
    print(radios);
  }

  // ignore: unused_element
  playMusic(String url) {
    audioPlayer.play(url);
    selectedRadio.value = radios.firstWhere((element) => element.url == url);
    print(selectedRadio);
  }

  changeColor(int index) {
    selectedColor.value = Color(int.tryParse(radios[index].color)!);
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (tex) => text.value = tex,
        onListening: (is_listening) {
          isListening.value = is_listening;
          if (!is_listening) {
            Future.delayed(Duration(seconds: 1), () {
              print(text.value);
              selectedRadio.value = radios
                  .firstWhere((element) => element.category == text.value);
              playMusic(selectedRadio.value!.url);
              changeIcon();
            });
          }
        },
      );

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
