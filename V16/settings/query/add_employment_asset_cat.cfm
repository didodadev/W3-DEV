<cfquery name="INSDRIVERLICENCE" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_EMPLOYMENT_ASSET_CAT 
	(
		SPECIAL_HIERARCHY,
		ASSET_CAT,
		IS_LAST_YEAR_CONTROL,
       	IS_VIEW_MYHOME,
		USAGE_YEAR,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		SEQUENCE_NO
	)
	VALUES 
	(
		<cfif len(attributes.SPECIAL_HIERARCHY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_HIERARCHY#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_cat#">,
		<cfif isdefined("attributes.IS_LAST_YEAR_CONTROL")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.IS_VIEW_MYHOME")>1<cfelse>0</cfif>,
		<cfif len(attributes.USAGE_YEAR)>#attributes.USAGE_YEAR#<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		<cfif isDefined('attributes.sequence_no') and len(attributes.sequence_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sequence_no#"><cfelse>NULL</cfif>
	)
</cfquery>
<cfif len(attributes.upper_asset_cat_id)>
	<cfquery name="get_1" datasource="#dsn#">
		SELECT MAX(ASSET_CAT_ID) AS MAX_ID FROM SETUP_EMPLOYMENT_ASSET_CAT
	</cfquery>
	<cfquery name="get_2" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = '#attributes.upper_asset_cat_id#'
	</cfquery>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			SETUP_EMPLOYMENT_ASSET_CAT
		SET
			HIERARCHY = #sql_unicode()#'#get_2.HIERARCHY#.#get_1.MAX_ID#',
			UPPER_ASSET_CAT_ID = #attributes.upper_asset_cat_id#
		WHERE
			ASSET_CAT_ID = #get_1.MAX_ID#
	</cfquery>
<cfelse>
	<cfquery name="get_" datasource="#dsn#">
		SELECT MAX(ASSET_CAT_ID) AS MAX_ID FROM SETUP_EMPLOYMENT_ASSET_CAT
	</cfquery>
	
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE
			SETUP_EMPLOYMENT_ASSET_CAT
		SET
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_.MAX_ID#">
		WHERE
			ASSET_CAT_ID = #get_.MAX_ID#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_employment_asset_cat" addtoken="no">
