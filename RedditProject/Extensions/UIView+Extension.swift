//
//  UIView+Extension.swift
//  RedditProject
//
//  Created by Ivan Bober on 13/12/2020.
//

import UIKit
import RxSwift

extension UIView {
    func tapped() -> Observable<UITapGestureRecognizer> {
        if let button = self as? UIButton {
            return button.rx.tap.map { UITapGestureRecognizer() }
        }
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.asObservable()
    }
}
