<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH <cfif not session.ep.ehesap>WHERE BRANCH_ID IN (#emp_branch_list#)</cfif> ORDER BY BRANCH_NAME
</cfquery>

<cfquery name="get_all_mails" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		EP.PUANTAJ_ID,
		EP.SAL_MON,
		EP.SAL_YEAR,
		B.BRANCH_FULLNAME,
		B.BRANCH_ID,
		EP.SSK_OFFICE_NO,
		EP.SSK_OFFICE
	FROM
		EMPLOYEES E,
		EMPLOYEES_PUANTAJ EP,
		EMPLOYEES_PUANTAJ_ROWS EPR,
		BRANCH B
	WHERE
		(
            EPR.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_PUANTAJ_MAILS WHERE EMPLOYEE_ID = EPR.EMPLOYEE_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON = #attributes.sal_mon#) OR
            EPR.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_PUANTAJ_MAILS WHERE EMPLOYEE_ID = EPR.EMPLOYEE_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON = #attributes.sal_mon# AND FIRST_READ_DATE IS NULL)
		)
		AND
		<cfif isdefined("attributes.employee_id")>
			E.EMPLOYEE_ID = #attributes.employee_id# AND
		</cfif>
		EP.SAL_MON = #attributes.sal_mon# AND
		EP.SAL_YEAR = #attributes.sal_year# AND
		EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
		EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		<cfif len(attributes.branch_id)>
			B.BRANCH_ID = #attributes.branch_id# AND
		<cfelseif not session.ep.ehesap>
			B.BRANCH_ID IN (#emp_branch_list#) AND
		<cfelse>
			B.BRANCH_ID IS NOT NULL AND
		</cfif>
		B.SSK_NO = EP.SSK_OFFICE_NO AND
		B.SSK_OFFICE = EP.SSK_OFFICE
	ORDER BY 
		B.BRANCH_FULLNAME,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>

<cfif not get_all_mails.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1808.Puantaj Kaydı Bulunamadı ve/veya Geçerli Hiç Bir Mail Adresi Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
<cfelse>

<cfset branch_list = listsort(listdeleteduplicates(valuelist(get_all_mails.branch_id,',')),'numeric','ASC',',')>

<cfquery name="get_mail_branches" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_NAME
</cfquery>

<cfoutput query="get_mail_branches">
	<cfquery name="get_old_mails" datasource="#dsn#" maxrows="1">
		SELECT 
			ROW_ID 
		FROM 
			EMPLOYEES_PUANTAJ_MAILS 
		WHERE 
			BRANCH_ID = #BRANCH_ID# AND 
			SAL_MON = #attributes.sal_mon# AND 
			SAL_YEAR = #attributes.sal_year#
	</cfquery>
	
	<cfif get_old_mails.recordcount>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				EMPLOYEES_PUANTAJ_MAILS 
			SET 
				LAST_MAIL_DATE = #NOW()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				ROW_ID = #get_old_mails.ROW_ID#
		</cfquery>
	<cfelse>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_PUANTAJ_MAILS 
				(
				SAL_MON,
				SAL_YEAR,
				BRANCH_ID,
				SSK_OFFICE_NO,
				SSK_OFFICE,
				FIRST_MAIL_DATE,
				RECORD_EMP
				)
				VALUES
				(
				#attributes.sal_mon#,
				#attributes.sal_year#,
				#BRANCH_ID#,
				'#SSK_NO#',
				'#SSK_OFFICE#',
				#now()#,
				#session.ep.userid#		
				)
		</cfquery>
	</cfif>
</cfoutput>

<cfif len(attributes.message_type)>
	<cfquery name="get_mail_warnings" datasource="#dsn#">
		SELECT 
			DETAIL 
		FROM 
			SETUP_MAIL_WARNING
		WHERE
			MAIL_CAT_ID = #attributes.message_type#
	</cfquery>
</cfif>


<cfsavecontent variable="message"><cfoutput>#get_all_mails.SAL_YEAR# #listgetat(ay_list(),get_all_mails.SAL_MON)#</cfoutput> Ay Bordrosu</cfsavecontent>
<cfloop query="get_all_mails">
	<cfif len(EMPLOYEE_EMAIL)>
		<cfquery name="get_old_mail_emp" datasource="#dsn#">
			SELECT 
				ROW_ID 
			FROM 
				EMPLOYEES_PUANTAJ_MAILS 
			WHERE 
				EMPLOYEE_ID = #EMPLOYEE_ID# AND
				BRANCH_ID = #branch_id# AND 
				SAL_MON = #attributes.sal_mon# AND 
				SAL_YEAR = #attributes.sal_year#
		</cfquery>
		
		<cfif get_old_mail_emp.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_MAILS 
				SET 
					LAST_MAIL_DATE = #NOW()#,
					UPDATE_EMP = #session.ep.userid#
				WHERE 
					ROW_ID = #get_old_mail_emp.ROW_ID#
			</cfquery>
		<cfelse>
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_PUANTAJ_MAILS 
					(
					EMPLOYEE_ID,
					SAL_MON,
					SAL_YEAR,
					BRANCH_ID,
					SSK_OFFICE_NO,
					SSK_OFFICE,
					FIRST_MAIL_DATE,
					RECORD_EMP
					)
					VALUES
					(
					#EMPLOYEE_ID#,
					#attributes.sal_mon#,
					#attributes.sal_year#,
					#BRANCH_ID#,
					'#SSK_OFFICE_NO#',
					'#SSK_OFFICE#',
					#now()#,
					#session.ep.userid#		
					)
			</cfquery>
		</cfif>
	
		<cfmail to="#EMPLOYEE_EMAIL#"
			from="#session.ep.company#<#session.ep.company_email#>"
			subject="#message#" type="HTML">
			Sayın #employee_name# #employee_surname#,
			<br/><br/>
			#SAL_YEAR# #listgetat(ay_list(),SAL_MON)# Ayı Bordronuza Erişmek İçin Aşağıdaki Linke Tıklayınız...<br/><br/>
			<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_bordro&is_submit=1&sal_mon=#SAL_MON#&sal_year=#SAL_YEAR#" target="_blank">#SAL_YEAR# #listgetat(ay_list(),SAL_MON)# Ayı Bordro</a> <br/><br/>
			
			<cfif len(attributes.message_type)>
				#get_mail_warnings.DETAIL#
			<cfelse>
				Lütfen Bordronuzu Kontrol Ediniz!...
			</cfif>
				<br/><br/>
			Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Direktörlüğüne Başvurunuz.<br/><br/>
			#BRANCH_FULLNAME#		
		</cfmail>
	</cfif>
</cfloop>
<script type="text/javascript">
	alert("<cf_get_lang no ='1809.Mailler Başarı İle Gönderildi'>!");
	window.close();
</script>
</cfif>
