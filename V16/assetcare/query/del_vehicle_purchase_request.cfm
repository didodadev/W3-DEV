<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
	SELECT
		REQUEST_ROW_ID,
		REQUEST_STATE
	FROM
		ASSET_P_REQUEST_ROWS
	WHERE
		REQUEST_ID = #attributes.request_id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="DEL_REQUESTS_ROWS" datasource="#DSN#">
		DELETE FROM 
			ASSET_P_REQUEST_ROWS
		WHERE 
			REQUEST_ROW_ID = #attributes.request_row_id#
	</cfquery>
  	<cfif get_request_rows.recordcount eq 1>
	  <cfquery name="DEL_REQUEST" datasource="#DSN#">
		DELETE FROM 
			ASSET_P_REQUEST
		WHERE
			REQUEST_ID = #attributes.request_id#
	  </cfquery>
  	</cfif>
	<cf_add_log log_type="-1" action_id="#attributes.request_row_id#" action_name="#attributes.head#" process_stage="#get_request_rows.request_state#">
  </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=assetcare.vehicle_request_search&form_submitted=1" addtoken="no">
