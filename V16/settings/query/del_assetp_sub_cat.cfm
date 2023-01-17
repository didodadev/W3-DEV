<cfquery name="DEL_SUB_CAT" datasource="#DSN#">
	DELETE FROM ASSET_P_SUB_CAT WHERE ASSETP_SUB_CATID = #attributes.sub_cat#
</cfquery>
<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.add_assetp_sub_cat" addtoken="no">
