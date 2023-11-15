# mkAdbApp

`mkAdbApp` is a nix helper function that will create an executable wrapper to [scrcpy](https://github.com/Genymobile/scrcpy) with a few parameters to launch a specific android app and present the relevant area of the screen as an application.

## Usage

```
{ pkgs, ... } : let
  mkAdbApp = import lib/mkAdbApp.nix pkgs;
in {
  environment.systemPackages = [
    (mkAdbApp {
      bin = "fgo";
      name = "com.aniplex.fategrandorder.en";
      crop = "1080:1920:0:278";
      title = "Fate/Grand Order";
    })
    (mkAdbApp {
      ...
    })
    ...
  ];
}
```
The `mkAdbApp` module takes two arguments, `pkgs` and an attribute set of app properties. Partial application allows you to pass `pkgs` once and use the result to build any number of app wrappers.

#### Syntax

<dl>
  <dt><code>bin</code></dt>
  <dd>The name of the executable to generate.</dd>
  <dt><code>name</code></dt>
  <dd>The package name of the Android app. You can find this by searching the app in the play store in a browser and check the URL.</dd>
  <dt><code>crop</code></dt>
  <dd>The screen area to crop to, handy for letterboxed games. The value is passed directly to the scrcpy <code>--crop</code> argument.</dd>
  <dt><code>title</code></dt>
  <dd>The title of the application window.</dd>
</dl>

#### 
