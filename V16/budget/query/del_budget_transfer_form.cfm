<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cftransaction>
    
    <cfset get_demand_ = demand.get_demand_(
                                                        demand_id : attributes.demand_id
                                                     )>
    <cfif len(get_demand_.demand_id)>
        <cfset del_demand_row = demand.del_demand_row(
                                                                    demand_id : valueList(get_demand_.demand_id)
                                                                 )>
    </cfif>

    
    <cfset del_demand = demand.del_demand( demand_id : attributes.demand_id )>

</cftransaction>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.budget_transfer_demand</cfoutput>';
</script>