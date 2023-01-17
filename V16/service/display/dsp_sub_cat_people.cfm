<cfset position_list = "">
<cfset position_cat_list = "">
<cfset position_mails = "">

<cfquery name="GET_POSTS" datasource="#DSN3#">
	SELECT POSITION_CODE, POSITION_CAT_ID FROM SERVICE_APPCAT_SUB_POSTS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_sub_cat_id#">
</cfquery>

<cfloop query="get_posts">				
	<cfif (not listfindnocase(position_list,get_posts.position_code,',')) and len(get_posts.position_code)>
		<cfset position_list = listappend(position_list,get_posts.position_code,',')>
	</cfif>
	
	<cfif not listfindnocase(position_cat_list,get_posts.position_cat_id,',') and len(get_posts.position_cat_id)>
		<cfset position_cat_list = listappend(position_cat_list,get_posts.position_cat_id,',')>
	</cfif>
</cfloop>

			
<cfif listlen(position_cat_list)>
	<cfquery name="GET_POSITION_CAT_POSITIONS" datasource="#DSN#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
	<cfloop query="get_position_cat_positions">
		<cfif not listfindnocase(position_list,get_position_cat_positions.position_code,',') and len(get_position_cat_positions.position_code)>
			<cfset position_list = listappend(position_list,get_position_cat_positions.position_code,',')>
		</cfif>
	</cfloop>
	<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
		SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
</cfif>

<cfif listlen(position_list)>
	<cfquery name="GET_POSITION_MAILS" datasource="#DSN#">
		SELECT 
			EP.EMPLOYEE_EMAIL,POSITION_NAME,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D
		WHERE 
			EP.POSITION_CODE IN (#position_list#) AND EP.EMPLOYEE_EMAIL IS NOT NULL AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	</cfquery>
</cfif>
<table cellpadding="0" cellspacing="0" border="0" style="width:100%; height:100%">
  	<tr class="color-border">
    	<td style="vertical-align:top">
      		<table cellpadding="2" cellspacing="1" border="0" style=" width:100%;height:100%">
				<tr class="color-list" style="height:35px;">
				  	<td class="headbold">&nbsp;Servis Kategorisi Dağıtım Listesi</td>
				</tr>
				<tr class="color-row">
					<td style="vertical-align:top">
						<br/>
						<table>
							<tr>
								<td class="formbold">Pozisyon Tipleri</td>
							</tr>
							<tr>
								<td><cfif listlen(position_cat_list)><cfoutput query="get_position_cats">#position_cat#,</cfoutput></cfif></td>
							</tr>
							<tr>
								<td class="formbold">Pozisyonlar</td>
							</tr>
							<tr>
								<td><cfif listlen(position_list)><cfoutput query="get_position_mails">#employee_name# #employee_surname# (#position_name#) - (#employee_email# )<br/></cfoutput></cfif></td>
							</tr>
						</table>
					</td>
				</tr>
	 		</table>
		</td>
 	</tr>
</table>



