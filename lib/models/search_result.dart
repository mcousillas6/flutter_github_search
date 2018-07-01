class SearchResult {
  final List<SearchResultItem> items;

  SearchResult(this.items);

  factory SearchResult.fromJson(dynamic json) {
    final items = (json as List)
      .cast<Map<String, Object>>()
      .map((Map<String, Object> item) {
        return SearchResultItem.fromJson(item);
      }).toList();
    return SearchResult(items);
  }

  bool isEmpty() {
    return items.isEmpty;
  }
}

class SearchResultItem {
  final String fullName;
  final String url;
  final String avatarUrl;

  SearchResultItem(this.fullName, this.url, this.avatarUrl);

  factory SearchResultItem.fromJson(Map<String, Object> json) {
    return SearchResultItem(
      json['full_name'] as String,
      json['html_url'] as String,
      (json['owner'] as Map<String, Object>)["avatar_url"] as String,
    );
  }
}
