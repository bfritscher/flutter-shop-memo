import 'package:flutter/widgets.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' show providerIcon;
import 'package:flutter_svg/flutter_svg.dart';

import '../oidc_eduid.dart';

Widget customProviderIcon(BuildContext context, String providerId) {
  try {
    return Icon(providerIcon(context, providerId));
  } catch (e) {
    return SvgPicture.string(
      dartIconSvgLight,
      width: 24,
      height: 24,
    );
  }
}
