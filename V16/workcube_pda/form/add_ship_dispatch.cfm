<cf_papers paper_type="ship">
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfif not (isDefined("xml_process_cat") and Len(xml_process_cat))>
	<!--- Xmlde Tanimli Olmayan Islem Tipleri Icin Default Sistemden Bir Tip Ataniyor --->
	<cfset default_process_type = 81>
	<cfinclude template="../query/get_process_cat.cfm">
	<cfset xml_process_cat = get_process_cat.process_cat_id>
</cfif>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">Depo Sevk İrsaliyesi</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">
	<tr>
		<td class="color-row">
			<cfform name="add_ship_dispatch" id="add_ship_dispatch" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_ship_dispatch" enctype="multipart/form-data">  
                <table style="width:100%;">
					<cfoutput>
                    <input type="hidden" name="active_period" id="active_period" value="#session.pda.period_id#">
                    <input type="hidden" name="deliver_date_frm"  id="deliver_date_frm" value="#dateformat(now(),'dd/mm/yyyy')#">
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="#session.pda.userid#">
                    <input type="hidden" name="deliver_get" id="deliver_get" value="#session.pda.name# #session.pda.surname#">
                    <input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.recordcount#">
                    <input type="hidden" name="order_date" id="order_date" value="#dateformat(now(),'dd/mm/yyyy')#" maxlength="10">
                    <input type="hidden" name="is_delivered" id="is_delivered" value="1"><!--- Teslim Al Secenegi Xml ile Secili Gelecek --->
                    </cfoutput>
                    <cfoutput query="get_money_bskt">
                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                        <input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
                        <input type="hidden" name="#money_type#" id="#money_type#" value="#rate2#">
                        <cfif money_type is 'TL'>
                            <input type="hidden" name="basket_money" id="basket_money" value="TL">
                            <input type="hidden" name="basket_rate1" id="basket_rate1" value="#rate1#">
                            <input type="hidden" name="basket_rate2" id="basket_rate2" value="#rate2#">
                        </cfif>
                    </cfoutput>
                    <tr>
                        <td class="infotag">Tarih *</td>
                        <td>
                            <cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:60px;">
                            <cf_wrk_date_image date_field="ship_date">
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">İrsaliye No *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='118.İrsaliye No Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="ship_number" id="ship_number" value="" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP','false',0,'',0,0);" class="wide_input">
                        </td>
                    </tr>
                    <tr>
                   	 	<td class="infotag">İşlem Tipi *</td>
                        <td><cf_workcube_process_cat></td>
                    </tr> 
                    <tr>
                        <td class="infotag">Çıkış Depo *</td>
                        <td><cfinclude template="../query/get_department_location.cfm">
                            <cfoutput>
                            <input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
                            <input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
                            <input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
                            <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                            <cfinput type="text" name="department_location" id="department_location" value="#attributes.department_location#" required="yes" message="#message#" class="wide_input">
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_ship_dispatch.department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_location_all_div('open_all_div','add_ship_dispatch','branch_id','department_id','location_id','department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Giriş Depo *</td>
                        <td><cfoutput>
                            <input type="hidden" name="location_id_in" id="location_id_in" value="">
                            <input type="hidden" name="department_id_in" id="department_id_in" value="">
                            <input type="hidden" name="branch_id_in" id="branch_id_in" value="">
                            <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                            <cfinput type="text" name="department_location_in" id="department_location_in" value="" required="yes" message="#message#" class="wide_input">
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_ship_dispatch.department_location_in','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_location_all_div('open_all_div','add_ship_dispatch','branch_id_in','department_id_in','location_id_in','department_location_in');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr style="height:25px;">
                        <td colspan="2"><div id="open_all_div"></div></td>
                    </tr>
                    <tr>
                        <td class="infotag">Barkod</td>
                        <td><div id="show_prod_dsp">
                                <input type="hidden" name="row_count" id="row_count" value="0">
                                <input type="text" name="search_product" id="search_product" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.Use_onKeyDown_Enter')>if(event.keyCode == 13)</cfif> {add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0);}" class="wide_input">
                                <a href="javascript://" onclick="add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Lot - Miktar</td>
                        <td><div id="show_lot_info">
                                <input type="text" name="search_lot_no" id="search_lot_no" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.Use_onKeyDown_Enter')>if(event.keyCode == 13)</cfif> { document.getElementById('search_amount').value = commaSplit(1,4); document.getElementById('search_amount').select(); }" class="middle_input">
                                <input type="text" name="search_amount" id="search_amount" value="<cfoutput>#TLFormat(1,4)#</cfoutput>" style="width:25px;" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.Use_onKeyDown_Enter')>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,1);}" class="small_input">
                            </div>
                        </td>
                    </tr>
                    <tr id="ship_info" style="display:none;">
                        <td colspan="2">
                        <table>
                            <tr>
                                <td colspan="2" class="txtboldblue">İrsaliye Bilgileri</td>
                            </tr>
                            <tr>
                                <td class="infotag" style="width:51px;">Lot No</td>
                                <td class="infotag" style="width:70px;">Barkod</td>
                                <td class="infotag">Miktar</td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" id="order_rows">
                            <!---<cfloop from="1" to="50" index="no">
                            <cfoutput>
                                <div id="n_my_div#no#" style="display:none">
                                <table cellpadding="1" cellspacing="0">
                                    <tr>
                                        <td><input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
                                            <input type="hidden" name="sid#no#" id="sid#no#" value="">
                                            <input type="hidden" name="row_ship_id#no#" id="row_ship_id#no#">
                                            <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="">
                                            <input type="text" name="lot_no#no#" id="lot_no#no#" style="width:50px;" value="">
                                            <input type="text" name="barcode#no#" id="barcode#no#" style="width:70px;" value="">
                                            <input type="text" name="amount#no#" id="amount#no#" style="width:25.5px;" value="1" class="moneybox" onkeyup="FormatCurrency(this,4);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.Use_onKeyDown_Enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                            <a href="javascript://" onclick="gizle_goster('tr_product_name#no#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                        </td>
                                    </tr>
                                    <tr id="tr_product_name#no#" style="display:'';">
                                        <td><input type="text" style="width:180px;" name="product_name#no#" id="product_name#no#" value="" readonly></td>
                                    </tr>
                                </table>
                                </div>
                            </cfoutput>
                            </cfloop>--->
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="button" value="Kaydet" onclick="control_inputs();">
                        </td>
                    </tr> 		
                </table>
			</cfform>
		</td>
	</tr>
</table>
<br/>
<cfinclude template="basket_js_functions.cfm"> <!--- <cfinclude template="__basket_js_functions_ship_dispatch.cfm"> kaldirilarak ortak hale getirildi FBS 20111001 --->
