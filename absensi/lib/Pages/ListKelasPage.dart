import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/widget/AppBarWidget.dart';
import 'package:absensi/widget/DrawerWidget.dart';
import 'package:absensi/widget/MatkulWidget.dart';

class ListKelas extends StatefulWidget {
  @override
  _ListKelasState createState() => _ListKelasState();
}

class _ListKelasState extends State<ListKelas> {
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse('https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc');
    final headers = {
      'Authorization': 'Bearer 923d222a6a5853d5c7550cc59f2251a0',
      'accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      print('Error fetching movies: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return Row(
                children: [
                  DrawerWidget(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "List Kelas yang Diambil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: MatkulWidget(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Popular Movies",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return ListTile(
                                  leading: _buildPosterWidget(movie['poster_path']),
                                  title: Text(movie['title']),
                                  subtitle: Text(movie['overview']),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(
                      "List Kelas yang Diambil",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  MatkulWidget(),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(
                      "Popular Movies",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return ListTile(
                        leading: _buildPosterWidget(movie['poster_path']),
                        title: Text(movie['title']),
                        subtitle: Text(movie['overview']),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      drawer: DrawerWidget(),
    );
  }

  Widget _buildPosterWidget(String posterPath) {
    final imageBaseUrl = 'https://image.tmdb.org/t/p/w92/';
    final imageUrl = '$imageBaseUrl$posterPath';

    return Image.network(
      imageUrl,
      width: 60,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image, size: 60);
      },
    );
  }
}