//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, Storyboarded, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    var completionHandler : ((String) -> Void)?
    var errorHandler : ((String) -> ()) = {error in }
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up the delgates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar.showsCancelButton = true
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        searchBar.delegate = self
    }
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searcResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        searchResults = searchResults.filter{$0.subtitle.lowercased().contains(AppStrings.COUNTRY_NAME_US)}
        self.searchResults = self.searchResults.filter { result in
            if !result.title.contains(",") {
                return false
            }
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            return true
        }
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let alert = UIAlertController(title: AppStrings.Error, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.OK, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        errorHandler(error.localizedDescription)
    }
  
}

// Setting up extensions for search bar
extension SearchViewController: UISearchBarDelegate {
    //functions invokes when cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true)
    }
    
    //functions invokes when search bar search text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            searchResults.removeAll()
            self.searchResultsTable.reloadData()
            return
        }
        searchCompleter.queryFragment = searchText
    }
}

// Setting up extensions for the table view
extension SearchViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        self.dismiss(animated: true) { [weak self] in
            guard let cityName = searchResult.title.components(separatedBy: ",").first else {
                return
            }
            self?.completionHandler?(cityName)
        }
    }
}



