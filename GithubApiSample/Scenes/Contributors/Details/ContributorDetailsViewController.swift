//
//  ContributorDetailsViewController.swift
//  GithubApiSample
//
//  Created by Oleksandr Harmash on 7/16/19.
//  Copyright © 2019 OG. All rights reserved.
//

import UIKit

import MapKit

class ContributorDetailsViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    
    var contributor: Contributor!
    var contributorLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = contributor.username
        map.setCenter(contributorLocation.coordinate, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = contributorLocation.coordinate
        annotation.title = contributor.username
        map.addAnnotation(annotation)
    }
    
}
