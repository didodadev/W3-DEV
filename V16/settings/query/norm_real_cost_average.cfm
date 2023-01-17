<cfquery name="get_averages" datasource="#dsn#">
	SELECT
		COUNT(EPR.EMPLOYEE_PUANTAJ_ID) AS KISI_SAYISI,
		SUM(TOTAL_SALARY) AS TOPLAM_MAAS,
		SUM(TOTAL_SALARY + (SSK_MATRAH * SSK_ISVEREN_CARPAN / 100) + SSDF_ISVEREN_HISSESI + ISSIZLIK_ISVEREN_HISSESI) AS TOPLAM_MALIYET,
		D.DEPARTMENT_ID
	FROM
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP,
		BRANCH B,
		EMPLOYEES_IN_OUT EI,
		DEPARTMENT D
	WHERE
		<cfif len(attributes.related_company)>
			B.RELATED_COMPANY = '#attributes.related_company#' AND
		</cfif>
		EP.SSK_OFFICE = B.SSK_OFFICE AND
		EP.SSK_OFFICE_NO = B.SSK_NO AND 
		EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND
		EP.SAL_MON = #ATTRIBUTES.SAL_MON# AND
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
		EI.IN_OUT_ID = EPR.IN_OUT_ID AND
		EI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EI.BRANCH_ID = B.BRANCH_ID
	GROUP BY
		D.DEPARTMENT_ID
</cfquery>

<cfoutput query="get_averages">
<cfset yil_ = ATTRIBUTES.SAL_YEAR>
<cfset ay_ = ATTRIBUTES.SAL_MON>
<cfset org_ = DEPARTMENT_ID>
<cfset real_salary_ = TOPLAM_MAAS>
<cfset real_cost_ = TOPLAM_MALIYET>
		<cfquery name="check_ssk" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEE_NORM_POSITIONS_AVERAGE
			WHERE
				NORM_YEAR = #yil_# AND
				NORM_MONTH = #ay_# AND
				DEPARTMENT_ID = #org_#
		</cfquery>
			<cfif check_ssk.recordcount>
				<cfquery name="upd_salary" datasource="#dsn#">
					UPDATE 
						EMPLOYEE_NORM_POSITIONS_AVERAGE
					SET					
						REAL_SALARY	= #real_salary_#,
						REAL_COST = #real_cost_#,
						MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_DATE = #NOW()#,
						UPDATE_EMP = #SESSION.EP.USERID#
					WHERE
						NORM_YEAR = #yil_# AND
						NORM_MONTH = #ay_# AND
						DEPARTMENT_ID = #org_#
				</cfquery>
			<cfelse>
				<cfquery name="add_salary" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_NORM_POSITIONS_AVERAGE
						(
						DEPARTMENT_ID,
						NORM_YEAR,
						NORM_MONTH,
						REAL_SALARY,
						REAL_COST,
						MONEY,
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP
						)
					VALUES
						(
						#org_#,
						#yil_#,
						#ay_#,
						#real_salary_#,
						#real_cost_#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
						'#CGI.REMOTE_ADDR#',
						#NOW()#,
						#SESSION.EP.USERID#
						)
				</cfquery>
			</cfif>
</cfoutput>
<script type="text/javascript">
	alert("Aktarım İşlemi Başarıyla Tamamlandı!");
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_norm_real_cost_average</cfoutput>";
</script>
