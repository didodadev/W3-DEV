<cfquery name="GET_BILL" datasource="#dsn2#">
	SELECT 
		INVOICE_ID,
		INVOICE_CAT,
		INVOICE_NUMBER,
		NETTOTAL,
		SALE_EMP,
		COMPANY_ID,
		CONSUMER_ID,
		INVOICE_DATE,
		OTHER_MONEY_VALUE,
		PURCHASE_SALES,
		NOTE
		<cfif len(session.ep.money2)>
		,NETTOTAL/(INVOICE_MONEY.RATE2/INVOICE_MONEY.RATE1) AS PRICE2
        </cfif>
	FROM 
		INVOICE
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY
		</cfif>
	WHERE
		INVOICE_ID > 0
		AND INVOICE_CAT <> 67
		AND INVOICE_CAT <> 69
		AND PURCHASE_SALES = 1 
	<cfif len(session.ep.money2)>
		AND INVOICE.INVOICE_ID = INVOICE_MONEY.ACTION_ID
		AND INVOICE_MONEY.MONEY_TYPE = '#session.ep.money2#'
	</cfif>		
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SALE_EMP = #attributes.employee_id#
	</cfif>
	<cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
		AND (INVOICE_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
	</cfif>
	<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	</cfif>
	<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
	ORDER BY INVOICE_DATE DESC
</cfquery>
<cfif not len(GET_BILL.recordcount)>
	<cfset GET_BILL.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_BILL.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cf_medium_list>
	<thead>
      <tr>
          <th width="30"><cf_get_lang dictionary_id ='57487.No'></th>
          <th width="150"><cf_get_lang dictionary_id ='57742.Tarih'></th>		  
          <th width="75"><cf_get_lang dictionary_id ='57880.Belge No'></th>
          <th width="200"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
          <th width="250"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
          <th width="100"><cf_get_lang dictionary_id ='57673.Tutar'></th>
          <th width="100"><cf_get_lang dictionary_id ='34136.Tutar Döviz'></th>
      </tr>
    </thead>
    <tbody>
	  <cfif GET_BILL.recordcount>
		  <cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             <tr>
                 <td>
                    <cfif listfind("50,51,52,53,54,55,56,57,58,59,60,61,62,63,65,66,67,531,591,592",GET_BILL.invoice_cat,",")>
                        <cfif get_bill.purchase_sales>
                            <cfif GET_BILL.invoice_cat eq 65>
                                <a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                <cfset link_str="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" >
                            <cfelseif GET_BILL.invoice_cat eq 66>
                                <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                <cfset link_str="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" >
                            <cfelseif GET_BILL.invoice_cat eq 52>
                                <a href="#request.self#?fuseaction=invoice.detail_invoice_retail&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                <cfset link_str="#request.self#?fuseaction=invoice.detail_invoice_retail&iid=#get_bill.invoice_id#">
                            <cfelse>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                <cfset link_str="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#">
                            </cfif>
                        <cfelseif not get_bill.purchase_sales>
                            <cfif invoice_cat eq 592 >
                                <a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                <cfset link_str="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#get_bill.invoice_id#">
                            <cfelse>
                                <cfif GET_BILL.invoice_cat eq 65>
                                    <a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                    <cfset link_str="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_bill.invoice_id#" >
                                <cfelseif GET_BILL.invoice_cat eq 66>
                                    <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                    <cfset link_str="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_bill.invoice_id#" >
                                <cfelse>
                                    <a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                    <cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_bill.invoice_id#">
                                </cfif>
                            </cfif>
                        </cfif>
                    <cfelse>
                        <a href="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                        <cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#">
                    </cfif>
                  </td>
                  <td>#dateformat(INVOICE_DATE,dateformat_style)# &nbsp; #timeformat(date_add('h',session.ep.time_zone,INVOICE_DATE),timeformat_style)#</td>
                  <td> <a href="#link_str#" class="tableyazi">#INVOICE_NUMBER#</a></td>
                  <td>
                     <a href="#link_str#" class="tableyazi">
                        <cfswitch expression="#get_bill.invoice_cat#">
                            <cfcase value="66"><cf_get_lang dictionary_id='29575.Demirbaş Satış Faturası'></cfcase>
                            <cfcase value="65"><cf_get_lang dictionary_id='29574.Demirbaş Alış Faturası'></cfcase>
                            <cfcase value="63"><cf_get_lang dictionary_id='57811.Alınan Fiyat Farkı Faturası'></cfcase>
                            <cfcase value="62"><cf_get_lang dictionary_id='57815.Alım İade Faturası'></cfcase>
                            <cfcase value="61"><cf_get_lang dictionary_id='57814.Alınan Proforma Faturası'></cfcase>
                            <cfcase value="58"><cf_get_lang dictionary_id='57830.Verilen Fiyat Farkı Faturası'></cfcase>
                            <cfcase value="57"><cf_get_lang dictionary_id='57770.Verilen Proforma Faturası'></cfcase>
                            <cfcase value="56"><cf_get_lang dictionary_id='57829.Verilen Hizmet Faturası'></cfcase>
                            <cfcase value="55"><cf_get_lang dictionary_id='57768.Toptan Satış İade Faturası'></cfcase>
                            <cfcase value="53"><cf_get_lang dictionary_id='57825.Toptan Satış Faturası'></cfcase>
                            <cfcase value="52"><cf_get_lang dictionary_id='57765.Perakende Satış Faturası'></cfcase>
                            <cfcase value="51"><cf_get_lang dictionary_id='57763.Alınan Vade Farkı Faturası'></cfcase>
                            <cfcase value="50"><cf_get_lang dictionary_id='57827.Verilen Vade Farkı Faturası'></cfcase>
                            <cfcase value="64"><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></cfcase>
                            <cfcase value="60"><cf_get_lang dictionary_id='32955.Alınan Hizmet Faturası'></cfcase>
                            <cfcase value="59"><cf_get_lang dictionary_id='57822.Mal Alım Faturasi'></cfcase>
                            <cfcase value="54"><cf_get_lang dictionary_id='57824.Parekende Satis Iade Faturasi'></cfcase>
                            <cfcase value="68"><cf_get_lang dictionary_id='29577.Serbest Meslek Makbuzu'></cfcase>
                            <cfcase value="690"><cf_get_lang dictionary_id='57817.Gider Pusulası Mal'></cfcase>
                            <cfcase value="691"><cf_get_lang dictionary_id='57818.Gider Pusulası Hizmet'></cfcase>
                            <cfcase value="592"><cf_get_lang dictionary_id='57819.Hal Faturası'></cfcase>
                            <cfcase value="591"><cf_get_lang dictionary_id='57820.İthalat Faturası'></cfcase>
                            <cfcase value="531"><cf_get_lang dictionary_id='57821.İhracat Faturası'></cfcase>
                        </cfswitch>
                     </a>
                </td>	
                 <td>#NOTE#</td>
                 <td  style="text-align:right;">#TLFormat(get_bill.nettotal)# #session.ep.money#</td>
                 <td  style="text-align:right;">#TLFormat(get_bill.PRICE2)# #session.ep.money2#</td>
             </tr>
             </cfoutput>
		 <cfelse>
		 <tr>
			 <td colspan="14">
			 <cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id ='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif>
			 </td>
		 </tr>
		</cfif>
    </tbody>
   </cf_medium_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
      <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
          <td>
            <cfset adres="objects.popup_list_related_papers">
            <cfif isDefined('attributes.sec') and len(attributes.sec)>
                <cfset adres = "#adres#&sec=#attributes.sec#">
            </cfif>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
                    <cfset adres = "#adres#&company_id=#attributes.company_id#" >
                    <cfset adres = "#adres#&member_name=#attributes.member_name#">
                </cfif>
                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>
                    <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#" >
                    <cfset adres = "#adres#&member_name=#attributes.member_name#">
                </cfif>
                <cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
                    <cfset adres = "#adres#&employee_id=#attributes.employee_id#" >
                    <cfset adres = "#adres#&employee=#attributes.employee#">
                </cfif>
                <cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
                    <cfset adres = "#adres#&belge_no=#attributes.belge_no#" >
                </cfif>
                <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
                    <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
                </cfif>
                <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                    <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
                </cfif>
                <cfif isdefined("attributes.form_varmi")>
                <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
            </cfif>
            <cf_pages page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#"></td>
          <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id ='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id ='57581.Sayfa'>:#attributes.page#</cfoutput>
          </td><!-- sil -->
        </tr>
      </table>
	</cfif>
  

