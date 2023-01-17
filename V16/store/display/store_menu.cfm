<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='41.Şube'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='365.İşlemler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='116.Emirler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='672.fiyat'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='245.Ürün'>/<cf_get_lang_main no='40.Stok'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang_main no='267.POS'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no ='5.Üyeler'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang_main no='108.Kasa'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no ='109.Banka'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang_main no ='110.Çek/Senet'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang_main no ='107.Cari Hesap'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang_main no='1518.Masraf'></cfsavecontent>
<cfsavecontent variable="m_dil_13"><cf_get_lang_main no='2307.rekabet'></cfsavecontent>
<cfsavecontent variable="m_dil_14"><cf_get_lang_main no='2308.Etiketler'></cfsavecontent>
<cfsavecontent variable="m_dil_15"><cf_get_lang_main no='250.alan'></cfsavecontent>
<cfsavecontent variable="m_dil_16"><cf_get_lang_main no ='22.Rapor'></cfsavecontent>
<cfset f_n_action_list = "store.list_purchase*0*0*#m_dil_1#,store.welcome*2*menu_sube_islem*#m_dil_2#,store.list_command*0*0*#m_dil_3#,store.prices*0*0*#m_dil_4#,store.welcome*2*menu_sube_urun*#m_dil_5#,store.list_stock_export*0*0*#m_dil_6#,store.welcome*2*menu_sube_uye*#m_dil_7#,store.welcome*2*menu_sube_kasa*#m_dil_8#,store.welcome*2*menu_sube_bank*#m_dil_9#,store.welcome*2*menu_sube_cheque*#m_dil_10#,store.welcome*2*menu_sube_ch*#m_dil_11#,store.welcome*2*menu_sube_my*#m_dil_12#,store.rivals*0*0*#m_dil_13#,store.list_label*0*0*#m_dil_14#,store.definitions*0*0*#m_dil_15#,store.welcome*2*menu_sube_report*#m_dil_16#">
<cfsavecontent variable="menu_sube_islem_div">
<div id="menu_sube_islem" class="menus2_show" style="position:absolute; margin-left:-2px; width:180px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_islem','','show');" onmouseout="workcube_showHideLayers('menu_sube_islem','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_islem','','show');">
  <cfif not listfindnocase(denied_pages,'store.list_purchase')>		
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_purchase';">
		<td>&nbsp;<cf_get_lang_main no='2267.Stok Hareketleri'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_bill')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_bill';">
		<td>&nbsp;<cf_get_lang_main no='1505.Faturalar'></td>
	</tr>
	</cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_bill_purchase')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_bill_purchase';">
		<td>&nbsp;<cf_get_lang_main no='2298.Alış Fatura'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_bill')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_bill';">
		<td>&nbsp;<cf_get_lang_main no='2299.Satış Fatura'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_bill_retail')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_bill_retail';">
		<td>&nbsp;<cf_get_lang_main no='353.Perakende Satış Faturası'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.product_accept')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_purchase';">
		<td>&nbsp;<cf_get_lang_main no='2300.Alış İrsaliye'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_sale')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_sale';">
		<td>&nbsp;<cf_get_lang_main no='2301.Satış İrsaliye'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_dispatch_internaldemand')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_dispatch_internaldemand';">
		<td>&nbsp;<cf_get_lang_main no='2268.Sevk Talebi Ekle'></td>
	</tr>		
  </cfif>  
  <cfif not listfindnocase(denied_pages,'store.add_ship_dispatch')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_ship_dispatch';">
		<td>&nbsp;<cf_get_lang_main no='2302.Depo Sevk'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_fis')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_fis';">
		<td>&nbsp;<cf_get_lang_main no='2269.Fiş'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_bill_other')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_bill_other';">
		<td>&nbsp;<cf_get_lang_main no='2270.Diğer Alış Ekle'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_internaldemand')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_internaldemand';">
		<td>&nbsp;<cf_get_lang_main no='2271.Satın Alma Talebi'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_order')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_order';">
		<td>&nbsp;&nbsp;<cf_get_lang_main no='795.Satış Siparişleri'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_order_instalment')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_order_instalment';">
		<td>&nbsp;&nbsp;<cf_get_lang_main no='796.Taksitli Satışlar'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_purchase_order')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_purchase_order';">
		<td>&nbsp;&nbsp;<cf_get_lang_main no='2211.Satınalma Siparişleri'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_group_ships')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_group_ships';">
		<td>&nbsp;<cf_get_lang_main no='2272.Grup İçi İrsaliyeler'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_group_ships')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_group_ships';">
		<td>&nbsp;<cf_get_lang_main no='2273.Grup İçi İrsaliye Ekle'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.marketplace_commands') and (session.ep.our_company_info.workcube_sector eq "per")>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.marketplace_commands';">
		<td>&nbsp;<cf_get_lang_main no='2287.Hal İrsaliyeleri'></td>
	</tr>		
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_marketplace_ship') and (session.ep.our_company_info.workcube_sector eq "per")>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_marketplace_ship';">
		<td>&nbsp;<cf_get_lang_main no='2288.Hal İrsaliyesi Ekle'></td>
	</tr>		
  </cfif>
   <cfif not listfindnocase(denied_pages,'store.list_daily_zreport')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_daily_zreport';">
		<td>&nbsp;<cf_get_lang_main no='1026.Z Raporu'></td>
	</tr>		
  </cfif>
   <cfif not listfindnocase(denied_pages,'store.form_add_stock_exchange')>
	<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_stock_exchange';">
		<td>&nbsp;<cf_get_lang_main no='1412.Stok Virman'></td>
	</tr>		
  </cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_urun_div">
