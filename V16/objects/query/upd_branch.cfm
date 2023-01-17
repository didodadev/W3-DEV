<cfquery name="UPD_COMPANY_BRANCH" datasource="#DSN#">
	UPDATE	
		COMPANY_BRANCH
	SET	
		COMPBRANCH_STATUS = <cfif isdefined("attributes.compbranch_status")>1<cfelse>0</cfif>,
        COMPBRANCH_CODE =  <cfif len(attributes.compbranch_code)>'#attributes.compbranch_code#'<cfelse>NULL</cfif>,
        COMPBRANCH_ALIAS = <cfif len(attributes.compbranch_alias)>'#attributes.compbranch_alias#'<cfelse>NULL</cfif>,        
		POS_CODE =	<cfif len(attributes.pos_code)>#attributes.pos_code#<cfelse>NULL</cfif>,
		COMPBRANCH__NAME = '#attributes.compbranch__name#',		
		COMPBRANCH__NICKNAME = '#attributes.compbranch__nickname#',		
		MANAGER_PARTNER_ID = <cfif len(attributes.manager_partner_id)>#attributes.manager_partner_id#<cfelse>NULL</cfif>,
		COMPBRANCH_EMAIL = '#attributes.compbranch_email#',
		COMPBRANCH_TELCODE = '#attributes.compbranch_telcode#',	
		COMPBRANCH_TEL1 = '#attributes.compbranch_tel1#',
		COMPBRANCH_TEL2 = '#attributes.compbranch_tel2#',
		COMPBRANCH_TEL3 = '#attributes.compbranch_tel3#',
		COMPBRANCH_FAX = '#attributes.compbranch_fax#',
		HOMEPAGE = '#attributes.homepage#',
		COMPBRANCH_ADDRESS = '#attributes.compbranch_address#',
		COMPBRANCH_POSTCODE = '#attributes.compbranch_postcode#',
		SEMT = <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
		COUNTY_ID = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CITY_ID = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		COUNTRY_ID = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_MEMBER = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		COORDINATE_1 = <cfif len(attributes.coordinate_1)>#attributes.coordinate_1#<cfelse>NULL</cfif>,
		COORDINATE_2 = <cfif len(attributes.coordinate_2)>#attributes.coordinate_2#<cfelse>NULL</cfif>,
        SZ_ID = <cfif len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>
	WHERE 
		COMPBRANCH_ID = #attributes.compbranch_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
