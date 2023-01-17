<cfcomponent>
    <cffunction name="systemParam" access="remote" returntype="struct">
		<cfif NOT IsDefined("application.host.hostName")> 
            <cfscript> 
                application.host.inet = createObject("java", "java.net.InetAddress"); 
                application.host.hostName = application.host.inet.localhost.getHostName(); 
            </cfscript> 
        </cfif>
        
        <cfscript>
			var systemParam = StructNew();
            var systemParam.workcube_version = 'Protein v2.0';
            var systemParam.server_detail = 'admin@yazilimsa.com,Workcube Catalyst Development Server';
            var systemParam.database_type = 'MSSQL';
            var systemParam.dsn = 'workcube_worknet';
            var systemParam.database_host = 'devsql';
            var systemParam.database_folder = 'C:\DEVSQL_DATA\';
            var systemParam.database_log_folder = 'C:\DEVSQL_DATA\';
            var systemParam.fusebox.server_machine = '1';	
            var systemParam.session_tree = 'FJIU';
            var systemParam.upload_folder = '/var/www/networg/public_html/documents/';
            var systemParam.download_folder = '/var/www/networg/public_html/';
            var systemParam.index_folder = '/var/www/networg/public_html/';
            var systemParam.app_folder = '/var/www/networg/public_html/';
            var systemParam.only_report_system = '0';
			var systemParam.lang_list = 'tr';
            var systemParam.reserved_words = '';
            var systemParam.dir_seperator = '\';
            var systemParam.fusebox.dynamic_hierarchy = true;
            var systemParam.fusebox.workcube_log = false;
            var systemParam.use_https = '0';
            var systemParam.fusebox.Format_Currency = '0';
            var systemParam.fusebox.use_spect_company = '';
            var systemParam.workcube_mode = '0';
            var systemParam.fusebox.use_period = True;
            var systemParam.standart_process_money = 'TL';
            var systemParam.standart_process_other_money = 'USD';
            var systemParam.fusebox.use_stock_speed_reserve = false;
            var systemParam.fusebox.process_tree_control = '0';
			
			var systemParam.employee_url = 'dev-jakarta.workcube.com';		
			var systemParam.dsn1 = '#systemParam.dsn#_product';
			var systemParam.dsn_report = '#systemParam.dsn#_report';
			var systemParam.free_actions = 'home.ban,agenda.emptypopup_get_event_xml,objects.popup_view_map,home.attacked,home.popup_send_password,home.popup_send_password,home.popup_password_arrangement,home.login,home.act_login,home.act_login1,home.emptypopup_act_login,home.logout,schedules.emptypopup_send_birthday_married_date,home.act_logout,home.popup_clear_session,home.emptypopup_clear_session,schedules.emptypopupflush_pos_sales,schedules.emptypopup_upd_currency_info,schedules.emptypopup_5min,schedules.emptypopup_events,schedules.emptypopup_1min,schedules.emptypopup_hourly,schedules.emptypopup_import_currency,schedules.emptypopup_daily,schedules.emptypopup_weekly,schedules.emptypopup_monthly,schedules.emptypopup_schedule_action,schedules.emptypopupflush_daily,schedules.emptypopup_warning_company_branch_related,myhome.emptypopup_vote_survey,myhome.popup_vote_results,objects.emptypopup_get_chat_user,schedules.emptypopup_add_product_xml,schedules.emptypopup_add_cost,schedules.card_info_update,schedules.emptypopup_show_order_details,schedules.emptypopup_work_rate_warnings,objects.emptypopupflush_xml_import_order_query,objects.emptypopupflush_xml_import_ship_query,objects.emptypopupflush_xml_import_ship_purchase_query,schedules.emptypopup_work_update_schedules,schedules.emptypopup_project_update_schedules,home.emptypopup_remove_email_from_list,home.installation,home.emptypopup_installation,objects2.popup_add_member_company,schedules.emptypopup_get_social_media_info,objects2.popup_change_pass,objects2.emptypopup_add_change_cons_pass,home.emptypopup_fms_auth_id,schedules.emptypopup_upd_warning_confirm_actions,home.emptypopup_tvradio_channel_status,home.emptypopup_isbak_mobil,schedules.emptypopup_finish_related_contract_warnings,objects2.emptypopup_add_comp_member,objects2.emptypopup_get_workdata,objects.form_add_detailed_survey_main_result,objects.emptypopup_add_detailed_survey_main_result';
			var systemParam.file_web_path = '/documents/';
			
			
			systemParam.employee_domain = 'http://#listfirst(systemParam.employee_url,';')#/';
			
			//kullanicinin su anda calistigi domain hangisi //#user_domain#
			if(isdefined("use_https_all") and use_https_all eq 1)//tümü https ise
				var systemParam.user_domain = 'https://#cgi.http_host#/';
			else if((cgi.server_port eq '80') or ListLen(cgi.http_host,':') gt 1)//port adi hostta tanimli ise tekrar eklenmeyecek ':' e gore kontrol ettik fbs20091023
				var systemParam.user_domain = 'http://#cgi.http_host#/';
			else
				var systemParam.user_domain = 'http://#cgi.http_host#:#cgi.server_port#/';
			var systemParam.https_domain = 'https://#cgi.http_host#/';
			
			var systemParam.colorrow = 'ffffff';
            var systemParam.colorlist = 'ffffff';
            var systemParam.colorborder = 'ffffff';
            var systemParam.colorheader = 'ffffff';
        </cfscript>
		<cfreturn systemParam>
    </cffunction>
</cfcomponent>