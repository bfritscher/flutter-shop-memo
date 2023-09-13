import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'take_snap.dart';
import 'home_page.dart';
import 'details_snap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // ... other providers
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

// GoRouter configuration
  final _router = GoRouter(
    redirect: (context, state) {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        return '/login';
      }

      if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
        return '/verify-email';
      }

      return null;
    },
    routes: [
      GoRoute(
          path: '/login',
          builder: (context, state) {
            return SignInScreen(
              headerBuilder: (context, constraints, shrinkOffset) {
                return Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        'Snap!',
                        style: GoogleFonts.anton(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ))),
                );
              },
              actions: [
                ForgotPasswordAction((context, email) {
                  final uri = Uri(
                    path: '/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                }),
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (!state.user!.emailVerified) {
                    context.go('/verify-email');
                  } else {
                    context.go('/');
                  }
                }),
              ],
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Firebase UI! Please sign in to continue.'
                        : 'Welcome to Firebase UI! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, action) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      action == AuthAction.signIn
                          ? 'By signing in, you agree to our terms and conditions.'
                          : 'By registering, you agree to our terms and conditions.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          }),
      GoRoute(
          path: '/verify-email',
          builder: (context, state) {
            return EmailVerificationScreen(
              actions: [
                EmailVerifiedAction(() {
                  context.go('/profile');
                }),
                AuthCancelledAction((context) {
                  FirebaseUIAuth.signOut(context: context);
                  context.go('/');
                }),
              ],
            );
          }),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) {
          final arguments = state.uri.queryParameters;
          return ForgotPasswordScreen(
            email: arguments['email'],
            headerMaxExtent: 200,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return ScaffoldBottomNavigationBar(
              navigationShell: navigationShell,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyHomePage(title: 'Snaps!');
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/snap',
                  builder: (BuildContext context, GoRouterState state) {
                    return const TakeSnapScreen();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/profile',
                  builder: (BuildContext context, GoRouterState state) {
                    return ProfileScreen(
                      appBar: AppBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        title: Text("Profile",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                      actions: [
                        SignedOutAction((context) {
                          context.go('/');
                        }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ]),
      GoRoute(
          path: '/snap/:id',
          builder: (context, state) {
            return DetailSnapScreen(id: state.pathParameters['id']!, data: state.extra);
          }),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Snap!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class ScaffoldBottomNavigationBar extends StatelessWidget {
  const ScaffoldBottomNavigationBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldBottomNavigationBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Snaps!'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Take'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int tappedIndex) {
          navigationShell.goBranch(tappedIndex);
        },
      ),
    );
  }
}
