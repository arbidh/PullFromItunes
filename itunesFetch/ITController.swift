//
//  ViewController.swift
//  itunesFetch
//
//  Created by Arbi on 9/15/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit


class ITController: UICollectionViewController {

    let networkManager = ITNetworkManager()
    let flowLayout = UICollectionViewFlowLayout()
    var cellWidth:CGFloat = 0
    let cellHeight:CGFloat = 400
    
    func setupCell(){
        collectionView?.register(ITControllerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
    }
    func setupView(){
        networkManager.ITNetworkManagerDelegate = self
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    func fetchITDataFromNetwork(){
        self.networkManager.fetchItunesData(term: "riannah", mediaType: "music")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchITDataFromNetwork()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCell()
       
        
      // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkManager.listOfMusicData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ITControllerCell
        guard let trackViewUrl = networkManager.listOfMusicData[indexPath.row].collectionViewUrl else{
            print("trackURL is nil")
            return
        }
        
        //the trackViewURL is not loading since it sends user
        //to itunes
        //i hardcoded the url to show you it works
        let url  = URL(string:"https://apple.com")
        let request = URLRequest(url:url!)

        cell.webview.loadRequest(request)
        
        view.addSubview(cell.webview)
        
    }
    func populateCell(cell:ITControllerCell, indexPath:IndexPath){
        guard let imageURL = self.networkManager.listOfMusicData[indexPath.row].artworkUrl100 else {
            print("url for artWorkUrl100 was nil")
            return
        }
        
        self.networkManager.fetchImageForURL(urlString:imageURL, success: { image in
            cell.imageView.image = image
        })
        
        guard let trackName = self.networkManager.listOfMusicData[indexPath.row].trackName else{
            print("trackName is empty")
            return
        }
        guard let collName = self.networkManager.listOfMusicData[indexPath.row].collectionName else{
            print("collectionName is empty")
            return
        }
        cell.trackNameLabel.text = trackName
        cell.collectionNameLabel.text = collName
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ITCell:ITControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ITControllerCell ??  ITControllerCell()
            populateCell(cell: ITCell, indexPath: indexPath)
            return ITCell

    }
}

//delegate Methods
extension ITController: ITNetworkManagerProtocol{
    func successWithData(data: [ITMusicData]) {
        if let genere = networkManager.listOfMusicData.first?.primaryGenreName,
            let artistName = networkManager.listOfMusicData.first?.artistName{
            title = String(format:"%@ (%@)",artistName,genere)
        }
        collectionView?.reloadData()
    }
}

extension ITController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = self.view.frame.size.width
        return CGSize(width:cellWidth, height:cellHeight)
    }
    func removeWebView(){
        
        for subview in self.view.subviews{
            
            if subview is UIWebView{
                
                self.view.removeFromSuperview()
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
      removeWebView()
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            cellWidth = UIScreen.main.bounds.size.width
            collectionView?.reloadData()
            
        }
        else{
            cellWidth = self.view.frame.size.width
            collectionView?.reloadData()
        }
    }
    
    
}


