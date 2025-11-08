import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Help Centre",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Call or chat with us and we will answer any\nquestion you have",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Help Icon (You can replace it with your image asset)
            Image.asset(
              'assets/help.png', // Replace with your local asset path
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 30),

            _buildHelpOption(
              icon: Icons.email_outlined,
              title: "Email Us",
              subtitle: "support@greenwallet.com",
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'support@greenwallet.com',
                  query: 'subject=Help Needed from GreenWallet App',
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildHelpOption(
              icon: FontAwesomeIcons.facebookF,
              title: "Facebook",
              subtitle: "Connect with us on Facebook",
              onTap: () async {
                final fbUrl = Uri.parse('https://facebook.com/your_page');
                if (await canLaunchUrl(fbUrl)) {
                  await launchUrl(fbUrl, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildHelpOption(
              icon: FontAwesomeIcons.xTwitter,
              title: "Twitter",
              subtitle: "Follow us on twitter",
              onTap: () async {
                final twitterUrl = Uri.parse(
                    'https://twitter.com/your_handle'); // Replace with actual link
                if (await canLaunchUrl(twitterUrl)) {
                  await launchUrl(twitterUrl,
                      mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Could not open Twitter")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD7C9F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF3F2771)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
