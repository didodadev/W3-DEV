<cfquery name="get_branch_employees" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,	
		BRANCH.ADMIN1_POSITION_CODE,
		BRANCH.ADMIN2_POSITION_CODE,
		SETUP_POSITION_CAT.POSITION_CAT,
		SETUP_TITLE.TITLE,
		ZONE.ZONE_NAME,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		ZONE,
		OUR_COMPANY,
		SETUP_POSITION_CAT,
		SETUP_TITLE
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NOT NULL AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0 AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
		SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
		SETUP_TITLE.TITLE_ID = EMPLOYEE_POSITIONS.TITLE_ID AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID = #attributes.branch_id# AND
		ZONE.ZONE_ID = BRANCH.ZONE_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	ORDER BY 
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_branch_employees.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td class="headbold" height="35"><cfoutput>#get_branch_employees.nick_name#</cfoutput></td>
	</tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  	<tr class="color-border">
    	<td>
      	<table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
			<tr class="color-header" height="22">
				<td colspan="6" class="form-title"><cfoutput>#get_branch_employees.zone_name# / #get_branch_employees.branch_name#</cfoutput></td>
			</tr>
			<tr class="color-row" height="22">
				<td colspan="6" class="txtboldblue"><cf_get_lang dictionary_id='32790.Yöneticiler'> : <cfoutput>#get_emp_info(get_branch_employees.admin1_position_code,1,0)# - #get_emp_info(get_branch_employees.admin2_position_code,1,0)#</cfoutput></td>
			</tr>
			<tr class="color-list" height="22">
				<td></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57576.Çalışan'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57571.Ünvan'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></td>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57572.Departman'></td>		  
			</tr>
	<cfif get_branch_employees.recordcount>    
       <cfoutput query="get_branch_employees">	
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td align="center"><CF_ONLINE id="#employee_id#" zone="ep"></td>
				<td>#position_name#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
				<td>#title#</td>
				<td>#position_cat#</td>
				<td>#department_head#</td>
			</tr>
		</cfoutput>
		<cfelse> 
			<tr class="color-row" height="20">
			  	<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
	  </cfif> 
      	</table>
		</td>
	</tr>  
</table>
