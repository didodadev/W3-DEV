<!--- <cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID 
	FROM 
		DEPARTMENT, 
		BRANCH,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
	ORDER BY 
		BRANCH.BRANCH_NAME,	
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfinclude template="../query/my_sett.cfm">
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
  <tr height="35" class="color-list">
	  <td class="headbold">                   
		<cfoutput>#session.ep.name# #session.ep.surname# : <cf_get_lang no='16.Çalışma Dönemi'></cfoutput>
	  </td>
  </tr>
  <tr class="color-row">
	<td valign="top">
	  <table>
		<cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=acc_period" method="POST">
			<input type="hidden" name="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
		  <tr>
			<td class="txtboldblue"><cf_get_lang no='16.Çalışma Dönemi'></td>
		  </tr>
		  <tr>
			<td>
				<cfquery name="GET_POS_ID" datasource="#DSN#">
					SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
				</cfquery>
				<input type="hidden" name="position_id" value="<cfoutput>#get_pos_id.position_id#</cfoutput>">
				<cfquery name="PERIODS" datasource="#DSN#">
					SELECT DISTINCT
						SP.* 
					FROM 
						SETUP_PERIOD SP, 
						EMPLOYEE_POSITION_PERIODS EP 
					WHERE 
						EP.PERIOD_ID = SP.PERIOD_ID AND 
						EP.POSITION_ID = #GET_POS_ID.POSITION_ID#
					ORDER BY
						SP.OUR_COMPANY_ID,
						SP.PERIOD_YEAR DESC
				</cfquery>
				<select name="user_period_id" style="width:300px;">
				<cfoutput query="periods">
					<cfquery name="COMPANY_NAME" datasource="#DSN#">
						SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = #periods.our_company_id#
					</cfquery>
					<option value="#period_id#" <cfif session.ep.period_id eq period_id>selected</cfif>>#period#-#company_name.company_name#</option>
				</cfoutput>
				</select>
			</td>
		  </tr>
		  <tr>
			<td class="txtboldblue"><cf_get_lang_main no='41.Şube'></td>
		  </tr>
		  <tr>
			<td>
				<select name="USER_LOCATION" style="width:300px;">
				<cfoutput query="all_departments">
					<option value="#department_id#-#branch_id#" <cfif session.ep.user_location is '#department_id#-#branch_id#'>selected</cfif>>#branch_name# / #department_head#</option>
				</cfoutput>
				</select>
			</td>
		  </tr>
		  <tr>
			<td style="text-align:right;" height="35"><cf_workcube_buttons is_upd='0'> </td>
		  </tr>
		</cfform>
	  </table>
	</td>
  </tr>
</table>
 --->
