<cfquery name="get_pos" datasource="#dsn3#">
	SELECT * FROM POS_EQUIPMENT WHERE POS_ID = #attributes.pos_id#
</cfquery>

<cfquery name="UPD_POS" datasource="#DSN3#">
	DELETE FROM
		POS_EQUIPMENT
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>

<cf_add_log  log_type="-1" action_id="#attributes.pos_id#" action_name="Yazar Kasa Silme : #get_pos.EQUIPMENT# #get_pos.EQUIPMENT_CODE#">

<cflocation url="#request.self#?fuseaction=finance.list_pos_equipment" addtoken="no">