<div id="menu_sube_urun" class="menus2_show" style="position:absolute; margin-left:-4px; width:150px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_urun','','show');" onmouseout="workcube_showHideLayers('menu_sube_urun','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_urun','','show');">
	<cfif not listfindnocase(denied_pages,'store.list_products')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_products';">
		<td>&nbsp;<cf_get_lang_main no ='152.Ürünler'></td>
	</tr>	
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.stocks')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.stocks';">
		<td>&nbsp;<cf_get_lang_main no='754.Stoklar'></td>
	</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.list_product_cost')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_product_cost';">
		<td>&nbsp;<cf_get_lang_main no='2277.Urun Maliyetleri'></td>
	</tr>	
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.list_serial_operations')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_serial_operations';">
		<td>&nbsp;<cf_get_lang_main no='2276.Seri Lot İşlemleri'></td>
	</tr>	
	</cfif>
	<cfif not listfindnocase(denied_pages,'objects.serial_no&event=det')>
	<tr height="18"  style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=objects.serial_no&is_store=1','page');">
    	<td>&nbsp;<cf_get_lang_main no ='225.Seri No'></td>
	</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.promotions')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.promotions';">
    	<td>&nbsp;<cf_get_lang_main no='171.promosyon'></td>
	</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.list_store_promotion')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_store_promotion';">
    	<td>&nbsp;<cf_get_lang_main no='1576.Aksiyonlar'></td>
	</tr>
	</cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_uye_div">
<div id="menu_sube_uye" class="menus2_show" style="position:absolute; margin-left:-4px; width:150px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_uye','','show');" onmouseout="workcube_showHideLayers('menu_sube_uye','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_uye','','show');">
    <cfif not listfindnocase(denied_pages,'store.consumer_list')>
      <tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.consumer_list';">
	    <td>&nbsp;<cf_get_lang_main no='1609.Bireysel Üyeler'></td>
      </tr>	
    </cfif>
    <cfif not listfindnocase(denied_pages,'store.form_add_consumer')>
      <tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_consumer';">
	    <td>&nbsp;<cf_get_lang_main no='1610.Bireysel Üye Ekle'></td>
      </tr>	
    </cfif>
    <cfif not listfindnocase(denied_pages,'store.form_list_company')>
	  <tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_list_company';">
		<td>&nbsp;<cf_get_lang_main no='1611.Kurumsal Üyeler'></td>
	  </tr>
	</cfif>
    <cfif not listfindnocase(denied_pages,'store.form_add_company')>
	  <tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_company';">
		<td>&nbsp;<cf_get_lang_main no='1612.Kurumsal Üye Ekle'></td>
	  </tr>	
	</cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_kasa_div">
