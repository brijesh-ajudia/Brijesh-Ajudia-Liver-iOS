//
//  UITableView+Extension.swift
//  DemoHyperhire
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit

extension UITableView {

    func register(_ nibs: [String]) {
        nibs.forEach { (nib) in
            self.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
    }
    
    func registerHeaders(_ nibs: [String]) {
        nibs.forEach { (nib) in
            self.register(UINib(nibName: nib, bundle: nil), forHeaderFooterViewReuseIdentifier: nib)
        }
    }
    
    func getDefaultCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
}


public extension UITableView {
    func registerHeader(headerType: UITableViewHeaderFooterView.Type, bundle: Bundle? = nil) {
        let headerName = headerType.className
        let nib = UINib(nibName: headerName, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: headerName)
    }
    
    func registerHeaders(headerTypes: [UITableViewHeaderFooterView.Type], bundle: Bundle? = nil) {
        headerTypes.forEach { registerHeader(headerType: $0, bundle: bundle) }
    }
    
    func registerCell(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func registerCells(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { registerCell(cellType: $0, bundle: bundle) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

extension UICollectionView {
   func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
       let className = cellType.className
       let nib = UINib(nibName: className, bundle: bundle)
       register(nib, forCellWithReuseIdentifier: className)
   }
    
   func register(cellTypes: [UICollectionViewCell.Type], bundle: Bundle? = nil) {
      cellTypes.forEach { register(cellType: $0, bundle: bundle) }
   }
    
   func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
       return self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
   }
}


protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
