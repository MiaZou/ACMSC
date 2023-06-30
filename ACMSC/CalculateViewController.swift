//
//  CalculateViewController.swift
//  ACMSC
//
//  Created by Mia Zou on 6/24/23.
//

// Algorithm for weather prediction is based of https://github.com/Treeki/MeteoNook

import UIKit

struct DayInfo {
    var y: Int
    var m: Int
    var d: Int
    var dayType: DayType
    var showerType: ShowerType
    var rainbowTime: Int
    var rainbowDouble: Bool
    var auroraFine01: Bool
    var auroraFine03: Bool
    var auroraFine05: Bool
    var types: [WeatherTypeInfo]
    var stars: [StarInfo]
    var gaps: [GapInfo]
}

struct WeatherTypeInfo {
    let time: Int
    let type: Any
    let specialCloud: Bool?
}

struct StarInfo {
    let hour: Int
    let minute: Int
    let seconds: [Int]
}

struct GapInfo {
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
}

enum DayType: Int {
    case noData = 0
    case none
    case shower
    case rainbow
    case aurora
}

enum ShowerType: Int {
    case notSure = 0
    case light
    case heavy
}

enum Hemisphere: Int {
    case Northern = 0
    case Southern = 1
}

enum Weather: Int {
    case clear = 0
    case sunny = 1
    case cloudy = 2
    case rainClouds = 3
    case rain = 4
    case heavyRain = 5
}

enum AmbiguousWeather: Int {
    case clearOrSunny = 95
    case sunnyOrCloudy = 96
    case cloudyOrRainClouds = 97
    case noRain = 98
    case rainOrHeavyRain = 99
}

enum CloudLevel {
    case none
    case cumulonimbus
    case cirrus
    case thin
    case billow
}

enum Pattern: Int {
    case Fine00 = 0
    case Fine01 = 1
    case Fine02 = 2
    case Fine03 = 3
    case Fine04 = 4
    case Fine05 = 5
    case Fine06 = 6
    case Cloud00 = 7
    case Cloud01 = 8
    case Cloud02 = 9
    case Rain00 = 10
    case Rain01 = 11
    case Rain02 = 12
    case Rain03 = 13
    case Rain04 = 14
    case Rain05 = 15
    case FineCloud00 = 16
    case FineCloud01 = 17
    case FineCloud02 = 18
    case CloudFine00 = 19
    case CloudFine01 = 20
    case CloudFine02 = 21
    case FineRain00 = 22
    case FineRain01 = 23
    case FineRain02 = 24
    case FineRain03 = 25
    case CloudRain00 = 26
    case CloudRain01 = 27
    case CloudRain02 = 28
    case RainCloud00 = 29
    case RainCloud01 = 30
    case RainCloud02 = 31
    case Commun00 = 32
    case EventDay00 = 33
}

enum PatternKind: Int {
    case Fine = 0
    case Cloud = 1
    case Rain = 2
    case FineCloud = 3
    case CloudFine = 4
    case FineRain = 5
    case CloudRain = 6
    case RainCloud = 7
    case Commun = 8
    case EventDay = 9
}

let Patterns: [[Weather]] = [
    //   0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23
    [Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.clear, Weather.sunny, Weather.clear,],  // Fine00
    [Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.clear, Weather.sunny,],  // Fine01
    [Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.cloudy, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.clear,],  // Fine02
    [Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.cloudy, Weather.clear, Weather.clear, Weather.sunny,],  // Fine03
    [Weather.clear, Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear,],  // Fine04
    [Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny,],  // Fine05
    [Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.clear,],  // Fine06
    [Weather.sunny, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.sunny,],  // Cloud00
    [Weather.sunny, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.sunny,],  // Cloud01
    [Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy,],  // Cloud02
    [Weather.sunny, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rainClouds,Weather.cloudy, Weather.sunny, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.cloudy,],  // Rain00
    [Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.sunny, Weather.sunny, Weather.cloudy,],  // Rain01
    [Weather.rainClouds,Weather.cloudy, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rainClouds,Weather.rain, Weather.sunny, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.rain, Weather.rain, Weather.rain, Weather.rainClouds,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain,],  // Rain02
    [Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rainClouds,Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.rainClouds,], // Rain03
    [Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain,],  // Rain04
    [Weather.rainClouds,Weather.rain, Weather.rain, Weather.heavyRain,Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.cloudy, Weather.sunny,],  // Rain05
//   0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23
    [Weather.rainClouds,Weather.cloudy, Weather.rainClouds,Weather.rainClouds,Weather.cloudy, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy,],  // FineCloud00
    [Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy,],  // FineCloud01
    [Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.rainClouds,Weather.rainClouds,Weather.rain,],  // FineCloud02
    [Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.rainClouds,Weather.rain, Weather.rain, Weather.cloudy, Weather.rain, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.clear,],  // CloudFine00
    [Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny,],  // CloudFine01
    [Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear,],  // CloudFine02
    [Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.rain, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny,],  // FineRain00
    [Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.rain, Weather.cloudy, Weather.rain, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny,],  // FineRain01
    [Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.heavyRain,Weather.cloudy, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear,],  // FineRain02
    [Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.sunny, Weather.heavyRain,Weather.rain, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny,],  // FineRain03
    [Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain,],  // CloudRain00
    [Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.rain, Weather.rain,],  // CloudRain01
    [Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.heavyRain,Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rainClouds,], // CloudRain02
    [Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy,],  // RainCloud00
    [Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.sunny, Weather.sunny,],  // RainCloud01
    [Weather.sunny, Weather.sunny, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.rainClouds,Weather.heavyRain,Weather.heavyRain,Weather.rain, Weather.rain, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.rain, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.rainClouds,Weather.cloudy, Weather.cloudy,],  // RainCloud02
//   0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23
    [Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.cloudy, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.cloudy, Weather.sunny, Weather.clear, Weather.sunny,],  // Commun00
    [Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny, Weather.clear, Weather.sunny,],  // EventDay00
];

