
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation

class PostVCViewModel : NSObject{
    
    //MARK: - Variable Declaration
    private var apiController: APIControllerProtocol
    var userList = Users()
    var reloadTableView: (() -> Void)?
    var postList = Posts()
    var userCellViewModel = [PostCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(userService: APIControllerProtocol = UserService()) {
        self.apiController = userService
    }
    
    //MARK: - GET TOKEN, POSTS and USER DATA
    func getUsersData() {
        if Connectivity.isConnectedToInternet {
            apiController.fetchUserToken(userName: "", password: ""){ (response, error)  in
                USERDEFAULTS.setDataForKey(response ?? "" , .accessToken)
                self.apiController.fetchPosts { success, model, error in
                    if success, let postModel = model {
                        self.apiController.fetchUsers { success, model, error in
                            if success, let list = model {
                                self.userList = list
                                self.fetchPosts(post: postModel)
                                self.postList = postModel
                            }
                        }
                    } else {
                        print(error!)
                    }
                }
            }
        }else{
            APPDELEGATE?.window?.rootViewController?.showToast(message: AlertMessage.msgNotReachable)
        }
    }
    
    func fetchPosts(post: Posts) {
        self.postList = post
        var objCellModel = [PostCellViewModel]()
        for j in 0..<post.count{
            for i in userList {
                if i.id == post[j].userID{
                    objCellModel.append(createCellModelPost(post: post[j], username: i.name, avatar: i.avatar))
                }
            }
        }
        userCellViewModel = objCellModel
    }
    
    //MARK: - Create cell and add data
    func createCellModelPost(post: Post, username: String, avatar: String) -> PostCellViewModel {
        let title = post.title
        let desc = post.body
        let username = username
        let image = avatar
        
        return PostCellViewModel(username: username, title: title, image: image, desc: desc)
    }
    
    //MARK: - return Cell to controller with Data
    func getCellViewModel(at indexPath: IndexPath) -> PostCellViewModel {
        return userCellViewModel[indexPath.row]
    }
}
