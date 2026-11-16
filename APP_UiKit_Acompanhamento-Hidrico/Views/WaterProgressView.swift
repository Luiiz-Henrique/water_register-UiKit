import UIKit

/// Visualiza o progresso em direção à meta diária de água.
final class WaterProgressView: UIView {

    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fillView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var fillWidthConstraint: NSLayoutConstraint?

    /// Valor entre 0 e 1 representando o percentual atingido da meta.
    var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(trackView)
        trackView.addSubview(fillView)

        NSLayoutConstraint.activate([
            trackView.topAnchor.constraint(equalTo: topAnchor),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.trailingAnchor.constraint(equalTo: trackView.trailingAnchor),
            fillView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor)
        ])

        fillWidthConstraint = fillView.heightAnchor.constraint(equalToConstant: 0)
        fillWidthConstraint?.isActive = true
    }

    private func updateProgress() {
        let ratio = CGFloat(min(max(progress, 0), 1))
        fillWidthConstraint?.constant = ratio * trackView.bounds.height

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Mantém a proporção correta quando a view redimensiona (ex: rotação)
        let ratio = CGFloat(min(max(progress, 0), 1))
        fillWidthConstraint?.constant = ratio * trackView.bounds.height
    }
}

#Preview("Progresso 60%") {
    let view = WaterProgressView()
    view.progress = 0.9
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 24)
    return view
}
