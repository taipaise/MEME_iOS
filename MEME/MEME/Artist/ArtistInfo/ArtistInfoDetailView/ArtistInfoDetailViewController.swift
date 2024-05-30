import UIKit

protocol ArtistInfoUpdateDelegate: AnyObject {
    // Define necessary delegate methods
}

final class ArtistInfoDetailViewController: UIViewController, ArtistInfoUpdateDelegate {
    weak var delegate: ArtistInfoUpdateDelegate?

    typealias TimeCell = ArtistTimeCollectionViewCell
    typealias DataSource = UICollectionViewDiffableDataSource<TimeSection, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<TimeSection, String>
    typealias HeaderView = ArtistTimeHeaderSupplementaryView

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private var fieldButtons: [UIButton]!
    @IBOutlet private var locationButtons: [UIButton]!
    @IBOutlet private var locationCheckImages: [UIImageView]!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet var timeViews: [UIView]!
    @IBOutlet private var weekButtons: [UIButton]!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var completeButton: UIButton!
    @IBOutlet private var timeSetButtons: [UIButton]!

    private var dataSource: DataSource?
    private var snapShot: SnapShot?
    var response: ArtistProfileResponse?
    var getresponse: ArtistProfileInfoResponse?

    private var selectedFields: Set<Int> = []
    private var makeUpLocation: Set<Int> = []
    private var isStart = true
    
    private var selectedWeekDay: Set<Int> = []
    private var selectedTime: Set<String> = []
    private var builder: ArtistProfileInfoBuilder?
    private var selectedLocation: MakeUpLocation?
    private var selectedExperience: WorkExperience?

    // Define genderViews as an array of UIViews or buttons
    private var genderViews: [UIView] = []

    private let amTimes: [String] = [
        "04:00", "04:30",
        "05:00", "05:30",
        "06:00", "06:30",
        "07:00", "07:30",
        "08:00", "08:30",
        "09:00", "09:30",
        "10:00", "10:30",
        "11:00", "11:30"
    ]

    private let pmTimes: [String] = [
        "12:00", "12:30",
        "13:00", "13:30",
        "14:00", "14:30",
        "15:00", "15:30",
        "16:00", "16:30",
        "17:00", "17:30",
        "18:00", "18:30",
        "19:00", "19:30",
        "20:00", "20:30",
        "21:00"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let artistInfoViewController = storyboard?.instantiateViewController(withIdentifier: ArtistInfoViewController.className) as? ArtistInfoViewController {
            artistInfoViewController.delegate = self
        }

        if let mondayButton = weekButtons.first(where: { $0.tag == 1 }) {
            weekButtonTapped(mondayButton)
        }

        ArtistProfileInfoManager.shared.getArtistProfileInfo(userId: 10) { [weak self] result in
            switch result {
            case .success(let response):
                print("Success: \(response)")
                self?.getresponse = response
                if let data = response.data {
                    DispatchQueue.main.async {
                        for button in self?.fieldButtons ?? [] {
                            if data.specialization.contains(where: { $0.displayText == button.titleLabel?.text }) {
                                button.layer.backgroundColor = UIColor.mainBold.cgColor
                            } else {
                                button.layer.borderColor = UIColor.mainBold.cgColor
                                button.tintColor = .white
                            }
                        }

                        guard let self = self else { return }
                        for (index, button) in self.locationButtons.enumerated() {
                            button.layer.borderWidth = 1
                            button.layer.cornerRadius = 9

                            if data.makeupLocation.displayText == button.titleLabel?.text {
                                button.layer.borderColor = UIColor.mainBold.cgColor
                                button.tintColor = .black
                                if index < self.locationCheckImages.count {
                                    self.locationCheckImages[index].tintColor = .mainBold
                                }
                            } else {
                                button.layer.borderColor = UIColor.gray300.cgColor
                                button.tintColor = .black
                                if index < self.locationCheckImages.count {
                                    self.locationCheckImages[index].tintColor = .gray
                                }
                            }
                        }

                        self.textField.text = data.shopLocation
                        self.setUI()
                    }
                } else {
                    print("data nil")
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }

        setUI()
        configureCollectionView()
    }

    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 관리")
        progressBar.configure(progress: 2)

        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false

        fieldButtons.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainBold.cgColor
        }

        textField.layer.cornerRadius = 9
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray300.cgColor

        timeViews.forEach {
            $0.layer.cornerRadius = 9
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }

        weekButtons.forEach { button in
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.mainBold.cgColor
        }

        completeButton.layer.cornerRadius = 10

        startTimeLabel.text = "04:00"
        endTimeLabel.text = "21:00"
    }

    @IBAction func fieldButtonTapped(_ sender: UIButton) {
        let tag = sender.tag

        if selectedFields.contains(tag) {
            selectedFields.remove(tag)
            sender.tintColor = .black
            sender.backgroundColor = .white
        } else {
            selectedFields.insert(tag)
            sender.tintColor = .white
            sender.backgroundColor = .mainBold
        }
    }

