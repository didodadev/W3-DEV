<!---ceren-update--->
<cflock name="CreateUUID()" timeout="20">
	<cftransaction>	
	   <!--- <cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
				<cfset trainingupd = cfc.update(
				TRAIN_HEAD:form.TRAIN_HEAD,
				TRAIN_OBJECTIVE:iif(isDefined("attributes.TRAIN_OBJECTIVE"),"attributes.TRAIN_OBJECTIVE",DE("")),
				TRAIN_DETAIL:form.TRAIN_DETAIL,
				SUBJECT_STATUS:iif(isDefined("attributes.SUBJECT_STATUS"),"attributes.SUBJECT_STATUS",DE("")),
				CURRENCY_ID:iif(isDefined("attributes.CURRENCY_ID"),"attributes.CURRENCY_ID",DE("")),
				TRAIN_PARTNERS:iif(isDefined("attributes.TRAIN_PARTNERS"),"attributes.TRAIN_PARTNERS",DE("")) ,
				TRAIN_CONSUMERS:iif(isDefined("attributes.TRAIN_CONSUMERS"),"TRAIN_CONSUMERS",DE("")),
				TRAIN_DEPARTMENTS : iif(isDefined("attributes.TRAIN_DEPARTMENTS"),"attributes.TRAIN_DEPARTMENTS",DE("")),
				TRAIN_POSITION_CATS: iif(isDefined("attributes.TRAIN_POSITION_CATS"),"attributes.TRAIN_POSITION_CATS",DE("")),
				emp_id:  iif(isDefined("attributes.emp_id"),"attributes.emp_id",DE("")),
			    par_id: iif(isDefined("attributes.par_id"),"attributes.par_id",DE("")),
			    cons_id: iif(isDefined("attributes.cons_id"),"attributes.cons_id",DE("")),
				TRAINING_SEC_ID:attributes.TRAINING_SEC_ID,
				TRAINING_CAT_ID:attributes.training_cat_id,
				TRAINING_STYLE:attributes.training_style,
				TRAINING_TYPE:attributes.training_type,
				totalday:form.totalday,
				member_type:attributes.member_type,
				expense:attributes.expense,
				money:iif(isDefined("attributes.MONEY_CURRENCY"),"attributes.MONEY_CURRENCY",DE("")),
                TRAIN_ID:attributes.TRAIN_ID,
				PRODUCT_ID : iif(isDefined("attributes.product_id"),"attributes.product_id",DE("")),
				TOTAL_HOURS : iif(isDefined("attributes.total_hours"),"attributes.total_hours",DE(""))
				)> --->
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
<script>
	window.location.href ="<cfoutput>#request.self#?fuseaction=training_management.list_training_subjects&event=upd&train_id=#train_id#</cfoutput>";
</script>

