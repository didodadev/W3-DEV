<cfparam name="attributes.start_date" default="#now()#">
<cfparam name="attributes.add_amount_" default="1">
<cfparam name="attributes.amount_round_number" default="2">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.list_ord_id" default="">
<cfparam name="attributes.id_order_form" default="">


<cf_box title="#getlang('','Alışveriş Sepeti',35366)#" closable="1" draggable="1" id="sepet_box">
    <cfform name="form_basket_2" action="#request.self#?fuseaction=#url.fuseaction#">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                <div class="form-group" id="item-company_id">
                    <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>							
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                            <input name="member_name" type="text" id="member_name"  onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
                            <cfset str_linke_ait="&field_consumer=form_basket_2.consumer_id&field_comp_id=form_basket_2.company_id&field_member_name=form_basket_2.member_name&field_type=form_basket_2.member_type">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&call_function=get_pricecat_list();&keyword='+encodeURIComponent(document.form_basket_2.member_name.value),'list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-id_order_form">
                    <label class="col col-12"><cf_get_lang dictionary_id='57611.Sipariş'></label>							
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="order_date" id="order_date">
                            <input type="hidden" name="list_ord_id" id="list_ord_id" value="<cfoutput>#attributes.list_ord_id#</cfoutput>">
                            <input type="text" name="id_order_form" id="id_order_form" value="<cfoutput>#attributes.id_order_form#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-order_id_form">
                    <label class="col col-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>							
                    <div class="col col-12">
                        <div class="input-group col col-12">
                            <select name="pricecat" id="pricecat">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                <div class="form-group" id="item-record_emp_id">
                    <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>	
                    <div class="col col-12">
                        <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="record_emp_id" id="record_emp_id" value="#session.ep.userid#">
                            <input type="hidden" name="record_cons_id" id="record_cons_id" value="">
                            <input type="hidden" name="record_part_id" id="record_part_id" value="">
                            <input name="record_name" id="record_name" type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57899.Kaydeden'></cfoutput>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,PARTNER_ID,EMPLOYEE_ID,MEMBER_NAME','record_cons_id,record_part_id,record_emp_id,record_name','','3','250');" value="#session.ep.name# #session.ep.surname#" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_emp_id=form_basket_2.record_emp_id&field_name=form_basket_2.record_name&field_consumer=form_basket_2.record_cons_id&field_partner=form_basket_2.record_part_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3','list','popup_list_pars');"></span>
                        </cfoutput>
                        </div>
                    </div>
                </div> 
                <div class="form-group" id="item-date">
                    <label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div> 
            </div>
        </cf_box_elements>
        <input type="hidden" value="" name="add_stock_id_" id="add_stock_id_">
        <div class="col col-12" style="border-bottom:1px solid #eaeaea;" class="margin-top-10 margin-bottom-5"></div>
        <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
        <cf_seperator id="find_product" header="#getlang('','Ürün Bul',61346)#">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="find_product">
                    <div class="form-group" id="item-product_id">					
                        <div class="input-group">
                            <input type="hidden" name="stock_id" id="stock_id">
                            <input type="hidden" name="product_id" id="product_id">
                            <input name="product_name" type="text" id="product_name" placeholder="<cfoutput><cf_get_lang dictionary_id='57657.Ürün'></cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');"  autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket_2.stock_id&product_id=form_basket_2.product_id&field_name=form_basket_2.product_name&call_function=add_barkod_serial&call_function_paremeter=5&keyword='+encodeURIComponent(document.form_basket_2.product_name.value),'list');"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <input name="add_stock_code_" id="add_stock_code_" placeholder="<cfoutput><cf_get_lang dictionary_id='57518.Stok Kodu'></cfoutput>" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(2);}">
                    </div>
                    <div class="form-group">
                        <input name="add_barcod_" id="add_barcod_" type="text" placeholder="<cfoutput><cf_get_lang dictionary_id='57633.Barkod'></cfoutput>" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(1);}">
                    </div>
                    <div class="form-group">
                        <input name="serial_number" id="serial_number" placeholder="<cfoutput><cf_get_lang dictionary_id='57637.Seri No'></cfoutput>" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(3);}">
                    </div>
                    <div class="form-group">
                        <input name="lotNoQrCode" placeholder="<cfoutput><cf_get_lang dictionary_id='32916.Lot No'></cfoutput>" id="lotNoQrCode" type="text" value="" onKeyDown="if(event.keyCode == 13) {add_barkod_serial(4);}">
                    </div>
                    <div class="form-group small">
                        <input type="text" name="add_amount_" id="add_amount_" placeholder="<cfoutput><cf_get_lang dictionary_id='57635.Miktar'></cfoutput>" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'2" value="<cfoutput>#AmountFormat(attributes.add_amount_,attributes.amount_round_number)#</cfoutput>"  onkeyup="return(FormatCurrency(this,event,'<cfoutput>#attributes.amount_round_number#</cfoutput>'));" onKeyDown="if(event.keyCode == 13) {add_barkod_serial();}">
                    </div>
                    <div class="form-group">
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" onclick="add_barkod_serial(2);"><i class="fa fa-shopping-basket"></i><cf_get_lang dictionary_id='52116.Sepete Ekle'></a>
                    </div>
                </div>
            </cf_box_elements>
        </div>
        <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
        <cf_seperator id="basket" header="#getlang('','Basket',29807)#">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="basket">
                <cf_grid_list id="prod_table">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57496.No'></th>
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
                        <input type="hidden" name="num_row" id="num_row" value="">
                    </tbody>
                </cf_grid_list> 
                <div class="ui-form-list-btn">
                    <div>
                        <a href="javascript://" class="ui-btn ui-btn-success" onclick="submit()"><cf_get_lang dictionary_id='59031.Kaydet'></a>
                    </div>
                </div>
            </div>
        </div>
    </cfform>
