<cfparam name="attributes.ship_method" default="">
<cfquery name="GET_ORDER_HISTORY" datasource="#DSN3#">
	SELECT *,(SELECT SUM(ORR.PRICE*ORR.TAX*ORR.QUANTITY/100) TAXPRICE FROM OFFER_ROW ORR WHERE ORR.OFFER_ID = OFFER_HISTORY.OFFER_ID) TAXPRICE FROM OFFER_HISTORY WHERE OFFER_ID = #attributes.offer_id# ORDER BY OFFER_HISTORY_ID
</cfquery>

<cfinclude template="../../sales/query/get_his_off_rows.cfm">
<cfinclude template="../../sales/query/get_offer_currencies.cfm">

<cfset stock_id_list = ''>
<cfset stock_id_count = ''>
<cfset work_id_list =listdeleteduplicates(ValueList(GET_ORDER_HISTORY.WORK_ID,','))>
<cfoutput query="get_offer_rows">
	<cfif not listfindnocase(stock_id_list,stock_id)>
		<cfset stock_id_list = listappend(stock_id_list,stock_id)>
		<cfset stock_id_count = listappend(stock_id_count,1)>
	<cfelse>
		<cfset sira_ = listfindnocase(stock_id_list,stock_id)>
		<cfset sayi_ = listgetat(stock_id_count,sira_) + 1>
		<cfset stock_id_count = listsetat(stock_id_count,sira_,sayi_)>
	</cfif>
</cfoutput>

<cfset offer_currency_list = valuelist(GET_OFFER_CURRENCIES.OFFER_CURRENCY_ID)>
<cfset off_list = listdeleteduplicates(ValueList(GET_ORDER_HISTORY.offer_stage,','))>

<cfif listlen(off_list,',')>
	<cfquery name="get_pro_stage" datasource="#DSN#">
		SELECT DISTINCT  PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#off_list#)
	</cfquery>
  	<cfif get_pro_stage.recordcount>
		<cfscript>
			for(pind=1;pind lte get_pro_stage.recordcount; pind=pind+1)
				'opp_stage_#get_pro_stage.PROCESS_ROW_ID[pind]#' = get_pro_stage.STAGE[pind];
		</cfscript>
	</cfif>
    
</cfif>
<cfif listlen(work_id_list,',')>
<cfset work_id_list=listsort(work_id_list,"numeric","ASC",",")>
<cfquery name="get_work_info" datasource="#dsn#">
	SELECT WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_id_list#) ORDER BY WORK_ID
</cfquery>
<cfset work_id_list = listsort(listdeleteduplicates(valuelist(get_work_info.WORK_ID,',')),'numeric','ASC',',')>
</cfif>
<cfset sayi = 0>
<cfset satir_sayi = 0>
<style>
.history_head tr:first-child td{
	background-color:#67bbc9;
	color:white;
	font-weight:bold;
	border:none;
	}
.history_head td {
	text-align:center;
	}	

