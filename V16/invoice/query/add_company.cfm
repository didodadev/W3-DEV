<cfinclude template = "../../objects/query/session_base.cfm">
<cfscript>
	list="',""";
	list2=" , ";
	attributes.member_name=replacelist(trim(attributes.member_name),list,list2);
	attributes.member_surname=replacelist(trim(attributes.member_surname),list,list2);
	a = "";
</cfscript>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.comp_name=replacelist(trim(attributes.comp_name),list,list2);
</cfscript>
<cfif not isdefined('is_web_service')><!--- web servisden geliyorsa aynı isim varmı diye kontrol edilmez--->
	<cfquery name="GET_COMP" datasource="#DSN2#">
		SELECT 	
			COMPANY_ID 
		FROM 
			#dsn_alias#.COMPANY 
		WHERE 
			FULLNAME = '#attributes.comp_name#'
		<cfif isDefined("attributes.company_code") and len(attributes.company_code)>
			OR MEMBER_CODE = '#attributes.member_code#'
		</cfif>
	</cfquery>
	<cfif get_comp.recordcount>
		<script type="text/javascript">
			alert("Şirketin tam ünvanı/kısa ünvanı veya üye kodu ile kayıtlı bir şirket var lütfen kontrol ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="ADD_COMPANY" datasource="#DSN2#">
	INSERT INTO 
		#dsn_alias#.COMPANY
    (
        COMPANY_STATUS,
        COMPANYCAT_ID,
        COMPANY_STATE,
        PERIOD_ID,
        MEMBER_CODE,
        <cfif isdefined('attributes.member_special_code') and len(attributes.member_special_code)>OZEL_KOD,</cfif>
        FULLNAME,
        NICKNAME,
        TAXOFFICE,
        TAXNO,
        COMPANY_EMAIL,
        COMPANY_TELCODE,
        COMPANY_TEL1,
        COMPANY_FAX,												
        COMPANY_ADDRESS,
        COUNTY,
        CITY,
        COUNTRY,
        IS_SELLER,
        IS_BUYER,
        IMS_CODE_ID,
        MOBIL_CODE,
        MOBILTEL,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE,
        IS_PERSON
    )
	VALUES
    (
        1,
        <cfif isdefined("attributes.comp_member_cat") and len(attributes.comp_member_cat)>#comp_member_cat#,<cfelse>#company_cat_id#,</cfif>
        #attributes.company_stage#,
        #session_base.period_id#,
        <cfif len(attributes.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_code#"><cfelse>NULL</cfif>,
        <cfif isdefined('attributes.member_special_code') and len(attributes.member_special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_special_code#">,</cfif>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#">,
        <cfif len(attributes.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_office#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.email)#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
        <cfif len(attributes.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#"><cfelse>NULL</cfif>,				
        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
        <cfif len(attributes.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#"><cfelse>NULL</cfif>,
        <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.country") and len(attributes.country)>#attributes.country#<cfelse>1</cfif>,
        0,
        1,
        <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.mobil_code") and len(attributes.mobil_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#"><cfelse>NULL</cfif>,
        <cfif isdefined("attributes.mobil_tel") and len(attributes.mobil_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#"><cfelse>NULL</cfif>,
        #session_base.userid#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        <cfif isdefined("attributes.is_person")>1<cfelse>0</cfif>			
    )
</cfquery>
<cfquery name="GET_MAX" datasource="#DSN2#">
	SELECT MAX(COMPANY_ID) MAX_COMPANY FROM #dsn_alias#.COMPANY
</cfquery>	
<cfquery name="ADD_COMP_PERIOD" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.COMPANY_PERIOD
    (
        COMPANY_ID,
        PERIOD_ID
    )
    VALUES
    (
        #get_max.max_company#,
        #session_base.period_id#
    )
</cfquery>
<cfquery name="ADD_PARTNER" datasource="#DSN2#">
	INSERT INTO 
		#dsn_alias#.COMPANY_PARTNER 
    (
        COMPANY_ID,
        COMPANY_PARTNER_NAME,
        COMPANY_PARTNER_SURNAME,
        COMPANY_PARTNER_EMAIL,
        MOBIL_CODE,
        MOBILTEL,
        COMPANY_PARTNER_TELCODE,
        COMPANY_PARTNER_TEL,
        COMPANY_PARTNER_FAX,					
        MEMBER_TYPE,					
        COMPANY_PARTNER_ADDRESS,
        COUNTY,
        CITY,
        RECORD_DATE,
        RECORD_MEMBER,
        RECORD_IP,
        TC_IDENTITY	
    )
	VALUES
    (
        #get_max.max_company#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_surname#">,
        <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"><cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#">,
        <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
        1,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">,
        <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
        #now()#,
        #session_base.userid#,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        <cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>'#attributes.tc_num#'<cfelse>NULL</cfif>
    )
</cfquery>
<cfquery name="GET_MAX_PARTNER" datasource="#DSN2#">
	SELECT
		MAX(PARTNER_ID) MAX_PARTNER_ID
	FROM
		#dsn_alias#.COMPANY_PARTNER
</cfquery>

<cfquery name="UPD_MEMBER_CODE" datasource="#DSN2#">
	UPDATE
		#dsn_alias#.COMPANY_PARTNER
	SET
		MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#get_max_partner.max_partner_id#">
	WHERE
		PARTNER_ID = #get_max_partner.max_partner_id#
</cfquery>
<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.COMPANY_PARTNER_DETAIL
    (
        PARTNER_ID
    )
	VALUES
    (
        #get_max_partner.max_partner_id#
    )
</cfquery>
<cfquery name="ADD_PART_SETTINGS" datasource="#DSN2#">
	INSERT INTO 
		#dsn_alias#.MY_SETTINGS_P 
    (
        PARTNER_ID,
        TIME_ZONE,
        MAXROWS,
        TIMEOUT_LIMIT
    )
	VALUES 
    (
        #get_max_partner.max_partner_id#,
        0,
        20,
        30
    )
</cfquery>
<cfquery name="UPD_MEMBER_CODE" datasource="#DSN2#">
	UPDATE 
		#dsn_alias#.COMPANY 
	SET		
	<cfif isdefined("attributes.company_code") and len(attributes.company_code)>
		MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company_code#">
	<cfelse>
		MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="C#get_max.max_company#">
	</cfif>
	WHERE 
		COMPANY_ID = #get_max.max_company#
</cfquery>
<cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN2#">
	UPDATE
		#dsn_alias#.COMPANY
	SET
		MANAGER_PARTNER_ID = #get_max_partner.max_partner_id#
	WHERE
		COMPANY_ID = #get_max.max_company#
</cfquery>
<cfquery name="ADD_BRANCH_RELATED" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.COMPANY_BRANCH_RELATED
    (
        COMPANY_ID,
        OUR_COMPANY_ID,
        BRANCH_ID,
        OPEN_DATE,
        RECORD_EMP,
        RECORD_DATE,
        RECORD_IP
    )
	VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session_base.user_location,2,'-')#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
    )
</cfquery>

<cfif session_base.our_company_info.is_efatura and isdefined("attributes.tax_num") and len(attributes.tax_num)>
   		<cfquery name="CHK_EINVOICE_METHOD" datasource="#DSN2#">
            SELECT EINVOICE_TYPE,EINVOICE_TEST_SYSTEM,EINVOICE_USER_NAME,EINVOICE_PASSWORD FROM #dsn_alias#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
        </cfquery>
		 <cfscript>
            ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"COMPANY",Action_id:get_max.max_company,VKN:attributes.tax_num,TCKN:attributes.tc_num,using_alias:dsn2);
        </cfscript> 
</cfif>
