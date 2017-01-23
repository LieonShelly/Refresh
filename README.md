# Quick Start

    override func viewDidLoad() {
        super.viewDidLoad()
        let refresh = LRefreshControl()
        tableView.addSubview(refresh)
        refresh.refreshHandler = {
          /** insert your refresh action here **/
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
         /** Do not forget call endRefreshing when loading end **/
            self.refresh.endRefreshing()
          }
        }
    }
  
# Environment
  Xcode 8 / Swift 3

# Installation
   pod 'LRefresh'