</cf_box>

<script>
    var num_row = 1;
    
    function add_barkod_serial(number){

        var serial_no = ($("#serial_number").val()).replace("'","");
        var lotNoQrCode = ($("#lotNoQrCode").val()).replace("'","");
        var add_stock_id_js_ = $("#add_stock_id_").val();
        var add_stock_code_js_= ($("#add_stock_code_").val()).replace("'","");
        var barcod = ($("#add_barcod_").val()).replace("'","");
        var stock_id = $("#stock_id").val();
        row_count = 1;

        for(multi_count = 1; multi_count <= row_count; multi_count++){

            if(serial_no !='' && serial_no != 0 ){
				if($("#add_amount_").val() != 1) $("#add_amount_").val(1);  //aynı seri no ile 1 adet urun eklenebilir
				var seri_list='';
				if($("#prod_table tbody tr").length)
				{
                    for (i=0; i < $("#prod_table tbody tr").length ; i++)
                    {
                        if(!list_find(seri_list,$("#lot_no"+i+"_").val(),','))
                        {
                            if(i != 0)
                                seri_list = seri_list + ',' ;
                            seri_list = seri_list + $("#lot_no"+i+"_").val();
                        }
                    }
				}
			}

            if( (barcod != undefined && barcod !='') || (serial_no != undefined && serial_no !='') || (add_stock_code_js_!= undefined && add_stock_code_js_!='') || (lotNoQrCode!= undefined && lotNoQrCode!='') || (stock_id != undefined && stock_id != '') ){

                if(barcod != undefined && barcod !=''){
                    var listParam = barcod;
                    str_product_detail_ = "obj_get_product_detail";
                    var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
                    if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");
						return false;
					}
                }
                else if(serial_no != undefined && serial_no !=''){
                    if(list_find(seri_list,serial_no))
					{
						alert("<cf_get_lang dictionary_id='32710.Bu Seri Daha Önce Eklenmişti'> !");
						return false;
                    }
                    str_seri_sale_control_ = "obj_get_seri_sale_control";
                    var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + serial_no;
					var get_seri_sale_control_ =wrk_safe_query(str_seri_sale_control_,'dsn3',0,listParam);
					if(get_seri_sale_control_.recordcount ==0)
					{ 
						alert("<cf_get_lang dictionary_id='32722.Bu Seri Nolu Ürün Satılamaz Durumda'>!");
						return false;
					}else{
                        temp_stock_id_= get_seri_sale_control_.STOCK_ID;
						var listParam = temp_stock_id_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                        str_product_detail_ = "obj_get_product_detail_5";
                        var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
						if(get_product_detail_.recordcount ==0)
						{
							alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
							return false;
						}
                    }

                }
                else if(lotNoQrCode != undefined && lotNoQrCode != ''){
                    var listParam = lotNoQrCode + "*" + '<cfoutput>#dsn2_alias#</cfoutput>' + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                    str_product_detail_= "obj_get_product_detail_qrcodeSales";
                    var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
					if(get_product_detail_.recordcount == 0){
                        alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");	
                    }

                }
                else if((add_stock_id_js_ != undefined && add_stock_id_js_ != '') || (add_stock_code_js_!= undefined && add_stock_code_js_ != '')){

                    var listParam = 0 + "*" + add_stock_code_js_ + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                    str_product_detail_= "obj_get_product_detail_10";
                    var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
                    if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
						return false;
                    }
                } 
                else if((stock_id != undefined && stock_id != '')){
                    var listParam = stock_id + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                    str_product_detail_= "obj_get_product_detail_5";
                    var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
                    if(get_product_detail_.recordcount == 0){
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
						return false;
                    }
                }
                    row_price_cat = $("#pricecat").val(); 
                    if(row_price_cat == ""){
                        alert("<cf_get_lang dictionary_id='33165.Fiyat listesi Seçiniz'>");	
                        return false;
                    }

                    var price_date="<cfoutput>#now()#</cfoutput>";
                    if(row_price_cat > 0) {
                        var listParam = get_product_detail_.PRODUCT_ID + "*" + row_price_cat + "*" + price_date + "*" + get_product_detail_.PRODUCT_UNIT_ID;
                        var str_price_all_ = 'obj_get_price_4';
                    }else{
                        var listParam = get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_UNIT_ID;
                        var str_price_all_ = "obj_get_price_5";
                    }
                    
                    var get_price = wrk_safe_query(str_price_all_,'dsn3',0,listParam);

                    if(get_price.recordcount == 0){
						alert("<cf_get_lang dictionary_id='34251.Ürün, Seçilen Fiyat Listesinde Tanımlı Fiyatı Olmadığından Sepete Eklenmeyecektir'>!");	
						return false;
                    }
                    $("#num_row").val("");
                    $("#num_row").val(num_row);
                    $("<tr id='tr_row_"+num_row+"'>").append(
                        $("<td>").text(num_row),
                        $("<td>").append(
                             $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'manufact_code_'+num_row, 'value' : get_product_detail_.MANUFACT_CODE[0] }),
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'barcod_'+num_row, 'value' : get_product_detail_.BARCOD[0] }),
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'row_control_'+num_row, 'value' : 1 }),
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'stock_id_'+num_row, 'value' : get_product_detail_.STOCK_ID[0] }),
                                $("<input>").attr({ 
                                                    'type'  : 'text',
                                                    'name'  : 'stock_code_'+num_row,
                                                    'value' : get_product_detail_.STOCK_CODE[0]
                                                })
                             )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'product_unit_id_'+num_row, 'value' : get_product_detail_.PRODUCT_UNIT_ID[0] }),
                                $("<input>").attr({ 'type' : 'hidden', 'name' : 'product_id_'+num_row, 'value' : get_product_detail_.PRODUCT_ID[0] }),
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'product_name_'+num_row,
                                                    'value' : get_product_detail_.PRODUCT_NAME[0]
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({ 'type' : 'text', 'name' : 'amount_'+num_row, 'value' : commaSplit($("#add_amount_").val()) }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'unit_'+num_row,
                                                    'value' : get_product_detail_.ADD_UNIT[0]
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'tax_'+num_row,
                                                    'value' : get_product_detail_.TAX[0]
                                                })
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'price_'+num_row,
                                                    'value' : commaSplit(get_price.PRICE[0])
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'price_kdv_'+num_row,
                                                    'value' : commaSplit(get_price.PRICE[0] * (1 + (get_product_detail_.TAX[0] / 100)))
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'price_money_'+num_row,
                                                    'value' : get_price.MONEY[0]
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
                                                    'name'  : 'price_net_'+num_row,
                                                    'value' : commaSplit(get_price.PRICE[0] * parseFloat($("#add_amount_").val()) * (1 + (get_product_detail_.TAX[0] / 100)))
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td>").append(
                            $("<a>").attr({ 'href' : 'javascript:void(0)', 'onclick' : 'del_row('+num_row+')' }).append(
                                $("<i>").addClass("fa fa-minus")
                            )
                        )
                    ).appendTo("#prod_table tbody")
                    num_row++;
                
            }
        }
        $("div#find_product input").val("");
        $("#add_amount_").val(commaSplit(1));
    }

    function add_order(){	
        var is_purchase = 0;
        var is_return = 0;
    
        if( ( $("#company_id").val().length != "" && $("#company_id").val() != "" ) || ( $("#consumer_id").val().length != "" && $("#consumer_id").val() != "" ) )
        {	
            str_irslink = '&is_from_invoice=1&control=2&order_id_liste=' + form_basket_2.list_ord_id.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket_2.company_id.value + '&consumer_id='+form_basket_2.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
            return true;
        }
        else{
            alert("<cfoutput><cf_get_lang dictionary_id='50081.Lütfen Cari Hesap seçiniz'></cfoutput>");
        }
    }

    function del_row(row){
        $("tr#tr_row_"+row).remove();
    }

    function submit(){
        if( ( $("#company_id").val().length != "" && $("#company_id").val() != "" ) || ( $("#consumer_id").val().length != "" && $("#consumer_id").val() != "" ) ){
            url_ = '/V16/objects/cfc/basketInbasket.cfc?method=addRows';
            data = $("#form_basket_2").serialize();
            $.ajax({                                                                                             
                    url: url_,
                    dataType: "text",
                    data: data,
                    cache: false,
                    async: false,
                    success: function(response) {
                        data = $.parseJSON(response);
                        if( data.SUCCESS )
                        {
                            alert("<cf_get_lang dictionary_id='61350.Sepet Başarıyla Oluşturuldu'>");
                            show_hide('sepet_box');
                            openmodal();
                        }else{
                            alert(data.MESSAGE);
                            return false;
                        }
                       
                    }
                });
        }else{
            alert("<cfoutput><cf_get_lang dictionary_id='50081.Lütfen Cari Hesap seçiniz'></cfoutput>");
        }
    }
    $("#warning_modal").css("min-width", "80%" );
    function get_pricecat_list(){
        var temp_card_paymethod = '';
        var temp_paymethod_vehicle = '';
        var is_store_module = '';
        if($("#company_id").length != 0 && $("#company_id").val().length != 0)
        {
            var get_credit_limit = wrk_safe_query('obj_get_credit_limit',"dsn",0,$("#company_id").val());
            var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#company_id").val());
            var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";
            if($("#dsp_only_member_price_cat_sales").val() == 1) //sadece risk tanımında gecerli fiyat listesi gelsin
            {
                if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
                    str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#company_id").val() + ' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) ';
                else
                    str_price_cat_ = str_price_cat_+' 1=2 ';
                str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
            }
            else
            {
                if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
                    str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#company_id").val() + ' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) OR ';
                str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
                    str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';
                    if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
                        str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
                    else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
                        str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
                    if(is_store_module != undefined && is_store_module==1)
                        str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
                str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
            }
            var get_price_cat = wrk_query(str_price_cat_,"dsn3");
            if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
                var selected_price_catid = get_credit_limit.PRICE_CAT;
            else if(get_price_cat.recordcount != 0)
                var selected_price_catid=get_price_cat.PRICE_CATID;
                $("#pricecat").empty();
                $("#pricecat").append("<option value='-2'>Standart Fiyat Listesi</option>");
            for (let i = 0; i < get_price_cat.recordcount; i++) {
                $("#pricecat").append(`<option value='${get_price_cat.PRICE_CATID[i]}'>${get_price_cat.PRICE_CAT[i]}</option>`);
            }
        }else{
            alert('Cari seçili olmadığı için standart fiyat listesi baz alınacaktır.')
        }
    }

    function get_pricecat_list(){
        var temp_card_paymethod = '';
        var temp_paymethod_vehicle = '';
        var is_store_module = '';

    if($("#company_id").length != 0 && $("#company_id").val().length != 0){
        var get_credit_limit = wrk_safe_query('obj_get_credit_limit',"dsn",0,$("#company_id").val());
        var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#company_id").val());
        var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";

    if($("#dsp_only_member_price_cat_sales").val() == 1){ //sadece risk tanımında gecerli fiyat listesi gelsin
        if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
            str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#company_id").val() + ' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) ';
        else
            str_price_cat_ = str_price_cat_+' 1=2 ';

        str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
    }else{
        if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
            str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#company_id").val() + ' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) OR ';

            str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
            str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';

            if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
                str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';

            else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
                str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;

            if(is_store_module != undefined && is_store_module==1)
                str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		

            str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
    }

    var get_price_cat = wrk_query(str_price_cat_,"dsn3");

    if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
        var selected_price_catid = get_credit_limit.PRICE_CAT;

    else if(get_price_cat.recordcount != 0)
        var selected_price_catid=get_price_cat.PRICE_CATID;

        $("#pricecat").empty();
        $("#pricecat").append("<option value='-2'>Standart Fiyat Listesi</option>");

    for (let i = 0; i < get_price_cat.recordcount; i++) {
        $("#pricecat").append(`<option value='${get_price_cat.PRICE_CATID[i]}'>${get_price_cat.PRICE_CAT[i]}</option>`);
    }

    }else{
        alert('Cari seçili olmadığı için standart fiyat listesi baz alınacaktır.')

    }

}

</script>