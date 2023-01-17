<!---Select ifadeleri düzenlendi.e.a 24.04.2012--->
<cfset position_list = "">
<cfset position_cat_list = "">
<cfset position_mails = "">
<cfquery name="GET_POSTS" datasource="#dsn#">
	SELECT
		POSITION_CAT_ID,
		POSITION_CODE
	FROM 
		G_SERVICE_APPCAT_SUB_POSTS 
	WHERE 
		SERVICE_SUB_CAT_ID = #SERVICE_SUB_CAT_ID#
</cfquery>
<cfloop query="GET_POSTS">				
	<cfif (not listfindnocase(position_list,GET_POSTS.POSITION_CODE,',')) and len(GET_POSTS.POSITION_CODE)>
		<cfset position_list = listappend(position_list,GET_POSTS.POSITION_CODE,',')>
	</cfif>
	
	<cfif not listfindnocase(position_cat_list,GET_POSTS.POSITION_CAT_ID,',') and len(GET_POSTS.POSITION_CAT_ID)>
		<cfset position_cat_list = listappend(position_cat_list,GET_POSTS.POSITION_CAT_ID,',')>
	</cfif>
</cfloop>
<cfif listlen(position_cat_list)>
	<cfquery name="get_position_cat_positions" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
	<cfloop query="get_position_cat_positions">
		<cfif not listfindnocase(position_list,get_position_cat_positions.POSITION_CODE,',') and len(get_position_cat_positions.POSITION_CODE)>
			<cfset position_list = listappend(position_list,get_position_cat_positions.POSITION_CODE,',')>
		</cfif>
	</cfloop>
	<cfquery name="get_position_cats" datasource="#dsn#">
		SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
</cfif>
<cfif listlen(position_list)>
	<cfquery name="get_position_mails" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_EMAIL,POSITION_NAME,EMPLOYEE_NAME,EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS EP,DEPARTMENT D
		WHERE 
			EP.POSITION_CODE IN (#position_list#) AND EP.EMPLOYEE_EMAIL IS NOT NULL AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>
</cfif>
<cf_popup_box title="#getLang('call',124)#">
	<table>
		<tr>
			<td class="formbold" height="30"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
		</tr>
		<tr>
			<td><cfif listlen(position_cat_list)><cfoutput query="get_position_cats">#POSITION_CAT#,</cfoutput></cfif></td>
		</tr>
		<tr>
			<td class="formbold" height="30"><cf_get_lang no='99.Pozisyonlar'></td>
		</tr>
		<tr>
			<td><cfif listlen(position_list)><cfoutput query="get_position_mails">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# (#POSITION_NAME#) - (#EMPLOYEE_EMAIL# )<br/></cfoutput></cfif></td>
		</tr>
	</table>
</cf_popup_box>
