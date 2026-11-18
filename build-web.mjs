// Baut den App-Inhalt (Ordner www/) aus kegelliste.html.
// Die Bibliotheken für Excel und PDF werden mit in die App gepackt, damit der Export auch ohne Internet geht.
import { readFileSync, writeFileSync, mkdirSync, copyFileSync, rmSync } from 'node:fs';

rmSync('www', { recursive: true, force: true });
mkdirSync('www/lib', { recursive: true });

const page = readFileSync('kegelliste.html', 'utf8');
const html = `<!doctype html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover,user-scalable=no">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}img{max-width:100%}</style>
</head>
<body>
${page}
</body>
</html>
`;
writeFileSync('www/index.html', html);

const libs = [
  'node_modules/xlsx/dist/xlsx.full.min.js',
  'node_modules/jspdf/dist/jspdf.umd.min.js',
  'node_modules/jspdf-autotable/dist/jspdf.plugin.autotable.min.js'
];
for (const f of libs) copyFileSync(f, 'www/lib/' + f.split('/').pop());
console.log('www/ gebaut:', html.length, 'Zeichen, Bibliotheken:', libs.length);
