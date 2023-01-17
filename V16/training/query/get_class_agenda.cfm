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
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		<!---TRAINING_CLASS.TRAINER_EMP,--->
		TRAINING_CLASS.FINISH_DATE
	FROM
		TRAINING_CLASS
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND 
		(
			TRAINING_CLASS.CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID =#session.ep.userid#) OR
			<!---TRAINING_CLASS.TRAINER_EMP =  #SESSION.EP.USERID# OR--->
			TRAINING_CLASS.CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#) OR
			TRAINING_CLASS.VIEW_TO_ALL = 1
		) 
			AND START_DATE <= #attributes.finishdate# AND FINISH_DATE >= #attributes.startdate#		
			<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
			AND CLASS_ID = #attributes.CLASS_ID#
			</cfif>
			<cfif isDefined("attributes.online") and len(attributes.online)>
			AND ONLINE = #attributes.ONLINE#
			</cfif>
			<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
			AND( CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%')
			</cfif>
			<cfif IsDefined("attributes.train_departments") and attributes.train_departments>
			AND ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
			</cfif>
			<cfif IsDefined("attributes.train_position_cats") and attributes.train_position_cats>
			AND ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
			</cfif>
</cfquery>
