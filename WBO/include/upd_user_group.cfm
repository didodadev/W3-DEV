<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MAX(MODULE_NO) AS MODULE_ID FROM WRK_MODULE
</cfquery>

<cfset attributes.level_id = "">
<cfset attributes.powerUser = "">
<cfset attributes.report_user_level = "">
<cfloop from="1" to="#get_module_id.module_id#" index="loop_level">
	<cfif IsDefined("attributes.level_id_#loop_level#")>
    	<cfset attributes.level_id = ListAppend(attributes.level_id,loop_level)>
	</cfif>
	<cfif IsDefined("attributes.powerUser_#loop_level#")>
    	<cfset attributes.powerUser = ListAppend(attributes.powerUser,loop_level)>
	</cfif>
	<cfif IsDefined("attributes.report_user_level#loop_level#")>
    	<cfset attributes.report_user_level = ListAppend(attributes.report_user_level,loop_level)>
	</cfif>
</cfloop>
<cfset attributes.level_id = ListSort(ListAppend(attributes.level_id,47),'numeric')><!--- objects yetkisi --->
<cfset attributes.powerUser = ListSort(ListAppend(attributes.powerUser,47),'numeric')><!--- objects yetkisi --->

<cfset attributes.level_id2 = 0>
<cfquery name="UPD_USER_GROUP" datasource="#DSN#">
	UPDATE 
		USER_GROUP
	SET	
		USER_GROUP_NAME = '#attributes.user_group_name#',
		USER_GROUP_PERMISSIONS = '#attributes.level_id#',
		USER_GROUP_PERMISSIONS_EXTRA = <cfif len(attributes.level_id2)>'#attributes.level_id2#'<cfelse>NULL</cfif>,
		IS_DEFAULT = <cfif isdefined("attributes.is_default") and len(attributes.is_default)>1<cfelse>0</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
	    UPDATE_IP = '#cgi.remote_addr#',
        IS_BRANCH_AUTHORIZATION = <cfif isdefined("attributes.branch") and len(attributes.branch)>1<cfelse>0</cfif>,
        POWERUSER = '#attributes.powerUser#',
		WRK_MENU = <cfif isdefined("attributes.wrk_menu") and len(attributes.wrk_menu)>'#attributes.wrk_menu#'<cfelse>NULL</cfif>,
		REPORT_USER_LEVEL = <cfif isdefined("attributes.report_user_level") and len(attributes.report_user_level)>'#attributes.report_user_level#'<cfelse>NULL</cfif>,
		SENSITIVE_USER_LEVEL = <cfif isdefined("attributes.sensitivity_label") and len(attributes.sensitivity_label)>'#attributes.sensitivity_label#'<cfelse>NULL</cfif>,
		DATA_LEVEL = <cfif isdefined("attributes.db_authorization") and len(attributes.db_authorization)>'#attributes.db_authorization#'<cfelse>NULL</cfif>
	WHERE
		USER_GROUP_ID = #user_group_id#
</cfquery>
<cf_wrk_get_history datasource="#dsn#" source_table="USER_GROUP" target_table="USER_GROUP_HISTORY" record_id= "#user_group_id#" record_name="USER_GROUP_ID">
<cfif isdefined("attributes.is_default") and len(attributes.is_default)>
    <cfquery name="UPD_DEFAULT_INFO" datasource="#DSN#">
        UPDATE USER_GROUP SET IS_DEFAULT = 0 WHERE USER_GROUP_ID != #user_group_id#
    </cfquery>
</cfif>
<cfset allData = ''>
<cfset allData = listAppend(allData,attributes.nListObject,',')>
<cfset allData = listAppend(allData,attributes.nAddObject,',')>
<cfset allData = listAppend(allData,attributes.nUpdObject,',')>
<cfset allData = listAppend(allData,attributes.nDelObject,',')>
<cfset allData = listDeleteDuplicates(allData,',')>

<cfquery name="DEL_OBJECT" datasource="#dsn#">
    DELETE FROM USER_GROUP_OBJECT WHERE USER_GROUP_ID = #attributes.user_group_id#
