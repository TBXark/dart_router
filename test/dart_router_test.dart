import 'package:flutter_test/flutter_test.dart';

import 'package:dart_router/dart_router.dart';

void main() {

  final router = Router();
  router.addRoute("app://user/:id", (ctx, args) {
    print("user id: ${ctx.params["id"]}");
  });
  router.addRoute("app://user/:id/:name", (ctx, args) {
    print("user id: ${ctx.params["id"]}");
    print("user name: ${ctx.params["name"]}");
  });
  router.addRoute("app://users/*all", (ctx, args) {
    print("users all: ${ctx.params["all"]}");
  });

  router.addRoute("app://query/test", (context, extraArgs) {
    print("query test: ${context.uri.queryParameters}");
  });

  router.handle("app://user/123");
  router.handle("app://user/123/abc");
  router.handle("app://users/123/abc");
  router.handle("app://query/test?name=abc&age=123");
}
