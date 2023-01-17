<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.width" default="">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.depth" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.spect_code" default="">
<cfparam name="attributes.department_name" default="">
<cfinclude template="../query/get_moneys.cfm">
<cfset url_str = ''>
<cfif isdefined("is_sale_product")>
	<cfset url_str = "#url_str#&is_sale_product=#is_sale_product#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif><!--- is_cost net maliyet hesaplamasını kontrol ediyor ozden09112005 --->
<cfif isdefined("attributes.department_out")>
	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined("attributes.location_out")>
	<cfset url_str = "#url_str#&location_out=#attributes.location_out#">
</cfif>
<cfif isdefined("attributes.department_in")>
	<cfset url_str = "#url_str#&department_in=#attributes.department_in#">
</cfif>
<cfif isdefined("attributes.location_in")>
	<cfset url_str = "#url_str#&location_in=#attributes.location_in#">
</cfif>
<cfif isdefined("attributes.update_product_row_id") and len(attributes.update_product_row_id)>
	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cfset url_str = "#url_str#&deliver_date=#attributes.deliver_date#">
</cfif>
<cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>
	<cfset url_str = "#url_str#&lot_no=#attributes.lot_no#">
</cfif>
<cfif isdefined("sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfif isdefined("int_basket_id")>
	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isDefined('attributes.rowcount') and len(attributes.rowcount)>
	<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
</cfif>
<cfif isDefined('attributes.is_price') and len(attributes.is_price)>
	<cfset url_str = "#url_str#&is_price=#attributes.is_price#">
</cfif>
<cfif isDefined('attributes.projects_id') and len(attributes.projects_id) and isDefined("attributes.project_head") and Len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.projects_id#&project_head=#replace(attributes.project_head,'#chr(39)#','')#">
</cfif>
<cfif isDefined('attributes.is_condition_sale_or_purchase') and len(attributes.is_condition_sale_or_purchase)>
	<cfset url_str = "#url_str#&is_condition_sale_or_purchase=#attributes.is_condition_sale_or_purchase#">
</cfif>
<cfset flag_prc_other=0>
<cfif isDefined('attributes.is_price_other') and len(attributes.is_price_other)>
	<cfset flag_prc_other=attributes.is_price_other>
	<cfset url_str = "#url_str#&is_price_other=#attributes.is_price_other#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_str = "#url_str#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isdefined("attributes.paymethod_id")>
	<cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
</cfif>
<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
	<cfset url_str = "#url_str#&card_paymethod_id=#attributes.card_paymethod_id#">
</cfif>
<cfif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
	<cfset url_str = "#url_str#&paymethod_vehicle=#attributes.paymethod_vehicle#">
</cfif>
<cfif isdefined('attributes.demand_type') and len(attributes.demand_type)>
 	<cfset url_str = "#url_str#&demand_type=#attributes.demand_type#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#")>
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("prod_order_result_") and prod_order_result_ eq 1>
	<cfif isdefined("open_stock_popup_type")>
		<cfset url_str = "#url_str#&open_stock_popup_type=#open_stock_popup_type#&prod_order_result_=#prod_order_result_#">
    </cfif>
    <cfif isdefined("is_lot_no_based")>
		<cfset url_str = "#url_str#&is_lot_no_based=#is_lot_no_based#">
    </cfif> 
	<cfif isdefined("round_number")>
		<cfset url_str = "#url_str#&round_number=#round_number#">
    </cfif>
</cfif>
<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
	<cfset url_str = "#url_str#&departmen_location_info=#attributes.departmen_location_info#">
