<cfinclude template="../query/my_sett.cfm">
<cfquery name="get_employee_name" datasource="#DSN#">
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<cfinclude template="../../objects/display/tree_back.cfm">
    	<td valign="top"> 
		<cfoutput>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td height="35" class="headbold">
					<cfif isdefined("attributes.employee_id")>
						#get_employee_name.employee_name# #get_employee_name.employee_surname# : <cf_get_lang dictionary_id='57413.Gündem'>
					<cfelse>
						#session.ep.name# #session.ep.surname# : <cf_get_lang dictionary_id='57413.Gündem'>
					</cfif>
				</td>
			</tr>
		</table>
	    </cfoutput>
		<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
		<cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=right" method="post">
			<tr class="color-row">
				<cfif isdefined("attributes.employee_id")>
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
				</cfif>
				<td valign="top" width="350">
				<table width="100%">
					<tr>
						<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='30834.Kişisel Gündem'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="my_valids" id="my_valids" <cfif my_sett.my_valids eq 1> checked</cfif>><cf_get_lang dictionary_id='30761.Onaylarım'></td>
					</tr>
				<cfif get_module_user(1)>
					<tr>
						<td><input type="checkbox" name="myworks" id="myworks" <cfif my_sett.myworks eq 1> checked</cfif>><cf_get_lang dictionary_id='30780.İşlerim'></td>
					</tr>
				</cfif>
				<cfif get_module_user(6)>
					<tr>
						<td nowrap="nowrap">
							<input type="checkbox" name="day_agenda" id="day_agenda" onClick="private_agenda_display();" <cfif my_sett.day_agenda eq 1> checked</cfif>>
							<cf_get_lang dictionary_id='30835.Günün Ajandası'>&nbsp;
							<div id="private_agenda_id" style="position:absolute">
								<input type="checkbox" name="private_agenda" id="private_agenda" <cfif my_sett.private_agenda eq 1>checked</cfif>>
							<cf_get_lang dictionary_id='31892.Benim Ajandam'>							
							</div>
						</td>
					</tr>
					<cfif my_sett.day_agenda eq 1>
						<script type="text/javascript">
							goster(document.getElementById('private_agenda_id'));
						</script>
					<cfelseif my_sett.DAY_AGENDA neq 1>
						<script type="text/javascript">
							gizle(document.getElementById('private_agenda_id'));
						</script>
					</cfif>
				</cfif>
					<tr>
						<td><input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1> checked</cfif>><cf_get_lang dictionary_id='57459.Yazışmalar'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="internaldemand" id="internaldemand" <cfif my_sett.internaldemand eq 1> checked</cfif>><cf_get_lang dictionary_id='30782.İç Talepler'></td>
					</tr>
				<cfif get_module_user(39)>
					<tr>
						<td><input type="checkbox" name="new_mails" id="new_mails" <cfif my_sett.new_mails eq 1> checked</cfif>><cf_get_lang dictionary_id='30837.Mailler'></td>
					</tr>
				</cfif>
					<tr>
						<td>
							<input type="checkbox" name="markets" id="markets" <cfif my_sett.markets eq 1> checked</cfif>>
							<cfsavecontent variable="piyasa"><cf_get_lang dictionary_id='30839.Piyasalar'></cfsavecontent>
							<cfset piyasa = '#left(piyasa,2)##lcase(mid(piyasa,3,len(piyasa)))#'>
							<cfoutput>#piyasa#</cfoutput> 
						</td>
					</tr>
					<tr>
						<td><input type="checkbox" name="poll_now" id="poll_now" value="1" <cfif my_sett.poll_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30840.Gündemdeki Anketler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="main_news" id="main_news" value="1" <cfif my_sett.main_news eq 1> checked</cfif>><cf_get_lang dictionary_id='30779.Workcube Taze İçerik'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="is_kural_popup" id="is_kural_popup" value="1" <cfif my_sett.is_kural_popup eq 1> checked</cfif>><cf_get_lang dictionary_id ='32375.Kural Popupları Açılsın'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="is_kariyer" id="is_kariyer" value="1" <cfif my_sett.is_kariyer eq 1> checked</cfif>><cf_get_lang dictionary_id ='31501.Şirket İçi İş İlanları'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="is_birthdate" id="is_birthdate" value="1" <cfif my_sett.is_birthdate eq 1> checked</cfif>> <cf_get_lang dictionary_id ='57896.Doğum Günleri'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="attending_workers" id="attending_workers" value="1" <cfif my_sett.attending_workers eq 1> checked</cfif>><cf_get_lang dictionary_id ='30852.İşe Yeni Başlayanlar'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="is_video" id="is_video" value="1" <cfif my_sett.is_video eq 1> checked</cfif>><cf_get_lang dictionary_id ='31919.Videolar'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="is_forum" id="is_forum" value="1" <cfif my_sett.is_forum eq 1> checked</cfif>><cf_get_lang dictionary_id ='58128.Forumlar'></td>
					</tr>
				<cfif get_module_user(11)>
					<tr>
						<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='30841.Satış Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="my_buyers" id="my_buyers" <cfif my_sett.my_buyers eq 1> checked</cfif>><cf_get_lang dictionary_id='30762.Müşterilerim'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1> checked</cfif>><cf_get_lang dictionary_id='30842.Gelen (Alınan) Siparişler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="offer_given" id="offer_given" <cfif my_sett.offer_given eq 1> checked</cfif>><cf_get_lang dictionary_id='30785.Verilen Teklifler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="sell_today" id="sell_today" <cfif my_sett.sell_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30843.Bugünkü Satışlar (Bugünkü Satış Faturaları)'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="promo_head" id="promo_head" <cfif my_sett.promo_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30844.Fırsat Başvuruları'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="most_sell_stock" id="most_sell_stock" <cfif my_sett.most_sell_stock eq 1> checked</cfif>><cf_get_lang dictionary_id='30788.En Çok Satan Ürünler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="offer_to_give" id="offer_to_give" <cfif my_sett.offer_to_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30845.Gelen Teklif İstekleri (Verilecek Teklifler)'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="new_stocks" id="new_stocks" <cfif my_sett.new_stocks eq 1> checked</cfif>><cf_get_lang dictionary_id='31486.Stoğa Yeni Gelen Ürünler'></td>
					</tr>
				</cfif>
				<cfif get_module_user(36)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30846.Finans Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="pay" id="pay" <cfif my_sett.pay eq 1> checked</cfif>><cf_get_lang dictionary_id='30847.Bugün/Yarın Yapılacak Ödemeler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="claim" id="claim" <cfif my_sett.claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30848.Bugün Tahsil Edilecek Alacaklar'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="pay_claim" id="pay_claim" <cfif my_sett.pay_claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30849.Borç / Alacak Son Durum (Yöneticiye Özet)'></td>
					</tr>
				</cfif>
				</table>
				</td>
				<td valign="top">
				<table width="100%">
					<tr>
						<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='30764.Raporlarım'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="report" id="report" <cfif my_sett.report eq 1> checked</cfif>><cf_get_lang dictionary_id='30764.Raporlarım'></td>
					</tr>
				<!--- Satınalma Gündemi Başladı --->
				<cfif get_module_user(12)>
					<tr>
						<td class="txtboldblue" width="200"><cf_get_lang dictionary_id='30850.Satınalma Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="my_sellers" id="my_sellers" <cfif my_sett.my_sellers eq 1> checked</cfif>><cf_get_lang dictionary_id='30763.Tedarikçilerim'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="orders_give" id="orders_give" <cfif my_sett.orders_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30851.Verilen Siparişler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="offer_taken" id="offer_taken" <cfif my_sett.offer_taken eq 1> checked</cfif>><cf_get_lang dictionary_id='31893.Gelen (Alınan) Teklifler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="come_again_sip" id="come_again_sip" <cfif my_sett.come_again_sip eq 1> checked</cfif>><cf_get_lang dictionary_id='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="purchase_today" id="purchase_today" <cfif my_sett.purchase_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30853.Bugünkü Alışlar (Bugünkü Alış Faturaları)'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="more_stocks_id" id="more_stocks_id" <cfif my_sett.more_stocks_id eq 1> checked</cfif>><cf_get_lang dictionary_id='30854.Fazla Stok Ürünler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="send_order" id="send_order" <cfif my_sett.send_order eq 1> checked</cfif>><cf_get_lang dictionary_id='30795.Sevk Emirleri'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="offer_to_take" id="offer_to_take" <cfif my_sett.offer_to_take eq 1> checked</cfif>><cf_get_lang dictionary_id='30855.Alınacak Teklifler'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="new_product" id="new_product" <cfif my_sett.new_product eq 1> checked</cfif>><cf_get_lang dictionary_id='30796.Yeni Ürünler'></td>
					</tr>
				</cfif>
				<!--- Uye --->
				<cfif get_module_user(4)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30856.Üye Yönetimi Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="pot_cons" id="pot_cons" <cfif my_sett.pot_cons eq 1> checked</cfif>><cf_get_lang dictionary_id='30797.Bireysel Üye Başvuruları'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="pot_partner" id="pot_partner" <cfif my_sett.pot_partner eq 1> checked</cfif>><cf_get_lang dictionary_id='30798.Kurumsal Üye Başvuruları'></td>
					</tr>
				</cfif>
				<!--- Fatura --->
				<cfif get_module_user(20)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30814.Fatura Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="pre_invoice" id="pre_invoice" <cfif my_sett.pre_invoice eq 1> checked</cfif>><cf_get_lang dictionary_id='30801.Kesilecek Faturalar'></td>
					</tr>
				</cfif>
				<cfif get_module_user(14)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30857.Servis Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="service_head" id="service_head" <cfif my_sett.service_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30039.Servis Başvuruları'></td>
					</tr>
					<!--- <tr>
						<td><input type="checkbox" name="over_time_acc" <cfif my_sett.over_time_acc eq 1> checked</cfif>><cf_get_lang no='46.Süresi Dolan Destek Hesapları'></td>
					</tr> --->
					<tr>
						<td><input type="checkbox" name="spare_part" id="spare_part" <cfif my_sett.spare_part eq 1> checked</cfif>><cf_get_lang dictionary_id='30938.Beklenen Yedek Parçalar'></td>
					</tr>
				</cfif>
				<!--- ik --->
				<cfif get_module_user(3)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30858.İK Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="hr" id="hr" <cfif my_sett.hr eq 1> checked</cfif>><cf_get_lang dictionary_id='30799.İK Başvuruları'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="finished_test_times" id="finished_test_times" <cfif my_sett.finished_test_times eq 1> checked</cfif>><cf_get_lang dictionary_id='31121.Deneme Süresi Bitenler'></td>
					</tr>
					<!--- Sozlesmesi Bitenler --->
					<tr>
						<td><input type="checkbox" name="sureli_is_finishdate" id="sureli_is_finishdate" <cfif my_sett.sureli_is_finishdate eq 1> checked</cfif>><cf_get_lang dictionary_id ='31989.Süreli İş Akdi Bitenler'></td>
					</tr>
					<!---<tr>
						<td><input type="checkbox" name="leaving_workers" id="leaving_workers" <cfif my_sett.leaving_workers eq 1> checked</cfif>><cf_get_lang no='365.İşten Ayrılanlar'></td>
					</tr>--->
				</cfif>
				<!--- kampanya --->
				<cfif get_module_user(15)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30859.Kampanya Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="campaign_now" id="campaign_now" <cfif my_sett.campaign_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30800.Gündemdeki Kampanyalar'></td>
					</tr>
				</cfif>
				<!--- Uretim --->
				<cfif get_module_user(26)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='30860.Üretim Gündemi'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="product_orders" id="product_orders" <cfif my_sett.product_orders eq 1> checked</cfif>><cf_get_lang dictionary_id='30804.Üretim Emirleri'></td>
					</tr>
				</cfif>
				<cfif get_module_user(17)>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='57437.Anlaşmalar'></td>
					</tr>
					<tr>
						<td><input type="checkbox" name="old_contracts" id="old_contracts" <cfif my_sett.old_contracts eq 1> checked</cfif>><cf_get_lang dictionary_id='31089.Süresi Dolan Anlaşmalar'></td>
					</tr>
				</cfif>
					<tr>
						<td height="35"> <cf_workcube_buttons is_upd='0'></td>
					</tr>
				</table>
				</td>
			</tr>
		</cfform>
		</table>
    	</td>
	</tr>
</table>
<br/>

<script type="text/javascript">
function private_agenda_display()
{
	if(document.getElementById('day_agenda').checked == false)
	{
		document.getElementById('private_agenda').checked == false;
		gizle(private_agenda_id);
	}
	else if(document.getElementById('day_agenda').checked == true)
		goster(private_agenda_id);
}
</script>
