//
//  MultiPart.swift
//

class MultiPart: NSObject {

    let session = URLSession(configuration: URLSessionConfiguration.default)

    func callPostWebService<T : Decodable>(_ url_String: String, parameters: [String: Any]?, filePathArr arrFilePath: [[String:Any]]?, model : T.Type, isLoader : Bool = true, isAPIToken : Bool = false, method : String = "POST", completion: @escaping (_ success: Bool, _ object: AnyObject?)->()) {
        
        if isLoader {
            Utility().showLoader()
        }
        
        let boundary = generateBoundaryString()
        
        let request = NSMutableURLRequest(url: URL(string: url_String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = method
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let httpBody: Data? = createBody(withBoundary: boundary, parameters: parameters, paths: arrFilePath)
        
        request.setValue("\(httpBody!.count)", forHTTPHeaderField:"Content-Length")
        
        let task = session.uploadTask(with: request as URLRequest, from: httpBody, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            
            if isLoader {
                Utility().hideLoader()
            }
            
            if error != nil {
                
                if Environment.Val.appID == 0 {
                    print("error = \(error ?? 0 as! Error)")
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    completion( false , error as AnyObject)
                })
                
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                        mainThread {
                            completion(false, AlertMessage.msgUnauthorized as AnyObject)
                        }
                    } else {

                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, Environment.Val.appID == 0 {
                            print(convertedJsonIntoDict)
                        }

                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let dictResponse = try decoder.decode(model, from: data)
                            mainThread {
                                completion(true, dictResponse as AnyObject)
                            }
                        } else {
                            let dictResponse = try decoder.decode(GeneralResponseModel.self, from: data)
                            mainThread {
                                completion(false, dictResponse.message as AnyObject)
                            }
                        }
                    }
                } catch let error as NSError {
                    
                    if Environment.Val.appID == 0 {
                        print("\n\n===========Error===========")
                        print("Error Code: \(error._code)")
                        print("Error Messsage: \(error.localizedDescription)")
                        if let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Print Server data:- " + str)
                        }
                        debugPrint(error)
                        print("===========================\n\n")
                        
                        debugPrint(error)
                    }
                    
                    completion(false, error as AnyObject)
                }
            }
        })
        
        task.resume()
    }
    
    func createBody(withBoundary boundary: String, parameters: [String: Any]?, paths: [[String:Any]]?) -> Data {
        
        var httpBody = Data()
        
        if let parameters = parameters {
            for (parameterKey, parameterValue) in parameters {
                httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("Content-Disposition: form-data; name=\"\(parameterKey)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                httpBody.append("\(parameterValue)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        if let paths = paths {
            
            for pathDic in paths {
                for path: String in pathDic[multiPartPathURLs] as! [String] {
                    let filename: String = URL(fileURLWithPath: path).lastPathComponent
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path))
                        
                        let mimetype: String = mimeType(forPath: path)
                        httpBody.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Disposition: form-data; name=\"\(pathDic[multiPartFieldName] ?? "")\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                        httpBody.append(data)
                        httpBody.append("\r\n".data(using: String.Encoding.utf8)!)
                    } catch {
                        if Environment.Val.appID == 0 {
                            print("Unable to load data: \(error)")
                        }
                    }
                }
            }
        }
        
        httpBody.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return httpBody
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func mimeType(forPath path: String) -> String {
        
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        
        return "application/octet-stream"
    }
}
