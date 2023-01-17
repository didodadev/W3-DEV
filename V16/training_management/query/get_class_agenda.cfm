<cfset bu_sene=dateformat(now(),'yyyy')>
<cfif len(attributes.month_id)>
	<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
		<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
		<cfset attributes.finishdate="#DaysInMonth(createdate(attributes.yil_src,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
	<cfelse>
		<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#bu_sene#">
		<cfset attributes.finishdate="#DaysInMonth(createdate(bu_sene,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#bu_sene#">
	</cfif>
<cfelse>
<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
	<cfset attributes.startdate="01/01/#attributes.yil_src#">
	<cfset attributes.finishdate="31/12/#attributes.yil_src#">
<cfelse>
	<cfset attributes.startdate="01/01/#bu_sene#">
	<cfset attributes.finishdate="31/12/#bu_sene#">
</cfif>
</cfif>
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>

<cfquery name="GET_CLASS" datasource="#DSN#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
    	<!--- IS_ACTIVE=1 AND ---><!--- SG 20122611 yönetim tarafında tümünü görebilmeliler--->
		CLASS_ID IS NOT NULL AND
		START_DATE <= #attributes.finishdate# AND FINISH_DATE >= #attributes.startdate#		
		<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
			AND CLASS_ID = #attributes.CLASS_ID#
		</cfif>
		<cfif isDefined("attributes.online") and len(attributes.online)>
			AND ONLINE = #attributes.ONLINE#
		</cfif>
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
			AND (CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%')
		</cfif>
		 <cfif IsDefined("attributes.train_departments") AND attributes.train_departments>
		 AND (CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
		 </cfif>
		 <cfif IsDefined("attributes.train_position_cats") AND attributes.train_position_cats>
		 AND (CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
		 </cfif>
		 <cfif isdefined("attributes.training_cat_id") AND len(attributes.training_cat_id)>AND TRAINING_CAT_ID = #attributes.training_cat_id#</cfif>
		 <cfif isdefined("attributes.training_sec_id") AND len(attributes.training_sec_id)>AND TRAINING_SEC_ID = #attributes.training_sec_id#</cfif>
		<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and len(attributes.member_name) and member_type eq 'employee'>
			AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #attributes.emp_id#)
		 <cfelseif isdefined("attributes.par_id") and len(attributes.par_id) and len(attributes.member_name) and member_type eq 'partner'>
			AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE PAR_ID = #attributes.par_id#)
		 <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id) and len(attributes.member_name) and member_type eq 'consumer'>
			AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE CONS_ID = #attributes.cons_id#)
		 </cfif>
</cfquery>
