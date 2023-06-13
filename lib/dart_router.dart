library dart_router;

class RouterNode {
  String pattern;
  String part;
  bool isWild;
  List<RouterNode> children;
  String? remark;

  RouterNode(this.pattern, this.part, this.isWild, this.children);

  void _insert(String pattern, List<String> parts, int height) {
    if (height == parts.length) {
      this.pattern = pattern;
      return;
    }
    String part = parts[height];
    RouterNode? child = _matchChild(part);
    if (child == null) {
      child = RouterNode(
          "", part, part.startsWith(":") || part.startsWith("*"), []);
      children.add(child);
    }
    child._insert(pattern, parts, height + 1);
  }

  RouterNode? _search(List<String> parts, int height) {
    if (height == parts.length || part.startsWith("*")) {
      if (pattern.isNotEmpty) {
        return this;
      }
      return null;
    }
    final matches = _matchChildren(parts[height]);
    for (var child in matches) {
      var result = child._search(parts, height + 1);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  List<RouterNode> _travel(List<RouterNode> list) {
    if (pattern.isNotEmpty) {
      list.add(this);
    }
    for (var child in children) {
      child._travel(list);
    }
    return list;
  }

  RouterNode? _matchChild(String part) {
    for (var child in children) {
      if (child.part == part || child.isWild) {
        return child;
      }
    }
    return null;
  }

  List<RouterNode> _matchChildren(String part) {
    List<RouterNode> matches = [];
    for (var child in children) {
      if (child.part == part || child.isWild) {
        matches.add(child);
      }
    }
    return matches;
  }
}

class RouterContext {
  Uri uri;
  Map<String, String> params;
  RouterContext(this.uri, {this.params = const {}});
}

class _RouterSearchContext {
  RouterNode node;
  Map<String, String> params;
  _RouterSearchContext(this.node, {this.params = const {}});
}

typedef Handler = void Function(RouterContext context);

class Router {
  Map<String, RouterNode> routes = {};
  Map<String, Handler> handlers = {};

  List<String> _parsePattern(String pattern) {
    final vs = pattern.split("/").toList();
    List<String> parts = [];
    for (var v in vs) {
      if (v.isNotEmpty) {
        parts.add(v);
        if (v.startsWith("*")) {
          break;
        }
      }
    }
    return parts;
  }

  String _buildKey(String group, String pattern) {
    return "$group:$pattern";
  }

  RouterNode? _addRoute(String group, String pattern, Handler handler) {
    final parts = _parsePattern(pattern);
    final key = _buildKey(group, pattern);
    RouterNode node = routes[group] ?? RouterNode("", "", false, []);
    node._insert(pattern, parts, 0);
    routes[group] = node;
    handlers[key] = handler;
    return node._search(parts, 0);
  }

  RouterNode? addRoute(String urlString, Handler handler) {
    final uri = Uri.parse(urlString);
    final pattern = "${uri.host}/${uri.path}";
    return _addRoute(uri.scheme, pattern, handler);
  }

  _RouterSearchContext? _getRoute(String group, String path) {
    final searchParts = _parsePattern(path);
    final root = routes[group];
    if (root == null) {
      return null;
    }
    final node = root._search(searchParts, 0);
    if (node == null) {
      return null;
    }
    final parts = _parsePattern(node.pattern);
    Map<String, String> params = {};
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.startsWith(":")) {
        params[part.substring(1)] = searchParts[i];
      }
      if (part.startsWith("*")) {
        params[part.substring(1)] = searchParts.sublist(i).join("/");
      }
    }
    return _RouterSearchContext(node, params: params);
  }

  void handle(String urlString) {
    final uri = Uri.parse(urlString);
    final pattern = "${uri.host}/${uri.path}";
    final ctx = _getRoute(uri.scheme, pattern);
    if (ctx == null) {
      return;
    }
    final handler = handlers[_buildKey(uri.scheme, ctx.node.pattern)];
    if (handler == null) {
      return;
    }
    final context = RouterContext(uri, params: ctx.params);
    handler(context);
  }


  List<RouterNode> allNode(String group) {
    final node = routes[group];
    if (node == null) {
      return [];
    }
    return node._travel([]);
  }

}
