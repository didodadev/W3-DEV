<cfif attributes.mode eq 1>
<cf_workcube_process is_upd='1'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=prod.product_tree_designer' 
		action_id='#attributes.tree_id#'
        old_process_line='#attributes.old_process_line#'
		action_table='PRODUCT_TREE'
		action_column='PRODUCT_TREE_ID'
		warning_description='Ağaç'>
<cfelse>
<cf_workcube_process is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=prod.product_tree_designer' 
		action_id='#attributes.tree_id#'
		action_table='PRODUCT_TREE'
		action_column='PRODUCT_TREE_ID'
		warning_description='Ağaç'>
</cfif>
