<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MAX(MODULE_NO) AS MODULE_ID FROM WRK_MODULE
</cfquery>

<cfset attributes.level_id = "">
<cfloop from="1" to="#get_module_id.module_id#" index="loop_level">
	<cfif IsDefined("attributes.level_id_#loop_level#")>
    	<cfset attributes.level_id = ListAppend(attributes.level_id,loop_level)>
	</cfif>
</cfloop>
<cfset attributes.level_id = ListSort(ListAppend(attributes.level_id,47),'numeric')><!--- objects yetkisi --->
<cfset attributes.level_id2 = 0>

<cftransaction>
	<cfquery name="ADD_USER_GROUP" datasource="#DSN#" result="getMaxId">
		INSERT INTO 
			USER_GROUP
		(
			IS_DEFAULT,
			USER_GROUP_NAME,			
			USER_GROUP_PERMISSIONS,
			USER_GROUP_PERMISSIONS_EXTRA,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
            IS_BRANCH_AUTHORIZATION,
			REPORT_USER_LEVEL, 
			SENSITIVE_USER_LEVEL,
			DATA_LEVEL
		)
		VALUES
		(
			<cfif isdefined("attributes.is_default") and len(attributes.is_default)>1<cfelse>0</cfif>,
			'#attributes.user_group_name#',
			'#attributes.level_id#',
			<cfif len(attributes.level_id2)>'#attributes.level_id2#'<cfelse>NULL</cfif>,
			 #now()#,
			 #session.ep.userid#,
			'#cgi.remote_addr#',
            <cfif isdefined("attributes.branch") and len(attributes.branch)>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.report_user_level") and len(attributes.report_user_level)>'#attributes.report_user_level#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.sensitivity_label") and len(attributes.sensitivity_label)>'#attributes.sensitivity_label#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.db_authorization") and len(attributes.db_authorization)>'#attributes.db_authorization#'<cfelse>NULL</cfif>
		)
	</cfquery>
    <cfif isdefined("attributes.is_default") and len(attributes.is_default)>
    	<cfquery name="UPD_DEFAULT_INFO" datasource="#DSN#">
        	UPDATE USER_GROUP SET IS_DEFAULT = 0 WHERE USER_GROUP_ID != #getMaxId.IDENTITYCOL#
        </cfquery>
	</cfif>
	<cf_wrk_get_history datasource="#dsn#" source_table="USER_GROUP" target_table="USER_GROUP_HISTORY" record_id= "#getMaxId.IDENTITYCOL#" record_name="USER_GROUP_ID">
</cftransaction>
<cfset attributes.actionId = getMaxId.IDENTITYCOL>

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
		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#replace(serializeJSON(getMenuUserGroup),'//','')#" charset="utf-8">
		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_jelibon_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#getJelibonJSON#" charset="utf-8">
		<cffile action="write" file="#upload_folder#personal_settings#dir_seperator#userGroup_watomic_menu_#LANGUAGE_SHORT#_#attributes.actionId#.json" addnewline="no" output="#getWatomicJSON#" charset="utf-8">
	<cfcatch></cfcatch>
	</cftry>
</cfoutput>
<cfset attributes.spa = 1>
<script type="text/javascript">
	var uName = <cfoutput>'#attributes.user_group_name#'</cfoutput>;
	var controlChar = 0;
	$("div.profile-usermenu ul li").each(function(index,element){
		if(controlChar == 0){
			var val = $(element).find("a").html().trim();
			if(val.localeCompare(uName)>0){
				$(element).before('<li class="user" liid="<cfoutput>#getMaxId.IDENTITYCOL#</cfoutput>"><a onclick="spaPageLoad(\'<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group&amp;spa=1&event=upd&amp;ID=<cfoutput>#getMaxId.IDENTITYCOL#</cfoutput>\',\'userGroup\',\'settings.form_add_user_group\',\'upd\',1,1)" href="javascript://">'+uName+'</a> <span class="badge pull-right">0</span></li>');
				controlChar = 1;
			}
		}
	})
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group";
	$(".login_bg").hide();
</script>
