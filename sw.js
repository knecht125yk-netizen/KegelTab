// Offline-Speicher von KegelTab. __BUILD__ wird beim Bauen durch eine neue Nummer ersetzt,
// dadurch merkt das Handy, dass es ein Update gibt.
const VERSION = 'kegeltab-__BUILD__';
const CORE = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/apple-touch-icon.png'
];
// Bibliotheken für Excel und PDF: werden gleich mitgespeichert, damit der Export auch offline geht.
const LIBS = [
  'https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.4.0/exceljs.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js'
];

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(VERSION);
    await cache.addAll(CORE.map(u => new Request(u, { cache: 'reload' })));
    await Promise.all(LIBS.map(u => cache.add(new Request(u, { mode: 'cors' })).catch(() => {})));
  })());
});

self.addEventListener('message', event => {
  if (event.data === 'skipWaiting') self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => (k.startsWith('kegeltab-') || k.startsWith('kegelliste-')) && k !== VERSION).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', event => {
  const req = event.request;
  if (req.method !== 'GET') return;
  // Seite selbst: immer die gespeicherte Version zeigen (schnell und offline), Updates kommen über eine neue sw.js.
  if (req.mode === 'navigate') {
    event.respondWith(caches.match('./index.html').then(r => r || fetch(req)));
    return;
  }
  // Alles andere: aus dem Speicher, sonst aus dem Netz holen und für später merken (z. B. Schriftarten).
  event.respondWith((async () => {
    const hit = await caches.match(req);
    if (hit) return hit;
    try {
      const res = await fetch(req);
      if (res && (res.ok || res.type === 'opaque')) {
        const cache = await caches.open(VERSION);
        cache.put(req, res.clone()).catch(() => {});
      }
      return res;
    } catch (e) {
      return new Response('', { status: 504, statusText: 'offline' });
    }
  })());
});
