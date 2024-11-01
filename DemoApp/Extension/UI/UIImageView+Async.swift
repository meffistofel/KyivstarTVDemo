//
//  UIImageView+Async.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadRemoteImageFrom(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        image = nil
        showActivityIndicator(color: .black)

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            hideActivityIndicatorView()
            return
        }

        URLSession.shared.dataTask(with: url) {
            data, response, error in
            DispatchQueue.main.async {
                self.hideActivityIndicatorView()
            }
            if let response = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: response) {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    } else {
                        self.image = UIImage(systemName: "people")
                    }
                }
            }
        }.resume()
    }
}

extension UIView {

    func showActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .gray, tranfsormValue: CGFloat? = nil) {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.frame = bounds
        activityIndicatorView.color = color
        activityIndicatorView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        if let tranfsormValue = tranfsormValue {
            activityIndicatorView.transform = CGAffineTransform(scaleX: tranfsormValue, y: tranfsormValue)
        }
        addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicatorView() {
        if let activityIndicator: UIView = self.subviews.first(where: { $0 is UIActivityIndicatorView }) {
            activityIndicator.removeFromSuperview()
        }
    }

}
