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

enum FetchedResultsType {
    case Conversation
    case Conversations
}


protocol FetchedResultsControllerType : NSFetchRequestResult {
    associatedtype ModelType
}

class ConversationDataProvider<T: NSFetchRequestResult> :  NSObject , FetchedResultsControllerType , NSFetchedResultsControllerDelegate  {
    
    typealias ModelType = T
    
    let frcType: FetchedResultsType
    
    var fetchedResultsController: NSFetchedResultsController<ModelType>?  =  NSFetchedResultsController<ModelType>()
    
    let tableView: UITableView

    init(tableView: UITableView ,with type: FetchedResultsType ) {
        
        self.tableView = tableView
        self.frcType = type
        
        super.init()
      
    }
   
    func performFetch() {
        
        self.fetchedResultsController?.delegate = self
        do {
            try self.fetchedResultsController?.performFetch()
            
        } catch {
            print("Error of perform fetch \(error)")
        }
    }
    
    
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
                
                if self.frcType == .Conversation {
                    let indexPaths = [IndexPath(row: 0, section: 0),]
                    self.tableView.deleteRows(at: indexPaths, with: .automatic)
                }
                else {
                    if let indexPath = indexPath {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
                
            case .insert:
                if self.frcType == .Conversation {
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


