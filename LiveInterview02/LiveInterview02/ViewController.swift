//
//  ViewController.swift
//  LiveInterview02
//
//  Created by Matthias Zarzecki on 26.01.22.
//

import UIKit

class ViewController: UITableViewController {
  private let api = Api()
  private var fruits: [Fruit] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self

    getFruits()
  }

  private func getFruits() {
    api.getFruits { [weak self] result in
      switch result {
      case .success(let fruitResponse):
        self?.fruits = fruitResponse.fruits
        print(fruitResponse.fruits.count)

        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    fruits.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cellIdentifier = "tableViewCell"
    let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier,
      for: indexPath
    )
    cell.textLabel?.text = fruits[indexPath.row].name
    cell.detailTextLabel?.text = "\(fruits[indexPath.row].price)"
    return cell
  }
}
