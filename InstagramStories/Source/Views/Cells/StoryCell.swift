//
//  StoryCell.swift
//  InstagramStories
//
//  Created by Борис on 18.12.2021.
//

import UIKit

protocol StoryCellImageDelegate {
    func fetchImage(stringURL: String, completion: @escaping (Result<UIImage,Error>)->())
}

final class StoryCell: UICollectionViewCell {
    
    //MARK: - Public properties
    var imageDelegate: StoryCellImageDelegate?
    
    //MARK: - Private properties
    private var activityIndicator: CustomActivityIndicator = {
        $0.type = .defaultActivityIndicator(.medium)
        $0.show()
        return $0
    }(CustomActivityIndicator())
    
    private let timeViewContainer: UIView = {
        Utils.addShadow(type: .shadowIsBelow, layer: $0.layer) // check this
        return $0
    }(UIView())
    
    private let timeView: UIView = {
        $0.backgroundColor = Palette.white.color
        return $0
    }(UIView())
    
    private let timeLabel: UILabel = {
        $0.font = Fonts.avenir(.heavy).getFont(size: .superSmall)
        $0.textColor = Palette.black.color
        return $0
    }(UILabel())
    
    private let storyImage: UIImageView = {
        $0.layer.cornerRadius = LocalConstants.cornerRadius
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.hide()
    }
    
    //MARK: - Public methods
    func configure(story: Story) {
        activityIndicator.show()
        timeLabel.text = Utils.handleDate(unixDate: story.time)
        
        imageDelegate?.fetchImage(stringURL: story.previewImageURL, completion: { [weak self] result in
            switch result {
            case .success(let image):
                UIView.transition(with: self?.storyImage ?? UIView(),
                                  duration: LocalConstants.animationDuration,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self?.storyImage.image = image })
 
                self?.activityIndicator.hide()
            case .failure(_):
                self?.storyImage.backgroundColor = Palette.superLightGray.color
            }
        })
    }
    
    //MARK: - Private methods
    private func setupSelf() {
        backgroundColor = Palette.clear.color
        contentView.layer.cornerRadius = LocalConstants.cornerRadius
        Utils.addShadow(type: .shadowIsBelow,
                        layer: layer,
                        opacity: LocalConstants.shadowOpacity)
    }
    
    private func addSubviews() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(storyImage)
        timeView.addSubview(timeLabel)
        timeViewContainer.addSubview(timeView)
        contentView.addSubview(timeViewContainer)
    }
    
    private func layout() {
        activityIndicator.pin
            .center()
        
        storyImage.pin
            .left()
            .right()
            .top()
            .bottom()
        
        timeViewContainer.pin
            .left(LocalConstants.timerViewContainerLeftInset)
            .top(LocalConstants.timerViewContainerBottomInset)
            .size(LocalConstants.timerViewContainerSize)
        
        timeView.pin
            .left()
            .right()
            .top()
            .bottom()
        
        timeView.layer.cornerRadius = timeView.frame.height / 2
        
        timeLabel.pin
            .center()
            .size(timeLabel.intrinsicContentSize)
    }
}

private enum LocalConstants {
    static let cornerRadius: CGFloat = 20
    static let animationDuration: TimeInterval = 0.45
    static let shadowOpacity: Float =  0.11
    
    //Layout
    static let timerViewContainerLeftInset: CGFloat = 10
    static let timerViewContainerBottomInset: CGFloat = 10
    static let timerViewContainerSize = CGSize(width: 40, height: 20)
}
