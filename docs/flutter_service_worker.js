'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "58a8279f861b85e2cf0060b1ad8960f1",
"index.html": "447107045fc0896a0a4b9a804a565415",
"/": "447107045fc0896a0a4b9a804a565415",
"styles.css": "d41d8cd98f00b204e9800998ecf8427e",
"main.dart.js": "c45aa4fe41da3418780965603109123e",
"assets/AssetManifest.json": "e24544e8d31068a46e6865a1009e849d",
"assets/NOTICES": "92021b64f8f95d97bdcc89e810aee1b1",
"assets/FontManifest.json": "9b2fcf6726822786ef567fbe2c557f70",
"assets/packages/cr_logger/fonts/Epilogue-Medium.ttf": "d1e8200c19edef3130d09547100e4e6d",
"assets/packages/cr_logger/fonts/Epilogue-Regular.ttf": "4b18060d8e9b36c2a06be703b0eca65d",
"assets/packages/cr_logger/assets/ic_back.png": "2df77505c3e262f4b69d11c7ebeb2a18",
"assets/packages/cr_logger/assets/ic_menu.png": "3fd1b21ce1e24f006f76777b2105ef2d",
"assets/packages/cr_logger/assets/arrow_down.png": "738d453df625ae901abf453bd2bb1d5f",
"assets/packages/cr_logger/assets/content_copy.png": "2479731a9ec08fa90b3ecbd8d672492c",
"assets/packages/flutter_dropzone_web/assets/flutter_dropzone.js": "0266ef445553f45f6e45344556cfd6fd",
"assets/fonts/Epilogue-Medium.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/fonts/Epilogue-Regular.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/assets/ic_http.png": "54aef4f92d394a3dc36d3f8896e7b2e6",
"assets/assets/ic_error.png": "45a3b075aadc5d38ad9592b866f73297",
"assets/assets/ic_json.png": "16b6f9c6e05938444c5d10c446ee6957",
"assets/assets/ic_warning_android.png": "26a514682f7576454fcf43825e2f78eb",
"assets/assets/ic_error_android.png": "5428509e94ada2ee048926996d866e0f",
"assets/assets/ic_error_ios.png": "e9a18dd2117c576435935706f4c0d10c",
"assets/assets/ic_warning_ios.png": "4bb4038ad04e25a549179f4881045cf8",
"assets/assets/ic_debug.png": "c6938f119748d4e8c1642bd4038ca815",
"assets/assets/ic_warning.png": "6db3734fcd593b0b3365ef00e7043cfc",
"assets/assets/ic_debug_native.png": "303a8e117e0c329db4713282895b450a"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
