<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfset get_date_bugun = dateformat(createdate(session.pda.period_year,month(now()),day(now())),'dd/mm/yyyy')>
<cfparam name="attributes.ship_date" default="#get_date_bugun#">
<cfif not (isDefined("xml_process_cat") and Len(xml_process_cat))>
	<!--- Xmlde Tanimli Olmayan Islem Tipleri Icin Default Sistemden Bir Tip Ataniyor --->
	<cfset default_process_type = 71>
	<cfinclude template="../query/get_process_cat.cfm">
	<cfset xml_process_cat = get_process_cat.process_cat_id>
</cfif>
<cfif fusebox.fuseaction contains 'form_add_purchase_return'>
	<cfset Head_ = "Alım İade İrsaliyesi">
<cfelse>
	<cfset Head_ = "Satış İrsaliyesi">
</cfif>
<!--- Default Sayfa Parametreleri - Ekleme ve Guncelleme Buradan Calisacagi Icin Duzenlendi --->
<cfset attributes.ship_date = DateFormat(createdate(session.pda.period_year,month(now()),day(now())),'dd/mm/yyyy')>
<cfset attributes.ship_number = "">
<cfset attributes.process_cat = "">
<cfset attributes.department_id = "">
<cfset attributes.location_id = "">
<cfset attributes.order_id_listesi = "">
<cfset attributes.order_id = "">
<cfset attributes.order_row_count = 0>
<cfset attributes.ship_row_count = 0>
<cfif isDefined("xml_show_member_info") and xml_show_member_info eq 1 and isDefined("attributes.company_id") and Len(attributes.company_id)>
	<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
		SELECT FULLNAME,MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfset attributes.consumer_id = "">
	<cfset attributes.comp_name = get_company_info.fullname>
	<cfset attributes.member_type = "partner">
	<cfset attributes.partner_id = get_company_info.manager_partner_id>
	<cfset attributes.partner_name = get_par_info(get_company_info.manager_partner_id,0,-1,0)>
<cfelse>
	<cfset attributes.consumer_id = "">
	<cfset attributes.company_id = "">
	<cfset attributes.comp_name = "">
	<cfset attributes.member_type = "">
	<cfset attributes.partner_id = "">
	<cfset attributes.partner_name = "">
