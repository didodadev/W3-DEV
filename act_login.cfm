<!-----------------------------------------------------------------------

*************************************************************************
		Copyright Katalizör Bilgi Teknolojileri Hizmetleri A.Ş www.workcube.com
*************************************************************************

Application	: 	W O R K C U B E    C A T A L Y S T
Motto		:	e-business Now!
Version		:	Cloud Edition New Generation

Version Leader		:	Omer Turhan
Development Team	:	Fatih Ayık, M.Emin Yaşartürk, Cemil Durgan, Emrah Kumru, Semih Akartuna ve tüm yazılım ekibi

Description			:
		Workcube is an e-business platform for corporates.
*************************************************************************
------------------------------------------------------------------------->

<cfinclude template="/AddOns/Plevne/interceptors/login.cfm">

<cfset login_action = createObject("component", "WMO.login")>
<cfset login_action.dsn = dsn/>

<cfif (listlen(safeip,';') eq 1 and listfirst(safeip,';') eq 1) or (listlen(safeip,';') eq 2 and not listfind(listlast(safeip,';'),cgi.remote_addr))>
	<cfset banned = login_action.get_ban_control()/>
	<cfif banned.recordcount>
		<cflocation addtoken="no" url="#request.self#?fuseaction=home.logout&secure_control=1">
	</cfif>
</cfif>

<cfinclude template="/AddOns/Plevne/interceptors/mfasubmit.cfm">

<cfif not (isDefined("form.username") and isDefined("form.password")) and (use_active_directory neq 2 or use_active_directory neq 3)>
 	<cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
	<cflocation url="#request.self#?fuseaction=home.login" addtoken="No">
	<cfabort>
</cfif>
<cfif isdefined("employee_browser_types") and len(employee_browser_types)>
	<cfset pass_browser_ = 0>
	<cfloop list="#employee_browser_types#" index="brs">
		<cfif browserdetect() contains brs>
			<cfset pass_browser_ = 1>
		</cfif>
	</cfloop>
	<cfif pass_browser_ eq 0>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no="2142.Lütfen Geçerli Bir Browser Kullanınız">! <cf_get_lang_main no="2143.Tanımlı Browserlar">: <cfoutput>#employee_browser_types#</cfoutput></cfsavecontent>
		<!--- <cfset session.error_text_pp = "#error_ses# #partner_browser_types#"> --->
		<cflocation url="#user_domain#" addtoken="No">
		<cfabort>
	</cfif>
</cfif>

<cfif use_active_directory eq 1>
	<cfset use_standart_login = 0>
	<cftry>
	   <cfldap action="QUERY"
		  name="auth"
		  attributes="#active_directory_atrr#"
		  start="#active_directory_start#"
		  server="#active_directory_server#"
		  username="#active_directory_server_add##form.username#"
		  password="#form.password#">
		<cfset isAuthenticated="yes">
		<cfcatch type="ANY">
		   <cfset isAuthenticated="no">
		   <cfset use_standart_login = 1>
		</cfcatch>
	</cftry>
<cfelseif use_active_directory eq 2>
	<cfset isAuthenticated="yes">
	<cfset use_standart_login = 0>
	<cfif isdefined("attributes.password")>
		<cftry>
		   <cfldap action="QUERY"
			  name="auth"
			  attributes="#active_directory_atrr#"
			  start="#active_directory_start#"
			  server="#active_directory_server#"
			  username="#active_directory_server_add##form.username#"
			  password="#form.password#">
			<cfset isAuthenticated="yes">
			<cfcatch type="ANY">
			   <cfset isAuthenticated="no">
			   <cfset use_standart_login = 1>
			</cfcatch>
		</cftry>
	</cfif>
