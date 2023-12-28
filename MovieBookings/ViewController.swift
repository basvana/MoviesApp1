//
//  ViewController.swift
//  MovieBookings
//
//  Created by danish on 21/12/23.//

import UIKit
import CoreData
import StoreKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    @IBOutlet weak var adminPassword: UITextField!
    @IBOutlet weak var adminLogin: UIButton!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var Login: UIButton!
    
    
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var castTV: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedNote: Movie? = nil
    
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var managedObjectContext: NSManagedObjectContext?
    
    let images = ["one", "two", "three", "four", "five", "six"]
    let titles = ["SALAAR", "Hi Nanna", "Dunki", "TIGER 3", "AquaMan 2", "DEVIL"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        
     /*   do {
                // Your code that might throw an exception
                cell.image.image = try UIImage(named: images[indexPath.row])
            } catch let error {
                print("An exception occurred while setting image: \(error)")
                // Handle the exception gracefully or provide a default image
                cell.image.image = UIImage(named: "defaultImage")
            }*/
        cell.image.image = UIImage(named: images[indexPath.row])
        cell.pTitle.text = titles[indexPath.row]
        cell.pSubTitle.text = "AVAILABLE NOW"
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // collectionView.dataSource = self
        if(selectedNote != nil)
        {
            titleTF.text = selectedNote?.title
            castTV.text = selectedNote?.cast
        }
        
    }
    
    
    @IBAction func ratings(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
   
   
 /*   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context: NSManagedObjectContext = self.fetchedResultsController.managedObjectContext
        context.delete(movieList[indexPath.row])
        movieList.remove(at: index.row)
    }*/

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        // Return NO if you do not want the item to be re-orderable.
        return false
    }
    

   @IBAction func loginbutton(_ sender: UIButton) {
        let username = userName.text ?? ""
        let Password = userPassword.text ?? ""
        
        let validUsername = "user"
        let validPassword = "password"
        
        if username == validUsername && Password == validPassword{
            //Successful Login
            showAlert(title:"Success", message: "Login Successful")
            //
            //performSegue(withIdentifier: "MovieTableView", sender: nil)
           // navigateToMovieTableView()
            navigationController?.pushViewController(UITableView, animated: true)
        }
        else{
            showAlert(title: "Error", message: "Invalid details")
        }
        
 
    }
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(okAction)
               present(alert, animated: true, completion: nil)
   //navigationController?.pushViewController(MovieTableViewController, animated: true)
    }
   
  /*  private func navigateToMovieTableView() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        if let movieTableVieSwController = storyboard.instantiateViewController(withIdentifier: "MovieTableViewController") as? MovieTableViewController{
    navigationController?.pushViewController(MovieTableViewController, animated: true)
    }
   
   }
        
    private func navigateToMovieTable()
   }
   
   */
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
            let newMovie = Movie(entity: entity!, insertInto: context)
            newMovie.id = Int32(movieList.count as NSNumber)
            newMovie.title = titleTF.text
            newMovie.cast = castTV.text
            do{
                try context.save()
                movieList.append(newMovie)
                navigationController?.popViewController(animated: true)
            }
            catch{
                print("context save error")
            }
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let movie = result as! Movie
                    if(movie == selectedNote)
                    {
                        movie.title = titleTF.text
                        movie.cast = castTV.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
}
class PostCell: UICollectionViewCell{
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pSubTitle: UILabel!
    
    override func awakeFromNib() {
        background.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
    }
}



