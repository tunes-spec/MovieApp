

import UIKit
import SafariServices

class MovieSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    // Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = field.text!
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=8ffb1941&s=\(query)&type=movie")!,
                                   completionHandler: { data, response, error in
                                    
                                    guard let data = data, error == nil else {
                                        return
                                    }
                                    
                                    // Convert
                                    var result: MovieResult?
                                    do {
                                        result = try JSONDecoder().decode(MovieResult.self, from: data)
                                    }
                                    catch {
                                        print("error")
                                    }
                                    
                                    guard let finalResult = result else {
                                        return
                                    }
                                    
                                    // Update our movies array
                                    let newMovies = finalResult.search
                                    self.movies.append(contentsOf: newMovies)
                                    
                                    // Refresh our table
                                    DispatchQueue.main.async {
                                        self.table.reloadData()
                                    }
                                    
                                   }).resume()
        
    }
    
    @IBAction func homeButtonDidTapped(_ sender: UIBarButtonItem) {
        showHomeApp()
    }
    
    private func showHomeApp() {
        let introAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "intro")
        if let windoewScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windoewScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = introAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCurlUp,
                              animations: nil,
                              completion: nil)
        }
    }
    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Show movie details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

