import 'package:flutter_test/flutter_test.dart';

import 'package:dart_router/dart_router.dart';

void main() {

  final router = Router();
  router.addRoute("app://user/:id", (ctx) {
    print("user id: ${ctx.params["id"]}");
  });
  router.addRoute("app://user/:id/:name", (ctx) {
    print("user id: ${ctx.params["id"]}");
    print("user name: ${ctx.params["name"]}");
  });
  router.addRoute("app://users/*all", (ctx) {
    print("users all: ${ctx.params["all"]}");
  });

  router.handle("app://user/123");
  router.handle("app://user/123/abc");
  router.handle("app://users/123/abc");
}
