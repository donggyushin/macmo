//
//  ImageProcessor.swift
//  macmo
//
//  Created by 신동규 on 1/17/26.
//

import Foundation
import MacmoDomain

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public final class ImageProcessor {

    public init() {}

    public func compressImageIfNeeded(imageData: Data, maxSizeByBytes: Int) async throws -> Data {
        // 이미 크기가 작으면 그대로 반환
        guard imageData.count > maxSizeByBytes else {
            return imageData
        }

        #if os(macOS)
        return try await compressImageMacOS(imageData: imageData, maxSizeByBytes: maxSizeByBytes)
        #else
        return try await compressImageIOS(imageData: imageData, maxSizeByBytes: maxSizeByBytes)
        #endif
    }

    // MARK: - macOS Implementation

    #if os(macOS)
    private func compressImageMacOS(imageData: Data, maxSizeByBytes: Int) async throws -> Data {
        guard let nsImage = NSImage(data: imageData) else {
            throw AppError.invalidInput
        }

        // NSImage를 CGImage로 변환
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw AppError.invalidInput
        }

        // NSBitmapImageRep 생성
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)

        // 압축 품질을 점진적으로 낮추면서 목표 크기 달성 시도
        var compressionQuality: CGFloat = 0.9
        let qualityStep: CGFloat = 0.1
        let minQuality: CGFloat = 0.1

        while compressionQuality >= minQuality {
            guard let compressedData = bitmapRep.representation(
                using: .jpeg,
                properties: [.compressionFactor: compressionQuality]
            ) else {
                throw AppError.custom("Failed to compress image")
            }

            // 목표 크기 달성
            if compressedData.count <= maxSizeByBytes {
                return compressedData
            }

            compressionQuality -= qualityStep
        }

        // 최소 품질로도 크기를 맞추지 못한 경우, 리사이징 시도
        return try await resizeAndCompressMacOS(
            nsImage: nsImage,
            maxSizeByBytes: maxSizeByBytes
        )
    }

    private func resizeAndCompressMacOS(nsImage: NSImage, maxSizeByBytes: Int) async throws -> Data {
        var scale: CGFloat = 0.8
        let scaleStep: CGFloat = 0.1
        let minScale: CGFloat = 0.1

        while scale >= minScale {
            let newSize = NSSize(
                width: nsImage.size.width * scale,
                height: nsImage.size.height * scale
            )

            let resizedImage = NSImage(size: newSize)
            resizedImage.lockFocus()
            nsImage.draw(
                in: NSRect(origin: .zero, size: newSize),
                from: NSRect(origin: .zero, size: nsImage.size),
                operation: .copy,
                fraction: 1.0
            )
            resizedImage.unlockFocus()

            guard let cgImage = resizedImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                scale -= scaleStep
                continue
            }

            let bitmapRep = NSBitmapImageRep(cgImage: cgImage)

            guard let compressedData = bitmapRep.representation(
                using: .jpeg,
                properties: [.compressionFactor: 0.7]
            ) else {
                scale -= scaleStep
                continue
            }

            if compressedData.count <= maxSizeByBytes {
                return compressedData
            }

            scale -= scaleStep
        }

        throw AppError.custom("Unable to compress image to target size")
    }
    #endif

    // MARK: - iOS/iPadOS Implementation

    #if !os(macOS)
    private func compressImageIOS(imageData: Data, maxSizeByBytes: Int) async throws -> Data {
        guard let uiImage = UIImage(data: imageData) else {
            throw AppError.invalidInput
        }

        // 압축 품질을 점진적으로 낮추면서 목표 크기 달성 시도
        var compressionQuality: CGFloat = 0.9
        let qualityStep: CGFloat = 0.1
        let minQuality: CGFloat = 0.1

        while compressionQuality >= minQuality {
            guard let compressedData = uiImage.jpegData(compressionQuality: compressionQuality) else {
                throw AppError.custom("Failed to compress image")
            }

            // 목표 크기 달성
            if compressedData.count <= maxSizeByBytes {
                return compressedData
            }

            compressionQuality -= qualityStep
        }

        // 최소 품질로도 크기를 맞추지 못한 경우, 리사이징 시도
        return try await resizeAndCompressIOS(
            uiImage: uiImage,
            maxSizeByBytes: maxSizeByBytes
        )
    }

    private func resizeAndCompressIOS(uiImage: UIImage, maxSizeByBytes: Int) async throws -> Data {
        var scale: CGFloat = 0.8
        let scaleStep: CGFloat = 0.1
        let minScale: CGFloat = 0.1

        while scale >= minScale {
            let newSize = CGSize(
                width: uiImage.size.width * scale,
                height: uiImage.size.height * scale
            )

            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            uiImage.draw(in: CGRect(origin: .zero, size: newSize))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                scale -= scaleStep
                continue
            }
            UIGraphicsEndImageContext()

            guard let compressedData = resizedImage.jpegData(compressionQuality: 0.7) else {
                scale -= scaleStep
                continue
            }

            if compressedData.count <= maxSizeByBytes {
                return compressedData
            }

            scale -= scaleStep
        }

        throw AppError.custom("Unable to compress image to target size")
    }
    #endif
}

