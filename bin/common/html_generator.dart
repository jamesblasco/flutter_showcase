import 'dart:io';

import 'social_metadata.dart';

void generateHtmlFile(SocialMetadata socialMetadata) {
  final template = _template(socialMetadata);
  File('build/web_showcase/index.html')..writeAsStringSync(template);
}

String _template(SocialMetadata socialMetadata) => '''
    <!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <!-- Primary Meta Tags -->
  <title>${socialMetadata.title ?? ''}</title>
  <meta name="title" content="${socialMetadata.title ?? ''}">
  <meta name="description" content="${socialMetadata.description ?? ''}">

  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="${socialMetadata.url ?? ''}">
  <meta property="og:title" content="${socialMetadata.title ?? ''}">
  <meta property="og:description" content="${socialMetadata.description ?? ''}">
  <meta property="og:image" content="./social_media.png">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="${socialMetadata.url ?? ''}">
  <meta property="twitter:title" content="${socialMetadata.title ?? ''}">
  <meta property="twitter:description" content="${socialMetadata.description ?? ''}">
  <meta property="og:image" content="./social_media.png">

  <!-- iOS meta tags & icons -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="example">
  <link rel="apple-touch-icon" href="/icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="shortcut icon" type="image/png" href="/favicon.png"/>

  <link rel="manifest" href="/manifest.json">
</head>
<body>
  <!-- This script installs service_worker.js to provide PWA functionality to
       application. For more information, see:
       https://developers.google.com/web/fundamentals/primers/service-workers -->
  <script>
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', function () {
        navigator.serviceWorker.register('/flutter_service_worker.js');
      });
    }
  </script>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>

    ''';
