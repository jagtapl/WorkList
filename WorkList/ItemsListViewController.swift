//
//  ViewController.swift
//  WorkList
//
//  Created by LALIT JAGTAP on 3/15/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit

class ItemsListViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var worklist: Worklist!

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: WorklistItem) {
        let newRowIndex = worklist.items.count
        worklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: WorklistItem) {
        if let index = worklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = worklist.items[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        title = worklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorklistItem", for: indexPath)
        
        let item = worklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        configureDueDate(for: cell, with: item)
        return cell
    }

    //MARK:- To toggle checkmark on a row selected or de-selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = worklist.items[indexPath.row]

            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- To delete a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        worklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: WorklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            //cell.accessoryType = .checkmark
            label.text = "✓"
        } else {
            //cell.accessoryType = .none
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: WorklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        //label.text = "\(item.itemID): \(item.text)"
    }
    
    func configureDueDate(for cell: UITableViewCell, with item: WorklistItem) {
        let label = cell.viewWithTag(1002) as! UILabel
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        label.text = formatter.string(for: item.dueDate)
    }
}

