<cfif isdefined("attributes.asset_id")>	
	<cfquery name="ADD_ASSET" datasource="#DSN#" result="MAX_ID">
		INSERT INTO 
			ASSET
			(
			MODULE_NAME,
			MODULE_ID,
			ACTION_SECTION,
			<cfif attributes.action_type eq 0>ACTION_ID<cfelse>ACTION_VALUE</cfif>,
			<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>ACTION_ID,</cfif>
			IS_DPL,
			IS_ACTIVE,
			ASSET_NO,
			ASSET_STAGE,
			ASSETCAT_ID, 
			ASSET_NAME,
			ASSET_FILE_NAME,
			ASSET_FILE_REAL_NAME,
			ASSET_FILE_SERVER_ID,
			ASSET_FILE_SIZE,
			ASSET_DESCRIPTION,
			ASSET_DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			PROPERTY_ID,
			IS_INTERNET,
			IS_SPECIAL,
			SERVER_NAME,
			IS_IMAGE,
			IMAGE_SIZE,
			COMPANY_ID,
			PERIOD_ID,
			RELATED_ASSET_ID,
			EMBEDCODE_URL
			)
			SELECT
			'#attributes.module#',
				#attributes.module_id#,
			'#UCASE(attributes.action_section)#',
			<cfif attributes.action_type eq 0>#attributes.action_id#<cfelse>'#attributes.action_id#'</cfif>,
			<cfif attributes.action_type eq 1 and len(attributes.action_id_2)>#attributes.action_id_2#,</cfif>
				IS_DPL,
				IS_ACTIVE,
				ASSET_NO,
				ASSET_STAGE,
				ASSETCAT_ID,
				ASSET_NAME,		   
				ASSET_FILE_NAME,
				ASSET_FILE_REAL_NAME,
				ASSET_FILE_SERVER_ID,
				ASSET_FILE_SIZE,
				ASSET_DESCRIPTION,
				ASSET_DETAIL,				   
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			PROPERTY_ID,
			IS_INTERNET,
			IS_SPECIAL,
			SERVER_NAME,
			IS_IMAGE,
			IMAGE_SIZE,
			#session.ep.company_id#,
			#session.ep.period_id#,
			#attributes.asset_id#,
			'#attributes.EMBEDCODE_URL#'
			FROM
				ASSET
			WHERE
				ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
	</cfquery>
	<cfquery name="ADD_ASSET_REL" datasource="#DSN#">
		INSERT INTO 
			ASSET_RELATED
			(
			COMPANY_CAT_ID,
			CONSUMER_CAT_ID,
			ALL_INTERNET,
			ALL_CAREER,
			POSITION_CAT_ID,
			USER_GROUP_ID,
			ALL_EMPLOYEE,
			ALL_PEOPLE,
			ASSET_ID,
			DIGITAL_ASSET_GROUP_ID
			)
			SELECT
				COMPANY_CAT_ID,
				CONSUMER_CAT_ID,
				ALL_INTERNET,
				ALL_CAREER,
				POSITION_CAT_ID,
				USER_GROUP_ID,
				ALL_EMPLOYEE,
				ALL_PEOPLE,
				#MAX_ID.IDENTITYCOL# AS ASSET_ID,
				DIGITAL_ASSET_GROUP_ID
			FROM
				ASSET_RELATED
			WHERE 
				ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	
</script>
