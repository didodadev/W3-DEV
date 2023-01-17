
<cfsetting showdebugoutput="no">
<cfoutput>	
<cfif attributes.no_box_page eq 1>
	<cfset title =''>
<cfelse>
	<cfset title="#getLang('','Tarihçe',57473)#">
</cfif>
	<cf_box id="#attributes.id#" title="#title#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfif attributes.act_type eq 1><!--- Satış Takibi ise --->
			<cfinclude template="list_demand_history.cfm">
		<cfelseif attributes.act_type eq 2><!--- Ödeme Talebi ise --->
			<cfinclude template="list_closed_act_history.cfm">
		<cfelseif attributes.act_type eq 3><!--- proje bağlantısı ise --->
			<cfinclude template="list_project_discount_history.cfm">
		<cfelseif attributes.act_type eq 4><!---sanal pos kuralı ise --->
			<cfinclude template="list_pos_operation_history.cfm">
		<cfelseif attributes.act_type eq 5><!---üretim emri ise --->
			<cfinclude template="list_production_order_history.cfm">
		<cfelseif attributes.act_type eq 6><!---harcama talebi ise --->
			<cfinclude template="expense_plan_history.cfm">
		<cfelseif attributes.act_type eq 7><!---fatura ise --->
			<cfinclude template="../../invoice/display/form_list_invoice_history.cfm">
		<cfelseif attributes.act_type eq 8><!---fatura ise --->
			<cfinclude template="related_contract_history.cfm">
		</cfif>
	</cf_box>
</cfoutput>

