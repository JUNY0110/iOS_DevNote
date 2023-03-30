//
//  SudoCode.swift
//  Delegate
//
//  Created by 지준용 on 2023/03/22.
//

protocol MomDelegate {
    func buyTubu()
}

class Mom {
    var delegate: MomDelegate?

    func cook() {
        print("재료손질")
        print("김치찌개 끓이기")
        delegate?.buyTubu()
    }
}

class Son: MomDelegate {
    func buyTubu() {
        print("두부 1모 구매")
    }
}
