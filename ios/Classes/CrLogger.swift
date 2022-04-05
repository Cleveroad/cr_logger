import Flutter

public class CrLogger : NSObject, FlutterStreamHandler {
    public static var loggerEvents: FlutterEventSink?
    
    private static let logTypeDebug = "d"
    private static let logTypeInfo = "i"
    private static let logTypeError = "e"
    
    private static let jsonStringKey = "jsonString"
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        CrLogger.loggerEvents = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    public static func d(message: Any) {
        DispatchQueue.global().async {
            if(message is KeyValuePairs<String, Any>) {
                loggerEvents?([logTypeDebug, toDictionary(keyValue: message as! KeyValuePairs<String, Any>)])
            } else {
                loggerEvents?([logTypeDebug, message])
            }
        }
    }
    
    public static func i(message: Any) {
        DispatchQueue.global().async {
            if(message is KeyValuePairs<String, Any>) {
                loggerEvents?([logTypeInfo, toDictionary(keyValue: message as! KeyValuePairs<String, Any>)])
            } else {
                loggerEvents?([logTypeInfo, message])
            }
        }
    }
    
    public static func e(message: Any) {
        DispatchQueue.global().async {
            if(message is KeyValuePairs<String, Any>) {
                loggerEvents?([logTypeError, toDictionary(keyValue: message as! KeyValuePairs<String, Any>)])
            } else {
                loggerEvents?([
                    logTypeError, message])
            }
        }
    }
    
    
    private static func toDictionary(keyValue: KeyValuePairs<String, Any>) -> [String: Any] {
        let jsonString = toJsonString(keyValue: keyValue)
        return [jsonStringKey : jsonString]
    }
    
    
    
    private static func toJsonString(keyValue: KeyValuePairs<String, Any>) -> String {
        var json = "{"
        var index = 1
        // We go through all the elements of the dictionary
        keyValue.forEach {
            // We check if we have a dictionary, if so, we bring it to the correct form
            if($1 is KeyValuePairs<String, Any>) {
                json.append(contentsOf: "\"\($0)\": ")
                json.append(contentsOf: toJsonString(keyValue: $1 as! KeyValuePairs<String, Any>))
            } // If we have an array, then we go through all the elements and bring them to the correct form
            else if($1 is Array<Any>) {
                let array = ($1 as! Array<Any>)
                // print the array key
                json.append(contentsOf: "\"\($0)\": [")
                // We go through all the elements of the array and also check them ourselves
                for n in 0..<array.count {
                    if(array[n] is KeyValuePairs<String, Any>) {
                        json.append(contentsOf: toJsonString(keyValue: array[n] as! KeyValuePairs<String, Any>))
                    } else if(array[n] is String) {
                        json.append(contentsOf: "\"\(String(describing: array[n]))\"")
                    } else {
                        json.append(contentsOf: String(describing: array[n]))
                    }
                    // If this is not the last element, then add a comma
                    if(n != array.count - 1) {
                        json.append(contentsOf: ", ")
                    }
                }
                json.append(contentsOf: "]")
            } // If we have a regular field, then we just fill it in the key: value
            else {
                if($1 is String) {
                    json.append(contentsOf: "\"\($0)\": \"\(String(describing: $1))\"")
                } else {
                    json.append(contentsOf: "\"\($0)\": \(String(describing: $1))")
                }
                
            }
            // If this is not the last element, then add a comma
            if(index != keyValue.count) {
                json.append(contentsOf: ", ")
            }
            index += 1
        }
        json.append(contentsOf: "}")
        
        return json
    }
}
