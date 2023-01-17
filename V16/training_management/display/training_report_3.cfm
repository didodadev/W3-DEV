<!--- eğitim grubu katilimcilari listelenecek... --->
<cfset attributes.PARTNER_IDS="">
<cfset attributes.EMPLOYEE_IDS="">
<cfset attributes.consumer_ids="">
<cfset attributes.group_ids="">
<cfloop list="#evaluate("att_list")#" index="i" delimiters=",">
  <cfif i contains "par">
	<cfset attributes.PARTNER_IDS = LISTAPPEND(attributes.PARTNER_IDS,LISTGETAT(I,2,"-"))>
  </cfif>
  <cfif i contains "emp">
	<cfset attributes.EMPLOYEE_IDS = LISTAPPEND(attributes.EMPLOYEE_IDS,LISTGETAT(I,2,"-"))>
  </cfif>
  <cfif i contains "con">
	<cfset attributes.consumer_ids = LISTAPPEND(attributes.consumer_ids,LISTGETAT(I,2,"-"))>
  </cfif>
  <cfif i contains "grp">
	<cfset attributes.group_ids = LISTAPPEND(attributes.group_ids,LISTGETAT(I,2,"-"))>
  </cfif>
</cfloop>
<cfinclude template="../query/get_class_report_attenders.cfm">
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td></tr>--->
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
 <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  <cfelse>
   <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang_main no='178.Katılımcılar'></font></td>
   </tr> 
  </cfif>
  
</table>
<table width="99%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	<tr height="22" class="formbold">
	<td><cf_get_lang_main no='158.Ad Soyad'></td>
	<td><cf_get_lang_main no='162.Şirket'></td>
	<td width="100"><cf_get_lang_main no='160.Departman'></td>
	<td width="100"><cf_get_lang_main no='1085.Pozisyon'></td>
	</tr>
	<cfif isdefined("get_class_attender_emps") >
		  <cfoutput query="get_class_attender_emps">
		  <tr height="20">
		  <td>#AD# #SOYAD#</td>
		  <td>#NICK_NAME#</td>
		  <td>#DEPARTMAN#</td>
		  <td>#POSITION#</td>
		  </tr>
		  </cfoutput>
	 </cfif> 
		<cfset department_list=''>
		<cfset department_cons_list=''>
		<cfif get_class_attender_pars.recordcount>
			<cfoutput query="get_class_attender_pars">
				<cfif len(department) and not listFindnocase(department_list,department)>
					<cfset department_list = listappend(department_list,department)>
				</cfif>
			</cfoutput>
			<cfif listlen(department_list)>
				<cfset department_list=listsort(department_list,"numeric","ASC",",")>
				<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
					SELECT
						*
					FROM
						SETUP_PARTNER_DEPARTMENT SPD
					WHERE
						 SPD.PARTNER_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#department_list#">)	 
				</cfquery>
			</cfif>
		</cfif>
		<cfif get_class_attender_cons.recordcount>
			<cfoutput query="get_class_attender_cons">
				<cfif len(department) and not listFindnocase(department_cons_list,department)>
					<cfset department_cons_list = listappend(department_cons_list,department)>
				</cfif>
			</cfoutput>
			<cfif listlen(department_cons_list)>
			<cfset department_cons_list=listsort(department_cons_list,"numeric","ASC",",")>
				<cfquery name="GET_PARTNER_DEPARTMENTS_CONS" datasource="#DSN#">
					SELECT
						*
					FROM
						SETUP_PARTNER_DEPARTMENT
					WHERE
						PARTNER_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#department_cons_list#">)	 
				</cfquery>
			</cfif>
		</cfif>
	 <cfif isdefined("get_class_attender_pars")>
		  <cfoutput query="get_class_attender_pars">
		  <tr height="20">
		  <td>#AD# #SOYAD#</td>
		  <td>#NICK_NAME#</td>
		  <td><cfif listlen(department_list)>#GET_PARTNER_DEPARTMENTS.PARTNER_DEPARTMENT[listfind(department_list,DEPARTMENT,',')]#&nbsp;<cfelse>&nbsp;</cfif></td>
		  <td>#POSITION#&nbsp;</td>
		  </tr>
		  </cfoutput> 
	 </cfif>  
	<cfif isdefined("get_class_attender_cons")> 
		  <cfoutput query="get_class_attender_cons">
		  <tr height="20">
		  <td>#AD# #SOYAD#&nbsp;</td>  
		  <td>#NICK_NAME#&nbsp;</td>
		  <td><cfif listlen(department_cons_list)>#GET_PARTNER_DEPARTMENTS_CONS.PARTNER_DEPARTMENT[listfind(department_cons_list,DEPARTMENT,',')]#&nbsp;<cfelse>&nbsp;</cfif></td>
		  <td>#POSITION#&nbsp;</td>
		  </tr>				  
		  </cfoutput>
	</cfif>
	<cfif isdefined("get_class_attender_grps")>
		 <cfoutput query="get_class_attender_grps">
		 <tr height="20">
		 <td colspan="4">#group_name# (<cf_get_lang no='1.Grup'>)</td>
		 <td>&nbsp;</td>
		 <td>&nbsp;</td>
		 <td>&nbsp;</td>
		 </tr>				 
		 </cfoutput>
	</cfif>
