

<cfsetting showdebugoutput="no">				
<cflock name="#createUUID()#" timeout="20">
		<cftransaction>			
					<cfset row_count=Evaluate("attributes.row_count_#j#_#stock_id#")>
					<cfloop from="1" to="#row_count#" index="i">
						<cfset amount=filterNum(Evaluate("attributes.amount_#j#_#i#"))>
						<cfset product_id_=Evaluate("attributes.product_id_#j#_#i#")>
						<cfset operation_type_id=Evaluate("attributes.operation_type_id_#j#_#i#")>
							<cfif len(amount) and (len(product_id_) or len(operation_type_id))>
								<cfset row_status=Evaluate("attributes.row_status_#j#_#i#")>
								<cfset amount=filterNum(Evaluate("attributes.amount_#j#_#i#"))>
								<cfset related_id=Evaluate("attributes.related_id_#j#_#i#")>
								<cfset product_id_=Evaluate("attributes.product_id_#j#_#i#")>
								<cfset product_name_=Evaluate("attributes.product_name_#j#_#i#")>
								<cfset old_related_id=Evaluate("attributes.old_related_id_#j#_#i#")>
								<cfset old_product_id=Evaluate("attributes.old_product_id_#j#_#i#")>
								<cfset old_product_name=Evaluate("attributes.old_product_name_#j#_#i#")>
								<cfset is_tree=Evaluate("attributes.is_tree_#j#_#i#")>
								<cfset unit_id=Evaluate("attributes.unit_id_#j#_#i#")>
								<cfset is_configure=Evaluate("attributes.is_configure_#j#_#i#")>
								<cfset is_sevk=Evaluate("attributes.is_sevk_#j#_#i#")>
								<cfset spect_main_id=Evaluate("attributes.spect_main_id_#j#_#i#")>
								<cfset line_number=Evaluate("attributes.line_number_#j#_#i#")>
								
								<cfset is_phantom=Evaluate("attributes.is_phantom_#j#_#i#")>
								<cfset process_stage=Evaluate("attributes.process_stage_#j#_#i#")>
										<cfquery name="get_spect_main" datasource="#dsn3#">
												SELECT  * FROM SPECT_MAIN SM WHERE  SM.STOCK_ID = #stock_id# AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
											</cfquery>
									<cfif isdefined("attributes.new_row_#j#_#i#") and row_status eq 1>
											
										<cfquery name="add_tree" datasource="#dsn3#" result="MAX_ID">
											INSERT INTO [PRODUCT_TREE]
												   (
													[RELATED_ID]
												   ,[PRODUCT_ID]
												   ,[IS_TREE]
												   ,[AMOUNT]
												   ,[UNIT_ID]
												   ,[STOCK_ID]
												   ,[IS_CONFIGURE]
												   ,[IS_SEVK]
												   ,[SPECT_MAIN_ID]
												   ,[LINE_NUMBER]
												   ,[OPERATION_TYPE_ID]
												   ,[IS_PHANTOM]
												   ,[PROCESS_STAGE]
												   ,[RECORD_EMP]
												   ,[RECORD_DATE]
												 )
											values(
													<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
													<cfif len(product_id_)>#product_id_#<cfelse>NULL</cfif>,
													<cfif len(is_tree)>#is_tree#<cfelse>NULL</cfif>,
													<cfif len(amount)>#amount#<cfelse>NULL</cfif>,
													<cfif len(unit_id)>#unit_id#<cfelse>NULL</cfif>,
													<cfif len(stock_id)>#stock_id#<cfelse>NULL</cfif>,
													<cfif len(is_configure)>#is_configure#<cfelse>NULL</cfif>,
													<cfif len(is_sevk)>#is_sevk#<cfelse>NULL</cfif>,
													<cfif len(spect_main_id)>#spect_main_id#<cfelse>NULL</cfif>,
													<cfif len(line_number)>#line_number#<cfelse>NULL</cfif>,
													<cfif len(operation_type_id) and operation_type_id gt 0>#operation_type_id#<cfelse>NULL</cfif>,
													<cfif len(is_phantom)>#is_phantom#<cfelse>NULL</cfif>,
													<cfif len(process_stage)>#process_stage#<cfelse>NULL</cfif>,
													#session.ep.userid#,
													#now()#
													)
										</cfquery>
										<cfloop query="get_spect_main">
														<cfquery name="ADD_ROW" datasource="#dsn3#">
															INSERT INTO
																SPECT_MAIN_ROW
																(
																	SPECT_MAIN_ID,
																	PRODUCT_ID,
																	STOCK_ID,
																	AMOUNT,
																	PRODUCT_NAME,
																	IS_PROPERTY,
																	IS_CONFIGURE,
																	IS_SEVK,
																	PROPERTY_ID,
																	VARIATION_ID,
																	TOTAL_MIN,
																	TOTAL_MAX,
																	TOLERANCE,
																	PRODUCT_SPACE,
																	PRODUCT_DISPLAY,
																	PRODUCT_RATE,
																	PRODUCT_LIST_PRICE,
																	CALCULATE_TYPE,
																	RELATED_MAIN_SPECT_ID,
																	RELATED_MAIN_SPECT_NAME,
																	LINE_NUMBER,
																	CONFIGURATOR_VARIATION_ID,
																	DIMENSION,
																	RELATED_TREE_ID,
																	OPERATION_TYPE_ID,
																	QUESTION_ID
																)
																VALUES
																(
																	#get_spect_main.spect_main_id#,
																	<cfif len(product_id_)>#product_id_#<cfelse>NULL</cfif>,
																	<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
																	<cfif len(amount)>#amount#<cfelse>NULL</cfif>,
																		<cfif len(product_name_)>'#product_name_#'<cfelse>NULL</cfif>,
																	0,
																	0,
																	0,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	NULL,
																	0,
																	NULL,
																	NULL,
																	#MAX_ID.IDENTITYCOL#,
																	NULL,
																	NULL											
																)
														</cfquery>		
													</cfloop>
								<cfelseif not isdefined("attributes.new_row_#j#_#i#") and row_status eq 1>
											<cfset product_tree_id=Evaluate("attributes.product_tree_id_#j#_#i#")>
													<cfquery name="upd_tree" datasource="#dsn3#">
															UPDATE [PRODUCT_TREE]
															SET
																	[RELATED_ID]=<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>
																   ,[PRODUCT_ID]=<cfif len(product_id_)>#product_id_#<cfelse>NULL</cfif>
																   ,[IS_TREE]=<cfif len(is_tree)>#is_tree#<cfelse>NULL</cfif>
																   ,[AMOUNT]=<cfif len(amount)>#amount#<cfelse>NULL</cfif>
																   ,[UNIT_ID]=<cfif len(unit_id)>#unit_id#<cfelse>NULL</cfif>
																   ,[STOCK_ID]=<cfif len(stock_id)>#stock_id#<cfelse>NULL</cfif>
																   ,[IS_CONFIGURE]=<cfif len(is_configure)>#is_configure#<cfelse>NULL</cfif>
																   ,[IS_SEVK]=<cfif len(is_sevk)>#is_sevk#<cfelse>NULL</cfif>
																   ,[SPECT_MAIN_ID]=<cfif len(spect_main_id)>#spect_main_id#<cfelse>NULL</cfif>
																 <!--- ,[LINE_NUMBER]=<cfif len(line_number)>#line_number#<cfelse>NULL</cfif>--->
																   ,[OPERATION_TYPE_ID]=<cfif len(operation_type_id) and operation_type_id gt 0>#operation_type_id#<cfelse>NULL</cfif>
																   ,[IS_PHANTOM]=<cfif len(is_phantom)>#is_phantom#<cfelse>NULL</cfif>
																   ,[PROCESS_STAGE]=<cfif len(process_stage)>#process_stage#<cfelse>NULL</cfif>
																   ,[UPDATE_EMP]=#session.ep.userid#
																   ,[UPDATE_DATE]=#now()#
															WHERE 
																PRODUCT_TREE_ID=#product_tree_id#
													</cfquery>
															<cfloop query="get_spect_main">
																	<cfquery name="get_spect_main_row" datasource="#dsn3#">
																		select *from SPECT_MAIN_ROW
																		WHERE 
																			SPECT_MAIN_ID = #get_spect_main.SPECT_MAIN_ID# 
																			AND STOCK_ID = #old_related_id#
																	</cfquery>
																<cfif get_spect_main_row.recordCount gt 0>
																	<cfquery name="upd_spect_main_row" datasource="#dsn3#">
																		UPDATE
																			SPECT_MAIN_ROW
																		SET
																			STOCK_ID = <cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
																			PRODUCT_ID = <cfif len(product_id_)>#product_id_#<cfelse>NULL</cfif>,
																			PRODUCT_NAME = <cfif len(product_name_)>'#product_name_#'<cfelse>NULL</cfif>,
																			AMOUNT=<cfif len(amount)>#amount#<cfelse>NULL</cfif>
																		WHERE 
																			SPECT_MAIN_ID = #get_spect_main.SPECT_MAIN_ID# 
																			AND STOCK_ID = #old_related_id#
																	</cfquery>
																<cfelse>
																	<cfquery name="ADD_ROW" datasource="#dsn3#">
																		INSERT INTO
																			SPECT_MAIN_ROW
																			(
																				SPECT_MAIN_ID,
																				PRODUCT_ID,
																				STOCK_ID,
																				AMOUNT,
																				PRODUCT_NAME,
																				IS_PROPERTY,
																				IS_CONFIGURE,
																				IS_SEVK,
																				PROPERTY_ID,
																				VARIATION_ID,
																				TOTAL_MIN,
																				TOTAL_MAX,
																				TOLERANCE,
																				PRODUCT_SPACE,
																				PRODUCT_DISPLAY,
																				PRODUCT_RATE,
																				PRODUCT_LIST_PRICE,
																				CALCULATE_TYPE,
																				RELATED_MAIN_SPECT_ID,
																				RELATED_MAIN_SPECT_NAME,
																				LINE_NUMBER,
																				CONFIGURATOR_VARIATION_ID,
																				DIMENSION,
																				RELATED_TREE_ID,
																				OPERATION_TYPE_ID,
																				QUESTION_ID
																			)
																			VALUES
																			(
																				#get_spect_main.spect_main_id#,
																				<cfif len(product_id_)>#product_id_#<cfelse>NULL</cfif>,
																				<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
																				<cfif len(amount)>#amount#<cfelse>NULL</cfif>,
																					<cfif len(product_name_)>'#product_name_#'<cfelse>NULL</cfif>,
																				0,
																				0,
																				0,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				NULL,
																				0,
																				NULL,
																				NULL,
																				#product_tree_id#,
																				NULL,
																				NULL											
																			)
																	</cfquery>	
																</cfif>
															
															
															</cfloop>
								<cfelseif row_status eq 0>
													<cfset product_tree_id=Evaluate("attributes.product_tree_id_#j#_#i#")>
													<cfquery name="del_tree" datasource="#dsn3#">
														delete [PRODUCT_TREE]
														where PRODUCT_TREE_ID=#product_tree_id#
													</cfquery>
														<cfloop query="get_spect_main">
																	<cfquery name="del_spect_main_row" datasource="#dsn3#">
																		DELETE
																			SPECT_MAIN_ROW
																		WHERE 
																			SPECT_MAIN_ID = #get_spect_main.SPECT_MAIN_ID# 
																			AND STOCK_ID = #old_related_id#
																	</cfquery>
														</cfloop>
								</cfif>
							
					</cfif>
					</cfloop>
				</cftransaction>
				</cflock>

