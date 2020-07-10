//
//  ViewController.swift
//  taskapp
//
//  Created by 斉藤　剛 on 2020/07/09.
//  Copyright © 2020 tsuyoshi.saito. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     // Realmインスタンスを取得する
       let realm = try! Realm()  // ←追加

       // DB内のタスクが格納されるリスト。
       // 日付の近い順でソート：昇順
       // 以降内容をアップデートするとリスト内は自動的に更新される。
       var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)  // ←追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        //プレースホルダの指定
        searchBar.placeholder = "検索文字列を入力してください"
        
         
    }
    //データの数(＝セルの数)を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return taskArray.count
    }
    //　各セルの内容を返すメソッド
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          //再利用可能なcellを得る
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          
          //セルに値を設定する
          let task = taskArray[indexPath.row]
          cell.textLabel?.text = task.title
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd HH:mm"
          
          let dateString:String = formatter.string(from: task.date)
          cell.detailTextLabel?.text = dateString
          
          return cell
        
    }
    //各セルを選択した時に実行されるメソッド
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    //セルが削除が可能なことを伝えるメソッド
    func tableView(_ table: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    //Deleteボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()

            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }

            inputViewController.task = task
        }
    }
     override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tableView.reloadData()
       }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        if searchBar.text != "" {
            let predicate = NSPredicate(format: "category = %@ ", searchBar.text!)
            taskArray = realm.objects(Task.self).filter(predicate)
            tableView.reloadData()
        }else{
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
}