let cumulonimbusPatterns: [PatternKind] = [
    .Fine,
    .FineCloud,
    .CloudFine,
    .FineRain,
    .EventDay
]

let cirrusPatterns: [PatternKind] = [
    .Fine,
    .Cloud,
    .FineCloud,
    .FineRain,
    .CloudFine,
    .CloudRain,
    .RainCloud,
    .EventDay
]

let rainbowPatternsByTime: [Int: Pattern] = [
    10: .CloudFine00,
    12: .CloudFine02,
    13: .CloudFine01,
    14: .FineRain00,
    15: .FineRain01,
    16: .FineRain03
]

class CalculateViewController: UIViewController {

    let maxPattern: Pattern = Pattern.EventDay00
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getCloudLevel(hemi: Hemisphere, month: UInt8, day: UInt8) -> CloudLevel {
        switch (hemi, month, day) {
        case (.Northern, 7, 21...31), (.Northern, 8, _), (.Northern, 9, 1...15):
            return .cumulonimbus
        case (.Northern, 9, 16...30), (.Northern, 10, _), (.Northern, 11, _):
            return .cirrus
        case (.Northern, 12, _), (.Northern, 1, _), (.Northern, 2, _):
            return .billow
        case (.Northern, 3, _), (.Northern, 4, _), (.Northern, 5, _):
            return .thin
        case (.Southern, 1, 21...31), (.Southern, 2, _), (.Southern, 3, 1...15):
            return .cumulonimbus
        case (.Southern, 3, 16...31), (.Southern, 4, _), (.Southern, 5, _):
            return .cirrus
        case (.Southern, 6, _), (.Southern, 7, _), (.Southern, 8, _):
            return .billow
        case (.Southern, 9, _), (.Southern, 10, _), (.Southern, 11, _):
            return .thin
        default:
            return .none
        }
    }
    
    func isHeavyShowerPattern(pattern: Pattern) -> Bool {
        return pattern == .Fine00
    }
    
    func isLightShowerPattern(pattern: Pattern) -> Bool {
        switch pattern {
        case .Fine02, .Fine04, .Fine06:
            return true
        default:
            return false
        }
    }
    
    func dayUsesTypes(day: DayInfo) -> Bool {
        let dt = day.dayType
        if dt == DayType.noData { return true }
        if dt == DayType.none { return true }
        if dt == DayType.shower && day.showerType != ShowerType.heavy { return true }
        return false
    }
    
    func checkTypeMatch(realType: Weather, expected: Any) -> Bool {
        switch expected {
        case AmbiguousWeather.clearOrSunny:
            return realType == Weather.clear || realType == Weather.sunny
        case AmbiguousWeather.sunnyOrCloudy:
            return realType == Weather.sunny || realType == Weather.cloudy
        case AmbiguousWeather.cloudyOrRainClouds:
            return realType == Weather.cloudy || realType == Weather.rainClouds
        case AmbiguousWeather.rainOrHeavyRain:
            return realType == Weather.rain || realType == Weather.heavyRain
        case AmbiguousWeather.noRain:
            return !(realType == Weather.rain || realType == Weather.heavyRain)
        default:
            return realType == expected as! Weather
        }
    }
    
    func getWeather(hour: UInt8, pattern: Pattern) -> Weather {
        let patternIndex = Int(pattern.rawValue)
        let hourIndex = Int(hour)
        return Patterns[patternIndex][hourIndex]
    }
    
    func getOldWeather(hour: Int, pat: Pattern) -> Weather? {
        if pat == Pattern.Fine02 {
            // Pre-v1.3.0
            if hour == 18 { return Weather.sunny }
            if hour == 19 { return Weather.cloudy }
        } else if pat == Pattern.Fine06 {
            // Pre-v1.3.0
            if hour == 17 { return Weather.sunny }
            if hour == 19 { return Weather.cloudy }
        }
        return nil
    }
    
