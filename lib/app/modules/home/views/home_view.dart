import 'package:ai_news/app/extras/utils/ai_utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(children: [
        Obx(() => VxAnimatedBox()
            .size(context.screenWidth, context.screenHeight)
            .withGradient(
              LinearGradient(
                colors: [
                  AIColor.primaryColor2,
                  controller.selectedColor.value,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            )
            .make()),
        AppBar(
          title: "AI radio"
              .text
              .xl4
              .bold
              .white
              .make()
              .shimmer(primaryColor: Vx.purple400, secondaryColor: Vx.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ).h(100).p16(),
        Obx(
          () => controller.radios.isEmpty
              ? Center(child: CircularProgressIndicator())
              : VxSwiper.builder(
                  itemCount: controller.radios.length,
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index) {
                    controller.changeColor(index);
                  },
                  itemBuilder: (context, index) {
                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: VxBox(
                            child: controller
                                .radios[index].category.text.uppercase.white
                                .make()
                                .px16(),
                          )
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 10)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              controller.radios[index].name.text.xl3.white.bold
                                  .make(),
                              5.heightBox,
                              controller
                                  .radios[index].tagline.text.sm.white.semiBold
                                  .make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              "Double Tap to play".text.gray300.make()
                            ].vStack())
                      ],
                      clip: Clip.antiAlias,
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                              image:
                                  NetworkImage(controller.radios[index].image),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken)),
                        )
                        .border(color: Colors.black, width: 5)
                        .withRounded(value: 60)
                        .make()
                        .onInkDoubleTap(() {
                      controller.playMusic(controller.radios[index].url);
                      controller.changeIcon();
                    }).p16();
                  },
                ).centered(),
        ),
        Obx(() => Align(
              alignment: Alignment.bottomCenter,
              child: [
                if (controller.isPlaying.value)
                  "Playing Now - ${controller.selectedRadio.value!.name} FM"
                      .text
                      .makeCentered(),
                Icon(
                        controller.isPlaying.value
                            ? CupertinoIcons.stop_circle
                            : CupertinoIcons.play_circle,
                        color: Colors.white,
                        size: 50)
                    .onInkTap(() {
                  if (controller.isPlaying.value) {
                    controller.audioPlayer.stop();
                    controller.changeIcon();
                  } else {
                    controller.playMusic(controller.selectedRadio.value!.url);
                    controller.changeIcon();
                  }
                })
              ].vStack(),
            ).pOnly(bottom: context.percentHeight * 12))
      ], fit: StackFit.expand),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: AvatarGlow(
        animate: controller.isListening.value,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          child: Icon(controller.isListening.value ? Icons.mic : Icons.mic_none,
              size: 36),
          onPressed: controller.toggleRecording,
        ),
      ),
    );
  }
}
