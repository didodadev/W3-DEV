<cfquery name="get_fuel" datasource="#dsn#">
	SELECT DOCUMENT_NUM FROM ASSET_P_FUEL WHERE FUEL_ID = #attributes.fuel_id#
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="del_fuel" datasource="#dsn#">
			DELETE FROM ASSET_P_FUEL WHERE FUEL_ID = #attributes.fuel_id#
		</cfquery>
		<cfquery name="del_km" datasource="#dsn#">
			DELETE FROM ASSET_P_KM_CONTROL WHERE KM_CONTROL_ID = #attributes.km_control_id#
		</cfquery>
        <cfif len(get_fuel.document_num)>
        	<cfset paper_no=attributes.fuel_id&"-"&get_fuel.document_num>
         <cfelse>
         	 <cfset paper_no=attributes.fuel_id>  
        </cfif>
		<cf_add_log log_type="-1" action_id="#attributes.fuel_id#" action_name="YAKIT:#attributes.plaka#" paper_no="#paper_no#">
		<cf_add_log log_type="-1" action_id="#attributes.km_control_id#" action_name="KM:#attributes.plaka#" paper_no="#paper_no#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload(); 
	window.close();
</script>


