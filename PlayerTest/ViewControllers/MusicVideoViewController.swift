//
//  MusicVideoTableViewController.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 17/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import RippleEffectView

class MusicVideoViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var musicCollectionView: UICollectionView!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var splashScreenContentView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isPlay = false
    var playerLayer = AVPlayerLayer()
    var rippleEffectView: RippleEffectView!
    var pathVideo : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initTableView()
        initCollectionView()
        initPlayerLayer()
        initSplashScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.orientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.orientation()
    }
    
    private func initPlayerLayer(){
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height/2) - 70 )
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.needsLayout()
        playerLayer.needsDisplay()
        playerLayer.speed = 2.0
        videoView.layer.addSublayer(playerLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.fullScreen))
        videoView.addGestureRecognizer(tap)
        
    }
    
    
    private func initTableView(){
        //table configuraçoes
        self.musicTableView.register(UINib(nibName: "MusicVideoViewCell", bundle: nil), forCellReuseIdentifier: "musicVideoCell")
        
        self.musicTableView.estimatedRowHeight = 100
        self.musicTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func initCollectionView(){
        //collection configuraçoes
        self.musicCollectionView.register(UINib(nibName: "MusicVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "musicVideoCollectionCell")

    }
    
    private func initNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        //Inicializando a busca
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Music Video "
        self.searchController.hidesNavigationBarDuringPresentation = false
        let scb = searchController.searchBar
        scb.barTintColor = .white
        scb.tintColor = .white
        
        if let txt = scb.value(forKey: "searchField") as? UITextField{
            txt.textColor = .black
            if let bg = txt.subviews.first{
                bg.backgroundColor = .white
                bg.layer.cornerRadius = 10
                bg.clipsToBounds = true
            }
        }
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func initSplashScreen(){
        rippleEffectView = RippleEffectView()
        rippleEffectView.tileImage = UIImage(named: "play")
        rippleEffectView.magnitude = 0.2
        rippleEffectView.cellSize = CGSize(width:50, height:50)
        rippleEffectView.rippleType = .heartbeat
        rippleEffectView.isHidden = true
        rippleEffectView.tileImageCustomizationClosure = {rows, columns, row, column, image in
            if (row % 2 == 0 && column % 2 == 0) {
                let newImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
                UIColor.random.set()
                newImage.draw(in: CGRect(x:0, y:0, width: image.size.width, height: newImage.size.height));
                if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return titledImage
                }
                UIGraphicsEndImageContext()
            }
            return image
        }
        rippleEffectView.setupView()
        self.splashScreenContentView.addSubview(rippleEffectView)
    }
    
    private func orientation(){
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
            self.musicTableView.isHidden = true
            self.musicCollectionView.isHidden = false
            self.videoView.isHidden = false
            self.playerLayer.position.y = 44
        } else {
            print("portrait")
            self.musicTableView.isHidden = false
            self.musicCollectionView.isHidden = true
            self.videoView.isHidden = isPlay ? false : true
        }
    }
    
    func playVideo(path:URL){
        
        let player = AVPlayer(url: path)
        playerLayer.player = player
        self.pathVideo = path
        player.play()
    }
    
    @objc func fullScreen(){
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: pathVideo!)
        playerController.player = player
        present(playerController, animated: true) {
                    player.play()
        }
    }
    
//    // MARK: - functions search
//    func searchBarIsEmpty() -> Bool {
//        // Returns true if the text is empty or nil
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
////        filteredSkill = mm.skills!.filter({( skill : ListaSkills) -> Bool in
////            return skill.nome!.lowercased().contains(searchText.lowercased())
////        })
////
////        tableView.reloadData()
//    }
//
//    func isFiltering() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }

}



