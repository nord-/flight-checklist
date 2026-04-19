import 'package:flutter/material.dart';
import 'models/checklist.dart';
import 'screens/home_screen.dart';
import 'services/checklist_loader.dart';
import 'services/checklist_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = ChecklistState();
  await state.init();
  final checklists = await ChecklistLoader.loadAll();
  runApp(FlightChecklistApp(state: state, checklists: checklists));
}

class FlightChecklistApp extends StatelessWidget {
  final ChecklistState state;
  final List<Checklist> checklists;

  const FlightChecklistApp({
    super.key,
    required this.state,
    required this.checklists,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flygchecklistor',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(state: state, checklists: checklists),
    );
  }
}
