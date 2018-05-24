struct Model<T: Decodable>: Decodable {
    let isError: Bool
    let message: String?
    let data:T?
    enum  CodingKeys:String, CodingKey{
        case isError,message,data
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isError = (try? values.decode(Bool.self, forKey: .isError)) ?? true
        message = try? values.decode(String.self, forKey: .message)
        data = try? values.decode(T.self, forKey: .data)
    }
}
//==================================
enum Response<T:Codable> {
    case errorResponse(error:String?)
    case success(data:Data,model:T?)
    case failure(error:String,message:String)
}

enum HTTPMethods:String{
    case get = "GET"
    case post = "POST"
}

class DataRequest {
    
    static func request<T:Codable>(_: T.Type,url:String,
                                   method:HTTPMethods = .get,
                                   param:[String:Any]? = nil,
                                   completion:@escaping (Response<T>)->Void){
        
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let param = param{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error: "param error", message: error.localizedDescription))
                }
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let mError = error{
                let msg:String = {
                    if let err = mError as? URLError,
                        err.code == .notConnectedToInternet {
                        return "Const.networkError"
                    } else {
                        return "Const.wentWrong"
                    }
                }()
                DispatchQueue.main.async {
                    completion(.failure(error: mError.localizedDescription, message: msg))
                }
                
            }else if let mData = data{
                DispatchQueue.main.async {
                    do{
                        let info = try JSONDecoder().decode(Model<T>.self, from: mData)
                        if info.isError{
                            completion(Response.errorResponse(error: info.message))
                        }else{
                            completion(Response.success(data: mData, model: info.data))
                        }
                        
                    }catch(let error){
                        completion(.failure(error: error.localizedDescription, message: "Const.wentWrong"))
                    }
                    
                }
                
            }
        }
        task.resume()
    }
    
}

//=================
 private func getCategories(){     
        DataRequest.request([CategoryInfo].self, url: URLs.categories,
                            method:HTTPMethods.post,
                            param:nil)
        { (response) in
            switch response{
            case .errorResponse(let error):
                print("ErrorResponse - ",error ?? "Nil")
                break
            case .success(_,let model):
                dump(model)
                if let array = model{
                    self.categoriesVC.categories = array
                }
                break
            case .failure(let error, let message):
                print("Failure - ",error,message)
                break
            }
        }
    }
