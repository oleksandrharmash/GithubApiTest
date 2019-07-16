//
//  ContributorsViewController.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import UIKit

import UIScrollView_InfiniteScroll
import DZNEmptyDataSet
import CoreLocation

class ContributorsViewController: UIViewController, LoadingView, ToastMessageView, ProgressHUDView {

    @IBOutlet var tableView: UITableView!
    
    
    //this should be in another plcae, but according timeframes...
    private var contributorsApi: ContributorsApiRouter {
        return ApiProvider.shared
    }
    
    private var usersApi: UsersApiRouter {
        return ApiProvider.shared
    }

    private var contributors: [Contributor] = []
    private var canLoadMore: Bool = true
    private var loadingInProcess: Bool = false

    private lazy var geocoder: CLGeocoder = {
       return CLGeocoder()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Swift repo"
      
        let identifier = ContributorTableViewCell.identifier
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.infiniteScrollTriggerOffset = 20
        tableView.addInfiniteScroll {[weak self] _ in
            self?.loadMore()
        }
        
        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ in
            self?.canLoadMore ?? false
        }
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        loadMore()
    }

    func loadMore() {
        loadingStarted()
        
        let perPage = 25
        contributorsApi.contributorsForRepository("swift", of: "apple",
                                      offset: contributors.count, itemsPerPage: perPage) {[weak self] result in
            self?.loadingFinished(state: result.loadedState)
            if case .success(let resp) = result,
                let contributors = resp?.items {
                self?.contributors.append(contentsOf: contributors)
                self?.canLoadMore = contributors.count == perPage
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func loadingStarted() {
        loadingInProcess = true
        
        if contributors.isEmpty {
            showHud(withTitle: nil, subtitle: nil)
            tableView.reloadEmptyDataSet()
        }
    }
    
    func loadingFinished(state: LoadedState) {
        loadingInProcess = false
        loadingFinished(state: state, completion: nil)
        tableView.finishInfiniteScroll()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let detailsVC = segue.destination as? ContributorDetailsViewController,
            let info = sender as? [String:Any],
            let location = info["location"] as? CLLocation,
            let contributor = info["contributor"] as? Contributor else { return }
        
        detailsVC.contributor = contributor
        detailsVC.contributorLocation = location
    }
}

//MARK: - UITableViewDelegate
extension ContributorsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributors.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailsFor(contributors[indexPath.row])
    }
    
    func showDetailsFor(_ contributor: Contributor) {
        showHud(withTitle: nil, subtitle: nil)

        usersApi.detailsFor(contributor) { [weak self] result in
            if case .success(let resp) = result,
                let location = resp?.item?.location {
                self?.decodeLocation(location, of: contributor)
            } else {
                self?.loadingFinished(state: result.loadedState)
            }
        }
    }
    
    func decodeLocation(_ location: String, of contributor: Contributor) {
        geocoder.geocodeAddressString(location) {[weak self] (placemark, error) in
            if let error = error {
                let reason = FailReason(description: error.localizedDescription)
                self?.loadingFinished(state: .failed(error: reason))
                return
            }
            
            guard let coordinate = placemark?.first?.location else {
                let reason = FailReason(description: "Can't found location of contributor")
                self?.loadingFinished(state: .failed(error: reason))
                return
            }
            
            self?.loadingFinished(state: .success)
            self?.showLocation(coordinate, of: contributor)
        }
    }
    
    func showLocation(_ location: CLLocation, of contributor: Contributor) {
        let sender: [String:Any] = ["location" : location, "contributor" : contributor]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toContributorDetails", sender: sender)
        }
    }
}

//MARK: - UITableViewDataSource

extension ContributorsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContributorTableViewCell.identifier, for: indexPath) as! ContributorTableViewCell
        let contributor = contributors[indexPath.row]
        cell.show(contributor)
        return cell
    }
}

//MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
extension ContributorsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !loadingInProcess else { return nil }
        
        let attributes: [NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 14),
                                                        .foregroundColor: UIColor.lightGray]
        return NSAttributedString(string: "Ooops", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard !loadingInProcess else { return nil }

        let attributes: [NSAttributedString.Key:Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                                        .foregroundColor: UIColor.darkGray]
        return NSAttributedString(string: "No contributors available. Tap to reload",
                                  attributes: attributes)
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        loadMore()
    }
}
