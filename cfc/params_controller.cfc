
/**
*
* @file         :   cfc\params_controller.cfc
* @author       :   Uğur Hamurpet<ugurhamurpet@workcube.com
* @date         :   22/08/2019
* @description  :   Upgrade sistemini kullanan sistemlerde parametre ayarlarının yönetildiği cfc'dir.

                    Yeni sürümle gelen parametreler data structının son parametresi olarak eklenir, 
                    require ya da readonly parametreleri kullanılarak, zorunluluk ya da sadece okunabilir özellikleri verilebilir.

                    Müşteri sürüm geçişi sırasında yeni gelen parametreyi görür, doldurur ve bir sonraki aşamaya devam eder.
*
*/

component output="true" displayname="Params controller"  {

    get_params = application.systemParam.systemParam();

    public function init(){
        return this;
    }

    mainPath = '#ReplaceNoCase(Replace(GetDirectoryFromPath(GetBaseTemplatePath()),'\','/','ALL'),"cfc/","")#';

    public struct function getParamsSetting() {
        
        responseData = StructNew();
        responseData = {

            data : {
                dsn : { val: isdefined("get_params.dsn") ? get_params.dsn : "", type : "text", required: true, readonlyKey : true, readonlyValue : false  },
                database_log_folder : { val: isdefined("get_params.database_log_folder") ? get_params.database_log_folder : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_host : { val: isdefined("get_params.database_host") ? get_params.database_host : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_port : { val: isdefined("get_params.database_port") ? get_params.database_port : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_folder : { val: isdefined("get_params.database_folder") ? get_params.database_folder : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                default_company_id_ : { val: isdefined("get_params.default_company_id_") ? get_params.default_company_id_ : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                employee_url : { val: isdefined("get_params.employee_url") ? get_params.employee_url : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                free_actions : { val: isdefined("get_params.free_actions") ? get_params.free_actions : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                mobile_url : { val: isdefined("get_params.mobile_url") ? get_params.mobile_url : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                onesignal_appID : { val: isdefined("get_params.onesignal_appID") ? get_params.onesignal_appID : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                onesignal : { val: isdefined("get_params.onesignal") ? get_params.onesignal : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                partner_url : { val: isdefined("get_params.partner_url") ? get_params.partner_url : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                partner_companies : { val: isdefined("get_params.partner_companies") ? get_params.partner_companies : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                recaptcha : { val: isdefined("get_params.recaptcha") ? get_params.recaptcha : false, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                google_auth_login : { val: isdefined("get_params.google_auth_login") ? get_params.google_auth_login : false, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                server_url : { val: isdefined("get_params.server_url") ? get_params.server_url : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                server_companies : { val: isdefined("get_params.server_companies") ? get_params.server_companies : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                use_script_on_process : { val: isdefined("get_params.use_script_on_process") ? get_params.use_script_on_process : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                fusebox : {
                    server_machine : { val : isdefined("get_params.fusebox.server_machine") ? get_params.fusebox.server_machine : 1, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    server_machine_list : { val : isdefined("get_params.fusebox.server_machine_list") ? get_params.fusebox.server_machine_list : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    use_period: { val : isdefined("get_params.fusebox.use_period") ? get_params.fusebox.use_period : true, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    use_spect_company: { val : isdefined("get_params.fusebox.use_spect_company") ? get_params.fusebox.use_spect_company : "", type : "text", required: false, readonlyKey : true, readonlyValue : false }
                },
                bugLog : {
                    bugLogListener : { val: "http://buglog.workcube.com/listeners/bugLogListenerWS.cfc?wsdl", type : "text", required: true, readonlyKey : true, readonlyValue : true },
                    bugLogAutoNotify : { val: true, type : "text", required: true, readonlyKey : true, readonlyValue : false }
                },
                mongodb : {
                    dbhost : { val : isdefined("get_params.mongodb.dbhost") ? get_params.mongodb.dbhost : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                    dbport : { val : isdefined("get_params.mongodb.dbport") ? get_params.mongodb.dbport : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                    dbname : { val : isdefined("get_params.mongodb.dbname") ? get_params.mongodb.dbname : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                    dbusername : { val : isdefined("get_params.mongodb.dbusername") ? get_params.mongodb.dbusername : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                    dbpassword : { val : isdefined("get_params.mongodb.dbpassword") ? get_params.mongodb.dbpassword : "", type : "text", required: false, readonlyKey : true, readonlyValue : false }
                },
                git : {
                    git_dir : { val: isdefined("get_params.git.git_dir") ? get_params.git.git_dir : (IsDefined("get_params.index_folder") ? replaceNoCase(replaceNoCase(replace(get_params.index_folder,"\","/","ALL"),"/V16",""),"/WMO","") : ""), type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_url : { val: isdefined("get_params.git.git_url") ? get_params.git.git_url : "https://bitbucket.org/workcube/devcatalyst.git", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_username : { val: isdefined("get_params.git.git_username") ? get_params.git.git_username : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_password : { val: isdefined("get_params.git.git_password") ? get_params.git.git_password : "", type : "password", required: true, readonlyKey : true, readonlyValue : false },
                    git_self_pull : { val: isdefined("get_params.git.git_self_pull") ? get_params.git.git_self_pull : false, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_branch : { val: isdefined("get_params.git.git_branch") ? get_params.git.git_branch : "", type : "text", required: false, readonlyKey : true, readonlyValue : false }
                },
                plevne: { val: isdefined("get_params.plevne") ? get_params.plevne : false, type: "text", required: true, readonlyKey: true, readonlyValue: false },
                use_password_reminder : { val: isdefined("get_params.use_password_reminder") ? ( get_params.use_password_reminder eq 1 ? true : false ) : true, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                server_detail : { val: isdefined("get_params.server_detail") ? get_params.server_detail : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                use_active_directory : { val: isdefined("get_params.use_active_directory") ? get_params.use_active_directory : "0", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_server : { val: isdefined("get_params.active_directory_server") ? get_params.active_directory_server : "wrkdcsrv", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_server_add : { val: isdefined("get_params.active_directory_server_add") ? get_params.active_directory_server_add : "CUBE\", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_start : { val: isdefined("get_params.active_directory_start") ? get_params.active_directory_start : "cn=users,dc=wrkdcsrv", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_atrr : { val: isdefined("get_params.active_directory_atrr") ? get_params.active_directory_atrr : "cn,sn,mail", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_control_user : { val: isdefined("get_params.active_directory_control_user") ? get_params.active_directory_control_user : "domain_user", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                active_directory_control_password : { val: isdefined("get_params.active_directory_control_password") ? get_params.active_directory_control_password : "domain_password", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                is_only_show_page : { val: isdefined("get_params.is_only_show_page") ? get_params.is_only_show_page : 0, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                workcube_mode : { val: isdefined("get_params.workcube_mode") ? get_params.workcube_mode : 0, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                standart_process_money : { val: isdefined("get_params.standart_process_money") ? get_params.standart_process_money : 'TL', type : "text", required: true, readonlyKey : true, readonlyValue : false },
                standart_process_other_money : { val: isdefined("get_params.standart_process_other_money") ? get_params.standart_process_other_money : 'USD', type : "text", required: true, readonlyKey : true, readonlyValue : false },
                upload_folder : { val: isdefined("get_params.upload_folder") ? replace(get_params.upload_folder,'\','/','ALL') : "#mainPath#documents/", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                dir_seperator : { val: isdefined("get_params.dir_seperator") ? get_params.dir_seperator : "/", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                index_folder : { val: isdefined("get_params.index_folder") ? replace(get_params.index_folder,'\','/','ALL') : "#replacenocase(replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"cfc\",""),"cfc/","")#V16/", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_type : { val: isdefined("get_params.database_type") ? get_params.database_type : "MSSQL", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                download_folder : { val: isdefined("get_params.download_folder") ? replace(get_params.download_folder,'\','/','ALL') : "#mainPath#", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                file_web_path : { val: isdefined("get_params.file_web_path") ? replace(get_params.file_web_path,'\','/','ALL') : "/documents/", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                default_menu : { val: isdefined("get_params.default_menu") ? get_params.default_menu : 1, type : "select", required: true, readonlyKey : true, readonlyValue : false, option: [{value: 1, text: "Holistic"}, {value: 2, text: "Watomic"}] },
                whops : {
                    our_company_id : { val: isdefined("get_params.whops.our_company_id") ? get_params.whops.our_company_id : 1, type : "text", required: true, readonlyKey : true, readonlyValue : false }
                }
            },
            hasChildParamList : ["fusebox","bugLog","mongodb","git","whops"]
            
        };

        //#data structının içerisinde Child struct içeren structların isimleri hasChildParamList değerine yazılır.

        /* CF 11 desteği kaldırıldığı için yeniden açıldı */
        orderedData = structNew("ordered");

        structKeys = structKeyArray(responseData.data);
        arraySort(structKeys, "text", "asc");

        for (key in structKeys) {
            orderedData[key] = responseData.data[key];
        }

        responseData.data = orderedData;

        return responseData;
    }

}