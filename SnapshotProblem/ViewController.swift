import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var activitiesDataSource: [Activity]!
    var snapshot = NSDiffableDataSourceSnapshot<Int, Activity.ID>()
    
    lazy var diffableDataSource = UITableViewDiffableDataSource<Int, Activity.ID>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let activity = self.getActivity(by: itemIdentifier)
        print("setting up cell with title: \(activity.title)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.titleLabel.text = activity.title
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesDataSource = [Activity(title: "first"), Activity(title: "second"), Activity(title: "third")]
        tableView.delegate = self
        tableView.dataSource = diffableDataSource
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        prepareSnapshot()
    }
    
    func prepareSnapshot() {
        let activitiesIds = activitiesDataSource.map(\.id)
        snapshot.appendSections([0])
        snapshot.appendItems(activitiesIds)
        diffableDataSource.apply(snapshot)
    }
        
    func getActivity(by id: UUID) -> Activity {
        guard let activity = self.activitiesDataSource.first(where: { $0.id == id }) else {
            fatalError("Could not find activity by id")
        }
        return activity
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityId = snapshot.itemIdentifiers[indexPath.row]
        let activity = getActivity(by: activityId)
        activity.title += " tap"
        snapshot.reconfigureItems([activityId])
        diffableDataSource.apply(snapshot)
    }
}