</cfif>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">#head_#</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
			<cfform name="add_sale" id="add_sale" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale" enctype="multipart/form-data">  
                <table>
                    <input type="hidden" name="sale" id="sale" value="1"><!--- satış --->
                    <input type="hidden" name="basket_due_value" id="basket_due_value" value="">
                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                    <input type="hidden" name="commethod_id" id="commethod_id" value="">
                    <input type="hidden" name="service_id" id="service_id" value="">
                    <input type="hidden" name="stock_id" id="stock_id" value="">
                    <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date"> 
                    <input type="hidden" name="ship_method" id="ship_method" value="">
                    <input type="hidden" name="ship_method_name" id="ship_method_name" value="">                
                    <input type="hidden" name="project_id" id="project_id" value="">
                    <input type="hidden" name="project_head" id="project_head" value="">                
                    <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="">
                    <input type="hidden" name="irsaliye" id="irsaliye" value="">
                    <input type="hidden" name="sale_emp" id="sale_emp" value="">
                    <input type="hidden" name="sale_emp_name" id="sale_emp_name" value="">
                    <input type="hidden" name="detail" id="detail" value="">
                    <input type="hidden" name="ref_no" id="ref_no" value="">
                    <input type="hidden" name="paper_number" id="paper_number" value="<cfif isdefined("paper_number")>#paper_number#</cfif>">
                    <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
                    <input type="hidden" name="active_period" id="active_period" value="#session.pda.period_id#">
                    <input type="hidden" name="deliver_date_frm" id="deliver_date_frm" value="#dateformat(now(),'dd/mm/yyyy')#">
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="#session.pda.userid#">
                    <input type="hidden" name="deliver_get" id="deliver_get" value="#session.pda.name# #session.pda.surname#">
                    <input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.recordcount#">
                    <cfloop query="get_money_bskt">
                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                        <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
                        <input type="hidden" name="#money_type#" id="#money_type#" value="#rate2#">
                        <cfif money_type is 'TL'>
                            <input type="hidden" name="basket_money" id="basket_money" value="TL">
                            <input type="hidden" name="basket_rate1" id="basket_rate1" value="#rate1#">
                            <input type="hidden" name="basket_rate2" id="basket_rate2" value="#rate2#">
                        </cfif>
                    </cfloop>
                    <tr>
                        <td class="infotag">Tarih *</td>
                        <td>
                            <cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" class="date_field">
                            <cf_wrk_date_image date_field="ship_date">
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">İrsaliye No *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='118.İrsaliye No Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="ship_number" id="ship_number" value="" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP','false',0,'',add_sale.company_id.value,add_sale.consumer_id.value);" class="wide_input">
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">İşlem Tipi *</td>
                        <td><cf_workcube_process_cat slct_width="127"></td>
                    </tr>
                    <tr>
                        <td class="infotag">Depo*</td>
                        <td><cfinclude template="../query/get_department_location.cfm">
                            <input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
                            <input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
                            <input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
                            <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                            <cfinput type="text" name="department_location" id="department_location" value="#attributes.department_location#" required="yes" message="#message#" class="wide_input">
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_sale.department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_location_all_div('open_all_div','add_sale','branch_id','department_id','location_id','department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Cari Hesap *</td>
                        <td><input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                            <input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
                            <input type="hidden" name="partner_name" id="partner_name" value="#attributes.partner_name#">
                            <input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                            <input type="text" name="member_name" id="member_name" value="#attributes.comp_name#" class="wide_input">
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_sale.comp_name','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_company_all_div('open_all_div');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>						
                        </td>
                    </tr>
                    <tr style="height:25px;">
                        <td colspan="2"><div id="open_all_div"></div></td>
                    </tr>
                    <tr>
                        <td class="infotag">Sipariş</td>
                        <td><input type="hidden" name="order_id_listesi" id="order_id_listesi" value="">
                            <input type="text" name="order_id" id="order_id" value="" class="wide_input" readonly>
                            <a href="javascript://" onclick="get_order_div('order_div','order_row_div',1,1);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>	
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Barkod</td>
                        <td><div id="show_prod_dsp">
                                <input type="hidden" name="row_count" id="row_count" value="0">
                                <input type="text" name="search_product" id="search_product" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0);}" class="wide_input">
                                <a href="javascript://" onclick="add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Lot - Miktar</td>
                        <td><div id="show_lot_info">
                                <input type="hidden" name="ship_row_count" id="ship_row_count" value="0">
                                <input type="text" name="search_lot_no" id="search_lot_no" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {return add_order_amount(document.getElementById('search_product').value);}" class="middle_input">
								<cfif browserdetect() contains 'Android'><a href="javascript://" onClick="add_order_amount(document.getElementById('search_product').value);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a></cfif>
                                <input type="text" name="search_amount" id="search_amount" value="#TLFormat(1,4)#" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> {return add_barcode3(document.getElementById('ship_row_count').value,document.getElementById('search_product').value,1);}" class="small_input">
								<cfif browserdetect() contains 'Android'><a href="javascript://" onClick="add_barcode3(document.getElementById('ship_row_count').value,document.getElementById('search_product').value,1);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a></cfif>
                            </div>
                        </td>
                    </tr>
                    <tr id="order_div"><!--- style="display:none;" --->
                        <td class="infotag" colspan="2">
                            <div id="order_row_div"></div>
                            <div id="order_row_div_action"></div>
                        </td>
                    </tr>
                    <div id="mydiv">
                        <tr id="order_info" style="display:none;">
                            <td colspan="2">
                                <table>
                                    <tr>
                                        <td colspan="3" class="txtboldblue">Sipariş Bilgileri</td>
                                    </tr>
                                    <tr>
                                        <td style="width:27px;">Miktar</td>
                                        <td style="width:27px;">İşlenen</td>
                                        <td>Barkod</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" id="order_rows">
                                <!---<cfloop from="1" to="50" index="no">
                                    <div id="n_my_div#no#" style="display:none">
                                        <table cellpadding="1" cellspacing="0">
                                            <tr>
                                                <td><input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
                                                    <input type="hidden" name="sid#no#" id="sid#no#" value="">
                                                    <input type="hidden" name="row_ship_id#no#" id="row_ship_id#no#" value="">
                                                    <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="">
                                                    <input type="text" name="amount#no#" id="amount#no#" style="width:25.5px;" readonly value="1" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();">
                                                    <input type="text" name="amount_diff#no#" id="amount_diff#no#" style="width:25.5px;" readonly value="0" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();">
                                                    <input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:75px;">
                                                    <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                    <a href="javascript://" onclick="gizle_goster('tr_product_name#no#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                </td>
                                            </tr>
                                            <tr id="tr_product_name#no#" style="display:'';">
                                                <td><input type="text" name="product_name#no#" id="product_name#no#" value="" style="width:180px;" readonly></td>
                                            </tr>
                                        </table>
                                    </div>
                                </cfloop>--->
                            </td>
                        </tr>
                    </div>
                    <div id="div_lot_control">
                        <tr id="ship_info" style="display:none;">
                            <td colspan="2">
                                <table>
                                    <tr>
                                        <td colspan="2" class="txtboldblue">İrsaliye Bilgileri</td>
                                    </tr>
                                    <tr>
                                        <td style="width:45px;">Lot No</td>
                                        <td style="width:75px;">Barkod</td>
                                        <td>Miktar</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" id="ship_rows">
                            <!---<cfloop from="1" to="50" index="lotno">
                                <div id="n_div_lot_control#lotno#" style="display:none">
                                <table cellpadding="1" cellspacing="0">
                                    <tr>
                                        <td>
                                            <input type="hidden" name="ship_row_kontrol#lotno#" id="ship_row_kontrol#lotno#" value="0">
                                            <input type="hidden" name="ship_sid#lotno#" id="ship_sid#lotno#" value="">
                                            <input type="hidden" name="ship_row_ship_id#lotno#" id="ship_row_ship_id#lotno#" value="">
                                            <input type="hidden" name="ship_wrk_row_relation_id#lotno#" id="ship_wrk_row_relation_id#lotno#" value="">
                                            <input type="text" name="ship_lot_no#lotno#" id="ship_lot_no#lotno#"  value="" style="width:45px;" readonly>
                                            <input type="text" name="ship_barcode#lotno#" id="ship_barcode#lotno#"  value="" style="width:75px;" readonly>
                                            <input type="text" name="ship_amount#lotno#" id="ship_amount#lotno#" value="#TLFormat(1,4)#" class="moneybox" onkeyup="FormatCurrency(this,4);" style="width:25.5px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();" readonly>
                                            <a href="javascript://" onclick="sil_lot(#lotno#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                            <a href="javascript://" onclick="gizle_goster('tr_ship_product_name#lotno#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                        </td>
                                    </tr>
                                    <tr id="tr_ship_product_name#lotno#" style="display:'';">
                                        <td><input type="text" name="ship_product_name#lotno#" id="ship_product_name#lotno#" value="" style="width:180px;" readonly></td>
                                    </tr>
                                </table>
                                </div>
                            </cfloop>--->
                            </td>
                        </tr>
                    </div>
                    <tr>
                        <td colspan="2" align="center"><input type="button" value="Kaydet" onclick="control_inputs();"></td>
                    </tr>
                </table>
			</cfform>
        </td>
	</tr>
</table>
</cfoutput>
<br/>
<cfinclude template="basket_js_functions.cfm">
