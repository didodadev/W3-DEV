<cfparam name="attributes.ref_code" default="">
<cfparam name="attributes.ref_code_name" default="">
<cfset attributes.isbox=1>
<cfparam name="attributes.is_period_kontrol" default="1">
<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_our_company_id = session.pp.our_company_id>
    <cfset session_company_id = session.pp.company_id>
    <cfset session_period_year = session.pp.period_year>
    <cfset session_language = session.pp.language>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
    <cfset session_our_company_id = session.ep.our_company_id>
    <cfset session_company_id = session.ep.company_id>
    <cfset session_period_year = session.ep.period_year>
    <cfset session_language = session.ep.language>
    <cfset session_user_id = session.ep.user_id>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
    <cfset session_our_company_id = session.ww.our_company_id>
    <cfset session_company_id = session.ww.company_id>
    <cfset session_period_year = session.ww.period_year>
    <cfset session_language = session.ww.language>
</cfif>
<cfparam name="attributes.maxrows" default='20'>
<cfif attributes.is_period_kontrol eq 1>
	<cfif isdefined('session.ep.userid')>
		<cfparam name="attributes.period_id" default="1;#session.ep.company_id#;#session.ep.period_id#">
	<cfelseif isdefined('session.pda.userid')>
		<cfparam name="attributes.period_id" default="1;#session.pda.our_company_id#;#session.pda.period_id#">
	</cfif>
</cfif>
<cfscript>
	accountingType = createObject("component","V16.settings.cfc.accountingType");
    getAccount = accountingType.getAccountType();
</cfscript>
<cfparam name="attributes.search_status" default=1>
<cfparam name="attributes.type" default="">
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_company_id#">
</cfquery>
	<cfquery name="get_period" datasource="#dsn#">
		SELECT
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			SP.PERIOD_ID,
			SP.PERIOD
		FROM
			SETUP_PERIOD SP WITH (NOLOCK),
			OUR_COMPANY WITH (NOLOCK),
			EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
		WHERE 
			EPP.PERIOD_ID = SP.PERIOD_ID 
			<cfif isdefined("session.ep.userid")>
				AND EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1)
			</cfif>
			AND SP.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
		ORDER BY 
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			SP.PERIOD_YEAR
	</cfquery>
	<cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>
<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP WITH (NOLOCK),
		SETUP_PERIOD SP WITH (NOLOCK),
		EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK),
		OUR_COMPANY O WITH (NOLOCK)
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID 
		<cfif isdefined("session.ep.userid")>
			AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT 
		CONSCAT_ID, 
		CONSCAT
	FROM
		GET_MY_CONSUMERCAT WITH (NOLOCK)
	WHERE
		<cfif isdefined('session.ep.userid')>
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">  AND
		</cfif>
		<cfif isdefined("attributes.period_id") and Len(attributes.period_id)>
			OUR_COMPANY_ID = #listGetAt(attributes.period_id,2,';')# AND
		</cfif>
		<cfif get_our_companies.recordcount>
			OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
		<cfelse>
			1 = 2	
		</cfif>
	GROUP BY
		CONSCAT_ID, 
		CONSCAT
	ORDER BY
		CONSCAT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.is_form_submitted" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_form_submitted')>
	<cfinclude template="../query/get_consumers.cfm">
<cfelse>
	<cfset get_consumers.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<!---<cfparam name="attributes.page" default=1>--->
