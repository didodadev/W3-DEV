<!--- notlar --->
<cfquery name="DEL_NOTES" datasource="#DSN#">
	DELETE FROM
		NOTES
	WHERE
		ACTION_SECTION = 'LIST_ROW_ID'
		AND	ACTION_ID IN (SELECT LIST_ROW_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#attributes.list_id#)
</cfquery>

<!--- yazışmalar --->
<cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
	DELETE FROM EMPLOYEES_APP_MAILS WHERE EMPAPP_ID = #attributes.list_id#
</cfquery>

<!--- yetkililer --->
<cfquery name="DEL_AUTHORITY" datasource="#dsn#">
	DELETE FROM
		EMPLOYEES_APP_AUTHORITY
	WHERE
		LIST_ID=#attributes.list_id#
</cfquery>

<cfquery name="del_select_list_rows" datasource="#dsn#">
	DELETE FROM
		EMPLOYEES_APP_SEL_LIST_ROWS
	WHERE
		LIST_ID=#attributes.list_id#
</cfquery>

<cfquery name="del_select_list" datasource="#dsn#">
	DELETE FROM
		EMPLOYEES_APP_SEL_LIST
	WHERE
		LIST_ID=#attributes.list_id#
</cfquery>
<!---<cflocation url="#request.self#?fuseaction=hr.emp_app_select_list" addtoken="No">--->
<script type="text/javascript">
	opener.location.href='<cfoutput>#request.self#?fuseaction=hr.emp_app_select_list</cfoutput>';
	window.close();
</script>
