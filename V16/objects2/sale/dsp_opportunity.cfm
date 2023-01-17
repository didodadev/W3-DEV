<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT 
    	OPP_NO,
        OPP_HEAD,
        OPP_DETAIL,
        COMPANY_ID,
        OPP_DATE,
        OPPORTUNITY_TYPE_ID,
        SALES_EMP_ID,
        ACTIVITY_TIME,
        COMMETHOD_ID,
        PROBABILITY,
        OPP_CURRENCY_ID,
        OPP_STATUS
	FROM 
     	OPPORTUNITIES 
    WHERE 
    	OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
</cfquery>

<cfoutput>
<table style="width:100%;">
  	<tr class="color-row" style="height:20px;">
        <td class="txtbold" style="width:10%; vertical-align:top;"><cf_get_lang_main no='75.No'></td>
        <td>#get_opportunity.opp_no#</td>
        <td class="txtbold">Durum</td>
        <td><cfif get_opportunity.opp_status eq 1><cf_get_lang_main no='81.Aktif'><cfelse>Pasif</cfif></td>
  	</tr>
  	<tr class="color-row" style="height:20px;">
        <td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
        <td colspan="3">#get_opportunity.opp_head#</td>
  	</tr>
	<tr class="color-row" style="height:20px;">
	  	<td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
	  	<td colspan="3">#get_opportunity.opp_detail#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='45.Müşteri'></td>
        <td>#get_par_info(get_opportunity.company_id,1,0,0)#</td>
		<td class="txtbold"><cf_get_lang no='426.Başvuru'></td>
        <td>#DateFormat(get_opportunity.opp_date,'dd/mm/yyyy')#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
		<td>
			<cfif len(get_opportunity.opportunity_type_id)>
				<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
					SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE OPPORTUNITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_opportunity.opportunity_type_id#">
				</cfquery>
				#get_opportunity_type.opportunity_type#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang no='482.Ekibiniz'></td>
        <td>#get_emp_info(get_opportunity.sales_emp_id,0,0)#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang no='430.Hareket'></td>
		<td>
            <cfif get_opportunity.activity_time eq 1><cf_get_lang no='436.Hemen'></cfif>
            <cfif get_opportunity.activity_time eq 7>1 Hafta</cfif>
            <cfif get_opportunity.activity_time eq 30>1 Ay</cfif>
            <cfif get_opportunity.activity_time eq 90>3 Ay</cfif>
            <cfif get_opportunity.activity_time eq 180>6 Ay</cfif>
            <cfif get_opportunity.activity_time eq 181>6 Aydan Fazla</cfif>
		</td>
		<td class="txtbold"><cf_get_lang_main no='731.İletişim'></td>
		<td>
			<cfif len(get_opportunity.commethod_id)>
                <cfquery name="GET_COMMETHOD_CATS" datasource="#DSN#">
                    SELECT COMMETHOD FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_opportunity.commethod_id#">
                </cfquery>
                #get_commethod_cats.commethod#
            </cfif>
		</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='1240.Olasılık'></td>
        <td>
            <cfif get_opportunity.probability eq 10>%10</cfif>
            <cfif get_opportunity.probability eq 20>%20</cfif>
            <cfif get_opportunity.probability eq 30>%30</cfif>
            <cfif get_opportunity.probability eq 40>%40</cfif>
            <cfif get_opportunity.probability eq 50>%50</cfif>
            <cfif get_opportunity.probability eq 60>%60</cfif>
            <cfif get_opportunity.probability eq 70>%70</cfif>
            <cfif get_opportunity.probability eq 80>%80</cfif>
            <cfif get_opportunity.probability eq 90>%90</cfif>
            <cfif get_opportunity.probability eq 100>%100</cfif>
		</td>
		<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
        <cfquery name="GET_OPP_CURRENCIES" datasource="#DSN3#">
            SELECT OPP_CURRENCY FROM OPPORTUNITY_CURRENCY WHERE OPP_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_opportunity.opp_currency_id#">
        </cfquery>
		<td>#get_opp_currencies.opp_currency#</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang no='433.Tahmini Gelir'></td>
        <cfquery name="GET_MONEYS" datasource="#DSN#">
			SELECT MONEY_ID, MONEY FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_opportunity.money#">
		</cfquery>
		<td>#TLFormat(get_opportunity.income)# #get_moneys.money#</td>
		<td class="txtbold"><cf_get_lang no='431.Tahmini Maliyet'></td>
        <td>#TLFormat(get_opportunity.cost)# #get_moneys.money#</td>
	</tr>
</table>
</cfoutput>

