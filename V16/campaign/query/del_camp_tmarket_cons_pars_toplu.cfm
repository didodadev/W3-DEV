<cfif isdefined('attributes.P_MAXROWS') and attributes.P_MAXROWS gt 1>
	<cfloop from="#attributes.P_STARTROW#" to="#attributes.P_STARTROW+attributes.P_MAXROWS-1#" index="p_sayac">
		<cfif isdefined("PARS_LIST_#p_sayac#")>
			<cfquery name="get_camp_target2" datasource="#dsn3#">
				DELETE FROM CAMPAIGN_TARGET_PEOPLE
				WHERE
					CAMP_ID = #attributes.camp_id#
					AND
					PAR_ID = #Evaluate("PARS_LIST_#p_sayac#")#
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined('attributes.C_MAXROWS') and attributes.C_MAXROWS gt 1>
	<cfloop from="#attributes.C_STARTROW#" to="#attributes.C_STARTROW+attributes.C_MAXROWS-1#" index="C_sayac">
		<cfif isdefined("CONS_LIST_#C_sayac#")>
			<cfquery name="get_camp_target" datasource="#dsn3#">
				DELETE FROM CAMPAIGN_TARGET_PEOPLE
				WHERE
					CAMP_ID = #attributes.camp_id#
					AND
					CON_ID = #Evaluate("CONS_LIST_#C_sayac#")#
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

