<cfinclude template="../query/get_class.cfm">
 <cfquery name="get_emp_att" datasource="#dsn#">
	SELECT 
		EMP_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME 
	FROM 
		TRAINING_CLASS_ATTENDER,
		EMPLOYEES,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE 
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
		C.COMP_ID=BRANCH.COMPANY_ID AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID AND
		EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                            ) AND
		CLASS_ID=#attributes.CLASS_ID# AND 
		EMP_ID IS NOT NULL AND
		PAR_ID IS NULL AND 
		CON_ID IS NULL
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME 
</cfquery>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
	<cfform name="add_class_attender_eval" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_training_detail">
		<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
		<tr class="color-list">
			<td height="35" class="headbold">
				<cf_get_lang no='185.Eğitim Değerlendirme Formu'>
			</td>
		</tr>
		<cfif len(attributes.QUIZ_ID)>
			<cfinclude template="../display/performance_quiz_2.cfm">
		<cfelse>
			<tr class="color-row">
				<td>&nbsp;</td>
			</tr>
		</cfif>
		<tr class="color-row">
			<td height="30" valign="top" style="text-align:right;"><cf_workcube_buttons is_upd='0'>&nbsp;&nbsp;&nbsp;</td>
		</tr>
	</cfform>
</table>
