<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>
		<cfset attributes.main_quantity = filterNum(attributes.main_quantity)>
		<cfquery name="add_drawing_part" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO
				DRAWING_PART
				(
					DPL_NO,
					STAGE_ID,
					MAIN_PRODUCT_ID,
					PROJECT_ID,
					ASSET_ID,
					QUANTITY,
					IS_ACTIVE,
					IS_MAIN_DPL,
					IS_YRM,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					'#attributes.asset_no#',
					#attributes.process_stage#,
					#attributes.main_product_id#,
					<cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
					#attributes.asset_id#,
					<cfif len(attributes.main_quantity)>#attributes.main_quantity#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_main_dpl')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_yrm')>1<cfelse>0</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
		</cfquery>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_stock_id = evaluate("attributes.stock_id#i#");
						form_product_id = evaluate("attributes.product_id#i#");
						form_product_name = evaluate("attributes.product_name#i#");
						form_pbs_id = evaluate("attributes.pbs_id#i#");
						form_pbs_code = evaluate("attributes.pbs_code#i#");
						form_work_id = evaluate("attributes.work_id#i#");
						form_work_head = evaluate("attributes.work_head#i#");
						form_quantity = filterNum(evaluate("attributes.quantity#i#"));
						wrk_row_id = "WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
					</cfscript>
					<cfquery name="add_drawing_part_rows" datasource="#dsn3#">
						INSERT INTO
							DRAWING_PART_ROW
							(
								DPL_ID,
								STOCK_ID,
								PRODUCT_ID,
								PBS_ID,
								WORK_ID,
								QUANTITY,
								IS_ACTIVE,
								WRK_ROW_ID
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								<cfif len(form_stock_id) and len(form_product_name)>#form_stock_id#<cfelse>NULL</cfif>,
								<cfif len(form_product_id) and len(form_product_name)>#form_product_id#<cfelse>NULL</cfif>,
								<cfif len(form_pbs_id) and len(form_pbs_code)>#form_pbs_id#<cfelse>NULL</cfif>,
								<cfif len(form_work_id) and len(form_work_head)>#form_work_id#<cfelse>NULL</cfif>,
								<cfif len(form_quantity)>#form_quantity#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
								'#wrk_row_id#'
							)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cf_workcube_process is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='DRAWING_PART'
			action_column='DPL_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=product.form_upd_drawing_parts&dpl_id=#MAX_ID.IDENTITYCOL#' 
			warning_description='DPL EKleme : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=product.form_upd_drawing_parts&dpl_id=#MAX_ID.IDENTITYCOL#" addtoken="no">

