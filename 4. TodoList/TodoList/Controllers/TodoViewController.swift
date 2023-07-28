//
//  TodoViewController.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/15.
//

import UIKit

// MARK: - Memo Enum

enum MemoList: CaseIterable {
    case memo
}

struct Datum: Hashable {
    let memo: String
    let endDate: Date
    let color: Int64
    let isSuccess: Bool
}

final class TodoViewController: BaseViewController {
    
    // MARK: - Property
    
    var dataSource: UITableViewDiffableDataSource<MemoList, Datum>!
    let todoManager = CoreDataManager.shared
    
    // MARK: - View
    
    private let tableView = BaseTableView()
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDataSource()
        configureTableView()
    }
    
    // MARK: - Layout
    
    override func layout() {
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    // MARK: - Attribute
    
    override func attribute() {
        tableView.register(TodoTableViewCell.self,
                           forCellReuseIdentifier: TodoTableViewCell.identifier)
        setupDataSource()
        configureTableView()
        configureRefreshControl()
        setupNavigationBar()
    }
    
    func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        setupDataSource()
        configureTableView()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func setupNavigationBar() {
        self.title = "할 일"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let additionButton = UIBarButtonItem(title: "추가", style: .plain,
                                             target: self, action: #selector(moveToAdditionVC))
        self.navigationItem.rightBarButtonItem = additionButton
        self.navigationItem.backButtonTitle = ""
    }

    
    // MARK: - Setup DataSource

    private func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource<MemoList, Datum>(tableView: self.tableView, cellProvider: { tableView, indexPath, data -> UITableViewCell? in

            guard let color = ColorType(rawValue: Int(data.color)) else { preconditionFailure() }
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
            
            cell.delegate = self
            
            cell.configure(memo: data.memo,
                           endDate: data.endDate,
                           color: color)
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    private func configureTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<MemoList, Datum>()
        snapshot.appendSections([.memo])

        let datum = todoManager.fetchTodoDataFromCoreData()

        for data in datum {
            snapshot.appendItems([Datum(memo: data.memo,
                                        endDate: data.endDate,
                                        color: data.colors,
                                        isSuccess: data.isSuccess)])
        }
        dataSource.apply(snapshot)
    }
    
    // MARK: - Navigation Method
    
    @objc func moveToAdditionVC() {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension TodoViewController: TodoTableViewCellDelegate {
    func presentAlert(_ sender: TodoTableViewCell) {
        let sheet = UIAlertController(title: "달성하셨습니까?", message: nil,
                                      preferredStyle: .actionSheet)
        let successAction = UIAlertAction(title: "예", style: .destructive) { action in
            self.deleteData(self.fetchData(from: sender))
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel)

        sheet.addAction(successAction)
        sheet.addAction(cancel)
        present(sheet, animated: true)
    }
    
    func fetchData(from sender: TodoTableViewCell) -> Datum {
        let color = sender.colorView.backgroundColor ?? .lightGray
        let colorNumber = ColorType.findColor(color)
        let data = Datum(memo: sender.memoLabel.text!,
                         endDate: (sender.hStackView.endDate.text?.convertToDate())!,
                         color: colorNumber,
                         isSuccess: false)
        return data
    }
    
    func deleteData(_ data: Datum) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([data])

        if let index = dataSource.indexPath(for: data) {
            let todoData = todoManager.fetchTodoDataFromCoreData()[index.row]
            todoManager.deleteTodo(data: todoData) {
                self.dataSource.apply(snapshot)
            }
        }
    }

    func moveToRenewalViewController(_ sender: TodoTableViewCell) {
        let detailVC = DetailViewController()
        let data = fetchData(from: sender)
        
        if let index = dataSource.indexPath(for: data) {
            let todoData = todoManager.fetchTodoDataFromCoreData()[index.row]
            detailVC.detailView.todoData = todoData
            detailVC.isUpdating = true
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
