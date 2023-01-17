<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.nickname = replacelist(attributes.nickname,list,list2)>
<cfset attributes.fullname=replacelist(attributes.fullname,list,list2)>
<cfset attributes.nickname = trim(attributes.nickname)>

<!--- sirket unvanı ve kısa unvanı kontrolü  --->
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT
		COMPANY_ID
	FROM
		COMPANY
	WHERE
		COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#"> AND
		NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.nickname#"> 
</cfquery> 
<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1401.Şirketin Tam Ünvanı/Kısa Ünvanı veya Üye kodu ile kayıtlı bir Şirket var lutfen kontrol ediniz'>..");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfscript>
	structdelete(form,"account_code");
	structdelete(form,"HIERARCY_COMPANY");
</cfscript>
<cfquery name="UPD_COMPANY" datasource="#DSN#">
	UPDATE 
		COMPANY 
	SET
		COMPANYCAT_ID = #attributes.companycat_id#,
		<cfif isDefined("attributes.pos_code") and len(attributes.pos_code)>POS_CODE = #attributes.pos_code#,</cfif>
		FULLNAME = '#attributes.fullname#',
		SECTOR_CAT_ID = <cfif isDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
		COMPANY_SIZE_CAT_ID = <cfif len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
		TAXOFFICE = '#attributes.taxoffice#',
		TAXNO = '#attributes.taxno#',
		COMPANY_EMAIL = '#attributes.email#',
		HOMEPAGE = '#attributes.homepage#',
		COMPANY_TELCODE = <cfif len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
		COMPANY_TEL1 = <cfif len(attributes.tel1)>'#attributes.tel1#'<cfelse>NULL</cfif>,
		COMPANY_TEL2 = <cfif len(attributes.tel2)>'#attributes.tel2#'<cfelse>NULL</cfif>,
		COMPANY_TEL3 = <cfif len(attributes.tel3)>'#attributes.tel3#'<cfelse>NULL</cfif>,
		COMPANY_FAX =  <cfif len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
		COMPANY_POSTCODE = '#attributes.postcod#',
		COMPANY_ADDRESS = '#attributes.adres#',
		COUNTY = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CITY = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		COUNTRY = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		NICKNAME = <cfif len(attributes.nickname)>'#attributes.nickname#'<cfelse>NULL</cfif>,
		SEMT = <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_PAR = #session.pp.userid#,
        UPDATE_EMP = NULL,
		UPDATE_DATE = #now()#
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.upd_my_member&company_id=#attributes.company_id#" addtoken="no">

