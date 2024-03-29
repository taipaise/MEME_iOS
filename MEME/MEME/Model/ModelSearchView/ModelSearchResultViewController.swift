//
//  ModelSearchResultViewController.swift
//  MEME
//
//  Created by 정민지 on 2/13/24.
//

import UIKit
import SnapKit

protocol ModelSearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidFinish(_ controller: ModelSearchResultViewController)
}

class ModelSearchResultViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: ModelSearchResultViewControllerDelegate?
    
    var selectedCategory: String?
    var selectedArtistId: Int?
    var searchKeyword: String?
    var selectedSortOption: String = "리뷰 순"
    
    var currentPage: Int = 0
    var totalPage: Int = 1
    var isLoading: Bool = false
    var searchResults: [SearchResultData] = []
    private var isLastPage: Bool {
        return currentPage >= totalPage-1
    }
    var isShowingEmptyState: Bool = false
    
    var searchCategory: Bool = false
    var searchArtist: Bool = false
    var searchText: Bool = false
    var searchAll: Bool = false
    
    private var navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        
        return button
    }()
    private let searchMakeup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "원하는 메이크업을 검색해보세요."
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 20
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.mainBold.cgColor
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        let textField = searchBar.searchTextField
            textField.backgroundColor = .white
            textField.textColor = .black
        
        if let leftView = textField.leftView as? UIImageView {
            leftView.tintColor = .mainBold
            }
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.mainBold]
            textField.attributedPlaceholder = NSAttributedString(string: "원하는 메이크업을 검색해보세요.", attributes: placeholderAttributes)
        searchBar.tintColor = .mainBold
        searchBar.isUserInteractionEnabled = true
        
        return searchBar
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
    private var emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 16)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        if let category = selectedCategory {
            fetchSearchResultsByCategory(category)
        } else if let keyword = searchKeyword, !keyword.isEmpty {
            searchMakeup.text = keyword
            fetchSearchResultsByText(keyword)
        } else if let artistId = selectedArtistId {
            fetchSearchResultsByArtist(artistId)
        } else {
            fetchSearchResultsAll(page: currentPage)
        }
        
        setupDismissKeyboardOnTapGesture()
        setupReservationChartTableView()
        configureSubviews()
        makeConstraints()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(backButton)
        searchMakeup.delegate = self
        navigationBarView.addSubview(searchMakeup)
        view.addSubview(numLabel)
        view.addSubview(searchNumLabel)
        view.addSubview(sortButton)
        reservationChartTableView.backgroundColor = .white
        view.addSubview(reservationChartTableView)
        
    }
    
    // MARK: - makeConstraints
    func makeConstraints() {
        navigationBarView.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        backButton.snp.makeConstraints {make in
            make.leading.equalTo(navigationBarView.snp.leading).offset(24)
            make.centerY.equalTo(navigationBarView.snp.centerY)
            make.width.equalTo(24)
        }
        searchMakeup.snp.makeConstraints {make in
            make.centerY.equalTo(navigationBarView.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(13)
            make.trailing.equalTo(navigationBarView.snp.trailing).offset(-24.26)
            make.height.equalTo(40)
        }
        
        sortButton.snp.makeConstraints {make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(17)
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
    func saveSearchKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: "recentSearchKeywords") ?? []
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
        }
        keywords.insert(keyword, at: 0)
        if keywords.count > 10 {
            keywords.removeLast()
        }
        UserDefaults.standard.set(keywords, forKey: "recentSearchKeywords")
    }
    
    @objc func backButtonTapped() {
        delegate?.searchResultViewControllerDidFinish(self)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sortButtonTapped() {
        let sortOptionsVC = SortOptionsViewController()
        sortOptionsVC.modalPresentationStyle = .custom
        sortOptionsVC.transitioningDelegate = self
        sortOptionsVC.onOptionSelected = { [weak self] selectedTitle in
            self?.sortButton.text = selectedTitle
            self?.selectedSortOption = selectedTitle
            self?.currentPage = 0
            self?.searchResults.removeAll()
            self?.reservationChartTableView.reloadData()
            
            if let category = self?.selectedCategory {
                self?.fetchSearchResultsByCategory(category)
            } else if let keyword = self?.searchKeyword, !keyword.isEmpty {
                self?.fetchSearchResultsByText(keyword)
            } else if let artistId = self?.selectedArtistId {
                self?.fetchSearchResultsByArtist(artistId)
            } else {
                self?.fetchSearchResultsAll(page: self?.currentPage)
            }
        }
        self.present(sortOptionsVC, animated: true)
        }
   
    
    //MARK: -Helpers
    private func mapSortParameter(from selectedSortOption: String) -> SearchSort? {
        switch selectedSortOption {
        case "리뷰 순":
            return .review
        case "가격 낮은 순":
            return .asc
        case "가격 높은 순":
            return .desc
        default:
            return nil
        }
    }

    private func mapCategoryNameToSearchCategory(_ name: String) -> SearchCategory? {
        switch name {
        case "데일리 메이크업":
            return .DAILY
        case "배우 메이크업":
            return .ACTOR
        case "면접 메이크업":
            return .INTERVIEW
        case "파티/이벤트\n메이크업":
            return .PARTY
        case "웨딩 메이크업":
            return .WEDDING
        case "특수 메이크업":
            return .PROSTHETIC
        case "스튜디오\n메이크업":
            return .STUDIO
        case "기타(속눈썹,\n퍼스널 컬러)":
            return .ETC
        default:
            return nil
        }
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
}

//MARK: -UITableViewDataSource, UITableViewDelegate
extension ModelSearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    //cell의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    //cell의 생성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ModelReservationChartTableViewCell", for: indexPath) as? ModelReservationChartTableViewCell else {
                fatalError("셀 타입 캐스팅 실패...")
            }
            cell.selectionStyle = .none
            let data = searchResults[indexPath.row]
            cell.configure(with: data)
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 141
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservationVC = ModelReservationViewController()
        let portfolioID = searchResults[indexPath.row].portfolioId
        reservationVC.portfolioID = portfolioID
        self.navigationController?.pushViewController(reservationVC, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension ModelSearchResultViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY + height >= contentHeight, !isLoading, !isShowingEmptyState, currentPage < totalPage {
            currentPage += 1
            
            if searchCategory, let category = self.selectedCategory {
                self.fetchSearchResultsByCategory(category)
            } else if searchText, let keyword = self.searchKeyword, !keyword.isEmpty {
                self.fetchSearchResultsByText(keyword)
            } else if searchArtist, let artistId = self.selectedArtistId {
                self.fetchSearchResultsByArtist(artistId)
            } else {
                self.fetchSearchResultsAll(page: self.currentPage)
            }
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension ModelSearchResultViewController {
    func setupDismissKeyboardOnTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension ModelSearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        searchResults.removeAll()
        reservationChartTableView.reloadData()
        
        isLoading = false
        saveSearchKeyword(query)
        currentPage = 0
        fetchSearchResultsByText(query)
        
        searchBar.resignFirstResponder()
    }
}



//MARK: - UIViewControllerTransitioningDelegate
extension ModelSearchResultViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}



