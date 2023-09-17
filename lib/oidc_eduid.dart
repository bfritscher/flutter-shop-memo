import 'package:firebase_ui_oauth_oidc/firebase_ui_oauth_oidc.dart';
import 'package:flutter/material.dart';

const _backgroundColor = ThemedColor(Colors.black, Colors.white);
const _color = ThemedColor(Colors.white, Colors.black);

const _dartIconSvgLight = '''

<svg xmlns="http://www.w3.org/2000/svg" id="Layer_1" data-name="Layer 1" viewBox="0 0 250 250"><circle cx="125" cy="125" r="122.37" style="fill:#00247d"/><path d="M63.88 160.18c0 10.1-5.82 10.59-15 10.59-12.3 0-14.81-3.91-14.81-16.34 0-11.51 1.84-16.53 14.81-16.53 13.22 0 15 3.86 15 17.88h-22.1c0 6.91.19 9.12 7.1 9.12 4.29 0 7.29.06 7.29-4.72Zm-7.71-9.3c0-6.61-1-7.1-7.29-7.1-6.67 0-7.1 1.41-7.1 7.1ZM91.49 165.57h-.25c-2 4.22-5.51 5.2-10 5.2-11.93 0-12.3-7.53-12.3-17.38 0-9.43 1.29-15.49 12.3-15.49 3.92 0 8 .74 9.67 4.66h.31V124.5h7.71v45.9h-7.75Zm-14.88-12.18c0 7.28-.18 11.51 6.86 11.51 7.89 0 7.59-3.86 7.59-11.51 0-6.85-.92-9.61-7.59-9.61-5.33 0-6.86 1.53-6.86 9.61ZM127.66 170.4v-5h-.24c-1.77 4.28-5.75 5.32-10.16 5.32-6.43 0-10.71-2.2-10.77-9.24v-23.21h7.71v20.26c0 4.59.43 6.37 5.39 6.37 5.93 0 7.83-2.51 7.83-8.08v-18.55h7.71v32.13ZM155.27 150.58v5.87H139v-5.87ZM168.13 170.4h-8.82v-45.9h8.82ZM176 124.5h21.91c12.67 0 18.06 4.59 18.06 17.08v10.83c0 9.55-2.69 18-16.59 18H176Zm23.38 38.38c5.94 0 7.78-5.33 7.78-10.47v-10.83c0-7.65-2.51-9.55-9.25-9.55h-13.13v30.85ZM34.24 89.28c0-9.22 4.24-10 12.77-10 7.46 0 12.86.32 12.44 9.72h-3.92c-.18-6-1.33-6.27-8.66-6.27-7.65 0-8.71 1-8.71 5.76 0 6.6 3.13 6 9.58 6.23 8.21.46 12.36.23 12.36 9.58 0 9.77-4.61 10.1-13.32 10.1s-13.37-1.06-12.63-11.06h3.92c-.1 7.6 1.38 7.6 8.71 7.6s9.4 0 9.4-6.78c0-6.59-3-5.48-9.27-6-6.82-.59-12.67.24-12.67-8.88ZM103 114.07h-5.9L88.06 83H88l-9.2 31.07H73L62.35 79.5h4l9.4 31.57h.09l9.32-31.57h5.76l9.22 31.57h.09l9.63-31.57h4.06ZM121.93 114.07H118V79.5h3.92ZM141.19 114.07h-3.92V83h-11.2v-3.5h26.32V83h-11.2ZM165.38 114.35c-6.31 0-10-4-10-10.88V90.1c0-9.77 6-10.87 14.43-10.87H173c7.24 0 9.45 3.13 9.45 10v1.11h-3.92v-1c0-4.84-1-6.64-6.08-6.64h-2.21c-8.11 0-11 1-11 7.29v9.49c0 7.88.32 11.43 6.87 11.43h4.65c6.27 0 8.2-.88 8.2-5.81v-2.76h3.92v3.22c0 7.93-5.07 8.81-12 8.81ZM215.93 114.07H212v-15.9h-20.22v15.9h-3.92V79.5h3.92v15.21H212V79.5h3.92Z" style="fill:#fff"/></svg>
''';

// Actually use a dark version of the svg here
const _dartIconSvgDark = _dartIconSvgLight;

const _dartIconSrc = ThemedIconSrc(_dartIconSvgLight, _dartIconSvgDark);

class EduidButtonStyle extends OidcProviderButtonStyle {
  const EduidButtonStyle();

  @override
  ThemedColor get backgroundColor => _backgroundColor;

  @override
  ThemedColor get color => _color;

  @override
  ThemedIconSrc get iconSrc => _dartIconSrc;

  @override
  double get iconPadding => 6;

  @override
  String get label => 'Sign in with edu-ID';
}
