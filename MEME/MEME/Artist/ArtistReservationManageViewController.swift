//
//  ArtistReservationManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistReservationManageViewController: UIViewController {
    @IBOutlet var artistReservationTableView: UITableView!
    @IBOutlet var onComingButton: UIButton!
    @IBOutlet var completeButton: UIButton!
    private var showOnComing : Bool = true
    
    // 더미 데이터
    private var makeUpNameArray : [String] = ["메이크업1","메이크업2","메이크업3"]
    private var modelNameArray : [String] = ["모델1","모델2","모델3"]
    private var reservationDateArray : [String] = ["2024.01.01 월","2024.01.02 화","2024.01.03 수"]
    private var onComingArray : [Bool] = [false,false,true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
    }
    private func tableViewConfigure(){
        artistReservationTableView.delegate = self
        artistReservationTableView.dataSource = self
        artistReservationTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    @objc private func reservationManagedBtnTapped(){
        let vc = ArtistReservationSingleManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onComingButtonTapped(_ sender: UIButton) {
        showOnComing = true
        onComingButton.setImage(UIImage(resource: .icCheckFill), for: .normal)
        completeButton.setImage(UIImage(resource: .icCheckEmpty), for: .normal)
        artistReservationTableView.reloadData()
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        showOnComing = false
        completeButton.setImage(UIImage(resource: .icCheckFill), for: .normal)
        onComingButton.setImage(UIImage(resource: .icCheckEmpty), for: .normal)
        artistReservationTableView.reloadData()
    }
}


extension ArtistReservationManageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = artistReservationTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = makeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = modelNameArray[indexPath.row]
        cell.reservationDateLabel.text = reservationDateArray[indexPath.row]
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        if !onComingArray[indexPath.row]{
            cell.reservationTimeLabel.textColor = UIColor(resource: .gray500)
            cell.reservationPlaceIconImage.image = UIImage(resource: .icMapNotAvilable)
            cell.reservationPriceIconLabel.textColor = UIColor(resource: .gray500)
        }
        if (showOnComing && onComingArray[indexPath.row]) || (!showOnComing && !onComingArray[indexPath.row]) {
            return cell
        } else {
            return UITableViewCell()
        }


    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (showOnComing == onComingArray[indexPath.row]) ? CGFloat(192) : CGFloat(0)
    }
    
}
