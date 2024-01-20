'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "8442e81620ebc9490d4a4f2779cf667f",
"assets/AssetManifest.bin.json": "56aef8dad2fb73fc7dd112d950a7a60a",
"assets/AssetManifest.json": "4f15414a69033c3ec09d43b73268cb51",
"assets/assets/appicon_header.png": "b737abf6c159ade8f9ea1a47c52f6627",
"assets/assets/crescendo/field.png": "1b430d3b846e5ff4a793a32142556e45",
"assets/assets/crescendo/high_note.png": "f170888c31417989880b654c2f1acd99",
"assets/assets/crescendo/note.png": "0c48c771828948f6e95b3b63bd3789f4",
"assets/assets/fonts/IBMPlexSans-Bold.ttf": "1ae7d0a8e83337da66631aeca59fbb02",
"assets/assets/fonts/IBMPlexSans-BoldItalic.ttf": "5c7054fd77f5371213e6bd40ba413007",
"assets/assets/fonts/IBMPlexSans-ExtraLight.ttf": "4362bbf9009288efcbd3130c5ac8f671",
"assets/assets/fonts/IBMPlexSans-ExtraLightItalic.ttf": "d09511dbf61a5625e6296f7e536b7dd3",
"assets/assets/fonts/IBMPlexSans-Italic.ttf": "291a8d32d7596f69509713e0d31e1eb7",
"assets/assets/fonts/IBMPlexSans-Light.ttf": "abcc0987be49b417483f65063f144e4a",
"assets/assets/fonts/IBMPlexSans-LightItalic.ttf": "f059e141654e87fe1ec2180873970da7",
"assets/assets/fonts/IBMPlexSans-Medium.ttf": "361336a2ed1908c5cd8dec2e10aa71a2",
"assets/assets/fonts/IBMPlexSans-MediumItalic.ttf": "77fbc569f8e2c0cecd7d1317eba8cce8",
"assets/assets/fonts/IBMPlexSans-Regular.ttf": "1286abb632c5a409a0a997d11c994e34",
"assets/assets/fonts/IBMPlexSans-SemiBold.ttf": "3ea7eea66304ac5e02a95265505300fd",
"assets/assets/fonts/IBMPlexSans-SemiBoldItalic.ttf": "c7e16f251b21174781a036ecc37fb301",
"assets/assets/fonts/IBMPlexSans-Thin.ttf": "6dcbea439f36a796c36e5197a527c8a1",
"assets/assets/fonts/IBMPlexSans-ThinItalic.ttf": "9823c5872a073bda1d37e35b8d518912",
"assets/assets/fonts/mono/IBMPlexMono-Bold.ttf": "be4cc57a744421b843e08a2001436f40",
"assets/assets/fonts/mono/IBMPlexMono-BoldItalic.ttf": "1e9f7dcae801e46684ec0dea4604c600",
"assets/assets/fonts/mono/IBMPlexMono-Italic.ttf": "d39621570e4423c5e048f25f955c8b48",
"assets/assets/fonts/mono/IBMPlexMono-Regular.ttf": "ea96a0afddbe8ff439be465b16cbd381",
"assets/FontManifest.json": "e1db49a1f239d3c5245ddebcea93bb71",
"assets/fonts/MaterialIcons-Regular.otf": "0d6c5e2cae1f1139f6311bb0b684513c",
"assets/NOTICES": "f52c6c0c52a2bc32b339e009b120674d",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3f2cb96740645bb071445ecc64467faa",
"/": "3f2cb96740645bb071445ecc64467faa",
"main.dart.js": "4a9d45e4fa7fe1cfbeae1465736f9f03",
"manifest.json": "bf24c84c3bf99672a631c4f84464e793",
"version.json": "984e87a32c25627321be459ed4229eec"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
