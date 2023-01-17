<cfif not isDefined('SESSION#var_#_prom_list')>
	<cfset 'SESSION#var_#_prom_list'="">
</cfif>
<cfif not isDefined('SESSION#var_#_total')>
	<cfset 'SESSION#var_#_total'=0>
</cfif>
<cfif not isDefined('SESSION#var_#_kdvlist')>
	<cfset 'SESSION#var_#_kdvlist'="">
</cfif>
<cfif not isDefined('SESSION#var_#_total_tax')>
	<cfset 'SESSION#var_#_total_tax'=0>
</cfif>
<cfif not isDefined('SESSION#var_#_net_total')>
	<cfset 'SESSION#var_#_net_total'=0>
</cfif>
<cfif not isDefined('SESSION#var_#_discount')>
	<cfset 'SESSION#var_#_discount'=0>
</cfif>
<cfif not isDefined('SESSION#var_#rate2')>
	<cfset 'SESSION#var_#rate2'=1>
</cfif>
<cfif not isDefined('SESSION#var_#rate1')>
	<cfset 'SESSION#var_#rate1'=1>
</cfif>
