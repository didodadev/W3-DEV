<cfif not isDefined('session.#var_#_kdvlist')>
	<cfset "session.#var_#_kdvlist"="">
</cfif>
<cfif not isDefined('session.#var_#_total')>
	<cfset "session.#var_#_total"=0>
</cfif>
<cfif not isDefined('session.#var_#_discount')>
	<cfset "session.#var_#_discount"=0>
</cfif>

<cfif not isDefined('session.#var_#_total_tax')>
	<cfset "session.#var_#_total_tax"=0>
</cfif>

<cfif not isDefined('session.#var_#_discount_new')>
	<cfset "session.#var_#_discount_new"=0>
</cfif>

<cfif not isDefined('session.#var_#_prom_list')>
	<cfset "session.#var_#_prom_list"=0>
</cfif>
<cfif not isDefined('session.#var_#_net_total')>
	<cfset "session.#var_#_net_total"=0>
</cfif>
<cfif not isDefined('session.#var_#_kdvpricelist')>
	<cfset "session.#var_#_kdvpricelist"="">
</cfif>

<cfif not isDefined('session.RATE1')>
	<cfset "session.RATE1"=1>
</cfif>
<cfif not isDefined('session.RATE2')>
	<cfset "session.RATE2"=1>
</cfif>
