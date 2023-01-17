<cf_date tarih = 'attributes.start_date'>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	attributes.process_type = get_process_type.PROCESS_TYPE;
	IS_ACCOUNT = get_process_type.IS_ACCOUNT;
	is_budget = get_process_type.IS_BUDGET;
	IS_ACCOUNT_GROUP = get_process_type.IS_ACCOUNT_GROUP;
	is_project_based_acc=get_process_type.IS_PROJECT_BASED_ACC;
	is_stock_act = get_process_type.IS_STOCK_ACTION;
	rd_money_value = listfirst(attributes.rd_money, ',');
	
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cfset multi="">
<!--- Action file larda sorun oluyordu bloklara ayırmak zorunda kaldık Özden-Sevda --->
<cfif not isdefined("is_transaction")>
	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfinclude template="upd_invent_stock_fis_return_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="upd_invent_stock_fis_return_ic.cfm">
</cfif>
<cfset attributes.actionId = attributes.fis_id >
<cfif not isDefined("related_ship_id")>
	<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:3,action_id:attributes.fis_id,query_type:2);</cfscript>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#attributes.fis_id#</cfoutput>";
		</script>
	<cfelseif session.ep.our_company_info.is_cost eq 1>
		<cfscript>cost_action(action_type:3,action_id:attributes.fis_id,query_type:3);</cfscript>
		<script type="text/javascript">
			window.location.href = "<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#attributes.fis_id#</cfoutput>";
		</script>
	<cfelse>
    	<script type="text/javascript">
			window.location.href = "<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#attributes.fis_id#</cfoutput>";
		</script>
	</cfif>
</cfif>
