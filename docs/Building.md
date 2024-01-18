# Building

## Building for Web

When we want to host the app online! In this guide, we'll be using Github Pages.
we can do this pretty easily! Here's your super fun guide to building for the web.

1. Install all your dependencies. You can see [the Usage guide](./Usage.md) for instructions on how to do this.

2. Modify "homepage" in the `package.json`. If we wanted to target `https://patheticmustan.github.io/ScoutingAppWebBuildTest/`, it might look something like this.

```json
{
  ...
  "homepage": "/ScoutingAppWebBuildTest",
  ...
}
```

3. Get the web build!

```cmd
expo build:web
```

The result should be in web-build. The file structure should look something like this:

```
> pwa
> static
asset-manifest.json
index.html
manifest.json
serve.json
...other favicon stuff
```

4. Stick the contents of `web-build` in your other repository that you're using for github pages.

I personally prefer having a separate repository for the web build, but if you really wanted you could keep it in the same one. 

[Enable Github Pages](https://docs.github.com/en/pages/quickstart) for whatever branch you choose, the website should automatically build.


### HELP! My build is a blank, white screen... 💔

If you're getting a bunch of 404 errors in console, try double checking you did step 2 correctly! 

### Related Reading

- https://docs.expo.dev/distribution/publishing-websites/
- https://docs.github.com/en/pages/quickstart