    @IBAction func makeUpLocationButtonTapped(_ sender: UIButton) {
        let tag = sender.tag

        if makeUpLocation.contains(tag) {
            makeUpLocation.remove(tag)
            sender.layer.borderColor = UIColor.gray200.cgColor
            locationCheckImages[tag].image = nil
        } else {
            makeUpLocation.insert(tag)
            sender.layer.borderColor = UIColor.mainBold.cgColor
            locationCheckImages[tag].image = .icCheck
        }
    }

    @IBAction func weekButtonTapped(_ sender: UIButton) {
        weekButtons.forEach {
            if sender.tag == $0.tag {
                $0.tintColor = .white
                $0.backgroundColor = .mainBold
            } else {
                $0.tintColor = .black
                $0.backgroundColor = .white
            }
        }
    }

    @IBAction private func timeButtonTapped(_ sender: UIButton) {
        if sender.tag == TimeSection.am.rawValue {
            isStart = true
        } else {
            isStart = false
        }

        timeSetButtons.forEach {
            $0.isEnabled = false
        }
        collectionView.isHidden = false
    }

    @IBAction private func completionButtonTapped(_ sender: Any) {
        guard
            var builder = builder,
            let selectedLocation = selectedLocation
        else {
            if builder == nil { print("builder nil") }
            if selectedLocation == nil { print("sele nil") }
            return
        }

        var specialization: [String] = []
        MakeUpCategory.allCases.forEach { category in
            if selectedFields.contains(category.intVal) {
                specialization.append(category.rawValue)
            }
        }
        var weekDays: [String] = []
        DayOfWeek.allCases.forEach { day in
            if selectedWeekDay.contains(day.intVal) {
                weekDays.append(day.rawValue)
            }
        }

        builder = builder.specialization(specialization)
        builder = builder.makeupLocation(selectedLocation.rawValue)
        builder = builder.week(weekDays)
        builder = builder.selectedTime(Array(selectedTime))
        if
            selectedLocation != .VISIT,
            let text = textField.text
        {
            builder = builder.shopLocation(text)
        }

        func patchArtistProfile(userId: Int, profileImg: String, nickname: String, gender: Gender, introduction: String, workExperience: WorkExperience, region: [Region], specialization: [SearchCategory], makeupLocation: MakeUpLocation, shopLocation: String, availableDayOfWeek: [DayOfWeek: ReservationTimes]) {
            MyPageManager.shared.patchArtistProfile(userId: KeyChainManager.loadMemberID(), profileImg: profileImg, nickname: nickname, gender: gender, introduction: introduction, workExperience: workExperience, region: region, specialization: specialization, makeupLocation: makeupLocation, shopLocation: shopLocation) { result in
                switch result {
                case .success(let response):
                    let nextVC = ArtistTabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
                case .failure(let error):
                    //
                    let nextVC = ArtistTabBarController()
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextVC, animated: false)
                }
            }
        }
        func patchAvailableTime(userId: Int, availableTimeDtoList: [AvailableTimeDto]) {
            AvailableTimeManager.shared.patchAvailableTime(userId: KeyChainManager.loadMemberID(), availableTimeDtoList: availableTimeDtoList) { result in
                switch result {
                case .success(let dto):
                    print("Available time updated successfully: \(dto)")
                case .failure(let error):
                    print("Failed to update available time: \(error)")
                }
            }
        }

        let userId = KeyChainManager.loadMemberID()
        let nextVC = ArtistTabBarController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

}

// MARK: - collectionView 설정
extension ArtistInfoDetailViewController {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        configureDataSource()
        collectionView.delegate = self
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TimeCell, String> { cell, indexPath, itemIdentifier in
            cell.configure(time: itemIdentifier)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<TimeHeaderSupplementaryView>(elementKind: HeaderView.className) { supplementaryView, elementKind, indexPath in
            switch indexPath.section {
            case TimeSection.am.rawValue:
                supplementaryView.setTitle(title: TimeSection.am.getStringValue())
            default:
                supplementaryView.setTitle(title: TimeSection.pm.getStringValue())
            }
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        dataSource?.supplementaryViewProvider = { view, kind, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: index
            )
        }

        snapShot = SnapShot()
        snapShot?.appendSections([.am, .pm])
        snapShot?.appendItems(amTimes, toSection: .am)
        snapShot?.appendItems(pmTimes, toSection: .pm)
        dataSource?.apply(snapShot ?? SnapShot(), animatingDifferences: false)
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(55),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(0),
                trailing: .fixed(6),
                bottom: .fixed(0)
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(31)
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 5
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 0)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            )

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(17)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HeaderView.className,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        return layout
    }
}

extension ArtistInfoDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }
        cell.contentView.layer.borderColor = UIColor.mainBold.cgColor

        if isStart {
            startTimeLabel.text = cell.getTime()
        } else {
            endTimeLabel.text = cell.getTime()
        }

        timeSetButtons.forEach {
            $0.isEnabled = true
        }
        collectionView.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimeCell else { return }
        cell.contentView.layer.borderColor = UIColor.gray300.cgColor
    }
}

// MARK: - scrollView delelgate
extension ArtistInfoDetailViewController: UIScrollViewDelegate {

}

extension ArtistInfoDetailViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

