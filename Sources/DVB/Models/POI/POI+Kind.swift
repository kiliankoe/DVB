extension POI {
    public enum Kind: String {
        case rentABike = "RentABike"
        case stop = "Stop"
        case poi = "Poi"
        case carSharing = "CarSharing"
        case ticketMachine = "TicketMachine"
        case platform = "Platform"
        case parkAndRide = "ParkAndRide"
    }
}

extension POI.Kind: Equatable {}

extension POI.Kind: Hashable {}

#if swift(>=4.2)
extension POI.Kind: CaseIterable {}
#else
extension POI.Kind {
    public static var allCases: [POI.Kind] {
        return [.rentABike, .stop, .poi, .carSharing, .ticketMachine, .platform, .parkAndRide]
    }
}
#endif
