
<cfif isdefined("attributes.is_delete")>
	<cfquery name="del_" datasource="#dsn3#">
		DELETE FROM ORDER_RESULT_QUALITY_ROW WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">
	</cfquery>
	<cfquery name="del_" datasource="#dsn3#">
		DELETE FROM ORDER_RESULT_QUALITY WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">
	</cfquery>
	<script type="text/javascript">
		location.href="<cfoutput>#request.self#?fuseaction=prod.list_quality_controls</cfoutput>";
	</script>
<cfelse>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_RESULT_QUALITY_ROW WHERE OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">
			</cfquery>
			<cfquery name="upd_quality" datasource="#dsn3#">
				UPDATE
					ORDER_RESULT_QUALITY
				SET
					CONTROLLER_EMP_ID = <cfif isDefined("attributes.controller_emp_id") and Len(attributes.controller_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.controller_emp_id#"><cfelseif isDefined("attributes.controller_emp_id_") and Len(attributes.controller_emp_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.controller_emp_id_#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.q_control_no") and Len(attributes.q_control_no)> Q_CONTROL_NO =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.q_control_no#">,</cfif>
					CONTROL_AMOUNT = <cfif isDefined("attributes.control_amount") and Len(attributes.control_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.control_amount,4)#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.control_amount_control,4)#"></cfif>,
					<cfif isDefined("attributes.control_detail") and Len(attributes.control_detail)> CONTROL_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.control_detail#">,</cfif>
					STAGE =<cfif isDefined("attributes.process_stage") and Len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					SUCCESS_ID = <cfif isDefined("attributes.success_id") and Len(attributes.success_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.success_id#"><cfelse>NULL</cfif>,
					IS_REPROCESS = 	<cfif isDefined("attributes.is_reprocess") and Len(attributes.is_reprocess)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_reprocess#"><cfelse>0</cfif>,
					IS_ALL_AMOUNT = <cfif isDefined("attributes.is_all_amount") and Len(attributes.is_all_amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_all_amount#"><cfelse>0</cfif>,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					CONTROL_DATE=<cfif isdefined("attributes.control_date") and len(attributes.control_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.control_date#"><cfelse>NULL</cfif>
				WHERE
					OR_Q_ID = #attributes.OR_Q_ID#
			</cfquery>
			<cfif isDefined("attributes.is_horizontal") and Len(attributes.is_horizontal) and attributes.is_horizontal eq 1>
				<!--- Kalite Tipleri Yatay Gelsin Xmli Secili Ise --->
				<cfloop list="#attributes.quality_type_list#" index="_ind_">
					<cfif isDefined("attributes.quality_control_row_id_list_#_ind_#") and Len(Evaluate('attributes.quality_control_row_id_list_#_ind_#'))>
					<cfloop list="#Evaluate('attributes.quality_control_row_id_list_#_ind_#')#" index="rowlist">
						<cfloop from="1" to="#filterNum(attributes.quantity_sample_count)#" index="qsc">
                        <cfset quality_rule = Evaluate("attributes.quality_rule_#_ind_#_#rowlist#_#qsc#")>
							<cfif isDefined("quality_rule") and quality_rule eq 0 and isdefined("attributes.quality_result_#_ind_#_#rowlist#_#qsc#") and Len(Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#"))>
								<cfset quality_result_ = filterNum(Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#"),4)>
                            <cfelseif isDefined("quality_rule") and quality_rule eq 2 and isdefined("attributes.quality_result_#_ind_#_#rowlist#_#qsc#") and Len(Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#")) >
                                <cfset quality_result_ = Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#")>
                             <cfelseif isDefined("quality_rule") and quality_rule eq 1 and isdefined("attributes.quality_result_#_ind_#_#rowlist#_#qsc#") and Len(Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#")) >
                               <cfset quality_result_ = dateformat(Evaluate("attributes.quality_result_#_ind_#_#rowlist#_#qsc#"),dateformat_style)>
                               <cf_date tarih='quality_result_'>
                            <cfelse>
								<cfset quality_result_ = 0>
							</cfif>
							<cfquery name="ADD_ORDER_RESULT_QUALITY_ROW" datasource="#dsn3#">
								INSERT INTO
									ORDER_RESULT_QUALITY_ROW
									(
										QUALITY_DETAIL, <!--- Aciklama --->
										CONTROL_TYPE_ID, <!--- Kontrol Tipi --->
										CONTROL_ROW_ID, <!--- Kontrol Kriteri --->
										SAMPLE_COLUMN, <!--- Numune Sayisi --->
										CONTROL_RESULT, <!--- Tolerans Degeri Sayı --->
                                        CONTROL_RESULT_TEXT, <!--- Tolerans Degeri Text --->
                                        CONTROL_RESULT_DATE, <!--- Tolerans Degeri Date --->
										QUALITY_VALUE, <!--- Sonuc Durumu, Kabul Red --->
										OR_Q_ID, <!--- Bagli Belge Id --->
										SERIAL <!--- Seri No --->
									)
									VALUES
									(
										<cfif isdefined("attributes.detail_#_ind_#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.detail_#_ind_#")#"><cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#_ind_#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rowlist#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#qsc#">,
										<cfif isDefined("quality_rule") and quality_rule eq 0 and len(quality_result_)><cfqueryparam cfsqltype="cf_sql_float" value="#quality_result_#"><cfelse>NULL</cfif>,
										<cfif isDefined("quality_rule") and quality_rule eq 2 and len(quality_result_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#quality_result_#"><cfelse>NULL</cfif>,
                                        <cfif isDefined("quality_rule") and quality_rule eq 1 and len(quality_result_)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#quality_result_#"><cfelse>NULL</cfif>,
                                        <cfif isdefined("attributes.quality_result_value_#_ind_#_#rowlist#_#qsc#") and len(Evaluate("attributes.quality_result_value_#_ind_#_#rowlist#_#qsc#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("attributes.quality_result_value_#_ind_#_#rowlist#_#qsc#")#"><cfelse>NULL</cfif>,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">,
										<cfif isdefined("attributes.serial_number_#qsc#") and len(Evaluate("attributes.serial_number_#qsc#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.serial_number_#qsc#")#"><cfelse>NULL</cfif>
									)
							</cfquery>
						</cfloop>
					</cfloop>
					</cfif>
				</cfloop>
			<cfelse>
                <cfloop list="#attributes.quality_type_list#" index="_ind_">
					<cfif isDefined("attributes.quality_rule_#_ind_#") and len(Evaluate("attributes.quality_rule_#_ind_#"))>
						<cfset quality_rule = Evaluate("attributes.quality_rule_#_ind_#")>
						<cfif isDefined("quality_rule") and quality_rule eq 0 and isdefined("attributes.result_#_ind_#") and Len(Evaluate("attributes.result_#_ind_#"))>
							<cfset result_ = filterNum(Evaluate("attributes.result_#_ind_#"),4)>
						<cfelseif isDefined("quality_rule") and quality_rule eq 2 and isdefined("attributes.result_#_ind_#") and Len(Evaluate("attributes.result_#_ind_#")) >
							<cfset result_ = Evaluate("attributes.result_#_ind_#")>
						<cfelseif isDefined("quality_rule") and quality_rule eq 1 and isdefined("attributes.result_#_ind_#") and Len(Evaluate("attributes.result_#_ind_#")) >
						<cfset result_ = dateformat(Evaluate("attributes.result_#_ind_#"),dateformat_style)>
						<cf_date tarih='result_'>
						<cfelse>
							<cfset result_ = "">
						</cfif>
					
					<cfquery name="ADD_ORDER_RESULT_QUALITY_ROW" datasource="#DSN3#">
					INSERT INTO
						ORDER_RESULT_QUALITY_ROW
						(
							QUALITY_DETAIL,
							QUALITY_VALUE,
							CONTROL_TYPE_ID,
							CONTROL_ROW_ID,
							CONTROL_RESULT,
                            CONTROL_RESULT_TEXT,
                            CONTROL_RESULT_DATE,
							OR_Q_ID,
							BRAND,
							MODEL
						)
						VALUES
						(
							<cfif isdefined("attributes.detail_#_ind_#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.detail_#_ind_#")#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.QUALITY_VALUE_#_ind_#")><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("attributes.QUALITY_VALUE_#_ind_#")#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#_ind_#">,
							<cfif isdefined("attributes.QUALITY_CONTROL_ROW_ID_#_ind_#")><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate("attributes.QUALITY_CONTROL_ROW_ID_#_ind_#")#"><cfelse>NULL</cfif>,
							<cfif isDefined("quality_rule") and quality_rule eq 0 and len(result_)><cfqueryparam cfsqltype="cf_sql_float" value="#result_#"><cfelse>NULL</cfif>,
                            <cfif isDefined("quality_rule") and quality_rule eq 2 and len(result_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#result_#"><cfelse>NULL</cfif>,
                            <cfif isDefined("quality_rule") and quality_rule eq 1 and len(result_)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#result_#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.OR_Q_ID#">,
							<cfif isdefined("attributes.brand_#_ind_#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.brand_#_ind_#")#"><cfelse>NULL</cfif>,
							<cfif isdefined("attributes.model_#_ind_#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate("attributes.model_#_ind_#")#"><cfelse>NULL</cfif>
						)
					</cfquery>
					</cfif>
		        </cfloop>
				<cfloop from="1" to="#row_count#" index="ind">
					<cfif isDefined("attributes.q_success_id#ind#") and Len(Evaluate('attributes.q_success_id#ind#'))><cfset q_success_id = Evaluate('attributes.q_success_id#ind#')><cfelse><cfset q_success_id =""></cfif>
					<cfif isDefined("attributes.success_amount#ind#") and Len(Evaluate('attributes.success_amount#ind#'))><cfset success_amount = filterNum(Evaluate('attributes.success_amount#ind#'))><cfelse><cfset success_amount =0></cfif>
					<cfquery name="add_quality_success" datasource="#dsn3#">
						UPDATE 
							ORDER_RESULT_QUALITY_SUCCESS_TYPE
						SET
								AMOUNT = <cfif isdefined('success_amount') and len("success_amount")><cfqueryparam cfsqltype="cf_sql_float" value="#success_amount#"><cfelse>NULL</cfif>,
								UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								RECORD_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						WHERE
							SUCCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_success_id#"> 
							AND ORDER_RESULT_QUALITY_ID = #attributes.OR_Q_ID#
					</cfquery>
				</cfloop>
			  </cfif>
			  <cfif isDefined("attributes.process_stage") and Len(attributes.process_stage)>
				<cf_workcube_process 
					is_upd='1' 
					data_source='#dsn3#' 
					old_process_line='0'
					process_stage='#attributes.process_stage#'
					record_member='#session.ep.userid#' 
					record_date='#now()#' 
					action_table='ORDER_RESULT_QUALITY'
					action_column='OR_Q_ID'
					action_id='#attributes.OR_Q_ID#'
					action_page='#request.self#?fuseaction=stock.list_quality_controls&event=upd&or_q_id=#attributes.OR_Q_ID#' 
					warning_description='Kalite : #attributes.q_control_no#'>
				</cfif>

		</cftransaction>    
	</cflock>
	<script type="text/javascript">
		<cfif isDefined('attributes.draggable')>
			location.href= document.referrer;
		<cfelse>
			location.href="<cfoutput>#request.self#?fuseaction=stock.list_quality_controls&event=upd&or_q_id=#attributes.OR_Q_ID#</cfoutput>"
		</cfif>
	</script>
</cfif>
<cfset attributes.actionId = attributes.OR_Q_ID >

