# DartRouter

DartRouter is a URL router implemented in dart, that uses a trie data structure to store and match URL patterns. It supports URL parameters and wildcards.

## Features

-  Support parsing URLs with path and query parameters
-  Support wildcard pattern matching for paths
-  Support for adding, searching, and printing all registered routes
-  Type-safe and intuitive API



## Usage

Here's an example of how to use DartRouter in your code:

```swift
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
```

## Author

tbxark, [tbxark@outlook.com](mailto:tbxark@outlook.com)

## License

DartRouter is available under the MIT license. See the LICENSE file for more info.
