//
//  LoginViewController.swift
//  App
//
//  Created by iOS on 24/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import GoogleSignIn
import DropDown

class LoginViewController: BaseVC,GIDSignInDelegate {
    
    @IBOutlet weak var buttonUserType: UIButton!
    @IBOutlet weak var imageViewRemember: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    var isRememeber = false
    @IBOutlet weak var buttonLogin: UIButton!
    let userTypeArray = ["Job Provider","Job Seeker"]//["Admin","Job Provider","Job Seeker"]
    var selectedType = ""
    
    let chooseEmp = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        APP_CONTEXT.appRootController = self.navigationController!
        self.navigationController?.setNavigationBarHidden (true, animated: false)
        self.buttonLogin.backgroundColor = APP_THEME_COLOR
        self.buttonLogin.setCornerRadius(radius: 5.0)
        
        //        self.textFieldEmail.text = "admin"
        //        self.textFieldPassword.text = "admin"
        HelperFunction.helper.storeInUserDefaultForKey(name: "GoogleSignInOptionSelected", val: "NO")
        setupChooseEmpDropDown()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: false)
        buttonUserType.setTitle("Select User Type", for: .normal)
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if self.selectedType == ""{
            runOnAfterTime(afterTime: 1.5) {
                showAlertWithTitleWithMessage(message: "Please select user type")
                return
            }
            
        }
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        HelperFunction.helper.storeInUserDefaultForKey(name: "GoogleSignInOptionSelected", val: "YES")
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        self.registerUser(firstName: givenName ?? "", lastName: familyName ?? "", email: email ?? "")
        // ...
    }
    
    //this method is used for the register user and save data to Realm
    func registerUser(firstName:String,lastName:String,email:String){
        let user = RObjUser()
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.password = "No Need"
        user.type = self.selectedType
        // user.gender = self.selectedGender
        user.mobileNum = Int("000000")!
        let realm = try! Realm()
        let arrayData = realm.objects(RObjUser.self).filter("email == %d && type == %d",email,self.selectedType)
        if arrayData.count>0{
            let name = String("\(user.firstName!) \(user.firstName!)")
            HelperFunction.helper.storeInUserDefaultForKey(name: "username", val: name)
            
            
            if self.selectedType == "Job Provider"{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompanyHomeViewController") as? CompanyHomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if self.selectedType == "Job Seeker"{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if self.selectedType == "Admin"{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                //do nothing...
            }
            
            return
        }else{
            runOnAfterTime(afterTime: 1.0) {
                DBManager.sharedInstance.addObject(object: user)
                //customeSimpleAlertView(title: "Registered!", message: "Congratulations! You are successfully registered")\
                
                let name = String("\(user.firstName!) \(user.firstName!)")
                HelperFunction.helper.storeInUserDefaultForKey(name: "username", val: name)
                
                if self.selectedType == "Job Provider"{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompanyHomeViewController") as? CompanyHomeViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else if self.selectedType == "Job Seeker"{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else if self.selectedType == "Admin"{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    //do nothing...
                }
                return
                //Reset all controls after user registeration
                
                
            }
            
        }
        
    }
    func setupChooseEmpDropDown() {
        
        chooseEmp.anchorView = self.buttonUserType
        chooseEmp.bottomOffset = CGPoint(x: 0, y: 0)
        chooseEmp.dataSource = userTypeArray
        chooseEmp.selectionAction = { [weak self] (index, item) in
            self!.selectedType = item
            self!.buttonUserType.setTitle(item, for: .normal)
            self!.chooseEmp.hide()
        }
        
    }
    //MARK: - Button action
    
    @IBAction func buttonSelectUserType(_ sender: Any) {
        chooseEmp.show()
    }
    @IBAction func next(_ sender: Any) {
        //        let homeVC = loadVC(storyboardMain, viewHomeVC) as! HomeViewController
        //        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    //MARK: - button action
    
    @IBAction func buttonHandlerRememberMe(_ sender: Any) {
        if self.isRememeber{
            self.imageViewRemember.image = UIImage(named: "uncheck")
            HelperFunction.helper.storeInUserDefaultForKey(name: "isRemember", val: "uncheck")
        }else{
            self.imageViewRemember.image = UIImage(named: "check")
            HelperFunction.helper.storeInUserDefaultForKey(name: "isRemember", val: "check")
        }
        self.isRememeber = !self.isRememeber
        
        
    }
    @IBAction func buttonHandlerSignup(_ sender: Any) {
        let signupVC = loadVC(storyboardMain, viewSignupVC) as! SignupViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
        
        //        let signupVC = loadVC(storyboardMain, "DeliveryViewController") as! DeliveryViewController
        //        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func buttonHandlerLogin(_ sender: Any) {
        HelperFunction.helper.storeInUserDefaultForKey(name: "GoogleSignInOptionSelected", val: "NO")
        if self.textFieldEmail.text == "admin" && self.textFieldPassword.text == "admin"{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompanyHomeViewController") as? CompanyHomeViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            return
            
        }
        if self.textFieldEmail.text == "" || self.textFieldPassword.text == "" || self.selectedType == ""{
            showAlertWithTitleWithMessage(message: "All fields are required")
        }else{
            
            if  HelperFunction.helper.isValidEmail(testStr: self.textFieldEmail.text!){
                if HelperFunction.helper.isPasswordValid(self.textFieldPassword.text!){
                    let realm = try! Realm()
                    let arrayUsers = realm.objects(RObjUser.self).filter("email == %d",self.textFieldEmail.text!)
                    if arrayUsers.count>0{
                        let user:RObjUser = arrayUsers[0]
                        if user.password == self.textFieldPassword.text!{
                            HelperFunction.helper.storeInUserDefaultForKey(name: "email", val: self.textFieldEmail.text!)
                            let name = String("\(user.firstName!) \(user.firstName!)")
                            HelperFunction.helper.storeInUserDefaultForKey(name: "username", val: name)
                            
                            if selectedType != user.type{
                                showAlertWithTitleWithMessage(message: "Please select appropriate user type")
                                return
                            }
                            
                            if user.type == "Job Provider"{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompanyHomeViewController") as? CompanyHomeViewController
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }else if user.type == "Job Seeker"{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }else if user.type == "Admin"{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobSeekerHomeViewController") as? JobSeekerHomeViewController
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }else{
                                //do nothing...
                            }
                            
                            
                        }else{
                            showAlertWithTitleWithMessage(message: "Wrong email or password!Please enter valid email id and password.")
                        }
                    }else{
                        showAlertWithTitleWithMessage(message: "User doesn't exists!.Please enter valid email id and password")
                    }
                }else{
                    showAlertWithTitleWithMessage(message: "Password should contain one special character and minimum 8 characters required")
                }
                
                
            }else{
                showAlertWithTitleWithMessage(message: "Email is not valid")
            }
            
        }
        
    }
    
}
