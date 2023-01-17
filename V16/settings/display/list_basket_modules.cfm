<cfset attributes.bskt_list=1>
<cfinclude template="../query/get_basket_details.cfm">
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='227.Basket Şablonları'></td>
	</tr>
	<cfif GET_BASKET.RecordCount >
		<cfoutput query="GET_BASKET">
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
			<td>
				<a href="#request.self#?fuseaction=settings.form_upd_bskt_detail&id=#ID#" class="tableyazi">
					<cfif BASKET_ID eq 34><cf_get_lang no='760.Bütçe Satış Kotaları'></cfif>		
					<cfif BASKET_ID eq 23><cf_get_lang no='105.Call Center Servis'></cfif>
					<cfif BASKET_ID eq 29><cf_get_lang no='110.Kataloglar'></cfif>
					<cfif BASKET_ID eq 33><cf_get_lang_main no='411.Müstahsil Makbuzu'></cfif>			
					<cfif BASKET_ID eq 30><cf_get_lang no='751.Partner Diğer Servis Detayları'></cfif>
					<cfif BASKET_ID eq 35><cf_get_lang no='820.Partner Portal Alım Siparişi'></cfif>
					<cfif BASKET_ID eq 36><cf_get_lang no='821.Partner Portal Alım Teklifi'></cfif>
					<cfif BASKET_ID eq 24><cf_get_lang no='822.Partner Portal Teklifler Satış'></cfif>
					<cfif BASKET_ID eq 25><cf_get_lang no='823.Partner Portal SiparişlerSatış'></cfif>
					<cfif BASKET_ID eq 26><cf_get_lang no='107.Partner Portal Ürün Katalogları'></cfif>
					<cfif BASKET_ID eq 27><cf_get_lang no='108.Partner Portal Servis'></cfif>
					<cfif BASKET_ID eq 28><cf_get_lang no='109.Public Portal Basket'></cfif>
					<cfif BASKET_ID eq 1><cf_get_lang no='84.Satınalma Faturası'></cfif>
					<cfif BASKET_ID eq 7><cf_get_lang no='89.Satınalma İç Talepleri'></cfif>
					<cfif BASKET_ID eq 5><cf_get_lang no='88.Satınalma Teklifi'></cfif>
					<cfif BASKET_ID eq 6><cf_get_lang no='71.Satınalma Siparişi'></cfif>
					<cfif BASKET_ID eq 2><cf_get_lang no='85.Satış Faturası'></cfif>
					<cfif BASKET_ID eq 3><cf_get_lang no='86.Satış Teklifi'> </cfif>
					<cfif BASKET_ID eq 4><cf_get_lang no='87.Satış Siparişi'></cfif>
					<cfif BASKET_ID eq 13><cf_get_lang no='95.Stok Açılış Fişi'></cfif>
					<cfif BASKET_ID eq 11><cf_get_lang no='93.Stok Alım İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 12><cf_get_lang no='528.Stok Fişi Ekle'></cfif>
					<cfif BASKET_ID eq 10><cf_get_lang no='92.Stok Satış İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 14><cf_get_lang no='96.Stok Satış Siparişi'></cfif>
					<cfif BASKET_ID eq 31><cf_get_lang no='747.Stok Sevk İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 17><cf_get_lang no='99.Şube Alım İrsaliyesi'></cfif> 
					<cfif BASKET_ID eq 15><cf_get_lang no='98.Stok Alım Siparişi'></cfif>			
					<cfif BASKET_ID eq 20><cf_get_lang no='102.Şube Alış Faturası'></cfif>
					<cfif BASKET_ID eq 37><cf_get_lang no='832.Sube Alım Siparişi'></cfif>
					<cfif BASKET_ID eq 39><cf_get_lang no='314.Şube İç Talepler'></cfif>	
					<cfif BASKET_ID eq 18><cf_get_lang no='100.Şube Satış Faturası'></cfif>			
					<cfif BASKET_ID eq 21><cf_get_lang no='103.Şube Satış İrsaliyesi'>- </cfif>
					<cfif BASKET_ID eq 38><cf_get_lang no='758.Sube Satış Siparişi'></cfif>
					<cfif BASKET_ID eq 32><cf_get_lang no='748.Şube Sevk İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 19><cf_get_lang no='101.Şube Stok Fişi'></cfif> 
					<cfif BASKET_ID eq 16><cf_get_lang no='97.Ürün Katalog Ekle'></cfif>
					<cfif BASKET_ID eq 8><cf_get_lang no='90.Yazışmalar İç Talepler'></cfif>					
					<cfif BASKET_ID eq 41><cf_get_lang no='348.Stok Hal İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 40><cf_get_lang no='356.Şube Hal İrsaliyesi'></cfif>
					<cfif BASKET_ID eq 42><cf_get_lang_main no='407.Hal Faturası'></cfif>
					<cfif BASKET_ID eq 43><cf_get_lang no='422.Şube Hal Faturası'></cfif>
					<cfif BASKET_ID eq 44><cf_get_lang no='475.Sevk İç Talep'></cfif>
					<cfif BASKET_ID eq 45><cf_get_lang no='498.Şube Sevk İç Talep'></cfif>
					<cfif BASKET_ID eq 46><cf_get_lang_main no='1420.Abone'></cfif>
					<cfif BASKET_ID eq 47><cf_get_lang no='1055.Servis Giriş'></cfif>
					<cfif BASKET_ID eq 48><cf_get_lang no='1056.Servis Çıkış'></cfif>
					<cfif BASKET_ID eq 49><cf_get_lang_main no='1791.İthal Mal Girişi'></cfif>
					<cfif BASKET_ID eq 50><cf_get_lang no='1465.Proje Malzeme Planı'></cfif>
					<cfif BASKET_ID eq 51><cf_get_lang no='1588.Taksitli Satış'></cfif>
					<cfif BASKET_ID eq 52><cf_get_lang_main no='1026.Z Raporu'></cfif>
				</a>
			</td>
		</tr>
	  </cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
		</tr>
	 </cfif>
</table>
