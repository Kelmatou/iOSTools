# :wrench:iOSTool:wrench:
Framework for any Swift development. It provides many functionalities to speed up your application development

## :rocket: Getting Started :rocket:

To include iOSTools in your project follow these steps:

 * Create a file named *Cartfile* at you project's root and write ```github "Kelmatou/iOSTools"``` in it.
 * Run command: ```carthage bootstrap --platform iOS``` in Terminal
 * Go to target General settings
 * Add iOSTools.framework in Embedded Binaries
 * If you cannot import iOSTools your project, go back to target settings ->
   Build Settings -> Framework Search Paths, then add the path to iOSTools.framework
 * Note: if you built simulator framework version, it will not be recognized
   unless you select simulator target. (same thing with device framework that
   must target iOS device or at least generic iOS device)

  iOSTools can now be used everywhere in your project's target.
  Documentation can be found in [Wiki](https://github.com/Kelmatou/iOSTools/wiki)

## :construction: Build Framework :construction:

### Requirement

  * Xcode 8 or later

### Building iOSTools for Simulator

  * Open iOSTools project in Xcode
  * Select any simulator and run iOSTools target
  * Product is located in "Products -> iOSTools.framework", just right click to
    reveal in finder.

### Building iOSTools for Real Device

  * Open iOSTools project in Xcode
  * Select any *Generic iOS Device*
  * Archive using "Product -> Archive"
  * Archive is created in your archive folder (by default: 
    /Users/*username*/Library/Developer/Xcode/Archives/*today's date*)
  * The framework built is located in this archive -> Products -> Library -> 
    Frameworks
  * Note: dSYMs may also be useful, they are also at archive's root -> dSYMs

## :punch: Contributing :punch:
You are free to bring your own contribution, however please try to follow these
development guidelines.

### Coding

  * Try to follow existing coding style (mostly based on Apple's coding style)
  * Use Editor -> Structure -> Re-Indent Xcode functionality
  * You can give any name to your class as long as it gives an idea of what's
    inside. If you're adding a existing type extension, name your file
    **classnameExtension**
  * Try to make your code as generic as possible.

  Overall, code **must compile** and must **not break any passed test**.

### Testing

  * Each time you create a class, the corresponding test file must be created
    in *iOSToolsTest/*. (unless it is a graphic component class such as camera,
    photo...)
    This file should have the same name as the class file.
  * Test all the methods of your class
  * Do not write test only for the main scenario, try to break your code
  * Before pushing on project's repository, launch all test suites.

If one test fails but it shouldn't and you can't find out why, leave that failed
test in the project. It is far better to know iOSTools doesn't handle one case
rather than ignoring it. Moreover, someone could find a solution.
