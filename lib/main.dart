import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
void main() {
  // Dodanie const dla wydajności
  runApp(const SportConnectApp());
}

class SportConnectApp extends StatelessWidget {
  const SportConnectApp({super.key}); // Dodanie const

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportConnect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF38A169), 
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38A169),
          secondary: const Color(0xFF6B46C1), // Fiolet
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF38A169),
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// Main screen with bottom navigation and shared data
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Lista jest dynamiczna, więc NIE MOŻE być const
  List<Map<String, dynamic>> gamesList = [
    {
      'sport': 'Beach Volleyball',
      'location': 'Venice Beach, CA',
      'playersNeeded': 2,
      'currentPlayers': 4,
      'maxPlayers': 6,
      'level': 'Intermediate',
      'time': 'In 30 min',
    },
    {
      'sport': 'Tennis',
      'location': 'Central Park Courts',
      'playersNeeded': 1,
      'currentPlayers': 1,
      'maxPlayers': 2,
      'level': 'Beginner',
      'time': 'In 1 hour',
    },
    {
      'sport': 'Beach Volleyball',
      'location': 'Santa Monica Beach',
      'playersNeeded': 1,
      'currentPlayers': 5,
      'maxPlayers': 6,
      'level': 'Expert',
      'time': 'Now',
    },
    {
      'sport': 'Basketball',
      'location': 'Rucker Park',
      'playersNeeded': 3,
      'currentPlayers': 7,
      'maxPlayers': 10,
      'level': 'Pro',
      'time': 'In 15 min',
    },
  ];

  // User profile data (dynamiczna, więc NIE const)
  Map<String, dynamic> userProfile = {
    'name': 'John Doe',
   
    'joinedDate': DateTime(2024, 1, 15),
    'gamesPlayed': 12,
    'gamesCreated': 5,
    'favoritesSports': ['Beach Volleyball', 'Tennis'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: IndexedStack(
  index: _currentIndex,
  children: [
    // Home Tab
    HomeTab(),

    // Find Game Tab
    FindGameTab(
      gamesList: gamesList,
      onGameJoined: _joinGame,
    ),

    // Map Tab
    MapTab(gamesList: gamesList),

    // Create Game Tab
    CreateGameTab(
      onGameAdded: _addNewGame,
    ),

    // Profile Tab
    ProfileTab(userProfile: userProfile),
  ],
),

      
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  type: BottomNavigationBarType.fixed,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Find Game',
    ),
     BottomNavigationBarItem(
    icon: Icon(Icons.map),
    label: 'Map',
  ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Create',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
 ),
);
  }

  // Function to add a new game to the list
  void _addNewGame(Map<String, dynamic> newGame) {
    setState(() {
      gamesList.add(newGame);
      // Update user stats
      userProfile['gamesCreated']++;
    });
  }

  // Function to handle joining a game
  void _joinGame(int gameIndex) {
    if (gameIndex >= 0 && gameIndex < gamesList.length && gamesList[gameIndex]['playersNeeded'] > 0) {
      setState(() {
        gamesList[gameIndex]['currentPlayers']++;
        gamesList[gameIndex]['playersNeeded']--;
        // Update user stats
        userProfile['gamesPlayed']++;
      });
    }
  }
}

