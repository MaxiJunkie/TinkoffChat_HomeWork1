//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by Максим Стегниенко on 14.11.2017.
//  Copyright © 2017 Maxim Stegnienko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ConversationDataProvider : NSObject {
    
    var fetchedResultsControllerUser: NSFetchedResultsController<User>?  =  NSFetchedResultsController<User>()
    var fetchedResultsControllerMessages: NSFetchedResultsController<Messages>?  =  NSFetchedResultsController<Messages>()
    
    let tableView: UITableView
    
    init(tableView: UITableView) {
     
        self.tableView = tableView
       
        super.init()
      
    }
    
   
    func performFetch() {
        
        self.fetchedResultsControllerUser?.delegate = self
        do {
            try self.fetchedResultsControllerUser?.performFetch()
            
        } catch {
            print("Error of perform fetch \(error)")
        }
    }
    
    func performFetchMessages() {
        
        self.fetchedResultsControllerMessages?.delegate = self
        do {
            try self.fetchedResultsControllerMessages?.performFetch()
            
        } catch {
            print("Error of perform fetch \(error)")
        }
    }
    
    
}

extension ConversationDataProvider: NSFetchedResultsControllerDelegate {
   
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
       
            switch type {
            case .delete:
                
                if controller == self.fetchedResultsControllerMessages {
                    let indexPaths = [IndexPath(row: 0, section: 0),]
                    self.tableView.deleteRows(at: indexPaths, with: .automatic)
                }
                else {
                    if let indexPath = indexPath {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
                
            case .insert:
                if controller == self.fetchedResultsControllerMessages {
                    
                    let indexPaths = [IndexPath(row: 0, section: 0),]
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }
                else {
                    if let newIndexPath = newIndexPath {
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                    }
                }
            case .move:
                if let indexPath = indexPath {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                if let newIndexPath = newIndexPath {
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
