<cfabort>
<!---
*********************************************************************************
**  Copyright Workcube E-Business Sys. Ltd. Istanbul Turkey info@workcube.com  **
**  		Tel: +90 212 2700522  Fax: +90 212 2686986		       		   **
*********************************************************************************
Name:
	
Circuits Name:
	
Purpose:
	
Inputs:
	
Outputs:
	
Create Date:
	
Author:
	
Revisions: 
	
*********************************************************************************
--->
<br />
<b><font color="#FF0000">
WORKCUBE KURULUM HOŞGELDİNİZ
</font></b>
<br /><b>
Bu Uyarıları ve "cfabort" ları <b>tek tek ve okuyarak</b> kaldırın.<br />
Aksi halde kurulumunuz bir şekilde kesinlikle başarısız olacaktır.<br />
<!--- <font color=red>Admin dosyası içindeki mesajları okumadan veya anlamadan beni aramayın. </font> ---></b>
<br />
<br />
1- Lisans xml in doğru olduğundan emin olun.
<br />
!!!!!!!!!!!!!! ÖNCE DİLİ EXPORT ET !!!!!!!!!!!!!!!!!
<hr>


<cfset dsn = application.systemParam.systemParam().dsn>

<cfif Server.OS.Name is 'Unix'>
	<cfset dir_seperator = '/'>
<cfelse>
	<cfset dir_seperator = '\'>
</cfif>

<cffunction name="sql_unicode" returntype="string" output="false">
		<cfscript>
			if(database_type is 'MSSQL')
				sql_add = 'N';
			else
				sql_add = '';
		</cfscript>
	<cfreturn sql_add>
</cffunction>


<cfset attributes.upload_folder = GetDirectoryFromPath(GetCurrentTemplatePath())>

<!---<!--- dil islemleri --->
<cfinclude template="../settings/query/lang_import.cfm"> 
<hr>
2- Dil kayıtları alındı.<br />
Şimdi de admin.cfm içinden <b>dil kodunu kapat</b> ve yeniden çalıştır.
<!--- dil islemleri bitti --->
<cfabort> --->
<cfset period_date='01/01/2007'>
<cf_date tarih="period_date">
<cfinclude template="admin_include1.cfm">
<cfinclude template="admin_include2.cfm">

<cfquery name="LICENSE" datasource="#DSN#">
	SELECT
		*
	FROM
		LICENSE
</cfquery>
<cfif not license.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#license.xml" variable="LicenseXML" charset="UTF-8">
	<cfset LicenseXMLDoc = XmlParse(LicenseXML)>
	<cfset workcube_encryption_key = "workcube_encryption_key_1234567890">
	<cfset WorkCube_ID = encrypt(LicenseXMLDoc.License.WorkCube_ID.XmlText, workcube_encryption_key)>

	<cfquery name="ADD_LICENSE" datasource="#DSN#">
		INSERT INTO
			LICENSE
		(
			WORKCUBE_ID,
			PROJECT_ID,
			COMPANY,
			COMPANY_PARTNER,
			TEL,
			FAX,
			EMAIL,
			WORKCUBE_ID1
		)
		VALUES
		(
			'#toString(LicenseXMLDoc.License.WorkCube_ID.XmlText)#',
			'#toString(LicenseXMLDoc.License.Project_ID.XmlText)#',
			'#toString(LicenseXMLDoc.License.Company.XmlText)#',
			'#toString(LicenseXMLDoc.License.Company_Partner.XmlText)#',
			'#toString(LicenseXMLDoc.License.Tel.XmlText)#',
			'#toString(LicenseXMLDoc.License.Fax.XmlText)#',
			'#toString(LicenseXMLDoc.License.Email.XmlText)#',
			'#WorkCube_ID#'
		)
	</cfquery>
</cfif>

<cfscript>
	session.ep = StructNew();
	session.ep.userid = 0;
	session.ep.week_start = 1;
	session.ep.position_code = 0;
	session.ep.money = 'TL';
	session.ep.money2 = '';
	session.ep.time_zone = '+2';
	session.ep.name = 'Admin';
	session.ep.surname = 'Admin';
	session.ep.position_name = 'Admin';
	session.ep.language = 'tr';
	session.ep.design_id = 4;
	session.ep.design_color = 1;
	session.ep.username = 'Admin';
	session.ep.user_location = "0-0";
	session.ep.depo_id = "";
	session.ep.userkey = "e-0";
	session.ep.period_year=year(now());
	session.ep.company_id=1;// Birden cok sirket icin kurulan serverlarda onemli admin.cfm i hangi sirketten den calistiracagimi gosterir.
	session.ep.period_id=1;
	session.ep.company='Admin';
	session.ep.company_email='admin@workcube.com';
	session.ep.company_nick='Admin';
	session.ep.user_level = '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1';
	session.ep.ehesap=1;
	session.ep.maxrows=20;
	session.ep.workcube_id = '#listlast(listlast(cgi.HTTP_COOKIE,';'),'=')#';
	session.ep.our_company_info = StructNew();
	session.ep.our_company_info.workcube_sector = '';
	session.ep.our_company_info.is_paper_closer = 0;
	session.ep.our_company_info.is_cost = 0;
	session.ep.our_company_info.is_cost_location = 0;
	session.ep.our_company_info.spect_type = 0;
	session.ep.our_company_info.guaranty_followup = 0;
	session.ep.our_company_info.is_maxrows_control_off = 0;
	session.ep.our_company_info.project_followup = 0;
	session.ep.our_company_info.sales_zone_followup = 0;
	session.ep.our_company_info.subscription_contract = 0;
	session.ep.our_company_info.sms= 0;
	session.ep.our_company_info.unconditional_list = 0;
	session.ep.our_company_info.detail_filter_open = 0;
	session.ep.our_company_info.rate_round_num = 4;
	session.ep.our_company_info.purchase_price_round_num = 4;
	session.ep.our_company_info.sales_price_round_num = 2;
	session.ep.our_company_info.multi_analysis_result = 0;
	session.ep.our_company_info.is_lot_no = 0;
	session.ep.authority_code_hr ='';
	session.ep.our_company_id='1';
	session.ep.admin = 1;
	session.ep.power_user = 1;
	session.ep.power_user_level_id = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86';
	session.ep.menu_id = 1;	
	session.ep.period_date='#period_date#';
	session.ep.timeout_min='119';
