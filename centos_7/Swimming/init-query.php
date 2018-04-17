<?php

$param_list = array (
    "update_package" => true,
    "update_url" => "http://res.lyxz.q-dazzle.com/hxm1/qz/and/data_a1/",
    "report_url" => "http://183.61.136.176:100/log_report.php",
    "upload_url" => "http://183.61.136.176:90/xxqy-upload/",
    //"event_url" => "http://cls.xxqt.youyannet.com/auc/event_report.php",
    "qq_gift_fetch_url" => "http://cls.lyxz.q-dazzle.com/api/qzw/fetch_qq_gift.php",
    "qq_gift_query_url" => "http://cls.lyxz.q-dazzle.com/api/qzw/query_qq_gift.php",
    "switch_list" => array(
        "audit_version" => false,
        "log_print" => true,
        "error_screen" => true,
        "testin_report" => true,
        "countly_report" => true,
        "open_chongzhi" => true,
        "open_gm" => true,
        "update_assets" => false,
        "active_code" => false,
        "qqvip_gift" => true,
                           ),
                     );

$server_info = array (
    "last_server" => 1,
    "server_time" => time(),
    "server_list" => array(
        array( id => 1, name => "mgXX_cn", ip => "XXXXX", port => 49900, flag => 1, avatar => "r1", role_name => "xxx", role_level => 10,20 ),
		array( id => 15, name => "mgXX_cn_1", ip => "XXXXX", port => 49990, flag => 1, avatar => "r2", role_name => "xxx", role_level => 10,20 ), 
		array( id => 5, name => "mgXX_cn_2", ip => "XXXXX", port => 49930, flag => 1, avatar => "r1", role_name => "xxx", role_level => 10,20 ),), 
        );

$version_info = array (
    "package_info" => array (
        "version" => 141205101,
        "name" => "xxqy",
        "desc" => "123456",
        "url" => "http://192.168.11.55/package/xxqy-debug.apk",
        "size" => 76338608,
        "md5" => "39627a68d9e152b0b5cac02ee471bb06",
                             ),
                       );

$version_info["assets_info"] = json_decode(file_get_contents("/var/www/html/version.txt"));
$version_info["update_data"] = base64_encode(file_get_contents("/var/www/html/update.lua"));

$init_info = array (
    "param_list" => $param_list,
    "server_info" => $server_info,
    "version_info" => $version_info,
                    );

echo json_encode($init_info);
