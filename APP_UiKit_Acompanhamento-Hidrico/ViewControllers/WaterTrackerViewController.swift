import UIKit

/// Tela principal do app de controle de água.
final class WaterTrackerViewController: UIViewController {

    private let manager = WaterManager.shared
    private var dailyGoal: Double = 2000 // meta fixa de 2000ml
    
    // MARK: - UI Elements
    
    private var titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()

    private var progressView:  WaterProgressView =  {
        let progressView = WaterProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var titleProgressView: UILabel = {
        let titleProgressView = UILabel()
        titleProgressView.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleProgressView.translatesAutoresizingMaskIntoConstraints = false
        return titleProgressView
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Quantidade ml"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Adicionar"
        config.image = UIImage(systemName: "drop.fill") // ícone de gota
        config.imagePlacement = .leading               // ícone à esquerda do texto
        config.imagePadding = 8                        // espaço entre ícone e texto
        config.cornerStyle = .medium
        
        let button = UIButton(type: .system)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 44
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Água Hoje"
        titleView.text = "Meta de \(Int(dailyGoal))ml"

        setupViews()
        setupConstraints()
        setupActions()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        progressView.layer.cornerRadius = progressView.layer.bounds.width / 2
        progressView.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(titleView)
        view.addSubview(progressView)
        view.addSubview(titleProgressView)
        view.addSubview(amountTextField)
        view.addSubview(addButton)
        view.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EntryCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressView.widthAnchor.constraint(equalToConstant: 150),
            progressView.heightAnchor.constraint(equalToConstant: 150),
            progressView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleProgressView.topAnchor.constraint(equalTo: progressView.topAnchor),
            titleProgressView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),
            titleProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            amountTextField.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            amountTextField.heightAnchor.constraint(equalToConstant: 44),

            addButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupActions() {
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func didTapAdd() {
        guard let text = amountTextField.text,
              !text.isEmpty,
              let amount = Int(text.replacingOccurrences(of: ",", with: ".")),
              amount > 0 else {
            return
        }
        manager.addEntry(amount: amount)
        amountTextField.text = ""
        updateUI()
    }

    // MARK: - UI Update

    private func updateUI() {
        let total = manager.todayTotal()
        titleProgressView.text = "\(total) ml"
        
        let ratio = min(Double(total) / dailyGoal, 1.0)
        print("Ratio", ratio)
        progressView.progress = Float(ratio)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension WaterTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.todayEntries().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = manager.todayEntries()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none

        cell.textLabel?.text = String(format: "%dml — %@", entry.amount, formatter.string(from: entry.date))
        print ("Print cell: ", cell.textLabel?.text)
        return cell
        
    }
}

// MARK: - UITableViewDelegate

extension WaterTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let entry = manager.todayEntries()[indexPath.row]
        manager.removeEntry(with: entry.id)
        updateUI()
    }
}

#Preview {
    return WaterTrackerViewController()
}
