//
//  ViewController.swift
//  UISearchControllerDemo
//
//  Created by Frank.Chen on 2017/4/1.
//  Copyright © 2017年 Frank.Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    var tableView: UITableView!
    var searchController: UISearchController!
    var dataList: [String] = ["Apple", "Lichee", "Orange"] // 預設資料集合資料集合
    var filterDataList: [String] = [String]() // 搜尋結果集合
    var searchedDataSource: [String] = ["Avocado", "Banana", "Cherry", "Coconut", "Durian", "Grape", "Grapefruit", "Guava", "Lemon"] // 被搜尋的資料集合
    var isShowSearchResult: Bool = false // 是否顯示搜尋的結果
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // 生成TableVeiw
        self.tableView = UITableView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // 生成SearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.placeholder = "請輸入水果名稱"
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchResultsUpdater = self // 遵守UISearchResultsUpdating協議
        self.searchController.searchBar.delegate = self // 遵守UISearchBarDelegate協議
        self.searchController.dimsBackgroundDuringPresentation = false // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        
        // 將searchBar掛載到tableView上
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    // MARK: - TableView DataSource
    // ---------------------------------------------------------------------
    // 設定表格section的列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            return self.filterDataList.count
        } else {
            return dataList.count
        }
    }
    
    // 表格的儲存格設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            cell!.textLabel?.text = String(filterDataList[indexPath.row])
        } else {
            cell!.textLabel?.text = String(dataList[indexPath.row])
        }
        
        return cell!
    }
    
    // MARK: - Search Bar Delegate
    // ---------------------------------------------------------------------
    // 當在searchBar上開始輸入文字時
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需實作，因有遵守UISearchResultsUpdating協議的話，則輸入文字的當下即會觸發updateSearchResults，所以等同於同一件事做了兩次(可依個人需求決定，也不一定要跟法蘭克一樣選擇不實作)
    }
    
    // 點擊searchBar上的取消按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 依個人需求決定如何實作
        // ...
    }
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發 updateSearchResults 的 delegate 做查詢的動作(可依個人需求決定如何實作)
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Search Controller Delegate
    // ---------------------------------------------------------------------
    // 當在searchBar上開始輸入文字時
    // 當「準備要在searchBar輸入文字時」、「輸入文字時」、「取消時」三個事件都會觸發該delegate
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
        if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count == 0 {
            return
        }
        
        self.filterDataSource()
    }
    
    // 過濾被搜陣列裡的資料
    func filterDataSource() {
        // 使用高階函數來過濾掉陣列裡的資料
        self.filterDataList = searchedDataSource.filter({ (fruit) -> Bool in
            return fruit.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
        })
        
        if self.filterDataList.count > 0 {
            self.isShowSearchResult = true
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            // ...
        }
        
        self.tableView.reloadData()
    }
}


