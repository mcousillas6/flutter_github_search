import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:github/models/search_result.dart';

class GithubApi {
  final String baseUrl;
  final Map<String ,SearchResult> cache;
  final http.Client client;

  GithubApi({
    HttpClient client,
    Map<String, SearchResult> cache,
    this.baseUrl = "https://api.github.com/search/repositories?q=",
  }) :
    this.client = client ?? http.Client(),
    this.cache = cache ?? <String, SearchResult>{};

  /// Search GH repos using the given term
  Future<SearchResult> search(String term) async {
    if (cache.containsKey(term)) {
      return cache[term];
    } else {
      final result = await _fetchResults(term);
      cache[term] = result;
      return result;
    }
  }

  Future<SearchResult> _fetchResults(String term) async {
    final response = await client.get(Uri.parse("$baseUrl$term"));
    final results = json.decode(response.body);
    return SearchResult.fromJson(results['items']);
  }
}
