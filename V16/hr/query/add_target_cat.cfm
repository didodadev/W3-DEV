<cflock name="CreateUUID()" timeout="30">
	<cftransaction>
		<cfquery name="INS_TARGET_CAT" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				TARGET_CAT
			(
				TARGETCAT_NAME,
				DETAIL,
				TARGETCAT_WEIGHT,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP,
                IS_ACTIVE
			) 
			VALUES 
			(
				'#attributes.targetcat_name#',
				'#attributes.targetcat_detail#',
				<cfif isdefined("attributes.targetcat_weight") and len(attributes.targetcat_weight)>#attributes.targetcat_weight#<cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#,
                <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
			)
		</cfquery>
		<cf_relation_segment
			is_upd='1' 
			is_form='0'
			field_id='#MAX_ID.IDENTITYCOL#'
			table_name='TARGET_CAT'
			action_table_name='RELATION_SEGMENT'
			select_list='1,2,3,4,5,6,7,8'>
				
	</cftransaction>
</cflock>
<script>
    window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_target_cat&event=upd&targetcat_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
