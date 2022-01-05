I'm not that good at reverse engineering, with that said

### Informations about the App
The application is written with the [Capacitor Framework](https://capacitorjs.com/), so we can quickly guess that most of the application code is in a javascript file.

### Finding the Javascript bundle
After downloading the APK (I use the link given by the [Aurora Store](https://auroraoss.com/)) and decoding it with [apktool](https://ibotpeaches.github.io/Apktool/), we find the source code under `/assets/public`.
Launching a web server in that folder (ex. `python -m http.server 8000`) lets us open the app as it would do on the phone.
From here on out, we can use the browser's tools to Debug and Analyze the application.
The scripts are minified and webpack has been used to bundle them together, so the chunks are quite hard to follow for static analysis, although in the `main.*.js` file we can find most of the app's code, together with obfuscated constants such as the OAuth2 Client Secret and some of the API endpoints.
Some possibly useful tools that I haven't tried are [Jalangi](https://github.com/Samsung/jalangi2), [MemInsight](https://github.com/Samsung/meminsight) and [Iroh](https://maierfelix.github.io/Iroh/)
