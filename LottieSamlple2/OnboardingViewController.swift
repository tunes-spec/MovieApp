//
//  ViewController.swift
//  LottieSamlple2
//
//  Created by TSUNE on 2021/03/21.
//

import UIKit

struct Slide {
    let title: String
    let animationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "観た映画を記録しよう！", animationName: "", buttonColor: .systemGreen, buttonTitle: "Next"),
        .init(title: "映画を探そう！", animationName: "", buttonColor: .systemYellow, buttonTitle: "Next")
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
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
    }
}


extension OnboardingViewController:UICollectionViewDelegateFlowLayout{
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! OnboardingViewControllerCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide)
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

class OnboardingViewControllerCell: UICollectionViewCell {
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func actionButtonTapped() {
    }
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
    }
}


