<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfparam name="attributes.class_id" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.training_sec_id" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="class_ids" default="">
<cfif isDefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id neq 0>
   <cfset GET_CLASS_IDS = cmp.GET_CLASS_IDS_F(training_sec_id:attributes.training_sec_id)>
	<!--- <cfquery name="GET_CLASS_IDS" datasource="#DSN#">
		SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
	</cfquery> --->
	<cfif get_class_ids.recordcount>
		<cfset class_ids = valuelist(get_class_ids.class_id)>
   </cfif>
</cfif>
<cfset GET_CLASS = cmp.GET_CLASS_F(
   class_id:iif(isDefined("attributes.class_id") and len(attributes.class_id),attributes.class_id,""),
   online:iif(isDefined("attributes.online") and len(attributes.online),attributes.online,""),
   keyword:iif(isDefined("attributes.keyword") and len(attributes.keyword),attributes.keyword,""),
   training_sec_id:iif(isdefined("attributes.training_sec_id") and len(attributes.training_sec_id),attributes.training_sec_id,""),
   class_ids:iif(isdefined("class_ids") and listLen(class_ids),class_ids,""),
   date1:iif(isdefined("attributes.date1") and len(attributes.date1),class_ids,"")
)>
<!--- <cfquery name="GET_CLASS" datasource="#DSN#">
	SELECT
	     CLASS_ID,
        CLASS_NAME,
        ONLINE,
        INT_OR_EXT,
        IS_INTERNET,
        IS_ACTIVE,
        TRAINING_ID,
        LANGUAGE,
        TRAINING_STYLE,
        PROCESS_STAGE,
        TRAINING_CAT_ID,
        MAX_PARTICIPATION,
        MAX_SELF_SERVICE,
        TRAINING_SEC_ID,
        CLASS_PLACE,
        CLASS_PLACE_MANAGER,
        CLASS_PLACE_ADDRESS,
        CLASS_TOOLS,
        PROJECT_ID,
        CLASS_TARGET,
        CLASS_ANNOUNCEMENT_DETAIL,
        CLASS_OBJECTIVE,
        VIEW_TO_ALL,
        IS_WIEW_BRANCH,
        IS_WIEW_DEPARTMENT,
        IS_VIEW_COMPANY,
        RECORD_DATE, 
        DATE_NO,
        HOUR_NO,
        CLASS_PLACE_TEL,
        STOCK_ID,
        MODULE_IDS,
        QUIZ_ID,
        START_DATE,
        FINISH_DATE,
        RECORD_EMP,
        UPDATE_EMP,
        UPDATE_DATE 
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
			AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		</cfif>
		<cfif isDefined("attributes.online") and len(attributes.online)>
			AND ONLINE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.online#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR CLASS_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		</cfif>
		<cfif isdefined("attributes.training_sec_id") and isdefined("get_class_ids") and get_class_ids.recordcount>
			AND	CLASS_ID IN (#class_ids#)
		</cfif> 	
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			<cf_date tarih='attributes.date1'>
			AND	START_DATE >= #attributes.date1#
		</cfif>
		<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id neq 0>
		   AND TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
		</cfif>
</cfquery> --->