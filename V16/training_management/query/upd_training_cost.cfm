<cflock name="#createuuid()#" timeout="20">
	<cftransaction>
		<cfquery name="upd_position_money" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_COST
			SET
				ONGORULEN_TOPLAM = <cfif len(attributes.ongorulen_toplam)>#attributes.ongorulen_toplam#<cfelse>NULL</cfif>,
				GERCEKLESEN_TOPLAM = <cfif len(attributes.gerceklesen_toplam)>#attributes.gerceklesen_toplam#<cfelse>NULL</cfif>,
				CLASS_COST = '#attributes.training_money#',
				EXCHANGE = <cfif len(attributes.kur)>#attributes.kur#<cfelse>NULL</cfif>,		
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				TRAINING_CLASS_COST_ID = #attributes.training_class_cost_id#	
		</cfquery>
		<cfif isdefined("attributes.update_record") and attributes.update_record eq 1>
			<cfquery name="del_" datasource="#dsn#">
				DELETE FROM TRAINING_CLASS_COST_ROWS WHERE TRAINING_CLASS_COST_ID = #attributes.training_class_cost_id# AND COST_ROW_ID IN (#attributes.cost_row_id#)		
			</cfquery>
		</cfif>
		<cfif len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol_#i#")>
					<cfif isdefined("attributes.cost_date_#i#") and len(evaluate('attributes.cost_date_#i#'))>
						<cfset attributes.cost_date_=evaluate('attributes.cost_date_#i#')>
						<cf_date tarih="attributes.cost_date_">
					<cfelse>
						<cfset attributes.cost_date_="">
					</cfif>
					<cfquery name="insert_position_costs" datasource="#dsn#">
						INSERT
						INTO
							TRAINING_CLASS_COST_ROWS
							(
								TRAINING_CLASS_COST_ID,
								EXPENSE_ITEM_ID,
								EXPLANATION,
								BRANCH_ID,
								COST_DATE,
								GERCEKLESEN,
								GERCEKLESEN_BIRIM,
								GERCEKLESEN_MIKTAR,
								ONGORULEN,
								ONGORULEN_BIRIM,
								ONGORULEN_MIKTAR
							)
							VALUES
							(
								#attributes.training_class_cost_id#,
								<cfif len(evaluate("attributes.items_names_#i#"))>#evaluate("attributes.items_names_#i#")#<cfelse>NULL</cfif>,
								'#wrk_eval("attributes.explanation_#i#")#',
								<cfif isdefined("attributes.branch_id_#i#") and len(evaluate("attributes.branch_id_#i#"))>#evaluate("attributes.branch_id_#i#")#<cfelse>NULL</cfif>,
								<cfif len(attributes.cost_date_)>#attributes.cost_date_#,<cfelse>NULL,</cfif>
								<cfif len(evaluate("attributes.gerceklesen_#i#"))>#evaluate("attributes.gerceklesen_#i#")#<cfelse>0</cfif>,
								<cfif len(evaluate("attributes.gerceklesen_birim_#i#"))>#evaluate("attributes.gerceklesen_birim_#i#")#<cfelse>0</cfif>,
								<cfif len(evaluate("attributes.gerceklesen_miktar_#i#"))>#evaluate("attributes.gerceklesen_miktar_#i#")#<cfelse>0</cfif>,
								<cfif len(evaluate("attributes.ongorulen_#i#"))>#evaluate("attributes.ongorulen_#i#")#<cfelse>0</cfif>,
								<cfif len(evaluate("attributes.ongorulen_birim_#i#"))>#evaluate("attributes.ongorulen_birim_#i#")#<cfelse>0</cfif>,
								<cfif len(evaluate("attributes.ongorulen_miktar_#i#"))>#evaluate("attributes.ongorulen_miktar_#i#")#<cfelse>0</cfif>		
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cfquery name="get_list_training_cost_row" datasource="#dsn#">
			SELECT * FROM TRAINING_CLASS_COST_ROWS WHERE TRAINING_CLASS_COST_ID = #attributes.training_class_cost_id#
		</cfquery>
		<cfif not get_list_training_cost_row.recordcount>
			<cfquery name="get_delete_training_class" datasource="#dsn#">
				DELETE FROM TRAINING_CLASS_COST WHERE TRAINING_CLASS_COST_ID = #attributes.training_class_cost_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
    <cfif isDefined("attributes.draggable")>
        closeBoxDraggable('training_cost_box');
    <cfelse>
    	window.location.href='<cfoutput>#request.self#?fuseaction=training_management.list_training_management_cost</cfoutput>'
    </cfif>
</script>