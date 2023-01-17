<cfquery name="GET_OFFTIME_EMP_COUNT" datasource="#DSN#">
	SELECT OFFTIMECAT_ID FROM OFFTIME WHERE OFFTIMECAT_ID=#attributes.ID#
</cfquery>
<cfinclude template="../form/upd_offtime.cfm">
