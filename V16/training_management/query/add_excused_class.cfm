<cfif LEN(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date = date_add('h', FORM.EVENT_finish_CLOCK - session.ep.TIME_ZONE, attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n', FORM.EVENT_finish_minute, attributes.finish_date)>
</cfif>
<cfif LEN(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add('h', FORM.EVENT_START_CLOCK - session.ep.TIME_ZONE, attributes.start_date)>
	<cfset attributes.start_date = date_add('n', FORM.EVENT_START_minute, attributes.start_date)>
</cfif>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="ADD_CLASS" datasource="#DSN#" result="MAX_ID">
		INSERT INTO
			TRAINING_CLASS
			(
			TRAINING_SEC_ID,
			TRAINING_CAT_ID,
			CLASS_NAME,
			START_DATE,
			FINISH_DATE,
			DATE_NO,
			HOUR_NO,
			<cfif LEN(Trim(emp_id))>
			TRAINER_EMP,
			<cfelseif LEN(Trim(par_id))>
			TRAINER_PAR,
			</cfif>
			PROCESS_STAGE,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#TRAINING_SEC_ID#,
			#TRAINING_CAT_ID#,
			'#CLASS_NAME#',
			<cfif LEN(attributes.START_DATE)>#attributes.START_DATE#,<cfelse>NULL,</cfif>
			<cfif LEN(attributes.FINISH_DATE)>#attributes.FINISH_DATE#,<cfelse>NULL,</cfif>
			#attributes.DATE_NO#,
			#attributes.HOUR_NO#,
			<cfif LEN(Trim(emp_id))>
			#emp_id#,
			<cfelseif LEN(Trim(par_id))>
			#par_id#,
			</cfif>
			#attributes.process_stage#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#
			)
		</cfquery>
		<cfif isdefined("attributes.joiners") and len(attributes.joiners)>
		   <cfloop list="#attributes.joiners#" index="i">
		     <cfquery name="add_joiners" datasource="#dsn#">
			   INSERT INTO
			     TRAINING_CLASS_ATTENDER
				 (
				   CLASS_ID,
				   EMP_ID
				 )
				 VALUES
				 (
				  #MAX_ID.IDENTITYCOL#,
				  #i#
				 )
			 </cfquery>
		   </cfloop>
		</cfif>
		<cfif isdefined("attributes.joiners_par") and len(attributes.joiners_par)>
		   <cfloop list="#attributes.joiners_par#" index="i">
		     <cfquery name="add_joiners_par" datasource="#dsn#">
			   INSERT INTO
			     TRAINING_CLASS_ATTENDER
				 (
				   CLASS_ID,
				   PAR_ID
				 )
				 VALUES
				 (
				  #MAX_ID.IDENTITYCOL#,
				  #i#
				 )
			 </cfquery>
		   </cfloop>
		</cfif>
		<cfif isdefined("attributes.joiners_con") and len(attributes.joiners_con)>
		   <cfloop list="#attributes.joiners_con#" index="i">
		     <cfquery name="add_joiners_con" datasource="#dsn#">
			   INSERT INTO
			     TRAINING_CLASS_ATTENDER
				 (
				   CLASS_ID,
				   CON_ID
				 )
				 VALUES
				 (
				  #MAX_ID.IDENTITYCOL#,
				  #i#
				 )
			 </cfquery>
		   </cfloop>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='TRAINING_CLASS'
			action_column='CLASS_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=training_management.popup_list_class_excuseds&class_id=#MAX_ID.IDENTITYCOL#' 
			warning_description = 'Eğitim : #MAX_ID.IDENTITYCOL#'>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
