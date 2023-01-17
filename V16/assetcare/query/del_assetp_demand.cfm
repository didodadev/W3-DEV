
<cfquery name="del_demand" datasource="#dsn#">
	DELETE FROM ASSET_P_DEMAND WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
</cfquery>

 <script type="text/javascript">
  <cfif is_popup eq 1>
	window.document.location.href='/index.cfm?fuseaction=myhome.list_assetp';
<cfelse>
	window.document.location.href='/index.cfm?fuseaction=assetcare.list_assetp_demands';
	
          
	</cfif>
</script>