</cfquery>
<cfloop index="aaa" from="1" to="#listlen(allData,',')#">
	<cfif listFindNoCase(attributes.level_id,listLast(listgetat(allData,aaa,','),'_'),',')>
		<cfquery name="get_names" datasource="#dsn#">
			SELECT FULL_FUSEACTION FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID = #Replace(listgetat(allData,aaa,','),'_'&listLast(listgetat(allData,aaa,','),'_'),'')#
		</cfquery>
        <cfquery name="ADD_OBJECT" datasource="#dsn#">
            INSERT INTO USER_GROUP_OBJECT
            (
                USER_GROUP_ID,
                OBJECT_NAME,
                MODULE_NO,
                LIST_OBJECT,
                ADD_OBJECT,
                UPDATE_OBJECT,
                DELETE_OBJECT,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
            )
            VALUES
            (
                #attributes.user_group_id#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_names.FULL_FUSEACTION#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(listgetat(allData,aaa,','),'_')#">,
                <cfif listFindNoCase(attributes.nListObject,listgetat(allData,aaa,','),',')>1<cfelse>0</cfif>,
                <cfif listFindNoCase(attributes.nAddObject,listgetat(allData,aaa,','),',')>1<cfelse>0</cfif>,
                <cfif listFindNoCase(attributes.nUpdObject,listgetat(allData,aaa,','),',')>1<cfelse>0</cfif>,
				<cfif listFindNoCase(attributes.nDelObject,listgetat(allData,aaa,','),',')>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    </cfif>
</cfloop>
<cf_wrk_get_history datasource="#dsn#" source_table="USER_GROUP_OBJECT" target_table="USER_GROUP_OBJECT_HISTORY" record_id= "#user_group_id#" record_name="USER_GROUP_ID">
<cfquery name="DEL_OBJECT_HIST" datasource="#dsn#">
	DELETE t1 
	FROM USER_GROUP_OBJECT_HISTORY t1 
	INNER JOIN USER_GROUP_OBJECT_HISTORY t2 ON t1.USER_GROUP_OBJECT_HIST_ID < t2.USER_GROUP_OBJECT_HIST_ID 
	WHERE	 
	t1.USER_GROUP_ID = t2.USER_GROUP_ID 
	AND t1.OBJECT_NAME = t2.OBJECT_NAME 
	AND t1.LIST_OBJECT = t2.LIST_OBJECT 
	AND t1.ADD_OBJECT = t2.ADD_OBJECT 
	AND t1.UPDATE_OBJECT = t2.UPDATE_OBJECT 
	AND t1.DELETE_OBJECT = t2.DELETE_OBJECT 
	AND t1.RECORD_EMP = t2.RECORD_EMP
</cfquery>	
<cfquery name="DEL_SESSIONS" datasource="#dsn#">
	DELETE FROM 
    	WRK_SESSION 
	WHERE 
    	USERID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE USER_GROUP_ID = #attributes.user_group_id#)    
</cfquery>
<cfset attributes.actionId = attributes.id>
<cfquery name="GET_USER_GROUP" datasource="#dsn#">
	SELECT
    	USER_GROUP_ID
	FROM
    	EMPLOYEE_POSITIONS
	WHERE
    	EMPLOYEE_ID = #session.ep.userid#
        AND USER_GROUP_ID = #attributes.user_group_id#
</cfquery>
<cfset menuObject = createObject("component", "WMO.login")>

<cfquery name="GET_LANGS" datasource="#dsn#">
	SELECT
    	LANGUAGE_SHORT
	FROM
    	SETUP_LANGUAGE
</cfquery>

<cfoutput query="GET_LANGS">

	<cfset getMenuUserGroup = menuObject.getMenuUserGroup('#LANGUAGE_SHORT#','#attributes.actionId#','#dsn#',0)/>
	<cfset getJelibonJSON = menuObject.getJeliMenuUserGroup('#LANGUAGE_SHORT#','#attributes.actionId#','#dsn#',1)/>
	<cfset getWatomicJSON = menuObject.getJeliMenuUserGroup('#LANGUAGE_SHORT#','#attributes.actionId#','#dsn#',2)/>

	<cftry>
		<cfif FileExists("#upload_folder#personal_settings#dir_seperator#userGroup_#LANGUAGE_SHORT#_#attributes.actionId#.json")>
			<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator#userGroup_#LANGUAGE_SHORT#_#attributes.actionId#.json">
		</cfif>
		<cfif FileExists("#upload_folder#personal_settings#dir_seperator#userGroup_jelibon_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json")>
			<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator#userGroup_jelibon_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json">
		</cfif>
		<cfif FileExists("#upload_folder#personal_settings#dir_seperator#userGroup_watomic_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json")>
			<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator#userGroup_watomic_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json">
		</cfif>

		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#replace(serializeJSON(getMenuUserGroup),'//','')#" charset="utf-8">
		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_jelibon_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#getJelibonJSON#" charset="utf-8">
		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_watomic_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#getWatomicJSON#" charset="utf-8">
	<cfcatch></cfcatch>
	</cftry>

</cfoutput>

<cfif GET_USER_GROUP.recordcount>
	<script type="text/javascript">
        window.location.href = '<cfoutput>#request.self#?fuseaction=myhome.welcome</cfoutput>';
    </script>
<cfelse>
	<cfset attributes.spa = 1>
    <script type="text/javascript">
		$("li.user").each(function(index,element){
			if($(element).attr('liId') == <cfoutput>#user_group_id#</cfoutput>){
				$(element).find('a').html(<cfoutput>'#attributes.user_group_name#'</cfoutput>);
			}
		})
		window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group";
    </script>
</cfif>