</cfif>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfset url_str_form = url_str>
<cfset url_str = '#url_str#&is_submit_form=1'>
<cfquery name="GET_ROWS" datasource="#DSN3#">
    SELECT 
        S.STOCK_ID,SPECT_MAIN_ID,STOCK_CODE,(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS MIKTAR
        ,HEIGHT_VALUE
        ,WIDTH_VALUE
        ,DEPTH_VALUE
        ,S.PRODUCT_NAME
        ,PU.MAIN_UNIT
        ,PU.ADD_UNIT
        ,SR.AMOUNT2
        ,PC.PRODUCT_CAT
        ,PC.FORM_FACTOR
        ,PS.PRICE
        ,PS.MONEY
    FROM 
        #dsn2_alias#.STOCKS_ROW SR,
        STOCKS S,
        SPECT_MAIN SM,
        PRODUCT_UNIT PU,
        PRODUCT P,
        PRODUCT_CAT PC,
        PRICE_STANDART PS
    WHERE 
        S.STOCK_ID=SR.STOCK_ID AND 
        SM.STOCK_ID=S.STOCK_ID AND
        P.PRODUCT_ID=PU.PRODUCT_ID AND
        P.PRODUCT_CATID=PC.PRODUCT_CATID AND
        PS.PRODUCT_ID=P.PRODUCT_ID AND
        PS.PURCHASESALES =  <cfqueryparam cfsqltype="cf_sql_integer" value="#is_sale_product#">  AND
        PRICESTANDART_STATUS=1 AND
        <cfif len(attributes.product_cat) and len(attributes.product_catid)>
            PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
        </cfif>
        <cfif isNumeric(attributes.width)>
            WIDTH_VALUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.width#"> AND
        </cfif>
        <cfif isNumeric(attributes.height)>
            HEIGHT_VALUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.height#"> AND
        </cfif>
        <cfif isNumeric(attributes.depth)>
            DEPTH_VALUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.depth#"> AND
        </cfif>
        <cfif len(attributes.stock_code)>
            S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code#%"> AND
        </cfif>
        <cfif len(attributes.location_id)>
            SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.location_id#"> AND
        </cfif>
        <cfif len(attributes.department_id)>
            SR.STORE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.department_id#"> AND
        </cfif>
        P.PRODUCT_ID=S.PRODUCT_ID AND MAIN_UNIT='KG' AND HEIGHT_VALUE IS NOT NULL AND WIDTH_VALUE IS NOT NULL AND DEPTH_VALUE IS NOT NULL AND ADD_UNIT IS NOT NULL
    GROUP BY HEIGHT_VALUE,WIDTH_VALUE,DEPTH_VALUE,S.STOCK_ID,S.STOCK_CODE,SPECT_MAIN_ID,S.PRODUCT_NAME,PU.MAIN_UNIT,PU.ADD_UNIT,SR.AMOUNT2,PC.PRODUCT_CAT,PC.FORM_FACTOR,PS.PRICE,PS.MONEY
    HAVING (SUM(STOCK_IN)-SUM(STOCK_OUT)) > 0
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_ROWS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang(2305,'Ebat-Özgül Ağırlık',65437)#">
    <cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_products#url_str_form#" method="post">
		<cf_box_search>
			<input type="hidden" name="is_submit_form" id="is_submit_form" value="">
			<input type="hidden" name="satir" id="satir" value="<cfoutput>#attributes.satir#</cfoutput>">
			<input type="hidden" name="is_submit_form" id="is_submit_form1" value="">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
			<cfif isDefined("attributes.from_product_config")><input type="hidden" name ="from_product_config" id="from_product_config" value=""></cfif>
			<div class="form-group" id="product_cat">
				<div class="input-group">   
					<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
					<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','150');">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
				</div>
			</div> 
            <div class="form-group small">
				<cfinput type="text" placeholder="#getlang('','En','48152')#-A" name="width" value="#attributes.width#">
			</div>
            <div class="form-group small">
				<cfinput type="text" placeholder="#getlang('','Boy','55735')#-B" name="height" value="#attributes.height#">
			</div>
            <div class="form-group small">
				<cfinput type="text" placeholder="#getlang('','Kalınlık','75')#-H" name="depth" value="#attributes.depth#">
			</div>
            <div class="form-group medium">
                    <select name="product_select_type" id="product_select_type" style="width:300px;">
                        <option value="1" <cfif basket_prod_list.product_select_type eq 1>selected</cfif>>1 - <cf_get_lang dictionary_id='43449.Fiyatsız Standart Stok Listesi'></option><!--- Perakende Sektörü --->
                        <option value="2" <cfif basket_prod_list.product_select_type eq 2>selected</cfif>>2 - <cf_get_lang dictionary_id='43450.Stoklu Özel Fiyatlı Satış Listesi'></option><!--- IT Sektörü - Satış --->
                        <option value="3" <cfif basket_prod_list.product_select_type eq 3>selected</cfif>>3 - <cf_get_lang dictionary_id='43451.Stoklu Alış Listesi'></option><!--- 3 - IT Sektörü - Alış --->
                        <option value="4" <cfif basket_prod_list.product_select_type eq 4>selected</cfif>>4 - <cf_get_lang dictionary_id='43452.Stoklu Liste - Depo Fişleri'></option><!--- 4 - IT Sektörü - Depo Fişi --->
                        <option value="6" <cfif basket_prod_list.product_select_type eq 6>selected</cfif>>5 - <cf_get_lang dictionary_id='43454.Specli Stoklu Özel Fiyatlı Satış Listesi'></option><!--- 6 - IT Sektörü - Satış Specli --->
                        <option value="7" <cfif basket_prod_list.product_select_type eq 7>selected</cfif>>6 - <cf_get_lang dictionary_id='43455.Specli Stoklu Alış Listesi'></option> <!--- 7 - IT Sektörü - Alış Specli --->
                        <option value="8" <cfif basket_prod_list.product_select_type eq 8>selected</cfif>>7 - <cf_get_lang dictionary_id='43459.İşçilikli Stoklu Özel Fiyatlı Satış Listesi'></option> <!--- 8 - IT Sektörü - Satış İşçilikli --->
                        <option value="9" <cfif basket_prod_list.product_select_type eq 9>selected</cfif>>8 - <cf_get_lang dictionary_id ='43901.İşçilikli Specli Özel Fiyatlı Satış Listesi'></option><!--- 9 - IT Sektörü - Satış işçilikli specli ---> 
                        <option value="10" <cfif basket_prod_list.product_select_type eq 10>selected</cfif>>9 - <cf_get_lang dictionary_id ='65081.Tedarikçi Bazında Stok Stratejili Ürün Listesi'></option><!--- 10 - IT Sektörü - Satınalma siparişi icin ---> 
                        <option value="11" <cfif basket_prod_list.product_select_type eq 11>selected</cfif>>10 - <cf_get_lang dictionary_id ='43903.Raf ve Son Kullanma Tarihli Stok Listesi'></option>
                        <option value="12" <cfif basket_prod_list.product_select_type eq 12>selected</cfif>>11 - <cf_get_lang dictionary_id ='43904.Taksit Hesaplamalı Fiyat Listesi'></option> 
                        <option value="13" <cfif basket_prod_list.product_select_type eq 13>selected</cfif>>12 - <cf_get_lang dictionary_id ='43905.Fiyat Listeli Stok Listesi'></option> 
                        <option value="14" <cfif basket_prod_list.product_select_type eq 14>selected</cfif>>13 - <cf_get_lang dictionary_id ='65437.Ebat-Özgül Ağırlık'></option> 
                    </select>
            </div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
		<cf_box_search_detail>
            <div class="col col-2 col-md-2 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-stock_code">
                    <label class="col col-12"><cfoutput>#getLang(352,'Stok Kodu',57518)#</cfoutput></label>
                    <cfinput type="text" name="stock_code" value="#attributes.stock_code#">
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-3 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-spect_code">
                    <label class="col col-12"><cfoutput>#getLang(352,'Spekt Kodu',65439)#</cfoutput></label>
                    <cfinput type="text" name="spect_code" value="#attributes.spect_code#">
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-3 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-department_location">
                    <label class="col col-12"><cfoutput>#getLang(352,'Departman',57572)#</cfoutput></label>
                        <cf_wrkdepartmentlocation
                        returninputvalue="location_id,department_name,department_id,branch_id"
                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldname="department_name"
                        fieldid="location_id"
                        department_fldid="department_id"
                        branch_fldid="branch_id"
                        department_id="#attributes.department_id#"
                        location_id="#attributes.location_id#"
                        location_name="#attributes.department_name#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        >
                    </div>
            </div>
        </cf_box_search_detail>
	</cfform>
    <cf_grid_list sort="#iif((isdefined("attributes.status") and attributes.status eq 2),0,1)#">
        <thead>
            <tr>
                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th><cf_get_lang dictionary_id ='65046.Form Faktörü'></th>
                <th><cf_get_lang dictionary_id='65439.Spekt Kodu'></th>
                <th><cf_get_lang dictionary_id='48152.En'></th>
                <th><cf_get_lang dictionary_id='55735.Boy'></th>
                <th><cf_get_lang dictionary_id='65440.Kal-H'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'>-1</th>
                <th>1.<cf_get_lang dictionary_id='57636.Birim'></th>                
                <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'>-2</th>
                <th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                <th><cf_get_lang dictionary_id='57636.Birim'></th>
            </tr>
        </thead>
        <tbody>
            <cfif GET_ROWS.recordcount>
                    <input type="hidden" name="cheque_id_list" id="cheque_id_list" value="">
                    <input type="hidden" name="cheque_act_date_list" id="cheque_id_list" value="">
                    <input type="hidden" name="type" id="type" value="">
                    <cfoutput query="GET_ROWS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#STOCK_CODE#</td>
                            <td>#PRODUCT_NAME#</td>
                            <td>#PRODUCT_CAT#</td>
                            <td>  
                                <cfif FORM_FACTOR eq 1><cf_get_lang dictionary_id="65045.Boru"></cfif>
                                <cfif FORM_FACTOR eq 2><cf_get_lang dictionary_id="39097.Profil"></cfif>
                                <cfif FORM_FACTOR eq 3>H</cfif>
                                <cfif FORM_FACTOR eq 4>I</cfif>
                                <cfif FORM_FACTOR eq 5>T</cfif>
                                <cfif FORM_FACTOR eq 6>U</cfif>
                                <cfif FORM_FACTOR eq 7>L</cfif>
                                <cfif FORM_FACTOR eq 8><cf_get_lang dictionary_id="65047.Köşebent"></cfif>
                                <cfif FORM_FACTOR eq 9><cf_get_lang dictionary_id="57666.Silindir"></cfif>
                                <cfif FORM_FACTOR eq 10><cf_get_lang dictionary_id="65048.Altıgen"></cfif>
                                <cfif FORM_FACTOR eq 11><cf_get_lang dictionary_id="65049.Beşgen"></cfif>
                                <cfif FORM_FACTOR eq 12><cf_get_lang dictionary_id="65050.Kare"></cfif>
                                <cfif FORM_FACTOR eq 13><cf_get_lang dictionary_id="65051.Dikdörtgen"></cfif>
                                <cfif FORM_FACTOR eq 14><cf_get_lang dictionary_id="65052.Üçgen"></cfif>
                                <cfif FORM_FACTOR eq 15><cf_get_lang dictionary_id="65053.Küre"></cfif>
                                <cfif FORM_FACTOR eq 16><cf_get_lang dictionary_id="63870.Rulo"></cfif>
                                <cfif FORM_FACTOR eq 17><cf_get_lang dictionary_id="65055.Sıvı"></cfif>
                                <cfif FORM_FACTOR eq 18><cf_get_lang dictionary_id="65054.Dökme"></cfif>
                            </td>
                            <td></td>
                            <td>#WIDTH_VALUE#</td>
                            <td>#HEIGHT_VALUE#</td>
                            <td>#DEPTH_VALUE#</td>
                            <td style="text-align:right;">#MIKTAR#</td>
                            <td>#MAIN_UNIT#</td>
                            <td style="text-align:right;">#AMOUNT2#</td>
                            <td>#ADD_UNIT#</td>
                            <td style="text-align:right;">#PRICE#</td>
                            <td>#MONEY#</td>
                        </tr>
                    </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.popup_products&#url_str#">
    <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
        <cfset adres = '#adres#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif isDefined('attributes.list_bank_name') and len(attributes.list_bank_name)>
        <cfset adres = '#adres#&list_bank_name=#attributes.list_bank_name#'>
    </cfif>
    <cfif isDefined('attributes.list_bank_branch_name') and len(attributes.list_bank_branch_name)>
        <cfset adres = '#adres#&list_bank_branch_name=#attributes.list_bank_branch_name#'>
    </cfif>
    <cfif isDefined('attributes.start_date') and len(attributes.start_date)>
        <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
    </cfif>
    <cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
        <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
    </cfif>
    <cfif isDefined('attributes.oby') and len(attributes.oby)>
        <cfset adres = '#adres#&oby=#attributes.oby#'>
    </cfif>	
    <cfif isDefined('attributes.status') and len(attributes.status)>
        <cfset adres = '#adres#&status=#attributes.status#'>
    </cfif>
    <cfif isdefined('attributes.money_type') and len(attributes.money_type)>
        <cfset adres = '#adres#&money_type=#attributes.money_type#'>
    </cfif>
    <cfif isdefined('attributes.account_id') and len(attributes.account_id)>
        <cfset adres = '#adres#&account_id=#attributes.account_id#'>
    </cfif>
    <cfif isdefined('attributes.cash') and len(attributes.cash)>
        <cfset adres = '#adres#&cash=#attributes.cash#'>
    </cfif>
    <cfif isDefined('attributes.record_date1') and len(attributes.record_date1)>
        <cfset adres = '#adres#&record_date1=#dateformat(attributes.record_date1,dateformat_style)#'>
    </cfif>
    <cfif isDefined('attributes.record_date2') and len(attributes.record_date2)>
        <cfset adres = '#adres#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#'>
    </cfif>
    <cfif isDefined('attributes.payroll_date1') and len(attributes.payroll_date1)>
        <cfset adres = '#adres#&payroll_date1=#dateformat(attributes.payroll_date1,dateformat_style)#'>
    </cfif>
    <cfif isDefined('attributes.payroll_date2') and len(attributes.payroll_date2)>
        <cfset adres = '#adres#&payroll_date2=#dateformat(attributes.payroll_date2,dateformat_style)#'>
    </cfif>
    <cfif isdefined('attributes.debt_company') and len(attributes.debt_company)>
        <cfset adres = '#adres#&debt_company=#attributes.debt_company#'>
    </cfif>
    <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#&is_form_submitted=1">
</cf_box>