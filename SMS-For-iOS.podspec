Pod::Spec.new do |s|
    s.name                = "SMS-For-iOS"
    s.version             = "1.2.0"
    s.summary             = '由Nihility-Ming提供的来自Mob的免费短信验证码SDK。'
    s.license             = 'Copyright © 2012-2015 mob'
    s.author              = { "Bi Weiming" => "weiming.bi@yahoo.com" }
    s.homepage            = 'http://mob.com'
    s.source              = { :git => "https://github.com/Nihility-Ming/SMS-For-iOS.git", :tag => "1.2.0" }
    s.platform            = :ios, '7.0'
    s.frameworks          = "MessageUI", "AddressBook", "AddressBookUI", "javascriptcore"
    s.libraries           = "icucore", "z", "stdc++"
    s.vendored_frameworks = 'SMS_SDK/SMS_SDK.framework', 'SMS_SDK/MOBFoundation.framework'
    s.resources           = 'SMS_SDK/en.lproj', 'SMS_SDK/zh-Hans.lproj'
end
