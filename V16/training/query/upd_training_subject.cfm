<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
		<cfquery name="UPD_TRAINING" datasource="#dsn#">
			UPDATE
				TRAINING
			SET
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				TRAIN_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#train_head#">,
				TRAIN_OBJECTIVE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#train_objective#">,
				TRAIN_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRAIN_DETAIL#">,
				<cfif isdefined("subject_status")>
					SUBJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#subject_status#">,
				<cfelse>
					SUBJECT_STATUS = 0,
				</cfif>
				<cfif isDefined("currency_id") and len(currency_id)>
					SUBJECT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currency_id#">,
				</cfif>
				<cfif isDefined("form.train_partners")>
					TRAIN_PARTNERS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#TRAIN_PARTNERS#,">, 
				<cfelse>
					TRAIN_PARTNERS = NULL, 
				</cfif>
				<cfif isDefined("form.train_consumers")>
					TRAIN_CONSUMERS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#TRAIN_CONSUMERS#,">, 
				<cfelse>
					TRAIN_CONSUMERS = NULL, 
				</cfif>
				<cfif isDefined("form.train_departments")>
					TRAIN_DEPARTMENTS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#TRAIN_DEPARTMENTS#,">, 
				<cfelse>
					TRAIN_DEPARTMENTS = NULL, 
				</cfif>
				<cfif isDefined("form.train_position_cats")>
					TRAIN_POSITION_CATS = <cfqueryparam cfsqltype="cf_sql_varchar" value=",#TRAIN_POSITION_CATS#,">, 
				<cfelse>
					TRAIN_POSITION_CATS = NULL, 
				</cfif>
				<cfif attributes.member_type eq "employee">
					TRAINER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">,
					TRAINER_PAR = NULL,
					TRAINER_CONS = NULL,
				<cfelseif attributes.member_type eq "partner">
					TRAINER_EMP = NULL,
					TRAINER_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">,
					TRAINER_CONS = NULL,
				<cfelseif attributes.member_type eq "consumer">
					TRAINER_EMP = NULL,
					TRAINER_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">,
					TRAINER_PAR = NULL,
				<cfelse>
					TRAINER_EMP = NULL,
					TRAINER_PAR = NULL,
					TRAINER_CONS = NULL,
				</cfif>
				<cfif isdefined("training_sec_id") and len(training_sec_id) and training_sec_id NEQ 0>
					TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAINING_SEC_ID#">,
				<cfelse>
					TRAINING_SEC_ID = NULL,
				</cfif>
				<cfif isdefined("training_cat_id") and len(training_cat_id) and training_cat_id NEQ 0>
					TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAINING_CAT_ID#">,
				<cfelse>
					TRAINING_CAT_ID = NULL,
				</cfif>
				TRAINING_STYLE = <cfif Len(attributes.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#"><cfelse>NULL</cfif>,
				TRAINING_TYPE = <cfif Len(attributes.training_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_type#">,<cfelse>NULL,</cfif>
				TOTAL_DAY = <cfif len(attributes.totalday)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.totalday#">,<cfelse>NULL,</cfif>
				TRAINING_EXPENSE = <cfif len(attributes.expense)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.expense#">,<cfelse>NULL,</cfif>
				MONEY_CURRENCY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#">
			WHERE
				TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#train_id#">
		</cfquery>
		<cf_relation_segment
			is_upd='1'
			is_form='0'
			field_id='#attributes.TRAIN_ID#'
			table_name='TRAINING'
			action_table_name='RELATION_SEGMENT_TRAINING'
			select_list='1,2,3,4,5,6,7,8,9'>
	</cftransaction>
</cflock>
<cfscript>
	structdelete(session,"training_folder");
</cfscript>
<cflocation url="#request.self#?fuseaction=training.form_upd_training_subject&train_id=#train_id#" addtoken="no">
