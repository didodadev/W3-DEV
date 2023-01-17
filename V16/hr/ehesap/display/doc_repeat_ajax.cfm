<cfsetting showdebugoutput="no">
<!--- <cfoutput>EMP=#attributes.employee_id#<br/>REPEAT=#attributes.IS_REPEAT#</cfoutput>
 --->
<cfquery name="upd_doc_repeat" datasource="#dsn#">
	UPDATE
		EMPLOYEES_IN_OUT
	SET
		DOC_REPEAT = #attributes.IS_REPEAT#
	WHERE 
		EMPLOYEE_ID=#attributes.employee_id# AND
		IN_OUT_ID=#attributes.in_out_id#
</cfquery>