<cfelseif use_active_directory eq 3>
	<cfset isAuthenticated="yes">
	<cfset use_standart_login = 0>
	<cfif isdefined("attributes.password")>
		<cftry>
		   <cfldap action="QUERY"
			  name="auth"
			  attributes="#active_directory_atrr#"
			  start="#active_directory_start#"
			  server="#active_directory_server#"
			  username="#active_directory_server_add##form.username#"
			  password="#form.password#">
			<cfset isAuthenticated="yes">
			<cfcatch type="ANY">
			   <cfset isAuthenticated="no">
			   <cfsavecontent variable="session.error_text"><cf_get_lang_main no="2265.Active Directory altında böyle bir kullanıcı bulunamadı."></cfsavecontent>
			   <cfset use_standart_login = 2><!--- Sadece Active Directory ile girişler sağlanacak. workcube şifresine bakmayacak. --->
			   <cfset EMPLOYEE_PASSWORD = CreateUUID()>
			</cfcatch>
		</cftry>
	</cfif>
<cfelse>
	<cfset use_standart_login = 1>
</cfif>

<cfif use_standart_login eq 1>
	<cf_cryptedpassword password="#password#" output="employee_password">
<cfelse>
	<cfset employee_password = ''>
</cfif>

<cfif not isdefined("use_password_maker")>
	<cfset use_password_maker = 0>
</cfif>
<cfset LOGIN = login_action.get_login_employee(username,employee_password,use_password_maker,use_standart_login,lang)/>

<cfset login_in = login.recordcount ? 1 : 0>

<cfset GET_SECURITY_LOGIN_INFO = login_action.get_security_login_info()/>
<cfif GET_SECURITY_LOGIN_INFO.recordcount and GET_SECURITY_LOGIN_INFO.IS_ACTIVE eq 1 and len(GET_SECURITY_LOGIN_INFO.LOGIN_COUNT) and GET_SECURITY_LOGIN_INFO.LOGIN_COUNT neq 0>
	<cfset GET_BANNED_USERS = login_action.get_username_ban_control(USERNAME)/>
	<cfif GET_BANNED_USERS.recordcount and GET_BANNED_USERS.recordcount gte GET_SECURITY_LOGIN_INFO.LOGIN_COUNT>
		<cfset login_in = 0>
	<cfelseif login.recordcount eq 1>
		<cfset login_in = 1>
	</cfif>
</cfif>

<cfset licenceAction = createObject("component", "WMO.functions")>
<cfset licenceActionInfo = licenceAction.GET_USER_LICENCE()>

