<cfsetting showdebugoutput="no">
<cfset kisi_list = listsort(list_to_emp_ids,'numeric')>
<cfset kayit_varmi=0>
<cfset egitim_varmi=0>
<cf_date tarih ="attributes.startdate">
<cf_date tarih ="attributes.finishdate">
<cfset startdate_= date_add('h',event_start_clock,attributes.startdate)>
<cfset startdate_= date_add('n',event_start_minute,startdate_)>
<cfset finishdate_= date_add('h',event_finish_clock,attributes.finishdate)>
<cfset finishdate_=date_add('n',event_finish_minute,finishdate_)>
 <cfloop from="1" to="#listlen(kisi_list)#" index="i">
	<cfquery datasource="#dsn#" name="get_event_to_pos">
		SELECT DISTINCT 
			E.EVENT_HEAD,
			EMP.EMPLOYEE_SURNAME,
			EMP.EMPLOYEE_NAME,
			EMP.EMPLOYEE_ID
		FROM 
			EVENT E,
			EMPLOYEES EMP
		WHERE
			EMP.EMPLOYEE_ID = #listgetat(kisi_list,i,',')# AND 
		(
			(
			E.STARTDATE >= #dateadd('h',-session.ep.time_zone,startdate_)# AND
			E.STARTDATE <= #dateadd('h',-session.ep.time_zone,finishdate_)#
			)
		OR
			(
			E.STARTDATE <= #dateadd('h',-session.ep.time_zone,startdate_)# AND
			E.FINISHDATE >= #dateadd('h',-session.ep.time_zone,startdate_)#
			)
		)
		AND E.EVENT_TO_POS LIKE '%,#listgetat(kisi_list,i,',')#,%'
		<cfif isDefined('attributes.event_id') and len(attributes.event_id)>
			AND EVENT_ID <> #attributes.event_id#
		</cfif>
	</cfquery>
	<cfif get_event_to_pos.recordcount>
		<cfoutput query="get_event_to_pos"><ul style="margin-top:5px;"><li>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# :#EVENT_HEAD# - <cf_get_lang_main no='3.Ajanda'></li></ul></cfoutput>
	<cfset kayit_varmi=1>
	</cfif>
</cfloop>
 <cfloop from="1" to="#listlen(kisi_list)#" index="i">
	<cfquery name="get_training" datasource="#dsn#">
		SELECT DISTINCT
			TC.CLASS_ID, 
		    TC.CLASS_NAME,
			EMP.EMPLOYEE_NAME,
			EMP.EMPLOYEE_SURNAME,
			EMP.EMPLOYEE_ID
		FROM
			TRAINING_CLASS_ATTENDER TCA,
			TRAINING_CLASS TC,
			EMPLOYEES EMP
		WHERE
			EMP.EMPLOYEE_ID = #listgetat(kisi_list,i,',')# AND
			 (
				(
				TC.START_DATE >= #startdate_# AND
				TC.START_DATE <= #finishdate_#
				)
			OR
				(
				TC.START_DATE <= #startdate_# AND
				TC.FINISH_DATE >= #startdate_#
				)
			) 
			AND TCA.EMP_ID = #listgetat(kisi_list,i,',')#
			AND	TCA.CLASS_ID=TC.CLASS_ID 

	</cfquery>
<cfif get_training.recordcount>
		<cfoutput query="get_training"><ul><li>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#:#CLASS_NAME# - <cf_get_lang_main no='7.Eğitim'></li></ul></cfoutput>
	<cfset egitim_varmi=1> 
</cfif>
</cfloop>
	<cfif egitim_varmi neq 1 and kayit_varmi neq 1> 
		<ul  style="margin-top:5px;">
        	<li><cf_get_lang no='4.Katılımcılar Uygun'></li>
        </ul>
	</cfif>

