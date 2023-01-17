<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.event eq 'del'>
			<cfquery name = "get_wizard_block" datasource = "#dsn#">
				SELECT WIZARD_BLOCK_ID FROM ACCOUNT_WIZARD_BLOCK WHERE WIZARD_ID = #attributes.wizard_id#
			</cfquery>
			<cfif len(get_wizard_block.wizard_block_id)>
				<cfquery name = "del_wizard_block_row" datasource = "#dsn#">
					DELETE FROM ACCOUNT_WIZARD_BLOCK_ROW WHERE WIZARD_BLOCK_ID IN (#valueList(get_wizard_block.wizard_block_id)#)
				</cfquery>
			</cfif>
			<cfquery name = "del_wizard_block" datasource = "#dsn#">
				DELETE FROM ACCOUNT_WIZARD_BLOCK WHERE WIZARD_ID = #attributes.wizard_id#
			</cfquery>
			<cfquery name = "del_wizard" datasource = "#dsn#">
				DELETE FROM ACCOUNT_WIZARD WHERE WIZARD_ID = #attributes.wizard_id#
			</cfquery>
		<cfelse>
			<cf_date tarih = "attributes.process_date">

			<cfif attributes.wizard_id eq ''>
				<cfquery name = "add_wizard" datasource = "#dsn#">
					INSERT INTO
						ACCOUNT_WIZARD
					(
						WIZARD_NAME,
						WIZARD_DESIGNER,
						WIZARD_STAGE,
						WIZARD_DATE,
						PERIOD_MONTH,
						PERIOD_DAY,
						CARD_PROCESS_CAT,
						TARGET_TYPE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					) VALUES (
						'#attributes.wizard_name#',
						'#attributes.employee_id#',
						'#attributes.process_stage#',
						#attributes.process_date#,
						'#attributes.run_period#',
						'#attributes.period_day#',
						'#attributes.process_cat#',
						'#attributes.target_type#',
						'#session.ep.userid#',
						'#cgi.remote_addr#',
						#now()#
					)

					SELECT SCOPE_IDENTITY() AS MAX_ID
				</cfquery>
				<cfset attributes.wizard_id = add_wizard.max_id>
			<cfelse>
				<cfquery name = "add_wizard" datasource = "#dsn#">
					UPDATE
						ACCOUNT_WIZARD
					SET
						WIZARD_NAME = '#attributes.wizard_name#',
						WIZARD_DESIGNER = '#attributes.employee_id#',
						WIZARD_STAGE = '#attributes.process_stage#',
						WIZARD_DATE = #attributes.process_date#,
						UPDATE_EMP = '#session.ep.userid#',
						UPDATE_IP = '#cgi.remote_addr#',
						UPDATE_DATE = #now()#,
						PERIOD_MONTH = '#attributes.run_period#',
						PERIOD_DAY = '#attributes.period_day#',
						CARD_PROCESS_CAT = '#attributes.process_cat#',
						TARGET_TYPE = '#attributes.target_type#'
					WHERE
						WIZARD_ID = #attributes.wizard_id#
				</cfquery>
			</cfif>

			<cfquery name = "get_wizard_block" datasource = "#dsn#">
				SELECT WIZARD_BLOCK_ID FROM ACCOUNT_WIZARD_BLOCK WHERE WIZARD_ID = #attributes.wizard_id#
			</cfquery>
			<cfquery name = "del_wizard_block" datasource = "#dsn#">
				DELETE FROM ACCOUNT_WIZARD_BLOCK WHERE WIZARD_ID = #attributes.wizard_id#
			</cfquery>
			<cfif len(get_wizard_block.wizard_block_id)>
				<cfquery name = "del_wizard_block_row" datasource = "#dsn#">
					DELETE FROM ACCOUNT_WIZARD_BLOCK_ROW WHERE WIZARD_BLOCK_ID IN (#valueList(get_wizard_block.wizard_block_id)#)
				</cfquery>
			</cfif>

			<cfloop from = "1" to = "#attributes.rowcount#" index = "r">
				<cfif evaluate("attributes.row_kontrol_#r#") eq 1>
					<cfquery name = "add_wizard_block" datasource = "#dsn#">
						INSERT INTO
							ACCOUNT_WIZARD_BLOCK
						(
							WIZARD_ID,
							BLOCK_NAME,
							BLOCK_BA
						) VALUES (
							#attributes.wizard_id#,
							'#evaluate("attributes.block_name_#r#")#',
							'#evaluate("attributes.block_type_#r#")#'
						)
						SELECT SCOPE_IDENTITY() AS MAX_BLOCK_ID
					</cfquery>

					<cfloop from = "1" to = "4" index = "c">
						<cfloop from = "1" to = "#evaluate('attributes.counter_#r#_#c#')#" index = "a">
							<cfquery name = "add_wizard_block_row" datasource = "#dsn#">
								INSERT INTO
									ACCOUNT_WIZARD_BLOCK_ROW
								(
									WIZARD_BLOCK_ID,
									BLOCK_COLUMN,
									ACCOUNT_CODE,
									RATE,
									DESCRIPTION,
									ACTION_TYPE
								) VALUES (
									#add_wizard_block.max_block_id#,
									#c#,
									'#evaluate("acc_#r#_#c#_#a#")#',
									'#evaluate("rate_#r#_#c#_#a#")#',
									'#evaluate("desc_#r#_#c#_#a#")#',
									<cfif len(evaluate("action_type_hidden_#r#_#c#_#a#"))>'#evaluate("action_type_hidden_#r#_#c#_#a#")#'<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfloop>
					</cfloop>
				</cfif>
			</cfloop>
			<cfset attributes.actionId = attributes.wizard_id>
		</cfif>
	</cftransaction>
</cflock>