 import 'package:example/movie_response.dart';
 import 'package:example/movies_fetcher.dart';
 import 'package:flutter/foundation.dart';
 import 'package:flutter/material.dart';

 import 'movies.dart';

 void main() => runApp(MyApp());

 class MyApp extends StatelessWidget {
   // This widget is the root of your application.
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       title: 'Super Enum Demo',
       home: MyHomePage(title: 'Movie Mania'),
     );
   }
 }

 class MyHomePage extends StatefulWidget {
   final String title;

   const MyHomePage({Key key, @required this.title}) : super(key: key);

   @override
   _MyHomePageState createState() => _MyHomePageState();
 }

 class _MyHomePageState extends State<MyHomePage> {
   final _movieFetcher =
       MoviesFetcher(apiKey: '9c9576f8c2e86949a3220fcc32ae2fb6');

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         elevation: 0.0,
         title: Text(widget.title,
             style: TextStyle(color: Colors.lightGreen, fontSize: 28)),
         backgroundColor: Colors.black54,
       ),
       backgroundColor: Colors.black54,
       body: StreamBuilder<MoviesResponse>(
         stream: _movieFetcher.fetchMovies(),
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             return snapshot.data.when<Widget>(
               success: (data) => MovieList(movieList: data.movies.results),
               unauthorized: (_) => Error(errorMessage: 'Invalid ApiKey'),
               noNetwork: (_) => Error(
                   errorMessage:
                       'No Internet, Please check your internet connection'),
               unexpectedException: (error) =>
                   Error(errorMessage: '${error.exception}'),
             );
           } else {
             return Loading(loadingMessage: 'Fetching Movies');
           }
         },
       ),
     );
   }
 }

 class MovieList extends StatelessWidget {
   final List<Movie> movieList;

   const MovieList({Key key, this.movieList}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     final deviceWidth = MediaQuery.of(context).size.shortestSide;

     print(deviceWidth);

     return GridView.builder(
       itemCount: movieList.length,
       physics: BouncingScrollPhysics(),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: deviceWidth > 900 ? 8 : deviceWidth > 600 ? 6 : 3,
         childAspectRatio: 1.5 / 1.8,
       ),
       itemBuilder: (context, index) {
         return Padding(
           padding: const EdgeInsets.all(8.0),
           child: Card(
             child: Padding(
               padding: const EdgeInsets.all(4.0),
               child: Image.network(
                 'https://image.tmdb.org/t/p/w342${movieList[index].posterPath}',
                 fit: BoxFit.fill,
               ),
             ),
           ),
         );
       },
     );
   }
 }

 class Loading extends StatelessWidget {
   final String loadingMessage;

   const Loading({Key key, @required this.loadingMessage}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Text(
             loadingMessage,
             textAlign: TextAlign.center,
             style: TextStyle(
               color: Colors.lightGreen,
               fontSize: 24,
             ),
           ),
           SizedBox(height: 24),
           CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
           ),
         ],
       ),
     );
   }
 }

 class Error extends StatelessWidget {
   final String errorMessage;

   const Error({Key key, @required this.errorMessage}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Center(
       child: Text(
         errorMessage,
         textAlign: TextAlign.center,
         style: TextStyle(
           color: Colors.lightGreen,
           fontSize: 24,
         ),
       ),
     );
   }
 }