<div id="menu_sube_kasa" class="menus2_show" style="position:absolute; margin-left:-4px; width:170px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_kasa','','show');" onmouseout="workcube_showHideLayers('menu_sube_kasa','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_kasa','','show');">
  <cfif not listfindnocase(denied_pages,'store.list_cash_actions')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_cash_actions';">
		<td>&nbsp;<cf_get_lang_main no='1485.Kasa İşlemleri'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_cash_to_cash')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cash_to_cash';">
		<td>&nbsp;<cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_cash_rate_valuation')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cash_rate_valuation';">
		<td>&nbsp;<cf_get_lang_main no ='2613.Kasa Kur Değerleme'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_cash_revenue')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cash_revenue';">
		<td>&nbsp;<cf_get_lang_main no ='2284.Nakit Tahsilat'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_cash_payment')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cash_payment';">
		<td>&nbsp;<cf_get_lang_main no='435.Ödeme'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.add_collacted_revenue')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_collacted_revenue';">
		<td>&nbsp;<cf_get_lang_main no='1763.Toplu Tahsilat'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.add_collacted_payment')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_collacted_payment';">
		<td>&nbsp;<cf_get_lang_main no='1765.Toplu Ödeme'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_stores_daily_reports')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_stores_daily_reports';">
		<td>&nbsp;<cf_get_lang_main no='2303.Günlük Finansal Rapor'></td>
	</tr>
  </cfif> 
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_bank_div">
<div id="menu_sube_bank" class="menus2_show" style="position:absolute; margin-left:-4px; width:170px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_bank','','show');" onmouseout="workcube_showHideLayers('menu_sube_bank','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_bank','show');">
	<cfif not listfindnocase(denied_pages,'store.list_bank_account')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_bank_account';">
			<td>&nbsp;<cf_get_lang_main no='1590.Banka Hesapları'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.list_bank_actions')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_bank_actions';">
			<td>&nbsp;<cf_get_lang_main no='1484.Banka İşlemleri'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_bank_account_open')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_bank_account_open';">
			<td>&nbsp;<cf_get_lang_main no='2280.Banka Hesabı Açılışı'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_bank_rate_valuation')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_bank_rate_valuation';">
			<td>&nbsp;<cf_get_lang_main no='1759.Banka Kur Değerleme'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_invest_money')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_invest_money';">
			<td>&nbsp;<cf_get_lang_main no ='2285.Hesaba Para Yatır'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_get_money')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_get_money';">
			<td>&nbsp;<cf_get_lang_main no='2286.Hesaptan Para Çek'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_virman')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_virman';">
			<td>&nbsp;<cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_gelenh')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_gelenh';">
			<td>&nbsp;<cf_get_lang_main no ='422.Gelen Havale'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.form_add_gidenh')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_gidenh';">
			<td>&nbsp;<cf_get_lang_main no ='423.Giden Havale'></td>
		</tr>
	</cfif>   
	<cfif not listfindnocase(denied_pages,'store.list_creditcard_revenue')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_creditcard_revenue';">
			<td>&nbsp;<cf_get_lang_main no='2304.Kredi Kartı Tahsilatları'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.list_payment_credit_cards')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_payment_credit_cards';">
			<td>&nbsp;<cf_get_lang_main no='1751.Kredi Kartı Hesaba Geçiş'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.add_collacted_gelenh')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_collacted_gelenh';">
			<td>&nbsp;<cf_get_lang_main no ='1750.Toplu Gelen Havale'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.add_collacted_gidenh')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_collacted_gidenh';">
			<td>&nbsp;<cf_get_lang_main no ='1758.Toplu Giden Havale'></td>
		</tr>
	</cfif> 
    <cfif not listfindnocase(denied_pages,'store.list_credit_card_expense')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_credit_card_expense';">
			<td>&nbsp;<cf_get_lang_main no='2333.Kredi Kartıyla Ödemeler'></td>
		</tr>
	</cfif>    
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_cheque_div">
<div id="menu_sube_cheque" class="menus2_show" style="position:absolute; margin-left:-4px; width:200px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_cheque','','show');" onmouseout="workcube_showHideLayers('menu_sube_cheque','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_cheque','','show');">
  <cfif not listfindnocase(denied_pages,'store.list_cheque_actions')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_cheque_actions';">
		<td>&nbsp;<cf_get_lang_main no='2290.Çek İşlemleri'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_cheques')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_cheques';">
		<td>&nbsp;<cf_get_lang_main no='2305.Çek Listesi'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_entry')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_entry';">
		<td>&nbsp;<cf_get_lang_main no ='440.Çek Giriş Bordrosu'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_bank_revenue')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_bank_revenue';">
		<td>&nbsp;<cf_get_lang_main no='441.Çek Çıkış - Tahsil'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_bank_guaranty')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_bank_guaranty';">
		<td>&nbsp;<cf_get_lang_main no='2291.Çek Çıkış - Banka'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_bank_guaranty_tem')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_bank_guaranty_tem';">
		<td>&nbsp;<cf_get_lang_main no='442.Çek Çıkış - Banka Teminat'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_endorsement')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_endorsement';">
		<td>&nbsp;<cf_get_lang_main no='2292.Çek Çıkış Bordrosu'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_entry_return')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_entry_return';">
		<td>&nbsp;<cf_get_lang_main no ='444.Çek İade Giriş Bordrosu'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_bank_guaranty_return')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_bank_guaranty_return';">
		<td>&nbsp;<cf_get_lang_main no='444.Çek İade Giriş'>-<cf_get_lang_main no='109.Banka'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_payroll_endor_return')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_payroll_endor_return';">
		<td>&nbsp;<cf_get_lang_main no ='445.Çek İade Çıkış Bordrosu'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_cheque_transfer')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cheque_transfer';">
		<td>&nbsp;<cf_get_lang_main no='2293.Çek Transfer'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_voucher_actions')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_voucher_actions';">
		<td>&nbsp;<cf_get_lang_main no='2294.Senet İşlemleri'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.list_vouchers')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_vouchers';">
		<td>&nbsp;<cf_get_lang_main no='2295.Senet Listesi'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_payroll_entry')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_payroll_entry';">
		<td>&nbsp;<cf_get_lang_main no ='598.Senet Giriş Bordrosu'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_payroll_endorsement')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_payroll_endorsement';">
		<td>&nbsp;<cf_get_lang_main no ='599.Senet Çıkış Bordrosu'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_payroll_revenue')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_payroll_revenue';">
		<td>&nbsp;<cf_get_lang_main no='1808.Senet Çıkış - Tahsil'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_payroll_bank_tah')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_payroll_bank_tah';">
		<td>&nbsp;<cf_get_lang_main no='1803.Senet Çıkış Banka - Tahsil'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_payroll_bank_tem')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_payroll_bank_tem';">
		<td>&nbsp;<cf_get_lang_main no='1804.Senet Çıkış Banka - Teminat'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_voucher_payroll_entry_return')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_voucher_payroll_entry_return';">
		<td>&nbsp;<cf_get_lang_main no ='601.Senet İade Giriş Bordrosu'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_voucher_bank_guaranty_return')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_bank_guaranty_return';">
		<td>&nbsp;<cf_get_lang_main no ='601.Senet İade Giriş Bordrosu'>(<cf_get_lang_main no ='728.Banka'>)</td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_voucher_payroll_endor_return')>
  	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_voucher_payroll_endor_return';">
    	<td>&nbsp;<cf_get_lang_main no='600.Senet İade Çıkış Bordrosu'></td>
    </tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_payment_voucher')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_payment_voucher';">
		<td>&nbsp;<cf_get_lang_main no='1823.Senet Tahsilat'></td>
	</tr>
  </cfif>
   <cfif not listfindnocase(denied_pages,'store.form_add_voucher_transfer')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_voucher_transfer';">
		<td>&nbsp;<cf_get_lang_main no='2289.Senet Transfer'></td>
	</tr>
  </cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_ch_div">
