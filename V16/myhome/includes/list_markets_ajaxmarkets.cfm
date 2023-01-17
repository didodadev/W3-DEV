<!--- gündem piyasalar objesidir ,merkez bankasndan gelen kurları sisteme alan schedule dan gelen sonuçları gösterir--->
<cfsetting showdebugoutput="no">
<cfinclude template="../includes/get_money_info.cfm">
<cfsavecontent variable="workersmessage"><cf_get_lang no='82.Piyasalar'></cfsavecontent>
<cf_flat_list>
	<thead>
		<tr>
			<th>&nbsp;</th>
			<th style="text-align:center;"><cf_get_lang_main no='764.Alış'></th>
			<th style="text-align:center;"><cf_get_lang_main no='36.Satış'></th>
			<th style="width:70px;" nowrap><cf_get_lang no ='1610.Efektif Alış'></th>
			<th style="width:70px;" nowrap><cf_get_lang no ='3.Efektif Satış'></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_money_info">
			<cfif len(dsp_rate_pur) and len(dsp_rate_sale)>
				<tr>
					<td>#currency_code#</td>
					<td style="text-align:center;">#TLFormat(dsp_rate_pur,session.ep.our_company_info.rate_round_num)#</td>
					<td style="text-align:center;">#TLFormat(dsp_rate_sale,session.ep.our_company_info.rate_round_num)#</td>
					<td style="text-align:center;">#TLFormat(effective_pur,session.ep.our_company_info.rate_round_num)#</td>
					<td style="text-align:center;">#TLFormat(effective_sale,session.ep.our_company_info.rate_round_num)#</td>
				</tr>
			</cfif>
		</cfoutput>
    </tbody>
</cf_flat_list>


