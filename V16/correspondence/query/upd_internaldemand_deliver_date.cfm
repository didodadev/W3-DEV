<cfif isdefined("attributes.row_order_id") and Len(attributes.row_order_id) and isdefined("attributes.row_deliver_date") and Len(attributes.row_deliver_date)>
	<cf_date tarih="attributes.row_deliver_date">
	<cfquery name="get_i_id" datasource="#dsn3#">
		SELECT TOP 1 INTERNALDEMAND_ROW.I_ID FROM INTERNALDEMAND_ROW WHERE INTERNALDEMAND_ROW.I_ROW_ID = #attributes.row_order_id#
	</cfquery>
	<cfquery name="UPD_ROW" datasource="#dsn3#">
		UPDATE
			INTERNALDEMAND_ROW
		SET
			DELIVER_DATE = #attributes.row_deliver_date#
		WHERE
			I_ROW_ID = #attributes.row_order_id#
	</cfquery>
	<cfquery name="UPD_DEMAND" datasource="#dsn3#">
		UPDATE
			INTERNALDEMAND
		SET
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#
		WHERE
			INTERNAL_ID = #get_i_id.I_ID#
	</cfquery>
</cfif>
