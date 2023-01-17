<cfsetting showdebugoutput="no">
<cfquery name="delPBS" datasource="#dsn3#">
	DELETE FROM 
		RELATION_PBS_CODE 
	WHERE 
		PBS_ID = #attributes.pbs_id# AND 
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
			OPPORTUNITY_ID = #attributes.opp_id#
		<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
			PROJECT_ID = #attributes.project_id#	
		<cfelseif isdefined('attributes.offer_id') and len(attributes.offer_id)>
			OFFER_ID = #attributes.offer_id#
		</cfif>
</cfquery>
