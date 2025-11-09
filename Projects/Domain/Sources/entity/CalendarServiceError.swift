//
//  CalendarServiceError.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//


public enum CalendarServiceError: Error {
    case accessDenied
    case eventCreationFailed
    case eventNotFound
    case noDueDate
}