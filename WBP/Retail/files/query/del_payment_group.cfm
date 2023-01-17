<cfquery name="Del_Payment_Group" datasource="#dsn_dev#">
	DELETE FROM PAYMENT_GROUP WHERE PAYMENT_GROUP_ID = #attributes.group_id#
</cfquery>

<cfquery name="Del_Payment_Group_Row" datasource="#dsn_dev#">
	DELETE FROM PAYMENT_GROUP_ROW WHERE PAYMENT_GROUP_ID = #attributes.group_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=retail.list_payment_group" addtoken="no">