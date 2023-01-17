<cfset attributes.action_id=attributes.offer_id>
<cfset attributes.action_section="OFFER_ID">
<cfinclude template="../../objects/query/del_assets.cfm">
<cfquery name="get_process" datasource="#dsn3#">
	SELECT OFFER_STAGE,OFFER_NUMBER,FOR_OFFER_ID,OFFER_HEAD,PROCESS_CAT FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfif len(get_process.PROCESS_CAT)>
	<cfquery name="get_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_process.process_cat#
	</cfquery>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- Silme Islemi Yapiliyor --->
		<cfinclude template="del_offer_ic.cfm">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.is_popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfif len(get_process.for_offer_id)>
    	<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_process.for_offer_id#</cfoutput>";
		</script>
	<cfelse>
    	<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=purchase.list_offer</cfoutput>";
		</script>	
	</cfif>
</cfif>

