<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfif not (isDefined("xml_process_cat") and len(xml_process_cat))>
	<!--- Xmlde Tanimli Olmayan Islem Tipleri Icin Default Sistemden Bir Tip Ataniyor --->
	<cfset default_process_type = 76>
	<cfinclude template="../query/get_process_cat.cfm">
	<cfset xml_process_cat = get_process_cat.process_cat_id>
</cfif>
<cfif fusebox.fuseaction contains 'purchase_control'>
	<cfset Head_ = "Kontrollü Alım İrsaliyesi">
<cfelse>
	<cfset Head_ = "Mal Alım İrsaliyesi">
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

<cfif isDefined("attributes.ship_id") and len(attributes.ship_id)>
	<cfquery name="GET_SHIP" datasource="#DSN2#">
		SELECT 
        	SHIP_ID, 
            PURCHASE_SALES, 
            SHIP_NUMBER, 
            SHIP_METHOD, 
            SHIP_DATE, 
            COMPANY_ID, 
            PARTNER_ID, 
            CONSUMER_ID, 
            EMPLOYEE_ID, 
            DELIVER_DATE, 
            LOCATION, 
            DELIVER_STORE_ID, 
            DEPARTMENT_IN, 
            LOCATION_IN, 
            OTHER_MONEY, 
            OTHER_MONEY_VALUE, 
            NETTOTAL, 
            TAXTOTAL, 
            OTV_TOTAL, 
            ADDRESS, 
            PAYMETHOD_ID, 
            ORDER_ID, 
            PROJECT_ID, 
            PROCESS_CAT, 
            CITY_ID, 
            COUNTY_ID, 
            DUE_DATE, 
            SA_DISCOUNT, 
            REF_NO, 
            GENERAL_PROM_LIMIT, 
            GENERAL_PROM_AMOUNT, 
            GENERAL_PROM_DISCOUNT, 
            FREE_PROM_LIMIT, 
            CARD_PAYMETHOD_ID, 
            CARD_PAYMETHOD_RATE, 
            COMMETHOD_ID, 
            SUBSCRIPTION_ID
        FROM 
       		SHIP 
        WHERE 
        	SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
	</cfquery>
	<cfquery name="GET_SHIP_ROW" datasource="#DSN2#">
		SELECT
			SB.BARCODE,
			SR.STOCK_ID,
			CASE WHEN SR.UNIT2 IS NULL THEN SR.AMOUNT ELSE SR.AMOUNT2 END AMOUNT,
			SR.WRK_ROW_RELATION_ID,
			SR.LOT_NO
		FROM
			SHIP_ROW SR,
			#dsn3_alias#.PRODUCT_UNIT PU,
			#dsn3_alias#.STOCKS_BARCODES SB
		WHERE
			SR.STOCK_ID = SB.STOCK_ID AND
			PU.PRODUCT_UNIT_STATUS = 1 AND
			PU.PRODUCT_ID = SR.PRODUCT_ID AND
			ISNULL(SR.UNIT2,SR.UNIT) = PU.ADD_UNIT AND
			SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
		GROUP BY
			SB.BARCODE,
			SR.STOCK_ID,
			SR.UNIT2,
			SR.AMOUNT2,
			SR.AMOUNT,
			SR.WRK_ROW_RELATION_ID,
			SR.LOT_NO,
			SR.SHIP_ROW_ID
		ORDER BY
			SR.SHIP_ROW_ID
	</cfquery>
	<cfset attributes.ship_row_count = get_ship_row.recordcount>
	
	<cfset attributes.ship_date = get_ship.ship_date>
	<cfset attributes.ship_number = get_ship.ship_number>
	<cfset attributes.process_cat = get_ship.process_cat>
	<cfif get_ship.purchase_sales eq 1>
		<cfset attributes.department_id = get_ship.deliver_store_id>
		<cfset attributes.location_id = get_ship.location>
	<cfelse>
		<cfset attributes.department_id = get_ship.department_in>
		<cfset attributes.location_id = get_ship.location_in>
	</cfif>
	<cfif len(get_ship.consumer_id)><cfset attributes.member_type = "Consumer"><cfelse><cfset attributes.member_type = "Partner"></cfif>
	<cfset attributes.consumer_id = get_ship.consumer_id>
	<cfset attributes.company_id = get_ship.company_id>
	<cfset attributes.comp_name = get_par_info(get_ship.company_id,1,0,0)>
	<cfset attributes.partner_id = get_ship.partner_id>
	<cfset attributes.partner_name = get_par_info(get_ship.company_id,0,-1,0)>
	<cfquery name="GET_ORDERS_SHIP" datasource="#DSN3#">
		SELECT OS.ORDER_ID,O.ORDER_NUMBER FROM ORDERS O, ORDERS_SHIP OS WHERE O.ORDER_ID = OS.ORDER_ID AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND OS.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> ORDER BY O.ORDER_NUMBER
	</cfquery>
	<cfif get_orders_ship.recordcount>
		<cfset attributes.order_id_listesi = ListDeleteDuplicates(ValueList(get_orders_ship.order_id,','))>
		<cfset attributes.order_id = ListDeleteDuplicates(ValueList(get_orders_ship.order_number,','))>
		<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
			SELECT
				SB.BARCODE,
				OW.STOCK_ID,
				CASE WHEN OW.UNIT2 IS NULL THEN OW.QUANTITY ELSE OW.AMOUNT2 END QUANTITY,
				OW.WRK_ROW_RELATION_ID
			FROM
				ORDER_ROW OW,
				PRODUCT_UNIT PU,
				STOCKS_BARCODES SB
			WHERE
				OW.STOCK_ID = SB.STOCK_ID AND
				PU.PRODUCT_UNIT_STATUS = 1 AND
				PU.PRODUCT_ID = OW.PRODUCT_ID AND
				ISNULL(OW.UNIT2,OW.UNIT) = PU.ADD_UNIT AND
				SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
				OW.ORDER_ROW_CURRENCY IN (-6,-7) AND
				OW.ORDER_ID IN (#attributes.order_id_listesi#)
			GROUP BY
				SB.BARCODE,
				OW.STOCK_ID,
				OW.UNIT2,
				OW.AMOUNT2,
				OW.QUANTITY,
				OW.WRK_ROW_RELATION_ID,
				OW.ORDER_ROW_ID
			ORDER BY
				OW.ORDER_ROW_ID
		</cfquery>
		<cfset attributes.order_row_count = Get_Order_Row.RecordCount>
	</cfif>
</cfif>
<cfif isDefined("xml_show_member_info") and xml_show_member_info eq 1 and isDefined("attributes.company_id") and len(attributes.company_id)>
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
<!--- //Default Sayfa Parametreleri - Ekleme ve Guncelleme Buradan Calisacagi Icin Duzenlendi --->

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">#head_#</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
            <cfform name="add_purchase" id="add_purchase" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_purchase" enctype="multipart/form-data">
                <table style="width:100%;">
                    <input type="hidden" name="service_id" id="service_id" value="">
                    <input type="hidden" name="service_serial_no" id="service_serial_no" value="">
                    <input type="hidden" name="service_stock_id" id="service_stock_id" value="">
                    <input type="hidden" name="basket_due_value" id="basket_due_value" value="">
                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                    <input type="hidden" name="ship_method" id="ship_method" value="">
                    <input type="hidden" name="ship_method_name" id="ship_method_name" value="">
                    <input type="hidden" name="deliver_member_type" id="deliver_member_type" value="employee">
                    <input type="hidden" name="project_id" id="project_id" value="">
                    <input type="hidden" name="project_head" id="project_head" value="">
                    <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="">
                    <input type="hidden" name="irsaliye" id="irsaliye" value="">	
                    <input type="hidden" name="detail" id="detail" value="">
                    <input type="hidden" name="ref_no" id="ref_no" value="">
                    <input type="hidden" name="active_period" id="active_period" value="#session.pda.period_id#">
                    <input type="hidden" name="deliver_date_frm"  id="deliver_date_frm" value="#dateformat(now(),'dd/mm/yyyy')#">
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
                            <cfinput type="text" name="ship_date" id="ship_date" value="#dateformat(now(),'dd/mm/yyyy')#" class="date_field" validate="eurodate" maxlength="10">
                            <cf_wrk_date_image date_field="ship_date">
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">İrsaliye No *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='118.İrsaliye No Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="ship_number" id="ship_number" value="#attributes.ship_number#" class="wide_input" required="yes" maxlength="50" message="#message#" onBlur="paper_control(this,'SHIP','false',0,'',add_purchase.company_id.value,add_purchase.consumer_id.value);">
                            <a href="javascript://" onclick="data_transfer(2);"><img  src="images/copy_list.gif" align="absmiddle" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">İşlem Tipi *</td>
                        <td><cfif isDefined('attributes.process_cat') and len(attributes.process_cat)>
                                <cf_workcube_process_cat process_cat="#attributes.process_cat#" is_upd='1'>
                            <cfelse>
                                <cf_workcube_process_cat> <!---  slct_width="120px;" --->
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Depo*</td>
                        <td><cfinclude template="../query/get_department_location.cfm">
                            <input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
                            <input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
                            <input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
                            <cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
                            <cfinput type="text" name="department_location" id="department_location" value="#attributes.department_location#" class="wide_input" required="yes" message="#message#">
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_purchase.department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_location_all_div('open_all_div','add_purchase','branch_id','department_id','location_id','department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
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
                            <a href="javascript://" onclick="get_turkish_letters_div('document.add_purchase.member_name','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle" class="form_icon"></a>
                            <a href="javascript://" onclick="get_company_all_div('open_all_div');"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr style="height:25px;">
                        <td colspan="2"><div id="open_all_div"></div></td>
                    </tr>
                    <tr>
                        <td class="infotag">Sipariş</td>
                        <td><input type="hidden" name="order_id_listesi" id="order_id_listesi" value="#attributes.order_id_listesi#">
                            <input type="text" name="order_id" id="order_id" value="#attributes.order_id#" class="wide_input" readonly>
                            <a href="javascript://" onclick="get_order_div('order_div','order_row_div',0,1);"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>	
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Barkod</td>
                        <td><div id="show_prod_dsp">
                                <input type="hidden" name="row_count" id="row_count" value="0">
                                <input type="text" name="search_product" id="search_product" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> {add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0)};" class="wide_input">
                                <a href="javascript://" onclick="add_barcode2(document.getElementById('row_count').value,document.getElementById('search_product').value,0);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="infotag">Lot - Miktar</td>
                        <td><div id="show_lot_info">
                                <input type="hidden" name="ship_row_count" id="ship_row_count" value="0">
                                <input type="text" name="search_lot_no" id="search_lot_no" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> {add_order_amount(document.getElementById('search_product').value)};" class="middle_input">
								<cfif browserdetect() contains 'Android'><a href="javascript://" onclick="add_order_amount(document.getElementById('search_product').value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a></cfif>
                                <input type="text" name="search_amount" id="search_amount" value="#TLFormat(1,4)#" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif>{return add_barcode3(document.getElementById('ship_row_count').value,document.getElementById('search_product').value,1);}" class="small_input">
								<cfif browserdetect() contains 'Android'><a href="javascript://" onclick="add_barcode3(document.getElementById('ship_row_count').value,document.getElementById('search_product').value,1);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a></cfif>
                            </div>
                        </td>
                    </tr>
                    <tr id="order_div"><!---  style="display:none;" --->
                        <td colspan="2">
                            <div id="order_row_div"></div>
                            <div id="order_row_div_action"></div>
                        </td>
                    </tr>
                    
                    <div id="mydiv">
                    <tr id="order_info" style="display:<cfif attributes.order_row_count gt 0>''<cfelse>none</cfif>;">
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
                                <div id="n_my_div#no#" style="display:<cfif attributes.order_row_count gte no>''<cfelse>none</cfif>;">
                                <table cellpadding="1" cellspacing="0">
                                    <tr>
                                        <td>
                                            <input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="<cfif attributes.order_row_count lte no>1<cfelse>0</cfif>">
                                            <input type="hidden" name="sid#no#" id="sid#no#" value="<cfif attributes.order_row_count gte no>#get_order_row.stock_id[no]#</cfif>">
                                            <input type="hidden" name="row_ship_id#no#" id="row_ship_id#no#" value="<cfif attributes.order_row_count gte no>#get_order_row.stock_id[no]#</cfif>">
                                            <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="<cfif attributes.order_row_count gte no>#get_order_row.wrk_row_relation_id[no]#</cfif>">
                                            <input type="text" name="amount#no#" id="amount#no#" style="width:25.5px;" readonly value="<cfif attributes.order_row_count gte no>#get_order_row.quantity[no]#<cfelse>1</cfif>" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <input type="text" name="amount_diff#no#" id="amount_diff#no#" style="width:25.5px;" readonly value="<cfif attributes.order_row_count gte no>#get_order_row.quantity[no]#<cfelse>#TLFormat(0,4)#</cfif>" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <input type="text" name="barcode#no#" id="barcode#no#" style="width:75px;" value="<cfif attributes.order_row_count gte no>#get_order_row.barcode[no]#</cfif>">
                                            <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                            <a href="javascript://" onclick="gizle_goster('tr_product_name#no#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                            <a href="javascript://" onclick="data_transfer(1,#no#);"><img  src="images/copy_list.gif" align="absmiddle" border="0"></a>
                                        </td>
                                    </tr>
                                    <tr id="tr_product_name#no#" style="display:'';">
                                        <td><input type="text" name="product_name#no#" id="product_name#no#" style="width:180px;" value="" readonly></td>
                                    </tr>
                                </table>
                                </div>
                            </cfloop>--->
                        </td>
                    </tr>
                    </div>
                    <div id="div_lot_control">
                        <tr id="ship_info" style="display:<cfif attributes.ship_row_count gt 0>''<cfelse>none</cfif>;">
                            <td colspan="2">
                            <table>
                                <tr>
                                    <td colspan="2" class="txtboldblue">İrsaliye Bilgileri</td>
                                </tr>
                                <tr>
                                    <td style="width:51px;">Lot No</td>
                                    <td style="width:70px;">Barkod</td>
                                    <td>Miktar</td>
                                </tr>
                            </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" id="ship_rows">
                                <!---<cfloop from="1" to="50" index="lotno">
                                    <div id="n_div_lot_control#lotno#" style="display:<cfif attributes.ship_row_count gte lotno>''<cfelse>none</cfif>;">
                                    <table cellpadding="1" cellspacing="0">
                                        <tr>
                                            <td><input type="hidden" name="ship_row_kontrol#lotno#" id="ship_row_kontrol#lotno#" value="<cfif attributes.ship_row_count gte lotno>1<cfelse>0</cfif>">
                                                <input type="hidden" name="ship_sid#lotno#" id="ship_sid#lotno#" value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.stock_id[lotno]#</cfif>">
                                                <input type="hidden" name="ship_row_ship_id#lotno#" id="ship_row_ship_id#lotno#" value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.stock_id[lotno]#</cfif>">
                                                <input type="hidden" name="ship_wrk_row_relation_id#lotno#" id="ship_wrk_row_relation_id#lotno#" value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.wrk_row_relation_id[lotno]#</cfif>">
                                                <input type="text" style="width:50px;" name="ship_lot_no#lotno#" id="ship_lot_no#lotno#" readonly value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.lot_no[lotno]#</cfif>">
                                                <input type="text" style="width:70px;" name="ship_barcode#lotno#" id="ship_barcode#lotno#" readonly value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.barcode[lotno]#</cfif>">
                                                <input style="width:25.5px;" type="text" name="ship_amount#lotno#" id="ship_amount#lotno#" readonly value="<cfif attributes.ship_row_count gte lotno>#get_ship_row.amount[lotno]#</cfif>" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                                <a href="javascript://" onclick="sil_lot(#lotno#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a>
                                                <a href="javascript://" onclick="gizle_goster('tr_ship_product_name#lotno#');"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                            </td>
                                        </tr>
                                        <tr id="tr_ship_product_name#lotno#" style="display:'';">
                                            <td><input type="text" style="width:180px;" name="ship_product_name#lotno#" id="ship_product_name#lotno#" value="" readonly></td>
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