<cfparam name="attributes.totalrecords" default="#get_consumers.recordcount#">
<!---<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>--->
<script type="text/javascript">
	function add_user(id,name,company,long_address,address,postcode,semt,county,county_id,city,city_id,country,country_id,member_account_code,mail_adress,telephone_number,consumer_reference_code,paymethod_id,paymethod_name,revmethod_id,revmethod_name,card_paymethod_id,card_revmethod_id,due_paymethod,due_revmethod,member_code,tel_code,tel_number,cons_name,cons_surname,home_adress,home_county,home_county_id,home_city_id,home_telcode,home_tel,mobil_telcode,mobil_tel,ozel_kod,tc_identy_no,vocation_id,consumer_username,imcat_id,im,title_name,mission,department,sex,work_tel_ext,work_faxcode,work_fax,homepage,tax_office,tax_no,related_company_id,related_company,ims_code_name,ims_code_id,address_id,tel_code2,tel_number2)
	{ 
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>; 
	<cfelse>
		var satir = -1;
	</cfif>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.updateBasketItemFromPopup(satir, { CONSUMER_ID: id, CONSUMER_NAME: name,MEMBER_ACCOUNT_CODE :member_account_code }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
		else
		{
		
		<cfif isdefined("attributes.field_comp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = '' ;
		</cfif>
		<!---Bireysel Üye Seçildiğinde Company Adı boşaltılıyor.--->
		<cfif isdefined("attributes.field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_name#</cfoutput>.value = cons_name + ' ' + cons_surname ;
		</cfif>
		<cfif isdefined("attributes.field_partner")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_partner#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined("attributes.field_emp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_emp_id#</cfoutput>.value = '';
		</cfif>	
		<!--- <cfif isdefined("attributes.field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_name#</cfoutput>.value = company;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#field_comp_name#</cfoutput>.focus();
		</cfif>	 bireysel üyenin ilgili şirketinin cari hesap alanına düşme sebebi nedir?  sevda ile konusarak kapadim. sorun olursa bana donus yaparsiniz. hgul 20130703--->
		<cfif isdefined("attributes.field_member_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_member_name#</cfoutput>.value = name;
		</cfif>	
		<cfif isdefined("attributes.field_type")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#field_type#</cfoutput>.value = "consumer";
		</cfif>	
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_consumer")>
			<cfif listlen(field_consumer,'.') eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_consumer#</cfoutput>').value = id;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consumer#</cfoutput>.value = id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_long_address")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_long_address#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_long_address#</cfoutput>.value = long_address;
		</cfif>
		<cfif isdefined("attributes.field_mail")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_mail#</cfoutput>.value = mail_adress;
		</cfif>
		<cfif isdefined("attributes.field_tel")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel#</cfoutput>.value = telephone_number;
		</cfif>
		<cfif isdefined("attributes.field_tel_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel_code#</cfoutput>.value = tel_code;
		</cfif>
		<cfif isdefined("attributes.field_tel_number")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_tel_number#</cfoutput>.value = tel_number;
		</cfif>
		<cfif isdefined("attributes.field_address")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_adress_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_adress_id#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_adress_id#</cfoutput>.value = address_id;
		</cfif>
		<cfif isdefined("attributes.field_address")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_postcode")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_country")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id#</cfoutput>.value = country_id;
		</cfif>
		<cfif isDefined("attributes.func_LoadCity") and isDefined("attributes.field_city_id") and isDefined("attributes.field_county_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.LoadCity(country_id,<cfoutput>"#listlast(attributes.field_city_id,'.')#","#listlast(attributes.field_county_id,'.')#"</cfoutput>);
		</cfif>
		<cfif isdefined("attributes.field_city")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id#</cfoutput>.value = city_id;
		</cfif>
		<cfif isDefined("attributes.func_LoadCounty") and isDefined("attributes.field_county_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.LoadCounty(city_id,<cfoutput>"#listlast(attributes.field_county_id,'.')#"</cfoutput>);
		</cfif>
		<cfif isdefined("attributes.field_county")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_address2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address2#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address2#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_postcode2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode2#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode2#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt2#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt2#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_county2")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county2#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county2#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id2#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_city2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city2#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id2#</cfoutput>.value = city_id;
		</cfif>
		<cfif isdefined("attributes.field_country2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country2#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id2#</cfoutput>.value = country_id;
		</cfif>
		<cfif isdefined("attributes.field_address3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_address3#</cfoutput>.value = address;
		</cfif>
		<cfif isdefined("attributes.field_postcode3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_postcode3#</cfoutput>.value = postcode;
		</cfif>
		<cfif isdefined("attributes.field_semt3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_semt3#</cfoutput>.value = semt;
		</cfif>
		<cfif isdefined("attributes.field_county3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county3#</cfoutput>.value = county;
		</cfif>
		<cfif isdefined("attributes.field_county_id3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_county_id3#</cfoutput>.value = county_id;
		</cfif>
		<cfif isdefined("attributes.field_city3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city3#</cfoutput>.value = city;
		</cfif>
		<cfif isdefined("attributes.field_city_id3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_city_id3#</cfoutput>.value = city_id;
		</cfif>
		<cfif isdefined("attributes.field_country3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country3#</cfoutput>.value = country;
		</cfif>
		<cfif isdefined("attributes.field_country_id3")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_country_id3#</cfoutput>.value = country_id;
		</cfif>
		<cfif isdefined("attributes.field_consno")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_consno#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_cons_ref_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_cons_ref_code#</cfoutput>.value = consumer_reference_code;
		</cfif>
		<cfif isdefined("attributes.field_paymethod_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_paymethod_id#</cfoutput>.value = paymethod_id;
			<cfif isdefined("attributes.field_card_payment_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_card_payment_id#</cfoutput>.value = card_paymethod_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_basket_due_value")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_basket_due_value#</cfoutput>.value = due_paymethod;		
		</cfif>
		<cfif isdefined("attributes.field_paymethod")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_paymethod#</cfoutput>.value = paymethod_name;
		</cfif>
		<cfif isdefined("attributes.field_revmethod_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_revmethod_id#</cfoutput>.value = revmethod_id;
			<cfif isdefined("attributes.field_card_payment_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_card_payment_id#</cfoutput>.value = card_revmethod_id;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_basket_due_value_rev")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_basket_due_value_rev#</cfoutput>.value = due_revmethod;		
		</cfif>
		<cfif isdefined("attributes.field_revmethod")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_revmethod#</cfoutput>.value = revmethod_name;
		</cfif>
		<cfif isdefined("attributes.field_cons_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_cons_code#</cfoutput>.value = member_code;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_cons_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_cons_name#</cfoutput>.value = cons_name;
		</cfif>	
		<cfif isdefined("attributes.field_cons_surname")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_cons_surname#</cfoutput>.value = cons_surname;
		</cfif>	
		<cfif isdefined("attributes.field_home_address")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_home_address#</cfoutput>.value = home_adress;
		</cfif>
		<cfif isdefined("attributes.field_home_city_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_home_city_id#</cfoutput>.value = home_city_id;
		</cfif>
		<cfif isdefined("attributes.field_home_county")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_home_county#</cfoutput>.value = home_county;
		</cfif>
		<cfif isdefined("attributes.field_home_county_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_home_county_id#</cfoutput>.value = home_county_id;
		</cfif>
		<cfif isdefined("attributes.field_ims_code_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_ims_code_id#</cfoutput>.value = ims_code_id;
		</cfif>
		<cfif isdefined("attributes.field_ims_code_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_ims_code_name#</cfoutput>.value = ims_code_name;
		</cfif>
		<cfif isdefined("attributes.field_hometel")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_hometel#</cfoutput>.value = home_tel;
		</cfif>
		<cfif isdefined("attributes.field_hometel_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_hometel_code#</cfoutput>.value = home_telcode;
		</cfif>
		<cfif isdefined("attributes.field_mobile_tel")>
			<cfif isdefined("attributes.field_mobile_tel_code")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel#</cfoutput>.value = mobil_tel;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel_code#</cfoutput>.value = mobil_telcode;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel#</cfoutput>.value = mobil_telcode + '' +  mobil_tel;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_mobile_tel_2")>
			<cfif isdefined("attributes.field_mobile_tel_code_2")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel_2#</cfoutput>.value = tel_number2;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel_code_2#</cfoutput>.value = tel_code2;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mobile_tel_2#</cfoutput>.value = tel_code2 + '' +  tel_number2;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_ozel_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_ozel_code#</cfoutput>.value = ozel_kod;
		</cfif>
		<cfif isdefined("attributes.field_tc_identy_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tc_identy_no#</cfoutput>.value = tc_identy_no;
		</cfif>
		<cfif isdefined("attributes.field_vocation_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_vocation_id#</cfoutput>.value = vocation_id;
		</cfif>
		<cfif isdefined("attributes.field_cons_username")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_cons_username#</cfoutput>.value = consumer_username;
		</cfif>
		<cfif isdefined("attributes.field_imcat_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_imcat_id#</cfoutput>.value = imcat_id;
		</cfif>
		<cfif isdefined("attributes.field_im")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_im#</cfoutput>.value = im;
		</cfif>
		<cfif isdefined("attributes.field_title_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_title_name#</cfoutput>.value = title_name;
		</cfif>
		<cfif isdefined("attributes.field_mission")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_mission#</cfoutput>.value = mission;
		</cfif>
		<cfif isdefined("attributes.field_department")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_department#</cfoutput>.value = department;
		</cfif>
		<cfif isdefined("attributes.field_sex")>
			if(sex == 2 || sex == 0) sex_p = 2; else sex_p = 1;//company partnerda kadin secenegi 2 ile tanimli
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_sex#</cfoutput>.value = sex_p;
		</cfif>
		<cfif isdefined("attributes.field_work_tel_ext")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_work_tel_ext#</cfoutput>.value = work_tel_ext;
		</cfif>
		<cfif isdefined("attributes.field_work_fax")>
			<cfif isdefined("attributes.field_work_faxcode")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_work_fax#</cfoutput>.value = work_fax;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.work_faxcode#</cfoutput>.value = work_faxcode;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_work_fax#</cfoutput>.value = work_faxcode + '' + work_fax;
			</cfif>
		</cfif>
		<cfif isdefined("attributes.field_homepage")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_homepage#</cfoutput>.value = homepage;
		</cfif>
		<cfif isdefined("attributes.field_tax_office")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tax_office#</cfoutput>.value = tax_office;
		</cfif>
		<cfif isdefined("attributes.field_tax_no")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_tax_no#</cfoutput>.value = tax_no;
		</cfif>
		<cfif isdefined("attributes.is_county_related_company") and isdefined("attributes.related_company_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.related_company_id#</cfoutput>.value = related_company_id;
		</cfif>
		<cfif isdefined("attributes.account_period")>
            <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#account_period#</cfoutput>.value = 1;//Tanımlıysa muhasebe ve dönem kontrolü yapmaz
		</cfif>
		<cfif isdefined("attributes.is_county_related_company") and isdefined("attributes.related_company")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.related_company#</cfoutput>.value = related_company;
		</cfif>
		/*şirket akış parametrelerine bağlı olarak company_credit den işlem dövizi bilgisi alıyor*/
		var listParam = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + id;
		var get_credit_all = wrk_safe_query('obj_get_credit_all_3','dsn',0,listParam);
		<cfif get_our_company_info.is_select_risk_money eq 1>
			if(get_credit_all.recordcount && get_credit_all.money != '')
			{
				new_money = get_credit_all.MONEY;
				new_money_list = get_credit_all.MONEY+';'+get_credit_all.RATE1+';'+get_credit_all.RATE2;
				<cfif isdefined("attributes.row_no")>
					new_row = "<cfoutput>#attributes.row_no#</cfoutput>";
					if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row) != undefined && new_row == 0)
						eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.money_id'+new_row).value = new_money_list;					
				<cfelse>
					if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say != undefined)
					{
						new_kur_say = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.kur_say.value;
						for(var i=1;i<=new_kur_say;i++)
						{
							if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value != "<cfoutput>#session.ep.money#</cfoutput>")
							{
								if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date_paper.value+'.value').toString() );
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.'+<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.search_process_date.value+'.value').toString() );
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payment_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.action_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.ACTION_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.PAYMENT_DATE.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.payroll_revenue_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.act_date.value').toString());
								else if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date != undefined)
									var paper_date_new = js_date( eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.expense_date.value').toString());
									
								if(paper_date_new != undefined && paper_date_new != '')
								{
									var listParam = eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value + "*" + paper_date_new;
									get_money_rate_ = wrk_safe_query("obj_get_money_rate_2",'dsn',0,listParam);
									if(get_money_rate_.recordcount == 0)
									{
										get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
										
									}								
								}
								else
								{
									get_money_rate_ = wrk_safe_query('obj_get_money_rate','dsn2',0,eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value);
								}
								if(get_credit_all.PAYMENT_RATE_TYPE == 1)
									eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = commaSplit(get_money_rate_.RATE3,4);
								else if(get_credit_all.PAYMENT_RATE_TYPE == 3)
									eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = commaSplit(get_money_rate_.EFFECTIVE_PUR,4);
								else if(get_credit_all.PAYMENT_RATE_TYPE == 4)
									eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = commaSplit(get_money_rate_.EFFECTIVE_SALE,4);
								else
									eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.txt_rate2_' + i).value = commaSplit(get_money_rate_.RATE2,4);
							}
							if(eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i) != undefined && eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.hidden_rd_money_'+i).value == new_money)
							{
								eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.rd_money['+(i-1)+']').checked = true;
							}
							if(typeof <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir != "undefined")
								<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.kur_degistir(i);	
						}
					}
				</cfif>	
			}				
		</cfif>
		<cfif isdefined("attributes.islem")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.islem.value = "emp";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.work_head.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.event_head.value = "";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.time_cost.expense.value = "";
		</cfif>
		<cfif isdefined("attributes.call_function")>
			<cfif listlen(attributes.call_function,'-') gt 1>
				<cfloop from="1" to="#listlen(attributes.call_function,'-')#" index="call_i">
					try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
						catch(e){};
				</cfloop>			
			<cfelse>
				try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.call_function#</cfoutput>;}
					catch(e){};
			</cfif>
		</cfif>
		if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.find_risk) != 'undefined')  //basketteki toplamdaki risk_bilgisi icin eklendi, add_company_js.cfm 'de de var.
		{
			try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.find_risk();}
				catch(e){};
		}
		if(typeof(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options) != 'undefined')  //basketteki toplamdaki risk_bilgisi icin eklendi, add_company_js.cfm 'de de var.
		{
			try{<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.set_price_catid_options();}
				catch(e){};
		}
		<cfif isdefined("attributes.field_member_account_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_member_account_code#</cfoutput>.value = member_account_code;
		</cfif>
		<cfif isdefined("attributes.field_member_account_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_member_account_id#</cfoutput>.value = member_account_code;
		</cfif>
		<cfif isdefined("attributes.str_opener_form_url")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.str_opener_form#</cfoutput>.action='<cfoutput>#request.self#?fuseaction=#attributes.str_opener_form_url#</cfoutput>'>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.str_opener_form#</cfoutput>.submit();
		</cfif>	
		<cfif isDefined("attributes.field_cons_table")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_cons_table#</cfoutput>.innerHTML += "<table class='label'><tr><td>"+name+"</td></tr></table>";
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_cons#</cfoutput>.value += "," + id + ",";
		</cfif>
		<cfif isdefined('attributes.function_name')>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#function_name#</cfoutput>(id,2);
		</cfif>
		}
		<cfif isDefined("attributes.url_direction") and isDefined("attributes.url_param")>
			<cfoutput>
				document.for_url_direction.action='#request.self#?fuseaction=#attributes.url_direction#&#attributes.url_param#=#evaluate('attributes.'&attributes.url_param)#&con_id='+id;
				document.for_url_direction.submit();
			</cfoutput>
		<cfelseif not isdefined("attributes.window_close")>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfif>
	}
	
	function reloadopener()
	{
		wrk_opener_reload();
		window.close();
	}
</script>
<form method="post" name="for_url_direction" id="for_url_direction">
</form>
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfscript>
	url_string = '&is_form_submitted=1';
	if (isdefined('attributes.is_cari_action')) url_string = '#url_string#&is_cari_action=#is_cari_action#';
	if (isdefined('attributes.is_multi_act')) url_string = '#url_string#&is_multi_act=#is_multi_act#';
	if (isdefined('attributes.account_period')) url_string = '#url_string#&account_period=#account_period#';
	if (isdefined('attributes.is_buyer_seller')) url_string = '#url_string#&is_buyer_seller=#attributes.is_buyer_seller#';
	if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';
	if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
	if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
	if (isdefined('attributes.field_revmethod_id')) url_string = '#url_string#&field_revmethod_id=#field_revmethod_id#';
	if (isdefined('attributes.field_card_payment_id')) url_string = '#url_string#&field_card_payment_id=#field_card_payment_id#';
	if (isdefined('attributes.field_basket_due_value_rev')) url_string = '#url_string#&field_basket_due_value_rev=#field_basket_due_value_rev#';
	if (isdefined('attributes.field_revmethod')) url_string = '#url_string#&field_revmethod=#field_revmethod#';
	if (isdefined("attributes.str_opener_form_url")) url_string = "#url_string#&str_opener_form_url=#str_opener_form_url#";
	if (isdefined("attributes.str_opener_form")) url_string = "#url_string#&str_opener_form=#str_opener_form#";
	if (isdefined("attributes.field_comp_id")) url_string = "#url_string#&field_comp_id=#field_comp_id#";
	if (isdefined("attributes.islem")) url_string = "#url_string#&islem=#islem#";
	if (isdefined("attributes.field_comp_name")) url_string = "#url_string#&field_comp_name=#field_comp_name#";
	if (isdefined('attributes.field_member_name')) url_string = '#url_string#&field_member_name=#field_member_name#';
	if (isdefined("url.come")) url_string = "#url_string#&come=#url.come#";
	if (isdefined("attributes.field_type")) url_string = "#url_string#&field_type=#field_type#";
	if (isdefined("attributes.field_name")) url_string = "#url_string#&field_name=#field_name#";
	if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#field_id#";
	if (isdefined("attributes.field_partner")) url_string = "#url_string#&field_partner=#field_partner#";
	if (isdefined("attributes.field_consno")) url_string = "#url_string#&field_consno=#field_consno#";
	if (isdefined("attributes.startdate")) url_string = "#url_string#&startdate=#startdate#";
	if (isdefined("attributes.field_consumer")) url_string = "#url_string#&field_consumer=#field_consumer#";
	if (isdefined("attributes.finishdate")) url_string = "#url_string#&finishdate=#finishdate#";
	if (isdefined('attributes.field_table')) url_string = '#url_string#&field_table=#field_table#';
	if (isdefined('attributes.field_cons_table')) url_string = '#url_string#&field_cons_table=#field_cons_table#';
	if (isdefined('attributes.field_pars')) url_string = '#url_string#&field_pars=#field_pars#';
	if (isdefined('attributes.field_cons')) url_string = '#url_string#&field_cons=#field_cons#';
	if (isdefined('attributes.field_cons_code')) url_string = '#url_string#&field_cons_code=#field_cons_code#';
	if (isdefined('attributes.field_pos')) url_string = '#url_string#&field_pos=#field_pos#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.field_emp_id")) url_string = "#url_string#&field_emp_id=#field_emp_id#";
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.url_param")) url_string = "#url_string#&url_param=#url_param#";
	if (isdefined("attributes.field_member_account_code")) url_string = "#url_string#&field_member_account_code=#attributes.field_member_account_code#";
	if (isdefined("attributes.field_member_account_id")) url_string = "#url_string#&field_member_account_id=#attributes.field_member_account_id#";
	if (isdefined("attributes.is_county_related_company")) url_string = "#url_string#&is_county_related_company=1";
	if (isdefined("attributes.related_company")) url_string = "#url_string#&related_company=#attributes.related_company#";
	if (isdefined("attributes.related_company_id")) url_string = "#url_string#&related_company_id=#attributes.related_company_id#";
	if (isdefined("attributes.url_param"))
		{if (isdefined("#attributes.url_param#")) url_string = "#url_string#&#attributes.url_param#=#evaluate('attributes.'&attributes.url_param)#";}
	if (isdefined("attributes.camp_id")) url_string = "#url_string#&camp_id=#attributes.camp_id#";	
	if (isdefined("attributes.field_long_address")) url_string = "#url_string#&field_long_address=#attributes.field_long_address#";	
	if (isdefined("attributes.field_address")) url_string = "#url_string#&field_address=#attributes.field_address#";
	if (isdefined("attributes.field_postcode")) url_string = "#url_string#&field_postcode=#attributes.field_postcode#";
	if (isdefined("attributes.field_semt")) url_string = "#url_string#&field_semt=#attributes.field_semt#";
	if (isdefined("attributes.field_mail")) url_string = "#url_string#&field_mail=#attributes.field_mail#";
	if (isdefined("attributes.field_mobile_tel")) url_string = "#url_string#&field_mobile_tel=#attributes.field_mobile_tel#";
	if (isdefined("attributes.field_mobile_tel_code")) url_string = "#url_string#&field_mobile_tel_code=#attributes.field_mobile_tel_code#";
	if (isdefined("attributes.field_mobile_tel_2")) url_string = "#url_string#&field_mobile_tel_2=#attributes.field_mobile_tel_2#";
	if (isdefined("attributes.field_mobile_tel_code_2")) url_string = "#url_string#&field_mobile_tel_code_2=#attributes.field_mobile_tel_code_2#";
	if (isdefined('attributes.control_pos')) url_string = '#url_string#&control_pos=#control_pos#';
	if (isdefined("attributes.field_tel")) url_string = "#url_string#&field_tel=#attributes.field_tel#";
	if (isdefined("attributes.field_tel_number")) url_string = "#url_string#&field_tel_number=#attributes.field_tel_number#";
	if (isdefined("attributes.field_tel_code")) url_string = "#url_string#&field_tel_code=#attributes.field_tel_code#";
	if (isdefined("attributes.field_country")) url_string = "#url_string#&field_country=#attributes.field_country#";
	if (isdefined("attributes.field_country_id")) url_string = "#url_string#&field_country_id=#attributes.field_country_id#";
	if (isdefined("attributes.func_LoadCity")) url_string = "#url_string#&func_LoadCity=#attributes.func_LoadCity#";
	if (isdefined("attributes.field_city")) url_string = "#url_string#&field_city=#attributes.field_city#";
	if (isdefined("attributes.field_city_id")) url_string = "#url_string#&field_city_id=#attributes.field_city_id#";
	if (isdefined("attributes.func_LoadCounty")) url_string = "#url_string#&func_LoadCounty=#attributes.func_LoadCounty#";
	if (isdefined("attributes.field_county")) url_string = "#url_string#&field_county=#attributes.field_county#";
	if (isdefined("attributes.field_county_id")) url_string = "#url_string#&field_county_id=#attributes.field_county_id#";
	if (isdefined("attributes.field_address2")) url_string = "#url_string#&field_address2=#attributes.field_address2#";
	if (isdefined("attributes.field_postcode2")) url_string = "#url_string#&field_postcode2=#attributes.field_postcode2#";
	if (isdefined("attributes.field_semt2")) url_string = "#url_string#&field_semt2=#attributes.field_semt2#";
	if (isdefined("attributes.field_county2")) url_string = "#url_string#&field_county2=#attributes.field_county2#";
	if (isdefined("attributes.field_county_id2")) url_string = "#url_string#&field_county_id2=#attributes.field_county_id2#";
	if (isdefined("attributes.field_city2")) url_string = "#url_string#&field_city2=#attributes.field_city2#";
	if (isdefined("attributes.field_city_id2")) url_string = "#url_string#&field_city_id2=#attributes.field_city_id2#";
	if (isdefined("attributes.field_country2")) url_string = "#url_string#&field_country2=#attributes.field_country2#";
	if (isdefined("attributes.field_country_id2")) url_string = "#url_string#&field_country_id2=#attributes.field_country_id2#";
	if (isdefined("attributes.field_address3")) url_string = "#url_string#&field_address3=#attributes.field_address3#";
	if (isdefined("attributes.field_postcode3")) url_string = "#url_string#&field_postcode3=#attributes.field_postcode3#";
	if (isdefined("attributes.field_semt3")) url_string = "#url_string#&field_semt3=#attributes.field_semt3#";
	if (isdefined("attributes.field_county3")) url_string = "#url_string#&field_county3=#attributes.field_county3#";
	if (isdefined("attributes.field_county_id3")) url_string = "#url_string#&field_county_id3=#attributes.field_county_id3#";
	if (isdefined("attributes.field_city3")) url_string = "#url_string#&field_city3=#attributes.field_city3#";
	if (isdefined("attributes.field_city_id3")) url_string = "#url_string#&field_city_id3=#attributes.field_city_id3#";
	if (isdefined("attributes.field_country3")) url_string = "#url_string#&field_country3=#attributes.field_country3#";
	if (isdefined("attributes.field_country_id3")) url_string = "#url_string#&field_country_id3=#attributes.field_country_id3#";
	if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
	if (isdefined('attributes.is_store_module')) url_string = '#url_string#&is_store_module=1';
	if (isdefined("attributes.is_account_code")) url_string = "#url_string#&is_account_code=#attributes.is_account_code#";
	if (isdefined("attributes.is_company_info")) url_string = "#url_string#&is_company_info=#attributes.is_company_info#";
	if (isdefined("attributes.field_cons_ref_code")) url_string = "#url_string#&field_cons_ref_code=#field_cons_ref_code#";
	if (isdefined("attributes.kontrol_conscat_id")) url_string = "#url_string#&kontrol_conscat_id=#attributes.kontrol_conscat_id#";
	if (isdefined("attributes.is_cons_city_control")) url_string = "#url_string#&is_cons_city_control=#attributes.is_cons_city_control#";
	if (isdefined("attributes.field_cons_name")) url_string = "#url_string#&field_cons_name=#attributes.field_cons_name#";
	if (isdefined("attributes.field_cons_surname")) url_string = "#url_string#&field_cons_surname=#attributes.field_cons_surname#";
	if (isdefined("attributes.field_home_address")) url_string = "#url_string#&field_home_address=#attributes.field_home_address#";
	if (isdefined("attributes.field_home_city_id")) url_string = "#url_string#&field_home_city_id=#attributes.field_home_city_id#";
	if (isdefined("attributes.field_home_county")) url_string = "#url_string#&field_home_county=#attributes.field_home_county#";
	if (isdefined("attributes.field_home_county_id")) url_string = "#url_string#&field_home_county_id=#attributes.field_home_county_id#";
	if (isdefined("attributes.field_hometel_code")) url_string = "#url_string#&field_hometel_code=#attributes.field_hometel_code#";
	if (isdefined("attributes.field_hometel")) url_string = "#url_string#&field_hometel=#attributes.field_hometel#";
	if (isdefined("attributes.field_ozel_code")) url_string = "#url_string#&field_ozel_code=#attributes.field_ozel_code#";
	if (isdefined("attributes.field_tc_identy_no")) url_string = "#url_string#&field_tc_identy_no=#attributes.field_tc_identy_no#";
	if (isdefined("attributes.field_vocation_id")) url_string = "#url_string#&field_vocation_id=#attributes.field_vocation_id#";
	if (isdefined("attributes.field_cons_username")) url_string = "#url_string#&field_cons_username=#attributes.field_cons_username#";
	if (isdefined("attributes.field_imcat_id")) url_string = "#url_string#&field_imcat_id=#attributes.field_imcat_id#";
	if (isdefined("attributes.field_im")) url_string = "#url_string#&field_im=#attributes.field_im#";
	if (isdefined("attributes.field_title_name")) url_string = "#url_string#&field_title_name=#attributes.field_title_name#";
	if (isdefined("attributes.field_mission")) url_string = "#url_string#&field_mission=#attributes.field_mission#";
	if (isdefined("attributes.field_department")) url_string = "#url_string#&field_department=#attributes.field_department#";
	if (isdefined("attributes.field_sex")) url_string = "#url_string#&field_sex=#attributes.field_sex#";
	if (isdefined("attributes.field_work_tel_ext")) url_string = "#url_string#&field_work_tel_ext=#attributes.field_work_tel_ext#";
	if (isdefined("attributes.field_work_faxcode")) url_string = "#url_string#&field_work_faxcode=#attributes.field_work_faxcode#";
	if (isdefined("attributes.field_work_fax")) url_string = "#url_string#&field_work_fax=#attributes.field_work_fax#";
	if (isdefined("attributes.field_homepage")) url_string = "#url_string#&field_homepage=#attributes.field_homepage#";
	if (isdefined("attributes.field_ims_code_id")) url_string = "#url_string#&field_ims_code_id=#attributes.field_ims_code_id#";
	if (isdefined("attributes.field_ims_code_name")) url_string = "#url_string#&field_ims_code_name=#attributes.field_ims_code_name#";
	if (isdefined("attributes.field_tax_office")) url_string = "#url_string#&field_tax_office=#attributes.field_tax_office#";
	if (isdefined("attributes.field_tax_no")) url_string = "#url_string#&field_tax_no=#attributes.field_tax_no#";
	if (isdefined("attributes.row_no")) url_string = "#url_string#&row_no=#attributes.row_no#";
	if (isdefined("attributes.field_adress_id")) url_string = "#url_string#&field_adress_id=#attributes.field_adress_id#";
	if (isdefined('attributes.control_pos')) url_string = '#url_string#&control_pos=#control_pos#';
	if (isdefined("attributes.pos_code")) url_string = "#url_string#&pos_code=#attributes.pos_code#";
	if (isdefined("attributes.pos_code_text")) url_string = "#url_string#&pos_code_text=#attributes.pos_code_text#";
	if (isdefined('attributes.function_name')) url_string = '#url_string#&function_name=#function_name#';
	if (isdefined("attributes.is_rate_select")) url_string = "#url_string#&is_rate_select=#attributes.is_rate_select#";
	if (isdefined("attributes.analysis_id")) url_string = "#url_string#&analysis_id=#attributes.analysis_id#";
	if (isdefined("attributes.is_my_extre_page")) url_string = "#url_string#&is_my_extre_page=#attributes.is_my_extre_page#";
	if (isdefined("attributes.satir")) url_string = "#url_string#&satir=#attributes.satir#";
</cfscript>
<cfsavecontent variable="head_">
    <cfoutput>
        <div class="form-row">
            <div class="form-group col-lg-2">
                <select class="form-control" name="categories" id="categories">
                    <cfif listcontainsnocase(select_list,1)>
                        <option value="widgetloader?widget_load=listPos&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" ><cf_get_lang dictionary_id='58875.Calisanlar'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,7)>
                        <option value="widgetloader?widget_load=listPars&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" <cfif attributes.widget_load is "listPars"> selected</cfif>><cfif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 0)><!---<cf_ge t_lang_main no='1261.Musteriler'>---><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'><cfelseif isdefined("attributes.is_buyer_seller") and (attributes.is_buyer_seller eq 1)><cf_get_lang dictionary_id='29528.Tedarikciler'><cfelse><cf_get_lang dictionary_id='29408.Kurumsal Uyeler'></cfif></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,8)>
                        <option value="widgetloader?widget_load=listCons&isbox=1&draggable=1&modal_id=#attributes.modal_id#&#url_string#" <cfif attributes.widget_load is "listCons"> selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Uyeler'></option>
                    </cfif>
                </select>
            </div>
        </div>
    </cfoutput>
</cfsavecontent>
<cfform name="search_con" id="search_con" method="post" action="widgetloader?widget_load=listCons&isbox=1&#url_string#">
	<div class="form-row">
		<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
		<div class="form-group col-lg-2 m-auto">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='32828.Keyword'></label>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
			<cfif isdefined("attributes.member_code") and len(attributes.member_code)>
				<cfinput class="form-control" type="text" name="keyword" placeholder="#message#" id="keyword" maxlength="50" value="#attributes.member_code#" >
			<cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
				<cfinput class="form-control" type="text" name="keyword" placeholder="#message#" id="keyword" maxlength="50" value="#attributes.keyword#">
			<cfelse>
				<cfinput class="form-control" type="text" name="keyword" placeholder="#message#" id="keyword" maxlength="50" value="">
			</cfif>
		</div>		
		<div class="form-group col-lg-2 m-auto">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='58627.Kimlik No'></label>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='58627.Kimlik No'></cfsavecontent>
			<input class="form-control" type="text" name="identity_no" placeholder="<cfoutput>#message#</cfoutput>" id="identity_no" value="<cfif isdefined("attributes.identity_no")><cfoutput>#attributes.identity_no#</cfoutput></cfif>" maxlength="11" onkeyup="isNumber(this);">
		</div>
		<div class="form-group col-lg-2 m-auto">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
			<select class="form-control" name="consumer_cat" id="consumer_cat">
				<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
				<cfoutput query="get_consumer_cat">
					<option value="#get_consumer_cat.CONSCAT_ID#" <cfif isdefined("attributes.consumer_cat") and attributes.consumer_cat eq get_consumer_cat.CONSCAT_ID>selected</cfif>>#get_consumer_cat.CONSCAT#</option>
				</cfoutput>
			</select>
		</div>
		<div class="form-group col-lg-2 m-auto">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'></label>
			<select class="form-control" name="search_status" id="search_status">			
				<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
				<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
				<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
			</select>	
		</div>	
		
		<div class="form-group col-lg-1 mt-5 py-2">             
			<button type="button" class="btn font-weight-bold text-uppercase btn-color-7" onclick="loadPopupBox('search_con','<cfoutput>#attributes.modal_id#</cfoutput>')"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
		</div>
		
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		<cfif isdefined("attributes.consumer_cat") and len(attributes.consumer_cat)>
			<cfset url_string = "#url_string#&consumer_cat=#attributes.consumer_cat#">
		</cfif>
		<cfif isdefined("attributes.identity_no") and len(attributes.identity_no)>
			<cfset url_string = "#url_string#&identity_no=#attributes.identity_no#">
		</cfif>
		<cfif isdefined("attributes.member_code") and len(attributes.member_code)>
			<cfset url_string = "#url_string#&member_code=#attributes.member_code#">
		</cfif>
		<cfif isdefined("attributes.ref_code") and len(attributes.ref_code)>
			<cfset url_string = "#url_string#&ref_code=#attributes.ref_code#">
		</cfif>
		<cfif isdefined("attributes.ref_code_name") and len(attributes.ref_code_name)>
			<cfset url_string = "#url_string#&ref_code_name=#attributes.ref_code_name#">
		</cfif>
		<cfif isdefined("attributes.period_id")>
			<cfset url_string = "#url_string#&period_id=#attributes.period_id#">
		</cfif>
	</div>
</cfform>
<cfoutput>#head_#</cfoutput>
<div class="table-responsive ui-scroll">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58585.Kod'></th>
				<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
				<th><cf_get_lang dictionary_id='57486.kategori'></th>
			
			</tr>
		</thead>
		<tbody>
			<cfif get_consumers.recordcount>
				<cfset county_list=''>
				<cfset city_id_list=''>
				<cfset country_list=''>
				<cfset district_list=''>
				<cfset consumer_id_list=''>
				<cfset ims_code_list=''>
				<cfoutput query="get_consumers" >
					<cfif len(work_county_id) and not listfindnocase(county_list,work_county_id)>
					<cfset county_list = Listappend(county_list,work_county_id)>
					</cfif>
					<cfif len(home_county_id) and not listfindnocase(county_list,home_county_id)>
					<cfset county_list = Listappend(county_list,home_county_id)>
					</cfif>
					<cfif len(work_city_id) and not listfindnocase(city_id_list,work_city_id)>
					<cfset city_id_list = Listappend(city_id_list,work_city_id)>
					</cfif>
					<cfif len(home_city_id) and not listfindnocase(city_id_list,home_city_id)>
					<cfset city_id_list = Listappend(city_id_list,home_city_id)>
					</cfif>
					<cfif len(ims_code_id) and not listfindnocase(ims_code_list, ims_code_id)>
					<cfset ims_code_list = Listappend(ims_code_list,ims_code_id)>
					</cfif>
					<cfif isdefined("attributes.field_long_address") or isdefined("attributes.field_country")>
						<cfif len(work_country_id) and not listfindnocase(country_list,work_country_id)>
							<cfset country_list = Listappend(country_list,work_country_id)>
						</cfif>
						<cfif len(home_country_id) and not listfindnocase(country_list,home_country_id)>
							<cfset country_list = Listappend(country_list,home_country_id)>
						</cfif>
					</cfif>
					<cfif len(work_district_id) and not listfindnocase(district_list,work_district_id)>
						<cfset district_list = Listappend(district_list,work_district_id)>
					</cfif>
					<cfif len(home_district_id) and not listfindnocase(district_list,home_district_id)>
						<cfset district_list = Listappend(district_list,home_district_id)>
					</cfif>
					
					<cfset consumer_id_list = Listappend(consumer_id_list,consumer_id)>
				</cfoutput>
				<cfif len(county_list)>
					<cfset county_list=listsort(county_list,"numeric","ASC",",")>	
					<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
						SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
					</cfquery>				
				</cfif>
				<cfif len(city_id_list)>
					<cfquery name="GET_CITY_NAME" datasource="#DSN#">
						SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
					</cfquery>
					<cfset city_id_list = listsort(listdeleteduplicates(valueList(GET_CITY_NAME.CITY_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(country_list)>
					<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
						SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
					</cfquery>
					<cfset country_list = listsort(listdeleteduplicates(valueList(GET_COUNTRY_NAME.COUNTRY_ID,',')),'numeric','ASC',',')>				
				</cfif>
				<cfif len(district_list)>
					<cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
						SELECT DISTRICT_NAME,DISTRICT_ID FROM SETUP_DISTRICT WHERE DISTRICT_ID IN (#district_list#) ORDER BY DISTRICT_ID
					</cfquery>
					<cfset district_list = listsort(listdeleteduplicates(valueList(GET_DISTRICT_NAME.DISTRICT_ID,',')),'numeric','ASC',',')>				
				</cfif>
				<cfif len(ims_code_list)>
					<cfquery name="GET_IMS_CODE_NAME" datasource="#DSN#">
						SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#ims_code_list#) ORDER BY IMS_CODE_ID
					</cfquery>
					<cfset ims_code_list = listsort(listdeleteduplicates(valueList(GET_IMS_CODE_NAME.IMS_CODE_ID,',')),'numeric','ASC',',')>				
				</cfif>
				<cfif len(consumer_id_list) and isdefined("attributes.field_paymethod_id") and isdefined("attributes.field_paymethod")>
					<cfset consumer_id_list=listsort(consumer_id_list, "numeric","ASC",",")>
					<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
						SELECT 
							SP.PAYMETHOD_ID,
							SP.PAYMETHOD,
							SP.DUE_DAY,
							CC.CONSUMER_ID
						FROM
							COMPANY_CREDIT CC,
							SETUP_PAYMETHOD SP
						WHERE
							CC.CONSUMER_ID IN (#consumer_id_list#) AND
							CC.OUR_COMPANY_ID = #session_company_id# AND
							CC.PAYMETHOD_ID = SP.PAYMETHOD_ID
						ORDER BY
							CC.CONSUMER_ID
					</cfquery>
					<cfoutput query="get_paymethod">
						<cfset "paymethod_id_#consumer_id#" = get_paymethod.paymethod_id>
						<cfset "paymethod_name_#consumer_id#" = get_paymethod.paymethod>
						<cfset "due_paymethod_#consumer_id#" = get_paymethod.due_day>
					</cfoutput>				
				</cfif>
				<cfif len(consumer_id_list) and isdefined("attributes.field_revmethod_id") and isdefined("attributes.field_paymethod")>
					<cfset consumer_id_list=listsort(consumer_id_list, "numeric","ASC",",")>
					<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
						SELECT 
							SP.PAYMETHOD_ID,
							SP.PAYMETHOD,
							SP.DUE_DAY,
							CC.CONSUMER_ID
						FROM
							COMPANY_CREDIT CC,
							SETUP_PAYMETHOD SP
						WHERE
							CC.CONSUMER_ID IN (#consumer_id_list#) AND
							CC.OUR_COMPANY_ID = #session_company_id# AND
							CC.REVMETHOD_ID = SP.PAYMETHOD_ID
						ORDER BY
							CC.CONSUMER_ID
					</cfquery>
					<cfoutput query="get_paymethod">
						<cfset "revmethod_id_#consumer_id#" = get_paymethod.paymethod_id>
						<cfset "revmethod_name_#consumer_id#" = get_paymethod.paymethod>
						<cfset "due_revmethod_#consumer_id#" = get_paymethod.due_day>
					</cfoutput>				
				</cfif>
				<cfif len(consumer_id_list) and isdefined("attributes.field_paymethod_id") and isdefined("attributes.field_paymethod") and isdefined("attributes.field_card_payment_id")>
					<cfset consumer_id_list=listsort(consumer_id_list, "numeric","ASC",",")>
					<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
						SELECT 
							SP.PAYMENT_TYPE_ID,
							SP.CARD_NO,
							CC.CONSUMER_ID
						FROM
							COMPANY_CREDIT CC,
							#dsn3_alias#.CREDITCARD_PAYMENT_TYPE SP
						WHERE
							CC.CONSUMER_ID IN (#consumer_id_list#) AND
							CC.OUR_COMPANY_ID = #session_company_id# AND
							CC.CARD_PAYMETHOD_ID = SP.PAYMENT_TYPE_ID
						ORDER BY
							CC.CONSUMER_ID
					</cfquery>
					<cfoutput query="get_paymethod">
						<cfset "card_paymethod_id_#consumer_id#" = get_paymethod.payment_type_id>
						<cfset "paymethod_name_#consumer_id#" = get_paymethod.card_no>
					</cfoutput>				
				</cfif>
				<cfif len(consumer_id_list) and isdefined("attributes.field_revmethod_id") and isdefined("attributes.field_revmethod") and isdefined("attributes.field_card_payment_id")>
					<cfset consumer_id_list=listsort(consumer_id_list, "numeric","ASC",",")>
					<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
						SELECT 
							SP.PAYMENT_TYPE_ID,
							SP.CARD_NO,
							CC.CONSUMER_ID
						FROM
							COMPANY_CREDIT CC,
							#dsn3_alias#.CREDITCARD_PAYMENT_TYPE SP
						WHERE
							CC.CONSUMER_ID IN (#consumer_id_list#) AND
							CC.OUR_COMPANY_ID = #session_company_id# AND
							CC.CARD_REVMETHOD_ID = SP.PAYMENT_TYPE_ID
						ORDER BY
							CC.CONSUMER_ID
					</cfquery>
					<cfoutput query="get_paymethod">
						<cfset "card_revmethod_id_#consumer_id#" = get_paymethod.payment_type_id>
						<cfset "revmethod_name_#consumer_id#" = get_paymethod.card_no>
					</cfoutput>				
				</cfif>
				<cfoutput query="get_consumers" >
					<tr>
						<td>#consumer_id#</td>
						<td>#member_code#</td>
						<td>
						<cfif isdefined("attributes.camp_id")>
							<a href="#request.self#?fuseaction=campaign.emptypopup_add_target_people&member_type=consumer&con_ids=#consumer_id#&camp_id=#attributes.camp_id#" class="tableyazi"> #consumer_name# #consumer_surname# </a>
						<cfelse>
							<cfset paymethod_id = ''>
							<cfset paymethod_name = ''>
							<cfset revmethod_id = ''>
							<cfset revmethod_name = ''>
							<cfset card_paymethod_id = ''>
							<cfset card_revmethod_id = ''>
							<cfset due_paymethod = 0>
							<cfset due_revmethod = 0>
							<cfset county_ = ''>
							<cfset home_county_ = ''>
							<cfset city_ = ''>
							<cfset country_=''>
							<cfset ims_code_name_=''>
							<cfset district_=''>
							<cfif (isdefined("attributes.field_county") or isdefined("attributes.field_long_address")) and len(county_list)>
									<cfset county_ = '#get_county_name.county_name[listfind(county_list,get_consumers.home_county_id,',')]#'>
							</cfif>
							<cfif isdefined("attributes.field_home_county") and len(county_list)>
								<cfset home_county_ = '#get_county_name.county_name[listfind(county_list,get_consumers.home_county_id,',')]#'>
							</cfif>
							<cfif isdefined("attributes.field_ims_code_name") and len(ims_code_list)>
								<cfset ims_code_name_ = '#get_ims_code_name.ims_code[listfind(ims_code_list,get_consumers.ims_code_id,',')]# #get_ims_code_name.ims_code_name[listfind(ims_code_list,get_consumers.ims_code_id,',')]#'>
							</cfif>
								<cfif (isdefined("attributes.field_city") or isdefined("attributes.field_long_address")) and len(get_consumers.home_city_id)>
									<cfset city_ = '#get_city_name.city_name[listfind(city_id_list,get_consumers.home_city_id,',')]#'>
								</cfif>
								<cfif (isdefined("attributes.field_country") or isdefined("attributes.field_long_address")) and len(get_consumers.home_country_id)>
									<cfset country_ = '#get_country_name.country_name[listfind(country_list,get_consumers.home_country_id,',')]#'>
								</cfif>	
								<cfif len(district_list) and len(get_consumers.home_district_id)>	
									<cfset district_ = '#get_district_name.district_name[listfind(district_list,get_consumers.home_district_id,',')]#'>
								</cfif>
							<cfif len(district_)>
								<cfset district_ = '#district_# '>
							</cfif>
							<cfset RepList = "#Chr(39)#,#Chr(13)#,#Chr(10)#">
							<cfset RepListNew = " , , ">
								<cfset str_adres = ReplaceList("#homeaddress#",RepList,RepListNew)>
								<cfset str_long_adres = ReplaceList("#district_##homeaddress# #homepostcode# #county_# #city_# #country_#",RepList,RepListNew)>
								<cfset str_adres_id = -2>
							
							<cfset str_home_adres = ReplaceList("#homeaddress#",RepList,RepListNew)>
							
							<cfif isdefined("paymethod_id_#consumer_id#")>
								<cfset paymethod_id = evaluate("paymethod_id_#consumer_id#")>
								<cfset paymethod_name = evaluate("paymethod_name_#consumer_id#")>
								<cfset due_paymethod = evaluate("due_paymethod_#consumer_id#")>
							</cfif>
							<cfif isdefined("revmethod_id_#consumer_id#")>
								<cfset revmethod_id = evaluate("revmethod_id_#consumer_id#")>
								<cfset revmethod_name = evaluate("revmethod_name_#consumer_id#")>
								<cfset due_revmethod = evaluate("due_revmethod_#consumer_id#")>
							</cfif>
							<cfif isdefined("card_paymethod_id_#consumer_id#")>
								<cfset card_paymethod_id = evaluate("card_paymethod_id_#consumer_id#")>
								<cfset paymethod_name = evaluate("paymethod_name_#consumer_id#")>
							</cfif>
							<cfif isdefined("card_revmethod_id_#consumer_id#")>
								<cfset card_revmethod_id = evaluate("card_revmethod_id_#consumer_id#")>
								<cfset revmethod_name = evaluate("revmethod_name_#consumer_id#")>
							</cfif>
							<cfset related_company_id_ = ''>
							<cfset related_company_ = ''>
							<cfif isdefined("attributes.is_county_related_company") and len(county_)>
								<cfquery name="get_related_" datasource="#dsn#">
									SELECT TOP 1
										C.COMPANY_ID,
										C.NICKNAME
									FROM 
										SALES_ZONES SZ,
										SALES_ZONES_TEAM SZT,
										SALES_ZONES_TEAM_COUNTY SZTC,
										COMPANY C
									WHERE 
										C.COMPANY_ID = SZ.RESPONSIBLE_COMPANY_ID AND
										SZ.SZ_ID = SZT.SALES_ZONES 
								</cfquery>
								<cfif get_related_.recordcount>
									<cfset related_company_id_ = get_related_.COMPANY_ID>
									<cfset related_company_ = get_related_.NICKNAME>
								</cfif>
							</cfif>
							<cfset temp_ozel_kod=ReplaceList(ozel_kod,RepList,RepListNew)>
							<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_multi_act") and attributes.is_multi_act eq 1>
								<cfset consumer_id_ = consumer_id&'_'&acc_type_id>
							<cfelse>
								<cfset consumer_id_ = consumer_id>
							</cfif>
							<a href="javascript:add_user('#consumer_id_#','#consumer_name# #consumer_surname#','#company#','#str_long_adres#','#str_adres#','#homepostcode#','#homesemt#','#county_#','#home_county_id#','#city_#','#home_city_id#','#country_#','#home_country_id#','#CONSUMER_EMAIL#','#CONSUMER_HOMETELCODE##CONSUMER_HOMETEL#',<cfif len(CONSUMER_REFERENCE_CODE)>'#CONSUMER_REFERENCE_CODE#'<cfelse>''</cfif>,'#paymethod_id#','#paymethod_name#','#revmethod_id#','#revmethod_name#','#card_paymethod_id#','#card_revmethod_id#','#due_paymethod#','#due_revmethod#','#member_code#','#CONSUMER_WORKTELCODE#','#CONSUMER_WORKTEL#','#consumer_name#','#consumer_surname#','#str_home_adres#','#home_county_#','#home_county_id#','#home_city_id#','#consumer_hometelcode#','#consumer_hometel#','#MOBIL_CODE#','#MOBILTEL#','#temp_ozel_kod#','#tc_identy_no#','#vocation_type_id#','#consumer_username#','#imcat_id#','#im#','#title#','#mission#','#department#','#sex#','#consumer_tel_ext#','#consumer_faxcode#','#consumer_fax#','#homepage#','#tax_office#','#tax_no#','#related_company_id_#','#related_company_#','#ims_code_name_#','#ims_code_id#','#str_adres_id#','#mobil_code_2#','#mobiltel_2#');" class="tableyazi"> #consumer_name# #consumer_surname# </a>
						</cfif>
						</td>
						<td>#conscat#</td>						
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4"><cfif isdefined('attributes.is_form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</table>
</div>
<script type="text/javascript">
	$(document).ready(function(){
    $( "#keyword" ).focus();
});
	function change_category(vl)
	{
		var listParam ;
        if(vl == "") vl = "0;0;0";
        <cfif isdefined("session.ep.userid")>
            listParam = "<cfoutput>#session.ep.userid#</cfoutput>*"+list_getat(vl,2,';');
        </cfif>
		var get_my_consumercat = wrk_safe_query('obj_get_my_consumercat','dsn',0,listParam);
		if(get_my_consumercat.recordcount)
		{
			for(j=<cfoutput>#get_consumer_cat.recordcount#</cfoutput>;j>=0;j--)
				document.getElementById("consumer_cat").options[j] = null;
			
			document.getElementById("consumer_cat").options[0] = new Option("<cf_get_lang dictionary_id='57486.Kategori'>","");
			for(var jj=0;jj<get_my_consumercat.recordcount;jj++)
			{
				document.getElementById("consumer_cat").options[jj+1]=new Option(get_my_consumercat.CONSCAT[jj],get_my_consumercat.CONSCAT_ID[jj]);
			}
		}
	}
	$("#categories").change(function(){
		openBoxDraggable(this.value,<cfoutput>#attributes.modal_id#</cfoutput>);  		
	});
</script>