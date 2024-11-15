import 'package:url_launcher/url_launcher_string.dart';

enum ContactType { phone, email, website, address, whatsapp, instagram}

class ContactUs {
  final String name;
  final String image;
  final ContactType type;
  final String data;

  ContactUs({
    required this.name,
    required this.image,
    required this.type,
    required this.data,
  });

  Future<bool> launchContact() async {
    String url = '';

    switch (type) {
      case ContactType.phone:
        url = 'tel:$data';
        break;
      case ContactType.email:
        url = 'mailto:$data';
        break;
      case ContactType.website:
        url = data;
        break;
      case ContactType.whatsapp:
        url = 'https://wa.me/$data';
        break;
      case ContactType.instagram:
        url = 'https://www.instagram.com/$data';
        break;
      case ContactType.address:
        url = 'https://www.google.com/maps/search/?api=1&query=$data';
        break;
    }

    return launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  static ContactUs get whatsapp => ContactUs(
    name: 'WhatsApp',
    image: 'assets/icons/whatsapp.svg',
    type: ContactType.whatsapp,
    data: '966530281151',
  );

  static ContactUs get instagram => ContactUs(
    name: 'instagram',
    image: 'assets/icons/instagram.svg',
    type: ContactType.instagram,
    data: 'giveagiftsa',
  );

}

final List<ContactUs> contactUs = [
  ContactUs.whatsapp,
  ContactUs.instagram,
];