//
//  PGDataManager.swift
//  NEIPG
//
//  Created by Gourav Sharma on 11/22/16.
//  Copyright © 2016 Yaogeng Cheng. All rights reserved.
//

import UIKit


@objc class PGDataManager: NSObject {
    
    static var db: OpaquePointer? = nil
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    
   class func openDatabase() -> Bool {
        
        do {
            let manager = FileManager.default
            
            let documentsURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("NEIPG.sqlite")
            
            var rc = sqlite3_open_v2(documentsURL.path, &db, SQLITE_OPEN_READWRITE, nil)
            if rc == SQLITE_CANTOPEN {
                
                let bundleURL = Bundle.main.url(forResource: "NEIPG", withExtension: "sqlite")!
                try manager.copyItem(at: bundleURL, to: documentsURL)
                rc = sqlite3_open_v2(documentsURL.path, &db, SQLITE_OPEN_READWRITE, nil)
            }
            
            if rc != SQLITE_OK {
                return false
            }
            
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    class func getPresciribeList(_ drugName: String) -> [PGCheckList]
    {
        //initalize wine array with model object
        var wineArray = [PGCheckList]()
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='")\(drugName)\("'")"
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
        //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                //create a model object
                let item = PGCheckList()
                //WineList *MyWine = [[WineList alloc]init];
                let pId = sqlite3_column_int(statement, 0)
                
                if let pDescr = sqlite3_column_text(statement, 1) {
                    
                    item.itemId = Int(pId)
                    item.itemName =  String(cString: pDescr)
                    item.drugName = drugName
                    wineArray.append(item)
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil

            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and wine array
        return wineArray;
    }
    
    
    class func getDrugList() -> [String] {
        
        var drugListArray = [String]()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "SELECT * FROM Drugs order by DrugName COLLATE NOCASE"
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let pDescr = sqlite3_column_text(statement, 1) {
                    
                    drugListArray.append(String(cString: pDescr))
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and drugListArray
        return drugListArray;
    }
    
    class func getDrugUseList() -> [String] {
        
        var drugListArray = [String]()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "SELECT distinct Use FROM DrugUse order by Use COLLATE NOCASE"
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let pDescr = sqlite3_column_text(statement, 0) {
                    
                    drugListArray.append(String(cString: pDescr))
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and drugListArray
        return drugListArray;
    }
    
    class func getDrugNameList(byIndication indication: String) -> [String] {
        
        var drugNameListArray = [String]()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT distinct GenericName FROM DrugUse where Use='")\(indication)\("' order by GenericName")"
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let pDescr = sqlite3_column_text(statement, 0) {
                    
                    drugNameListArray.append(String(cString: pDescr))
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and drugListArray
        return drugNameListArray ;
    }
    
    class func getContent(_ drugName: String) -> String {
        //return @"Problem with prepare statement";
        //NSMutableString* theString = [NSMutableString string];
        var theString = ""
        theString = theString.appendingFormat("%@", "<link rel='stylesheet' type='text/css' href='styles.css'>")
        
        //open database
        if PGDataManager.openDatabase()
        {
             
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT dch.DrugContentHeaderID, dch.HeaderHtml, dc.TextHTML FROM DrugContent dc, DrugContentHeader dch where dc.DrugContentHeaderID=dch.DrugContentHeaderID and GenericName=")'\(drugName)' order by dch.DrugContentHeaderID"
        
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            var str = ""
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let pId = sqlite3_column_int(statement, 0)
                let pCode = sqlite3_column_text(statement, 1)
                let pDescr = sqlite3_column_text(statement, 2)
                str = "\("<A name='")\(Int(pId))\("'></A>")\(String(cString: pCode!))\(String(cString: pDescr!))"
                theString = theString.appendingFormat("%@", str)
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
           
        }
        theString = theString.appendingFormat("%@", "<table width='100%' border='0'><tr><td align='right'><A href='#top'>Back to Top</A></td></tr></table><p>&nbsp;</p>")
        return theString
    }
    
    class func getGenericDrugName(_ drugName: String) -> String
    {
        var pDescr = ""
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT GenericName FROM drugs where DrugName='")\(drugName)\("'")"
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let desc = sqlite3_column_text(statement, 0) {
                    
                    pDescr =  String(cString: desc)
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and wine array
        return pDescr
    }
    
    
    class func getConsiderationKeys(_ drugName: String) -> [String : Array<String>]
    {
        //var dict = [String: [String]]()
        
        var dict = Dictionary<String, Array<String>>()
       
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT distinct c.* FROM DrugConsiderations dc, Category c where dc.CategoryCode=c.CategoryCode and dc.CategoryCode<>'PRESCRIBE' and dc.GenericName='")\(drugName)\("'")"
            

            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                var wineArray = [String]()
                
                if let pDescr = sqlite3_column_text(statement, 2) {
                    
                    wineArray.append(String(cString: pDescr))
                }
                
                if let pImageName = sqlite3_column_text(statement, 3) {
                    
                    wineArray.append(String(cString: pImageName))
                }
                
                if let pCode = sqlite3_column_text(statement, 1) {
                    
                   dict[String(cString: pCode)] = wineArray
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        //return and wine array
        return dict
    }
    
    class func getContentHeader() -> [String: AnyObject] {
       
        
        var keyArray = [Int]()
        var valueArray = [String]()
        var dict = Dictionary<String, Array<AnyObject>>()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "SELECT  * FROM DrugContentHeader"
            
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                
                let pId = sqlite3_column_int(statement, 0)
                keyArray.append(Int(pId))
               
                if let pDescr = sqlite3_column_text(statement, 1) {
                    
                     valueArray.append( String(cString: pDescr))
                }
               
                dict["key"] = keyArray as [AnyObject]
                dict["value"] = valueArray as [AnyObject]
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        
        return dict as [String : AnyObject]
    }

    class func getConsiderationList(_ drugName: String) -> [String:  Array<PGCheckList>] {
        
        
        var dict = Dictionary<String, Array<PGCheckList>>()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
            let sqlQuery = "\("SELECT c.*, dc.RankID FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsId=c.ConsiderationsId and dc.CategoryCode<>'PRESCRIBE' and dc.GenericName='")\(drugName)\("'")"
            
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
                
                //create a model object
                let item = PGCheckList()
                item.checked = false;
                var wineArray = [PGCheckList]()
                
                let pId = sqlite3_column_int(statement, 0)
                item.itemId = Int(pId)
            
                if let pDescr = sqlite3_column_text(statement, 2) {
                    
                    item.itemName =  String(cString: pDescr)
                }
                
                 let rId = sqlite3_column_int(statement, 3)
                
                 item.rankId = Int(rId);
                
                let pCode = sqlite3_column_text(statement, 1)
                
                if  (dict[String(cString: pCode!)] != nil)
                {
                    dict[String(cString: pCode!)]?.append(item)
                }
                else
                {
                     wineArray.append(item)
                     dict[String(cString: pCode!)] = wineArray
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        
        return dict 
    }
    
    
    class func getAlternateDrugList(_ sqlQuery: String) -> [String] {
        
        var wineArray = [String]()
        
        //open database
        if PGDataManager.openDatabase()
        {
            var statement: OpaquePointer? = nil
        
            if sqlite3_prepare_v2(db, sqlQuery, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing insert: \(errmsg)")
            }
            
            //if find data statement
            while sqlite3_step(statement) == SQLITE_ROW {
                
            if let pDescr = sqlite3_column_text(statement, 0) {
                    
                    wineArray.append( String(cString: pDescr))
                }
            }
            
            //finalize statement
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            //close database
            if sqlite3_close(db) != SQLITE_OK {
                print("error closing database")
            }
            
            db = nil
        }
        
        return wineArray
    }

}
