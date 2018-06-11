extension Route {
    public enum MobilitySettings: Encodable {
        //swiftlint:disable:next nesting
        public enum PreconfiguredMobilitySettings: String, Encodable {
            case none = "None"
            case medium = "Medium"
            case high = "High"
        }

        //swiftlint:disable:next nesting
        public struct IndividualMobilitySettings: Encodable {
            //swiftlint:disable:next nesting
            public enum EntranceOption: String, Encodable {
                case any = "Any"
                case small = "Small"
                case noStep = "NoStep"
            }

            public let noSolidStairs: Bool
            public let noEscalators: Bool
            public let minimumInterchangeCount: Bool
            public let entranceOption: EntranceOption

            //swiftlint:disable:next nesting
            private enum CodingKeys: String, CodingKey {
                case noSolidStairs = "solidStairs"
                case noEscalators = "escalators"
                case minimumInterchangeCount = "leastChange"
                case entranceOption = "entrance"
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case ._preconfigured(let preconfiguredRestriction): try container.encode(preconfiguredRestriction)
            case ._individual(let individualRestriction): try container.encode(individualRestriction)
            }
        }

        /// Please use `.none`, `.medium` or `.high` instead of this.
        case _preconfigured(PreconfiguredMobilitySettings) // swiftlint:disable:this identifier_name
        /// Please use `.individual(...:)` instead of this.
        case _individual(IndividualMobilitySettings) // swiftlint:disable:this identifier_name

        /// "Ohne Einschränkungen"
        public static let none = MobilitySettings._preconfigured(.none)
        /// "Rollator, Kinderwagen"
        public static let medium = MobilitySettings._preconfigured(.medium)
        /// "Rollstuhlfahrer ohne Hilfe"
        public static let high = MobilitySettings._preconfigured(.high)

        public static func individual(noSolidStairs: Bool,
                                      noEscalators: Bool,
                                      minimumInterchangeCount: Bool,
                                      entranceOption: IndividualMobilitySettings.EntranceOption)
            -> MobilitySettings {
                let settings = IndividualMobilitySettings(noSolidStairs: noSolidStairs,
                                                          noEscalators: noEscalators,
                                                          minimumInterchangeCount: minimumInterchangeCount,
                                                          entranceOption: entranceOption)
                return ._individual(settings)
        }
    }
}
