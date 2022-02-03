import Foundation
import OSAMCommon

private let catalanLanguageCode = "ca"
private let spanishLanguageCode = "es"
private let englishLanguageCode = "en"

extension Language {
    func toLanguageCode() -> String {
        switch self {
        case .ca:
            return catalanLanguageCode
        case .es:
            return spanishLanguageCode
        case .en:
            return englishLanguageCode
        default:
            return catalanLanguageCode
        }
    }
}

func getLanguageFromString(langugageCode: String) -> Language {
    if langugageCode == catalanLanguageCode {
        return Language.ca
    } else if langugageCode == spanishLanguageCode {
        return Language.es
    } else if langugageCode == englishLanguageCode {
        return Language.en
    } else {
        return Language.ca
    }
}

extension VersionControlResponse {
    func toStringResponse() -> String {
        switch self {
        case .accepted:
            return "ACCEPTED"
        case .dismissed:
            return "DISMISSED"
        case .cancelled:
            return "CANCELLED"
        case .error:
            return "ERROR"
        default:
            return "DISMISSED"
        }
    }
}

extension RatingControlResponse {
    func toStringResponse() -> String {
        switch self {
        case .accepted:
            return "ACCEPTED"
        case .dismissed:
            return "DISMISSED"
        case .cancelled:
            return "CANCELLED"
        case .later:
            return "LATER"
        case .error:
            return "ERROR"
        default:
            return "DISMISSED"
        }
    }
}
