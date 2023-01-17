<cf_date tarih = 'attributes.start_date'>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfquery name="get_process_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
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
			<cfinclude template="upd_invent_stock_fis_ic.cfm">
		</cftransaction>
	</cflock>
<cfelse>
	<cfinclude template="upd_invent_stock_fis_ic.cfm">
</cfif> 
<cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.fis_id#" action_name="#attributes.fis_no# Güncellendi" paper_no="#attributes.fis_no#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
<cfif not isDefined("related_ship_id")>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=#attributes.fis_id#</cfoutput>";
    </script>
</cfif>

