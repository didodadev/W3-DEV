
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	
	
		<cfquery name="del_" datasource="#DSN3#">
			DELETE
				TEXTILE_SAMPLE_REQUEST
				WHERE
					REQ_ID=#attributes.req_id#
       </cfquery>
       <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			DELETE
				TEXTILE_SR_PROCESS
				WHERE
					REQUEST_ID=#attributes.req_id#
		</cfquery>	
 <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			DELETE
				TEXTILE_PRODUCT_PLAN
				WHERE
					REQUEST_ID=#attributes.req_id#
		</cfquery>			
	</cftransaction>
</cflock>
<script>
	   window.location.href='<cfoutput>index.cfm?fuseaction=textile.list_sample_request</Cfoutput>';
</script>

