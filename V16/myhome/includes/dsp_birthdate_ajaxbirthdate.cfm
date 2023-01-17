<cfsetting showdebugoutput="no">
<cfset my_month=month(now())>
<cfset my_day=day(now())>
<cfset list_day = ''>
<cfset list_month = ''>
<cfset list_day = '#day(now())#'>
<cfset list_month = '#month(now())#'>
<cfloop from = "1" to = "6" index = "LoopCount">
	<cfset list_day = listappend(list_day,'#day(date_add("d",LoopCount,now()))#',',')>
	<cfset list_month = listappend(list_month,'#month(date_add("d",LoopCount,now()))#',',')>
</cfloop>
<cfquery name="get_birthdate" datasource="#dsn#"> 
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		EI.BIRTH_DATE BIRTH_DATE,
		DAY(BIRTH_DATE) BIRTH_DATE_DAY,
		MONTH(BIRTH_DATE) BIRTH_DATE_MONTH,
		CASE WHEN MONTH(BIRTH_DATE) = 1 AND #month(now())# = 12 THEN '0' ELSE '1' END AS RELATED_YEAR,
		EP.POSITION_NAME,
		B.BRANCH_NAME
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI,
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		EMPLOYEES_IN_OUT EIO
	WHERE 
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EI.BIRTH_DATE IS NOT NULL AND
		E.EMPLOYEE_STATUS = 1 AND
		(
		<cfif isdefined("attributes.is_daily_birthday") and attributes.is_daily_birthday eq 1>
			MONTH(BIRTH_DATE) = #my_month# AND DAY(BIRTH_DATE) = #my_day#
		<cfelse>
			<cfloop index = "LoopCount" from = "1" to = "7">
				(MONTH(BIRTH_DATE) = #listgetat(list_month,LoopCount,',')# AND DAY(BIRTH_DATE) = #listgetat(list_day,LoopCount,',')# )<cfif LoopCount neq 7>OR</cfif>
			</cfloop>
		</cfif>
		)AND
		<cfif not (isdefined("attributes.is_all_employee") and attributes.is_all_employee eq 1)>
			(EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE > #now()#) AND
		</cfif>
		EP.IS_MASTER = 1 AND
		E.EMPLOYEE_ID=EP.EMPLOYEE_ID AND
		E.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID=B.BRANCH_ID
	GROUP BY 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		EI.BIRTH_DATE,
		EP.POSITION_NAME,
		B.BRANCH_NAME
	ORDER BY 
		MONTH(BIRTH_DATE),
		DAY(BIRTH_DATE),
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
		B.BRANCH_NAME
</cfquery> 
<cfsavecontent variable="birthdatemessage"><cf_get_lang_main no ='484.Dogum Gunleri'></cfsavecontent>
<div id="_dsp_birthdate_" style="overflow:auto;">
	<cf_ajax_list>
		<cfif get_birthdate.recordcount>
			<tbody>
				<cfoutput query="get_birthdate">
					<tr <cfif birth_date_day eq my_day>style="color:red;"</cfif>>
						<td>
							<a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#EMPLOYEE_ID#','medium','popup_emp_det');">#employee_name# #employee_surname#</a>
						</td>
						<td>#POSITION_NAME#</td>
						<td>#BRANCH_NAME#</td>
						<td>#dateformat(birth_date,'dd')# #listgetat(ay_list(),dateformat(birth_date,'mm'))#</td>
					</tr>
				</cfoutput>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td style="text-align:left;"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</tbody>
		</cfif>
	</cf_ajax_list>
</div>

<!---Dogum günleri için scrool eklendi--->
<cfset div_len = get_birthdate.recordcount*22>
	<cfif div_len gte 110>
		<cfset div_len = 110>
	<cfelse>
		<cfset div_len=0>
	</cfif>
<script type="text/javascript">
	if(<cfoutput>#div_len#</cfoutput> >= 110)
		document.getElementById('_dsp_birthdate_').style.height =<cfoutput>#div_len#</cfoutput>;
</script> 
