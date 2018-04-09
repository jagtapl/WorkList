//
//  ListsViewController.swift
//  WorkList
//
//  Created by LALIT JAGTAP on 3/30/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

//    var lists = [Worklist] ()

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
//        var list = Worklist(name: "Properties")
//        lists.append(list)
//
//        list = Worklist(name: "Alt Invest")
//        lists.append(list)
//
//        list = Worklist(name: "Coding")
//        lists.append(list)
//
//        list = Worklist(name: "Misc")
//        lists.append(list)
//
//        for list in lists {
//            let item = WorklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//        }
    
//        loadWorklists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped ?
        if viewController === self {
            dataModel.indexOfSelectedWorklist = -1
//            UserDefaults.standard.set(-1, forKey: "WorklistIndex")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
  
        let index = dataModel.indexOfSelectedWorklist
//        let index = UserDefaults.standard.integer(forKey: "WorklistIndex")
        
//        if index != -1 {      // this can cause suble error ...when app it killed from xcode so UserDefault saved index but new list not saved.
        
        if (index > 0 ) && (index < dataModel.lists.count) {
            let worklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowWorklist", sender: worklist)
        }
    }
    
    // MARK:- Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let worklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = worklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let count = worklist.countUncheckedItems()
        if worklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        }
        else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(worklist.countUncheckedItems()) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: worklist.iconName)
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedWorklist = indexPath.row
        //UserDefaults.standard.set(indexPath.row, forKey: "WorklistIndex")
        
        let worklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowWorklist", sender: worklist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWorklist" {
            let controller = segue.destination as! ItemsListViewController
            controller.worklist = sender as! Worklist
        } else if segue.identifier == "AddWorklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        let worklist = dataModel.lists[indexPath.row]
        controller.workListToEdit = worklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding worklist: Worklist) {
        dataModel.lists.append(worklist)
        dataModel.sortWorklists()
        tableView.reloadData()
        
        /* Removed and replaced with reloadData api as less no of rows in this table.
           But this approach is must where table has hundreds of row, to get better performance.
         
        let newRowIndex = dataModel.lists.count
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        */
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing worklist: Worklist) {
        dataModel.sortWorklists()
        tableView.reloadData()
        /* Removed and replaced with reloadData api as less no of rows in this table.
           But this approach is must where table has hundreds of row, to get better performance.
 
        if let index = dataModel.lists.index(of: worklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = worklist.name
            }
        }
        */
        
        navigationController?.popViewController(animated: true)
    }

    
    //TODO: Lalit todo
    
    //FIXME: Lalit fixme

}
