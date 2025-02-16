'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "3aa244b68803f7db418d9c9c9a2572b4",
"version.json": "0394ea80a25a19317aaad56c13542aef",
"main.dart.js_7.part.js": "417e01badf7f9fd8d9770b95c6fd4e6b",
"main.dart.js_12.part.js": "35177d614826af6f95a61278199edd91",
"main.dart.js_6.part.js": "4c6add1e98441178e92ccdd1241375bc",
"index.html": "13883a4387f0037fa2fdcfc76ff3c765",
"/": "13883a4387f0037fa2fdcfc76ff3c765",
"main.dart.js_13.part.js": "de6450a52c99f31fac605950380824cf",
"main.dart.js_11.part.js": "6258013be4e920aedff8f81b2830a0c0",
"main.dart.js_4.part.js": "3dbf82e998e043c5f9f831811b57d526",
"main.dart.js": "0c90cd47e5169d52e4382b1cf70a462d",
"main.dart.js_18.part.js": "f62bcd9cf301413f071b54b25bed4a7c",
"main.dart.js_19.part.js": "f1fadaea02c85f6c73425888ef079d98",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_10.part.js": "dd8723f6c81ee20ab1fe71f2811b78df",
"main.dart.js_5.part.js": "c7b7eda3e0b2803c23f0a558be4ccac0",
"main.dart.js_15.part.js": "a2dd314d3803a54602c5cc0a18946d6a",
"favicon.png": "6cdedf2e85c823fb365f96da6c162f2a",
"main.dart.js_23.part.js": "482a5f9452a23dea28e105420108ddb1",
"main.dart.js_9.part.js": "a6bf37cf1931340934f32cb9b3ab1656",
"main.dart.js_22.part.js": "1840e06e50547ded5aca1b69e4e4a5bb",
"main.dart.js_8.part.js": "b7b594babee5bcccb605a05a637a550a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/payoorcart.png": "6cdedf2e85c823fb365f96da6c162f2a",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "eb006b998b774ffb6cfc332128516679",
"main.dart.js_14.part.js": "3680272b9a46f7d16ca2f13a7aa8207c",
"main.dart.js_1.part.js": "e952d544d84f3c9614e4b33770e29172",
"main.dart.js_20.part.js": "e2fbe7da1abb889c132a5b2273924413",
"main.dart.js_3.part.js": "7dcacbfe4cf59bf94187d0083ba80c4a",
"assets/AssetManifest.json": "392d951f0655cb869d1b0d274e0193f7",
"assets/NOTICES": "5fd840746acd0764ab25baf61c49a5bf",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "a0045af36b0b72227b9a9970c358f0dc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "12cb5777d42625d5e48d929e9821333f",
"assets/fonts/MaterialIcons-Regular.otf": "0e98944300b94e1a5ed9e7a53418cbef",
"assets/assets/fruits.png": "84b7103725e920e69ff1ee25c387a9a6",
"assets/assets/gal2.jpg": "c389ad7a4451fdbe12456a076b477691",
"assets/assets/payoorlogo.png": "d1b00bff946afe52be80292caff0926c",
"assets/assets/chicken_lap.png": "d942c2e0b60e0f4d94e8397d9a4bfee7",
"assets/assets/gal.jpg": "95fc8a866d60bf9d9798079d1a92033e",
"assets/assets/bike.png": "6c95176586c2a7a68412d75385a48ca0",
"assets/assets/chai_seed.jpeg": "31522e0ec206e38728d998860f302e13",
"assets/assets/pepper_container.png": "808e6c87a183bebafa62208a9fd4dda6",
"assets/assets/loading.gif": "98753524fe9a411f02fa058545f896fc",
"assets/assets/like.png": "ef75e98aa8fe5103aab305532f6aa60d",
"assets/assets/dude.jpg": "11f9718e5fc1a2ca61b6b1bb8869d28b",
"assets/assets/dude2.jpg": "5118069ae95bd5ba3eb2c5c06747a7c0",
"assets/assets/paper_box.png": "95a2cfda95c0c18cfdac01ed5bee0656",
"assets/assets/payoorcart.png": "6cdedf2e85c823fb365f96da6c162f2a",
"assets/assets/bournvita.png": "80f4405810b52740f5bad8ab53f9d3a3",
"assets/assets/fruit_basket.jpeg": "e83de3d95f3dec1531fcff7bf4183755",
"assets/assets/twitter.svg": "0c9462a79f736453eac5bf7cbb756875",
"assets/assets/dude.jpeg": "d799b34d3d0c202914340a6c703cd434",
"assets/assets/paper_basket.png": "fbbc2f4e43a0a1c492cfb1094380d913",
"assets/assets/dude2.jpeg": "eb62359ac7ffaf4226c823b05fb9837b",
"assets/assets/sample_dish.png": "ba8de172b5018817cd83ab4bc07e0cb1",
"assets/assets/burger.png": "b77ac191f939c868a38d3e573d7e14ac",
"main.dart.js_2.part.js": "fb79d16b2cd1713d59ec591354887ef0",
"main.dart.js_17.part.js": "e2cea9a27e7ffca8f7f68a0205c9c7d8",
"main.dart.js_21.part.js": "8145677f1ce079ebdd1b70aa1101be75",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