//MARK: -API 통신 메소드
extension ModelSearchResultViewController {
    //카테고리 검색
    func fetchSearchResultsByCategory(_ categoryName: String) {
        searchCategory = true
        searchArtist = false
        searchText = false
        searchAll = false
        
        guard let searchCategory = mapCategoryNameToSearchCategory(categoryName),
              !isLoading else {
            return
        }
        isLoading = true
        
        let sortParameter = mapSortParameter(from: selectedSortOption)
        SearchManager.shared.getSearchCategory(category: searchCategory, page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("카테고리 검색 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    
    //아티스트 검색
    func fetchSearchResultsByArtist(_ artistId: Int) {
        searchCategory = false
        searchArtist = true
        searchText = false
        searchAll = false
        
        guard !isLoading else { return }
        isLoading = true
        
        let sortParameter = mapSortParameter(from: selectedSortOption)
        SearchManager.shared.getSearchArtist(artistId: artistId, page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("아티스트 검색 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    
    //최근 검색어 검색 & text 검색
    func fetchSearchResultsByText(_ query: String) {
        searchCategory = false
        searchArtist = false
        searchText = true
        searchAll = false
        
        guard !isLoading else { return }
        isLoading = true
        
        let sortParameter = mapSortParameter(from: selectedSortOption)
        SearchManager.shared.getSearchText(query: query, page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("text 검색 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    
    //검색 text가 null일 경우 전체 검색
    func fetchSearchResultsAll(page: Int? = nil) {
        searchCategory = false
        searchArtist = false
        searchText = false
        searchAll = true
        
        guard !isLoading else { return }
        isLoading = true
        
        let sortParameter = mapSortParameter(from: selectedSortOption)
        SearchManager.shared.getSearchAll(page: currentPage, sort: sortParameter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let searchResultDTO):
                    self.handleSearchResults(searchResultDTO)
                case .failure(let error):
                    self.numLabel.text = "0"
                    if let responseData = error.response {
                        let responseString = String(data: responseData.data, encoding: .utf8)
                        print("전체 검색 실패: \(responseString ?? "no data")")
                    }
                    self.totalPage = 0
                    self.isShowingEmptyState = true
                    self.reservationChartTableView.reloadData()
                }
            }
        }
    }
    private func handleSearchResults(_ searchResultDTO: SearchResultDTO) {
        searchResults.removeAll()
        
        if let totalNumber = searchResultDTO.data?.totalNumber {
            self.numLabel.text = "\(totalNumber)"
        } else {
            self.numLabel.text = "0"
        }
        
        if let content = searchResultDTO.data?.content, !content.isEmpty {
            isShowingEmptyState = false
            searchResults.append(contentsOf: content)
            reservationChartTableView.reloadData()
            emptyStateView.isHidden = true
        } else {
            emptyStateView.isHidden = false
        }
        
        totalPage = searchResultDTO.data?.totalPage ?? 0
    }
}
