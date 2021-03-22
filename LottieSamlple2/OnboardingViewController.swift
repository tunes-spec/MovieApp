//
//  ViewController.swift
//  LottieSamlple2
//
//  Created by TSUNE on 2021/03/21.
//

import UIKit
import Lottie

struct Slide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "映画の感想は専用のアプリにまとめておくと、時間が経った時に読み返す楽しみが味わえます", animationName: "review", buttonColor: .systemGreen, buttonTitle: "記録する"),
        .init(title: "見たい映画がない時に！映画によるストレス発散は学術的にも証明されています", animationName: "movie", buttonColor: .systemYellow, buttonTitle: "探す")
    ]
}


class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    private let slides: [Slide] = Slide.collection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
            let nextIndex = indexpath.item + 1
            let nextIndexPath = IndexPath(item: nextIndex , section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
        }
    }
    
    private func showMainApp() {
        let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MianApp")
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

