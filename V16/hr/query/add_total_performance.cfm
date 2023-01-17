<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfset per_ids_new = ListRemoveDuplicates(attributes.PER_IDS)>
<cftransaction> 
	  <cfquery name="add_total_performance" datasource="#dsn#">
	 INSERT INTO
		EMPLOYEE_TOTAL_PERFORMANCE
		(
            EMP_ID,
            START_DATE,
            FINISH_DATE,
            TARGET_IDS,
            QUOTE_IDS,
            PER_IDS,
            DEVELOPMENT_ID,
            POSSIBLE_PROMOTE_POS,
            <cfif len(POSSIBLE_PROMOTE_TIME)>
            POSSIBLE_PROMOTE_TIME,
            </cfif>
            MAX_POSSIBLE_PROMOTE_POS,
            <cfif len(MAX_POSSIBLE_PROMOTE_TIME)>
            MAX_POSSIBLE_PROMOTE_TIME,
            </cfif>
            ROTATION_POS,
            LUCK_TRAIN_SUBJECT_1,
            LUCK_TRAIN_SUBJECT_2,
            LUCK_TRAIN_SUBJECT_3,
            LUCK_TRAIN_SUBJECT_4,
            RECORD_KEY,
            RECORD_IP,
            RECORD_DATE
		)
		VALUES
		(
            #attributes.EMP_ID#,
            #attributes.start_date#,
            #attributes.finish_date#,
            '#attributes.TARGET_IDS#',
            '#attributes.QUOTE_IDS#',
            '#per_ids_new#',
            #DEVELOPMENT_ID#,
            <cfif len(POSSIBLE_PROMOTE_POS_NAME)>
                '#POSSIBLE_PROMOTE_POS#',
            <cfelse>
                NULL,
            </cfif>
            <cfif len(POSSIBLE_PROMOTE_TIME)>
            #POSSIBLE_PROMOTE_TIME#,
            </cfif>
            <cfif len(MAX_POSSIBLE_PROMOTE_POS_NAME)>
                '#MAX_POSSIBLE_PROMOTE_POS#',
            <cfelse>
                NULL,
            </cfif>
            <cfif len(MAX_POSSIBLE_PROMOTE_TIME)>
            #MAX_POSSIBLE_PROMOTE_TIME#,
            </cfif>
            <cfif len(ROTATION_POS_NAME)>
                '#ROTATION_POS#',
            <cfelse>
                NULL,
            </cfif>
            '#LUCK_TRAIN_SUBJECT_1#',
            '#LUCK_TRAIN_SUBJECT_2#',
            '#LUCK_TRAIN_SUBJECT_3#',
            '#LUCK_TRAIN_SUBJECT_4#',
            '#SESSION.EP.USERKEY#',
            '#CGI.REMOTE_ADDR#',
            #now()#
		)
	 </cfquery> 
</cftransaction>
<script type="text/javascript">
        window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_total_performances';
</script>