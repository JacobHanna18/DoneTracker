//
//  ViewController.swift
//  DoneTracker
//
//  Created by Jacob Hanna on 22/12/2020.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, Presenting, ObservableObject, UIDocumentPickerDelegate{
    
    func reload() {
        self.navigationController?.view.tintColor = Lists.selectedList.color
        self.title = Lists.selectedList.name
        content.rootView.selected = Lists.selectedIndex
    }
    
    static var main : ViewController!

    @IBOutlet weak var calenderView: UIView!
    var content : UIHostingController<calenderView>!
    
    var calenderV : calenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.main = self
        if Lists.value.count == 0{
            Lists.newList()
        }
        self.title = Lists.selectedList.name
        self.navigationController?.view.tintColor = Lists.selectedList.color
        calenderV = DoneTracker.calenderView(month: Day().m, year: Day().y, selected: Lists.selectedIndex)
        setContent()
    }
    
    func setContent(){
        content = UIHostingController(rootView: calenderV)
        
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
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        do{
            let file = try String(contentsOf: urls[0], encoding: String.Encoding.utf8)
            Lists.newFrom(json: file)
            FormVC.top?.reload()
        }catch{
        }
        
    }

}

