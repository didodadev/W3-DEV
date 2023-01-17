<!---onceden secilmis sevk adresi varsa kaldırıyoruz--->
<cfif isdefined("attributes.is_ship_address") and len(attributes.is_ship_address)>
	<cfquery name="UPD_BRANCH" datasource="#DSN#">
		UPDATE COMPANY_BRANCH SET IS_SHIP_ADDRESS = 0 WHERE COMPANY_ID = #attributes.company_id# AND IS_SHIP_ADDRESS = 1
	</cfquery>
</cfif>
<!---onceden secilmis fatura adresi varsa kaldırıyoruz--->
<cfif isdefined("attributes.is_invoice_address") and len(attributes.is_invoice_address)>
	<cfquery name="UPD_BRANCH" datasource="#DSN#">
		UPDATE COMPANY_BRANCH SET IS_INVOICE_ADDRESS = 0 WHERE COMPANY_ID = #attributes.company_id# AND IS_INVOICE_ADDRESS = 1
	</cfquery>
</cfif>
<cfif len(attributes.compbranch_address)>
	<cfset list="\n,#Chr(13)#,#Chr(10)#"><!--- Newline karakterlerinin database e yazılmaması için eklenmistir. --->
	<cfset list2=" , , ">
    <cfset attributes.compbranch_address=replacelist(attributes.compbranch_address,list,list2)>
</cfif>
<cfquery name="UPD_COMPANY_BRANCH" datasource="#DSN#">
	UPDATE
		COMPANY_BRANCH
	SET
		COMPBRANCH_STATUS = <cfif isdefined("attributes.compbranch_status")>1<cfelse>0</cfif>,
		POS_CODE =	<cfif len(attributes.pos_code_text)>#attributes.pos_code#<cfelse>NULL</cfif>,
        COMPBRANCH_CODE = <cfif len(attributes.compbranch_code)>'#attributes.compbranch_code#'<cfelse>NULL</cfif>,
        COMPBRANCH_ALIAS = <cfif len(attributes.compbranch_alias)>'#attributes.compbranch_alias#'<cfelse>NULL</cfif>,
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
		COMPBRANCH_ADDRESS = <cfif len(attributes.compbranch_address)>'#wrk_eval("attributes.compbranch_address")#'<cfelse>NULL</cfif>,
		COMPBRANCH_POSTCODE = '#attributes.compbranch_postcode#',
		SEMT = '#attributes.semt#',
		COUNTY_ID = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CITY_ID = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		COUNTRY_ID = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		IS_SHIP_ADDRESS=<cfif isdefined("attributes.is_ship_address") and len(attributes.is_ship_address)>1<cfelse>0</cfif>,
        IS_INVOICE_ADDRESS=<cfif isdefined("attributes.is_invoice_address") and len(attributes.is_invoice_address)>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_MEMBER = #session.ep.userid#,
		UPDATE_PAR = NULL,
		UPDATE_IP = '#cgi.remote_addr#',
		COORDINATE_1 = <cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
		COORDINATE_2 = <cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
		COMPBRANCH_MOBIL_CODE = <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
		COMPBRANCH_MOBILTEL = <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
        SZ_ID =  <cfif len(attributes.sales_zone_id)>'#attributes.sales_zone_id#'<cfelse>NULL</cfif>
	WHERE 
		COMPBRANCH_ID = #attributes.compbranch_id#
</cfquery>
 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=updBranch&brid=#attributes.compbranch_id#&cpid=#attributes.company_id#</cfoutput>";
</script>

