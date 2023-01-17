<cfquery name="get_rates" datasource="#dsn3#">
	SELECT 
		WRR.WAREHOUSE_TASK_TYPE_ID,
		WRR.RATE_CODE,
		WTT.WAREHOUSE_TASK_TYPE,
		WTT.WAREHOUSE_TASK_TYPE_ORDER,
		WRR.RATE_INFO
	FROM
		WAREHOUSE_RATES WR,
		WAREHOUSE_RATES_ROWS WRR,
		#dsn_alias#.WAREHOUSE_TASK_TYPES WTT
	WHERE 
		WRR.WAREHOUSE_TASK_TYPE_ID = WTT.WAREHOUSE_TASK_TYPE_ID AND
		WR.RATE_ID = WRR.RATE_ID AND
		WR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		WR.ACTION_DATE < #NOW()#
		<cfif attributes.task_in_out eq 1>
			AND WTT.IS_SHIPMENT = 1
		</cfif>
		<cfif attributes.task_in_out eq 0>
			AND WTT.IS_RECEIVING = 1
		</cfif>
		<cfif attributes.task_in_out eq 2 or attributes.task_in_out eq 3>
			AND WTT.WAREHOUSE_TASK_TYPE_ID IS NULL
		</cfif>
	ORDER BY
		WTT.WAREHOUSE_TASK_TYPE_ORDER ASC
</cfquery>

<cfif isdefined("get_rates") and get_rates.recordcount>
	<label>
		<b><cf_get_lang dictionary_id="39892.Services"></b>
	</label>
	<input type="hidden" name="rate_code_list" value="<cfoutput>#valuelist(get_rates.rate_code)#</cfoutput>">
		<cfoutput query="get_rates">
			<div class="form-group" id="item-services">
						<label class="col col-4">#WAREHOUSE_TASK_TYPE#</label>
						<input type="hidden" name="rate_type_id_#rate_code#" value="#WAREHOUSE_TASK_TYPE_ID#">
						<div class="col col-8 col-xs-12">
						<select name="rate_row_#rate_code#">
							<cfloop from="0" to="100" index="i">
								<option value="#i#">#i#</option>
							</cfloop>
						</select>
			</div></div>
		</cfoutput>
		<div class="form-group" id="item-services">
			<label class="col col-4"><cf_get_lang dictionary_id="58156.Diğer"></label>
			<div class="col col-5 col-xs-12">
					<input type="text" name="other_detail" id="other_detail" value="">									
				</div><div class="col col-3 col-xs-12">
						<select name="other_amount">
							<cfloop from="0" to="100" index="i">
								<cfoutput><option value="#i#">#i#</option></cfoutput>
							</cfloop>
						</select>
					</div>
	
		</div>
</cfif>