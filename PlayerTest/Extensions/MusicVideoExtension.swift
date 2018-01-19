//
//  MusicVideoExtension.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 18/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import UIKit

extension MusicVideoViewController : UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mm.response?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isPlay {
            return (UIScreen.main.bounds.size.height/2) - 70 
        }else{
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if self.isPlay {
////            let videoHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
////            videoHeaderView.layer.addSublayer(self.playerLayer)
//            return self.videoView
//        }else{
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicVideoCell", for: indexPath) as! MusicVideoViewCell
        
        cell.artistLabel.text = mm.response?.results![indexPath.row].artistName
        cell.songLabel.text = mm.response?.results![indexPath.row].trackName
        cell.timeLabel.text = mm.response?.results![indexPath.row].trackInMinute()
        cell.iTunnesButton.tag = indexPath.row
        
        iTunnesAPI.getImage(url: (mm.response?.results![indexPath.row].artworkUrl100!)!, success: { (image) in
            cell.videoImage.image = image
        }) { (error) in
            print("deu erro")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        play(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mm.response?.resultCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicVideoCollectionCell", for: indexPath) as! MusicVideoCollectionViewCell
        
        cell.artistLabel.text = mm.response?.results![indexPath.row].artistName
        cell.songLabel.text = mm.response?.results![indexPath.row].trackName
        cell.timeLabel.text = mm.response?.results![indexPath.row].trackInMinute()
        
        iTunnesAPI.getImage(url: (mm.response?.results![indexPath.row].artworkUrl100!)!, success: { (image) in
            cell.videoImage.image = image
        }) { (error) in
            print("deu erro")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        play(indexPath: indexPath)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let url = "https://itunes.apple.com/search?term=\(searchBar.text ?? "")&entity=musicVideo"
        iTunnesAPI.get(Response.self, url: url, finish: {
            print("Nada")
        }, success: { (item) in
            mm.response = item
            self.musicTableView.reloadData()
            self.musicCollectionView.reloadData()
        }) { (error, code) in
            print("----erro \(error.localizedDescription) ----- code \(code ?? 0)")
        }
    }
    
    private func play(indexPath:IndexPath){
        self.rippleEffectView.isHidden = false
        self.rippleEffectView.startAnimating()
        let url =  mm.response?.results![indexPath.row].previewUrl
        iTunnesAPI.downloadFile(url: url!, name: "preview", success: { (path) in
            self.rippleEffectView.stopAnimating()
            self.rippleEffectView.isHidden = true
            self.isPlay = true
            self.videoView.isHidden = false
            self.musicTableView.reloadData()
            self.playVideo(path: path)
        }) { (error, code) in
            print("--- error \(error?.localizedDescription ?? "sem descrição") ---- code\(code ?? 0)")
        }
    }
    
}
