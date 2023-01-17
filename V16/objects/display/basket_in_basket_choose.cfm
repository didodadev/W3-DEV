<cfparam name="attributes.start_date" default="#dateformat(dateadd('d',-10,now()),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.list_ord_id" default="">
<cfparam name="attributes.id_order_form" default="">

<cfif len( attributes.start_date ) and isDate( attributes.start_date )><cf_date tarih = "attributes.start_date"></cfif>
<cfif len( attributes.finish_date ) and isDate( attributes.finish_date )><cf_date tarih = "attributes.finish_date"></cfif>

<cfset actions = createObject("component","V16.objects.cfc.basketInbasket")>
<cfset GET_ONLINE_SALES_ALL = actions.GET_ONLINE_SALES_ALL(
                                                            start_date       : '#iif( len(attributes.start_date), 'attributes.start_date', DE("") )#',
                                                            finish_date      : '#iif( len(attributes.finish_date), 'attributes.finish_date', DE("") )#',
                                                            member_name      : '#iif( len(attributes.member_name), 'attributes.member_name', DE("") )#',
                                                            member_type      : '#iif( len(attributes.member_type), 'attributes.member_type', DE("") )#',
                                                            company_id       : '#iif( len(attributes.company_id), 'attributes.company_id', DE("") )#',
                                                            consumer_id      : '#iif( len(attributes.consumer_id), 'attributes.consumer_id', DE("") )#',
                                                            order_id_listesi : '#iif( len(attributes.list_ord_id), 'attributes.list_ord_id', DE("") )#',
                                                            order_id_form    : '#iif( len(attributes.id_order_form), 'attributes.id_order_form', DE("") )#'
                                                            )>

<cfquery name="GET_ONLINE_SALES_EMP" dbtype="query">
    SELECT 
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        RECORD_EMP,
        COUNT(*) AS COUNTER
    FROM GET_ONLINE_SALES_ALL
    GROUP BY 
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        RECORD_EMP
</cfquery>

