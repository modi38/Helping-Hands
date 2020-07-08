

import Foundation
import UIKit
import SystemConfiguration
import NVActivityIndicatorView

//MARK:

//MARK:
//MARK: Application related variables

let APP_CONTEXT = UIApplication.shared.delegate as! AppDelegate
//public let APP_NAME: String = Bundle.main.infoDictionary!["CFBundleName"] as! String
public let APP_NAME = "Helping Hands"
public let APP_VERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
public let APP_Bundle_Identifier =  Bundle.main.bundleIdentifier
//let getStoryboard2 = UIStoryboard(name: "MyStoryboardName", bundle: nil)


let helper = HelperFunction()


//Mark: - image name

public let APP_BGIMAGE: String = "img_AppBackgroung"
public let USER_PLACEHOLDER: String = "img_UserPlaceHolder_Home"
let MIN_DISTANCE:Float = 10.0
let MAX_DISTANCE:Float = 500.0

let MIN_AGE:CGFloat = 13
let MAX_AGE:CGFloat = 99
let ALERT_CORNER_RADIUS:CGFloat = 8.0


public func DegreesToRadians(degrees: Float) -> Float {
    return Float(Double(degrees) * Double.pi / 180)
}

//MARK:- Storyboard name
public let storyboardMain :String = "Main"

//MARK: View ID
public let viewLoginVC = "idLoginViewController"
public let viewHomeVC = "idHomeViewController"
public let viewSignupVC = "idSignupViewController"
public let viewImageDisplayerVC = "idImageDisplayerViewController"



//MARK:  Get VC for navigation

public func getStoryboard(storyboardName: String) -> UIStoryboard {
    return UIStoryboard(name: "\(storyboardName)\(isIpad() ? "_iPad" : "")", bundle: nil)
}

public func loadVC(_ strStoryboardId: String, _ strVCId: String) -> UIViewController {
    
    let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
    return vc
}

//MARK: - Check Device is iPad or not

public func isIpad( ) ->Bool{
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return false
    case .pad:
        return true
    case .unspecified:
        return false
        
    default :
        return false
    }
}


//MARK: - iOS version checking Functions

func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedSame
}

func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedDescending
}

func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedAscending
}

func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == ComparisonResult.orderedAscending
}

func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != ComparisonResult.orderedDescending
}


//MARK: - Get full screen size

public func fixedScreenSize() -> CGSize {
    let screenSize = UIScreen.main.bounds.size
    
    if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    return screenSize
}

public func SCREENWIDTH() -> CGFloat
{
    return fixedScreenSize().width
}

public func SCREENHEIGHT() -> CGFloat
{
    return fixedScreenSize().height
}

//MARK: - Network indicator

public func ShowNetworkIndicator(xx :Bool)
{
    UIApplication.shared.isNetworkActivityIndicatorVisible = xx
}


//MARK: - Count enum
func enumCount<T: Hashable>(_: T.Type) -> Int {
    var i = 1
    while (withUnsafePointer(to: &i, {
        return $0.withMemoryRebound(to: T.self, capacity: 1, { return $0.pointee })
    }).hashValue != 0) {
        i += 1
    }
    return i
}


func arrayEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

func enumValues<T>(from array: AnyIterator<T>) -> [T.RawValue] where T: RawRepresentable {
    return array.map { $0.rawValue }
}


//MARK: - Get image from image name

public func Set_Local_Image(_ imageName :String) -> UIImage
{
    return UIImage(named:imageName)!
}




//MARK: - Font

public func THEME_FONT_REGULAR(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue", size: size)!
}

public func THEME_FONT_MEDIUM(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Medium", size: size)!
}

public func THEME_FONT_MEDIUM_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-MediumItalic", size: size)!
}

public func THEME_FONT_LIGHT(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Light", size: size)!
}

public func THEME_FONT_LIGHT_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "Helvetica-LightItalic", size: size)!
}

public func THEME_FONT_BOLD(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: size)!
}

public func THEME_FONT_BOLD_ITALIC(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-BoldItalic", size: size)!
}

//MARK: - SHOW ALERT

func customeSimpleAlertView(title:String, message:String , textAlign : NSTextAlignment = .center)  {
    runOnMainThread {
        let _ = NIPLAlertController.alert(title: title, message: message)
    }
}


func showAlertWithTitleWithMessage(message:String)  {
    runOnMainThread {
        let _ = NIPLAlertController.alert(title: ALERT_NAME, message: message)
    }
}

func showNoInternetMAlert()  {
    runOnMainThread {
        let _ = NIPLAlertController.alert(title: ALERT_NAME, message: "No intermet connection available. Please try again!")
    }
}


public var ALERT_NAME = "Alert"
//MARK: - Color functions

public func COLOR_CUSTOM(_ Red: Float, _ Green: Float , _ Blue: Float, _ Alpha: Float) -> UIColor {
    return  UIColor (red:  CGFloat(Red)/255.0, green: CGFloat(Green)/255.0, blue: CGFloat(Blue)/255.0, alpha: CGFloat(Alpha))
}

public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func randomColor(_ alpha : CGFloat = 1.0) -> UIColor {
    let r: UInt32 = arc4random_uniform(255)
    let g: UInt32 = arc4random_uniform(255)
    let b: UInt32 = arc4random_uniform(255)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}


public let APP_TEXTCOLOR: UIColor = UIColor.white
public let CLEAR_COLOR :UIColor = UIColor.clear


