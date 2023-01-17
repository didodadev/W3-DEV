
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

    public struct function getParamsSetting() {
        
        responseData = StructNew();
        responseData = {

            data : {
                dsn : { val: get_params.dsn, type : "text", required: true, readonlyKey : true, readonlyValue : false  },
                database_log_folder : { val: get_params.database_log_folder, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_host : { val: get_params.database_host, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_port : { val: isdefined("get_params.database_port") ? get_params.database_port : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                database_folder : { val: get_params.database_folder, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                default_company_id_ : { val: get_params.default_company_id_, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                employee_url : { val: get_params.employee_url, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                free_actions : { val: get_params.free_actions, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                mobile_url : { val: get_params.mobile_url, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                onesignal_appID : { val: isdefined("get_params.onesignal_appID") ? get_params.onesignal_appID : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                onesignal : { val: isdefined("get_params.onesignal") ? get_params.onesignal : "", type : "text", required: false, readonlyKey : true, readonlyValue : false },
                partner_url : { val: get_params.partner_url, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                partner_companies : { val: get_params.partner_companies, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                recaptcha : { val: isdefined("get_params.recaptcha") ? get_params.recaptcha : false, type : "text", required: true, readonlyKey : true, readonlyValue : false },
                server_url : { val: get_params.server_url, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                server_companies : { val: get_params.server_companies, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                use_script_on_process : { val: get_params.use_script_on_process, type : "text", required: false, readonlyKey : true, readonlyValue : false },
                fusebox : {
                    server_machine : { val : isdefined("get_params.fusebox.server_machine") ? get_params.fusebox.server_machine : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    server_machine_list : { val : isdefined("get_params.fusebox.server_machine_list") ? get_params.fusebox.server_machine_list : "", type : "text", required: true, readonlyKey : true, readonlyValue : false }
                },
                bugLog : {
                    bugLogListener : { val: "https://buglog.workcube.com/listeners/bugLogListenerWS.cfc?wsdl", type : "text", required: true, readonlyKey : true, readonlyValue : true },
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
                    git_dir : { val: isdefined("get_params.git.git_dir") ? get_params.git.git_dir : replaceNoCase(replaceNoCase(get_params.index_folder,"\V16",""),"\WMO",""), type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_url : { val: isdefined("get_params.git.git_url") ? get_params.git.git_url : "https://bitbucket.org/workcube/devcatalyst.git", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_username : { val: isdefined("get_params.git.git_username") ? get_params.git.git_username : "", type : "text", required: true, readonlyKey : true, readonlyValue : false },
                    git_password : { val: isdefined("get_params.git.git_password") ? get_params.git.git_password : "", type : "password", required: true, readonlyKey : true, readonlyValue : false }
                },
                plevne: { val: false, type: "text", required: true, readonlyKey: true, readonlyValue: false }
            },
            hasChildParamList : ["fusebox","bugLog","mongodb","git"]
            
        };

        //#data structının içerisinde Child struct içeren structların isimleri hasChildParamList değerine yazılır.

        /* CF 11 uyumsuzluğundan dolayı kapatıldı */
        /* orderedData = structNew("ordered");

        structKeys = structKeyArray(responseData.data);
        arraySort(structKeys, "text", "asc");

        for (key in structKeys) {
            orderedData[key] = responseData.data[key];
        }

        responseData.data = orderedData; */

        return responseData;
    }

}