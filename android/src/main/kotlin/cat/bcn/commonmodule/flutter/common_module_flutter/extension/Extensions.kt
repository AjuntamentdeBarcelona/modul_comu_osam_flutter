package cat.bcn.commonmodule.flutter.common_module_flutter.extension

import cat.bcn.commonmodule.ui.versioncontrol.Language
import cat.bcn.commonmodule.ui.versioncontrol.RatingControlResponse
import cat.bcn.commonmodule.ui.versioncontrol.VersionControlResponse

private const val catalanLanguageCode = "ca"
private const val spanishLanguageCode = "es"
private const val englishLanguageCode = "en"

fun Language.toLanguageCode(): String = when (this) {
    Language.CA -> catalanLanguageCode
    Language.ES -> spanishLanguageCode
    Language.EN -> englishLanguageCode
}

fun getLanguageFromString(languageCode: String): Language = when (languageCode) {
    catalanLanguageCode -> Language.CA
    spanishLanguageCode -> Language.ES
    englishLanguageCode -> Language.EN
    else -> Language.CA
}

fun VersionControlResponse.toStringResponse(): String = when (this) {
    VersionControlResponse.ACCEPTED -> "ACCEPTED"
    VersionControlResponse.DISMISSED -> "DISMISSED"
    VersionControlResponse.CANCELLED -> "CANCELLED"
    VersionControlResponse.ERROR -> "ERROR"
}

fun RatingControlResponse.toStringResponse(): String = when (this) {
    RatingControlResponse.ACCEPTED -> "ACCEPTED"
    RatingControlResponse.DISMISSED -> "DISMISSED"
    RatingControlResponse.CANCELLED -> "CANCELLED"
    RatingControlResponse.LATER -> "LATER"
    RatingControlResponse.ERROR -> "ERROR"
}