# Airport Finder
A test iOS App to find airports near your location.

## Description
This app prompts the user to select a radius (in km), and then finds up to five nearby airports within that radius. 
It uses the device's location as a starting point.

## Running the app
Running the app requires setting API secrets from Lufthansa's API in a `Secrets` struct where Xcode can find it. You can, for example:

- Get the required secrets [by registering here](https://developer.lufthansa.com/docs). 
- Then, find the file `SecretsSample.swift` in the project's Support directory, rename the struct to `Secrets` and update its properties like so:

```Swift
struct Secrets {
  static let LHClientID: String = "Your Lufthansa ClientID"
  static let LHClientSecret: String = "Your Lufthansa ClientSecret"
}
```

## Limitations
- The UI is designed to run on iPhone only. Running on iPad will probably look ugly.
- The app requires reading the iPhone's location. A possible improvement would be adding the ability to select a location manually.
- Once a search has been made, there is no UI to go back to the starting screen. You need to re-run the app to change the radius.
- As of now, error handling methods are stubs with little more than `print` statements. Improvements include presenting alerts and action sheets to the user with  possible recovery actions and/or instructions for next steps.

## Credits
- Icon graphic made by [DinosoftLabs](https://www.flaticon.com/authors/dinosoftlabs) from [www.flaticon.com](https://www.flaticon.com/).