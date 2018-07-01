import 'package:flutter/material.dart';
import 'package:github/widgets/search/empty_result_widget.dart';
import 'package:github/github_api.dart';
import 'package:github/bloc/search_bloc.dart';
import 'package:github/widgets/search/search_error_widget.dart';
import 'package:github/widgets/search/search_intro_widget.dart';
import 'package:github/widgets/search/loading_widget.dart';
import 'package:github/widgets/search/search_result_widget.dart';
import 'package:github/state/search_state.dart';

class SearchScreen extends StatefulWidget {
  final GithubApi api;

  SearchScreen({Key key, GithubApi api})
      : this.api = api ?? GithubApi(),
        super(key: key);

  @override
  SearchScreenState createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  SearchBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = SearchBloc(widget.api);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchState>(
      stream: bloc.state,
      initialData: SearchNoTerm(),
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        final state = snapshot.data;

        return Scaffold(
          body: Stack(
            children: <Widget>[
              Flex(direction: Axis.vertical, children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Github...',
                    ),
                    style: TextStyle(
                      fontSize: 36.0,
                      fontFamily: "Hind",
                      decoration: TextDecoration.none,
                    ),
                    onChanged: bloc.onTextChanged.add,
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      SearchIntro(visible: state is SearchNoTerm),
                      EmptyWidget(visible: state is SearchEmpty),
                      LoadingWidget(visible: state is SearchLoading),
                      SearchErrorWidget(visible: state is SearchError),
                      SearchResultWidget(
                        items:
                            state is SearchPopulated ? state.result.items : [],
                      ),
                    ],
                  ),
                )
              ])
            ],
          ),
        );
      },
    );
  }
}
