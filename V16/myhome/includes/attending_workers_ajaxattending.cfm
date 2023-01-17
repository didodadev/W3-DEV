<cfsetting showdebugoutput="no">
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset attributes.week_day = date_add('d',-7,createodbcdatetime(createdate(year(now()),month(now()),day(now()))))>
<cfset in_workers_date = dateformat(attributes.to_day,dateformat_style)>
<cfquery name="get_in_out_branches" datasource="#dsn#">
	SELECT
		B.BRANCH_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		EIO.START_DATE,
		D.DEPARTMENT_HEAD
	FROM
		EMPLOYEES_IN_OUT EIO,
		BRANCH B,
		EMPLOYEES E,
		DEPARTMENT D,
		OUR_COMPANY OC
	WHERE
		<cfif isdefined("attributes.branch_id")>
		EIO.BRANCH_ID = #attributes.branch_id# AND
		</cfif>
		EIO.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND IN_OUT_ID <> EIO.IN_OUT_ID AND FINISH_DATE IS NOT NULL) AND
		EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		EIO.START_DATE >= #attributes.week_day#
</cfquery>
<cfquery name="get_branches_" datasource="#dsn#">
	SELECT
		B.BRANCH_NAME,
		B.BRANCH_ID,
		OC.NICK_NAME
	FROM
		EMPLOYEES_IN_OUT EIO,
		BRANCH B,
		DEPARTMENT D,
		OUR_COMPANY OC
	WHERE
		<cfif isdefined("attributes.branch_id")>
		EIO.BRANCH_ID = #attributes.branch_id# AND
		</cfif>
		EIO.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EIO.EMPLOYEE_ID AND IN_OUT_ID <> EIO.IN_OUT_ID AND FINISH_DATE IS NOT NULL) AND
		EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		EIO.START_DATE >= #attributes.week_day#
	GROUP BY
		B.BRANCH_NAME,
		B.BRANCH_ID,
		OC.NICK_NAME
</cfquery>
<cf_flat_list>
	<cfif get_branches_.recordcount>
		<cfoutput query="get_branches_">
			<tbody>
				<tr>
					<td class="iconL"> <a href="javascript:gizle_goster(list_correspondence#currentrow#_menu#currentrow#);"><i class="fa fa-caret-right"></i></a></td>
					<td width="50%">#nick_name#</td>
					<td>#branch_name#</td>
				</tr>
			</tbody>
				<cfquery name="get_emp_in_out" dbtype="query">
					SELECT
						*
					FROM
						get_in_out_branches
					WHERE
						BRANCH_ID = #get_branches_.BRANCH_ID#
				</cfquery>
				<tr id="list_correspondence#currentrow#_menu#currentrow#" style="display:none;">
				  <td colspan="3">
					  <table>
						<cfloop query="get_emp_in_out">
							<tr>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_show_cv_page&employee_id=#get_emp_in_out.employee_id#','page')" class="tableyazi">#get_emp_in_out.employee_name# #get_emp_in_out.employee_surname#</a></td>
								<td>#get_emp_in_out.department_head#</td>
								<td>#dateformat(get_emp_in_out.start_date,dateformat_style)#</td>
							</tr>
						</cfloop>
					  </table>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tbody>
				<tr>
						<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
				</tr>
			</tbody>
		</cfif>
</cf_flat_list>
