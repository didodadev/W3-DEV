<cfquery name="list_simular_employees" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
		EMPLOYEE_POSITIONS.IS_VEKALETEN,
		EMPLOYEE_POSITIONS.VEKALETEN_DATE,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.NICK_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.HIERARCHY_DEP_ID,
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		DEPARTMENT.DEPARTMENT_HEAD,
		ZONE.ZONE_NAME
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY,
		ZONE
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.ZONE_ID = ZONE.ZONE_ID
		AND (EMPLOYEE_POSITIONS.EMPLOYEE_ID=0 OR EMPLOYEE_POSITIONS.EMPLOYEE_ID IS NULL)
		<cfif len(ATTRIBUTES.POSITION_NAME)>
			AND EMPLOYEE_POSITIONS.POSITION_NAME='#ATTRIBUTES.POSITION_NAME#'
		</cfif>
	 	AND EMPLOYEE_POSITIONS.POSITION_CAT_ID=#ATTRIBUTES.POSITION_CAT_ID#
	  	AND EMPLOYEE_POSITIONS.TITLE_ID=#ATTRIBUTES.TITLE_ID#
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=#ATTRIBUTES.DEPARTMENT_ID#
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
</cfquery>
<cfif list_simular_employees.recordcount>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56712.Benzer Boş Pozisyonlar"></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cf_medium_list>
	<thead>
    <tr>
        <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
        <th width="100"><cf_get_lang dictionary_id='57992.Bölge'></th>
        <th width="70"><cf_get_lang dictionary_id='57574.Sirket'></th>
        <th width="70"><cf_get_lang dictionary_id='57453.Sube'></th>
        <th><cf_get_lang dictionary_id='57572.Departman'></th>
        <th width="160"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
        <th>&nbsp;</th>
    </tr>
    </thead>
    <tbody>
		<cfoutput query="list_simular_employees">
        <tr>
            <td>#currentrow#</td>
            <td>#ZONE_NAME#</td>
            <td>#NICK_NAME#</td>
            <td>#BRANCH_NAME#</td>
            <td>#DEPARTMENT_HEAD#</td>
            <td><a href="##" onclick="last_control();" class="tableyazi">#POSITION_NAME#&nbsp;<cfif is_vekaleten eq 1>(V.)</cfif></a></td>
            <td align="center" width="20"><cfif is_vekaleten eq 1><img src="/images/bugpro.gif" title="<cf_get_lang no ='1626.Vekalet Tarihi'> : #dateformat(vekaleten_date,dateformat_style)#"></cfif></td>
        </tr>
        </cfoutput>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="8" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value=" Varolan Kayıtları Gözardı Et" onClick="submit_form();"></td>
        </tr>
    </tfoot>
</cf_medium_list>
</cfif>
<script type="text/javascript">
	<cfif not list_simular_employees.recordcount>
	opener.add_pos.submit();
	window.close();
	</cfif>
	function submit_form()
	{
	opener.add_pos.submit();
	window.close();
	}
	function last_control()
	{
		
		opener.location.href='<cfoutput>#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#list_simular_employees.position_id#</cfoutput>';
		window.close();
	}

</script>
