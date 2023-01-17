<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_QUALITY_REPORT" datasource="#DSN3#">
			UPDATE 
				QUALITY_CONTROL_DETAIL
			SET
				CONTROL_TYPE=<cfif len(ATTRIBUTES.QUALITY_CONTROL_TYPE)>#ATTRIBUTES.TYPE_ID#,<cfelse>NULL,</cfif>
				CONTROL_AUTHOR_TYPE=<cfif len(ATTRIBUTES.EMPLOYEE_ID)>'employee',<cfelseif len(ATTRIBUTES.PARTNER_ID)>'partner',<cfelseif len(ATTRIBUTES.CONSUMER_ID)>'consumer',</cfif>
				CONTROL_AUTHOR=<cfif len(ATTRIBUTES.EMPLOYEE_ID)>#ATTRIBUTES.EMPLOYEE_ID#,<cfelseif len(ATTRIBUTES.PARTNER_ID)>#ATTRIBUTES.PARNER_ID#,<cfelseif len(ATTRIBUTES.CONSUMER_ID)>#ATTRIBUTES.CONSUMER_ID#,</cfif>
				PRODUCT_ID=<cfif isdefined("ATTRIBUTES.GET_PRODUCT_ID") and len(ATTRIBUTES.GET_PRODUCT_ID)>#ATTRIBUTES.GET_PRODUCT_ID#,<cfelse>#ATTRIBUTES.service_product_id#,</cfif>
				DETAIL=<cfif len(ATTRIBUTES.DETAIL)>'#ATTRIBUTES.DETAIL#',<cfelse>NULL,</cfif>
				STOCK_ID=<cfif len(ATTRIBUTES.STOCK_ID)>#ATTRIBUTES.STOCK_ID#,<cfelse>NULL,</cfif>
				PRODUCTION_ORDER_ID=<cfif len(ATTRIBUTES.STATION_ID_ORDER)>#ATTRIBUTES.STATION_ID_ORDER#,<cfelseif isdefined("ATTRIBUTES.P_ORDER_ID")>#ATTRIBUTES.P_ORDER_ID#,<cfelse>null,</cfif>
				SUCCESS_ID=<cfif len(ATTRIBUTES.QUALITY_SUCCESS)>#ATTRIBUTES.QUALITY_SUCCESS#,<cfelse>NULL,</cfif>
				RECORD_DATE=#NOW()#,
				RECORD_EMP=#SESSION.EP.USERID#,
				RECORD_IP='#CGI.REMOTE_ADDR#',
				WORKSTATION_ID=<cfif isdefined("attributes.STATION_ID") and len(attributes.STATION_ID)>#attributes.STATION_ID#<cfelse>NULL</cfif>
			WHERE
				CONTROL_ID=#URL.ID#
		</cfquery>
		<cfif len(attributes.type_id)>
			<cfquery name="GET_QUALITY_CONTROL_ROW" datasource="#DSN3#">
				SELECT
					*
				FROM
					QUALITY_CONTROL_ROW
				WHERE
					QUALITY_CONTROL_TYPE_ID=#ATTRIBUTES.TYPE_ID#
			</cfquery>
			<cfloop query="get_quality_control_row">
				<cfquery name="ADD_QUALITY_CONTROL_SUCCESS_ROW" datasource="#DSN3#">
					UPDATE 
						QUALITY_CONTROL_SUCCESS_ROW
					SET
						QUALITY_CONTROL_ROW_ID=#attributes.control_row_id#,
						QUALITY_SUCCESS_ID=#URL.ID#,
						SUCCESS_ROW_RESULT='#wrk_eval("attributes.quality_control_row_id"&currentrow)#',
						RECORD_DATE=#NOW()#,
						RECORD_EMP=#SESSION.EP.USERID#,
						RECORD_IP='#CGI.REMOTE_ADDR#'
					WHERE
						QUALITY_SUCCESS_ID=#URL.ID#
				</cfquery>
			</cfloop>
		</cfif>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cftransaction>
</cflock>
