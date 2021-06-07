//
//  ViewController.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 4/6/2021.
//

import UIKit
import Alamofire
import PromiseKit
import Moya
class ViewController: UIViewController {
    
    let interactor: ViewControllerInteractorProtocol
    
    init(interactor: ViewControllerInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        interactor.getRouteList()
            .done { list in
                list.forEach { print($0.description) }
            }
            .catch { error in
                print(error)
            }
    }
}

