//
//  ViewController+TableView.swift
//  DFAXUIElementExample
//
//  Created by raymond on 2021/1/17.
//

import Foundation
import Cocoa

extension ViewController : NSTableViewDataSource, NSTableViewDelegate{
    fileprivate enum CellIdentifiers : String {
        case PIDCell = "PIDCellID"
        case NameCell = "NameIconCellID"
        case BundleCell = "BundleCellID"
        case SelectCell = "CheckBoxCellID"
        
        case WinIdCell = "WinIDCellID"
        case WinTitleCell = "TitleCellID"
        case WinIsFocusCell = "FocuseCellID"
        case WinIsMainCell = "MainCellID"
        case WinSelectCell = "WindowSelectCellID"
        
        case AttributeNameCell = "AttributeNameCellID"
        case ValueCell = "ValueCellID"
        case SettableCell = "SettableCellID"
        
        case ActionNameCell = "ActionNameCellID"
        case ActionCell = "ActionCellID"
        
        case AppAttributeNameCell = "AppAttributeNameCellID"
        case AppAttributeValueCell = "AppAttributeValueCellID"
        case AppIsSettableCell = "AppIsSettableCellID"
        
        
     }
    
    fileprivate enum ColumnIdentifiers : String {
        case PIDColumn = "PIDColumnID"
        case NameColumn = "NameColumnID"
        case BundleColumn = "BundleColumnID"
        case SelectColumn = "SelectColumnID"
     }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if appTblView == tableView{
            
            return self.appList.count
            
        }else if windowTblView == tableView{
            
            return self.windowList.count
            
        }else if windowAttributeTblView == tableView{
            
            return self.windowAttributeNameList.count
            
        }else if windowActionTblView == tableView{
            
            return self.windowActionList.count
            
        }else if AppAttributeNameTblVIew == tableView{
            
            return self.appAttributeNameList.count
            
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableView == appTblView{
            
            return self.appList[row]
            
        }else if tableView == windowTblView{
            
            return self.windowList[row]
            
        }else if tableView == windowAttributeTblView{
            
            return self.windowAttributeNameList[row]
            
        }else if tableView == windowActionTblView{
            
            return self.windowActionList[row]
            
        }else if tableView == AppAttributeNameTblVIew{
            
            return self.appAttributeNameList[row]
            
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableView == self.appTblView{
            return getCellOfApplicationTableView(tableColumn: tableColumn, row: row)
        }
        if tableView == self.windowTblView{
            return getCellOfWindowTableView(tableColumn: tableColumn, row: row)
        }
        if tableView == self.windowAttributeTblView{
            return getCellOfAttributeTblView(tableColumn: tableColumn, row: row)
        }
        if tableView == self.windowActionTblView{
            return getCellOfActionTblView(tableColumn: tableColumn, row: row)
        }
        if tableView == self.AppAttributeNameTblVIew{
            return getCellOfAppAttributeTblView(tableColumn: tableColumn, row: row)
        }
        return nil
    }
    
    
    func getCellOfApplicationTableView(tableColumn:NSTableColumn?, row:Int) -> NSView? {
        let app = self.appList[row]
        var cellIdentifier : String?
        var image: NSImage?
        var text: String = ""
        var isCheck = false
        
        if tableColumn?.identifier.rawValue == ColumnIdentifiers.PIDColumn.rawValue{
            text = String(app.processIdentifier)
            cellIdentifier = CellIdentifiers.PIDCell.rawValue
            
        }else if tableColumn?.identifier.rawValue == ColumnIdentifiers.NameColumn.rawValue{
            text = app.localizedName ?? ""
            image = app.icon
            cellIdentifier = CellIdentifiers.NameCell.rawValue
            
        }else if tableColumn?.identifier.rawValue == ColumnIdentifiers.SelectColumn.rawValue{
            
            isCheck = false
            if appRef.pid() == app.processIdentifier{
                isCheck = true
            }
            cellIdentifier = CellIdentifiers.SelectCell.rawValue
        }else if tableColumn?.identifier.rawValue == ColumnIdentifiers.BundleColumn.rawValue{
            cellIdentifier = CellIdentifiers.BundleCell.rawValue
            text = app.bundleIdentifier ?? "undefined"
            
        }else{
            
            cellIdentifier = nil
            return nil
        }
        
        guard cellIdentifier != nil else {
            return nil
        }
        
        if let cell = self.appTblView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier!), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image
            
            
            for sub in cell.subviews {
                if sub is NSButton && sub.identifier?.rawValue == "CheckBoxID"{
                    let checkBox = sub as! NSButton
                    checkBox.tag = row
                    checkBox.state = .off
                    if isCheck{
                        checkBox.state = .on
                    }
                }
            }
            return cell
        }
        return nil
    }
    
    
    func getCellOfWindowTableView(tableColumn:NSTableColumn?, row:Int) -> NSView? {
        let window = windowList[row]
        var cellIdentifier : String?
        var text: String = ""
        var isCheck = false
        
        if self.windowTblView.tableColumns[0] == tableColumn{
            
            cellIdentifier = CellIdentifiers.WinIdCell.rawValue
            text = String(window.windowID())
            
        }else if self.windowTblView.tableColumns[1] == tableColumn{
            
            cellIdentifier = CellIdentifiers.WinTitleCell.rawValue
            text = window.title() ?? "undefined"
            
        }else if self.windowTblView.tableColumns[2] == tableColumn{
            cellIdentifier = CellIdentifiers.WinIsFocusCell.rawValue
            
            
            if window == appRef.focusedWindow(){
                text = "true"
            }else{
                text = "false"
            }
           
        }else if self.windowTblView.tableColumns[3] == tableColumn{
            cellIdentifier = CellIdentifiers.WinIsMainCell.rawValue
            if let isMain = window.isMain(){
                text = String(isMain)
            }else{
                text = "undefined"
            }
        }else if self.windowTblView.tableColumns[4] === tableColumn{
            cellIdentifier = CellIdentifiers.WinSelectCell.rawValue
            if windowRef == window{
                isCheck = true
            }else{
                isCheck = false
            }
            
        }else{
            
            cellIdentifier = nil
            return nil
        }
        
        
        guard cellIdentifier != nil else {
            return nil
        }
        
        if let cell = self.windowTblView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier!), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            
            for sub in cell.subviews {
                if sub is NSButton && sub.identifier?.rawValue == "WindowCheckBoxID"{
                    let checkBox = sub as! NSButton
                    checkBox.tag = row
                    checkBox.state = .off
                    if isCheck{
                        checkBox.state = .on
                    }
                }
            }
            return cell
        }
        return nil
    }
    
    
    func getCellOfAttributeTblView(tableColumn:NSTableColumn?, row:Int) -> NSView? {
        let key = self.windowAttributeNameList[row]
        var cellIdentifier : String?
        var text: String = ""
        if self.windowAttributeTblView.tableColumns[0] == tableColumn{
            cellIdentifier = CellIdentifiers.AttributeNameCell.rawValue
            text = key
        }else if self .windowAttributeTblView.tableColumns[1] == tableColumn{
            cellIdentifier = CellIdentifiers.ValueCell.rawValue
            text = String(describing: windowRef?.value(attributeKey: key))
        }else if self .windowAttributeTblView.tableColumns[2] == tableColumn{
            cellIdentifier = CellIdentifiers.SettableCell.rawValue
            if let isSettable = windowRef?.isAttributeSettable(attributeKey: key){
                text = String(isSettable)
            }else{
                text = "undefined"
            }
            
        }
        else{
            return nil
        }
        
        guard cellIdentifier != nil else {
            return nil
        }
        if let cell = self.windowAttributeTblView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier!), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
    
    func getCellOfActionTblView(tableColumn:NSTableColumn?, row:Int) -> NSView? {
        let key = self.windowActionList[row]
        var cellIdentifier : String?
        var text: String = ""
        
        if self.windowActionTblView.tableColumns[0] == tableColumn{
            cellIdentifier = CellIdentifiers.ActionNameCell.rawValue
            text = key
        }else if self .windowActionTblView.tableColumns[1] == tableColumn{
            cellIdentifier = CellIdentifiers.ActionCell.rawValue
            
            
        }else{
            return nil
        }
        
        guard cellIdentifier != nil else {
            return nil
        }
        if let cell = self.windowActionTblView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier!), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            
            for sub in cell.subviews {
                if sub is NSButton{
                    let btn = sub as! NSButton
                    btn.identifier = NSUserInterfaceItemIdentifier(rawValue: key)
                }
            }
            
            return cell
        }
        
        return nil
    }
    
    
    func getCellOfAppAttributeTblView(tableColumn:NSTableColumn?, row:Int) -> NSView? {
        
        let key = self.appAttributeNameList[row]
        var cellIdentifier : String?
        var text: String = ""
        if self.AppAttributeNameTblVIew.tableColumns[0] == tableColumn{
            
            cellIdentifier = CellIdentifiers.AppAttributeNameCell.rawValue
            text = key
            
        }else if self.AppAttributeNameTblVIew.tableColumns[1] == tableColumn{
            
            cellIdentifier = CellIdentifiers.AppAttributeValueCell.rawValue
            text = String(describing: appRef.value(attributeKey: key))
            
        }else if self.AppAttributeNameTblVIew.tableColumns[2] == tableColumn{
            
            cellIdentifier = CellIdentifiers.AppIsSettableCell.rawValue
            let isSettable = appRef.isAttributeSettable(attributeKey: key)
            text = String(isSettable)
            
        }
        else{
            return nil
        }
        
        guard cellIdentifier != nil else {
            return nil
        }
        if let cell = self.AppAttributeNameTblVIew.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(cellIdentifier!), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}
