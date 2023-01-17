<cfquery name="GET_FUSE" datasource="#DSN#"> 
	SELECT 
		FUSEACTION,
		MODUL_SHORT_NAME
	FROM
		WRK_OBJECTS
	WHERE
		WRK_OBJECTS_ID = #attributes.woid# 
</cfquery>

<cfloop list="#attributes.wrk_ids#" index="k" >
	<cfquery name="UPD_FUSEACTION_REL" datasource="#DSN#">
		UPDATE
			WRK_OBJECTS
		SET
			RELATED_FUSEACTION = '#get_fuse.fuseaction#',
			RELATED_MODUL_SHORT_NAME = '#get_fuse.modul_short_name#'
		WHERE
			WRK_OBJECTS_ID = #k#
	</cfquery>
</cfloop>

<!---<cflocation url="#request_self#?fuseaction=dev.upd_fuseaction&woid=#attributes.woid#" >--->
