extension Route {
    public struct StandardSettings: Encodable {
        //swiftlint:disable:next nesting
        public enum MaxChangeCount: String, Encodable {
            /// "Nur Direktverbindungen"
            case none = "None"
            case one = "One"
            case two = "Two"
            case unlimited = "Unlimited"
        }

        let maximumInterchangeCount: MaxChangeCount

        //swiftlint:disable:next nesting
        public enum WalkingSpeed: String, Encodable {
            case verySlow = "VerySlow"
            case slow = "Slow"
            case normal = "Normal"
            case fast = "Fast"
            case veryFast = "VeryFast"
        }

        let walkingSpeed: WalkingSpeed

        //swiftlint:disable:next nesting
        public enum FootpathDistance: Int, Encodable {
            case five = 5
            case ten = 10
            case fifteen = 15
            case twenty = 20
            case thirty = 30
        }

        let footpathDistanceToStop: FootpathDistance

        let modes: [Mode]
        /// "Nahegelegene Alternativhaltestellen einschließen"
        let includeAlternativeStops: Bool

        public static var `default`: StandardSettings {
            return StandardSettings(maximumInterchangeCount: .unlimited,
                                    walkingSpeed: .normal,
                                    footpathDistanceToStop: .five,
                                    modes: Mode.allRequest,
                                    includeAlternativeStops: true)
        }

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case maximumInterchangeCount = "maxChanges"
            case walkingSpeed
            case footpathDistanceToStop = "footpathToStop"
            case modes = "mot"
            case includeAlternativeStops
        }
    }
}
