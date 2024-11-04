//
//  UIImageView+Async.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation
import UIKit

@globalActor
actor BackgroundActor {
    static let shared = BackgroundActor()
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    @BackgroundActor
    func loadRemoteImageFrom(urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            return
        }
        await MainActor.run {
            image = nil
        }

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            await MainActor.run {
                self.image = imageFromCache
                hideActivityIndicatorView()
            }
            return
        }

        await MainActor.run {
            showActivityIndicator(color: .black)
        }

        guard !Task.isCancelled else {
            return
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        await MainActor.run {
            self.hideActivityIndicatorView()
        }

        if let imageToCache = UIImage(data: data) {
            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            await MainActor.run {
                self.image = imageToCache
            }
        } else {
            await MainActor.run {
                self.image = UIImage(systemName: "questionmark.circle.fill")
            }
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
