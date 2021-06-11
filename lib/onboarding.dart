import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lifelineStyle = TextStyle(
        fontSize: 28, color: Color(0xff6574cf), fontWeight: FontWeight.w700);
    const blackStyle = TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.w700);
    const bodyStyle = TextStyle(fontSize: 15.0);

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
            title: "Welcome to",
            body: "TIMETRAC ",
            image: Image.asset(
              "assets/onboarding0.png",
              scale: 2,
            ),
            decoration: PageDecoration(
              pageColor: Colors.white,
              titlePadding: EdgeInsets.all(0),
              imagePadding: EdgeInsets.only(top: 100),
              titleTextStyle: lifelineStyle,
              bodyTextStyle: lifelineStyle,
            )),
        PageViewModel(
          body: "Description here",
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Productivity", style: lifelineStyle),
              Text(" at its best", style: blackStyle),
            ],
          ),
          image: Image.asset(
            "assets/onboarding1.png",
            scale: 3,
          ),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.only(top: 100),
            pageColor: Colors.white,
            bodyTextStyle: bodyStyle,
          ),
        ),
        PageViewModel(
          body: "Description here",
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Track", style: lifelineStyle),
              Text(" your work", style: blackStyle),
            ],
          ),
          image: Image.asset(
            "assets/onboarding2.png",
            scale: 3,
          ),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.only(top: 100),
            pageColor: Colors.white,
            bodyTextStyle: bodyStyle,
          ),
        ),
        PageViewModel(
          body: "Description here",
          titleWidget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Minimal UI", style: lifelineStyle),
              Text("thats easy on the eye", style: blackStyle),
            ],
          ),
          image: Image.asset(
            "assets/onboarding1.png",
            scale: 2,
          ),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.only(top: 100),
            pageColor: Colors.white,
            bodyTextStyle: bodyStyle,
          ),
        ),
      ],
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('ONBOARD', '123');
        _onIntroEnd(context);
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(7.0, 7.0),
        color: Color(0xFFBDBDBD),
        activeColor: Color(0xff6574cf),
        activeSize: Size(30.0, 7.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
