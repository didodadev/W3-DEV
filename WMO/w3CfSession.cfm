<!--- oturumlar kontrolü application update edelim ve kullanici online mi bakalim degilse atalim  --->

<cfif isDefined("session.sessionid")>
	<cfset sessInfo = session.sessionid>
<cfelse>
    <cfset sessInfo = cookie.jsessionid>
</cfif>

<cfstoredproc procedure="GET_WORKCUBE_APP" datasource="#dsn#">
	<cfprocparam type="IN" cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
	<cfprocparam type="IN" cfsqltype="cf_sql_varchar" value="#CFID#">
	<cfprocparam type="IN" cfsqltype="cf_sql_varchar" value="#sessInfo#">
	<cfprocparam type="IN" cfsqltype="cf_sql_bit" value="0">
	<cfprocresult name="WORKCUBE_APP">
</cfstoredproc>

<cfif only_report_system eq 1>
	<cfif not workcube_app.recordcount>
		<cfif IsDefined("attributes.cfid_")>			
			<cfquery name="WORKCUBE_APP" datasource="#DSN#">
				SELECT * FROM WRK_SESSION WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cftoken_#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cfid_#">
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfscript>
/* 20040704
	Bu dosyada asagidaki kisimdaki session atamalari daha once sadece databaseden de CFID ve CFTOKEN a göre kayit donmusse
	(ki CFTOKEN icin cf admin ekranlarindan use UUID() for CFTOKEN secilmis olmali) ve session defined degilse session dolduruluyordu
	(ki gercekten de session defined olmayabilir veya multiple instance kurulumlarinda kullanici diger bir instance dan geliyordur).
	Ancak bu multiple instance kurulumlarinda kullanici diger instance dan geliyor ve donem-sirket e iliskin degerlerini degistirmisse
	problem oluyordu o yuzden (standart server kurulumlarinda gerek olmadigi halde) session tanimli ise de farkli ise de degilse de
	bu degiskenleri session a yine de dolduruyoruz.
*/
if (workcube_app.recordcount)
{
	if (listfindnocase(employee_url,'#cgi.http_host#',';') )
	{
		if(not isdefined('session.ep.userid'))
		{
			session.ep = StructNew();
			session.ep.userid = workcube_app.userid;
			session.ep.week_start = workcube_app.week_start;
			session.ep.user_level = workcube_app.user_level;
			if(len(workcube_app.user_level_extra))
				session.ep.user_level_extra = workcube_app.user_level_extra; //alt modul yetkileri
			session.ep.dockphone = workcube_app.DOCK_PHONE;
			session.ep.report_user_level = workcube_app.REPORT_USER_LEVEL;
			session.ep.data_level = workcube_app.DATA_LEVEL;
			session.ep.worktips_open = IsDefined("workcube_app.WORKTIPS_OPEN") ? workcube_app.WORKTIPS_OPEN : 0;
			session.ep.position_code = workcube_app.position_code;
			session.ep.money = workcube_app.money;
			session.ep.money2 = workcube_app.money2;
			session.ep.other_money = workcube_app.other_money;
			session.ep.time_zone = workcube_app.time_zone;
			session.ep.name = workcube_app.name;
			session.ep.surname = workcube_app.surname;
			session.ep.discount_valid = workcube_app.discount_valid;
			session.ep.duedate_valid = workcube_app.duedate_valid;
			session.ep.price_valid = workcube_app.price_valid;
			session.ep.price_display_valid = workcube_app.price_display_valid;
			session.ep.cost_display_valid = workcube_app.cost_display_valid;
			session.ep.rate_valid = workcube_app.rate_valid;
			session.ep.their_records_only = workcube_app.their_records_only;
			session.ep.consumer_priority = workcube_app.consumer_priority;
			session.ep.member_view_control = workcube_app.member_view_control;
			session.ep.position_name = workcube_app.position_name;
			session.ep.language = workcube_app.language_id;
			session.ep.design_id = workcube_app.design_id;
			session.ep.menu_id = workcube_app.menu_id;
			session.ep.design_color = workcube_app.design_color;
			session.ep.username = workcube_app.username;
			session.ep.user_location = workcube_app.user_location;
			session.ep.userkey = workcube_app.userkey;
			session.ep.company = workcube_app.company;
			session.ep.company_email = workcube_app.company_email;
			session.ep.company_id = workcube_app.company_id;
			session.ep.company_nick = workcube_app.company_nick;
			session.ep.period_id = workcube_app.period_id;
			session.ep.period_start_date = workcube_app.start_date;
			session.ep.period_finish_date = workcube_app.finish_date;
			session.ep.period_year = workcube_app.period_year;
			session.ep.period_is_integrated = workcube_app.IS_INTEGRATED;
			session.ep.ehesap = workcube_app.ehesap;
			session.ep.maxrows = workcube_app.maxrows;
			session.ep.workcube_id = workcube_app.workcube_id;
			session.ep.admin = workcube_app.admin_status;
			session.ep.period_date = dateformat(workcube_app.period_date,'yyyy-mm-dd');
			session.ep.process_date = dateformat(workcube_app.process_date,'yyyy-mm-dd');
			session.ep.timeout_min = workcube_app.timeout_min;
			session.ep.our_company_info = StructNew();
			session.ep.our_company_info.workcube_sector = workcube_app.workcube_sector;
			session.ep.our_company_info.is_paper_closer = workcube_app.is_paper_closer;
			session.ep.our_company_info.is_cost = workcube_app.is_cost;
			session.ep.our_company_info.is_cost_location = workcube_app.is_cost_location;
			session.ep.our_company_info.spect_type = workcube_app.SPECT_TYPE;
			session.ep.our_company_info.guaranty_followup = workcube_app.IS_GUARANTY_FOLLOWUP;
			session.ep.our_company_info.project_followup = workcube_app.IS_PROJECT_FOLLOWUP;
			session.ep.our_company_info.asset_followup = workcube_app.IS_ASSET_FOLLOWUP;
			session.ep.our_company_info.sales_zone_followup = workcube_app.IS_SALES_ZONE_FOLLOWUP;
			session.ep.our_company_info.subscription_contract=workcube_app.IS_SUBSCRIPTION_CONTRACT;
			session.ep.our_company_info.sms = workcube_app.IS_SMS;
			session.ep.our_company_info.unconditional_list = workcube_app.IS_UNCONDITIONAL_LIST;
			session.ep.our_company_info.is_maxrows_control_off = workcube_app.IS_MAXROWS_CONTROL_OFF;
			session.ep.our_company_info.is_ifrs = workcube_app.IS_IFRS;
			session.ep.our_company_info.rate_round_num = workcube_app.RATE_ROUND_NUM;
			session.ep.our_company_info.purchase_price_round_num = workcube_app.PURCHASE_PRICE_ROUND_NUM;
			session.ep.our_company_info.sales_price_round_num = workcube_app.SALES_PRICE_ROUND_NUM;
			session.ep.our_company_info.is_stock_based_cost = workcube_app.IS_STOCK_BASED_COST;
			session.ep.our_company_info.is_location_follow = workcube_app.IS_LOCATION_FOLLOW;
			session.ep.our_company_info.is_prod_cost_type = workcube_app.IS_PROD_COST_TYPE;
			session.ep.our_company_info.is_project_group = workcube_app.IS_PROJECT_GROUP;
			session.ep.our_company_info.special_menu_file = workcube_app.SPECIAL_MENU_FILE;
			session.ep.our_company_info.is_add_informations = workcube_app.IS_ADD_INFORMATIONS;
			session.ep.our_company_info.earchive_date = workcube_app.earchive_date;			
			session.ep.our_company_info.is_edefter = workcube_app.is_edefter;
			session.ep.our_company_info.is_efatura = workcube_app.is_efatura;
			session.ep.our_company_info.is_earchive = workcube_app.is_earchive;			
			session.ep.our_company_info.is_lot_no = workcube_app.is_lot_no;
			session.ep.our_company_info.efatura_date = dateformat(workcube_app.efatura_date,'yyyy-mm-dd');
			session.ep.dateformat_style = workcube_app.dateformat_style;
			session.ep.timeformat_style = workcube_app.timeformat_style;
			session.ep.moneyformat_style = workcube_app.moneyformat_style;
			session.ep.authority_code_hr = workcube_app.authority_code_hr;
			if(not len(workcube_app.power_user_level_id))
			{
				session.ep.power_user = 0;
				session.ep.power_user_level_id = '';
			}
			else
			{
				session.ep.power_user = 1;
				session.ep.power_user_level_id = workcube_app.power_user_level_id;
			}
			session.ep.isBranchAuthorization = workcube_app.IS_BRANCH_AUTHORIZATION;
		}
	}
}
</cfscript>
<cfif isdefined("session.ep.userid")>
	<cfif WORKCUBE_APP.recordcount>
		<cfset sessionIdList = valuelist(WORKCUBE_APP.SESSIONID,',')>
		<cfif isDefined("session.sessionid")>
            <cfset sessInfo = session.sessionid>
        <cfelse>
            <cfset sessInfo = cookie.jsessionid>
        </cfif>
		<cfset ignore_actions = ["home.emptypopup_special_functions","home.emptypopup_calender_functions"] />
		<cfif not listFindNoCase(sessionIdList,sessInfo,',')>
            <cfset structClear( session ) />
			<cflocation url="#user_domain##request.self#?fuseaction=home.login" addtoken="no">
		<cfelseif isdefined("attributes.fuseaction") and not isdefined("attributes.ajax") and not isdefined("attributes.isAjax") and not ArrayContains(ignore_actions, attributes.fuseaction)>
			<cfquery name="upd_wrk_session" datasource="#dsn#">
				UPDATE WRK_SESSION SET ACTION_DATE = #now()#, ACTION_PAGE = <cfqueryparam value = "#attributes.fuseaction#" CFSQLType = "cf_sql_nvarchar">, ACTION_PAGE_Q_STRING = <cfqueryparam value = "#cgi.QUERY_STRING#" CFSQLType = "cf_sql_nvarchar"> 
				WHERE SESSIONID = '#WORKCUBE_APP.SESSIONID#'
			</cfquery>
        </cfif>
        <!---
        <cfif not listFindNoCase(valuelist(WORKCUBE_APP.SESSIONID,','),sessInfo,',')>
            <cfset structClear( session ) />
			<cflocation url="#user_domain##request.self#?fuseaction=home.login" addtoken="no">
        </cfif>
		--->
	<cfelse><!--- Kullanıcının bilgisayarında cookie sorunu varsa kullanıcının çoklu girişi gerçekleşiyordu. --->
		<cfif isdefined("attributes.ajax")><!--- ajax sayfaları direk kes --->
            <cfsetting showdebugoutput="no">
            <cfexit method="exittemplate">
            <cfset structClear( session ) />
            <cfabort>
        <cfelse>
        	<cfset structClear( session ) />
        	<cflocation url="#user_domain##request.self#?fuseaction=home.login" addtoken="no">
        </cfif>
    </cfif>
</cfif>