<div id='div_rows'>
    <cf_box title="#getLang('','',35366)#" closable="1" popup_box="1" add_href="javascript:changemodal()" >
        <cfform name="form_basket_2" action="#request.self#?fuseaction=objects.basket_in_basket_choose">
            <cfinput type="hidden" name="submit" value="1">
            <cf_box_elements>
                <div class="col col-5 col-md-6 col-sm-12 col-xs-12">
                    <div class="form-group" id="item-company_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>							
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                                <input name="member_name" type="text" id="member_name"  onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
                                <cfset str_linke_ait="&field_consumer=form_basket_2.consumer_id&field_comp_id=form_basket_2.company_id&field_member_name=form_basket_2.member_name&field_type=form_basket_2.member_type">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.form_basket_2.member_name.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_id_form">
                        <label class="col col-4"><cf_get_lang dictionary_id='57611.Sipariş'></label>							
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="order_date" id="order_date">
                                <input type="hidden" name="list_ord_id" id="list_ord_id" value="<cfoutput>#attributes.list_ord_id#</cfoutput>">
                                <input type="text" name="id_order_form" id="id_order_form" value="<cfoutput>#attributes.id_order_form#</cfoutput>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="form-group" id="item-record_emp_id">
                        <label class="col col-4"><cf_get_lang dictionary_id='57899.Kaydeden'></label>	
                        <div class="col col-12">
                            <div class="input-group">
                            <cfoutput>
                                <input type="hidden" name="record_emp_id" id="record_emp_id" value="">
                                <input type="hidden" name="record_cons_id" id="record_cons_id" value="">
                                <input type="hidden" name="record_part_id" id="record_part_id" value="">
                                <input name="record_name" id="record_name" type="text" placeholder="" onfocus="AutoComplete_Create('record_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,PARTNER_ID,EMPLOYEE_ID,MEMBER_NAME','record_cons_id,record_part_id,record_emp_id,record_name','','3','250');" value="" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_emp_id=form_basket_2.record_emp_id&field_name=form_basket_2.record_name&field_consumer=form_basket_2.record_cons_id&field_partner=form_basket_2.record_part_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3','list','popup_list_pars');"></span>
                            </cfoutput>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-date">
                        <label class="col col-4"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div> 
                </div>
                <div class="col col-1" style="margin-top:36px;">
                    <cf_wrk_search_button button_type="4" search_function="loadPopupBox('form_basket_2', #attributes.modal_id#)">
                </div>
            </cf_box_elements>
            <div class="col col-12" style="border-bottom:1px solid #eaeaea;"></div>
            <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                <cf_seperator id="find_product" header="#getLang('','',61349)#">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="find_product">
                        <ul class="ui-list">
                            <cfif GET_ONLINE_SALES_EMP.recordCount>
                                <cfoutput query="GET_ONLINE_SALES_EMP">
                                    <li>
                                        <a href="javascript:void(0)">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-online-store"></span>
                                                #EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #COUNTER#
                                            </div>
                                            <div class="ui-list-right">
                                                <i class="fa fa-chevron-down"></i>
                                            </div>
                                        </a>
                                        <ul>
                                            <cfquery name="GET_SALES" dbtype="query">
                                                SELECT UNIQUE_ID
                                                FROM GET_ONLINE_SALES_ALL
                                                WHERE RECORD_EMP = #RECORD_EMP#
                                            </cfquery>
                                            <cfloop query="#GET_SALES#">
                                                <li>
                                                    <a href="javascript:void(0)" onclick="doldur('#UNIQUE_ID#')">
                                                        <div class="ui-list-left">
                                                            <span class="ui-list-icon"></span>
                                                            Sepet - #left(UNIQUE_ID,8)#
                                                        </div>
                                                        <div class="ui-list-right">
                                                            <i class="fa fa-cube"></i>
                                                        </div>
                                                    </a>
                                                </li>
                                            </cfloop>
                                        </ul>
                                    </li>
                                </cfoutput>
                            </cfif>
                        </ul>
                    </div>
                </div>
                <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
                <cf_seperator id="basket" header="#getLang('','',29807)#">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="basket">
                        <cf_grid_list id="prod_table">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                    <th><cf_get_lang dictionary_id='38019.Ürün İsmi'></th>
                                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                    <th><cf_get_lang dictionary_id='57636.Birim'></th>
                                    <th><cf_get_lang dictionary_id='57639.KDV'></th>
                                    <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                                    <th><cf_get_lang dictionary_id='34128.KDV li Birim Fiyat'></th>
                                    <th><cf_get_lang dictionary_id='57677.Döviz'></th>
                                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                    <th><cf_get_lang dictionary_id='33932.Toplam Fiyat'></th>
                                    <th><a href="javascript:void(0)"><i class="fa fa-minus"></i></a></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfinput name="num_row" id="num_row" value="" type="hidden">
                                <cfif not isdefined("attributes.submit")>
                                    <tr>
                                        <td colspan="12"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td>
                                    </tr>
                                </cfif>
                            </tbody>
                        </cf_grid_list> 
                        <div class="ui-form-list-btn">
                            <div>
                                <a href="javascript://" class="ui-btn ui-btn-success" onclick="submit()">Sepete Doldur</a>
                            </div>
                        </div>
                    </div>
                </div>
        </cfform>
    </cf_box>
</div>


