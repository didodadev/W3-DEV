<cfset class_id =attributes.action_id>
<cfset att_list =''>
<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#class_id# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#class_id# AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#class_id# AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfif get_emp_att.RECORDCOUNT>
	<cfloop query="get_emp_att">
		<cfset att_list = listappend(att_list,"emp-#get_emp_att.EMP_ID#",",")>
	</cfloop>
</cfif>
<cfif get_par_att.RECORDCOUNT>
	<cfloop query="get_par_att">
		<cfset att_list = listappend(att_list,"par-#get_par_att.PAR_ID#",",")>
	</cfloop>
</cfif>
<cfif get_con_att.RECORDCOUNT>
	<cfloop query="get_con_att">
		<cfset att_list = listappend(att_list,"con-#get_con_att.CON_ID#",",")>
	</cfloop>
</cfif>
<cfset attributes.partner_ids="">
<cfset attributes.employee_ids="">
<cfset attributes.consumer_ids="">
<cfloop list="#evaluate("att_list")#" index="i" delimiters=",">
	<cfif i contains "par">
		<cfset attributes.partner_ids = LISTAPPEND(attributes.partner_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "emp">
		<cfset attributes.employee_ids = LISTAPPEND(attributes.employee_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "con">
		<cfset attributes.consumer_ids = LISTAPPEND(attributes.consumer_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "grp">
		<cfset attributes.group_ids = LISTAPPEND(attributes.group_ids,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop>
<cfif not len(listsort(attributes.employee_ids,"numeric"))>
	<cfset attributes.employee_ids = 0>
</cfif>
<cfif not len(LISTSORT(attributes.partner_ids,"NUMERIC"))>
	<cfset attributes.partner_ids = 0> 
</cfif>
<cfif not len(LISTSORT(attributes.consumer_ids,"NUMERIC"))>
	<cfset attributes.consumer_ids = 0>
</cfif>
<cfquery name="get_class_attender" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ATTENDER,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		AND C.COMP_ID=BRANCH.COMPANY_ID
		AND TRAINING_CLASS_ATTENDER.EMP_ID IN (#LISTSORT(attributes.EMPLOYEE_IDS,"NUMERIC")#)
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		AND TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL
		AND TRAINING_CLASS_ATTENDER.CLASS_ID=#class_id#
UNION
	SELECT 
		COMPANY_PARTNER.COMPANY_PARTNER_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ATTENDER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = #CLASS_ID#
		AND TRAINING_CLASS_ATTENDER.PAR_ID IN (#LISTSORT(attributes.PARTNER_IDS,"NUMERIC")#)
		AND COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
UNION
	SELECT
		CONSUMER.CONSUMER_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ATTENDER,
		CONSUMER
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = #CLASS_ID#
		AND TRAINING_CLASS_ATTENDER.CON_ID IN (#LISTSORT(attributes.consumer_ids,"NUMERIC")#)
		AND CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID
		AND TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
</cfquery>	
<cfset mails = "">
<cfset mail_list=''>		
<cfloop query="get_class_attender">
 <cfif len(EMAIL) and (EMAIL contains "@") and (Len(EMAIL) gte 6)>
	<cfset mails = mails & EMAIL & ",">
  </cfif> 
</cfloop>
<form name="mail_list">
	<input name="mails" id="mails" type="hidden" value="<cfif Len(mails) gt 1><cfoutput>#Left(mails,Len(mails) - 1)#</cfoutput></cfif>">
</form>
