
import UIKit
import MGSwipeTableCell

class ShellChatListViewController: UIViewController {
    lazy var tableView:UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.tableHeaderView = UIView()
        $0.register(UINib(nibName: "ShellChatListTableViewCell", bundle: .main), forCellReuseIdentifier: "ShellChatListTableViewCell")

        return $0


    }(UITableView())


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }

}
extension ShellChatListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShellChatListTableViewCell") as! ShellChatListTableViewCell
        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named: "deleteWatch"), backgroundColor: UIColor.clear, callback: { result in
            return true
        })]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}