</table>
</td>
</tr>
<tr>
<td>
<cfif isdefined("attributes.excused1")>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='99.Mazeretliler'></font></td>
  </tr>
</table>
<table width="99%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	<tr height="22" class="formbold">
		<td><cf_get_lang_main no='158.Ad Soyad'></td>
		<td width="100">Şirket</td>
		<td width="100"><cf_get_lang_main no='160.Departman'></td>
		<td width="100"><cf_get_lang_main no='1085.Pozisyon'></td>
	</tr>
	<cfquery name="GET_EMP_NAME" datasource="#DSN#">
		SELECT 
			TCA.START_DATE, 
			TCA.FINISH_DATE, 
			TCADT.EMP_ID,	
			TCADT.CON_ID,	
			TCADT.PAR_ID,	
			EMPLOYEES.EMPLOYEE_NAME AS AD,
			EMPLOYEES.EMPLOYEE_SURNAME AS SOYAD,
			<!---TCADT.EXCUSE,
			TCADT.EXCUSE_PAR,
			TCADT.EXCUSE_CON,
			--->
			TCADT.IS_EXCUSE_MAIN,
			TCADT.CON_ID,
			TCADT.EMP_ID,
			TCADT.PAR_ID,
			TCADT.CLASS_ATTENDANCE_ID
		FROM 
			TRAINING_CLASS_ATTENDANCE AS TCA, 
			TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
			EMPLOYEES
		WHERE 
			TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
			EMPLOYEES.EMPLOYEE_ID=TCADT.EMP_ID AND 
			<!---(TCADT.IS_EXCUSE = 1 OR TCADT.IS_EXCUSE_PAR = 1 OR TCADT.IS_EXCUSE_CON = 1) AND --->
			TCADT.IS_EXCUSE_MAIN = 1 AND
			TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
			TCADT.IS_TRAINER = 0
	</cfquery>
	<cfquery name="GET_PARTNER_NAME" datasource="#DSN#">	
		SELECT
			TCA.START_DATE, 
			TCA.FINISH_DATE, 
			TCADT.EMP_ID,	
			TCADT.CON_ID,	
			TCADT.PAR_ID,	
			COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
			COMPANY_PARTNER.TITLE AS POSITION,
			COMPANY_PARTNER.DEPARTMENT, 	
			COMPANY.NICKNAME AS NICK_NAME,
			<!---TCADT.EXCUSE,
			TCADT.EXCUSE_PAR,
			TCADT.EXCUSE_CON,--->
			TCADT.IS_EXCUSE_MAIN,
			TCADT.CON_ID,
			TCADT.EMP_ID,
			TCADT.PAR_ID,
			TCADT.CLASS_ATTENDANCE_ID
		FROM
			TRAINING_CLASS_ATTENDANCE AS TCA, 
			TRAINING_CLASS_ATTENDANCE_DT AS TCADT,
			COMPANY_PARTNER,
			COMPANY
		WHERE
			TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
			COMPANY_PARTNER.PARTNER_ID=TCADT.PAR_ID AND
			COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND 
			<!---(TCADT.IS_EXCUSE = 1 OR TCADT.IS_EXCUSE_PAR = 1 OR TCADT.IS_EXCUSE_CON = 1) AND --->
			TCADT.IS_EXCUSE_MAIN = 1 AND
			TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
			TCADT.IS_TRAINER = 0
	</cfquery>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			TCA.START_DATE, 
			TCA.FINISH_DATE, 
			TCADT.EMP_ID,	
			TCADT.CON_ID,	
			TCADT.PAR_ID,
			CONSUMER.CONSUMER_NAME AS AD,
			CONSUMER.CONSUMER_NAME AS SOYAD,
			CONSUMER.TITLE AS POSITION,
			CONSUMER.DEPARTMENT,
			CONSUMER.COMPANY AS NICK_NAME,
			<!---TCADT.EXCUSE,
			TCADT.EXCUSE_PAR,
			TCADT.EXCUSE_CON,--->
			TCADT.IS_EXCUSE_MAIN,
			TCADT.CON_ID,
			TCADT.EMP_ID,
			TCADT.PAR_ID,
			TCADT.CLASS_ATTENDANCE_ID
		FROM 
			TRAINING_CLASS_ATTENDANCE AS TCA, 
			TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
			CONSUMER
		WHERE 
			TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
			CONSUMER.CONSUMER_ID=TCADT.CON_ID AND 
			<!---(TCADT.IS_EXCUSE = 1 OR TCADT.IS_EXCUSE_PAR = 1 OR TCADT.IS_EXCUSE_CON = 1) AND --->
			TCADT.IS_EXCUSE_MAIN = 1 AND
			TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
			TCADT.IS_TRAINER = 0
	</cfquery>
	<cfif GET_EMP_NAME.RECORDCOUNT>
		<cfoutput query="get_emp_name">
		<cfquery name="GET_EMP_DETAY" datasource="#DSN#">
			SELECT 
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME, 
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.POSITION_NAME,
				DEPARTMENT.DEPARTMENT_HEAD,
				OUR_COMPANY.NICK_NAME
			FROM 
				EMPLOYEE_POSITIONS,
				DEPARTMENT,
				BRANCH,
				OUR_COMPANY
			WHERE 
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_name.emp_id#"> AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
		</cfquery>
		<tr>
			<td>#AD# #SOYAD#</td>
 			<td>#GET_EMP_DETAY.NICK_NAME#</td>
			<td>#GET_EMP_DETAY.DEPARTMENT_HEAD#</td>
			<td>#GET_EMP_DETAY.POSITION_NAME#</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="4"><cf_get_lang_main no='72.Kayıt yok'></td>
		</tr>
	</cfif>
	<cfset partner_department_list=''>
	<cfif GET_PARTNER_NAME.recordcount>
		<cfoutput query="GET_PARTNER_NAME">
			<cfif len(department) and not listFindnocase(partner_department_list,department)>
				<cfset partner_department_list = listappend(partner_department_list,department)>
			</cfif>
		</cfoutput>
		<cfif listlen(partner_department_list)>
			<cfset partner_department_list=listsort(partner_department_list,"numeric","ASC",",")>
			<cfquery name="GET_PAR_DEP" datasource="#DSN#">
				SELECT
					PARTNER_DEPARTMENT
				FROM
					SETUP_PARTNER_DEPARTMENT SPD
				WHERE
					 SPD.PARTNER_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#partner_department_list#">)	 
			</cfquery>
		</cfif>
	</cfif>
	<cfif GET_PARTNER_NAME.RECORDCOUNT>
		<cfoutput query="GET_PARTNER_NAME">
			<tr>
				<td>#AD# #SOYAD#</td>
				<td><cfif len(NICK_NAME)>#NICK_NAME#<cfelse>&nbsp;</cfif></td>
				<td><cfif listlen(partner_department_list)>#GET_PAR_DEP.PARTNER_DEPARTMENT[listfind(partner_department_list,DEPARTMENT,',')]#&nbsp;<cfelse>&nbsp;</cfif></td>
				<td><cfif len(POSITION)>#POSITION#<cfelse>&nbsp;</cfif></td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</cfif>
	<cfset consumer_department_list=''>
	<cfif GET_CONS_NAME.recordcount>
		<cfoutput query="GET_CONS_NAME">
			<cfif len(department) and not listFindnocase(consumer_department_list,department)>
				<cfset consumer_department_list = listappend(consumer_department_list,department)>
			</cfif>
		</cfoutput>
		<cfif listlen(consumer_department_list)>
			<cfset consumer_department_list=listsort(consumer_department_list,"numeric","ASC",",")>
			<cfquery name="GET_CONS_DEP" datasource="#DSN#">
				SELECT
					PARTNER_DEPARTMENT
				FROM
					SETUP_PARTNER_DEPARTMENT SPD
				WHERE
					 SPD.PARTNER_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#consumer_department_list#">)	 
			</cfquery>
		</cfif>
	</cfif>
	<cfif GET_CONS_NAME.RECORDCOUNT>
		<cfoutput query="GET_CONS_NAME">
			<tr>
				<td>#AD# #SOYAD#</td>
				<td><cfif len(NICK_NAME)>#NICK_NAME#<cfelse>&nbsp;</cfif></td>
				<td><cfif listlen(consumer_department_list)>#GET_CONS_DEP.PARTNER_DEPARTMENT[listfind(partner_department_list,DEPARTMENT,',')]#&nbsp;<cfelse>&nbsp;</cfif></td>
				<td><cfif len(POSITION)>#POSITION#<cfelse>&nbsp;</cfif></td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</cfif>
</table>
</cfif>
</td>
</tr>
<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
