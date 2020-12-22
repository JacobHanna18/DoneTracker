//
//  ViewController.swift
//  DoneTracker
//
//  Created by Jacob Hanna on 22/12/2020.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, Presenting{
    
    func reload() {
        print(Lists.selectedIndex)
        content.rootView.month = content.rootView.month
    }

    @IBOutlet weak var calenderView: UIView!
    var content : UIHostingController<calenderView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Lists.value.count == 0{
            Lists.newList()
        }
        setContent()

    }
    
    func setContent(){
        content = UIHostingController(rootView: DoneTracker.calenderView(month: Day().m, year: Day().y))
        
        content.view.backgroundColor = UIColor.clear
        addChild(content)
        content.view.frame = calenderView.frame
        calenderView.addSubview(content.view)
        content.didMove(toParent: self)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.topAnchor.constraint(equalTo: calenderView.topAnchor).isActive = true
        content.view.bottomAnchor.constraint(equalTo: calenderView.bottomAnchor).isActive = true
        content.view.leftAnchor.constraint(equalTo: calenderView.leftAnchor).isActive = true
        content.view.rightAnchor.constraint(equalTo: calenderView.rightAnchor).isActive = true
    }
    
    @IBAction func selectMenu(_ sender: Any) {
        self.showForm({Lists.props})
    }

}

