<!--- History - Belirtilen kosullarda degisiklik varsa history ye kayit atiyor YK 20080528 --->
<cfquery name="hist_cont" datasource="#dsn#">
	SELECT
		C.*,
		(SELECT MAX(POSITION_CODE) POS_CODE FROM WORKGROUP_EMP_PAR WHERE COMPANY_ID = #session.pp.company_id# AND OUR_COMPANY_ID = #session.pp.company_id# AND IS_MASTER = 1) AGENT_POS_CODE
	FROM
		COMPANY C
	WHERE
		C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<!---<cfif (attributes.fullname neq hist_cont.fullname) or (attributes.nickname neq hist_cont.nickname) or (attributes.manager_partner_id neq hist_cont.manager_partner_id) or
	  (attributes.taxoffice neq hist_cont.taxoffice) or (attributes.taxno neq hist_cont.taxno) or (attributes.company_email neq hist_cont.company_email) or
	  (attributes.company_telcode neq hist_cont.company_telcode) or (attributes.company_tel1 neq hist_cont.company_tel1) or (attributes.company_tel2 neq hist_cont.company_tel2) or 
	  (attributes.company_tel3 neq hist_cont.company_tel3) or (attributes.company_fax neq hist_cont.company_fax) or (attributes.company_address neq hist_cont.company_address) or
	  (attributes.semt neq hist_cont.semt) or (attributes.county_id neq hist_cont.county) or (attributes.city_id neq hist_cont.city) or (attributes.country neq hist_cont.country) or
	  (attributes.company_postcode neq hist_cont.company_postcode)>
		<cfoutput query="hist_cont">
			<cfquery name="add_company_history" datasource="#dsn#">
				INSERT INTO
					COMPANY_HISTORY
				(
					COMPANY_ID,
					COMPANYCAT_ID,
					FULLNAME,
					NICKNAME,
					MANAGER_PARTNER_ID,
					TAXOFFICE,
					TAXNO,
					COMPANY_EMAIL,
					COMPANY_TELCODE,
					COMPANY_TEL1,
					COMPANY_TEL2,
					COMPANY_TEL3,
					COMPANY_FAX,
					COMPANY_ADDRESS,
					SEMT,
					COUNTY,
					CITY,
					COUNTRY,
					COMPANY_POSTCODE,
					RECORD_PAR,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#session.pp.company_id#,
					#hist_cont.companycat_id#,
					'#fullname#',
					'#nickname#',
					<cfif len(manager_partner_id)>#manager_partner_id#<cfelse>NULL</cfif>,
					<cfif len(taxoffice)>'#taxoffice#'<cfelse>NULL</cfif>,
					<cfif len(taxno)>'#taxno#'<cfelse>NULL</cfif>,
					<cfif len(company_email)>'#company_email#'<cfelse>NULL</cfif>,
					<cfif len(company_telcode)>'#company_telcode#'<cfelse>NULL</cfif>,
					<cfif len(company_tel1)>'#company_tel1#'<cfelse>NULL</cfif>,
					<cfif len(company_tel2)>'#company_tel2#'<cfelse>NULL</cfif>,
					<cfif len(company_tel3)>'#company_tel3#'<cfelse>NULL</cfif>,
					<cfif len(company_fax)>'#company_fax#'<cfelse>NULL</cfif>,
					<cfif len(company_address)>'#company_address#'<cfelse>NULL</cfif>,
					<cfif len(semt)>'#semt#'<cfelse>NULL</cfif>,
					<cfif len(county)>#county#<cfelse>NULL</cfif>,
					<cfif len(city)>#city#<cfelse>NULL</cfif>,
					<cfif len(country)>#country#<cfelse>NULL</cfif>,
					<cfif len(company_postcode)>'#company_postcode#'<cfelse>NULL</cfif>,
					#session.pp.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfoutput>
</cfif>--->
<!--- //History --->
<cfquery name="upd_company" datasource="#dsn#">
	UPDATE 
		COMPANY 
	SET
		FULLNAME = '#attributes.fullname#',
		NICKNAME = <cfif len(attributes.nickname)>'#attributes.nickname#'<cfelse>NULL</cfif>,
		MANAGER_PARTNER_ID = <cfif isDefined("attributes.manager_partner_id") and len(attributes.manager_partner_id)>#attributes.manager_partner_id#,<cfelse>NULL,</cfif>
		TAXOFFICE = '#attributes.taxoffice#',
		TAXNO = '#attributes.taxno#',COMPANY_TELCODE = <cfif len(attributes.company_telcode)>'#attributes.company_telcode#'<cfelse>NULL</cfif>,
		COMPANY_TEL1 = <cfif len(attributes.company_tel1)>'#attributes.company_tel1#'<cfelse>NULL</cfif>,
		COMPANY_TEL2 = <cfif len(attributes.company_tel2)>'#attributes.company_tel2#'<cfelse>NULL</cfif>,
		COMPANY_TEL3 = <cfif len(attributes.company_tel3)>'#attributes.company_tel3#'<cfelse>NULL</cfif>,
		COMPANY_FAX =  <cfif len(attributes.company_fax)>'#attributes.company_fax#'<cfelse>NULL</cfif>,
		COMPANY_EMAIL = '#attributes.company_email#',
		COMPANY_ADDRESS = '#attributes.company_address#',
		COMPANY_POSTCODE = '#attributes.company_postcode#',
		HOMEPAGE = <cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
		COUNTY = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		CITY = <cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
		SEMT= <cfif isdefined("attributes.semt") and len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
		COUNTRY = <cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_PAR = #session.pp.userid#,
		UPDATE_EMP = NULL,
		UPDATE_DATE = #now()#
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>

<cf_wrk_get_history  datasource='#DSN#' source_table= 'COMPANY' target_table= 'COMPANY_HISTORY' record_id= '#attributes.company_id#' record_name='COMPANY_ID'>
<cfif isdefined("attributes.count") and attributes.count gt 0>
	<cfloop from="1" to="#attributes.count#" index="b">
		<cfquery name="UPD_COMPANY_BRANCH" datasource="#dsn#">
			UPDATE
				COMPANY_BRANCH
			SET
				COMPBRANCH_ADDRESS = <cfif isdefined("attributes.branch_address_#b#") and len(evaluate('attributes.branch_address_#b#'))>'#wrk_eval('attributes.branch_address_#b#')#'<cfelse>NULL</cfif>,
				COMPBRANCH_POSTCODE = <cfif isdefined("attributes.branch_postcode_#b#") and len(evaluate('attributes.branch_postcode_#b#'))>'#wrk_eval('attributes.branch_postcode_#b#')#'<cfelse>NULL</cfif>,
				COUNTY_ID = <cfif isdefined("attributes.branch_county_id_#b#") and len(evaluate('attributes.branch_county_id_#b#'))>#evaluate('attributes.branch_county_id_#b#')#<cfelse>NULL</cfif>,
				CITY_ID = <cfif isdefined("attributes.branch_city_id_#b#") and len(evaluate('attributes.branch_city_id_#b#'))>#evaluate('attributes.branch_city_id_#b#')#<cfelse>NULL</cfif>,
				COUNTRY_ID = <cfif isdefined("attributes.branch_country_#b#") and len(evaluate('attributes.branch_country_#b#'))>#evaluate('attributes.branch_country_#b#')#<cfelse>NULL</cfif>,
				SEMT = <cfif isdefined("attributes.branch_semt_#b#") and len(evaluate('attributes.branch_semt_#b#'))>'#wrk_eval('attributes.branch_semt_#b#')#'<cfelse>NULL</cfif>,
				COMPBRANCH_TELCODE = <cfif isdefined("attributes.compbranch_telcode_#b#") and len(evaluate('attributes.compbranch_telcode_#b#'))>'#wrk_eval('attributes.compbranch_telcode_#b#')#'<cfelse>NULL</cfif>,
				COMPBRANCH_TEL1 = <cfif isdefined("attributes.compbranch_tel1_#b#") and len(evaluate('attributes.compbranch_tel1_#b#'))>'#wrk_eval('attributes.compbranch_tel1_#b#')#'<cfelse>NULL</cfif>,
				COMPBRANCH_EMAIL = <cfif isdefined("attributes.compbranch_email_#b#") and len(evaluate('attributes.compbranch_email_#b#'))>'#wrk_eval('attributes.compbranch_email_#b#')#'<cfelse>NULL</cfif>,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_PAR = #session.pp.userid#,
				UPDATE_MEMBER = NULL,
				UPDATE_DATE = #now()#
			WHERE
				COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.compbranch_id_#b#')#">
		</cfquery>
	</cfloop>
</cfif>
<cfif isdefined('attributes.orderww_back') and attributes.orderww_back eq 1>
	<cflocation url="#request.self#?fuseaction=objects2.form_add_orderww&grosstotal=#attributes.grosstotal#" addtoken="No">
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.form_upd_my_company" addtoken="no">
</cfif>
