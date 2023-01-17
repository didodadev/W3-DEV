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
            var systemParam.workcube_version = 'dev';
            var systemParam.server_detail = 'admin@workcube.com,Workcube Catalyst Development Server';
            var systemParam.database_type = 'MSSQL';
            var systemParam.dsn = 'workcube_dev';
            var systemParam.database_host = '127.0.0.1';
            var systemParam.database_port = '1433';
            var systemParam.database_folder = 'C:\W3Catalyst\Dev\DB\';
            var systemParam.database_log_folder = 'C:\W3Catalyst\Dev\DB\';
            var systemParam.fusebox.server_machine = '1';
            var systemParam.reportman_url = 'http://reportman.workcube.com/';
           
                    var systemParam.fusebox.server_machine_list = 'https://dev.workcube.com';
                    var systemParam.employee_url = 'dev.workcube.com';
                    var systemParam.server_url = 'ww.workcube';
                    var systemParam.server_companies = '1';
                    var systemParam.partner_url = 'project.catalyst';
                    var systemParam.partner_companies = '1';
                    var systemParam.career_url = 'cp.workcube;cp.saha';
                    var systemParam.career_companies = '1;1';
                    var systemParam.pda_url = 'pda.workcube;pda3.workcube';
                    var systemParam.pda_companies = '1;1';
                    var systemParam.session_tree = 'FJIU';
                    var systemParam.emp_mail_path = '#GetDirectoryFromPath(GetCurrentTemplatePath())#documents\emp_mails\';
                    var systemParam.par_mail_path = '#GetDirectoryFromPath(GetCurrentTemplatePath())#documents\par_mails\';
                    var systemParam.con_mail_path = '#GetDirectoryFromPath(GetCurrentTemplatePath())#documents\con_mails\';
                    var systemParam.upload_folder = 'C:\W3Catalyst\Dev\PROD\documents\';
                    var systemParam.download_folder = 'C:\W3Catalyst\Dev\PROD\';
           
            //git parameters
            var systemParam.git = {
                git_dir : 'C:\W3Catalyst\Dev\PROD\',
                git_url : 'https://bitbucket.org/workcube/devcatalyst.git',
                git_username : 'bitbucketserver',
                git_password : 'Abt112233*!',
                git_self_pull : true
            }

            var systemParam.recaptcha = false;
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
			var systemParam.index_folder = '#Replace(GetDirectoryFromPath(GetCurrentTemplatePath()),"WMO\","")#v16\';
            
			//Active Directory bileşenleri
			var systemParam.use_active_directory = '0';
			var systemParam.active_directory_server = 'wrkdcsrv';
			var systemParam.active_directory_server_add = 'CUBE\';
			var systemParam.active_directory_start = 'cn=users,dc=wrkdcsrv';
			var systemParam.active_directory_atrr = 'cn,sn,mail';
			//Active Directory bileşenleri

            var systemParam.safeip = '';
            
            var systemParam.partner_browser_types = '';
            var systemParam.mobile_url = '';
            var systemParam.use_script_on_process = '0';
            var systemParam.use_password_reminder = 1;
            var systemParam.is_pdf_header = '0'; 
            var systemParam.campaign_mail_address_list = '0';
            var systemParam.company_asset_relation = 0; 
            var systemParam.default_company_id_ = 1; 
            var systemParam.is_wrk_visit_report = 1;
            var systemParam.is_performance_counter = 0;
            var systemParam.is_gov_payroll =  0;
            var systemParam.workcube_mode_ip = '127.0.0.1,77.92.119.10';//development modda gorunmesini istedigimiz ıpler
            var systemParam.is_fulltext_search = 0; //company ve content üzerinde hızlı arama yapmak için set edilir 0 kapalı 1 açık.Content için  workcube_report v14 klasörü  altında fulltextsearch ,Company için fulltextsearch1 dosyalarının içindeki scriptler çalıştırılır.
            var systemParam.netbook_folder = '\\wrkedeftersrv2\edefter'; //#GetDirectoryFromPath(GetCurrentTemplatePath())#netbooks
			var systemParam.request.self = 'index.cfm';
			//Buradan aşağıdaki parametreler parametre olarak fbx_settings, fbx_circuits gibi sayfalarda kullanılıyordu. Buraya toplandı.
			if(not isdefined("systemParam.default_company_id_"))
				var systemParam.default_company_id_ = 1;
			var systemParam.is_only_show_page = 0;
			var systemParam.attributes.is_basket_hidden = 0;
			if(listfindnocase(systemParam.server_url,'#cgi.http_host#',';')){
				var systemParam.server_url_company = listgetat(systemParam.server_companies,listfindnocase(systemParam.server_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.server_url_company;
			}
			
			if(listfindnocase(systemParam.pda_url,'#cgi.http_host#',';')){
				var systemParam.pda_url_company = listgetat(systemParam.pda_companies,listfindnocase(systemParam.pda_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.pda_url_company;
			}
			
			if(listfindnocase(systemParam.career_url,'#cgi.http_host#',';')){
				var systemParam.career_url_company = listgetat(systemParam.career_companies,listfindnocase(systemParam.career_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.career_url_company;
			}
			
			if(listfindnocase(systemParam.partner_url,'#cgi.http_host#',';')){
				var systemParam.partner_url_company = listgetat(systemParam.partner_companies,listfindnocase(systemParam.partner_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.partner_url_company;
			}
			
			if(listfindnocase(systemParam.mobile_url,'#cgi.http_host#',';')){
				var systemParam.mobile_url_company = listgetat(systemParam.mobile_companies,listfindnocase(systemParam.mobile_url,'#cgi.http_host#',';'),';');
				var systemParam.default_company_id_ = systemParam.mobile_url_company;
			}

			var systemParam.dsn1 = '#systemParam.dsn#_product';
			var systemParam.dsn_report = '#systemParam.dsn#_report';

			var systemParam.free_actions = 'home.ban,agenda.emptypopup_get_event_xml,objects.popup_view_map,home.attacked,home.popup_send_password,home.popup_send_password,home.popup_password_arrangement,home.login,home.act_login,home.act_login1,home.emptypopup_act_login,home.logout,schedules.emptypopup_send_birthday_married_date,home.act_logout,home.popup_clear_session,home.emptypopup_clear_session,schedules.emptypopupflush_pos_sales,schedules.emptypopup_upd_currency_info,schedules.emptypopup_5min,schedules.emptypopup_events,schedules.emptypopup_1min,schedules.emptypopup_hourly,schedules.emptypopup_import_currency,schedules.emptypopup_daily,schedules.emptypopup_weekly,schedules.emptypopup_monthly,schedules.emptypopup_schedule_action,schedules.emptypopupflush_daily,schedules.emptypopup_warning_company_branch_related,myhome.emptypopup_vote_survey,myhome.popup_vote_results,objects.emptypopup_get_chat_user,schedules.emptypopup_add_product_xml,schedules.emptypopup_add_cost,schedules.card_info_update,schedules.emptypopup_show_order_details,schedules.emptypopup_work_rate_warnings,objects.emptypopupflush_xml_import_order_query,objects.emptypopupflush_xml_import_ship_query,objects.emptypopupflush_xml_import_ship_purchase_query,schedules.emptypopup_work_update_schedules,schedules.emptypopup_project_update_schedules,home.emptypopup_remove_email_from_list,home.installation,home.emptypopup_installation,objects2.popup_add_member_company,schedules.emptypopup_get_social_media_info,objects2.popup_change_pass,objects2.emptypopup_add_change_cons_pass,home.emptypopup_fms_auth_id,schedules.emptypopup_upd_warning_confirm_actions,home.emptypopup_tvradio_channel_status,home.emptypopup_isbak_mobil,schedules.emptypopup_finish_related_contract_warnings,objects2.emptypopup_add_comp_member,objects2.emptypopup_get_workdata,objects.form_add_detailed_survey_main_result,objects.emptypopup_add_detailed_survey_main_result';
			var systemParam.file_web_path = '/documents/';
			
			
			systemParam.employee_domain = 'http://#listfirst(systemParam.employee_url,';')#/';
			systemParam.pda_domain = 'http://#listfirst(systemParam.pda_url,';')#/';
			systemParam.mobile_domain = 'http://#listfirst(systemParam.mobile_url,';')#/';
			systemParam.partner_domain = 'http://#listfirst(systemParam.partner_url,';')#/';
			systemParam.public_domain = 'http://#listfirst(systemParam.server_url,';')#/'; 
			
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

            //retail wbp
            var systemParam.dsn_gen = 'Genius3';
            var systemParam.dsn_gen_alias = 'Genius3';
            var systemParam.dsn_dev = 'workcube_dev_retail';
            var systemParam.dsn_dev_alias = 'workcube_dev_retail';
            var systemParam.genel_fiyat_listesi = 1;
            var systemParam.merkez_depo_id = 13;
            var systemParam.iade_depo_id = 17;
            var systemParam.merkez_lokasyon_id = 1;
            var systemParam.min_stock_deger = 0.1;
            var systemParam.min_stock_deger_warning = 0.15;
            var systemParam.ambalaj_type_id = 5;
            var systemParam.uretici_type_id = 4;
            var systemParam.muadil_type_id = 10;
            var systemParam.marka_type_id = 3;
            var systemParam.promosyon_type_id = 7;
            var systemParam.market_promosyon_type_id = 11;
            var systemParam.sektor_type_id = 6;
            var systemParam.buyukluk_type_id = 1;
            var systemParam.firin_depo_id = 14;
            var systemParam.order_stage_ = 43;
            var systemParam.valid_order_stage_ = 76;
            var systemParam.tekli_siparis_mail_form = 23;
            var systemParam.coklu_siparis_mail_form = 31;
            var systemParam.fazla_stok = "1";
            var systemParam.market_name = "Gülgen";
            var systemParam.market_fullname = "Gülgen Market";
            var systemParam.order_row_currency_id_list = "-1,-2,-3,-4,-5,-6,-7,-8,-9,-10";
            var systemParam.order_row_currency_name_list = "Açık,Tedarik,Kapatıldı,Kısmi,Üretim,Sevk,Eksik Teslimat,Fazla Teslimat,İptal,Kapatıldı";
            var systemParam.kasa_cikislar = "3,8,9,10,13";
            var systemParam.kasa_cikis_olmayanlar = "2,4,5";
            var systemParam.kasa_cikislar_maliyetsiz = "13";
            var systemParam.magaza_department_list = '1,3,4,6,7,9,10,11,12,21,22';
            var systemParam.satis_karakterli_processler = '67,52,53,70,71,-1003,-1004,-1005';
            var systemParam.yazar_kasa_pos_odeme_tipleri = '1,2,3,7,8,9,10,13,15,16,17,18,20,21,22';
            var systemParam.yazar_kasa_cek_odeme_tipleri = '11,12,14,23,24,25';
            var systemParam.yazar_kasa_nakit_odeme_tipleri = '0,5,6,26';
            var systemParam.kasa_cikislar = "3,8,9,10,13";
            var systemParam.kasa_cikis_olmayanlar = "2,4,5,12";
            var systemParam.fazla_stok = "1";
            var systemParam.dahil_olmayan_tipler = "91,690,691";
            var systemParam.senet_yazici = "\\192.168.0.31\HP LaserJet Professional P1102";
            var systemParam.kasa_cikislar = "3,8,9,10,13";
            var systemParam.kasa_cikis_olmayanlar = "2,4,5,12";
            var systemParam.fazla_stok = "1";
            var systemParam.koli_unit = "10";
            var systemParam.teneke_unit = "39";
            var systemParam.palet_unit = "31";
            var systemParam.bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())));
        </cfscript>
		<cfreturn systemParam>
    </cffunction>
</cfcomponent>