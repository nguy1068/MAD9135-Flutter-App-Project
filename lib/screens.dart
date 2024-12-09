import 'package:flutter/material.dart';
import 'widgets.dart';
import 'services.dart';
import 'providers.dart';
import 'utils.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShareCodeScreen()),
              );
            },
            child: Text('Get a Code to Share'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnterCodeScreen()),
              );
            },
            child: Text('Enter a Code'),
          ),
        ],
      ),
    );
  }
}

class ShareCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpHelper = HttpHelper();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    SharedPreferencesHelper.getDeviceId().then((deviceId) {
      userProvider.updateDeviceId(deviceId);
      httpHelper.startSession(deviceId).then((session) {
        sessionProvider.updateSession(session['data']['session_id'], session['data']['code']);
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text('Share Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingIndicator(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieSelectionScreen()),
                );
              },
              child: Text('Start Movie Matching'),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterCodeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final httpHelper = HttpHelper();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Enter Code')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter Code'),
            maxLength: 4,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              SharedPreferencesHelper.getDeviceId().then((deviceId) {
                userProvider.updateDeviceId(deviceId);
                httpHelper.joinSession(deviceId, int.parse(_controller.text)).then((session) {
                  sessionProvider.updateSession(session['data']['session_id'], _controller.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieSelectionScreen()),
                  );
                }).catchError((error) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(message: error.toString()),
                  );
                });
              });
            },
            child: Text('Join Session'),
          ),
        ],
      ),
    );
  }
}

class MovieSelectionScreen extends StatefulWidget {
  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> movies = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    final httpHelper = HttpHelper();
    final newMovies = await httpHelper.fetchMovies((movies.length ~/ 20) + 1);
    setState(() {
      movies.addAll(newMovies);
      isLoading = false;
    });
  }

  void voteMovie(bool vote) async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final httpHelper = HttpHelper();
    final result = await httpHelper.voteMovie(sessionProvider.sessionId!, movies[currentIndex]['id'], vote);

    if (result['data']['match']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Match Found!'),
          content: Text('You matched on ${movies[currentIndex]['title']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        currentIndex++;
        if (currentIndex >= movies.length) {
          fetchMovies();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Movie Selection')),
        body: Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Movie Selection')),
      body: Center(
        child: Dismissible(
          key: Key(movies[currentIndex]['id'].toString()),
          onDismissed: (direction) {
            voteMovie(direction == DismissDirection.endToStart);
          },
          child: MovieCard(
            title: movies[currentIndex]['title'],
            posterPath: 'https://image.tmdb.org/t/p/w500${movies[currentIndex]['poster_path']}',
          ),
        ),
      ),
    );
  }
}
