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
import ProgressHUD

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
        ProgressHUD.show()
        firstly {
            interactor.getRouteList()
        }.done { routes in
            routes.forEach { print($0.description) }
        }.ensure {
            ProgressHUD.dismiss()
        }.catch { error in
            ProgressHUD.showError(error.localizedDescription, image: nil, interaction: false)
        }
    }
}

