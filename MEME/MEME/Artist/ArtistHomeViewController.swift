//
//  ArtistHomeViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit

class ArtistHomeViewController: UIViewController {
    @IBOutlet var artistHomeProfileStatusView: UIView!
    @IBOutlet var secondArtistHomeProfileStatusView: UIView!
    @IBOutlet var artistHomeProfileNoStatusView: UIView!
    @IBOutlet var artistProfileImageView: UIImageView!
    @IBOutlet var artistHomeProfileLabel: UILabel!
    @IBOutlet var artistReservationStatusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
        tableViewConfigure()
    }
    private func uiSet(){
        if(TodayRes==0){
            artistHomeProfileNoStatusView.isHidden = false
            artistHomeProfileStatusView.isHidden = true
            secondArtistHomeProfileStatusView.isHidden = true
        }else if(TodayRes==1){
            artistHomeProfileNoStatusView.isHidden = true
            artistHomeProfileStatusView.isHidden = false
            secondArtistHomeProfileStatusView.isHidden = true
        }else{
            artistHomeProfileNoStatusView.isHidden = true
            artistHomeProfileStatusView.isHidden = false
            secondArtistHomeProfileStatusView.isHidden = false
        }
        
        
        
        artistHomeProfileStatusView.layer.cornerRadius = 10
        artistHomeProfileNoStatusView.layer.cornerRadius = 10
        secondArtistHomeProfileStatusView.layer.cornerRadius = 10
        
        artistProfileImageView.layer.cornerRadius = artistProfileImageView.frame.height/2
        artistProfileImageView.clipsToBounds = true
        
        artistHomeProfileLabel.text = "안녕하세요, 00님!\n내일 예약 " + String(tomorrowRes) + "건이 있어요."
    }
    
    private func tableViewConfigure(){
        artistReservationStatusTableView.delegate = self
        artistReservationStatusTableView.dataSource = self
        artistReservationStatusTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }

    @IBAction private func profileImageTapped(_ sender: UIButton) {
        let vc = ArtistProfilePreviewViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func portfolioManageBtnTapped(_ sender: UIButton) {
        let vc = ArtistPortfolioManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func entireReservationBtnTapped(_ sender: UIButton) {
        let vc = EntireArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func reservationManagedBtnTapped(){
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArtistHomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(resMakeUpNameArray.count>2) {
            return 2
        } else {
            return resMakeUpNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = artistReservationStatusTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = resMakeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = resModelNameArray[indexPath.row]
        cell.reservationDateLabel.text = resDateArray[indexPath.row]
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)
    }
    
    
    
}
