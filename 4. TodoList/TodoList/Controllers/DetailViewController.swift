//
//  DetailViewController.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/16.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Property
    
    let todoManager = CoreDataManager.shared
    var isUpdating = false
    
    // MARK: - View
    
    var detailView = DetailView()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        attribute()
    }
    
    // MARK: - Layout
    
    override func layout() {
        view.addSubview(detailView)
        detailView.frame = view.bounds
    }
    
    // MARK: - Attribute
    
    override func attribute() {
        super.attribute()
        
        detailView.attribute()
        detailView.delegate = self
    }
    
    // MARK: - Method
    
    func isCheckDuplication(_ sender: DetailView) -> Bool {
        let isCheckDuplication = todoManager.fetchTodoDataFromCoreData().allSatisfy { data in
            if data.memo == sender.textView.text &&
               data.endDate == (sender.dateLabel.text?.convertToDate())! {
                return false
            }
            return true
        }
        return isCheckDuplication
    }
    
    func duplicationAlert() {
        let alert = UIAlertController(title: "알림",
                                      message: """
                                                같은 날 동일하게 작성된 일정이 있습니다.
                                                이어서 작성하시겠습니까?
                                                """,
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "계속", style: .default)
        let noAction = UIAlertAction(title: "뒤로 가기", style: .destructive) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}

// MARK: - Data Handling

extension DetailViewController: DetailViewDelegate {
    func tappedCalendar(_ sender: DetailView) {
        sender.dateLabel.text = "🕓 \(sender.datePicker.date.convertToString())"
    }
    
    func pressedSaveButton(_ sender: DetailView) {
        if self.isUpdating {
            if isCheckDuplication(sender), let todoData = detailView.todoData {
                sender.addAndUpdateButton.isEnabled = false
                
                todoData.memo = sender.textView.text
                todoData.colors = Int64(sender.colorNumber)
                todoData.endDate = sender.datePicker.date
                todoManager.updateTodo(newTodoData: todoData) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            duplicationAlert()
        } else {
            if isCheckDuplication(sender) {
                sender.addAndUpdateButton.isEnabled = false

                todoManager.saveTodoData(memo: sender.textView.text,
                                         endDate: (sender.dateLabel.text?.convertToDate())!,
                                         color: Int64(sender.colorNumber),
                                         isSuccess: false) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            duplicationAlert()
        }
    }
}