</style>
<cfsavecontent variable="title_">
<cf_get_lang dictionary_id='57473.Tarihçe'> (<cf_get_lang dictionary_id ='34303.Güncellenme Sayısı'> : <cfoutput>#get_order_history.recordcount#</cfoutput>) 
</cfsavecontent>
<cf_popup_box title="#title_#">
<cf_medium_list>
    <tbody>
        <cfif get_order_history.recordcount>
          <cfset temp_ = 0>
          <cfoutput query="get_order_history">
           <cfset temp_ = temp_ +1> 
           <cfsavecontent variable="header_txt">#dateformat(record_date,dateformat_style)# (#timeformat(record_date,timeformat_style)#) - <cfif attributes.portal_type eq "employee">#get_emp_info(record_emp,0,0)#<cfelse>#get_par_info(record_par,0,-1,0)#</cfif></cfsavecontent>
           <cf_seperator id="history_#temp_#" header="#header_txt#" is_closed="1">
           <table id="history_#temp_#" style="display:none" style="width:100%;" border="0" cellspacing="0" cellpadding="0" align="left" width="99%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
                                <td >#currentrow#</td>
                                <td class="txtbold"><cf_get_lang dictionary_id='32818.Teklif Tarihi'></td>
                                <td style="">#dateformat(offer_date,dateformat_style)#</td>
                                <td class="txtbold"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
                                <td>#dateformat(deliverdate,dateformat_style)#</td>
                                <cfif get_order_history.purchase_sales eq 1>
                				<td class="txtbold"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'> </td>
                                <td >#dateformat(finishdate,dateformat_style)#</td>
           						</cfif>
                            </tr>
                            <tr>  
                            	<td class="txtbold"><cf_get_lang dictionary_id="30024.KDV siz"></td>
                                <td style=""><cfif len(get_order_history.price)>#TLFormat(price-taxprice)# #session.ep.money#</cfif></td>
                                <td class="txtbold"><cf_get_lang dictionary_id='57416.proje'></td>
                                <td><cfif len (get_order_history.project_id)>#get_project_name(get_order_history.project_id)#</cfif></td>  
                                <td class="txtbold"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
                                <td>
									<cfif len(get_order_history.paymethod)>
										<cfset attributes.paymethod_id = get_order_history.paymethod>
                                        <cfinclude template="../../sales/query/get_paymethod.cfm">
                                        #get_paymethod.paymethod#
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                	               				
                                <td class="txtbold" ><cf_get_lang dictionary_id='32840.Teklif Tutarı'></td>
                                <td style=""><cfif len(get_order_history.price)>#TLFormat(price)# #session.ep.money#</cfif></td>
                                <cfif get_order_history.purchase_sales eq 0> 
                				<td class="txtbold"><cf_get_lang dictionary_id='32555.İş/görev'></td>
                                <td><cfif len(get_order_history.work_id) >#get_work_info.work_head[listfind(work_id_list,work_id)]#</cfif></td>
            						</cfif>
                                <td class="txtbold" ><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
                                <td style="">
                                <cfif len(get_order_history.ship_method)>
								<cfset attributes.ship_method=get_order_history.ship_method>
                                <cfset attributes.ship_address= get_order_history.ship_address>
                                <cfinclude template="../../sales/query/get_ship_method.cfm">
                                #get_ship_method.ship_method#
                            	</cfif>
                                </td>
                            </tr>
                            <tr>   
                             	<td class="txtbold" ><cf_get_lang dictionary_id="30024.KDV siz"><cf_get_lang dictionary_id ='57677.Döviz'></td>
                                <td style="">
                                <cfif len(get_order_history.other_money)>
                                    <cfquery name="get_money_history" datasource="#dsn3#">
                                        SELECT * FROM OFFER_MONEY WHERE ACTION_ID = #attributes.offer_id# AND MONEY_TYPE = '#other_money#'
                                    </cfquery>
                                #TLFormat((get_money_history.rate1)*(price-taxprice)/(get_money_history.rate2))# #other_money#
                            	</cfif>
                                </td>
                                
                                <td class="txtbold" ><cf_get_lang dictionary_id='38707.Teklif Tutarı Döviz'></td>
                                <td style="">
                                <cfif len(get_order_history.other_money)>
                                    <cfquery name="get_money_history" datasource="#dsn3#">
                                        SELECT * FROM OFFER_MONEY WHERE ACTION_ID = #attributes.offer_id# AND MONEY_TYPE = '#other_money#'
                                    </cfquery>
                                #TLFormat((get_money_history.rate1)*price/(get_money_history.rate2))# #other_money#
                                </cfif>
                                </td>
                                <td class="txtbold" ><cf_get_lang dictionary_id ='32842.Teklif Süreci'></td>
                                <td style=""><cfif isdefined('opp_stage_#OFFER_STAGE#')>#Evaluate('opp_stage_#OFFER_STAGE#')#</cfif></td>
                            </tr>
                        </table>
                    </td>    
                </tr>
                <tr>
                	<td> 
                    <table cellpadding="0" cellspacing="0" border="0" width="100%"  class="history_head">

                        	<cfif GET_OFFER_ROWS.recordcount>
                                <tr height="20"> 
                                    <td width="40" style="padding:1mm;"><cf_get_lang dictionary_id="57487.No"></td>
                                    <!---<td width="140"><cf_get_lang_main no ='818.Satır no'></td>--->
                                    <td width="60" ><cf_get_lang dictionary_id ='57657.Ürün'></td>
                                    <td width="159"><cf_get_lang dictionary_id ='57635.Miktar'></td>
                                        				  
                                    <td  width="40"><cf_get_lang dictionary_id ='57629.Açıklama'></td>
                                    <td  width="120" ><cf_get_lang dictionary_id ='58084.Fiyat'></td>
                                    <td  width="159"><cf_get_lang dictionary_id ='34076.Döviz Fiyat'></td>
                                    <td><cf_get_lang dictionary_id ='57677.Döviz'></td>
                                    <td><cf_get_lang dictionary_id ='57639.KDV'></td>
                                    <td><cf_get_lang dictionary_id ='57673.Tutar'></td>
                                 </tr>
                                 <cfset OFFER_HISTORY_ID_ = OFFER_HISTORY_ID>
                                <cfloop query="get_offer_rows" >
                                 <cfset sayi = sayi + 1>
                                 <cfif get_offer_rows.O_HISTORY_ID eq OFFER_HISTORY_ID_>
                    			<cfset satir_sayi = satir_sayi + 1>
                                	<tr>
                                        <td align="center">#currentrow#</td>
                                       <!--- <td align="center">#satir_sayi#</td>--->
                                        <td>#product_name# #property#</td>
                                        <td>#quantity#</td>
                                        <td><cfif len (product_name2)> #product_name2# </cfif></td>
                                        <td  style="text-align:right;">#TLFormat(price)# #session.ep.money#</td>
                                        <td  style="text-align:right;">#TLFormat(price_other)# #other_money#</td>
                                        <td  style="text-align:right;">#OTHER_MONEY#</td>
                                        <td  style="text-align:right;">#TAX#</td>
                                        <td  style="text-align:right;">#TLFormat(QUANTITY*PRICE)#</td>
                                    </tr>
                                    </cfif>
                                </cfloop>
                               </cfif>
                        </table>	
                    </td>
                </tr> 
                <cfset satir_sayi = 0>
          </cfoutput>
          <cfelse>
          <tr>
            <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
          </tr>
        </cfif>
        </table>
	</tbody>
</cf_medium_list>
</cf_popup_box>
