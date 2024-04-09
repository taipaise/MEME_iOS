//
//  ModelHomeViewItem.swift
//  MEME
//
//  Created by 정민지 on 4/3/24.
//

enum ModelHomeViewControllerSection {
    case modelReservations
    case recommendByReview
    case recommendByRecent
}

enum ModelHomeViewControllerItem: Hashable {
    case modelReservations(ReservationData)
    case recommendByReview(Portfolio)
    case recommendByRecent(Portfolio)
    case noData(String)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .modelReservations(let reservationData):
            hasher.combine(reservationData.reservationId)
        case .recommendByReview(let portfolio), .recommendByRecent(let portfolio):
            hasher.combine(portfolio.portfolioId)
        case .noData(let uniqueString):
            hasher.combine(uniqueString)
        }
    }
    
    static func ==(lhs: ModelHomeViewControllerItem, rhs: ModelHomeViewControllerItem) -> Bool {
        switch (lhs, rhs) {
        case (.modelReservations(let lhsData), .modelReservations(let rhsData)):
            return lhsData.reservationId == rhsData.reservationId
        case (.recommendByReview(let lhsPortfolio), .recommendByReview(let rhsPortfolio)),
            (.recommendByRecent(let lhsPortfolio), .recommendByRecent(let rhsPortfolio)):
            return lhsPortfolio.portfolioId == rhsPortfolio.portfolioId
        default:
            return false
        }
    }
}
