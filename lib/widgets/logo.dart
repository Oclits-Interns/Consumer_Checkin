import 'package:consumer_checkin/constant/colors_constant.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(image: AssetImage("assets/logo.png")),
    //NetworkImage("https://oclits.com/wp-content/uploads/elementor/thumbs/ConsumerCheckInSL512x512-oe6w0zaw1l5468ajcv2mps6mjmoh866bq4kxtq9udc.png")),
        const SizedBox(height: 20,),
        Text(
            "CONSUMER",
            style: TextStyle(
                letterSpacing: 3,
                color: kMaroon,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"
            )),
        const Text(
            "CHECKIN",
            style: TextStyle(
                letterSpacing: 8,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: "Montserrat"
            )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 90.0),
          child: Divider(
            color: Colors.black,
            thickness: 2,
          ),
        ),
        const Text(
          "ALL UTILITIES HUB",
          style: TextStyle(
              fontFamily: "Oswald",
              fontSize: 18,
              letterSpacing: 4
          ),
        ),
      ],
    );
  }
}