<div id="menu_sube_ch" class="menus2_show" style="position:absolute; margin-left:-4px; width:130px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_ch','','show');" onmouseout="workcube_showHideLayers('menu_sube_ch','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_ch','','show');">
  <cfif not listfindnocase(denied_pages,'store.list_caris')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_caris';">
		<td>&nbsp;<cf_get_lang_main no='2278.Cari Hareketler'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.list_company_extre')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_company_extre&is_page=1';">
		<td>&nbsp;<cf_get_lang_main no ='397.Hesap Ekstresi'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.list_duty_claim')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_duty_claim';">
		<td>&nbsp;<cf_get_lang_main no='2279.Borç Alacak Dökümü'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.list_securefund')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_securefund';">
	<td>&nbsp;<cf_get_lang_main no='264.Teminatlar'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_add_cari_to_cari')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_cari_to_cari';">
	<td>&nbsp;<cf_get_lang_main no='2328.Cari Virman Ekle'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_collacted_cari_virman')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_collacted_cari_virman';">
	<td>&nbsp; <cf_get_lang_main no='645.Toplu'> <cf_get_lang_main no='2328.Cari Virman Ekle'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.popup_form_add_debit_claim_note')>
	<tr height="18"  style="cursor:pointer;" onclick="windowopen('#request.self#?fuseaction=store.popup_form_add_debit_claim_note','medium');">
	<td>&nbsp;<cf_get_lang_main no='650.Dekont'> <cf_get_lang_main no='170.Ekle'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.add_collacted_dekont')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_collacted_dekont';">
		<td>&nbsp;<cf_get_lang_main no='1849.Toplu Dekont'> <cf_get_lang_main no='170.Ekle'></td>
	</tr>
  </cfif>
  <cfif not listfindnocase(denied_pages,'store.form_upd_account_open')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_upd_account_open';">
		<td>&nbsp;<cf_get_lang_main no='1344.Açılış/Devir Fişi'>/<cf_get_lang_main no='1834.Devir Fişi'></td>
	</tr>
  </cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_my_div">
