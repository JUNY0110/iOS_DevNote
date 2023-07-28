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

final class TodoViewController: BaseViewController, TableViewDataSourceDelegate {
    
    // MARK: - Property
    
    private var dataSource: TableViewDataSource!
    private let todoManager = CoreDataManager.shared
    var dataCount: Int {
        get {
            return todoManager.fetchTodoDataFromCoreData().count
        }
        set {
            configureMicroCopy(newValue)
        }
    }
    
    // MARK: - View
    
    private let tableView = BaseTableView()
    private let microcopy: UILabel = {
        $0.text = "추가된 일정이 없습니다."
        $0.textAlignment = .center
        $0.textColor = .secondaryLabel
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.backgroundColor = .systemGray6
        return $0
    }(UILabel())
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDataSource()
        configureMicroCopy(dataCount)
    }
    
    // MARK: - Layout
    
    override func layout() {
        self.view.addSubview(tableView)
        self.view.addSubview(microcopy)
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Attribute
    
    override func attribute() {
        tableView.register(TodoTableViewCell.self,
                           forCellReuseIdentifier: TodoTableViewCell.identifier)
        setupDataSource()
        configureRefreshControl()
        setupNavigationBar()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
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
        self.dataSource = TableViewDataSource(tableView: self.tableView, cellProvider: { tableView, indexPath, data -> UITableViewCell? in

            guard let color = ColorType(rawValue: Int(data.color)) else { preconditionFailure() }
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
            
            cell.delegate = self
            
            cell.configure(memo: data.memo,
                           endDate: data.endDate,
                           color: color)

            return cell
        })
        dataSource.delegate = self
        
        tableView.dataSource = dataSource
    }

    // MARK: - Navigation Method
    
    @objc func moveToAdditionVC() {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Refresh Control
    
    @objc func handleRefreshControl() {
        setupDataSource()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func configureMicroCopy(_ count: Int) {
        if count == 0 {
            microcopy.isHidden = false
            microcopy.frame = view.bounds
        } else {
            microcopy.isHidden = true
        }
    }
}

extension TodoViewController: TodoTableViewCellDelegate {
    private func fetchData(from sender: TodoTableViewCell) -> Datum {
        let color = sender.colorView.backgroundColor ?? .lightGray
        let colorNumber = ColorType.findColor(color)
        let data = Datum(memo: sender.memoLabel.text!,
                         endDate: (sender.hStackView.endDate.text?.convertToDate())!,
                         color: colorNumber,
                         isSuccess: false)
        return data
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


protocol TableViewDataSourceDelegate {
    var dataCount: Int { get set }
}

final class TableViewDataSource: UITableViewDiffableDataSource<MemoList, Datum> {
    
    // MARK: - Property
    
    private let todoManager = CoreDataManager.shared
    var delegate: TableViewDataSourceDelegate?
    
    // MARK: - Init
    
    override init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<MemoList, Datum>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)

        applySnapshot()
    }
    
    // MARK: - Apply Snapshot
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MemoList, Datum>()
        snapshot.appendSections([.memo])

        let datum = todoManager.fetchTodoDataFromCoreData()

        for data in datum {
            snapshot.appendItems([Datum(memo: data.memo, endDate: data.endDate,
                                        color: data.colors, isSuccess: data.isSuccess)])
        }
        
        self.apply(snapshot)
    }

    // MARK: - Method
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let cellItem = itemIdentifier(for: indexPath) {
            self.deleteCell(cellItem)
        }
        delegate?.dataCount = todoManager.fetchTodoDataFromCoreData().count
    }
    
    private func deleteCell(_ data: Datum) {
        var snapshot = snapshot()

        if let index = indexPath(for: data) {
            let todoData = todoManager.fetchTodoDataFromCoreData()[index.row]
            todoManager.deleteTodo(data: todoData) {
                snapshot.deleteItems([data])
            }
        }
        self.apply(snapshot)
    }
}