    func isSpecialCloudEntryAllowed(claimedWeather: Any, cloudLevel: CloudLevel, hour: Int) -> Bool {
        if claimedWeather as! Weather != Weather.clear && claimedWeather as! Weather != Weather.sunny && claimedWeather as! AmbiguousWeather != AmbiguousWeather.clearOrSunny { return false }
        switch cloudLevel {
        case CloudLevel.cumulonimbus:
            return hour >= 9 && hour <= 20
        case CloudLevel.cirrus:
            return hour >= 6 || hour <= 3
        case CloudLevel.billow:
            return hour >= 6 && hour <= 16
        case CloudLevel.thin:
            return hour >= 6 || hour <= 3
        default:
            return false
        }
    }
    
    func getPatternKind(pat: Pattern) -> PatternKind {
        switch pat {
        case .Fine00, .Fine01, .Fine02, .Fine03, .Fine04, .Fine05, .Fine06:
            return .Fine
        case .Cloud00, .Cloud01, .Cloud02:
            return .Cloud
        case .Rain00, .Rain01, .Rain02, .Rain03, .Rain04, .Rain05:
            return .Rain
        case .FineCloud00, .FineCloud01, .FineCloud02:
            return .FineCloud
        case .CloudFine00, .CloudFine01, .CloudFine02:
            return .CloudFine
        case .FineRain00, .FineRain01, .FineRain02, .FineRain03:
            return .FineRain
        case .CloudRain00, .CloudRain01, .CloudRain02:
            return .CloudRain
        case .RainCloud00, .RainCloud01, .RainCloud02:
            return .RainCloud
        case .Commun00:
            return .Commun
        case .EventDay00:
            return .EventDay
        }
    }
    
    func checkPatternAgainstTypes(pat: Pattern, cloudLevel: CloudLevel, types: [WeatherTypeInfo]) -> Bool {
        for typeInfo in types {
            let hour = typeInfo.time
            let claimedWeather = typeInfo.type
            let realWeather = getWeather(hour: UInt8(hour), pattern: pat)
            if !checkTypeMatch(realType: realWeather, expected: claimedWeather) {
                // allow for discrepancies
                let oldWeather = getOldWeather(hour: hour, pat: pat)
                if oldWeather == nil || checkTypeMatch(realType: oldWeather!, expected: claimedWeather) { return false }
            }
            if typeInfo.specialCloud! && isSpecialCloudEntryAllowed(claimedWeather: claimedWeather, cloudLevel: cloudLevel, hour: hour) {
                switch cloudLevel {
                case CloudLevel.cumulonimbus:
                    if !cumulonimbusPatterns.contains(getPatternKind(pat: pat)) { return false }
                    break
                case CloudLevel.cirrus:
                    if !cirrusPatterns.contains(getPatternKind(pat: pat)) { return false }
                    break
                default:
                    break
                }
            }
        }
        return true
    }
    
    func getPossiblePatternsForDay(hemisphere: Hemisphere, day: DayInfo) -> [Pattern] {
        var results: [Pattern] = []
        let cloudLevel: CloudLevel = getCloudLevel(hemi: hemisphere, month: UInt8(day.m), day: UInt8(day.d))

        for pat in 0...maxPattern.rawValue {
            let isHeavy = isHeavyShowerPattern(pattern: Pattern(rawValue: pat)!)
            if day.dayType == DayType.shower {
                // Showers restrict patterns according to the specified shower type
                let isLight = isLightShowerPattern(pattern: Pattern(rawValue: pat)!)
                if isLight && day.showerType == ShowerType.heavy { continue }
                if isHeavy && day.showerType == ShowerType.light { continue }
                if !isLight && !isHeavy { continue }
            } else if day.dayType == DayType.rainbow {
                // Rainbows have one pattern determined by the rainbow time
                if pat != rainbowPatternsByTime[day.rainbowTime]?.rawValue { continue }
            } else if day.dayType == DayType.aurora {
                // Aurorae have three patterns, no easy way to distinguish
                // so we leave it to the user
                if pat == Pattern.Fine01.rawValue {
                    if !day.auroraFine01 { continue }
                } else if pat == Pattern.Fine03.rawValue {
                    if !day.auroraFine03 { continue }
                } else if pat == Pattern.Fine05.rawValue {
                    if !day.auroraFine05 { continue }
                } else {
                    continue
                }
            } else if day.dayType == DayType.none {
                // Exclude heavy showers if 'None of the above' is selected
                // since they're pretty hard to miss
                if isHeavy { continue }
            }

            // TODO: isPatternPossibleAtDate
            // if !isPatternPossibleAtDate(hemisphere, day.m, day.d, pat) { continue }

            if dayUsesTypes(day: day) && !checkPatternAgainstTypes(pat: Pattern(rawValue: pat)!, cloudLevel: cloudLevel, types: day.types) { continue }

            results.append(Pattern(rawValue: pat)!)
        }

        return results
    }
}
