//
//  EntireArtistReservationManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class EntireArtistReservationManageViewController: UIViewController {
    
    @IBOutlet var onComingButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    
    @IBOutlet var artistReservationTableView: UITableView!
    // 더미 데이터
    private var makeUpNameArray : [String] = ["메이크업1","메이크업2","메이크업3"]
    private var modelNameArray : [String] = ["모델1","모델2","모델3"]
    private var reservationDateArray : [String] = ["2024.01.01 월","2024.01.02 화","2024.01.03 수"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewConfigure()
    }
    
    private func tableViewConfigure(){
        artistReservationTableView.delegate = self
        artistReservationTableView.dataSource = self
        artistReservationTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reservationManagedBtnTapped(){
        let vc = ArtistReservationSingleManageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension EntireArtistReservationManageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makeUpNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = artistReservationTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell
        cell?.makeUpNameLabel.text = makeUpNameArray[indexPath.row]
        cell?.modelNameLabel.text = modelNameArray[indexPath.row]
        cell?.reservationDateLabel.text = reservationDateArray[indexPath.row]
        cell?.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell ?? UITableViewCell()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)

    }
    
}
