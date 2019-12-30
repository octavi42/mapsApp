import UIKit

class CardViewController: UIView {
    
    weak var mapNavigationDelegate: MapNavigationDelegate!

    @IBOutlet var navigationBar: UIView!
    @IBOutlet var directionButtonOutlet: UIButton!
    @IBOutlet var directionButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet var directionButtonWidthConstraint: NSLayoutConstraint!
    
    @IBAction func directionButton(_ sender: Any) {
        self.mapNavigationDelegate.didTapDirectionButton1()
    }
    
    @IBAction func swipeNavigationAction(_ sender: Any) {
        
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            }, completion: nil)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CardViewController", owner: self, options: nil)
        addSubview(navigationBar)
        navigationBar.frame = self.bounds
        navigationBar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func justPrint(){
        print("just printing")
    }

}

extension CardViewController: CardNavigationDelegate {
    func viewDidLoadForCardVC() {
        self.justPrint()
    }
}
