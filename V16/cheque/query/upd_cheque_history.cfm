<cfscript>
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}		
</cfscript>
<cfif isdefined("attributes.cheque_id") and len(attributes.cheque_id) and isdefined("attributes.payroll_id")and len(attributes.payroll_id)>
	<cfquery name="upd_cheque_history" datasource="#dsn2#">
		UPDATE 
			CHEQUE_HISTORY
		SET 
			OTHER_MONEY='#session.ep.money#',
			OTHER_MONEY_VALUE=<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value)>#attributes.system_currency_value#<cfelse>NULL</cfif>,
			OTHER_MONEY2=<cfif isdefined("session.ep.money2")>'#session.ep.money2#'<cfelse>NULL</cfif>,
			OTHER_MONEY_VALUE2=<cfif isdefined("attributes.system_currency_value") and len(attributes.system_currency_value)>#wrk_round(attributes.system_currency_value/currency_multiplier)#<cfelse>NULL</cfif>
		WHERE 
			CHEQUE_ID=#attributes.cheque_id#
			AND PAYROLL_ID=#attributes.payroll_id#
	</cfquery>
	<cfquery name="get_hist_id" datasource="#dsn2#">
		SELECT HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_ID=#attributes.cheque_id# AND PAYROLL_ID=#attributes.payroll_id#
	</cfquery>
	<cfquery name="get_cheq_" datasource="#dsn2#">
		SELECT CURRENCY_ID FROM CHEQUE WHERE CHEQUE_ID =#attributes.cheque_id# 
	</cfquery>
	<cfquery name="del_hist_money" datasource="#dsn2#"><!--- money kayıtları siliniyor --->
		DELETE FROM CHEQUE_HISTORY_MONEY WHERE ACTION_ID = #get_hist_id.history_id#
	</cfquery>
	<cfloop from="1" to="#attributes.kur_say#" index="i">
		<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
			INSERT INTO CHEQUE_HISTORY_MONEY 
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#get_hist_id.history_id#,
				'#wrk_eval("attributes.hidden_rd_money_#i#")#',
				#evaluate("attributes.txt_rate2_#i#")#,
				#evaluate("attributes.txt_rate1_#i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#i#") is get_cheq_.currency_id>1<cfelse>0</cfif>
			)
		</cfquery>
	</cfloop>
</cfif>
<cfset money_list = attributes.kur_say & '-'>
<cfloop from="1" to="#attributes.kur_say#" index="i">
	<cfset money_list= money_list & '#evaluate("attributes.hidden_rd_money_#i#")#' & ',' & '#evaluate("attributes.txt_rate1_#i#")#' & ',' & '#evaluate("attributes.txt_rate2_#i#")#' & '-'>
</cfloop>
<cfoutput>
	<script type="text/javascript">
		<cfif isdefined("attributes.cheque_id") and len(attributes.cheque_id) and isdefined("attributes.payroll_id")and len(attributes.payroll_id)>
		<cfelseif isdefined("attributes.row") and len(attributes.row)>
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_system_currency_value'+#attributes.row#).value = #attributes.system_currency_value#;
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value = '#money_list#';
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money_value2'+#attributes.row#).value = #wrk_round(attributes.system_currency_value/currency_multiplier)#;
			eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.other_money2'+#attributes.row#).value = '#session.ep.money2#';
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>cheque_rate_change();
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>toplam(1,0);
		</cfif>
		parent.location.reload();
		</script> 
</cfoutput>
