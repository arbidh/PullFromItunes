//
//  ITControllerCellCollectionViewCell.swift
//  itunesFetch
//
//  Created by Arbi on 9/16/17.
//  Copyright © 2017 arbiapps. All rights reserved.
//

import UIKit

class ITControllerCell: UICollectionViewCell {
    
        
        let imageView:UIImageView = {
            let imageView = UIImageView()
            imageView.frame = CGRect(x:0,y:0,width:0,height:0)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
    
        let webview:UIWebView = {
            let wbView = UIWebView(frame: UIScreen.main.bounds)
            return wbView
        }()
    
        let trackNameLabel:UILabel = {
            
            let tracklabel = UILabel()
            tracklabel.translatesAutoresizingMaskIntoConstraints = false
            tracklabel.font = UIFont.systemFont(ofSize: 15)
            tracklabel.textAlignment = NSTextAlignment.center
            return tracklabel
        }()
        let collectionNameLabel:UILabel = {
            
            let collNameLbl = UILabel()
            collNameLbl.translatesAutoresizingMaskIntoConstraints = false
            collNameLbl.numberOfLines = 0
            collNameLbl.font = UIFont.systemFont(ofSize: 16, weight: 2)
            collNameLbl.textAlignment = NSTextAlignment.center
            return collNameLbl
        }()
        
        func setupLabel(){
            
            
            addSubview(collectionNameLabel)
            addSubview(trackNameLabel)
            
            NSLayoutConstraint.activate([
                collectionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor ,constant:50),
                collectionNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
                collectionNameLabel.topAnchor.constraint(equalTo: topAnchor , constant: 20),
                collectionNameLabel.heightAnchor.constraint(equalToConstant: 100),
                trackNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                trackNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
                
                ])
            
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupImage()
            setupLabel()
            self.backgroundColor = UIColor.gray
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }
    
    
    
        func setupImage(){
            
            addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
                imageView.heightAnchor.constraint(equalToConstant: 200)
                
                ])
        }
    
    deinit {
        imageView.removeFromSuperview()
        collectionNameLabel.removeFromSuperview()
        trackNameLabel.removeFromSuperview()
        
    }
        
    }


