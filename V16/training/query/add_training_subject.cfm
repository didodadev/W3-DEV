<cfif not (isdefined("attributes.training_sec_id") and  len(attributes.training_sec_id))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='543.Kategori/Bölüm seçmediniz '>!!");
		history.back();  
	</script>
	<cfabort>
</cfif>
<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
		<cfquery name="ADD_TRAINING" datasource="#dsn#">
			INSERT 
			INTO
				TRAINING
				(
					RECORD_DATE,
					RECORD_EMP, 
					RECORD_IP,
					TRAIN_HEAD, 
					TRAIN_OBJECTIVE, 
					TRAIN_DETAIL, 
					SUBJECT_STATUS,
					<cfif isdefined("CURRENCY_ID") and len(CURRENCY_ID)> SUBJECT_CURRENCY_ID, </cfif>
					TRAINER_EMP,
					TRAINER_PAR,
					TRAINING_SEC_ID,
					TRAINING_CAT_ID,
					TRAINING_STYLE,
					TRAINING_TYPE,
					TOTAL_DAY,
					TRAINING_STAGE,
					TRAINING_EXPENSE,
					MONEY_CURRENCY
				)
			VALUES
				(
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					'#TRAIN_HEAD#', 
					'#TRAIN_OBJECTIVE#',
					'#TRAIN_DETAIL#',
					1,
					<cfif isdefined("CURRENCY_ID") and len(CURRENCY_ID)>#CURRENCY_ID#,</cfif>
					<cfif attributes.member_type eq "employee">
					#attributes.emp_id#,NULL,
					<cfelseif attributes.member_type eq "partner">NULL,#attributes.par_id#,<cfelse>NULL,NULL,</cfif>
					#attributes.training_sec_id#,
					#attributes.training_cat_id#,
					<cfif len(attributes.training_style)>#attributes.training_style#<cfelse>NULL</cfif>,
					<cfif len(attributes.training_type)>#attributes.training_type#,<cfelse>NULL,</cfif>
					<cfif len(attributes.totalday)>#attributes.totalday#,<cfelse>NULL,</cfif>
					<cfif len(attributes.level)>#attributes.level#,<cfelse>NULL,</cfif>
					<cfif len(attributes.expense)>#attributes.expense#,<cfelse>NULL,</cfif>
					'#attributes.money#'
				)
		</cfquery>		
		<cfquery name="GET_MAX_ID" datasource="#dsn#">
			SELECT MAX(TRAIN_ID) AS MAX_ID FROM  TRAINING
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training.popup_list_training_subjects&field_id=#attributes.field_id#&field_name=#attributes.field_name#&keyword=#attributes.train_head#" addtoken="no">
