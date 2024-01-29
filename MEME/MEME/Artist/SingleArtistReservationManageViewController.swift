//
//  ArtistReservationSingleManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class SingleArtistReservationManageViewController: UIViewController {
    
    @IBOutlet var cancelBarView: UIView!
    @IBOutlet var cancelBarLabel: UILabel!
    @IBOutlet var cancelBarButton: UIButton!
    @IBOutlet var resInfoFrameView: UIView!
    
    private var isToday: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        // Do any additional setup after loading the view.
    }

    private func uiSet(){
        self.navigationController?.isNavigationBarHidden = true
        cancelBarView.layer.cornerRadius=10
        resInfoFrameView.layer.cornerRadius=10
        if isToday {
            cancelBarView.backgroundColor = .gray500
            cancelBarLabel.text = "당일 예약은 취소가 불가능합니다"
            cancelBarButton.isHidden = true
        }else{
            cancelBarView.backgroundColor = .systemRed
            cancelBarLabel.text = "예약 취소하기"
            cancelBarButton.isHidden = false
        }
    }
    
    @IBAction private func backBtnDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func reservationCancelBtnDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "예약 취소하기", message: "\n예약을 취소하시겠습니까? 취소 시 모델에게 취소 알림이 전송됩니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : nil )
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler : nil )
        // HIG에 따라 Cancel이 왼쪽
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
    


}
