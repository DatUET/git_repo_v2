//
//  CacheData.swift
//  git-reposytories
//
//  Created by gem on 7/3/20.
//  Copyright © 2020 gem. All rights reserved.
//

import CoreData
import UIKit

class CacheData {
    public func saveRepoToCoreData(repo: Repository, nameEntity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let repoEntity = NSEntityDescription.entity(forEntityName: nameEntity, in: managedContext)!
        let repoInDataCore = NSManagedObject(entity: repoEntity, insertInto: managedContext)
        repoInDataCore.setValue(repo.avatar, forKey: "avatar")
        repoInDataCore.setValue(repo.fork, forKey: "fork")
        repoInDataCore.setValue(repo.issue, forKey: "issue")
        repoInDataCore.setValue(repo.lastCommit, forKey: "lastCommit")
        repoInDataCore.setValue(repo.reponame, forKey: "reponame")
        repoInDataCore.setValue(repo.star, forKey: "star")
        repoInDataCore.setValue(repo.url, forKey: "url")
        repoInDataCore.setValue(repo.username, forKey: "username")
        repoInDataCore.setValue(repo.watch, forKey: "watch")
        do{
           try managedContext.save()
        } catch {
            debugPrint("ERR on save core data \(error)")
        }
    }
    
    public func getRepoCoreData(nameEntity: String) -> [Repository] {
        var arrRepo = [Repository]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return arrRepo }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for repo in result as! [NSManagedObject] {
                let avatar = repo.value(forKey: "avatar") as! String
                let username = repo.value(forKey: "username") as! String
                let reponame = repo.value(forKey: "reponame") as! String
                let url = repo.value(forKey: "url") as! String
                let star = repo.value(forKey: "star") as! Int
                let watch = repo.value(forKey: "watch") as! Int
                let fork = repo.value(forKey: "fork") as! Int
                let issue = repo.value(forKey: "issue") as! Int
                let lastCommit = repo.value(forKey: "lastCommit") as! String
                arrRepo.append(Repository.init(avatar: avatar, username: username, reponame: reponame, url: url, star: star, watch: watch, fork: fork, issue: issue, lastCommit: lastCommit))
            }
            
        } catch {
            debugPrint("ERR get data \(error)")
        }
        return arrRepo
    }
    
    public func deleteAllRepoDataCore(nameEntity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(nameEntity) error :", error)
        }
    }
}
