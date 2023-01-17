<cfquery name="CHECK_BRANCH" datasource="#DSN#">
	SELECT
		COMPBRANCH_ID
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME = '#trim(attributes.compbranch__name)#' AND 
		COMPANY_ID = #attributes.company_id#
</cfquery>
<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='1735.şube adı'><cf_get_lang_main no='781.tekrarı'>");
		window.history.go(-1);
	</script>
<cfelse>
	<!---onceden secilmis sevk adresi varsa kaldırıyoruz--->
	<cfif isdefined("attributes.is_ship_address") and len(attributes.is_ship_address)>
		<cfquery name="UPD_BRANCH" datasource="#DSN#">
			UPDATE COMPANY_BRANCH SET IS_SHIP_ADDRESS=0 WHERE COMPANY_ID = #attributes.company_id# AND IS_SHIP_ADDRESS = 1
		</cfquery>
	</cfif>
	<!---onceden secilmis fatura adresi varsa  kaldırıyoruz--->
	<cfif isdefined("attributes.is_invoice_address") and len(attributes.is_invoice_address)>
		<cfquery name="UPD_BRANCH" datasource="#DSN#">
			UPDATE COMPANY_BRANCH SET IS_INVOICE_ADDRESS = 0 WHERE COMPANY_ID = #attributes.company_id# AND IS_INVOICE_ADDRESS = 1
		</cfquery>
	</cfif>
	<cfif len(attributes.compbranch_address)>
        <cfset list="\n,#Chr(13)#,#Chr(10)#"><!--- Newline karakterlerinin database e yazılmaması için eklenmiştir. --->
        <cfset list2=" , , ">
        <cfset attributes.compbranch_address=replacelist(attributes.compbranch_address,list,list2)>
    </cfif>
    <cfquery name="ADD_COMPANY_BRANCH" datasource="#DSN#">
        INSERT INTO
            COMPANY_BRANCH
        (
            COMPBRANCH_STATUS,
            COMPANY_ID,
            COMPBRANCH_CODE,
            COMPBRANCH_ALIAS,
            POS_CODE,
            COMPBRANCH__NAME,
            COMPBRANCH__NICKNAME,
            COMPBRANCH_EMAIL,
            COMPBRANCH_TELCODE,
            COMPBRANCH_TEL1,
            COMPBRANCH_TEL2,
            COMPBRANCH_TEL3,
            COMPBRANCH_FAX,
            HOMEPAGE,
            COMPBRANCH_ADDRESS,
            COMPBRANCH_POSTCODE,
            SEMT,
            COUNTY_ID,
            CITY_ID,
            COUNTRY_ID,
            MANAGER_PARTNER_ID,
            IS_SHIP_ADDRESS,
            IS_INVOICE_ADDRESS,
            RECORD_DATE,	
            RECORD_MEMBER,
            RECORD_IP,
            COORDINATE_1,
            COORDINATE_2,
            COMPBRANCH_MOBIL_CODE,
            COMPBRANCH_MOBILTEL,
            SZ_ID
        )
            VALUES
        (
            <cfif isdefined("attributes.compbranch_status")>1<cfelse>0</cfif>,
            #attributes.company_id#,
            <cfif len(attributes.compbranch_code)>'#attributes.compbranch_code#'<cfelse>NULL</cfif>,
            <cfif len(attributes.compbranch_alias)>'#attributes.compbranch_alias#'<cfelse>NULL</cfif>,
            <cfif len(attributes.pos_code)>#attributes.pos_code#<cfelse>NULL</cfif>,
            '#attributes.compbranch__name#',
            <cfif isdefined("attributes.compbranch__nickname") and len(attributes.compbranch__nickname)>'#attributes.compbranch__nickname#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_email") and len(attributes.compbranch_email)>'#attributes.compbranch_email#'<cfelse>NULL</cfif>,
            '#attributes.compbranch_telcode#',
            '#attributes.compbranch_tel1#',
            <cfif isdefined("attributes.compbranch_tel2") and len(attributes.compbranch_tel2)>'#attributes.compbranch_tel2#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_tel3") and len(attributes.compbranch_tel3)>'#attributes.compbranch_tel3#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_fax") and len(attributes.compbranch_fax)>'#attributes.compbranch_fax#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_address") and len(attributes.compbranch_address)>'#wrk_eval("attributes.compbranch_address")#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_postcode") and len(attributes.compbranch_postcode)>'#attributes.compbranch_postcode#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.semt") and len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.country") and len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.manager_partner_id") and len(attributes.manager_partner_id)>#attributes.manager_partner_id#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.is_ship_address") and len(attributes.is_ship_address)>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.is_invoice_address") and len(attributes.is_invoice_address)>1<cfelse>0</cfif>,
            #now()#,
            #session.ep.userid#,
            '#cgi.remote_addr#',
            <cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
            <cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
            <cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
            <cfif len(attributes.sales_zone_id)>'#attributes.sales_zone_id#'<cfelse>NULL</cfif>
        )
    </cfquery>
	
</cfif>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.company_id#</cfoutput>";
</script>
