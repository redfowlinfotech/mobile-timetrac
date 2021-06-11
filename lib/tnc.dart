import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.only(top: 80),
        child: ListView(
          children: <Widget>[
            // Max Size

            ExpansionTile(
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.grey),
              ),
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                        "Protecting your privacy is important to us. We hope the following statement will help "
                        "you understand how our app deals with the personal identifiable information ('PII') you may "
                        "occasionally provide to us via the Internet (the Google Play Platform). "
                        "Generally, we do not collect any PII from you when you download our Android applications. "
                        "To be specific, we do not require the consumers to get registered before downloading the "
                        "application, nor do we keep track of the consumers' visits to our application. ",
                        style: TextStyle(color: Colors.grey)))
              ],
            ),
            ExpansionTile(
              title: Text(
                'User Agreement',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Identifiers, such as your IP address, device ID, and device information (such as model,"
                    "brand and operating system)."
                    "Analytics - We use third party analytics tools, Google Analytics, to help us measure traffic "
                    "and usage trends for the service. Google Analytics collects information such as how often "
                    "users visit our services, what pages they visit when they do so, and what other pages they "
                    "use prior to coming to our services. We use the information we get from Google Analytics "
                    "only to improve our services."
                    "Log file - The only situation we may get access to your PII is when you personally decide to "
                    "email us your feedback or to provide us with a bug log report. The PII we may get from you "
                    "in that situation are strictly limited to your name, email address, device information, location "
                    "Information and your survey response only."
                    "How we use your information : In the above situation, we guarantee that your PII will only "
                    "be used for contacting you and improving our services. We will never use such information "
                    "(e.g. your name and email address) for any other purposes, such as to further market our "
                    "products, or to disclose your personal information to a third party for commercial gains. "
                    "Contact us : It should be noted that whether or not to send us your feedback or bug report "
                    "is a completely voluntary initiative upon your own decision. If you have concern about your "
                    "PII being misused, or if you want further information about our privacy policy and what it "
                    "means, please feel free to email us at contact@redfowlinfotech.com, we will endeavor to "
                    "provide clear answers to your questions in a timely manner."
                    "Geolocation information, such as your GPS information when you use the location reminder "
                    "feature of the Services. Where required, we will obtain your consent prior to collecting such "
                    "information."
                    "Cookies: we use cookies and other similar technologies (Cookies) to enhance your "
                    "experience when using the Services. For more information about our Cookies policy, see "
                    "below How We Use Cookies and Similar Technologies section",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ],
        ),

        // This trailing comma makes auto-formatting nicer for build methods.
      )),
    );
  }
}
