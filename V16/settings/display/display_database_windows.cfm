<cfif isdefined("attributes.action_type")>
	<cfswitch expression="#attributes.action_type#">
		<!--- TABLO LISTESI --->
		<cfcase value="table_list">
			<cfinclude template="../display/table_list.cfm">
		</cfcase>
		<!--- DATABASE IZIN LISTESI --->
		<cfcase value="login_access_list">
			<cfinclude template="../display/login_access_list.cfm">
		</cfcase>
		<!--- COLUMN LISTESI --->
		<cfcase value="column_list">
			<cfinclude template="../display/column_list.cfm">
		</cfcase>
	</cfswitch>
</cfif>
