<cfinclude template="../../myhome/query/my_sett.cfm">
<cfif isdefined("attributes.employee_id")>
	<cfquery name="GET_EMPLOYEE_NAME" datasource="#dsn#">
	   SELECT 
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.POSITION_CAT_ID,
			EMPLOYEE_POSITIONS.USER_GROUP_ID 
	   FROM 
			EMPLOYEES,
			EMPLOYEE_POSITIONS 
	   WHERE 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery datasource="#dsn#" name="get_ozel_menus">
		SELECT * FROM MAIN_MENU_SETTINGS WHERE (POSITION_CAT_IDS LIKE '%,#GET_EMPLOYEE_NAME.POSITION_CAT_ID#,%' OR USER_GROUP_IDS LIKE '%,#GET_EMPLOYEE_NAME.USER_GROUP_ID#,%' OR TO_EMPS LIKE '%,#GET_EMPLOYEE_NAME.EMPLOYEE_ID#,%') AND IS_ACTIVE = 1
	</cfquery>
<cfelse>
	<cfset get_ozel_menus.recordcount = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33375.Kişisel Ayarlar'></cfsavecontent>
<cf_seperator title="#message#" id="my_settings" is_closed="0">
<table width="98%" id="my_settings" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border" style="display:none;">
	<tr class="color-row"> 
    	<td valign="top"> 
            <cf_area width="50%">
            <cfform name="form1" method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=left">
                <table width="100%">
					<cfif isdefined("attributes.employee_id")>
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                    </cfif>
                    <tr> 
                        <td class="txtboldblue"><cf_get_lang dictionary_id='33376.Tasarım Ayarları'></td>
                    </tr>
                    <tr> 
                        <td class="formbold"><cf_get_lang dictionary_id='33377.Arayüz'></td>
                    </tr>			  
                    <tr> 
                        <td><input type="checkbox" name="standart_menu_closed" id="standart_menu_closed" value="1" <cfif my_sett.standart_menu_closed eq 1>checked</cfif>><cf_get_lang dictionary_id='33378.Standart Menüler Kapalı'></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" name="myhome_quick_menu_page" id="myhome_quick_menu_page" value="1" <cfif my_sett.myhome_quick_menu_page eq 1> checked</cfif>> <cf_get_lang dictionary_id='33380.Anasayfa Hızlı Erişim Açılsın'></td>
                    </tr>			  
                    <tr> 
                        <td><input type="radio" name="interface" id="interface" <cfif get_ozel_menus.recordcount>onFocus="checked_etme_ozel();"</cfif> value="4"  <cfif listfindnocase('1,2,3,4',my_sett.interface_id)>checked</cfif>><cf_get_lang dictionary_id="32470.General"></td>
                    </tr>
                    <tr>
                        <td class="formbold"><cf_get_lang dictionary_id='33384.Özel Menüler'></td>
                    </tr>
                    <cfif isdefined("attributes.employee_id")>
                        <cfoutput query="get_ozel_menus">
                            <tr>
                                <td><input name="ozel_menu_id" id="ozel_menu_id" type="radio" onFocus="checked_etme();" value="#menu_id#" <cfif my_sett.ozel_menu_id eq menu_id>checked</cfif> autocomplete="off"> #menu_name#</td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </table>
                <table width="100%">
                    <tr> 
                        <td class="formbold"><cf_get_lang dictionary_id='33385.Renkler'></td>
                    </tr>
                    <tr> 
                        <td><input type="radio" name="color" id="color" value="1" <cfif my_sett.interface_color eq 1>checked</cfif>><cf_get_lang dictionary_id="33381.Aqua"></td>
                    </tr>
                    <tr> 
                        <td><input type="radio" name="color" id="color" value="2" <cfif my_sett.interface_color eq 2>checked</cfif>><cf_get_lang dictionary_id="32475.Brown"></td>
                    </tr>
                    <tr> 
                        <td><input type="radio" name="color" id="color" value="3" <cfif my_sett.interface_color eq 3>checked</cfif>><cf_get_lang dictionary_id="32478.Orange"></td>
                    </tr>
                    <tr> 
                        <td><input type="radio" name="color" id="color" value="4" <cfif my_sett.interface_color eq 4>checked</cfif>><cf_get_lang dictionary_id="32522.Olive"></td>
                    </tr>
                    <tr> 
                        <td><input type="radio" name="color" id="color" value="5" <cfif my_sett.interface_color eq 5>checked</cfif>><cf_get_lang dictionary_id="32561.Kurşuni"></td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="color" id="color" value="6" <cfif my_sett.interface_color eq 6>checked</cfif>><cf_get_lang dictionary_id="33391.Turkuaz"></td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="color" id="color" value="7" <cfif my_sett.interface_color eq 7>checked</cfif>><cf_get_lang dictionary_id="32567.Natural"></td>
                    </tr>
                </table>
                <table width="100%">
                    <tr> 
                        <td class="txtboldblue" height="9"><cf_get_lang dictionary_id='33392.Dil Tercihim'></td>
                    </tr>
                    <cfquery name="GET_LANG" datasource="#dsn#">
                        SELECT * FROM SETUP_LANGUAGE
                    </cfquery>
					<cfoutput query="get_lang">
                        <tr> 
                            <td><input type="radio" name="lang" id="lang" value="#get_lang.language_short#" <cfif my_sett.language_id eq get_lang.language_short>checked</cfif>>#get_lang.language_set#</td>
                        </tr>
                    </cfoutput>
                    <tr>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='33393.Listeleme Maksimum Kayıt Sayısı'></td>
                    </tr>
                    <tr>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33394.Lütfen 1 ile 250 Arasında Maksimum Kayıt Sayısı Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#my_sett.maxrows#" onKeyUp="isNumber(this);" required="yes" range="1,250" maxlength="3" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='33395.Session Timeout Süresi dk'></td>
                    </tr>
                    <tr>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33396.Timeout Süresi 5 ile 119 Dakika Arasında Olmalı'>!</cfsavecontent>
                            <cfinput type="text" name="TIMEOUT_LIMIT" value="#my_sett.timeout_limit#" onKeyUp="isNumber(this);" required="yes" range="5,119" maxlength="3" validate="integer" message="#message#">
                        </td>
                    </tr> 
                    <tr> 
                        <td>
                            <cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol()'>
                            <cfif len(my_sett.update_emp)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#get_emp_info(my_sett.update_emp,0,0)# - <cfif len(my_sett.update_date)>#dateformat(date_add('h',session.ep.time_zone,my_sett.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,my_sett.update_date),timeformat_style)#</cfif></cfoutput></cfif>
                        </td>
                    </tr>
                 </table>
            </cfform>
            </cf_area>
			<cf_area>
                <cfform method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=right">
                <cfif isdefined("attributes.employee_id")>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                </cfif>
                <table width="100%">
                    <tr> 
                        <td class="txtboldblue" width="200"><cf_get_lang dictionary_id='33397.Kişisel Gündem'></td>
                    </tr>
                    <tr>
                        <td><input type="checkbox" name="my_valids" id="my_valids" <cfif my_sett.my_valids eq 1>checked</cfif>><cf_get_lang dictionary_id='33398.Onaylarım'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="myworks" id="myworks" <cfif my_sett.myworks eq 1>checked</cfif>><cf_get_lang dictionary_id='33399.İşlerim'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="day_agenda" id="day_agenda" <cfif my_sett.day_agenda eq 1>checked</cfif> ><cf_get_lang dictionary_id='33400.Günün Ajandası'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1>checked</cfif>><cf_get_lang dictionary_id='57459.Yazışmalar'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="internaldemand" id="internaldemand" <cfif my_sett.internaldemand eq 1>checked</cfif>><cf_get_lang dictionary_id='33401.İç Talepler'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="markets" id="markets" <cfif my_sett.markets eq 1>checked</cfif>><cf_get_lang dictionary_id='33404.Piyasalar'></td></tr>
                        <tr> 
                            <td><input type="checkbox" name="poll_now" id="poll_now" <cfif my_sett.poll_now eq 1>checked</cfif>><cf_get_lang dictionary_id='33405.Gündemdeki Anketler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="main_news" id="main_news" <cfif my_sett.main_news eq 1>checked</cfif>><cf_get_lang dictionary_id='33406.Workcube Taze İçerik'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="is_kural_popup" id="is_kural_popup" value="1" <cfif my_sett.is_kural_popup eq 1> checked</cfif>><cf_get_lang dictionary_id='33407.Kural Popupları Açılsın'></td>
                        </tr>
                        <tr> 
                            <td class="txtboldblue" width="200"><cf_get_lang dictionary_id='33408.Raporlarım'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="report" id="report" <cfif my_sett.report eq 1>checked</cfif>><cf_get_lang dictionary_id='33408.Raporlarım'></td>
                        </tr>		
                    <cfif not (get_module_user(11) eq 0) and (get_module_user(11) lte 4)>
                        <tr> 
                            <td class="txtboldblue" width="200"><cf_get_lang dictionary_id='33409.Satış Gündemi'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1>checked</cfif>><cf_get_lang dictionary_id='33410.Gelen Siparişler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="offer_given" id="offer_given" <cfif my_sett.offer_given eq 1>checked</cfif>><cf_get_lang dictionary_id='33411.Verilen Teklifler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="sell_today" id="sell_today" <cfif my_sett.sell_today eq 1>checked</cfif>><cf_get_lang dictionary_id='33412.Bugünkü Satışlar'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="promo_head" id="promo_head" <cfif my_sett.promo_head eq 1>checked</cfif>><cf_get_lang dictionary_id='33414.Fırsat Başvuruları'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="most_sell_stock" id="most_sell_stock" <cfif my_sett.most_sell_stock eq 1>checked</cfif>><cf_get_lang dictionary_id='33415.En Çok Satan Ürünler'></td>
                        </tr>
                    </cfif>
                    <cfif not (get_module_user(12) eq 0) and (get_module_user(12) lte 4)>
                        <tr> 
                            <td class="txtboldblue" width="200"><cf_get_lang dictionary_id='33416.Satınalma Gündemi'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="orders_give" id="orders_give" <cfif my_sett.orders_give eq 1>checked</cfif>><cf_get_lang dictionary_id='33419.Verilen Siparişler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="offer_taken" id="offer_taken" <cfif my_sett.offer_taken eq 1>checked</cfif>><cf_get_lang dictionary_id='33421.Gelen Teklifler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="come_again_sip" id="come_again_sip" <cfif my_sett.come_again_sip eq 1>checked</cfif>><cf_get_lang dictionary_id='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="purchase_today" id="purchase_today" <cfif my_sett.purchase_today eq 1>checked</cfif>><cf_get_lang dictionary_id='33424.Bugünkü Alışlar'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="more_stocks_id" id="more_stocks_id" <cfif my_sett.more_stocks_id eq 1>checked</cfif>><cf_get_lang dictionary_id='33425.Fazla Stok Ürünler'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="send_order" id="send_order" <cfif my_sett.send_order eq 1>checked</cfif>><cf_get_lang dictionary_id='33426.Sevk Emirleri'></td>
                        </tr>
                    </cfif>
                    <cfif not (get_module_user(4) eq 0) and (get_module_user(4) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33427.Üye Yönetimi Gündemi'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="pot_cons" id="pot_cons" <cfif my_sett.pot_cons eq 1>checked</cfif>><cf_get_lang dictionary_id='33428.Bireysel Üye Başvuruları'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="pot_partner" id="pot_partner" <cfif my_sett.pot_partner eq 1>checked</cfif>><cf_get_lang dictionary_id='33429.Kurumsal Üye Başvuruları'></td>
                        </tr>
                    </cfif>
                    <cfif not (get_module_user(20) eq 0) and (get_module_user(20) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33430.Fatura Gündemi'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="pre_invoice" id="pre_invoice" <cfif my_sett.pre_invoice eq 1>checked</cfif>><cf_get_lang dictionary_id='33431.Kesilecek Faturalar'></td>
                        </tr>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33432.Servis Gündemi'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="service_head" id="service_head" <cfif my_sett.service_head eq 1>checked</cfif>><cf_get_lang dictionary_id='30039.Servis Başvuruları'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="over_time_acc" id="over_time_acc" <cfif my_sett.over_time_acc eq 1>checked</cfif>><cf_get_lang dictionary_id='33434.Süresi Dolan Destek Hesapları'></td>
                        </tr>
                    </cfif>
                    <cfif not (get_module_user(3) eq 0) and (get_module_user(3) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33435.İK Gündemi'></td>
                        </tr>
                        <tr>
                            <td> <input type="checkbox" name="hr" id="hr" <cfif my_sett.hr eq 1>checked</cfif>><cf_get_lang dictionary_id='33436.İş Başvuruları'></td>
                        </tr>
                        </cfif>
                        <cfif not (get_module_user(15) eq 0) and (get_module_user(15) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33437.Kampanya Gündemi'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="campaign_now" id="campaign_now" <cfif my_sett.campaign_now eq 1>checked</cfif>><cf_get_lang dictionary_id='33438.Gündemdeki Kampanyalar'></td>
                        </tr>
                        </cfif>
                        <cfif not (get_module_user(26) eq 0) and (get_module_user(26) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33439.Üretim Gündemi'></td>
                        </tr>
                        <tr>
                            <td><input type="checkbox" name="product_orders" id="product_orders" <cfif my_sett.product_orders eq 1>checked</cfif>><cf_get_lang dictionary_id='33440.Üretim Emirleri'></td>
                        </tr>
                    </cfif>
                    <cfif not (get_module_user(16) eq 0) and (get_module_user(16) lte 4)>
                        <tr>
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33441.Finans Gündemi'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="pay" id="pay" <cfif my_sett.pay eq 1>checked</cfif>><cf_get_lang dictionary_id='33442.Bugün/Yarın Yapılacak Ödemeler'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="claim" id="claim" <cfif my_sett.claim eq 1>checked</cfif>><cf_get_lang dictionary_id='33443.Bugün Tahsil Edilecek Alacaklar'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="pay_claim" id="pay_claim" <cfif my_sett.pay_claim eq 1>checked</cfif>><cf_get_lang dictionary_id='33444.Borç / Alacak Son Durum (Yöneticiye Özet)'></td>
                        </tr>
                    </cfif>
                        <tr> 
                            <td height="35"> 
                                <cf_workcube_buttons is_upd='0' is_cancel='0'>
                                <cfif len(my_sett.update_emp)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#get_emp_info(my_sett.update_emp,0,0)# - <cfif len(my_sett.update_date)>#dateformat(date_add('h',session.ep.time_zone,my_sett.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,my_sett.update_date),timeformat_style)#</cfif></cfoutput></cfif>
                            </td>
                        </tr>
                    </table>
                    </cfform>
            </cf_area>   
			<cf_area new_line="1">
                <cfform method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_top">
                    <table>
                        <cfif isdefined("attributes.employee_id")>
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        </cfif>
                        <tr> 
                            <td class="txtboldblue"><cf_get_lang dictionary_id='33445.Ajanda Ayarları'></td>
                        </tr>
                        <tr> 
                            <td><input type="checkbox" name="agenda" id="agenda" <cfif my_sett.agenda eq 1>checked</cfif>><cf_get_lang dictionary_id='33446.Ajandamı herkes görsün'></td>
                        </tr>
                        <tr> 
                            <td><cf_get_lang dictionary_id='33447.Saat Ayarı'></td>
                        </tr>
                        <tr> 
                            <td> 
                                <cf_wrkTimeZone width="300">
                                <!--- 17.07.2012 6 ay sonra silinsin P.Y. --->
        <!---						<select name="TIME_ZONE" style="width:300px;">
                                    <option value="-12" <cfif my_sett.time_zone eq -12>selected</cfif>>(GMT-12:00) International Date Line West</option>
                                    <option value="-11" <cfif my_sett.time_zone eq -11>selected</cfif>>(GMT-11:00) Midway Island, Samoa</option>
                                    <option value="-10" <cfif my_sett.time_zone eq -10>selected</cfif>>(GMT-10:00) Hawaii</option>
                                    <option value="-9"  <cfif my_sett.time_zone eq -9> selected</cfif>>(GMT-09:00) Alaska</option>
                                    <option value="-8"  <cfif my_sett.time_zone eq -8> selected</cfif>>(GMT-08:00) Pacific Time (US & Canada); Tijuana</option>
                                    <option value="-7"  <cfif my_sett.time_zone eq -7> selected</cfif>>(GMT-07:00) Mountain Time (US & Canada)</option>
                                    <option value="-6"  <cfif my_sett.time_zone eq -6> selected</cfif>>(GMT-06:00) Saskatchewan</option>
                                    <option value="-5"  <cfif my_sett.time_zone eq -5> selected</cfif>>(GMT-05:00) Eastern Time (US & Canada)</option>
                                    <option value="-4"  <cfif my_sett.time_zone eq -4> selected</cfif>>(GMT-04:00) Atlantic Time (Canada)</option>
                                    <option value="-3"  <cfif my_sett.time_zone eq -3> selected</cfif>>(GMT-03:00) Greenland</option>
                                    <option value="-2"  <cfif my_sett.time_zone eq -2> selected</cfif>>(GMT-02:00) Mid-Atlantic</option>
                                    <option value="-1"  <cfif my_sett.time_zone eq -1> selected</cfif>>(GMT-01:00) Azores</option>
                                    <option value="0"   <cfif my_sett.time_zone eq 0>  selected</cfif>>(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London</option>
                                    <option value="+1"  <cfif my_sett.time_zone eq +1> selected</cfif>>(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna</option>
                                    <option value="+2"  <cfif my_sett.time_zone eq +2> selected</cfif>>(GMT+02:00) Athens, Istanbul, Minsk</option>
                                    <option value="+3"  <cfif my_sett.time_zone eq +3> selected</cfif>>(GMT+03:00) Moscow, St. Petersburg, Volgograd</option>
                                    <option value="+4"  <cfif my_sett.time_zone eq +4> selected</cfif>>(GMT+04:00) Baku, Tbilisi, Yerevan</option>
                                    <option value="+5"  <cfif my_sett.time_zone eq +5> selected</cfif>>(GMT+05:00) Islamabad, Karachi, Tashkent</option>
                                    <option value="+6"  <cfif my_sett.time_zone eq +6> selected</cfif>>(GMT+06:00) Almaty, Novosibirsk</option>
                                    <option value="+7"  <cfif my_sett.time_zone eq +7> selected</cfif>>(GMT+07:00) Bangkok, Hanoi, Jakarta</option>
                                    <option value="+8"  <cfif my_sett.time_zone eq +8> selected</cfif>>(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi</option>
                                    <option value="+9"  <cfif my_sett.time_zone eq +9> selected</cfif>>(GMT+09:00) Osaka, Sapporo, Tokyo</option>
                                    <option value="+10" <cfif my_sett.time_zone eq +10>selected</cfif>>(GMT+10:00) Canberra, Melbourne, Sydney</option>
                                    <option value="+11" <cfif my_sett.time_zone eq +11>selected</cfif>>(GMT+11:00) Magadan, Solomon Is., New Caledonia</option>
                                    <option value="+12" <cfif my_sett.time_zone eq +12>selected</cfif>>(GMT+12:00) Fiji, Kamchatka, Marshall Is.</option>
                                    <option value="+13" <cfif my_sett.time_zone eq +13>selected</cfif>>(GMT+13:00) Nuku'alofa</option>
                                </select>
        --->                	</td>
                        </tr>
                        <tr> 
                            <td> 
                                <cf_workcube_buttons is_upd='0' is_cancel='0'>
                                <cfif len(my_sett.update_emp)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#get_emp_info(my_sett.update_emp,0,0)# - <cfif len(my_sett.update_date)>#dateformat(date_add('h',session.ep.time_zone,my_sett.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,my_sett.update_date),timeformat_style)#</cfif></cfoutput></cfif>
                            </td>
                        </tr>
                    </table>
                </cfform>
                <cfform  name="me" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_down" method="POST">
                
                <cfif isdefined("attributes.employee_id")>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                </cfif>
				<cfif fusebox.use_period>
                <cfquery name="GET_NUMBERS" datasource="#DSN3#">
                    SELECT
                        *
                    FROM
                        PAPERS_NO
                    WHERE
                    <cfif isDefined("attributes.employee_id")>
                       EMPLOYEE_ID = #attributes.employee_id#
                    <cfelse>
                       EMPLOYEE_ID = #session.ep.userid#
                    </cfif>	
                </cfquery>
                <cfif get_numbers.recordcount>
                    <cfoutput>
                        <table width="100%">
                            <tr> 
                                <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='33448.Belge No Ayarları'></td>
                            </tr>
                            <tr> 
                                <td width="90">&nbsp;<cf_get_lang dictionary_id='33449.Tah Makbuzu No'></td>
                                <td> 
                                    <input type="text" name="revenue_receipt_no" id="revenue_receipt_no" value="#get_numbers.revenue_receipt_no#" style="width:80px;">
                                    <input type="text" name="revenue_receipt_number" id="revenue_receipt_number" value="#get_numbers.revenue_receipt_number#" size="4" style="width:50px;">
                                </td>
                            </tr>
                            <tr> 
                                <td>&nbsp;<cf_get_lang dictionary_id='58133.Fatura No'></td>
                                <td> 
                                    <input type="text" name="invoice_no" id="invoice_no" value="#get_numbers.invoice_no#" style="width:80px;">
                                    <input type="text" name="invoice_number" id="invoice_number" value="#get_numbers.invoice_number#" size="4" style="width:50px;">
                                </td>
                            </tr>
                            <tr> 
                                <td>&nbsp;<cf_get_lang dictionary_id='58138.İrsaliye No'></td>
                                <td> 
                                    <input type="text" name="ship_no" id="ship_no" value="#get_numbers.ship_no#" style="width:80px;">
                                    <input type="text" name="ship_number" id="ship_number" value="#get_numbers.ship_number#" size="4" style="width:50px;">
                                </td>
                            </tr>
                        </table>
                    </cfoutput>
                <cfelse>
                    <table width="100%">
                        <tr> 
                            <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='33448.Belge No Ayarları'></td>
                        </tr>
                        <tr> 
                            <td width="90">&nbsp;<cf_get_lang dictionary_id='33449.Tah Makbuzu No'></td>
                            <td> 
                                <input type="text" name="revenue_receipt_no" id="revenue_receipt_no" style="width:80px;">
                                <input type="text" name="revenue_receipt_number" id="revenue_receipt_number"  size="4" style="width:50px;">
                            </td>
                        </tr>
                        <tr> 
                            <td>&nbsp;<cf_get_lang dictionary_id='58133.Fatura No'></td>
                            <td> 
                                <input type="text" name="invoice_no" id="invoice_no"  style="width:80px;">
                                <input type="text" name="invoice_number" id="invoice_number" size="4" style="width:50px;">
                            </td>
                        </tr>
                        <tr> 
                            <td>&nbsp;<cf_get_lang dictionary_id='58138.İrsaliye No'></td>
                            <td> 
                                <input type="text" name="ship_no" id="ship_no"  style="width:80px;">
                                <input type="text" name="ship_number" id="ship_number"  size="4" style="width:50px;">
                            </td>
                        </tr>
                    </table>
                </cfif>
				</cfif>
                <br/>
                <table width="100%">
                    <tr> 
                        <td class="txtboldblue" colspan="2"><cf_get_lang dictionary_id='33451.Kişisel İletişim Grupları'><a href="##" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_users&process=sett</cfoutput>','list')"><img src="/images/plus_list.gif" border="0"></a></td>
                    </tr>
                    <cfquery name="GET" datasource="#DSN#">
                        SELECT 
                            * 
                        FROM 
                            USERS
                        WHERE
                        <cfif isDefined("attributes.employee_id")>
                            RECORD_MEMBER = #attributes.employee_id#
                        <cfelse>
                            RECORD_MEMBER = #session.ep.userid#
                        </cfif>	
                    </cfquery>
                    <cfoutput>
                        <cfloop from="1" to="#get.recordcount#" index="i">
                            <tr>
                                <td align="left" valign="top"><a href="##" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_USERS&group_id=#get.GROUP_ID[i]#&process=sett','list')" class="tableyazi">#get.GROUP_NAME[i]#</a></td>
                                <td>
                                    <cfset attributes.par_ids = #get.partners[i]#>
                                    <cfif len(attributes.par_ids)>
                                        <cfinclude template="../../myhome/query/get_company_partner.cfm">
                                        <cfloop list="#valuelist(get_company_partner.fullname)#" index="j">#j#,</cfloop>
                                    </cfif>
                                    
                                    <cfset attributes.cons=#get.consumers[i]#>
                                    <cfif len(attributes.cons)>
                                        <cfinclude template="../../myhome/query/get_consumer_det.cfm">
                                        <cfloop list="#valuelist(get_consumer_det.consumer_name)#" index="s">#s#,</cfloop>
                                    </cfif>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </table>
                <table width="100%">
                    <cfquery name="GET_POS_CODE" datasource="#DSN#">
                        SELECT 
                        POSITION_CODE
                        FROM 
                        EMPLOYEE_POSITIONS
                        WHERE
                        <cfif isDefined("attributes.employee_id")> 
                            EMPLOYEE_ID = #attributes.employee_id#
                        <cfelse>  
                            EMPLOYEE_ID = #session.ep.userid# 
                        </cfif>  
                    </cfquery>
                    <cfquery name="GET_MYGROUPS" datasource="#DSN#">
                        SELECT 
                        WORKGROUP_NAME,
                        WORKGROUP_ID
                        FROM
                        WORK_GROUP
                        WHERE
                        WORKGROUP_ID IN (SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #get_pos_code.position_code#)
                    </cfquery>
                    <tr>
                        <td class="txtboldblue"><cf_get_lang dictionary_id='29818.İş Grupları'></td>
                    </tr>
                    <cfif get_mygroups.recordcount>
                        <cfoutput query="get_mygroups">
                            <tr> 
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_workgroup&workgroup_id=#workgroup_id#','small');" class="tableyazi">#workgroup_name#</a></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                        </tr>
                    </cfif>	
                </table>
                <br/>
                <table width="100%">
                    <tr> 
                        <td>
                            <cf_workcube_buttons is_upd='0' is_cancel='0'><br/>
                            <cfif len(my_sett.update_emp)><cf_get_lang dictionary_id='57703.Güncelleme'> : <cfoutput>#get_emp_info(my_sett.update_emp,0,0)# - <cfif len(my_sett.update_date)>#dateformat(date_add('h',session.ep.time_zone,my_sett.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,my_sett.update_date),timeformat_style)#</cfif></cfoutput></cfif>
                        </td>
                    </tr>
                </table>
                <cfif my_sett.favorItes eq 1><cfinclude template="../../myhome/includes/list_favourites.cfm"></cfif>
                </cfform>
            </cf_area>
    	</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{ 
	<cfif get_ozel_menus.recordcount eq 0>
		if(document.form1.standart_menu_closed.checked == true)
		{  
			alert("<cf_get_lang dictionary_id='33453.Çalışan İçin Seçili Özel Menü Bulunmamaktadır Standart Menu Seçiniz'>!");
			return false;		
		 }
	</cfif>
}

function checked_etme_ozel()
{
	if (document.form1.ozel_menu_id.length != undefined) /*n tane*/
	{
		for (i=0; i < form1.ozel_menu_id.length; i++)
		{
			document.form1.ozel_menu_id[i].checked = false;
		}
	}
	else 
		document.form1.ozel_menu_id.checked = false;
}

function checked_etme()
{
	if(document.form1.interface.length != undefined) /* n tane*/
	{
		for (i=0; i < form1.interface.length; i++)
		{
			document.form1.interface[i].checked = false;
		}
	}
	else
		document.form1.interface.checked = false;
}
</script>
