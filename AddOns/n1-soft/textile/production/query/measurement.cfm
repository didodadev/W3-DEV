<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.proclist" default="">

<cfobject name="predefined" component="addons.n1-soft.textile.cfc.operation_process">
<cfset get_predefineds = predefined.get_predefineds(attributes.req_id,attributes.order_id)>
<cfif isdefined("attributes.main_operation_id") and len(attributes.main_operation_id) and not isdefined("attributes.is_delete")>
	<cfscript>	
		predefined.clear_predefined_rows(
			main_operation_id:attributes.main_operation_id
		);
		predefined.update_predefined(
				main_operation_id:attributes.main_operation_id,
				req_id:attributes.req_id,
				order_id:attributes.order_id,
				amount:attributes.order_amount,
				proclist:attributes.proclist,
				page_type:attributes.page_type,
				marj:attributes.marj
			);
	</cfscript>
<cfelseif isdefined("attributes.main_operation_id") and len(attributes.main_operation_id) and isdefined("attributes.is_delete")>
	<cfscript>
		predefined.clear_predefined(
				main_operation_id:attributes.main_operation_id
			);
		</cfscript> 
<cfelseif not len(attributes.main_operation_id)>
		<cfscript>
				key=predefined.insert_predefined
				(
					req_id:attributes.req_id,
					order_id:attributes.order_id,
					amount:attributes.order_amount,
					proclist:attributes.proclist,
					page_type:attributes.page_type,
					marj:attributes.marj
				);
				attributes.main_operation_id=key;
	   	</cfscript> 
</cfif>
<script type="text/javascript">
	<cfif attributes.page_type eq 1>
		window.location.href = '<cfoutput>#request.self#?fuseaction=textile.operations&order_number1=#attributes.order_no#&keyword=#attributes.order_no#</cfoutput>';
	<cfelseif attributes.page_type eq -1>
		window.location.href = '<cfoutput>#request.self#?fuseaction=textile.tracking&order_number1=#attributes.order_no#&keyword=#attributes.order_no#</cfoutput>';
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=textile.tracking&event=measurement&main_operation_id=#attributes.main_operation_id#</cfoutput>';	
	</cfif>
</script>
