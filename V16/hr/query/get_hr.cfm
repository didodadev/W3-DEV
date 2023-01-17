<cfif not session.ep.ehesap>
	<cfquery name="my_branches" datasource="#dsn#">
		SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#
	</cfquery>
	<cfif not my_branches.recordcount>
		<script type="text/javascript">alert("<cf_get_lang dictionary_id='56831.Hiçbir Şubeye Yetkiniz Yok! Şube Yetkilerinizi Düzenleyiniz'>!");history.back();</script>
		<cfabort>
	</cfif>
	<cfset my_branch_list = valuelist(my_branches.BRANCH_ID)>
</cfif>
<cfquery name="GET_HR" datasource="#DSN#">
	SELECT 
		E.*,
		EI.TC_IDENTY_NO,
		ED.SEX,
		ED.EMAIL_SPC,
		ED.MOBILCODE_SPC,
		ED.MOBILTEL_SPC,
		ST.TIME_ZONE
	FROM 
		EMPLOYEES E
			LEFT JOIN MY_SETTINGS ST ON E.EMPLOYEE_ID = ST.EMPLOYEE_ID,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #attributes.employee_id#
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
		<cfif isdefined("kontrol_branch") and not session.ep.ehesap>
			AND 
			(
				E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,DEPARTMENT WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#)) OR 
				E.EMPLOYEE_ID NOT IN(SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0 AND IS_MASTER = 1 AND POSITION_STATUS = 1)
			)
			AND 
			<!---giriş-çıkış şube yetkisi kontrolü --->
			(
				E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT) OR 
				E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID IN (#my_branch_list#))
			)
		</cfif>
</cfquery>
