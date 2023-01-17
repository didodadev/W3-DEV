<!---delete  --->
<cflock timeout="60">
	<cftransaction>
	<cfset attributes.action_id=attributes.TRAIN_ID>
	<cfset attributes.action_section="TRAINING_SEC_ID">
	<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
				<cfset GET_TRAINING_SUBJECT = cfc.GET_TRAINING_SUBJECT(
				TRAIN_ID:attributes.TRAIN_ID
				)>
	<cfdirectory action="LIST" directory="#upload_folder#training#dir_seperator##get_training_subject.folder#" name="liste">
	<cfoutput query="liste">
		<cfif ((liste.name is not ".") and (liste.name is not ".."))>
			<cftry>
				<cffile action="DELETE" file="#upload_folder#training#dir_seperator##get_training_subject.folder##liste.name#">
				<cfcatch type="Any">
					<cf_get_lang no='282.Dosya Bulunamadı Ama Veritabanında Güncellendi !'>
				</cfcatch>
			</cftry>
		</cfif>
	</cfoutput>
	<cftry>
		<cfdirectory action="DELETE" directory="#upload_folder#training#dir_seperator##get_training_subject.folder#">
		<cfcatch type="Any">
			<cf_get_lang no='282.Dosya Bulunamadı Ama Veritabanında Güncellendi !'>
		</cfcatch>
	</cftry>
	<cf_add_log  log_type="-1" action_id="#attributes.train_id#" action_name="#attributes.head#" process_stage="#GET_TRAINING_SUBJECT.subject_currency_id#">
	</cftransaction>
</cflock>
<cflock name="CreateUUID()" timeout="20">
		<cftransaction>
			<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
				<cfset trainingdel = cfc.del(TRAIN_ID:attributes.TRAIN_ID)>
		
		<cf_relation_segment
			is_del=1
			is_upd='0' 
			is_form='0'
			field_id='#attributes.TRAIN_ID#'
			table_name='TRAINING'
			action_table_name='RELATION_SEGMENT_TRAINING'
			select_list='1,2,3,4,5,6,7,8'>
		</cftransaction>
</cflock>
<cfscript>
	structdelete(session,"training_folder");
</cfscript>
<script>
        window.location.href = '<cfoutput>#request.self#?fuseaction=training_management.list_training_subjects</cfoutput>';
</script>

