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

    @MainActor
    func loadRemoteImageFrom(urlString: String) async {
        guard let url = URL(string: urlString) else {
            return
        }
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            hideActivityIndicatorView()
            return
        }

        do {
            showActivityIndicator(color: .black)
            
            let (data, _) = try await URLSession.shared.data(from: url)

            self.hideActivityIndicatorView()

            if let imageToCache = UIImage(data: data) {
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = imageToCache
            } else {
                self.image = UIImage(systemName: "questionmark.circle.fill")
            }
        } catch  {
            print(error)
        }
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