<script>   

    function doldur(unique_id){
        var num_row = 1;
        $("#prod_table tbody tr").remove();
        $.ajax({                                                                                             
                url: '/V16/objects/cfc/basketInbasket.cfc?method=getRows',
                dataType: "text",
                data: { unique_id : unique_id },
                cache: false,
                async: false,
                success: function(result) {
                    data = $.parseJSON(result);
                    data.forEach((e) => {
                        $("#num_row").val("");
                        $("#num_row").val(num_row);

                        var listParam = e.STOCK_ID + "*" + 0 + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                        var get_pro_detail = wrk_safe_query('obj_get_product_detail_9','dsn3',0,listParam);
                        //console.log(get_pro_detail);

                        $("<tr id='tr_row_"+num_row+"'>").append(
                        $("<td>").text(num_row),
                        $("<td>").append(
                             $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'manufact_code_'+num_row, 'name' : 'manufact_code_'+num_row, 'value' : get_pro_detail.MANUFACT_CODE[0] }),
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'barcod_'+num_row, 'name' : 'barcod_'+num_row, 'value' : get_pro_detail.BARCOD[0] }),
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'row_control_'+num_row, 'name' : 'row_control_'+num_row, 'value' : 1 }),
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'stock_id_'+num_row, 'name' : 'stock_id_'+num_row, 'value' : e.STOCK_ID }),
                                $("<input>").attr({ 
                                                    'type'  : 'text',
                                                    'id'    : 'stock_code_'+num_row,
                                                    'name'  : 'stock_code_'+num_row,
                                                    'value' : get_pro_detail.STOCK_CODE[0]
                                                })
                             )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'product_unit_id_'+num_row, 'name' : 'product_unit_id_'+num_row, 'value' : e.PRODUCT_UNIT_ID }),
                                $("<input>").attr({ 'type' : 'hidden', 'id' : 'product_id_'+num_row, 'name' : 'product_id_'+num_row, 'value' : e.PRODUCT_ID }),
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'product_name_'+num_row,
                                                    'name'  : 'product_name_'+num_row,
                                                    'value' : e.PRODUCT_NAME
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'text', 'id' : 'amount_'+num_row, 'name' : 'amount_'+num_row, 'value' : e.QUANTITY }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'unit_'+num_row,
                                                    'name'  : 'unit_'+num_row,
                                                    'value' : get_pro_detail.ADD_UNIT[0]
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'tax_'+num_row,
                                                    'name'  : 'tax_'+num_row,
                                                    'value' : e.TAX
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'price_'+num_row,
                                                    'name'  : 'price_'+num_row,
                                                    'value' : commaSplit(e.PRICE)
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'price_kdv_'+num_row,
                                                    'name'  : 'price_kdv_'+num_row,
                                                    'value' : commaSplit(e.PRICE * (1 + (e.TAX / 100)))
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'price_money_'+num_row,
                                                    'name'  : 'price_money_'+num_row,
                                                    'value' : e.PRICE_MONEY
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'description_'+num_row
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'id'    : 'price_net_'+num_row,
                                                    'name'  : 'price_net_'+num_row,
                                                    'value' : commaSplit(e.PRICE * e.QUANTITY * (1 + (e.TAX / 100)))
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<a>").attr({ 'href' : 'javascript:void(0)', 'onclick' : 'del_row('+num_row+')' }).append(
                                $("<i>").addClass("fa fa-minus")
                            )
                        )
                    ).appendTo("#prod_table tbody");
                    num_row++;

                    });
                }
            });
    }

    function del_row(row){
        $("tr#tr_row_"+row).remove();
    }

    function add_order()
    {	
        var is_purchase = 0;
        var is_return = 0;
    
        if( ( $("#company_id").val().length != "" && $("#company_id").val() != "" ) || ( $("#consumer_id").val().length != "" && $("#consumer_id").val() != "" ) )
        {	
            str_irslink = '&is_from_invoice=1&control=1&order_id_liste=' + form_basket_2.list_ord_id.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket_2.company_id.value + '&consumer_id='+form_basket_2.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
            return true;
        }
        else{
            alert("<cfoutput><cf_get_lang dictionary_id='50081.Lütfen Cari Hesap seçiniz'></cfoutput>");
        }
    }

    function submit(){
        if( $("#num_row").val() > 0)
            for( cnt_num_row = 1; cnt_num_row <= parseInt($("#num_row").val()); cnt_num_row++ ){
                if( $("#row_control_"+cnt_num_row).val() != undefined && $("#row_control_"+cnt_num_row).val() == 1 ){
                    var product_id = $("#product_id_"+cnt_num_row).val();
                    var stock_id = $("#stock_id_"+cnt_num_row).val();
                    var stock_code = $("#stock_code_"+cnt_num_row).val();
                    var barcod = $("#barcod_"+cnt_num_row).val();
                    var manufact_code = $("#manufact_code_"+cnt_num_row).val();
                    var product_name = $("#product_name_"+cnt_num_row).val();
                    var product_unit_id = $("#product_unit_id_"+cnt_num_row).val();
                    var add_unit = $("#unit_"+cnt_num_row).val();
                    var price = filterNum($("#price_"+cnt_num_row).val());
                    var price_other = filterNum($("#price_"+cnt_num_row).val());
                    var tax = $("#tax_"+cnt_num_row).val();
                    var price_money = $("#price_money_"+cnt_num_row).val();
                    var amount = filterNum($("#amount_"+cnt_num_row).val());
                    var toplam_hesap = filterNum($("#price_net_"+cnt_num_row).val());
                    add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, product_unit_id, add_unit, '', '', price, price_other, tax, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', price_money, '', amount, '', 1, 1, 0, 0, 0, '', '', '', 0, 1, 0, '', '', add_unit, 0, 0, 0, '', 0, 0, '', '', '', price, '', -2, 0, '', 0, 0, 0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
                }
            }
        else{
            alert("<cfoutput><cf_get_lang dictionary_id='60234.Satııra Ürün Ekleyin'></cfoutput>");
        }
    }

    $('.ui-list li a i.fa-chevron-down').click(function(){
		$(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
		$(this).closest('li').find("> ul").fadeToggle();
	});

    $("#warning_modal").css("min-width", "80%" );

    
        
</script>
