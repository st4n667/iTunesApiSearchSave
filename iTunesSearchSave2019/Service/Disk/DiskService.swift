//
//  DiskService.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 27/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import UIKit

struct DiskEndpoint {
    enum DiskLocation {
        case documents, cache
        
        var location: FileManager.SearchPathDirectory {
            switch self {
            case .documents:
                return .documentDirectory
            case .cache:
                return .cachesDirectory
            }
        }
    }
    
    private init(diskLocation: DiskLocation = .documents, folderPath: String? = nil) {
        self.diskLocation = diskLocation
        self.folderPath = folderPath
    }
    
    private let diskLocation: DiskLocation
    private let folderPath: String?
    
    private var prefix = "file://"
    
    private let invalidCharacters: CharacterSet = {
        var invalidCharacters = CharacterSet(charactersIn: ":/")
        invalidCharacters.formUnion(.whitespacesAndNewlines)
        invalidCharacters.formUnion(.symbols)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)
        invalidCharacters.formUnion(.decomposables)
        return invalidCharacters
    }()
    
    private func createURL(for filename: String) throws -> URL {
        let validFilename = filename
            .components(separatedBy: invalidCharacters)
            .joined(separator: "_")
        
        guard var url = FileManager.default.urls(for: diskLocation.location, in: .userDomainMask).first else {
            throw DiskError.createEndpointError(nil)
        }
        
        if let folderPath = folderPath {
            url.appendPathComponent(folderPath, isDirectory: true)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw DiskError.createDirectoryError(error)
            }
        }
        
        url.appendPathComponent(validFilename, isDirectory: false)
        return url
    }
    
    static func imageDocuments(filename: String) throws -> URL {
        do {
            let endpoint = DiskEndpoint(diskLocation: .documents, folderPath: "images")
            let url = try endpoint.createURL(for: filename)
            return url
        } catch {
            throw DiskError.createEndpointError(error)
        }
    }
}

struct DiskService {
    
    static func saveImage(_ image: UIImage, to endpoint: URL) throws {
        let url = endpoint.absoluteURL
        do {
            var imageData: Data?
            if let pngData = image.pngData() {
                imageData = pngData
            } else if let jpegData = image.jpegData(compressionQuality: 1) {
                imageData = jpegData
            }
            if let data = imageData {
                try data.write(to: url, options: .atomic)
            } else {
                throw DiskError.dataTransformError
            }
        } catch {
            throw DiskError.fileSaveError(error)
        }
    }
    
    static func loadImageWithEndpoint(_ endpoint: URL) throws -> UIImage {
        let url = endpoint.absoluteURL
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw DiskError.dataTransformError
            }
        } catch {
            throw error
        }
    }

    static func removeDataWithEndpint(_ endpoint: URL) throws {
        do {
            try FileManager.default.removeItem(at: endpoint.absoluteURL)
        } catch {
            throw DiskError.fileDeleteError(error)
        }
    }
    
}
