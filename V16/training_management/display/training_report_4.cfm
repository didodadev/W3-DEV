<cfquery name="get_trainings_emp" datasource="#DSN#">
	SELECT
		FINALTEST_POINT,
		PRETEST_POINT,
		FINALTEST_POINT-PRETEST_POINT AS FARK,
		EMP_ID
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
		AND EMP_ID IS NOT NULL
</cfquery> 
<cfquery name="get_trainings_comp" datasource="#DSN#">
	SELECT
		FINALTEST_POINT,
		PRETEST_POINT,
		FINALTEST_POINT-PRETEST_POINT AS FARK,
		PAR_ID
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
		AND PAR_ID IS NOT NULL
</cfquery> 
<cfquery name="get_trainings_cons" datasource="#DSN#">
	SELECT
		FINALTEST_POINT,
		PRETEST_POINT,
		FINALTEST_POINT-PRETEST_POINT AS FARK,
		CON_ID
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
		AND CON_ID IS NOT NULL
</cfquery> 
<cfset company_id_list=''>
<cfset consumer_id_list=''>
<cfset emp_id_list=''>
<cfif get_trainings_emp.recordcount>
	<cfoutput query="get_trainings_emp">
		<cfif len(EMP_ID) and not listfind(emp_id_list,EMP_ID)>
			<cfset emp_id_list=listappend(emp_id_list,EMP_ID)>
		</cfif>
	</cfoutput>
	<cfif len(emp_id_list)>
	<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
		<cfquery name="GET_EMP_ID" datasource="#DSN#">
			SELECT
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				EMPLOYEE_ID
			FROM 
				EMPLOYEES
			WHERE
				EMPLOYEE_ID IN (#emp_id_list#)
			ORDER BY
				EMPLOYEE_ID
		</cfquery>
	</cfif>
</cfif>
<cfif get_trainings_comp.recordcount>
	<cfoutput query="get_trainings_comp">
		<cfif len(PAR_ID) and not listFindnocase(company_id_list,PAR_ID)>
			<cfset company_id_list = listappend(company_id_list,PAR_ID)>
		</cfif>
	</cfoutput>
	<cfif listlen(company_id_list)>
		<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
		<cfquery name="COMPANY_NAME" datasource="#dsn#">
			SELECT
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				PARTNER_ID
			FROM
				COMPANY_PARTNER
			WHERE
				PARTNER_ID  IN (#company_id_list#)
			ORDER BY 
				PARTNER_ID	
		</cfquery>
	</cfif>	
</cfif>

<cfif get_trainings_cons.recordcount>
	<cfoutput query="get_trainings_cons">
		<cfif len(CON_ID) and not listFindnocase(consumer_id_list,CON_ID)>
			<cfset consumer_id_list = listappend(consumer_id_list,CON_ID)>
		</cfif>
	</cfoutput>
	<cfif listlen(consumer_id_list)>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfquery name="CONS_NAME" datasource="#dsn#">
		  SELECT 
			  CONSUMER_NAME,
			  CONSUMER_SURNAME,
			  CONSUMER_ID
		  FROM 
			  CONSUMER 
		  WHERE 
			  CONSUMER_ID IN (#consumer_id_list#)
		  ORDER BY
			  CONSUMER_ID	  
		</cfquery>	
	</cfif>
</cfif>
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
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='309.On Test Son Test Sonuçları'></font></td>
  </tr>
  </cfif>
  
</table>
<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	<tr class="formbold" height="25">
	<td><cf_get_lang_main no='164.Çalışan'></td>
	<td width="75"><cf_get_lang no='310.İlk Sınav'></td>
	<td width="75"><cf_get_lang no='311.Final Sınavı'></td>
	<td width="50"><cf_get_lang_main no='1171.Fark'></td>
	</tr>
  
	<cfoutput query="get_trainings_emp">
		<tr height="20">
			<td><cfif listlen(emp_id_list) >#GET_EMP_ID.EMPLOYEE_NAME[listfind(emp_id_list,EMP_ID,',')]#&nbsp;#GET_EMP_ID.EMPLOYEE_SURNAME[listfind(emp_id_list,EMP_ID,',')]#<cfelse>&nbsp;</cfif></td>
			<td align="center">#PRETEST_POINT#</td>
			<td align="center">#FINALTEST_POINT#</td>
			<td align="center">#FARK#</td>
		</tr>
	</cfoutput>
	<cfoutput query="get_trainings_comp">
		<tr height="20">
			<td><cfif listlen(company_id_list) >#COMPANY_NAME.COMPANY_PARTNER_NAME[listfind(company_id_list,PAR_ID,',')]#&nbsp;#COMPANY_NAME.COMPANY_PARTNER_SURNAME[listfind(company_id_list,PAR_ID,',')]#<cfelse>&nbsp;</cfif></td>
			<!--- <cfif listlen(company_id_list)>
			<td>#COMPANY_NAME.COMPANY_PARTNER_NAME[listfind(emp_id_list,PAR_ID,',')]#&nbsp;#COMPANY_NAME.COMPANY_PARTNER_SURNAME[listfind(emp_id_list,PAR_ID,',')]#</td><cfelse><td>&nbsp;</td>
			</cfif>
			<cfif listlen(consumer_id_list)>
			<td>#CONS_NAME.CONSUMER_NAME[listfind(consumer_id_list,CON_ID,',')]#&nbsp;#CONS_NAME.CONSUMER_SURNAME[listfind(consumer_id_list,CON_ID,',')]#</td><cfelse><td>&nbsp;</td>
			</cfif> --->
			<td align="center">#PRETEST_POINT#</td>
			<td align="center">#FINALTEST_POINT#</td>
			<td align="center">#FARK#</td>
		</tr>
	</cfoutput>
	<cfoutput query="get_trainings_cons">
		<tr height="20">
			<td><cfif listlen(consumer_id_list) >#CONS_NAME.CONSUMER_NAME[listfind(consumer_id_list,CON_ID,',')]#&nbsp;#CONS_NAME.CONSUMER_SURNAME[listfind(consumer_id_list,CON_ID,',')]#<cfelse>&nbsp;</cfif></td>
			<td align="center">#PRETEST_POINT#</td>
			<td align="center">#FINALTEST_POINT#</td>
			<td align="center">#FARK#</td>
		</tr>
	</cfoutput>
</table>
</td>
</tr>
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
