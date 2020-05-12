//
//  MasterViewController.swift
//  RedditTest
//
//  Created by luciano on 04/05/2020.
//  Copyright © 2020 Egg. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var networking: Networking = Networking()
    var articles : [Article] = []
    var nextPage: String = ""
    var articlesIds: [String] = []

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top posts"
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")

        self.articlesIds = userDefaults.object(forKey: "articlesIds") as? [String] ?? []

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        let addButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(dismissAll(_:)))
        navigationItem.rightBarButtonItem = addButton

        networking.getTopPost(after: "") { articlesData in
            self.articles = articlesData.children
            if let after = articlesData.after {
                self.nextPage = after
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .white

        tableView.addSubview(refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: Private Methods

    @objc private func dismissAll(_ sender: Any) {
        self.articles = []
        tableView.reloadSections([0], with: .fade)
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        networking.getTopPost(after: "") { articlesData in
            self.articles = articlesData.children
            if let after = articlesData.after {
                self.nextPage = after
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }

    private func updateArticleId(articleId: String) {
           // Append String to Array of Strings
           if !self.articlesIds.contains(articleId) {
               self.articlesIds.append(articleId)
               userDefaults.set(self.articlesIds, forKey: "articlesIds")
           }
       }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = articles[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.articleData = object.data
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: Table View

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailCell.preferredHeight
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = articles[indexPath.row].data
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.viewData = DetailCell.ViewData(data: object)
        cell.selectedCell = self.articlesIds.contains(object.id)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == articles.count {
            networking.getTopPost(after: nextPage) { articlesData in
                self.articles += articlesData.children
                if let after = articlesData.after {
                    self.nextPage = after
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DetailCell
        cell.selectedCell = true

        let object = articles[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)

        updateArticleId(articleId: object.data.id)
    }
}

extension MasterViewController: DetailCellDelegate {
    func detailCellTapOnDismissButton(cell: DetailCell) {
        guard
        let indexPath = self.tableView?.indexPath(for: cell)
        else { return }

        self.articles.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
