<!--- ic 20050827 - burada bu include'da kullanilabilirdi ancak subeyi ve şirket query'de yok eklenmeli...
<cfinclude template="../query/get_position.cfm">
 --->
<cfif isdefined("attributes.employee_id") and len("attributes.employee_id")>
	<cfquery name="get_pos_other" datasource="#dsn#">
		SELECT 
			#dsn#.Get_Dynamic_Language(EP.POSITION_ID,'#session.ep.language#','EMPLOYEE_POSITIONS','POSITION_NAME',NULL,NULL,EP.POSITION_NAME) AS POSITION_NAME,
			EP.POSITION_ID,
			EP.EMPLOYEE_ID,
			EP.POSITION_CODE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			OUR_COMPANY.NICK_NAME
		FROM
			EMPLOYEE_POSITIONS EP,
			BRANCH,
			DEPARTMENT,
			OUR_COMPANY
		WHERE
			EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			DEPARTMENT.DEPARTMENT_ID = EP.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	</cfquery>

	<cfif get_pos_other.recordcount>
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                </tr>
            </thead>
            <cfoutput query="get_pos_other">
				<tbody>
					<tr>
						<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#">#POSITION_NAME#</a></td>
						<td>#NICK_NAME#</td>
						<td>#BRANCH_NAME#</td>
						<td>#DEPARTMENT_HEAD#</td>
					</tr>
				</tbody>
            </cfoutput>
        </cf_flat_list>
	</cfif>
</cfif>
