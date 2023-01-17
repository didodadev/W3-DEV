<!---29.06.19 ceren.insert işlemi için cfc objesi oluşturuldu --->
<cfif not (isdefined("attributes.training_sec_id") and  len(attributes.training_sec_id))>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='74.Kategori'>/<cf_get_lang_main no='583.bölüm'>!!");
		history.back();  
	</script>
	<cfabort>
</cfif>

<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
		<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
            <cfset training = cfc.cat(
                TRAIN_HEAD:form.TRAIN_HEAD,
                TRAIN_OBJECTIVE:iif(isDefined("attributes.TRAIN_OBJECTIVE"),"attributes.TRAIN_OBJECTIVE",DE("")),
                TRAIN_DETAIL:form.TRAIN_DETAIL,
                SUBJECT_STATUS:iif(isDefined("attributes.SUBJECT_STATUS"),"attributes.SUBJECT_STATUS",DE("")),
                CURRENCY_ID:iif(isDefined("attributes.CURRENCY_ID"),"attributes.CURRENCY_ID",DE("")),
                TRAINER_EMP:attributes.emp_id,
                TRAINER_PAR:attributes.par_id,
                TRAINER_CONS:attributes.cons_id,
                TRAINING_SEC_ID:attributes.TRAINING_SEC_ID,
                TRAINING_CAT_ID:attributes.training_cat_id,
                TRAINING_STYLE:attributes.training_style,
                TRAINING_TYPE:attributes.training_type,
                TOTALDAY:form.totalday,
                member_type:attributes.member_type,
                expense:attributes.expense,
                MONEY_CURRENCY:iif(isDefined("attributes.MONEY_CURRENCY"),"attributes.MONEY_CURRENCY",DE("")),
                PRODUCT_ID:iif(isDefined("attributes.product_id"),"attributes.product_id",DE("")),
                TOTAL_HOURS:iif(isDefined("attributes.total_hours"),"attributes.total_hours",DE("")),
                PROCESS_STAGE : iif(isDefined("attributes.process_stage"),"attributes.process_stage",DE("")),
                LANGUAGE_ID : iif(isDefined("attributes.language_id"),"attributes.language_id",DE(""))
			)>
			<cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
			<cf_workcube_process is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='TRAINING'
				action_column='TRAINING_ID'
				action_id='#training.identitycol#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects&event=upd&train_id=#training.IDENTITYCOL#'
				warning_description="#getLang('','Müfredat',46049)# : #training.identitycol#">
			</cfif>	
		<cf_relation_segment
			is_upd='1' 
			is_form='0'
			field_id='#training.IDENTITYCOL#'
			table_name='TRAINING'
			action_table_name='RELATION_SEGMENT_TRAINING'
			select_list='1,2,3,4,5,6,7,8,9'>
	</cftransaction>
</cflock>
<script>
	window.location.href ="<cfoutput>#request.self#?fuseaction=training_management.list_training_subjects&event=upd&train_id=#training.IDENTITYCOL#</cfoutput>";
</script>
