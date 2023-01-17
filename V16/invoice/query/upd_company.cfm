<cfinclude template = "../../objects/query/session_base.cfm">
<cfscript>
	list="',""";
	list2=" , ";
	attributes.member_name=replacelist(trim(attributes.member_name),list,list2);
	attributes.member_surname=replacelist(trim(attributes.member_surname),list,list2);
</cfscript>
<cfquery name="GET_COMP" datasource="#dsn2#">
	SELECT
		COMPANY_ID
	FROM
		#dsn_alias#.COMPANY
	WHERE
		COMPANY_ID <> #attributes.company_id# AND
		<cfif isdefined("attributes.tax_office") and Len(attributes.tax_office)>
			TAXOFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_office#"> AND
		</cfif>
		<cfif isdefined("attributes.tax_num") and Len(attributes.tax_num)>
			TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_num#"> AND
		</cfif>
		(
			FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#">
		<cfif isdefined("attributes.member_code") and len(attributes.member_code)>
			OR MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_code#">
		</cfif>
		)
</cfquery>
<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("Şirketin Tam Unvanı/Kısa Unvanı Veya Uye Kodu Ile Kayıtlı Bir Şirket Var Lütfen Kontrol Ediniz");
		history.back();
	</script>
	<cfabort>
</cfif>

<!--- <cfscript>
	structdelete(form,"account_code");
	structdelete(form,"HIERARCY_COMPANY");
</cfscript> --->
<cfquery name="UPD_COMPANY" datasource="#dsn2#">
	UPDATE 
		#dsn_alias#.COMPANY 
	SET
		MEMBER_CODE = <cfif len(attributes.member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_code#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)>
			OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">,
		</cfif>
		PERIOD_ID = #session_base.period_id#,
		FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#">,
		NICKNAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_name#">,
        <cfif isdefined("attributes.comp_member_cat") and len(attributes.comp_member_cat)>
        	COMPANYCAT_ID = #comp_member_cat#,
        </cfif>
        TAXOFFICE = <cfif len(attributes.tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_office#"><cfelse>NULL</cfif>,
		TAXNO = <cfif len(attributes.tax_num)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_num#"><cfelse>NULL</cfif>,
		COMPANY_EMAIL = <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.email)#"><cfelse>NULL</cfif>,
		COMPANY_TELCODE = <cfif len(attributes.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#"><cfelse>NULL</cfif>,
		COMPANY_TEL1 = <cfif len(attributes.tel_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#"><cfelse>NULL</cfif>,
		COMPANY_FAX =  <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,
		COMPANY_ADDRESS = <cfif len(attributes.address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#"><cfelse>NULL</cfif>,
		COUNTRY = <cfif isDefined("attributes.country") and len(attributes.country)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"><cfelse>225</cfif>,
		COUNTY = <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		IMS_CODE_ID = <cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
		CITY = <cfif isdefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.mobil_code") and len(attributes.mobil_code)>
			MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#">,
		</cfif>
		<cfif isdefined("attributes.mobil_tel") and len(attributes.mobil_tel)>
			MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#">,
		</cfif>
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session_base.userid#,
		UPDATE_DATE = #now()#,
		IS_PERSON = <cfif isdefined("attributes.is_person")>1<cfelse>0</cfif>	
	WHERE
		COMPANY_ID = #attributes.company_id#
</cfquery>
<cfquery name="ADD_PARTNER" datasource="#DSN2#">
	UPDATE
		#dsn_alias#.COMPANY_PARTNER 
    SET 
        COMPANY_PARTNER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_name#">,
        COMPANY_PARTNER_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.member_surname#">,
        COMPANY_PARTNER_EMAIL = <cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"><cfelse>NULL</cfif>,
        MOBIL_CODE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_code#">,
        MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobil_tel#">,
        COMPANY_PARTNER_TELCODE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#">,
        COMPANY_PARTNER_TEL =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_number#">,
        COMPANY_PARTNER_FAX = 	 <cfif isdefined("attributes.fax_number") and len(attributes.fax_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax_number#"><cfelse>NULL</cfif>,			
        MEMBER_TYPE = 1,			
        COMPANY_PARTNER_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.address#">,
        COUNTY =  <cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
        CITY = <cfif isdefined("attributes.city") and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
        UPDATE_DATE = #now()#,
        UPDATE_MEMBER =  #session_base.userid#,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		TC_IDENTITY	= <cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>'#attributes.tc_num#'<cfelse>NULL</cfif>
	WHERE
	COMPANY_ID = #attributes.company_id#
</cfquery>
