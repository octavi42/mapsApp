//
//  AppViewController.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 23/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import UIKit

var executeOnce = true
var loaded = false
var pinData = [Pin]()
var pinImagesDownloaded = [UIImage]()
//var pin

class AppViewController: UIViewController {
    
    //let mapVC = MapViewController()
    
    @IBOutlet var appSegueButton: UIButton!
    
    final let url = URL(string: "https://sighisoaraapi.herokuapp.com/pins/all")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapVC.removeFromParent()
        
        print("view appeard")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if executeOnce {
            downloadJsonData()
        }
        
    }

    func downloadImagesFromData() {
            for i in stride(from: 0, to: pinData.count, by: 1) {
                print("enterd 1")
                if let imageUrl = URL(string: pinData[i].pinImage) {
                    print("enterd 2")
                        let data = try? Data(contentsOf: imageUrl)
                        if let data = data {
                            let downloadedPinImage = UIImage(data: data)
                            pinImagesDownloaded.append(downloadedPinImage!)
                                print("should have appended")
                        } else {
                            print("couldn't download images")
                        }
                } else {
                    print("failed getting url")
                }
            }
            print("image count\(pinImagesDownloaded.count)")
            print("pins count\(pinData.count)")
    }
    
    func downloadJsonData() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else{
                print("something went wrong")
                return
            }
            print("data = \(data)")
            do
            {
                let decoder = JSONDecoder()
                let downloadedPins = try decoder.decode(Pins.self, from: data)
                
                pinData = downloadedPins.venues
                
                self.downloadImagesFromData()
                
                loaded = true
                executeOnce = false
                
                print(pinData.count)
                print("done")
                
            } catch {
                print("something went wrong download")
            }
        }.resume()
    }
    
}
