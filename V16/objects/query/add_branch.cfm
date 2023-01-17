<cfquery name="CHECK_BRANCH" datasource="#DSN#">
	SELECT
		COMPANY_ID
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME = '#trim(attributes.compbranch__name)#' AND 
		COMPANY_ID = #attributes.company_id#
</cfquery>
<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='838.Aynı Adlı Şube Kaydı Var ! Şube Adını Değişiniz !'>");
		window.history.go(-1);
	</script>
<cfelse>
	<cfquery name="ADD_COMPANY_BRANCH" datasource="#DSN#">
        INSERT INTO
            COMPANY_BRANCH
        (
            COMPBRANCH_STATUS,
            COMPBRANCH_CODE,
            COMPBRANCH_ALIAS,
            IS_SHIP_ADDRESS,
            IS_INVOICE_ADDRESS,
            COMPANY_ID,	
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
            RECORD_DATE,	
            RECORD_MEMBER,
            RECORD_IP,
            COORDINATE_1,
            COORDINATE_2,
            SZ_ID
        )
        VALUES
        (
            <cfif isdefined("attributes.compbranch_status")>1<cfelse>0</cfif>,
            <cfif len(attributes.compbranch_code)>'#attributes.compbranch_code#'<cfelse>NULL</cfif>,
            <cfif len(attributes.compbranch_alias)>'#attributes.compbranch_alias#'<cfelse>NULL</cfif>,            
            <cfif isdefined("attributes.shipment_address_status")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.invoice_address_status")>1<cfelse>0</cfif>,
            #attributes.company_id#,
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
            <cfif isdefined("attributes.compbranch_address") and len(attributes.compbranch_address)>'#attributes.compbranch_address#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.compbranch_postcode") and len(attributes.compbranch_postcode)>'#attributes.compbranch_postcode#'<cfelse>NULL</cfif>,
            <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
            <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.manager_partner_id") and len(attributes.manager_partner_id)>#attributes.manager_partner_id#<cfelse>NULL</cfif>,
            #now()#,
            #session.ep.userid#,
            '#cgi.remote_addr#',
            <cfif len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
            <cfif len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
            <cfif len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelse>NULL</cfif>
        )
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
