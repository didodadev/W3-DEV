<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>

<cfquery name="get_branch_dept_positions_1" datasource="#dsn#">
	SELECT DISTINCT
		EP.*,
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD,
		EP.POSITION_CAT_ID,
		EP.POSITION_ID,
		EP.EMPLOYEE_ID
	FROM 
		DEPARTMENT D,
		EMPLOYEE_POSITIONS_HISTORY EP,
		BRANCH B 
	WHERE		
		EP.POSITION_CAT_ID = #position_cat_id# AND
		EP.EMPLOYEE_ID IN (SELECT EIO.EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND D.BRANCH_ID = EIO.BRANCH_ID AND (EIO.FINISH_DATE IS NULL OR (EIO.FINISH_DATE >= #puantaj_start_# AND EIO.FINISH_DATE >= #puantaj_finish_#) )) AND
		EP.EMPLOYEE_ID > 0 AND
		EP.POSITION_STATUS = 1 AND
		D.DEPARTMENT_STATUS = 1 AND
		D.IS_STORE <> 1
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		<cfif isdefined("attributes.RELATED_COMPANY")>
		B.RELATED_COMPANY = '#attributes.RELATED_COMPANY#' AND
		<cfelse>
		B.BRANCH_ID = #attributes.BRANCH_ID# AND
		</cfif>
		(
		(EP.FINISH_DATE >= #puantaj_finish_#)
		OR
		EP.FINISH_DATE IS NULL
		OR
		EP.FINISH_DATE = ''
		)
	ORDER BY
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD,
		EP.EMPLOYEE_NAME
</cfquery>

<table width="98%" align="center">
	<tr>
		<td height="35" class="headbold"><cf_get_lang dictionary_id="35262.Norm Kadro Çalışmaları"></td>
	</tr>
</table>

<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
	<tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang dictionary_id="57453.Şube"></td>
		<td class="form-title"><cf_get_lang dictionary_id="35449.Departman"></td>
		<td class="form-title"><cf_get_lang dictionary_id="58497.Pozisyon"></td>
		<td class="form-title"><cf_get_lang dictionary_id="30368.Çalışan"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57501.Başlangıç"></td>
		<td class="form-title"><cf_get_lang dictionary_id="57502.Bitiş"></td>
		<td class="form-title"><cf_get_lang dictionary_id="59004.Pozisyon Tip"><cf_get_lang dictionary_id="58527.ID"></td>
		<td class="form-title"><cf_get_lang dictionary_id="58497.Pozisyon"><cf_get_lang dictionary_id="58527.ID"></td>
		<td class="form-title"><cf_get_lang dictionary_id="30368.Çalışan"><cf_get_lang dictionary_id="58527.ID"></td>
	</tr>
	<cfoutput query="get_branch_dept_positions_1">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td>#BRANCH_NAME#</td>
		<td>#department_head#</td>
		<td>#position_name#</td>
		<td>#employee_name# #employee_surname#</td>
		<td>#dateformat(start_date,dateformat_style)#</td>
		<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
		<td>#POSITION_CAT_ID#</td>
		<td>#position_id#</td>
		<td>#employee_id#</td>
	</tr>
	</cfoutput>
</table>
<br/>
