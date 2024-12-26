import UIKit
import FirebaseFirestore

class CustomerHomeViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    var stores: [Details] = []
    var filteredStores: [Details] = []
    var searchController: UISearchController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customer Home"
        setupTableView()
        setupSearchController()
        fetchStoresFromFirestore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStoresFromFirestore()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Stores"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Fetch Stores from Firestore
    private func fetchStoresFromFirestore() {
        let db = Firestore.firestore()
        db.collection("Stores").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            // Parse documents into Details objects
            self.stores = documents.compactMap { document -> Details? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let num = data["number"] as? String,
                      let pass = data["password"] as? String,
                      let location = data["location"] as? String,
                      let web = data["website"] as? String,
                      let from = data["from"] as? String,
                      let to = data["to"] as? String,
                      let logoUrl = data["logoUrl"] as? String else {
                    return nil
                }

                // Use a placeholder for the image until it's fetched
                let placeholderImage = self.placeholderImage()

                // Initialize the Details object with the Firestore document ID
                return Details(
                    id: document.documentID, // Save the document ID
                    name: name,
                    email: email,
                    num: num,
                    pass: pass,
                    image: placeholderImage, // Placeholder for now
                    location: location,
                    web: web,
                    from: from,
                    to: to,
                    logoUrl: logoUrl
                )
            }

            print("Customer Home: Fetched \(self.stores.count) stores successfully")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Placeholder Image
    private func placeholderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.darkGray
            ]
            let text = "Image"
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (100 - textSize.width) / 2, y: (100 - textSize.height) / 2), withAttributes: attributes)
        }
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased(), !query.isEmpty else {
            filteredStores = stores
            tableView.reloadData()
            return
        }

        filteredStores = stores.filter { store in
            store.name.lowercased().contains(query) || store.location.lowercased().contains(query)
        }
        tableView.reloadData()
    }

    // MARK: - TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (searchController?.isActive ?? false) ? filteredStores.count : stores.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreTableViewCell
        let store: Details = (searchController?.isActive ?? false) ? filteredStores[indexPath.section] : stores[indexPath.section]
        cell.name.text = store.name

        // Dynamically load the image from logoUrl
        if let url = URL(string: store.logoUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.photo.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.photo.image = UIImage(named: "placeholder") // Default placeholder image
                    }
                }
            }
        } else {
            cell.photo.image = UIImage(named: "placeholder") // Default placeholder image if URL is invalid
        }

        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedStore = (searchController?.isActive ?? false) ? filteredStores[indexPath.section] : stores[indexPath.section]
//        performSegue(withIdentifier: "showStoreDetails", sender: selectedStore)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetails",
           let destinationVC = segue.destination as? StoreDetailViewController,
           let selectedStore = sender as? Details {
            destinationVC.store = selectedStore
        }
    }
}
