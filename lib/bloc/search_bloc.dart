import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:github/github_api.dart';
import 'package:github/state/search_state.dart';
import 'package:github/models/search_result.dart';

class SearchBloc {
  final Sink<String> onTextChanged;
  final Stream<SearchState> state;

  factory SearchBloc(GithubApi api) {
    final onTextChanged = PublishSubject<String>();

    final state = onTextChanged.distinct()
      .debounce(const Duration(milliseconds: 250))
      .switchMap((String term) => _search(term, api))
      .startWith(SearchNoTerm());
    return SearchBloc._(onTextChanged, state);
  }

  SearchBloc._(this.onTextChanged, this.state);

  void dispose() {
    onTextChanged.close();
  }

  static Stream<SearchState> _search(String term , GithubApi api) async* {
    if (term.isEmpty) {
      yield SearchNoTerm();
    } else {
      yield SearchLoading();

      try {
        final result = await api.search(term);

        if (result.isEmpty()) {
          yield SearchEmpty();
        } else {
          yield SearchPopulated(result);
        }
      } catch (e) {
        yield SearchError();
      }
    }
  }
}
