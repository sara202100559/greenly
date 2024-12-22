import UIKit

class CustomerHomeViewController: UITableViewController {

    // MARK: - Properties
    var stores: [Details] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customer Home"
        setupTableView()
        loadStores()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStores()
        tableView.reloadData()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    // MARK: - Load Stores
    func loadStores() {
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: StoresTableViewController.storesArchiveURL)
            stores = try decoder.decode([Details].self, from: data)
            print("Customer: Stores loaded successfully.")
        } catch {
            print("Customer: Error loading stores: \(error)")
        }
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stores.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        let store = stores[indexPath.section]
        cell.name.text = store.name
        cell.photo.image = store.image
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedStore = stores[indexPath.section]
        performSegue(withIdentifier: "showStoreDetails", sender: selectedStore)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetails",
           let destinationVC = segue.destination as? StoreDetailViewController,
           let selectedStore = sender as? Details {
            destinationVC.store = selectedStore
        }
    }
}
