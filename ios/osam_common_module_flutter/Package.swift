// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "osam_common_module_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "osam-common-module-flutter", targets: ["osam_common_module_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/AjuntamentdeBarcelona/modul_comu_osam.git", exact: "3.2.1-dev")
    ],
    targets: [
        .target(
            name: "osam_common_module_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "OSAMCommon", package: "modul_comu_osam")
            ]
        )
    ]
)
