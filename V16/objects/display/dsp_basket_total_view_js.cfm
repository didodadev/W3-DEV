<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset str_money_bskt = SESSION.EP.MONEY>
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset str_money_bskt = SESSION.PP.MONEY>
</cfif>
<cfset str_money_bskt_found = true>
<div class="ui-row">
    <div id="sepetim_total" class="padding-0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"><cf_get_lang dictionary_id="57677.Dövizler"></span>
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div> 
                </div>
                <div class="totalBoxBody">
					<cfoutput>
						<table cellspacing="0">
							<tbody>
								<cfloop query="get_money_bskt">
									<cfif IS_SELECTED>
										<cfset sepet_rate1 = rate1>
										<cfset sepet_rate2 = rate2>
										<cfset str_money_bskt = money_type>
										<cfset str_money_bskt_found = false>
									<cfelseif str_money_bskt_found and money_type eq session_base.money2>
										<cfset sepet_rate1 = rate1>
										<cfset sepet_rate2 = rate2>
										<cfset str_money_bskt = money_type>
									<cfelseif str_money_bskt_found and rate1 eq 1 and rate2 eq 1>
										<cfset sepet_rate1 = 1>
										<cfset sepet_rate2 = 1>
										<cfset str_money_bskt = money_type>				
									</cfif>
								<tr <cfif money_type eq session_base.money> style="display:none;"</cfif>>
									<td><input type="radio" name="rd_money" id="rd_money" value="#currentrow#" disabled="disabled" <cfif isDefined('str_money_bskt') and str_money_bskt eq money_type>checked</cfif>></td>
									<td>#money_type#</td>
									<td>#TLFormat(rate1,0)#/</td>
									<td><input type="text" id="txt_rate2_1" name="txt_rate2_1" value="#TLFormat(rate2,4)#" style="width:100%;" class="box" readonly></td>
								</tr>
							</cfloop>
							</tbody>
						</table>
					</cfoutput>
				</div>
			</div>
		</div>
		<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"><cf_get_lang dictionary_id="57492.Toplam"></span>
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div>
                </div>
				<div class="totalBoxBody">
					
								<table><tbody><cfoutput><tr>
									<td  class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
									<td width="125"  id="total_default" style="text-align:right;" name="total_default">#TLFormat(sepet.total)#</td>
									<td width="120"  id="total_wanted" style="text-align:right;" name="total_wanted">#TLFormat(sepet.total*sepet_rate1/sepet_rate2)#</td></tr>
								
								<cfif (fusebox.circuit eq 'invoice' or listfind("1,2,3,4,10,14,18,20,21,33,38,51,52",attributes.basket_id,","))>
									<tr>
										<td  class="txtbold"><cf_get_lang dictionary_id='57678.Fatura Altı İndirim'></td>
										<td  id="total_tax_default" style="text-align:right;" name="total_tax_default"><cfif StructKeyExists(sepet,'genel_indirim')>#TLFormat(sepet.genel_indirim)#</cfif></td>
										<td  id="total_tax_wanted" style="text-align:right;" name="total_tax_wanted">&nbsp;</td>
									</tr>
								</cfif>
								<tr>
									<td  class="txtbold"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
									<td id="total_discount_default" style="text-align:right;" name="total_discount_default">#TLFormat(sepet.toplam_indirim)#</td>
									<td   id="total_discount_wanted" style="text-align:right;" name="total_discount_wanted">#TLFormat(sepet.toplam_indirim*sepet_rate1/sepet_rate2)#</td>
								</tr>
								<tr>
									<td  class="txtbold"><cf_get_lang dictionary_id='57643.Toplam KDV'></td>
									<td  id="total_tax_default" style="text-align:right;" name="total_tax_default">#TLFormat(sepet.total_tax)#</td>
									<td  id="total_tax_wanted" style="text-align:right;" name="total_tax_wanted">#TLFormat(sepet.total_tax*sepet_rate1/sepet_rate2)#</td>
								</tr>
								<cfif ListFindNoCase(display_list, "OTV")>
									<tr>
										<td  class="txtbold"><cf_get_lang dictionary_id="58021.ÖTV"></td>
										<td  id="total_otv_default" style="text-align:right;" name="total_tax_default"><cfif StructKeyExists(sepet,'total_otv')>#TLFormat(sepet.total_otv)#</cfif></td>
										<td  id="total_otv_wanted" style="text-align:right;" name="total_otv_wanted"><cfif StructKeyExists(sepet,'total_otv')>#TLFormat(sepet.total_otv*sepet_rate1/sepet_rate2)#</cfif></td>
									</tr>
								</cfif>
								<tr>
									<td  class="txtbold"><cf_get_lang dictionary_id='51316.KDVli Toplam'></td>
									<td  id="net_total_default" style="text-align:right;" name="net_total_default">#TLFormat(sepet.net_total)#</td>
									<td  id="net_total_wanted" style="text-align:right;" name="net_total_wanted">#TLFormat(sepet.net_total*sepet_rate1/sepet_rate2,basket_total_round_number)#</td>
								</tr>
							</cfoutput>
							<cfif ListFindNoCase(display_list, "tax")>
								<cfoutput>
									<cfset counter=1>
									<tr> 
										<td class="txtbold" id="td_kdv_list"><cf_get_lang dictionary_id='57639.KDV'></td>
										<cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
											<td style="text-align:right">% #sepet.kdv_array[m][1]#</td><td style="text-align:right"> #TLFormat(sepet.kdv_array[m][2]*(100-sa_percent)/100)#</td>
										</cfloop>
									</tr>
								</cfoutput>	
							<cfelse>
								<tr> 
									<td colspan="7" id="td_kdv_list">
										<cf_get_lang dictionary_id='57681.Kdv Tanımı Yapılmış'>
									</td>
								</tr>
							</cfif>
							<cfif ListFindNoCase(display_list, "OTV")>
								<cfoutput>
									<cfset otv_counter=1>
									<tr> 
										<td class="txtbold" id="td_otv_list">
											<cf_get_lang_main no="609.ÖTV">
										</td>
									</tr>
								</cfoutput>	
							</cfif>
						
						</table> 
						</tbody>
				</div>
			</div>
		</div>
	</div>
</div>