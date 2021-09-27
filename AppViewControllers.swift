//
//  ViewControllers.swift
//  Populaw
//
//  Created by Gaurang on 09/09/21.
//

import UIKit

class AppViewControllers {

    static let shared = AppViewControllers()

    // SignIn

    var signIn: SignInVC {
        getViewController(.signIn)
    }

    // Signup

    func signUp(for signUpFor: SignUpBy) -> SignUpVC {
        let viewCtr: SignUpVC = getViewController(.signUp)
        viewCtr.signupFor = signUpFor
        return viewCtr
    }

    var forgotPassword: ForgotPasswordVC {
        getViewController(.signUp)
    }

    var otp: OtpVC {
        getViewController(.signUp)
    }

    var resetPassword: ResetPasswordVC {
        getViewController(.signUp)
    }

    var signUpUserType: SignupUserTypeVC {
        getViewController(.signIn)
    }

    func findProfile(for signUpFor: SignUpBy) -> FindProfileVC {
        let viewCtr: FindProfileVC = getViewController(.signUp)
        viewCtr.signupFor = signUpFor
        return viewCtr
    }

    func claimProfile(for signUpFor: SignUpBy) -> ClaimProfileVC {
        let viewCtr: ClaimProfileVC = getViewController(.signUp)
        viewCtr.signupFor = signUpFor
        return viewCtr
    }

    var subscription: SubscriptionVC {
        getViewController(.signUp)
    }

    // Main

    func tabBar() -> TabBarViewController {
        let viewCtr = TabBarViewController()
        return viewCtr
    }

    var notification: NotificationVC {
        return NotificationVC()
    }

    //Home

    var sideMenu: SideMenuVC {
        let viewCtr: SideMenuVC = getViewController(.home)
        viewCtr.modalPresentationStyle = .overFullScreen
        return viewCtr
    }

    var home: HomeViewController {
        getViewController(.home)
    }

    var followAttorneys: FollowpopulawAttorneysVC {
        getViewController(.home)
    }

    func postDetails() -> PostDetailsViewController {
        let viewCtr: PostDetailsViewController = getViewController(.home)
        return viewCtr
    }

    var myActivity: MyActivitiesVC {
        return getViewController(.home)
    }

    // PopUps

    func cardAlert(header: String, info: String) -> CardAlertVC {
        let viewCtr: CardAlertVC = getViewController(.popups)
        viewCtr.header = header
        viewCtr.info = info
        return viewCtr
    }

    func leaveGroupPopup() -> LeaveGroupPopupVC {
        let viewCtr: LeaveGroupPopupVC = getViewController(.popups)
        viewCtr.modalPresentationStyle = .overFullScreen
        viewCtr.modalTransitionStyle = .crossDissolve
        return viewCtr
    }

    // Profile

    func profile(userId: String) -> ProfileVC {
        let viewCtr: ProfileVC = getViewController(.profile)
        viewCtr.userId = userId
        return viewCtr
    }

    func editProfile(userId: String) -> EditProfileVC {
        let viewCtr: EditProfileVC = getViewController(.profile)
        viewCtr.userId = userId
        return viewCtr
    }

    func followes(type: FollowersVC.ViewType) -> FollowersVC {
        let viewCtr: FollowersVC = getViewController(.profile)
        viewCtr.type = type
        return viewCtr
    }

    // Search

    var search: SearchVC {
        getViewController(.search)
    }

    var advanceSearch: AdvanceSearchVC {
        getViewController(.search)
    }

    // Post

    var shardPost: SharePostVC {
        getViewController(.post)
    }

    // Group

    var joinGroup: JoinGroupVC {
        getViewController(.group)
    }

    var myGroups: MyGroupVC {
        getViewController(.group)
    }

    var groupDetails: GroupDetailsVC {
        getViewController(.group)
    }

    func groupPrivacy() -> GroupPrivacyVC {
        let viewCtr: GroupPrivacyVC = getViewController(.group)
        return viewCtr
    }

    func groupMembers() -> GroupMembersVC {
        let viewCtr: GroupMembersVC = getViewController(.group)
        return viewCtr
    }

    func groupInviteMembers() -> InviteMembersVC {
        let viewCtr: InviteMembersVC = getViewController(.group)
        return viewCtr
    }

    // Account Setting

    var accountSetting: AccountSettingVC {
        return getViewController(.accountSetting)
    }

    // Chat

    var chatUser: ChatUsersVC {
        return getViewController(.chat)
    }

    func chatRoom() -> ChatRoomVC {
        let viewCtr: ChatRoomVC = getViewController(.chat)
        return viewCtr
    }

    var newMessage: NewMessageVC {
        return NewMessageVC()
    }

    // MARK: - Method to get viewCotroller from storyboard
    func getViewController<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard) -> T {
        return UIStoryboard(storyboard: storyboard).instantiate()
    }

}
