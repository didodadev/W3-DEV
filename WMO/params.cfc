<cfcomponent>   
    
    <cfset paramsSettings = createObject("component", "workcube.V16.settings.cfc.params_settings")>
    <cfset params = paramsSettings.getDeserializedParams()>
	<cfset getreleaseno = paramsSettings.GET_PARAMS()>

    <cffunction name="Get" access="remote" returntype="struct">
		<cfif NOT IsDefined("application.host.hostName")> 
            <cfscript> 
                application.host.inet = createObject("java", "java.net.InetAddress"); 
                application.host.hostName = application.host.inet.localhost.getHostName(); 
            </cfscript>
        </cfif>
        <cfscript>
            var systemParam = StructNew();
            structAppend(systemParam, params, false );

            //Kaldırılacak değerler params_controller.cfc dosyasına eklenmeli ve aşağıdaki gibi koşula alınmalı!

            if(not StructKeyExists(systemParam, "database_type")) systemParam.database_type = 'MSSQL';
            if(not StructKeyExists(systemParam, "dir_seperator")) systemParam.dir_seperator = '/';
            if(not StructKeyExists(systemParam, "index_folder")) systemParam.index_folder = '#replacenocase(replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"WMO\",""),"WMO/","")#V16/';
            if(not StructKeyExists(systemParam, "file_web_path")) systemParam.file_web_path = '/documents/';
            if(not StructKeyExists(systemParam, "server_detail")) systemParam.server_detail = 'aksay@aksayplastik.com,Workcube Aksay Plastik Server';
            if(not StructKeyExists(systemParam, "use_spect_company ")) systemParam.use_spect_company  = '';
            if(not StructKeyExists(systemParam.fusebox, "use_period")) systemParam.fusebox.use_period  = True;

            var systemParam.company_asset_relation = 0;
            var systemParam.is_gov_payroll =  0;
            var systemParam.workcube_version = '#getreleaseno.RELEASE_NO#';
            var systemParam.reportman_url = 'http://reportman.workcube.com/';
            var systemParam.career_url = 'cp.workcube;cp.saha';
            var systemParam.career_companies = '1;1';
            var systemParam.pda_url = 'pda.workcube;pda3.workcube';
            var systemParam.pda_companies = '1;1';
            var systemParam.session_tree = 'FJIU';
            var systemParam.emp_mail_path = replacenocase(replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"WMO\",""),"WMO/","") & 'documents/emp_mails/';
            var systemParam.par_mail_path = replacenocase(replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"WMO\",""),"WMO/","") & 'documents/par_mails/';
            var systemParam.con_mail_path = replacenocase(replacenocase(GetDirectoryFromPath(GetCurrentTemplatePath()),"WMO\",""),"WMO/","") & 'documents/con_mails/';
            var systemParam.only_report_system = '0';
			var systemParam.lang_list = 'tr';
            var systemParam.reserved_words = '';
            var systemParam.fusebox.dynamic_hierarchy = true;
            var systemParam.fusebox.workcube_log = false;
            var systemParam.use_https = '0';
            var systemParam.fusebox.Format_Currency = '0';
            var systemParam.workcube_mode = '0';
            var systemParam.fusebox.use_stock_speed_reserve = false;
            var systemParam.fusebox.process_tree_control = '0';
            var systemParam.safeip = '';

            var systemParam.is_wrk_visit_report = 1;
            
            var systemParam.workcube_mode_ip = '192.168.18.100,192.168.18.54,192.168.18.53,213.144.115.154,192.168.18.168,192.168.18.19,192.168.18.14,192.168.18.17,192.168.18.22,192.168.18.18,192.168.18.140,192.168.18.129,192.168.18.139,192.168.6.10,192.168.18.49,213.144.115.154,192.168.6.19,192.168.6.11,192.168.6.15,192.168.18.142,192.168.6.18,192.168.19.62,192.168.18.75,192.168.18.97,213.144.115.202,10.0.0.14,10.0.0.12,10.0.0.13,192.168.18.27,10.0.0.11,192.168.18.126,192.168.7.77,192.168.18.58,10.0.0.16,10.0.0.19,192.168.18.15,192.168.18.25,10.0.0.15,192.168.18.39,192.168.18.109,192.168.18.170,192.168.18.122,195.214.144.238,10.0.0.14,192.168.18.139,192.168.18.51,10.0.0.31';//development modda gorunmesini istedigimiz ıpler
            var systemParam.is_fulltext_search = 0; //company ve content üzerinde hızlı arama yapmak için set edilir 0 kapalı 1 açık.Content için  workcube_report v14 klasörü  altında fulltextsearch ,Company için fulltextsearch1 dosyalarının içindeki scriptler çalıştırılır.
            var systemParam.netbook_folder = '\\wrkedeftersrv2\edefter'; //#GetDirectoryFromPath(GetCurrentTemplatePath())#netbooks
			var systemParam.request.self = 'index.cfm';
			//Buradan aşağıdaki parametreler parametre olarak fbx_settings, fbx_circuits gibi sayfalarda kullanılıyordu. Buraya toplandı.      
			if(len(systemParam.server_url) && listfindnocase(systemParam.server_url,'#cgi.http_host#',';')){
				var systemParam.server_url_company = listgetat(systemParam.server_companies,listfindnocase(systemParam.server_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.server_url_company;
			}
			if(len(systemParam.pda_url) && listfindnocase(systemParam.pda_url,'#cgi.http_host#',';')){
				var systemParam.pda_url_company = listgetat(systemParam.pda_companies,listfindnocase(systemParam.pda_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.pda_url_company;
			}
			if(len(systemParam.pda_url) && listfindnocase(systemParam.pda_url,'#cgi.http_host#',';')){
				var systemParam.career_url_company = listgetat(systemParam.career_companies,listfindnocase(systemParam.career_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.career_url_company;
			}
			if(len(systemParam.partner_url) && listfindnocase(systemParam.partner_url,'#cgi.http_host#',';')){
				var systemParam.partner_url_company = listgetat(systemParam.partner_companies,listfindnocase(systemParam.partner_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.partner_url_company;
			}
			var systemParam.dsn1 = '#systemParam.dsn#_product';
			var systemParam.dsn_report = '#systemParam.dsn#_report';
			var systemParam.employee_domain = 'http://#listfirst(systemParam.employee_url,';')#/';
			var systemParam.pda_domain = 'http://#listfirst(systemParam.pda_url,';')#/';
			var systemParam.partner_domain = 'http://#listfirst(systemParam.partner_url,';')#/';
			var systemParam.public_domain = 'http://#listfirst(systemParam.server_url,';')#/'; 
			//kullanicinin su anda calistigi domain hangisi //#user_domain#
			if(isdefined("use_https_all") and use_https_all eq 1)//tümü https ise
				var systemParam.user_domain = 'https://#cgi.http_host#/';
			else if((cgi.server_port eq '80') or ListLen(cgi.http_host,':') gt 1)//port adi hostta tanimli ise tekrar eklenmeyecek ':' e gore kontrol ettik fbs20091023
				var systemParam.user_domain = 'http://#cgi.http_host#/';
			else
				var systemParam.user_domain = 'http://#cgi.http_host#:#cgi.server_port#/';
			var systemParam.https_domain = 'https://#cgi.http_host#/';
        </cfscript>
		<cfreturn systemParam>
    </cffunction>

</cfcomponent>