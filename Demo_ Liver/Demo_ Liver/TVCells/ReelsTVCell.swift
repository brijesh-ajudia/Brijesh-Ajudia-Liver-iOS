//
//  ReelsTVCell.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import UIKit
import Lottie
import IQKeyboardManagerSwift
import AVFoundation

class ReelsTVCell: UITableViewCell {
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var viewReelVideo: UIView!
    
    @IBOutlet weak var viewtop: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLikesCount: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var lblViewersCount: UILabel!
    @IBOutlet weak var lblExplore: UILabel!
    @IBOutlet weak var lblVideoTag: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tblComments: UITableView!
    
    @IBOutlet weak var viewAnimation: UIView!
    
    @IBOutlet weak var txtComment: UITextField!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTFConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //var allComments: [Comments] = []
    
    var animationView: LottieAnimationView?
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPlaying: Bool = false
    
    var allComments: [Comments] = []
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply gradients to the views
        
        IQKeyboardManager.shared.enable = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.loadLottieAnimation(_:)))
        tap.numberOfTapsRequired = 2
        tap.delegate = self
        self.contentView.addGestureRecognizer(tap)
        
        if DeviceUtility.deviceHasTopNotch == true {
            self.topConstraint.constant = sceneDelegate?.window?.safeAreaInsets.top ?? 20
            self.bottomTFConstraint.constant = sceneDelegate?.window?.safeAreaInsets.bottom ?? 20
        }
        else {
            self.topConstraint.constant = 20
            self.bottomTFConstraint.constant = 20
        }
        
        self.applyTopGradient()
        self.applyBottomGradient()
        
        self.setUpTableData()
        self.setUpTxtField()
        
        NotificationCenter.default.addObserver(self,
                              selector: #selector(self.keyboardNotification(notification:)),
                              name: UIResponder.keyboardWillChangeFrameNotification,
                              object: nil)
    }

    private func applyTopGradient() {
        viewtop.applyGradientBackground(
            colors: [UIColor.black.withAlphaComponent(0.5).cgColor,
                     UIColor.black.withAlphaComponent(0.20).cgColor,
                     UIColor.clear.cgColor],
            locations: [0.0, 0.48, 0.91])
    }

    private func applyBottomGradient() {
        viewBottom.applyGradientBackground(
            colors: [UIColor.clear.cgColor,
                     UIColor.black.withAlphaComponent(0.50).cgColor,
                     UIColor.black.withAlphaComponent(0.75).cgColor],
            locations: [0.0, 0.39, 0.86])
    }
    
    func configureVideo(with url: URL) {
        // Remove old player if exists
        playerLayer?.removeFromSuperlayer()
        
        // Initialize player
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.viewReelVideo.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Add to the container view
        if let playerLayer = playerLayer {
            self.viewReelVideo.layer.addSublayer(playerLayer)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    @objc private func videoDidFinishPlaying() {
        NotificationCenter.default.post(name: NSNotification.Name("VideoFinished"), object: nil)
    }
    
    func playVideo() {
        player?.play()
        isPlaying = true
        
        print("Video is playing")
    }
    
    func pauseVideo() {
        player?.pause()
        isPlaying = false
        
        print("Video paused")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        isPlaying = false
    }
    
    func addComment(textField: UITextField, videoObj: Videos?) {
        let comment = textField.text ?? ""
        
        var param: [String: Any] = [:]
        param["id"] = (self.allComments.last?.id ?? 0) + 1
        param["username"] = videoObj?.username ?? ""
        param["picURL"] = videoObj?.profilePicURL ?? ""
        param["comment"] = comment
        
        do {
            let comment = try DictionaryDecoder().decode(Comments.self, from: param)
            self.allComments.append(comment)
            self.tblComments.reloadData()
            
            DispatchQueue.main.async {
                let lastIndexPath = IndexPath(row: self.allComments.count - 1, section: 0)
                self.tblComments.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
            
        }
        catch let error {
            print("No able to decode in Comment", error.localizedDescription)
        }
        self.txtComment.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTableData() {
        self.tblComments.registerCells(cellTypes: [CommentTVCell.self])
        self.tblComments.backgroundColor = UIColor.clear
        self.tblComments.separatorStyle = .none
        self.tblComments.showsVerticalScrollIndicator = false
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tblComments.tableHeaderView = UIView(frame: frame)
        
        self.tblComments.tableFooterView = UIView(frame: .zero)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tblComments.contentInset = insets
        self.tblComments.sectionHeaderTopPadding = 0
        self.tblComments.contentInsetAdjustmentBehavior = .never
        self.tblComments.isUserInteractionEnabled = true
        self.tblComments.estimatedRowHeight = 27 + 12
        
        self.tblComments.delegate = self
        self.tblComments.dataSource = self
    }
    
    func setUpTxtField() {
        self.txtComment.keyboardType = .default
        self.txtComment.setAttributePlaceHolderWithFont(title: "Comment", font: AppFont.font(type: .SF_Regular, size: 12.0))
        self.txtComment.keyboardAppearance = .light
        self.txtComment.returnKeyType = .done
    }
    
    @objc func loadLottieAnimation(_ g: UITapGestureRecognizer) {
        self.viewAnimation.isHidden = false
        animationView = LottieAnimationView(name: "Heart")
        if let animationView = animationView {
            animationView.frame = self.viewAnimation.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            
            animationView.play { [weak self] finished in
                if finished {
                    self?.animationView?.removeFromSuperview()
                    self?.animationView = nil
                    self?.viewAnimation.isHidden = true
                }
            }
            
            self.viewAnimation.addSubview(animationView)
            
            let maskView = UIView(frame: animationView.bounds)
            maskView.backgroundColor = .clear
            maskView.isUserInteractionEnabled = false
            maskView.alpha = 0.0
            animationView.addSubview(maskView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                maskView.alpha = 1.0
            }
        }
    }
    
    func togglePlayPauseVideo() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        }
        else {
            player.play()
        }
        
        isPlaying.toggle()
    }
    
    //MARK: - Keyboard Will Show & Keyboard Will Hide
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            if endFrameY >= UIScreen.main.bounds.size.height {
                // Hide
                if DeviceUtility.deviceHasTopNotch == true {
                    self.bottomConstraint.constant = 0.0
                }
                else {
                    self.bottomConstraint.constant = 0.0
                }
                print("Key Board Hide")
            } else {
                // Show
                if DeviceUtility.deviceHasTopNotch == true {
                    self.bottomConstraint.constant = ((endFrame?.size.height ?? 0.0) - 21.0)
                }
                else {
                    self.bottomConstraint.constant = ((endFrame?.size.height ?? 0.0) - 7.0)
                }
                print("Key Board Show")
            }
            
            let i = notification.userInfo!
            let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            UIView.animate(withDuration: s) { self.contentView.layoutIfNeeded() }
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: self.txtComment) {
            return false
        }
        return true
    }
    
}

// MARK: - UITableView Methods
extension ReelsTVCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell", for: indexPath) as! CommentTVCell
        
        let commentObj = self.allComments[indexPath.row]
        
        cell.imgUser.loadImageFromProfile(urlString: commentObj.picURL ?? "")
        
        cell.lblUsername.text = commentObj.username?.capitalized ?? ""
        cell.lblUsername.font = AppFont.font(type: .SF_Semibold, size: 9.0)
        
        cell.lblComment.text =  commentObj.comment ?? ""
        cell.lblComment.font = AppFont.font(type: .SF_Regular, size: 9.0)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