</cfscript>
<cfquery name="ADD_WRK_SESSION_TO_DB" datasource="#DSN#">
	INSERT INTO 
		WRK_SESSION
	(
		CFID,
		CFTOKEN,
		WORKCUBE_ID,
		USERID,
		USER_TYPE,
		USERNAME,
		NAME,
		SURNAME,
		POSITION_CODE,
		MONEY,
		TIME_ZONE,
		POSITION_NAME,
		LANGUAGE_ID,
		DESIGN_ID,
		DESIGN_COLOR,
		COMPANY_ID,
		COMPANY,
		COMPANY_EMAIL,
		COMPANY_NICK,
		EHESAP,
		MAXROWS,
		USER_LOCATION,
		USERKEY,
		PERIOD_ID,
		PERIOD_YEAR,
		IS_INTEGRATED,
		USER_LEVEL,
		WORKCUBE_SECTOR,
		IS_COST,
        IS_COST_LOCATION,
		SPECT_TYPE,
		ERROR_TEXT,
		SESSIONID,
		COMPANY_CATEGORY,
		ADMIN_STATUS,
		PERIOD_DATE,
		TIMEOUT_MIN,
		ACTION_PAGE,
		FUSEACTION,
		IS_GUARANTY_FOLLOWUP,
		IS_PROJECT_FOLLOWUP,
		IS_SALES_ZONE_FOLLOWUP,
		IS_SMS,
		IS_UNCONDITIONAL_LIST,
		IS_DETAIL_FILTER_OPEN,
		AUTHORITY_CODE_HR,
		IS_SUBSCRIPTION_CONTRACT,
		IS_MESSAGE,
		MONEY2,
		IS_MAXROWS_CONTROL_OFF,
		PURCHASE_PRICE_ROUND_NUM,
		SALES_PRICE_ROUND_NUM,
		RATE_ROUND_NUM,
        IS_LOT_NO
	)
	VALUES
	(
		'#cfid#',
		'#cftoken#',
		'#session.ep.workcube_id#',
		#session.ep.userid#,
		0,
		'#session.ep.username#',
		'#session.ep.name#',
		'#session.ep.surname#',
		#session.ep.position_code#,
		'#session.ep.money#',
		#session.ep.time_zone#,
		'#session.ep.position_name#',
		'#session.ep.language#',
		#session.ep.design_id#,
		#session.ep.design_color#,
		#session.ep.company_id#,
		'#session.ep.company#',
		'#session.ep.company_email#',
		'#session.ep.company_nick#',
		#session.ep.ehesap#,
		#session.ep.maxrows#,
		'#session.ep.user_location#',
		'#session.ep.userkey#',
		#session.ep.period_id#,
		#session.ep.period_year#,
		0,
		'#session.ep.user_level#',
		'#session.ep.our_company_info.workcube_sector#',
		#session.ep.our_company_info.is_cost#,
        #session.ep.our_company_info.is_cost_location#,
		#session.ep.our_company_info.spect_type#,
		'',
		'#session.sessionid#',
		'#session.ep.our_company_id#',
		#session.ep.admin#,
		#session.ep.period_date#,
		#session.ep.timeout_min#,
		NULL,
		NULL,
		#session.ep.our_company_info.guaranty_followup#,
		#session.ep.our_company_info.project_followup#,
		#session.ep.our_company_info.sales_zone_followup#,
		#session.ep.our_company_info.sms#,
		#session.ep.our_company_info.unconditional_list#,
		#session.ep.our_company_info.detail_filter_open#,
		'#session.ep.authority_code_hr#',
		#session.ep.our_company_info.subscription_contract#,
		0,
		'#session.ep.money2#',
		0,
		#session.ep.our_company_info.purchase_price_round_num#,
		#session.ep.our_company_info.sales_price_round_num#,
		#session.ep.our_company_info.rate_round_num#,
        #session.ep.our_company_info.is_lot_no#
	)
</cfquery>

<cflocation url="../#request.self#?fuseaction=myhome.welcome" addtoken="No">
