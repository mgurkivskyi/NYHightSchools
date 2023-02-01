# Wellcome to my test project

## Architecture

I chose MVVM+Coordinators since it is my goto architecture that allows layer separation and good dependency injection.

UIViewController subclasses only know about an instance that conforms ViewModelProtocol, receives data from it, and notifies it about any user interactions.

ViewModel, which conforms viewController's ViewModelProtocol, makes all data manipulations, asks DataProvider for data, and sends all navigation instructions to the NavigationDelegate.

DataProvider in this case just makes simple HTTP requests, however, can be extended to have caching, persistent storage, or other features.

Model just structs that represent data received from API.

The coordinator is the class that handles the navigation and configuration of ViewControllers, ViewModels, and DataProviders. Only Coordinator knows about the existence of all these classes since all of them communicate up layers thru protocols. The coordinator conforms NavigationDelegate protocol for handling navigation between screens.

## Other

Combine used between View and ViewModel, however, delegates or closures can be used for the same purpose. Combine gives easy SwiftUI migration in the future.

Dependency injection with generics will allow to mock DataProvider or ViewModel and assign a custom viewModel to SwiftUI preview in the future or use a mock object for various testing purposes.

## What I would do if I have more time

1. Add better API error handling
2. Add a spinner for pagination loading
3. Add unit tests