// Home Tab - Welcome screen
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportConnect'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_volleyball,
                  size: 80,
                  color: Color(0xFF38A169),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to SportConnect!',
                  style: GoogleFonts.orbitron(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Find players for your favorite sports',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38A169).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF6B46C1), // Fiolet
                      width: 4,
                    ),
                  ),
                  child: const Column( 
                    children: [
                      _StatItem(emoji: '🎯', mainText: 'Over 1,200 games', subText: 'created this month'),
                      SizedBox(height: 12),
                      _StatItem(emoji: '⚡', mainText: '24 active games', subText: 'right now'),
                      SizedBox(height: 12),
                      _StatItem(emoji: '🌍', mainText: 'Players in 15+', subText: 'cities worldwide'),
                      SizedBox(height: 12),
                      _StatItem(emoji: '🏆', mainText: 'Join 5,000+', subText: 'active sports enthusiasts'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Nowy, wydzielony, stały widget
class _StatItem extends StatelessWidget {
  final String emoji;
  final String mainText;
  final String subText;

  const _StatItem({
    required this.emoji,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(subText, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Find Game Tab
// -----------------------------------------------------------------------------

class FindGameTab extends StatefulWidget {
  final List<Map<String, dynamic>> gamesList;
  final Function(int) onGameJoined;

  const FindGameTab({
    super.key,
    required this.gamesList,
    required this.onGameJoined,
  });

  @override
  State<FindGameTab> createState() => _FindGameTabState();
}

class _FindGameTabState extends State<FindGameTab> {
  String selectedSport = 'All';
  String selectedLevel = 'All';

  // Helper to build filter chips
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: Colors.deepPurple.shade400,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  // Color helper for level badge
  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Expert':
      case 'Pro': 
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Join Game logic 
  void _joinGame(BuildContext context, Map<String, dynamic> game, int gameIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Game'),
          content: Text('Do you want to join ${game['sport']} at ${game['location']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onGameJoined(gameIndex);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You joined the game! The organizer will be notified.')),
                );
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Musisz znaleźć index gry, która pasuje do obecnego 'game' w filteredGames
    final List<Map<String, dynamic>> gamesWithOriginalIndex = [];
    for (int i = 0; i < widget.gamesList.length; i++) {
      gamesWithOriginalIndex.add({
        ...widget.gamesList[i],
        'originalIndex': i, // Dodajemy oryginalny indeks, aby przekazać go do _joinGame
      });
    }

    // Apply filters
    final filteredGames = gamesWithOriginalIndex.where((game) {
      final sportMatch = selectedSport == 'All' || game['sport'] == selectedSport;
      final levelMatch = selectedLevel == 'All' || game['level'] == selectedLevel;
      return sportMatch && levelMatch;
    }).toList();

    return Scaffold(
  appBar: AppBar(
    title: Text(
      'Find a Game',
      // DODAJ TEN BLOK STYLE:
      style: GoogleFonts.orbitron(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
     centerTitle: true,
    backgroundColor: Colors.deepPurple,
  ),
      body: Column(
        children: [
          // 🔹 FILTER SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', selectedSport == 'All', () {
                    setState(() => selectedSport = 'All');
                  }),
                  _buildFilterChip('Beach Volleyball', selectedSport == 'Beach Volleyball', () {
                    setState(() => selectedSport = 'Beach Volleyball');
                  }),
                  _buildFilterChip('Tennis', selectedSport == 'Tennis', () {
                    setState(() => selectedSport = 'Tennis');
                  }),
                  _buildFilterChip('Basketball', selectedSport == 'Basketball', () {
                    setState(() => selectedSport = 'Basketball');
                  }),
                  _buildFilterChip('Soccer', selectedSport == 'Soccer', () {
                    setState(() => selectedSport = 'Soccer');
                  }),
                ],
              ),
            ),
          ),

          // 🔹 LEVEL FILTER
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Levels', selectedLevel == 'All', () {
                    setState(() => selectedLevel = 'All');
                  }),
                  _buildFilterChip('Beginner', selectedLevel == 'Beginner', () {
                    setState(() => selectedLevel = 'Beginner');
                  }),
                  _buildFilterChip('Intermediate', selectedLevel == 'Intermediate', () {
                    setState(() => selectedLevel = 'Intermediate');
                  }),
                  _buildFilterChip('Expert', selectedLevel == 'Expert', () {
                    setState(() => selectedLevel = 'Expert');
                  }),
                  _buildFilterChip('Pro', selectedLevel == 'Pro', () {
                    setState(() => selectedLevel = 'Pro');
                  }),
                ],
              ),
            ),
          ),

          // 🔹 GAMES LIST
          Expanded(
            child: filteredGames.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [ 
                        Icon(Icons.sports, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No games found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Try changing your filters!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      // POBRANIE ORYGINALNEGO INDEXU
                      final int originalGameIndex = game['originalIndex'];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFF6B46C1), width: 4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    game['sport'],
                                    style: GoogleFonts.orbitron(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getLevelColor(game['level']),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      game['level'],
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(game['location'])),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.people, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${game['currentPlayers']}/${game['maxPlayers']} players'),
                                  const SizedBox(width: 16),
                                  Text('Need: ${game['playersNeeded']} more'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(game['time']),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: game['playersNeeded'] > 0
                                    ? () => _joinGame(context, game, originalGameIndex) 
                                    : null,
                                child: Text(game['playersNeeded'] > 0 ? 'Join Game' : 'Game Full'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Create Game Tab
// -----------------------------------------------------------------------------

class CreateGameTab extends StatefulWidget {
  final Function(Map<String, dynamic>) onGameAdded;

  const CreateGameTab({
    super.key,
    required this.onGameAdded,
  });

  @override
  State<CreateGameTab> createState() => _CreateGameTabState();
}

class _CreateGameTabState extends State<CreateGameTab> {
  final _formKey = GlobalKey<FormState>();
  String _selectedSport = 'Beach Volleyball';
  String _selectedLevel = 'Intermediate';
  String _location = '';
  int _maxPlayers = 6;
  int _currentPlayers = 1;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Available sports list - const
  final List<String> _sports = const [
    'Beach Volleyball',
    'Tennis',
    'Basketball',
    'Soccer',
    'Badminton',
    'Table Tennis',
    'Squash',
  ];

  // Skill levels - const
  final List<String> _levels = const [
    'Beginner',
    'Intermediate', 
    'Expert',
    'Pro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Game',
          style: GoogleFonts.orbitron(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sport selection dropdown
            DropdownButtonFormField<String>(
              value: _selectedSport,
              decoration: const InputDecoration( 
                labelText: 'Choose Sport',
                border: OutlineInputBorder(),
              ),
              items: _sports.map((sport) {
                return DropdownMenuItem(value: sport, child: Text(sport));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSport = value!;
                  // Set default max players based on sport
                  if (value == 'Beach Volleyball') _maxPlayers = 6;
                  else if (value == 'Tennis') _maxPlayers = 2;
                  else if (value == 'Basketball') _maxPlayers = 10;
                  else if (value == 'Soccer') _maxPlayers = 22;
                  else if (value == 'Badminton') _maxPlayers = 4;
                  else if (value == 'Table Tennis') _maxPlayers = 2;
                  else if (value == 'Squash') _maxPlayers = 2;
                  else _maxPlayers = 4;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Location input field
            TextFormField(
              decoration: const InputDecoration( 
                labelText: 'Location',
                hintText: 'e.g. Central Park Court 3, Venice Beach',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
              onSaved: (value) {
                _location = value!;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Skill level dropdown
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: const InputDecoration( 
                labelText: 'Skill Level',
                border: OutlineInputBorder(),
              ),
              items: _levels.map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Player count fields
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _currentPlayers.toString(),
                    decoration: const InputDecoration( 
                      labelText: 'Current Players',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Enter a number';
                      }
                      int currentPlayers = int.parse(value);
                      if (currentPlayers >= _maxPlayers) {
                        return 'Must be less than max players ($_maxPlayers)';
                      }
                      if (currentPlayers < 1) {
                        return 'Must be at least 1';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (int.tryParse(value ?? '') != null) {
                        _currentPlayers = int.parse(value!);
                      }
                    },
                    onSaved: (value) {
                      _currentPlayers = int.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _maxPlayers.toString(),
                    decoration: const InputDecoration( 
                      labelText: 'Max Players',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Enter a number';
                      }
                      int maxPlayers = int.parse(value);
                      if (maxPlayers <= _currentPlayers) {
                        return 'Must be more than current players ($_currentPlayers)';
                      }
                      if (maxPlayers < 2) {
                        return 'Must be at least 2';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (int.tryParse(value ?? '') != null) {
                        _maxPlayers = int.parse(value!);
                      }
                    },
                    onSaved: (value) {
                      _maxPlayers = int.parse(value!);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Date and time selectors
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration( 
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    child: InputDecorator(
                      decoration: const InputDecoration( 
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                      ),
                      child: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Create game button
            ElevatedButton(
              onPressed: _createGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16), 
              ),
              child: const Text('Create Game', style: TextStyle(fontSize: 16)), 
            ),
          ],
        ),
      ),
    );
  }

  // Date picker function
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), 
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Time picker function
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Handle creating a new game
  void _createGame() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      String timeString = _getTimeString();
      int playersNeeded = _maxPlayers - _currentPlayers;
      
      Map<String, dynamic> newGame = {
        'sport': _selectedSport,
        'location': _location,
        'playersNeeded': playersNeeded,
        'currentPlayers': _currentPlayers,
        'maxPlayers': _maxPlayers,
        'level': _selectedLevel,
        'time': timeString,
      };
      
      widget.onGameAdded(newGame);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game created successfully! Players can now join.')), 
      );
      
      _formKey.currentState!.reset();
      setState(() {
        // Zresetowanie stanów po dodaniu gry
        _selectedSport = 'Beach Volleyball';
        _selectedLevel = 'Intermediate';
        _location = '';
        _maxPlayers = 6;
        _currentPlayers = 1;
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now();
      });
    }
  }

  // Helper function to create time string
  String _getTimeString() {
    DateTime now = DateTime.now();
    DateTime gameDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    
    Duration difference = gameDateTime.difference(now);
    
    if (difference.isNegative) {
      return 'Now'; 
    } else if (difference.inMinutes < 30) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      return 'In ${hours}h ${minutes}min';
    } else {
      return '${_selectedDate.day}/${_selectedDate.month} at ${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

// -----------------------------------------------------------------------------
// Profile Tab
// -----------------------------------------------------------------------------

class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const ProfileTab({
    super.key,
    required this.userProfile,
  });

  // POPRAWIONA DEFINICJA STAŁEJ (Użyto BorderRadius.all z Radius.circular)
  static const _kProfileCardShape = RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    side: const BorderSide( 
      color: const Color(0xFF6B46C1), 
      width: 4,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.orbitron( 
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:  Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16), 
        children: [
          // Profile header
          Card(
            elevation: 3,
            shape: _kProfileCardShape, // Użycie stałej
            child: Padding(
              padding: const EdgeInsets.all(20), 
              child: Column(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 16), 
                  // Name
                  Text(
                    userProfile['name'],
                    style: const TextStyle( 
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  // Member since
                  Text(
                    'Player since ${_formatDate(userProfile['joinedDate'])}',
                    style: const TextStyle( 
                      fontSize: 18,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20), 
          
          // Statistics section
          Text(
            'Career Stats',
            style: GoogleFonts.orbitron(
              fontSize: 20,  
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10), 
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Matches Played',
                  userProfile['gamesPlayed'].toString(),
                  Icons.sports,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16), 
              Expanded(
                child: _buildStatCard(
                  'Events Organized',
                  userProfile['gamesCreated'].toString(),
                  Icons.add_circle,
                  Colors.blue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20), 
          
          // Favorite sports section
          Text(
            'Sport Disciplines',
            style: GoogleFonts.orbitron(   
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20, 
            ),
          ),
          const SizedBox(height: 10), 
          
          Card(
            elevation: 3,
            shape: _kProfileCardShape, // Użycie stałej
            child: Padding(
              padding: const EdgeInsets.all(16), 
              child: Column(
                children: userProfile['favoritesSports'].map<Widget>((sport) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4), 
                    child: Row(
                      children: [
                        const Icon(Icons.sports_volleyball, color: Colors.orange, size: 20), 
                        const SizedBox(width: 12), 
                        Text(
                          sport,
                          style: const TextStyle(fontSize: 16), 
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 20), 
          
          // Account actions
          Text(
            'Account',
            style: GoogleFonts.orbitron(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20, 
            ),
          ),
          const SizedBox(height: 10), 
          
          Card(
            elevation: 3,
            shape: _kProfileCardShape, // Użycie stałej
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit), 
                  title: const Text('Edit Profile'), 
                  trailing: const Icon(Icons.arrow_forward_ios), 
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile coming soon!')), 
                    );
                  },
                ),
                const Divider(height: 1), 
                ListTile(
                  leading: const Icon(Icons.settings), 
                  title: const Text('Settings'), 
                  trailing: const Icon(Icons.arrow_forward_ios), 
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon!')), 
                    );
                  },
                ),
                const Divider(height: 1), 
                ListTile(
                  leading: const Icon(Icons.help), 
                  title: const Text('Help & Support'), 
                  trailing: const Icon(Icons.arrow_forward_ios), 
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help & Support coming soon!')), 
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Wydzielony widget do statystyk
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: _kProfileCardShape, // Użycie stałej
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8), 
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6), 
            Text(
              title,
              style: GoogleFonts.orbitron(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Funkcja formatująca datę
  String _formatDate(DateTime date) {
    const List<String> months = [ 
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
    
  }
}
// Map Tab
class MapTab extends StatefulWidget {
  final List<Map<String, dynamic>> gamesList;

  const MapTab({
    Key? key,
    required this.gamesList,
  }) : super(key: key);

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController? mapController;
  static const LatLng _defaultLocation = LatLng(53.8008, -1.5491); // Leeds 🏙️
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers(); // <-- dodane
  }

  @override
  void didUpdateWidget(MapTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gamesList != widget.gamesList) {
      _updateMarkers(); // <-- aktualizacja markerów przy każdej zmianie listy gier
    }
  }

  void _updateMarkers() {
    final newMarkers = widget.gamesList.map((game) {
      // UWAGA: Na razie losowa lokalizacja w okolicach Leeds
      final randomOffset = (game['sport'].hashCode % 100) / 5000.0;

      return Marker(
        markerId: MarkerId(game['sport'] + game['time']),
        position: LatLng(_defaultLocation.latitude + randomOffset, _defaultLocation.longitude - randomOffset),
        infoWindow: InfoWindow(
          title: game['sport'],
          snippet:
              '${game['level']} • ${game['currentPlayers']}/${game['maxPlayers']} players',
        ),
      );
    }).toSet();

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: GoogleFonts.orbitron(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _defaultLocation,
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: _markers, // <-- tu dodajemy markery
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
