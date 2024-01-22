//
//  ModelReservationChartTableViewController.swift
//  MEME
//
//  Created by 정민지 on 1/20/24.
//

import UIKit
import SnapKit

class ModelReservationChartViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private var selectedButton: ModelReservationTypeButton?
    
    // MARK: - Properties
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.backgroundColor = UIColor.white
        
        return backButton
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "예약하기"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let buttonScrollView = UIScrollView()
    private let buttonsStackView = UIStackView()
    
    
    private let allButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("전체", for: .normal)

        return button
    }()
    private let specialButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("특수 메이크업", for: .normal)

        return button
    }()
    private let actorButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("배우 메이크업", for: .normal)

        return button
    }()
    private let interviewButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("면접 메이크업", for: .normal)

        return button
    }()
    private let dailyButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("데일리 메이크업", for: .normal)

        return button
    }()
    private let studioButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("스튜디오 메이크업", for: .normal)

        return button
    }()
    private let weddingButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("웨딩 메이크업", for: .normal)

        return button
    }()
    private let partyButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("파티/이벤트 메이크업", for: .normal)
        
        return button
    }()
    private let etcButton: ModelReservationTypeButton = {
        let button = ModelReservationTypeButton()
        button.setTitle("기타 메이크업", for: .normal)

        return button
    }()


    
    
    private var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private var numLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.textColor = .black
        label.font = .pretendard(to: .bold, size: 12)
        
        return label
    }()
    private var searchNumLabel: UILabel = {
        let label = UILabel()
        label.text = "개의 검색 결과"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 12)
        
        return label
    }()
    private let sortButton: SortOptionButton = {
        let button = SortOptionButton()
        button.text = "리뷰순"
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "icon_align"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBold.cgColor
        button.layer.cornerRadius = 17
        
        
        return button
    }()
    private var reservationChartTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupButtonsStackView()
        setupButtonsAction()
        selectButton(allButton)
        setupReservationChartTableView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        buttonScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(buttonScrollView)
        view.addSubview(lineView)
        view.addSubview(numLabel)
        view.addSubview(searchNumLabel)
        view.addSubview(sortButton)
        reservationChartTableView.backgroundColor = .white
        view.addSubview(reservationChartTableView)
        
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        backButton.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints {make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.centerX.equalToSuperview()
        }
        buttonScrollView.snp.makeConstraints {make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.5)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        lineView.snp.makeConstraints {make in
            make.top.equalTo(buttonScrollView.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
        sortButton.snp.makeConstraints {make in
            make.top.equalTo(lineView.snp.bottom).offset(17)
            make.trailing.equalToSuperview().offset(-24)
        }
        numLabel.snp.makeConstraints {make in
            make.centerY.equalTo(sortButton.snp.centerY)
            make.leading.equalToSuperview().offset(24)
        }
        searchNumLabel.snp.makeConstraints {make in
            make.centerY.equalTo(numLabel.snp.centerY)
            make.leading.equalTo(numLabel.snp.trailing)
        }
        reservationChartTableView.snp.makeConstraints {make in
            make.top.equalTo(sortButton.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
    }
    //MARK: -Action
    private func setupButtonsAction() {
            let buttons = [
                allButton,
                specialButton,
                actorButton,
                interviewButton,
                dailyButton,
                studioButton,
                weddingButton,
                partyButton,
                etcButton
            ]
            buttons.forEach { button in
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            }
        }

        @objc func buttonTapped(_ sender: ModelReservationTypeButton) {
            selectButton(sender)
        }

        private func selectButton(_ button: ModelReservationTypeButton) {
            selectedButton?.backgroundColor = .white
            button.backgroundColor = .mainBold
            selectedButton = button
        }
    
    @objc func sortButtonTapped() {
        let sortOptionsVC = SortOptionsViewController()
        sortOptionsVC.modalPresentationStyle = .custom
        sortOptionsVC.transitioningDelegate = self
        sortOptionsVC.onOptionSelected = { [weak self] selectedTitle in
            self?.sortButton.text = selectedTitle
        }
        self.present(sortOptionsVC, animated: true)
        }
    
       func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
           return ModalPresentationController(presentedViewController: presented, presenting: presenting)
       }
   
    
    //MARK: -Helpers
    private func setupButtonsStackView() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 5
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillProportionally
        buttonScrollView.addSubview(buttonsStackView)
        [allButton, specialButton, actorButton, interviewButton, dailyButton, studioButton, weddingButton, partyButton, etcButton].forEach { button in
            buttonsStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.greaterThanOrEqualTo(54)
            }
        }

        buttonScrollView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(10)
        }
        buttonScrollView.contentSize = buttonsStackView.intrinsicContentSize
    }
    private func setupReservationChartTableView() {
        reservationChartTableView = UITableView()
        
        //delegate 연결
        reservationChartTableView.delegate = self
        reservationChartTableView.dataSource = self
        
        //cell 등록
        let ModelReservationChartTableViewCell = UINib(nibName: "ModelReservationChartTableViewCell", bundle: nil)
        reservationChartTableView.register(ModelReservationChartTableViewCell, forCellReuseIdentifier: "ModelReservationChartTableViewCell")
        
    }



    // MARK: - Navigation


}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelReservationChartViewController: UITableViewDataSource, UITableViewDelegate {

    //cell의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //api 호출 한 수 만큼 수정
        return 10
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ModelReservationChartTableViewCell", for: indexPath) as? ModelReservationChartTableViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 141
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let reservationVC = ModelReservationViewController()
            // 전달할 데이터 추가
            self.navigationController?.pushViewController(reservationVC, animated: true)
        }

}