<cfif licenceActionInfo.recordcount>
	<cfif len(login.employee_id)>
		<cfset licenceUserResult = login_action.GET_USER_LICENCE_LOGIN(login.employee_id)>
        <cfif licenceUserResult.recordcount and licenceUserResult.USER_ANSWER EQ 0>
            <cfset login_in = 0>
            <cfset session.error_text = 'Lisansı reddettiğiniz için giriş yapamazsınız'>
            <cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfif login_in eq 1>
	<cfset GET_EMP_AUTHORITY_CODES = login_action.GET_EMP_AUTHORITY_CODES(login.position_id)/>
	<cfquery name="GET_EMP_AUTHORITY_CODES_1" dbtype="query">
		SELECT AUTHORITY_CODE FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 3
	</cfquery>
	
	<cfset GET_STOP_LOGIN = login_action.GET_STOP_LOGIN(login.position_cat_id)/>

	<cfif get_stop_login.recordcount>
		<cfif len(get_stop_login.message)>
			<cfsavecontent variable="session.error_text"><cfoutput>#get_stop_login.message#</cfoutput></cfsavecontent>
		<cfelse>	
			<cfsavecontent variable="session.error_text"><cf_get_lang_main no='808.ip_hatasi'></cfsavecontent>
		</cfif>
		<cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
		<cfabort>
	</cfif>
	<cfif (login.is_ip_control eq 1) and (cgi.remote_addr neq login.ip_address and not (len(login.ip_address) and left(cgi.remote_addr,len(login.ip_address)) is '#login.ip_address#'))>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no='260.ip_hatasi'></cfsavecontent>
		<cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
		<cfabort>
	</cfif>
	<cfif not len(login.user_group_id) and not len(login.level_id)>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
		<cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
		<cfabort>
	</cfif>
	<cfset dark_mode="">
	<cfset light_mode="">
	<cfset dark_mode_number="">
	<cfset light_mode_number="">
	<cfloop index="i" from="1" to="5">
		<cfset dark_mode=dark_mode&Chr(RandRange(65, 90))>
		<cfset light_mode=light_mode&Chr(RandRange(65, 90))>
		<cfset light_mode_number=light_mode_number&RandRange(1, 9)>
		<cfset dark_mode_number=dark_mode_number&RandRange(1, 9)>
	</cfloop>
	<cfset session.dark_mode = "#dark_mode#:#dark_mode_number#">
	<cfset session.light_mode = "#light_mode#:#light_mode_number#">
    <!---
	<cfif get_workcube_app_user(login.employee_id,0).recordcount>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no='134.Bu Ozelliklerde Bir Kullanıcı Su Anda Sistemde!'></cfsavecontent>
		<cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
		<cfabort>
	</cfif>
	--->
    
	<!---<cfif session_tree_cont() eq 0>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no='1883.Sistem Maksimum Kullanıcı Sayısına Ulaştı'></cfsavecontent>
		<cflocation url="#request.self#?fuseaction=home.login" addtoken="no">
		<cfabort>
	</cfif> --->
    
    <cfset UPD_FAILED_LOGIN = login_action.update_failed_login(Lcase(attributes.USERNAME))/>
    
	<cfscript>
		//Dil değeri önceden oluşturulduğundan; kaybolmaması için local değişkene alınır.
		local.userLanguage = session.ep.language?:"tr";

		// partner ve public icin de bu ayarlamalar gereklidir. Değişiklikler oralara da uygulanmalı
		session.ep = StructNew();
		session.ep.userid = login.employee_ID;
		session.ep.week_start = login.week_start;
		session.ep.position_code = login.position_code;
		session.ep.money = login.money;
		session.ep.money2 = login.other_money;
		session.ep.other_money = login.standart_process_money;
		session.ep.time_zone = login.time_zone;
		session.ep.name = login.employee_name;
		session.ep.surname = login.employee_surname;
		session.ep.position_name = login.position_name;
		session.ep.consumer_priority = login.consumer_priority;
		session.ep.discount_valid = login.discount_valid;
		session.ep.duedate_valid = login.duedate_valid;
		session.ep.member_view_control = login.member_view_control;
		session.ep.price_valid = login.price_valid;
		session.ep.price_display_valid = login.price_display_valid;
		session.ep.cost_display_valid = login.cost_display_valid;
		session.ep.rate_valid = login.rate_valid;
		session.ep.their_records_only = login.their_records_only;
		session.ep.language = local.userLanguage != "tr" ? local.userLanguage : login.language_id;
		session.ep.design_id = len(login.interface_id) ? login.interface_id : 1;
		session.ep.menu_id = login.WRK_MENU;
		session.ep.design_color = login.interface_color;
		session.ep.username = login.employee_username;
		session.ep.userkey = 'e-#login.employee_id#';
		session.ep.company_id = login.our_company_id;
		session.ep.company = login.company_name;
		session.ep.company_email = login.email;
		session.ep.company_nick = login.nick_name;
		session.ep.period_id = login.period_id;
		session.ep.period_start_date = dateformat(login.start_date,'yyyy-mm-dd');
		session.ep.period_finish_date = dateformat(login.finish_date,'yyyy-mm-dd');
		session.ep.ehesap = login.ehesap;
		session.ep.maxrows = login.maxrows;
		session.ep.server_machine = fusebox.server_machine;
		if(isDefined("session.SESSIONID"))
			session.ep.workcube_id = session.SESSIONID;
		else
			session.ep.workcube_id = cookie.JSESSIONID;
		session.ep.our_company_info = StructNew();
		
		session.ep.our_company_info.workcube_sector = login.workcube_sector;
		session.ep.our_company_info.is_paper_closer =login.is_paper_closer;
		session.ep.our_company_info.is_cost =login.is_cost;
		session.ep.our_company_info.is_cost_location =login.is_cost_location;
		session.ep.our_company_info.guaranty_followup = login.is_guaranty_followup;
		session.ep.our_company_info.project_followup = login.is_project_followup;
		session.ep.our_company_info.asset_followup = login.is_asset_followup;
		session.ep.our_company_info.sales_zone_followup = login.is_sales_zone_followup;
		session.ep.our_company_info.subscription_contract=login.is_subscription_contract;
		session.ep.our_company_info.sms = login.is_sms;
		session.ep.our_company_info.unconditional_list = login.is_unconditional_list;
		session.ep.our_company_info.spect_type = login.spect_type;
		session.ep.our_company_info.is_ifrs = login.is_use_ifrs;
		session.ep.our_company_info.rate_round_num = login.rate_round_num;
		session.ep.our_company_info.purchase_price_round_num = login.purchase_price_round_num;
		session.ep.our_company_info.sales_price_round_num = login.sales_price_round_num;
		session.ep.our_company_info.is_prod_cost_type = login.is_prod_cost_type;
		session.ep.our_company_info.is_stock_based_cost = login.is_stock_based_cost;
		session.ep.our_company_info.is_project_group = login.is_project_group;
		session.ep.our_company_info.special_menu_file = login.special_menu_file;
		session.ep.our_company_info.is_maxrows_control_off = login.is_maxrows_control_off;
		session.ep.our_company_info.is_add_informations = login.is_add_informations;
		session.ep.our_company_info.is_efatura = login.is_efatura;
		session.ep.our_company_info.efatura_date = login.efatura_date;
		session.ep.our_company_info.is_edefter = login.is_edefter;
		session.ep.our_company_info.is_earchive = login.is_earchive;
		session.ep.our_company_info.earchive_date = login.earchive_date;		
		session.ep.our_company_info.is_lot_no = login.is_lot_no;
		session.ep.our_company_info.is_eshipment = login.is_eshipment;
		session.ep.our_company_info.eshipment_date = login.eshipment_date;
		if(len(login.dateformat_style))
			session.ep.dateformat_style = login.dateformat_style;
		else {
			session.ep.dateformat_style = 'dd/mm/yyyy';
		}
		if(len(login.timeformat_style))
			session.ep.timeformat_style = login.timeformat_style;
		else {
			session.ep.timeformat_style = 'HH:mm';
		}
		if(len(login.moneyformat_style))
			session.ep.moneyformat_style = login.moneyformat_style;
		else {
			session.ep.moneyformat_style = 0;
		}
		if(len(login.is_location_follow))
			session.ep.our_company_info.is_location_follow = login.is_location_follow;
		else
			session.ep.our_company_info.is_location_follow = 0;
		//session.ep.authority_code = StructNew();
		session.ep.authority_code_hr = "#get_emp_authority_codes_1.authority_code#";
		if(not len(login.admin_status)) session.ep.admin = 0;
		else session.ep.admin = login.admin_status;
		
		if(not len(login.power_user_level_id))
		{
			session.ep.power_user = 0;
			session.ep.power_user_level_id = '';
		}
		else
		{
			session.ep.power_user = 1;
			session.ep.power_user_level_id = login.power_user_level_id;
		}
		session.ep.dockphone = login.SENSITIVE_USER_LEVEL;
		session.ep.report_user_level = login.REPORT_USER_LEVEL;
		session.ep.data_level = login.DATA_LEVEL;
		session.ep.timeout_min = login.TIMEOUT_LIMIT;
		session.ep.worktips_open = ( isdefined("login.WORKTIPS_OPEN") and len(login.WORKTIPS_OPEN) ) ? login.WORKTIPS_OPEN : 0;
		// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020
		get_priority_branch_dept = login_action.GET_BRANCH_DEPT(login.position_code,login.our_company_id);
		if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID) and len(get_priority_branch_dept.LOCATION_ID))
			session.ep.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID&'-'&get_priority_branch_dept.LOCATION_ID;
		else if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID))
			session.ep.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID;
		else
			session.ep.user_location = login.DEPARTMENT_ID&'-'&login.BRANCH_ID;
		// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020

		// period date of login user
		get_period_date = login_action.get_period_date(LOGIN.POSITION_ID,LOGIN.PERIOD_ID);
		session.ep.period_year=login.period_year;
		session.ep.period_is_integrated=login.is_integrated;
		if (len(get_period_date.period_date)) 
			session.ep.period_date = dateformat(get_period_date.period_date,'yyyy-mm-dd');
		else if (len(login.period_date)) 
			session.ep.period_date =dateformat(login.period_date,'yyyy-mm-dd');
		else 
			session.ep.period_date = "#login.period_year#-01-01";
		// period date of login user
		// grup uyesi
		if (len(get_period_date.process_date))
			session.ep.process_date = dateformat(get_period_date.process_date,'yyyy-mm-dd');
		else if (len(login.process_date)) 
			session.ep.process_date=dateformat(login.process_date,'yyyy-mm-dd');
		else 
			session.ep.process_date = "#login.period_year#-01-01";
		if (len(login.user_group_id))
		{
			GET_USER_GROUPS = login_action.get_user_groups(login.user_group_id);
			session.ep.user_level = get_user_groups.user_group_permissions;
			//if(isdefined("use_extra_modules") and use_extra_modules eq 1 and get_modules_extra.recordcount)
			//	session.ep.user_level_extra = get_user_groups.user_group_permissions_extra;	
			if(len(get_user_groups.IS_BRANCH_AUTHORIZATION))
				session.ep.isBranchAuthorization = get_user_groups.IS_BRANCH_AUTHORIZATION;
			else
				session.ep.isBranchAuthorization = 0;
		}
		else 
		{
			session.ep.user_level = login.level_id;
		//	if(isdefined("use_extra_modules") and use_extra_modules eq 1 and get_modules_extra.recordcount)
		//		session.ep.user_level_extra = login.level_extra_id;
			session.ep.isBranchAuthorization = 0;
		}
		structDelete(session, "error_text");
		session.ep.is_order_closed = 0;// pp-ww deki gibi siparisin odemesi kontrolu icim eklendi
		if(isdefined("attributes.screen_width"))
		{
			session.ep.screen_width = "#attributes.screen_width#";
			session.ep.screen_height = "#attributes.screen_height#";
		}
		else
		{
			session.ep.screen_width = "-1";
			session.ep.screen_height = "-1";
		}
	</cfscript>
	
	<cfset pass_control = login_action.get_pass_control()/>
	<cfif pass_control.recordcount>
		<cfset get_pass_ = login_action.get_user_pass_control(login.employee_id)/>
		<cfif get_pass_.recordcount>
			<cfif get_pass_.force_password_change eq 1 or datediff('d',get_pass_.record_date,now()) gt pass_control.password_change_interval>
				<cfset session.ep.must_password_change = 1>
			<cfelse>
				<cfset session.ep.must_password_change = 0>
			</cfif>
		<cfelse>
			<cfset session.ep.must_password_change = 1>
		</cfif>
		<cfif session.ep.must_password_change EQ 1>
			<cfset session.ep.must_password_change_ignore_actions = ["myhome.list_myaccount_password","myhome.account_process","home.logout"]>
		</cfif>
	</cfif>
	
	<cfif isdefined("use_password_maker") and use_password_maker eq 1 and login.SEND_PASSWORD_MAKER eq 1>
		<cfset session.ep.user_password_maker = 1>
	</cfif>
	
	<cfinclude template="/AddOns/Plevne/interceptors/gopchacontrol.cfm">

	<!--- session degiskenleri db ye --->
	<cfset attributes.session_text = "session.ep">
	<cfinclude template="add_variables.cfm">
	<cfset add_login_table = login_action.ADD_LAST_LOGIN(session.ep.userid,fusebox.server_machine,'#browserDetect()#')>
	<!--- eger rapor sistemi degilse uretim planlamada simulasyonda girdigi urunleri siliyor --->
    <cfif only_report_system eq 0  and fusebox.use_period>
        <cfset del_rows = login_action.del_production_rows(session.ep.userid,'#dsn#_#session.ep.company_id#')>
    </cfif>
	<cfscript>
		// 20040318 explorer surumu 6 dan küçük olanlari görelim
		browser_flag = 0;
		if(Find("MSIE",cgi.http_user_agent))
		{
			if(Val(RemoveChars(cgi.http_user_agent,1,Find("MSIE",cgi.http_user_agent)+4)) lt 6)
				browser_flag = 1;
		}
	</cfscript>
	
	<cfif browser_flag>
		<cfmail to="#session.ep.company#<#session.ep.company_email#>" charset="utf-8" subject="Eski Browser" from="#listlast(server_detail)#<#listfirst(server_detail)#>">#session.ep.name# #session.ep.surname# (#session.ep.position_name#-#cgi.REMOTE_ADDR# ; #cgi.http_user_agent#)</cfmail>
	</cfif>
	<cfif session.ep.design_id eq 6>
		<cflocation url="#request.self#?fuseaction=cubetv.welcome" addtoken="No">
	</cfif>
    
	<cfif isDefined('form.referer') and len(form.referer)>
		<cflocation url="#form.referer#" addtoken="No">
	<cfelse>
		<cfif isDefined("session.originalURL")>
			<cfset local.directURL = session.originalURL>
			<cfset StructDelete(session, "originalURL")/>
			<cflocation url="#local.directURL#" addtoken="no">
		<cfelse>
			<cflocation url="#request.self#?fuseaction=myhome.welcome" addtoken="No">
		</cfif>
	</cfif>
	<cfabort>
