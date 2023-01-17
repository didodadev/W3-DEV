<!--- Bireysel Uye Sayfasi--->
<cfif isdefined("attributes.cid") or isdefined("session.ww.userid")>
	<cfset table_name = "CONSUMER_BANK">
	<cfset column_name = "CONSUMER_BANK_ID">
<!--- Kurumsal Uye Sayfasi --->	
<cfelseif isdefined("attributes.cpid")>
	<cfset table_name = "COMPANY_BANK">
	<cfset column_name = "COMPANY_BANK_ID">
<!--- Calisan Detay --->	
<cfelseif isdefined("employee_id")>
	<cfset table_name = "EMPLOYEES_BANK_ACCOUNTS">
	<cfset column_name = "EMP_BANK_ID">
</cfif>
<cfquery name="DEL_CONS_BANK" datasource="#DSN#">
	DELETE FROM
		#table_name#
	WHERE 
		#column_name# = #attributes.bid#
</cfquery>

<script>
	<cfif isDefined('attributes.draggable')>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'emp_bank_accounts');
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>