<div id="menu_sube_my" class="menus2_show" style="position:absolute; margin-left:-4px; width:120px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_my','','show');" onmouseout="workcube_showHideLayers('menu_sube_my','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_my','','show');">
  <cfif not listfindnocase(denied_pages,'store.list_cost')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.list_expense_income';">
		<td>&nbsp;<cf_get_lang_main no ='1591.Masraf ve Gelir Fişleri'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.form_add_expense_cost')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.form_add_expense_cost';">
		<td>&nbsp;<cf_get_lang_main no='2296.Masraf Ekle'></td>
	</tr>
  </cfif> 
  <cfif not listfindnocase(denied_pages,'store.add_income_cost')>
	<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.add_income_cost';">
		<td>&nbsp;<cf_get_lang_main no='2297.Gelir Ekle'></td>
	</tr>
  </cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfsavecontent variable="menu_sube_report_div">
<div id="menu_sube_report" class="menus2_show" style="position:absolute; margin-left:-4px; width:130px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_sube_report','','show');" onmouseout="workcube_showHideLayers('menu_sube_report','','hide');">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0"  width="100%" onmouseover="workcube_showHideLayers('menu_sube_report','','show');">
	<cfif not listfindnocase(denied_pages,'store.stock_analyse')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.stock_analyse';">
			<td>&nbsp;<cf_get_lang_main no='606.Stok Analiz Raporu'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.sale_analyse_report')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.sale_analyse_report';">
			<td>&nbsp;<cf_get_lang_main no='2274.Satış Analiz Raporu'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'store.sale_analyse_report_orders')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.sale_analyse_report_orders';">
			<td>&nbsp;<cf_get_lang_main no='2275.Satış Analiz Sipariş'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'report.purchase_analyse_report')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.purchase_analyse_report';">
			<td>&nbsp;<cf_get_lang_main no='2306.Alış Analizi Fatura'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'report.purchase_analyse_report_ship') and fusebox.use_period>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.purchase_analyse_report_ship';">
			<td>&nbsp;<cf_get_lang_main no ='2282.Alış Analizi İrsaliye'></td>
		</tr>
	</cfif> 
	<cfif not listfindnocase(denied_pages,'report.cost_analyse_report') and fusebox.use_period>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.cost_analyse_report';">
			<td>&nbsp;<cf_get_lang_main no='2283.Detaylı Harcama Analizi'></td>
		</tr>
	</cfif>
	<cfif not listfindnocase(denied_pages,'report.detail_budget_report') and fusebox.use_period>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=store.detail_budget_report';">
			<td>&nbsp;<cf_get_lang_main no ='1648.Bütçe Raporu'></td>
		</tr>
	</cfif>
</table>
</cfoutput>
</div>
</cfsavecontent>
<cfset menu_module_layer = "store">
<cfinclude template="../../design/module_menu.cfm">
