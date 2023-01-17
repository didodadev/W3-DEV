<cftry><!--- Kurumsal üye sayfası --->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_company.cfm">

	<cfif len(get_company.country)>
        <cfquery name="get_country" datasource="#dsn#">
            SELECT COUNTRY_NAME,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID  = #get_company.country#
        </cfquery>
    
        <cfif len(get_country.country_phone_code)>
            <cfset phone_code = "+" & get_country.COUNTRY_PHONE_CODE>
        <cfelse>
            <cfset phone_code = get_country.COUNTRY_PHONE_CODE>
        </cfif>
    <cfelse>
    	<cfset get_country.country_name = ''>
        <cfset phone_code = ''>
        <cfset get_country.country_phone_code = ''>
    </cfif>
    <cfif len(get_company.country)>
        <cfquery name="get_city" datasource="#dsn#">
            SELECT
                 CITY_NAME
            FROM
                 SETUP_CITY
            WHERE
                COUNTRY_ID = #get_company.country# <cfif len(get_company.city)> and CITY_ID = #get_company.city#</cfif>
        </cfquery>
    <cfelse>
    	<cfset get_city.CITY_NAME = ''>
    </cfif>

	<cfif len(get_company.COUNTY)>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT
                COUNTY_NAME
            FROM
                SETUP_COUNTY
            WHERE
                COUNTY_ID = #get_company.COUNTY#
        </cfquery>
    <cfelse>
    	<cfset GET_COUNTY.COUNTY_NAME = ''>
    </cfif>
	
	<cfif len(get_company.member_code)>
		<b><cf_get_lang dictionary_id='57558.Üye No'></b><br><br>
		<cf_workcube_barcode show="1" type="code39" width="200" height="25" value="#get_company.member_code#">
		<br>
		<cfoutput>#get_company.member_code#</cfoutput>
		<br><br>
		<hr>
		<br>
	</cfif>
	<b><cf_get_lang dictionary_id='57658.Üye'> - <cf_get_lang dictionary_id='30324.Adres Bilgileri'></b> 
	<br>
    <cf_workcube_barcode show="1" type="qrcode" width="150" height="150" value="MECARD:N:#get_company.fullname#;ADR:#get_company.company_address# #get_company.semt# #get_company.company_postcode# #GET_COUNTY.COUNTY_NAME# #get_city.CITY_NAME# #get_country.country_name#;TEL:#phone_code# #get_company.company_telcode##get_company.company_tel1#;EMAIL:#get_company.company_email#;URL:#get_company.homepage#;">
    
    <cfcatch><!--- Kurumsal üyelerin çalışanları sayfası --->
		<cfsetting showdebugoutput="no">
		<cfinclude template="../../member/query/get_partner.cfm">
        
		<cfif len(GET_PARTNER.country)>
            <cfquery name="get_country" datasource="#dsn#">
                SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID  = #GET_PARTNER.country#
            </cfquery>
        <cfelse>
            <cfset get_country.COUNTRY_NAME = ''>
        </cfif>
        
		<cfif len(GET_PARTNER.COUNTRY)>
            <cfquery name="get_city" datasource="#dsn#">
                SELECT
                     CITY_NAME
                FROM
                     SETUP_CITY
                WHERE
                    COUNTRY_ID = #GET_PARTNER.COUNTRY# <cfif len(GET_PARTNER.CITY)> and CITY_ID = #GET_PARTNER.CITY#</cfif>
            </cfquery>
        <cfelse>
            <cfset get_city.CITY_NAME = ''>
        </cfif>
        
        <cfif len(GET_PARTNER.COUNTY)>
            <cfquery name="GET_COUNTY" datasource="#DSN#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY where COUNTY_ID = #GET_PARTNER.COUNTY#
            </cfquery>
		<cfelse>
        	<cfset GET_COUNTY.COUNTY_NAME = ''>
        </cfif>
        <cf_workcube_barcode show="1" type="qrcode" width="150" height="150" value="MECARD:N:#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME# #GET_PARTNER.TITLE#; ADR:#GET_PARTNER.COMPANY_PARTNER_ADDRESS# #GET_COUNTY.COUNTY_NAME# #GET_PARTNER.COMPANY_PARTNER_POSTCODE# #get_city.CITY_NAME# #GET_COUNTRY.COUNTRY_NAME# ;TEL:#GET_PARTNER.COMPANY_PARTNER_TELCODE##GET_PARTNER.COMPANY_PARTNER_TEL#; EMAIL:#GET_PARTNER.COMPANY_PARTNER_EMAIL#;">
    </cfcatch>
</cftry>
