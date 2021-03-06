//
//  WebServiceHelper.swift
//  Somi
//
//  Created by Paras on 24/03/21.
//

import Foundation
import UIKit


//let BASE_URL = "https://ambitious.in.net/Arun/appurados/index.php/api/"//Live
let BASE_URL = "http://appurados.com/admin/index.php/api/"
struct WsUrl{
    
    static let url_SignUp  = BASE_URL + "signup"
    static let url_SocialLogin  = BASE_URL + "social_login"
    static let url_getSubCategory = BASE_URL + "get_sub_category?"
    static let url_Login  = BASE_URL + "login"
    static let url_getProfile = BASE_URL + "get_profile"
    static let url_updateProfile = BASE_URL + "update_profile"
    static let url_getBannerHome = BASE_URL + "get_banner"
    static let url_getCategory = BASE_URL + "get_category"
    static let url_getVendor = BASE_URL + "get_vendor?"
    static let url_getProduct = BASE_URL + "get_product?"
    static let url_forgotPassword = BASE_URL + "forgot_password"
    static let url_getRewards = BASE_URL + "get_rewards"
    static let url_GetOrders = BASE_URL + "get_order"
    static let url_RepeatOrder = BASE_URL + "repeate_order?"
    static let url_Getnotification = BASE_URL + "get_notification"
    static let url_GetOfferCategory = BASE_URL + "get_offer_category"
    static let url_GetPackageDelivery = BASE_URL + "get_package_delivery"
    static let url_GetCartDetails = BASE_URL + "get_cart?"
    static let url_GetUserAddress = BASE_URL + "get_user_address"
    static let url_GetPromoCode = BASE_URL + "get_promocode"
    static let url_FavUnfav = BASE_URL + "save_in_favorite"
    static let url_AddAddress = BASE_URL + "add_user_address"
    static let url_BuyOffer = BASE_URL + "buy_offer_voucher"
    static let url_AddToCart = BASE_URL + "add_to_cart"
    static let url_EstimateDeliveryCost = BASE_URL + "estimated_delivery_cost"
    static let url_PackageDelivery = BASE_URL + "package_delivery"
    static let url_PlaceAnOrder = BASE_URL + "place_an_order"
    static let url_getChatMessage = BASE_URL + "get_messages"
    static let url_sendMessage = BASE_URL + "insert_messages"
    static let url_GiveRating = BASE_URL + "rating"
   
}

//Api Header

struct WsHeader {

    //Login

    static let deviceId = "Device-Id"

    static let deviceType = "Device-Type"

    static let deviceTimeZone = "Device-Timezone"

    static let ContentType = "Content-Type"

}



//Api parameters

struct WsParam {

    

    //static let itunesSharedSecret : String = "c736cf14764344a5913c8c1"

    //Signup

    static let dialCode = "dialCode"

    static let contactNumber = "contactNumber"

    static let code = "code"

    static let deviceToken = "deviceToken"

    static let deviceType = "deviceType"

    static let firstName = "firstName"

    static let lastName = "lastName"

    static let email = "email"

    static let driverImage = "driverImage"

    static let isSignup = "isSignup"

    static let licenceImage = "licenceImage"

    static let socialId = "socialId"

    static let socialType = "socialType"

    static let imageUrl = "image_url"

    static let invitationId = "invitationId"

    static let status = "status"

    static let companyId = "companyId"

    static let vehicleId = "vehicleId"

    static let type = "type"

    static let bookingId = "bookingId"

    static let location = "location"

    static let latitude = "latitude"

    static let longitude = "longitude"

    static let currentdate_time = "current_date_time"

}



//Api check for params

struct WsParamsType {

    static let PathVariable = "Path Variable"

    static let QueryParams = "Query Params"

}