public let APP_THEME_COLOR :UIColor = UIColor(red: 0.12, green: 0.76, blue: 0.76, alpha: 1.00)
public let APP_THEME_COLOR2 :UIColor = UIColor(red: 0.12, green: 0.76, blue: 0.76, alpha: 1.00)//COLOR_CUSTOM(219,33,38,1)
public let APP_GRAYBG_COLOR :UIColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00)


public let APP_PENDING_COLOR :UIColor = UIColor(red: 1.00, green: 0.72, blue: 0.13, alpha: 1.00)
public let APP_ACCEPTED_COLOR :UIColor = UIColor(red: 0.04, green: 0.73, blue: 0.53, alpha: 1.00)
public let APP_ONGOING_COLOR :UIColor = UIColor(red: 0.36, green: 0.47, blue: 1.00, alpha: 1.00)
public let APP_COMPLETED_COLOR :UIColor = UIColor(red: 0.35, green: 0.40, blue: 0.87, alpha: 1.00)
public let APP_CANCELLED_COLOR :UIColor = UIColor(red: 0.99, green: 0.22, blue: 0.48, alpha: 1.00)
public let APP_TIMEOUT_COLOR :UIColor = UIColor(red: 0.16, green: 0.16, blue: 0.24, alpha: 1.00)


public let APP_WHITE_COLOR :UIColor = COLOR_CUSTOM(255,255,255,1)
public let APP_RED_COLOR :UIColor = COLOR_CUSTOM(211, 44, 44,1)
public let APP_BLACK_COLOR :UIColor = COLOR_CUSTOM(52, 42, 61,1)
public let APP_GREY_COLOR :UIColor = COLOR_CUSTOM(130,130,130,1)

//MARK: - APP COMMON IMAGES
let NO_IMAGE = "default-placeholder"
let IMAGE_PLACEHOLDER = "default-placeholder"
let IMAGE_USER_PLACEHOLDER = "default-placeholder"


struct Constants {
    
    enum CurrentDevice : Int {
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    struct MixpanelConstants {
        static let activeScreen = "Active Screen";
    }
    
    struct CrashlyticsConstants {
        static let userType = "User Type";
    }
    
}

//MARK: - Loader
public func createSmallLoaderInView() -> NVActivityIndicatorView {
    let loaderSize : CGFloat = 30.0
    let frame = CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize)
    let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: .ballRotateChase)
    activityIndicatorView.color = APP_BLACK_COLOR
    return activityIndicatorView
}



//MARK: - Mile to Km
//Convert Mile to kilometer

public func mileToKilometer(myDistance : Int) -> Float {
    
    return Float(myDistance) * 1.60934
    
}

//MARK: - Kilometer to Mile
//Convert Kilometer to Mile

public func KilometerToMile(myDistance : Double) -> Double {
    
    return (myDistance) * 0.621371192
    
}

//MARK: - NULL to NIL
//Convert Null Value to nil

public func NULL_TO_NIL(value : AnyObject?) -> AnyObject? {
    
    if value is NSNull {
        return "" as AnyObject
    } else {
        return value
    }
}



//MARK: - Rounded two digit
//Rounded two digit value

extension Double{
    // let x = Double(0.123456789).roundToPlaces(4)  // x becomes 0.1235 under Swift 2
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



//MARK: - Time Ago Function
//Generate time ago string from Spedified date

func timeAgoSinceDateForChat(timestamp : Int, numericDates:Bool = false) -> String
{
    let calendar = NSCalendar.current
    let date = Date(timeIntervalSince1970: Double(timestamp))
    
    if calendar.isDateInYesterday(date){
        return "Yesterday"
    }
    else if calendar.isDateInToday(date) {
        return "Today"
    }
    else {
        return DateFormater.getDateStringFromTimeStamp(timeStamp: timestamp, DATE_FOR_CHAT)!
    }
}

///MARK: - Check Internet connection

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
        
    }) else {
        
        return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
    
}

//MARK: - GET UDID
func getUDID() -> String {
    
    var UDID = ""
    if iskeyAlreadyExist(UD_KEY_UDID){
        UDID = getStringValueFromUserDefaults_ForKey(UD_KEY_UDID)
    }else{
        let theUUID : CFUUID = CFUUIDCreate(nil);
        let string : CFString = CFUUIDCreateString(nil, theUUID);
        UDID =  string as String
        setStringValueToUserDefaults(UDID, UD_KEY_UDID)
    }
    return UDID
}


//MARK: - FONT FUNCTION
public func printFonts(){
    
    // Get all fonts families
    for family in UIFont.familyNames {
        print("\(family)")
        
        // Show all fonts for any given family
        for name in UIFont.fontNames(forFamilyName: family) {
            print("   \(name)")
        }
    }
}


//MARK: - Constant
let totalAboutMeCount = 300

//MARK:
//MARK: KEY_VALUES
let KEY_LOGIN_USER:String = "LoginUser"



//MARK: - Notification Center Key
extension Notification.Name {
    static let NOTI_PUSH = Notification.Name("pushNotification")
    static let NOTI_LOGIN = Notification.Name("LogInNotification")
}

//MARK: - USER_DEFAULTS
let UD_ID_USER_LOGIN:String = "IS user Login"
let UD_LAST_MODIFIED_DATE:String = "lastMOdifiedDate"
let UD_KEY_UDID:String = "UDID String"
let UD_ACCESS_TOKEN:String = "UDID ACCESS TOKEN"
let UD_HISTORY_SEARCH = "UD HISTORY SEARCH"
let UD_HISTORY_LOCATION = "UD HISTORY LOCATION"




