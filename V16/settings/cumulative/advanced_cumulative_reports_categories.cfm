<table cellspacing="1" cellpadding="2"  border="0" width="98%" align="center" class="color-head">
	<tr>
		<td class="headbold" height="35"><cf_get_lang no='2666.Kümülatif Rapor Oluşturma Ayarları'></td>
	</tr>
</table>
<table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border">
	<tr class="color-row">
    	<td width="400" valign="top">
        	<table>
                <tr>
                    <td valign="top">
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(stocks);"><strong><cf_get_lang_main no='754.Stoklar'></strong></a><br/>
						<span id="stocks">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;" id="STOCK_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2659.İşlem Tipi Bazında Stok İşlemleri'></a><br/>
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;" id="STOCK_LOCATION_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2656.Depolara Bazında Stok Toplamları'></a><br/>                    
						</span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(caris);"><strong><cf_get_lang no='2658.Cari İşlemler'></strong></a><br/>
						<span id="caris">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;" id="CARI_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2661.Cari İşlemler(İşlem Tipi ve Projeler Bazında)'></a><br/>                    
						</span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(sales);"><strong><cf_get_lang no='2657.Alış-Satış'></strong></a><br/>
						<span id="sales">
                            <img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"  id="SALES_PRODUCT_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2668.Stok Bazında Satışlar'></a><br/>
                            <img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"  id="SALES_CUSTOMER_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2669.Müşteri/Tedarikçi Bazında Satışlar'></a><br/>
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"  id="SALES_PURCHASE_PRODUCT_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2670.Stok Bazında Alış ve Satışlar'></a><br/>
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"  id="SALES_PURCHASE_CUSTOMER_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2671.Müşteri/Tedarikçi Bazında Alış ve Satışlar'></a><br/>
                        </span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(expense);"><strong><cf_get_lang no='2660.Harcamalar'></strong></a><br/>
						<span id="expense">
                        	<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;" id="EXPENSE_MONTH"  onClick="get_detail_report(this);"><cf_get_lang no='2667.Detaylı Harcamalar'></a><br/>
                        </span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(manufact);"><strong><cf_get_lang_main no='44.Üretim'></strong></a><br/>
						<span id="manufact">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;" id="PRODUCTION_MONTH" onClick="get_detail_report(this);"><cf_get_lang no='2672.İstasyon Bazında Üretim Sonuçları'></a><br/>
						</span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(service);"><strong><cf_get_lang no='2663.Servis ve Garanti'></strong></a><br/>
						<span id="service" style="display:none;">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"><cf_get_lang no='2673.Müşteri Bazında Servis İşlemleri'></a><br/>
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"><cf_get_lang no='2674.Ürün Bazında Servis İşlemleri'></a><br/>                    
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"><cf_get_lang no='2675.Abonelik ve Destek Sözleşmeleri'></a><br/>                    
                        </span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(member);"><strong><cf_get_lang no='2676.Müşteri ve İş Geliştirme'></strong></a><br/>
						<span id="member" style="display:none;">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"><cf_get_lang no='2677.Çalışan Bazında İş Geliştirme Aktiviteleri'></a><br/>                    
						</span>
						<img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(employee);"><strong><cf_get_lang_main no='1864.HR'></strong></a><br/>
						<span id="employee" style="display:none;">
							<img src="/images/tree_3.gif" align="absmiddle" border="0"><a style="cursor:pointer;"><cf_get_lang no='2678.Depatman Bazında İK Aktiviteleri'></a><br/>                    
						</span>
					</td>
                </tr>
 			</table>
            <br/>
        </td>
        <td valign="top">
            <div id="report_categoris"></div>
        </td>
    </tr>
</table>
<script type="text/javascript">
	var selected_link_id ='';
	function get_detail_report(object_){
		document.getElementById(object_.id).style.color ='red';
		if(selected_link_id && selected_link_id != object_.id) document.getElementById(selected_link_id).style.color ='';
		selected_link_id = object_.id;
		AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=settings.ajax_emptypopup_advanced_cumulative_reports_type&report_name='+object_.innerHTML+'&report_table_name='+object_.id+''</cfoutput>,'report_categoris',1)
	}
</script>
