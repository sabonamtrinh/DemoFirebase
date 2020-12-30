//
//  StorageManager.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//
import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    private let bucket = Storage.storage().reference()
    
    public enum IGStorgeManagerError: Error {
        case failedtoDowload
    }
    
    public func upLoadImage(image: Data, completion: @escaping (Bool) -> Void ) {
        let randomID = UUID.init().uuidString
        bucket.child("image/\(randomID).png").putData(image, metadata: nil) { (_, error) in
            if error != nil {
                completion(false)
            }
            completion(true)
        }
    }
   
    public func downloadImage(with refernce: String, completion:@escaping (Bool,[Data]) -> Void ) {
        var datas = [Data]()
        bucket.child(refernce).getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                completion(false,datas)
                return
            }
            datas.append(data!)
            completion(true,datas)
        })
    }
}

