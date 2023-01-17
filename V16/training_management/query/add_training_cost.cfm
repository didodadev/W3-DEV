<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="upd_position_money" datasource="#dsn#">
		INSERT INTO
			TRAINING_CLASS_COST
			(
				CLASS_ID,
				ONGORULEN_TOPLAM,
				GERCEKLESEN_TOPLAM,
				CLASS_COST,
				EXCHANGE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				<cfif isdefined("attributes.class_id") and len(attributes.class_id)>#attributes.class_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.ongorulen_toplam)>#attributes.ongorulen_toplam#<cfelse>NULL</cfif>,
				<cfif len(attributes.gerceklesen_toplam)>#attributes.gerceklesen_toplam#<cfelse>NULL</cfif>,
				'#attributes.training_money#',
				<cfif len(attributes.kur)>#attributes.kur#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
		<cfquery name="last_id" datasource="#dsn#">
			SELECT MAX(TRAINING_CLASS_COST_ID) AS LAST_COST_ID FROM TRAINING_CLASS_COST
		</cfquery>

		<cfif len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol_#i#")>
					<cfif isdefined("attributes.cost_date_#i#") and len(evaluate('attributes.cost_date_#i#'))>
						<cfset attributes.cost_date_=evaluate('attributes.cost_date_#i#')>
						<cf_date tarih="attributes.cost_date_">
					<cfelse>
						<cfset attributes.cost_date_="">
					</cfif>
					<cfquery name="insert_position_cost" datasource="#dsn#">
						INSERT INTO
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
								#last_id.last_cost_id#,
								<cfif len(evaluate("attributes.items_names_#i#"))>#evaluate("attributes.items_names_#i#")#<cfelse>NULL</cfif>,
								'#Replace(evaluate("attributes.explanation_#i#"),"'"," ","all")#',
								<cfif isdefined("attributes.branch_id_#i#") and len(evaluate("attributes.branch_id_#i#"))>#evaluate("attributes.branch_id_#i#")#,<cfelse>NULL,</cfif>
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
	</cftransaction>
</cflock>
<script type="text/javascript">
    <cfif isDefined("attributes.draggable")>
        closeBoxDraggable('training_cost_box');
    <cfelse>
	    window.location.href='<cfoutput>#request.self#?fuseaction=training_management.list_training_management_cost</cfoutput>'
    </cfif>
</script>