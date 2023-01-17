<cfif listgetat(attributes.fuseaction,1,'.') eq 'myhome'>
    <cfset TRAVEL_DEMAND_ID = contentEncryptingandDecodingAES(isEncode:0,content:attributes.travel_demand_id,accountKey:'wrk')>
<cfelse>
    <cfset TRAVEL_DEMAND_ID = attributes.travel_demand_id>
</cfif>
<cfquery name="del_travel_demand" datasource="#DSN#">
	DELETE FROM EMPLOYEES_TRAVEL_DEMAND WHERE TRAVEL_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAVEL_DEMAND_ID#">
</cfquery>
<script type="text/javascript">
  <cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	window.location.href="<cfoutput>#request.self#?fuseaction=myhome.list_travel_demands</cfoutput>";
    <cfelse>
        window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_travel_demands</cfoutput>";
    </cfif>  
	<!---wrk_opener_reload();--->
	window.close();
</script>
