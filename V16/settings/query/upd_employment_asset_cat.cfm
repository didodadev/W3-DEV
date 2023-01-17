<cfquery name="UPDDRIVERLICENCE" datasource="#dsn#">
	UPDATE 
		SETUP_EMPLOYMENT_ASSET_CAT 
	SET 
		SPECIAL_HIERARCHY = <cfif len(attributes.SPECIAL_HIERARCHY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SPECIAL_HIERARCHY#"><cfelse>NULL</cfif>,
		ASSET_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_cat#">,
		IS_LAST_YEAR_CONTROL = <cfif isdefined("attributes.IS_LAST_YEAR_CONTROL")>1<cfelse>0</cfif>,
		IS_VIEW_MYHOME = <cfif isdefined("attributes.IS_VIEW_MYHOME")>1<cfelse>0</cfif>,
		USAGE_YEAR = <cfif len(attributes.USAGE_YEAR)>#attributes.USAGE_YEAR#<cfelse>NULL</cfif>,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		SEQUENCE_NO = <cfif isDefined('attributes.sequence_no') and len(attributes.sequence_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sequence_no#"><cfelse>NULL</cfif>
	WHERE 
		ASSET_CAT_ID=#attributes.asset_cat_id#
</cfquery>

<cfquery name="get_old" datasource="#dsn#">
	SELECT 
    	ASSET_CAT_ID, 
        ASSET_CAT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        IS_LAST_YEAR_CONTROL, 
        IS_VIEW_MYHOME, 
        HIERARCHY, 
        UPPER_ASSET_CAT_ID, 
        USAGE_YEAR, 
        SPECIAL_HIERARCHY,
		SEQUENCE_NO
    FROM 
    	SETUP_EMPLOYMENT_ASSET_CAT 
    WHERE 
	    ASSET_CAT_ID=#attributes.asset_cat_id#
</cfquery>

<cfif len(attributes.upper_asset_cat_id) and not len(get_old.UPPER_ASSET_CAT_ID)>
	<cfquery name="get_1" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #attributes.upper_asset_cat_id#
	</cfquery>
	<cfquery name="get_alts" datasource="#dsn#">
		SELECT 
            ASSET_CAT_ID, 
            ASSET_CAT, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            IS_LAST_YEAR_CONTROL, 
            IS_VIEW_MYHOME,
            HIERARCHY, 
            UPPER_ASSET_CAT_ID, 
            USAGE_YEAR, 
            SPECIAL_HIERARCHY
        FROM 
        	SETUP_EMPLOYMENT_ASSET_CAT 
        WHERE 
        	HIERARCHY = '#get_old.HIERARCHY#' OR HIERARCHY LIKE '#get_old.HIERARCHY#.%'
	</cfquery>
	<cfoutput query="get_alts">
		<cfset asset_cat_id_ = ASSET_CAT_ID>
		<cfset new_hie_ = get_1.HIERARCHY>
		<cfset new_hie_ = new_hie_ & '.' & HIERARCHY>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				SETUP_EMPLOYMENT_ASSET_CAT
			SET
				<cfif asset_cat_id_ eq attributes.asset_cat_id>
					UPPER_ASSET_CAT_ID = #attributes.upper_asset_cat_id#,
				</cfif>
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">
			WHERE
				ASSET_CAT_ID = #asset_cat_id_#
		</cfquery>
	</cfoutput>
<cfelseif not len(attributes.upper_asset_cat_id) and len(get_old.UPPER_ASSET_CAT_ID)>
	<cfquery name="get_1" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #get_old.upper_asset_cat_id#
	</cfquery>
	<cfquery name="get_alts" datasource="#dsn#">
		SELECT 
            ASSET_CAT_ID, 
            ASSET_CAT, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            IS_LAST_YEAR_CONTROL, 
            IS_VIEW_MYHOME,
            HIERARCHY, 
            UPPER_ASSET_CAT_ID, 
            USAGE_YEAR, 
            SPECIAL_HIERARCHY 
        FROM 
   	    	SETUP_EMPLOYMENT_ASSET_CAT 
        WHERE 
	        HIERARCHY = '#get_old.HIERARCHY#' OR HIERARCHY LIKE '#get_old.HIERARCHY#.%'
	</cfquery>
	<cfoutput query="get_alts">
		<cfset asset_cat_id_ = ASSET_CAT_ID>
		<cfset new_hie_ = replace(HIERARCHY,'#get_1.HIERARCHY#.','','all')>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				SETUP_EMPLOYMENT_ASSET_CAT
			SET
				<cfif asset_cat_id_ eq attributes.asset_cat_id>
					UPPER_ASSET_CAT_ID = NULL,
				</cfif>
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">
			WHERE
				ASSET_CAT_ID = #asset_cat_id_#
		</cfquery>
	</cfoutput>
<cfelseif len(attributes.upper_asset_cat_id) and len(get_old.UPPER_ASSET_CAT_ID) and attributes.upper_asset_cat_id neq get_old.UPPER_ASSET_CAT_ID>
	<cfquery name="get_1" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #get_old.upper_asset_cat_id#
	</cfquery>
	<cfquery name="get_2" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID = #attributes.upper_asset_cat_id#
	</cfquery>
	<cfquery name="get_alts" datasource="#dsn#">
		SELECT 
            ASSET_CAT_ID, 
            ASSET_CAT, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            IS_LAST_YEAR_CONTROL, 
            IS_VIEW_MYHOME,
            HIERARCHY, 
            UPPER_ASSET_CAT_ID, 
            USAGE_YEAR, 
            SPECIAL_HIERARCHY 
        FROM 
        	SETUP_EMPLOYMENT_ASSET_CAT 
        WHERE 
        	HIERARCHY = '#get_old.HIERARCHY#' OR HIERARCHY LIKE '#get_old.HIERARCHY#.%'
	</cfquery>
	<cfoutput query="get_alts">
		<cfset asset_cat_id_ = ASSET_CAT_ID>
		<cfset new_hie_ = replace(HIERARCHY,'#get_1.HIERARCHY#.','#get_2.HIERARCHY#.','all')>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				SETUP_EMPLOYMENT_ASSET_CAT
			SET
				<cfif asset_cat_id_ eq attributes.asset_cat_id>
					UPPER_ASSET_CAT_ID = #attributes.upper_asset_cat_id#,
				</cfif>
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">
			WHERE
				ASSET_CAT_ID = #asset_cat_id_#
		</cfquery>
	</cfoutput>
</cfif>
<script>
	location.href=document.referrer;
</script>
