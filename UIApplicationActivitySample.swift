class MainViewController : UIViewController  {
    
    //========================================
    // MARK:- Properties
    //========================================
    @IBOutlet var mainTableView: UITableView!
    
    //========================================
    // MARK:- UIViewController
    //========================================
    override func viewDidLoad() {
        
        NSLog("")
        super.viewDidLoad()

        if self.profile.isLoggedIn == false  {
            self.performSegueWithIdentifier("MainToLoginSegue", sender:self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        NSLog("")
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(foregroundEntered), name: UIApplicationWillEnterForegroundNotification,  object: nil)
        nc.addObserver(self, selector: #selector(backgroundEntered), name: UIApplicationDidEnterBackgroundNotification,   object: nil)

        self.becomeActive()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSLog("")
        super.viewWillDisappear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        nc.removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func foregroundEntered () {
        
        NSLog("+++++++++++++++++++++++++++++++++++ BECOME ACTIVE +++++++++++++++++++++++++++++++++++")
        self.becomeActive()
    }
    
    func backgroundEntered () {
        
        NSLog("+++++++++++++++++++++++++++++++++++ BECOME INACTIVE +++++++++++++++++++++++++++++++++++")
        // close dialogs, etc
    }

    //========================================
    // MARK:- Activate
    //========================================
    override func becomeActive() {
        NSLog("")
        self.loadLatest()
    }
    
    override func becomeInactive () {
        NSLog("")
        super.becomeInactive()
    }
    
    func loadLatest() {
        
        NSLog("")
        if self.isLoading == true {
           NSLog("### ### IGNORING ### ###")
           return
        }
        self.isLoading = true        

        self.loadingIndicator.hidden = false
        STRequestController.sharedInstance.requestSitesAll { (result, response) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingIndicator.hidden = true
                self.mainTableView.reloadData()
            }
        }

    }