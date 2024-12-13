//
//  ViewController.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var tblReels: UITableView!
    
    var commentTF: UITextField!
    
    var allVideos: [Videos] = []
    
    var allComments: [Comments] = []
    
    var currentlyPlayingIndexPath: IndexPath?
    
    private weak var task: URLSessionTask?
    var getVideoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpTableData()
        
    }
    
    
    func setUpTableData() {
        self.tblReels.registerCells(cellTypes: [ReelsTVCell.self])
        self.tblReels.backgroundColor = UIColor.clear
        self.tblReels.separatorStyle = .none
        self.tblReels.showsVerticalScrollIndicator = false
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tblReels.tableHeaderView = UIView(frame: frame)
        
        self.tblReels.tableFooterView = UIView(frame: .zero)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tblReels.contentInset = insets
        self.tblReels.sectionHeaderTopPadding = 0
        self.tblReels.contentInsetAdjustmentBehavior = .never
        self.tblReels.isUserInteractionEnabled = true
        
        self.tblReels.delegate = self
        self.tblReels.dataSource = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loadedVideos = loadVideos() {
            self.allVideos = loadedVideos
            self.tblReels.reloadData()
            
            if let comments = self.loadComments() {
                self.allComments = comments
            }
            
            self.playFirstVisibleCell()
        }
    }
    
    func loadVideos() -> [Videos]? {
        guard let url = Bundle.main.url(forResource: "Videos", withExtension: "json") else {
            print("File not found.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let appList = try decoder.decode(VideoModalClass.self, from: data)
            return appList.videos
        } catch {
            print("Error decoding Video JSON: \(error)")
            return nil
        }
    }
    
    func loadComments() -> [Comments]? {
        guard let url = Bundle.main.url(forResource: "Comments", withExtension: "json") else {
            print("File not found.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let appList = try decoder.decode(CommentsModalClass.self, from: data)
            return appList.comments
        } catch {
            print("Error decoding Comments JSON: \(error)")
            return nil
        }
    }
    
    func playFirstVisibleCell() {
        guard let firstVisibleIndexPath = self.tblReels.indexPathsForVisibleRows?.first else { return }
        currentlyPlayingIndexPath = firstVisibleIndexPath
        
        if let cell = self.tblReels.cellForRow(at: firstVisibleIndexPath) as? ReelsTVCell {
            cell.playVideo() // Custom method in your UITableViewCell subclass
        }
    }
    

}


// MARK: - UITableView Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReelsTVCell", for: indexPath) as! ReelsTVCell
        
        let videoObj = self.allVideos[indexPath.row]
        
        cell.imgMain.loadImageFromProfile(urlString: videoObj.thumbnail ?? "")
        cell.viewReelVideo.isHidden = true
        cell.imgMain.isHidden = false
        
        if let videoURL = URL(string: videoObj.video ?? "") {
            cell.viewReelVideo.isHidden = false
            cell.imgMain.isHidden = true
            
            cell.configureVideo(with: videoURL)
        }
        
        cell.imgUser.loadImageFromProfile(urlString: videoObj.profilePicURL ?? "")
        
        cell.lblUserName.text = videoObj.username ?? ""
        cell.lblUserName.font = AppFont.font(type: .SF_Medium, size: 10.0)
        
        cell.lblLikesCount.text = "\(videoObj.likes ?? 0)"
        cell.lblUserName.font = AppFont.font(type: .SF_Medium, size: 10.0)
        
        cell.btnFollow.titleLabel?.font = AppFont.font(type: .SF_Medium, size: 12.0)
        
        cell.lblTag.text = videoObj.topic ?? ""
        cell.lblTag.font = AppFont.font(type: .SF_Regular, size: 10.0)
        
        cell.lblViewersCount.text = "\(videoObj.viewers ?? 0)"
        cell.lblViewersCount.font = AppFont.font(type: .SF_Medium, size: 10.0)
        
        cell.lblExplore.font = AppFont.font(type: .SF_Regular, size: 10.0)
        
        
        let fullString = NSMutableAttributedString(string: "\(indexPath.row + 1)")
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.font(type: .SF_Medium, size: 10.0)]
        let secondString = NSAttributedString(string: "/\(self.allVideos.count)", attributes: secondAttributes)
        fullString.append(secondString)
        cell.lblVideoTag.attributedText = fullString
        
        cell.allComments = self.allComments
        
        cell.lblTimer.font = AppFont.font(type: .SF_Regular, size: 7.0)
        
        cell.txtComment.tag = indexPath.row
        cell.txtComment.delegate = self
        cell.txtComment.addTarget(self, action: #selector(self.commectTF), for: .editingDidEnd)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ReelsTVCell {
            videoCell.playVideo() // Start video playback
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ReelsTVCell {
            videoCell.pauseVideo() // Pause video playback
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReelsTVCell {
            cell.togglePlayPauseVideo()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight()
    }
    
    
}

// MARK: - UITextField Delegate
extension ViewController {
    
    @objc func commectTF(_ textField: UITextField) {
        print("TF ---> ", textField.text ?? "")
        
        let comment = textField.text ?? ""
        let tag = textField.tag
        let videoObj = self.allVideos[tag]
        
        let iPath = IndexPath(row: tag, section: 0)
        
        if let cell = self.tblReels.cellForRow(at: iPath) as? ReelsTVCell {
            cell.addComment(textField: textField, videoObj: videoObj)
        }
        
        self.view.resignFirstResponder()
    }
    
}