<cfelse>
	<cfset GET_SECURITY_LOGIN_INFO = login_action.get_security_login_info()/>
	<cfif GET_SECURITY_LOGIN_INFO.recordcount and GET_SECURITY_LOGIN_INFO.IS_ACTIVE eq 1 and len(GET_SECURITY_LOGIN_INFO.LOGIN_COUNT) and GET_SECURITY_LOGIN_INFO.LOGIN_COUNT neq 0>
		<cfset GET_FAILED_LOGIN = login_action.get_failed_login(Lcase(attributes.USERNAME))/> 
		<cfset ADD_FAILED_LOGIN = login_action.add_failed_login(Lcase(attributes.USERNAME),CGI.REMOTE_ADDR,dateAdd('h',2,now()))/> 
		<cfif GET_FAILED_LOGIN.recordcount gt GET_SECURITY_LOGIN_INFO.LOGIN_COUNT-1>
			<cfsavecontent variable="session.error_text"><cf_get_lang_main no="2264. Hatalı Giriş Sayısını Aştınız"><cf_get_lang_main no="2241. Ssitem Yönteticinize Başvurunuz"></cfsavecontent>
		</cfif>
	</cfif>
	<cfif not isDefined("session.error_text")>
		<cfsavecontent variable="session.error_text"><cf_get_lang_main no='126.session_error'></cfsavecontent>
	</cfif>
	<cflocation url="#request.self#?fuseaction=home.login&error=1" addtoken="No">
	<cfabort>
</cfif>
