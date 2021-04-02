
import UIKit
import Lottie

struct Slide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "見たい映画がない時に！映画によるストレス発散は学術的にも証明されています", animationName: "movie", buttonColor: .systemGreen, buttonTitle: "探す"),
        .init(title: "映画の感想は専用のアプリにまとめておくと、時間が経った時に読み返す楽しみが味わえます", animationName: "review", buttonColor: .systemYellow, buttonTitle: "記録する")
    ]
}


class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    
    private let slides: [Slide] = Slide.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = slides.count
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
    }
    
    private func handleAvtionButtonTap(at indexpath: IndexPath) {
        if indexpath.item == slides.count - 1 {
            showMainApp()
        } else {
            showSeachApp()
        }
    }
    
    private func showMainApp() {
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
        if let windoewScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windoewScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = mainAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCurlUp,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func showSeachApp() {
        let searchMovieAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Search")
        if let windoewScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windoewScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = searchMovieAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCurlUp,
                              animations: nil,
                              completion: nil)
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(collectionView.contentOffset.y / scrollView.frame.size.height)
        pageControl.currentPage = index
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension OnboardingViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! OnboardingViewControllerCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide)
        cell.actionButtonDidTap = { [weak self] in
            self!.handleAvtionButtonTap(at: indexPath)
        }
        return cell
    }
}

class OnboardingViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var actionButtonDidTap: (() -> Void)?
    
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        
        let animation = Animation.named(slide.animationName)
        animationView.animation = animation
        animationView.loopMode = .loop
        
        if !animationView.isAnimationPlaying {
            animationView.play(completion: nil)
        }
    }
    
    @IBAction func actionButtonTapped() {
        actionButtonDidTap?()
    }
}

