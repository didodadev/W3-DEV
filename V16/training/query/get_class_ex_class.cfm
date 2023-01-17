<!--  Daha önce başvuran kişileri bul ve listelemesini engelle !-->
<cfquery name="get_applied_emps" datasource="#dsn#"> 
	SELECT 
    	CLASS_ID 
   	FROM 
    	TRAINING_JOIN_REQUESTS
	WHERE 
    	EMPLOYEE_ID = #SESSION.EP.USERID#
</cfquery>
<cfset liste = ValueList(get_applied_emps.class_id)> 

<cfset bu_ay=Month(now())>
<cfset attributes.DUN = date_add('d',-1,Now())>
<cfset attributes.BUGUN = Now()>
<cfset attributes.tarih_dokuzyuz="01/01/1900">
<cf_date tarih='attributes.tarih_dokuzyuz'>
<cfif Len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
</cfif>
<cfquery name="get_class_ex_class" datasource="#dsn#">
<cfif (isDefined("attributes.IC_DIS") AND (attributes.IC_DIS IS 1) OR (attributes.IC_DIS IS 0)) OR (not isDefined("attributes.IC_DIS"))>
SELECT
		START_DATE, 
		FINISH_DATE, 
		ONLINE, 
		CLASS_ID, 
		CLASS_NAME, 
		CLASS_PLACE, 
		MONTH_ID, 
		#attributes.tarih_dokuzyuz# AS CLASS_DATE, 
		'İÇ' AS TYPE
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.online") and len(attributes.online)>
		AND
		ONLINE = #attributes.ONLINE#
		</cfif>
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		CLASS_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		AND START_DATE IS NULL
		AND FINISH_DATE IS NULL
		<cfif isDefined("attributes.date1") and len(attributes.date1) and attributes.date1 IS NOT 'NULL'>
		AND	MONTH_ID > #month(attributes.date1)# 
		<cfelse>
		AND	MONTH_ID > #bu_ay#
		</cfif>
		<cfif isdefined("attributes.training_sec_id") AND attributes.training_sec_id>
		AND	TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif get_applied_emps.recordcount>
		AND CLASS_ID NOT IN (#liste#)
		</cfif>
UNION ALL
	SELECT
		START_DATE, 
		FINISH_DATE, 
		ONLINE, 
		CLASS_ID, 
		CLASS_NAME, 
		CLASS_PLACE, 
		MONTH_ID, 
		#attributes.tarih_dokuzyuz# AS CLASS_DATE, 
		'İÇ' AS TYPE
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.online") and len(attributes.online)>
		AND
		ONLINE = #attributes.ONLINE#
		</cfif>
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
			CLASS_NAME LIKE '%#attributes.KEYWORD#%'
			OR
			CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND
			(
			START_DATE >= #attributes.date1#
			OR
			FINISH_DATE >= #attributes.date1#
			)
		<cfelse>
			AND
			FINISH_DATE > #attributes.BUGUN#
		</cfif>
		<cfif isDefined("attributes.field_id")>
			AND
			START_DATE > #attributes.DUN#
		</cfif>
		<cfif isdefined("attributes.training_sec_id") AND attributes.training_sec_id>
			AND
			TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif get_applied_emps.recordcount>
		AND CLASS_ID NOT IN (#liste#)
		</cfif>
</cfif>
<cfif (isDefined("attributes.IC_DIS") AND attributes.IC_DIS IS 0) OR (not isDefined("attributes.IC_DIS"))>
	UNION ALL
</cfif>
<cfif (isDefined("attributes.IC_DIS") AND (attributes.IC_DIS IS 2) OR (attributes.IC_DIS IS 0)) OR (not isDefined("attributes.IC_DIS"))>
	SELECT
		#attributes.tarih_dokuzyuz# AS START_DATE, 
		#attributes.tarih_dokuzyuz# AS FINISH_DATE, 
		0 AS ONLINE, 
		EX_CLASS_ID AS CLASS_ID, 
		CLASS_NAME, 
		CLASS_PLACE, 
		0 AS MONTH_ID, 
		CLASS_DATE, 
		'DIŞ' AS TYPE
	FROM
		TRAINING_EX_CLASS
	WHERE
		EX_CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.online") and len(attributes.online) AND attributes.online>
		AND
		1 = 0
		</cfif>
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		CLASS_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		CLASS_PLACE LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND
			CLASS_DATE >= #attributes.date1#
		<cfelse>
			AND
			CLASS_DATE > #attributes.BUGUN#
		</cfif>
		<cfif isdefined("attributes.training_sec_id") AND attributes.training_sec_id>
		AND
		TRAINING_SEC_ID = #attributes.training_sec_id#
		</cfif>
		<cfif get_applied_emps.recordcount>
		AND CLASS_ID NOT IN (#liste#)
		</cfif>
</cfif>
	ORDER BY
		CLASS_NAME

</cfquery>
