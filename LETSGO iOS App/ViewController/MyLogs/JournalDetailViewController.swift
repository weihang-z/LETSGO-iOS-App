import UIKit

final class JournalDetailViewController: UIViewController {
    private let entry: JournalEntry
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let bodyLabel = UILabel()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(entry: JournalEntry) {
        self.entry = entry
        super.init(nibName: nil, bundle: nil)
        title = "Log Detail"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViews()
        layoutContent()
        render()
    }

    private func configureViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = UIColor.systemGray5

        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.numberOfLines = 0

        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        dateLabel.textColor = .secondaryLabel

        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0
    }

    private func layoutContent() {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, dateLabel, bodyLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 220),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func render() {
        imageView.image = entry.coverImage ?? UIImage(systemName: "photo")
        imageView.tintColor = entry.coverImage == nil ? .systemGray : .clear
        titleLabel.text = entry.title
        dateLabel.text = dateFormatter.string(from: entry.date)
        bodyLabel.text = "Full story goes here. Add text, photos, and highlights from your day."
    }
}
