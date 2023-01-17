<cfquery name="GET_COMP" datasource="#dsn#">
	SELECT
		COMPANY_ID
	FROM 
		COMPANY
	WHERE 
		(FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fullname#"> AND COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#">)
		OR
		(NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nickname#"> AND COMPANY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#">)
		<cfif isDefined("FORM.COMPANY_CODE") and len(FORM.COMPANY_CODE)>
			OR MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.company_code#">
		</cfif>
</cfquery>

<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1401.Şirketin Tam Ünvanı/Kısa Ünvanı veya Üye kodu ile kayıtlı bir Şirket var lutfen kontrol ediniz'>..");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>	
<cfquery name="UPD_COMPANY" datasource="#dsn#">
	UPDATE 
		COMPANY 
	SET
		<cfif isDefined("FORM.COMPANYCAT_ID")>
		COMPANYCAT_ID = #FORM.COMPANYCAT_ID#,
		</cfif>
		FULLNAME = '#FORM.FULLNAME#',
		NICKNAME = '#FORM.NICKNAME#',
		COMPANY_EMAIL = '#TRIM(FORM.EMAIL)#',
		HOMEPAGE = '#TRIM(FORM.HOMEPAGE)#',
		COMPANY_TELCODE = '#FORM.TELCOD#',
		COMPANY_TEL1 = '#FORM.TEL1#',
		COMPANY_FAX = '#FORM.FAX#',
		COMPANY_POSTCODE = '#FORM.POSTCOD#', 
		COMPANY_ADDRESS = '#FORM.ADRES#',
		COUNTY = '#FORM.COUNTY#',
		CITY = '#FORM.CITY#',
		COUNTRY = '#FORM.COUNTRY#',
		SECTOR_CAT_ID = #FORM.COMPANY_SECTOR#,
		COMPANY_SIZE_CAT_ID = #FORM.COMPANY_SIZE_CAT_ID#
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#">
</cfquery>


	<cfquery name="UPD_PARTNER" datasource="#dsn#">
		UPDATE COMPANY_PARTNER SET
			 COMPANY_PARTNER_NAME = '#FORM.COMPANY_PARTNER_NAME#',
			 COMPANY_PARTNER_SURNAME = '#FORM.COMPANY_PARNTER_SURNAME#',
			 TITLE = '#FORM.COMPANY_PARTNER_TITLE#',
			 COMPANY_PARTNER_EMAIL = '#TRIM(FORM.EMAIL)#',
			 COMPANY_PARTNER_TELCODE = '#FORM.TELCOD#',		
			 COMPANY_PARTNER_FAX = '#FORM.FAX#',
			 COMPANY_PARTNER_TEL = '#FORM.TEL1#'
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.me_ww" addtoken="No">
