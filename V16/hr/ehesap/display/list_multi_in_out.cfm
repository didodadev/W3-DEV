<cfquery name="get_in_out_other" datasource="#dsn#">
	SELECT 
		EI.EMPLOYEE_ID,
		EI.IN_OUT_ID,
		EI.POSITION_CODE,
		EI.START_DATE,
		EI.FINISH_DATE,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		OUR_COMPANY.NICK_NAME,
		EI.SOCIALSECURITY_NO,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
	FROM
		EMPLOYEES_IN_OUT EI
        LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID,
		BRANCH,
		DEPARTMENT,
		OUR_COMPANY
	WHERE
		EI.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	ORDER BY EI.START_DATE DESC
</cfquery>
<cf_box title="#getLang('','Çalışan Giriş Çıkışları',53542)# : #get_emp_info(attributes.EMPLOYEE_ID,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
				<th><cf_get_lang dictionary_id ='57453.Şube'></th>
				<th><cf_get_lang dictionary_id ='57572.Departman'></th>
				<th><cf_get_lang dictionary_id ='53237.SSK No'></th>
				<th width="75"><cf_get_lang dictionary_id ='57554.Giriş'></th>
				<th width="75"><cf_get_lang dictionary_id ='57431.Çıkış'></th>
				<th width="20"></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_in_out_other.recordcount>
				<cfoutput query="get_in_out_other">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>#NICK_NAME#</td>
					<td>#BRANCH_NAME#</td>
					<td>#DEPARTMENT_HEAD#</td>
					<td>#SOCIALSECURITY_NO#</td>
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
					<td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#IN_OUT_ID#&empName=#UrlEncodedFormat('#EMPLOYEE#')#" target="_blank"><i class="fa fa-money" title="<cf_get_lang dictionary_id='53127.Ücret'>" alt="<cf_get_lang dictionary_id='53127.Ücret'>"></i></a></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row">
					<td colspan="7"><cf_get_lang dictionary_id ='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
