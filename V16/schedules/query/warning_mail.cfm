<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfset warning_date = dateformat(attributes.to_day,dateformat_style)>

<cfquery name="get_email_warning" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		PAGE_WARNINGS AS WARNINGS
	WHERE
		IS_ACTIVE = 1
		AND EMAIL_WARNING_DATE >= #attributes.TO_DAY# AND EMAIL_WARNING_DATE < #DATEADD('D',1,attributes.TO_DAY)#
		AND IS_CAUTION_ACTION = 1
	ORDER BY POSITION_CODE
</cfquery>

<cfif get_email_warning.recordcount>
	<cfset position_list = ''>
	<cfset position_list = valuelist(get_email_warning.position_code,',')>
	<!--- uyarılacak kişiye mail gidecek*************** --->
	<cfloop query="get_email_warning">
		<cfquery name="get_employee_list" datasource="#DSN#">
		   SELECT 
			 EMP.EMPLOYEE_EMAIL,
			 EMP.EMPLOYEE_SURNAME,
			 EMP.EMPLOYEE_ID,
			 EMP.EMPLOYEE_NAME
		  FROM 
			 EMPLOYEE_POSITIONS EMPO,
			 EMPLOYEES EMP
		  WHERE 
			 EMPO.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
			 POSITION_CODE = #position_code#
		</cfquery>
		<cfif len(get_employee_list.employee_email)>
			<cfmail to="#get_employee_list.EMPLOYEE_EMAIL#" from="#ListLast(Server_Detail)#<#ListFirst(Server_Detail)#>" subject="Deneme Süresi"type="HTML">
				Sayın #get_employee_list.EMPLOYEE_NAME# #get_employee_list.EMPLOYEE_SURNAME#,
				<br/><br/>
				#warning_head#<br/><br/>
				Detayları görmek için aşağıdaki linke tıklayınız.<br/><br/>
				<a href="#user_domain##url_link#">Deneme Süresi</a><br/><br/>
			</cfmail>
		<cfquery name="upd_active" datasource="#dsn#">
			UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = #w_id#
		</cfquery>
		</cfif>
	</cfloop>
	<!--- uyarılacak kişiye mail gidecek*************** --->
</cfif>


