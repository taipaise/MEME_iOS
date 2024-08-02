//
//  ArtistReservationSingleManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class SingleReservationManageViewController: UIViewController {
    //MARK: - UI Properties
    @IBOutlet weak var cancelBarView: UIView!
    @IBOutlet weak var cancelBarLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIButton!
    @IBOutlet weak var confirmReservationBarView: UIView!
    @IBOutlet weak var confirmReservationBarButton: UIButton!
    @IBOutlet weak var confirmReservationBarLabel: UILabel!
    @IBOutlet weak var modelInfoFrameView: UIView!
    @IBOutlet weak var modelInfoView: UIView!
    @IBOutlet weak var makeupCategoryLabel: UILabel!
    @IBOutlet weak var modelNicknameLabel: UILabel!
    @IBOutlet weak var modelSkinTypeLabel: UILabel!
    @IBOutlet weak var modelGenderLabel: UILabel!
    @IBOutlet weak var modelPersonalColorLabel: UILabel!
    @IBOutlet weak var makeupNameLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationTimeLabel: UILabel!
    @IBOutlet weak var reservationPlaceLabel: UILabel!
    @IBOutlet weak var reservationPriceLabel: UILabel!
    @IBOutlet weak var reservationEmailLabel: UILabel!
    @IBOutlet weak var modelInfoLabel: UILabel!
    
    //MARK: - Properties
    private var reservationData: ReservationDetailData!
    private var reservationId: Int!
    
    //MARK: - ViewController 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configure()
    }
    required init(reservationId: Int) {
        self.reservationId = reservationId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setUI()
    private func setUI(){
        navigationItem.title = "예약 관리"
        cancelBarView.layer.cornerRadius=10
        confirmReservationBarView.layer.cornerRadius=10
        
        modelInfoLabel.text = KeyChainManager.read(forkey: .role) == RoleType.ARTIST.rawValue ? "모델 정보" : "나의 정보"
        modelInfoFrameView.layer.borderColor = UIColor.mainBold.cgColor
        modelInfoFrameView.layer.borderWidth = 1.3
        
        modelInfoView.layer.cornerRadius=10
        modelInfoView.layer.shadowColor = UIColor.gray500.cgColor
        modelInfoView.layer.shadowOpacity = 0.25
        modelInfoView.layer.shadowRadius = 4
        modelInfoView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 5, y: 7, width: modelInfoView.bounds.width-22, height: modelInfoView.bounds.height)).cgPath
        modelInfoView.layer.masksToBounds = false
        
        modelInfoFrameView.layer.cornerRadius=10
    }
    
    func configure(){
        //TODO: API Response DTO 수정 후 재작성
        if isToday(Date()){
            cancelBarView.isHidden = true
            confirmReservationBarLabel.text = "당일 예약은 취소 불가합니다"
        }
    }
    
    @IBAction private func reservationCancelBtnDidTap(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "예약 취소하기",
            message: "\n예약을 취소하시겠습니까? 취소 시 모델에게 취소 알림이 전송됩니다.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "예",
            style: .default
        ) { [weak self] _ in
            self?.patchReservation(reservationId: self?.reservationData.reservationId ?? 0)
            if let navigationController = self?.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        let noAction = UIAlertAction(
            title: "아니오",
            style: .cancel,
            handler : nil
        )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
}

extension SingleReservationManageViewController{
    func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (E)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }
}

//MARK: - API 호출
extension SingleReservationManageViewController {
    func patchReservation(reservationId: Int) {
        ReservationManager.shared.patchReservation(
            reservationId: reservationId,
            status: .CANCEL
            ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("예약 상태 변경 성공: \(response)")
                case .failure(let error):
                    print("예약 상태 변경 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    //TODO: - 예약 확정 API 호출
    func confirmReservation(){
        
    }
    //TODO: - 예약 상세 조회 API 호출
    func getReservationDetail(){
        
    }
}

