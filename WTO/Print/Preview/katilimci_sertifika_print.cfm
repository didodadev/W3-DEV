<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfset att_list = ''>
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
<cfset attributes.group_ids="">
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
<cfif not len(LISTSORT(attributes.group_ids,"NUMERIC"))>
	<cfset attributes.group_ids = 0>
</cfif>

<cfquery name="get_class_attender" datasource="#DSN#">
	SELECT
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID AS K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS AD,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS SOYAD,
        TRAINING_CLASS.START_DATE,
        TRAINING_CLASS.CLASS_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
        TRAINING_CLASS,
		EMPLOYEE_POSITIONS
	WHERE
    	TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS_ATTENDER.EMP_ID IN (#LISTSORT(attributes.EMPLOYEE_IDS,"NUMERIC")#)
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		AND TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL
		<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
			AND TRAINING_CLASS_ATTENDER.CLASS_ID=#attributes.action_id#
		</cfif>
UNION
	SELECT 
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
        TRAINING_CLASS.START_DATE,
        TRAINING_CLASS.CLASS_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
        TRAINING_CLASS,
		COMPANY_PARTNER
	WHERE
    	TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.action_id#
		AND TRAINING_CLASS_ATTENDER.PAR_ID IN (#LISTSORT(attributes.PARTNER_IDS,"NUMERIC")#)
		AND COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID
UNION
	SELECT
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.CON_ID AS K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
        TRAINING_CLASS.START_DATE,
        TRAINING_CLASS.CLASS_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
        TRAINING_CLASS,
		CONSUMER
	WHERE
    	TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.action_id#
		AND TRAINING_CLASS_ATTENDER.CON_ID IN (#LISTSORT(attributes.consumer_ids,"NUMERIC")#)
		AND CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID
		AND TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
</cfquery>
<table style="text-align:center" cellpadding="0" cellspacing="0" border="0" height="35" style="width:180mm;">
	<tr><td style="height:10mm;">&nbsp;</td></tr>
    <tr>
		<td class="headbold">Katılımcı Sertifika</td>
	</tr>
</table><br/>
<table border="0" style="text-align:center;width:180mm;">
	<cfif get_class_attender.recordcount>
    	<cfoutput query="get_class_attender">
        	<tr><td>Sn. #ad# #soyad#, <br />#dateformat(START_DATE,dateformat_style)# tarihinde düzenlenen #class_name#'ne katılım sağlanmıştır.</td></tr>
        </cfoutput>
    </cfif>
</table>
