
import UIKit

class ViewController: UIViewController {
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
           let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
           return panGestureRecognizer
       }()
    
    private var initialTableViewY: CGFloat = 0
    var maxTableViewY : CGFloat = 0
    var minTableViewY : CGFloat  = 0
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
   private func setupView(){
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialTableViewY = tableView.frame.origin.y
                maxTableViewY = initialTableViewY
                minTableViewY = navBar.frame.origin.y
    }

}


extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension ViewController{
    
    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
           let translation = gestureRecognizer.translation(in: view)
        print(translation.y)
           switch gestureRecognizer.state {
           case .began, .changed:
               let newTableViewY = tableView.frame.origin.y + translation.y
               print(minTableViewY, " - " ,newTableViewY,  " - " ,maxTableViewY)
               
               tableView.frame.origin.y = max(min(newTableViewY, maxTableViewY), minTableViewY)
//               tableView.setNeedsDisplay()
//               tableView.layoutIfNeeded()
               
               if newTableViewY <= minTableViewY {
                   tableView.isScrollEnabled = true
               } else {
                   tableView.isScrollEnabled = false
               }
               
               gestureRecognizer.setTranslation(.zero, in: view)
           case .ended:
               
               // Perform any final adjustments or animations
               break
           default:
               break
           }
       }
    
}
