import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexus/cubits/appLocalizationCubit.dart';
import 'package:nexus/ui/styles/colors.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await Hive.openBox(showCaseBoxKey);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Theme.of(context).copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: onPrimaryColor,
                secondary: secondaryColor,
                surface: backgroundColor,
                error: errorColor,
                onSecondary: onSecondaryColor,
                onSurface: onBackgroundColor,
              ),
            ),
            locale: context.read<AppLocalizationCubit>().state.language,
          );
        },
      ),
    );
  }
}
