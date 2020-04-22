# Flutter Showcase

A simple, fast and easy way to share you flutter project or mockups with the world. [Demo](https://jamesblasco.github.io/flutter_showcase/)

<a href="https://jamesblasco.github.io/flutter_showcase/"> <img   src="https://github.com/jamesblasco/flutter_showcase/blob/master/preview.gif?raw=true"/></a>




## Intro

<a href="https://jamesblasco.github.io/flutter_showcase/"> <img align="right"  width= 200 src="https://github.com/jamesblasco/flutter_showcase/blob/master/mobile.png?raw=true"/></a>



Flutter Showcase is a project that helps you share flutter your project online. 
While building your project as a website is enough, this package aims to empower your demo.
You can can have different appareances, actionable links and social metadata.

**Flutter Showcase is only displayed when building the web project. When compiling to other platforms your project will still look as before.**

> Right now there is only SimpleTemplate
but the goal is to provide multiple options to share your project so you can choose the one that 
fits for you.

Check the [web demo](https://jamesblasco.github.io/flutter_showcase/) with the awesome vignettes from [@gskinnerTeam](https://github.com/gskinnerTeam/flutter_vignettes)

## Getting Started

1. Install package [Check last version](https://pub.dev/packages/flutter_showcase#-installing-tab-)

2. Wrap your app around a Showcase widget

``` dart
runApp(Showcase(
  title: 'My Awesome Project',
  description: 'Hello World! Welcome to my awesome Flutter Project',
  app: MyApp()
))
```

3. Add the frame builder inside Material App 

``` dart
MaterialApp(
  ....
  builder: Frame.builder,
  ....
)
```
> Why is this needed? This builder is used to set new MediaQuery params with mobile size

3. Run `Flutter build web` 

4. Publish the web project:
  See this cool articles on how to publish your app
  
  - [Firebase](https://medium.com/flutter/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469)
  - [Github - Automated](https://medium.com/flutter-community/flutter-web-github-actions-github-pages-dec8f308542a)
  
  
## That easy? **Yess!!!**

Keep reading for more detailed features


## Customize my showcase

1. Choose the template you perfer from the class Templates.

2. Add actianable links
```dart
Showcase(
  // Add LinkData.github, LinkData.pub or create your custom LinkData()
  links: [
    LinkData.github(
      'https://github.com/jamesblasco/flutter_showcase'),
    LinkData.pub(
    'https://github.com/jamesblasco/flutter_showcase')
  ],
  //Add your brand logo next to the Flutter logo
  logoLink: LinkData(
      icon: Image.asset('assets/jaime_logo.png',
          fit: BoxFit.fitHeight),
      url: 'https://github.com/jamesblasco')
)      
```

3. Create your custom theme
```dart
Showcase(
  theme : TemplateThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      fontFamily: 'WorkSans',
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.1,
      letterSpacing: 5),
    descriptionTextStyle: TextStyle(
        fontFamily: 'WorkSans',
        color: Colors.white70,
        fontWeight: FontWeight.w400,
        letterSpacing: 2),  
    flutterLogoColor: FlutterLogoColor.white,
    frameTheme: FrameThemeData(
      frameColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),    
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      textTheme: ButtonTextTheme.accent,
      padding: EdgeInsets.all(16),
    ),
    buttonTextStyle: TextStyle(
        fontFamily: 'WorkSans',
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 2),
    buttonIconTheme: IconThemeData(color: Colors.black) 
  ),
)  

```


## Current package problems
  
  - Flutter web is still limited, some features are not available and performance can be a bit low sometimes
  - While most of the ui packages work on web, there are some packages that won't work or will not allow to compile the app
  - Creating a mobile frame inside a Flutter web app makes the global positions from gestures to be a reference for the     whole screen and not the framed app, this might cause problems if you are using globalPosition in any GestureDetector or more advanced Widgets


##  Autogenerate social media tags - Experimental

CAUTION! This feature is still experimental; It generates a new index.html, if you add your own js scrips (as Firebase) it won't work for now.

This projects aims to generate social media tags title, description, url and image for your Flutter project so
you don't have to do it. 

1. A WebDriver is needed for making a screenshot of the project
  For the experimental version I am using `ChromeDriver`. 
  
  Github Actions have `ChromeDriver` installed by default 🎉
  Local instalation:
  - Mac users with Homebrew installed: `brew tap homebrew/cask && brew cask install chromedriver`
  - Debian based Linux distros: `sudo apt-get install chromium-chromedriver`
  - Windows users with Chocolatey installed: `choco install chromedriver`
  
  See [here](https://sites.google.com/a/chromium.org/chromedriver/downloads) for installing manually

2. Add this at the bottom of your `pubspec.yaml`
```yaml
showcase:
  title: Your project name
  description: This is the description of your project
  url: https://showcase-custom-web.com
```
3. Instead of `flutter build web` we will use `flutter pub run flutter_showcase build` that will generate the web project in the folder in build/web_showcase



