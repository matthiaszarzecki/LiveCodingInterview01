//
//  ViewController.swift
//  LiveInterview02
//
//  Created by Matthias Zarzecki on 26.01.22.
//

import UIKit

class ViewController: UITableViewController {
  private let api = Api()

  override func viewDidLoad() {
    super.viewDidLoad()

    api.getFruits { result in
      switch result {
      case .success(let fruitResponse):
        print(fruitResponse.fruits.count)
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
}
