<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfset per_ids_new = ListRemoveDuplicates(attributes.PER_IDS)>
<cftransaction>
	  <cfquery name="upd_perform" datasource="#dsn#">
	 UPDATE
		EMPLOYEE_TOTAL_PERFORMANCE
	 SET	
		START_DATE = #attributes.start_date#,
		FINISH_DATE = #attributes.finish_date#,
		TARGET_IDS = '#attributes.TARGET_IDS#',
		QUOTE_IDS = '#attributes.QUOTE_IDS#',
		PER_IDS = '#per_ids_new#',
		
		<cfif IsDefined("DEVELOPMENT_ID")>
			DEVELOPMENT_ID = #DEVELOPMENT_ID#,
		</cfif>
		<cfif len(POSSIBLE_PROMOTE_POS_NAME)>
			POSSIBLE_PROMOTE_POS = '#POSSIBLE_PROMOTE_POS#',
		<cfelse>
			POSSIBLE_PROMOTE_POS = NULL,
		</cfif>
		<cfif len(POSSIBLE_PROMOTE_TIME)>
			POSSIBLE_PROMOTE_TIME = #POSSIBLE_PROMOTE_TIME#,
		</cfif>
		<cfif len(MAX_POSSIBLE_PROMOTE_POS_NAME)>
			MAX_POSSIBLE_PROMOTE_POS = '#MAX_POSSIBLE_PROMOTE_POS#',
		<cfelse>
			MAX_POSSIBLE_PROMOTE_POS = NULL,
		</cfif>
		<cfif len(MAX_POSSIBLE_PROMOTE_TIME)>
			MAX_POSSIBLE_PROMOTE_TIME = #MAX_POSSIBLE_PROMOTE_TIME#,
		</cfif>
		<cfif len(ROTATION_POS_NAME)>
			ROTATION_POS = '#ROTATION_POS#',
		<cfelse>
			ROTATION_POS = NULL,
		</cfif>
		LUCK_TRAIN_SUBJECT_1 = '#LUCK_TRAIN_SUBJECT_1#',
		LUCK_TRAIN_SUBJECT_2 = '#LUCK_TRAIN_SUBJECT_2#',
		LUCK_TRAIN_SUBJECT_3 = '#LUCK_TRAIN_SUBJECT_3#',
		LUCK_TRAIN_SUBJECT_4 = '#LUCK_TRAIN_SUBJECT_4#',
		
		UPDATE_KEY = '#SESSION.EP.USERKEY#',
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#

	WHERE
		EMP_ID = #attributes.EMP_ID#
		AND
		PERFORMANCE_ID = #attributes.PERFORMANCE_ID#
	 </cfquery> 
</cftransaction>
<script type="text/javascript">
        window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_total_performances';
</script>

