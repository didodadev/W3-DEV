<cfprocessingdirective pageEncoding="utf8">
<link rel="stylesheet" href="/AddOns/AFM/assets/css/bootstrap.min.css">
<link href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.min.css" rel="stylesheet">
<link rel="stylesheet" href="/AddOns/AFM/assets/css/Catalog.css">
<script src="/AddOns/AFM/assets/JS/bootstrap.min.js"></script>
<script src="/AddOns/AFM/assets/JS/jquery.validate.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>
<script src="/AddOns/AFM/assets/JS//catalog/Catalog.js"></script>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.order_id_listesi" default="">
<cfparam name="attributes.order_id_form" default="">
<cfparam name="attributes.add_amount_" default="1">
<cfparam name="attributes.amount_round_number" default="2">

<div class="bootstrap">
    <div class="row" type="row">
        <div type="column" index="1" sort="true" class="col col-9 col-sm-12 catalogBox">
            <div class="col col-12 catalogNavBoxBody">
                <cf_box title="Katalog Tipi" body_style="height:10%" >
                    <div class="col col-3 col-xl-3">
                        <a class="ui-btn ui-btn-green" href="javascript://" id="aosdocBtn" name="aosdocBtn" onclick="changeCatalog('Aosdoc')">AosDoc</a>
                    </div>
                    <div class="col col-3 col-xl-3">
                        <a class="ui-btn ui-btn-green" href="javascript://" id="etkaBtn" name="etkaBtn" onclick="changeCatalog('Etka')">Etka</a>
                    </div>
                    <div class="col col-3 col-xl-3">
                        <a class="ui-btn ui-btn-green" href="javascript://" id="gtMotiveBtn" name="gtMotiveBtn" onclick="changeCatalog('GTMotive')">GT Motive</a>
                    </div>
                    <div class="col col-3 col-xl-3">
                        <a class="ui-btn ui-btn-green" href="javascript://" id="productBtn" name="productBtn" onclick="changeCatalog('ProductSearch')">Ürün Arama</a>
                    </div>
                </cf_box>
            </div>
            <div class="col col-12 catalogBoxBody">
                <cf_box id="catalog"  title="Ürün Kataloğu">
                    <h3>Bir katalog seçiniz.</h3>
                </cf_box>
                <cf_box id="etkaCatalog" body_style="height:100%" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);height:100%;" title="Ürün Kataloğu - Etka" box_page="#request.self#?fuseaction=objects.emptypopup_etka_1">

                </cf_box>
                <cf_box id="aosdocCatalog" body_style="height:100%" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);height:100%;" title="Ürün Kataloğu - AosDoc" box_page="#request.self#?fuseaction=objects.emptypopup_aosdoc">

                </cf_box>
                <!--- <cf_box id="productSearch" body_style="height:100%" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);height:100%;" title="Ürün Arama" box_page="#request.self#?fuseaction=objects.basket_in_basket">

                </cf_box> --->
                <!--- <cfinclude template="catalog/etka.cfm">   --->                
                <!--- <cfinclude template="catalog/aosdoc.cfm"> --->
                <cfinclude template="catalog/gtmotive.cfm">
            </div>
        </div>
        <div type="column" index="2" sort="true" class="col col-3 col-sm-12 float-right sepetBox" style="">
            <div class="col col-12 sepetBoxBody">
                <cf_box title="Sepet" body_style="height:100%" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);height:100%;" id="sepet">
                    <cfform name="form_basket_afm" action="void(0)">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="form-group" id="item-company_id">
                            <label class="col col-6"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>							
                            <div class="col col-6">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                                    <input name="member_name" type="text" id="member_name"  onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=form_basket_afm.consumer_id&field_comp_id=form_basket_afm.company_id&field_member_name=form_basket_afm.member_name&field_type=form_basket_afm.member_type">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.form_basket_afm.member_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-order_id_form">
                            <label class="col col-6"><cf_get_lang dictionary_id='57611.Sipariş'></label>							
                            <div class="col col-6">
                                <div class="input-group">
                                    <input type="hidden" name="order_date" id="order_date">
                                    <input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfoutput>#attributes.order_id_listesi#</cfoutput>">
                                    <input type="text" name="order_id_form" id="order_id_form" value="<cfoutput>#attributes.order_id_form#</cfoutput>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group small">
                            <input type="text" name="add_amount_" id="add_amount_" placeholder="<cfoutput><cf_get_lang dictionary_id='57635.Miktar'></cfoutput>" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = commaSplit(1,'2" value="<cfoutput>#AmountFormat(attributes.add_amount_,attributes.amount_round_number)#</cfoutput>"  onkeyup="return(FormatCurrency(this,event,'<cfoutput>#attributes.amount_round_number#</cfoutput>'));" onKeyDown="if(event.keyCode == 13) {add_barkod_serial();}">
                        </div>
                    </div>
                    <div class="sepetItemList">
                        <cf_grid_list id="sepetItems">
                            <thead>
                                <tr>
                                    <th>No</th>
                                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                    <th class='longSepetTd hidden'><cf_get_lang dictionary_id='38019.Ürün İsmi'></th>
                                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='57636.Birim'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='57639.KDV'></th>
                                    <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='34128.KDV li Birim Fiyat'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='57677.Döviz'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                    <th class="longSepetTd hidden"><cf_get_lang dictionary_id='33932.Toplam Fiyat'></th>
                                    <th><a href="javascript:void(0)"><i class="fa fa-minus"></i></a></th>
                                </tr>
                            </thead>
                            <tbody>
                                <input type="hidden" name="num_row" id="num_row" value="">
                            </tbody>
                        </cf_grid_list>
                    </div>
                    <div class="sepetSummary">
                        <div class="row">
                            <p style="float:left">KDV'siz Toplam Fiyat: </p><p id="totalPrice" style="text-align:right">0,00 TL</p>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <a class="ui-btn ui-btn-green" href="javascript://" id="sepetOrder" name="gtMotiveBtn" onclick="submitSepet()">Sipariş Oluştur</a>
                            </div>
                        </div>
                    </div>
                </cfform>
                </cf_box>
            </div>
        </div>
    </div>
</div>

<script>
    window.resizeTo(1366,768);
$( document ).ready(function(){
    $("#unique_etkaCatalog").hide();
    $("#unique_aosdocCatalog").hide();
    $("#unique_gtMotiveCatalog").hide();
    $("#unique_productSearch").hide();
    elem = $("#sepet")[0]; 
    let resizeObserver = new ResizeObserver(() => { 
        if($('#sepet').width() > 670){
            $('.longSepetTd').removeClass('hidden');
        }else{
            $('.longSepetTd').addClass('hidden');
        }
}); 

resizeObserver.observe(elem); 


});
    function changeCatalog(catalogId){
        switch (catalogId)
        {
            case "Aosdoc":
                $("#unique_catalog").hide();
                $("#unique_etkaCatalog").hide();
                $("#unique_productSearch").hide();
                $("#unique_gtMotiveCatalog").hide();
                $("#unique_aosdocCatalog").show();
                $("#aosdocBtn").addClass( "isDisabled");
                $("#etkaBtn").removeClass( "isDisabled" );
                $("#gtMotiveBtn").removeClass( "isDisabled" );
                $("#productBtn").removeClass( "isDisabled");
                break;
            case "Etka":
                $("#unique_catalog").hide();
                $("#unique_aosdocCatalog").hide();
                $("#unique_productSearch").hide();
                $("#unique_gtMotiveCatalog").hide();
                $("#unique_etkaCatalog").show();
                $("#aosdocBtn").removeClass( "isDisabled");
                $("#etkaBtn").addClass( "isDisabled" );
                $("#gtMotiveBtn").removeClass( "isDisabled" );
                $("#productBtn").removeClass( "isDisabled");

                refresh_box('etkaCatalog','<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_etka_1','0');
                break;
            case "GTMotive":
                $("#unique_catalog").hide();
                $("#unique_aosdocCatalog").hide();
                $("#unique_etkaCatalog").hide();
                $("#unique_gtMotiveCatalog").show();
                $("#unique_productSearch").hide();
                $("#aosdocBtn").removeClass( "isDisabled");
                $("#etkaBtn").removeClass( "isDisabled" );
                $("#gtMotiveBtn").addClass( "isDisabled" );
                $("#productBtn").removeClass( "isDisabled");
                break;
            case "ProductSearch":
                $("#unique_catalog").hide();
                $("#unique_aosdocCatalog").hide();
                $("#unique_etkaCatalog").hide();
                $("#unique_gtMotiveCatalog").hide();
                $("#unique_productSearch").show();
                $("#aosdocBtn").removeClass( "isDisabled");
                $("#etkaBtn").removeClass( "isDisabled" );
                $("#gtMotiveBtn").removeClass( "isDisabled" );
                $("#productBtn").addClass( "isDisabled");
                refresh_box('productSearch','<cfoutput>#request.self#</cfoutput>?fuseaction=objects.basket_in_basket','0');
                break;
        }
    }
    function submitSepet(){
        if( ( $("#company_id").val().length != "" && $("#company_id").val() != "" ) || ( $("#consumer_id").val().length != "" && $("#consumer_id").val() != "" ) ){
            url_ = '/v16/objects/cfc/basketInbasket.cfc?method=addRows';
            data = $("#form_basket_afm").serialize();
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
                            alert("<cfoutput>#getLang('','',61350)#</cfoutput>");
                            //show_hide('sepet_box');
                            //openmodal();
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

    var num_row = 1;
    totalprice=0;

    function add_barkod_serial(stockCode){

        //var add_stock_id_js_ = $("#add_stock_id_").val();
        //var add_stock_code_js_= ($("#add_stock_code_").val()).replace("'","");
        row_count = 1;
        for(multi_count = 1; multi_count <= row_count; multi_count++){
                if(( stockCode!= undefined && stockCode != '')){

                    var listParam = 0 + "*200.41." + stockCode + "*" + "<cfoutput>#dsn1_alias#</cfoutput>";
                    str_product_detail_= "obj_get_product_detail_10";
                    var get_product_detail_ = wrk_safe_query(str_product_detail_,'dsn3',0,listParam);
                    if(get_product_detail_.recordcount ==0)
					{
						alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>!");			
						return false;
                    }
                }
                    row_price_cat = -2 ; // Standart Satış 

                    var listParam = get_product_detail_.PRODUCT_ID + "*" + get_product_detail_.PRODUCT_UNIT_ID;
                    var get_price = wrk_safe_query("obj_get_price_3",'dsn3',0,listParam);
                    
                    if(get_price.recordcount == 0) // Bu alan ürünün fiyat listesinde fiyati yoksa sepete eklememesi icin eklendi.
					{
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
                        $("<td class='longSepetTd hidden'>").append(
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
                        $("<td class='longSepetTd hidden'>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'unit_'+num_row,
                                                    'value' : get_product_detail_.ADD_UNIT[0]
                                                })
                            )
                        ),
                        $("<td class='longSepetTd hidden'>").append(
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
                        $("<td class='longSepetTd hidden'>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'price_kdv_'+num_row,
                                                    'value' : commaSplit(get_price.PRICE[0] * (1 + (get_product_detail_.TAX[0] / 100)))
                                                }).addClass("moneybox")
                            )
                        ),
                        $("<td class='longSepetTd hidden'>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'price_money_'+num_row,
                                                    'value' : get_price.MONEY[0]
                                                })
                            )
                        ),
                        $("<td class='longSepetTd hidden'>").append(
                            $("<div>").addClass("form-group").append(
                                $("<input>").attr({
                                                    'type'  : 'text',
                                                    'name'  : 'description_'+num_row
                                                })
                            )
                        ),
                        $("<td class='longSepetTd hidden'>").append(
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
                    ).appendTo("#sepetItems tbody")
                    num_row++;
                totalprice+=get_price.PRICE[0]* parseFloat($("#add_amount_").val());
            }
        $("div#find_product input").val("");
        $("#add_amount_").val(commaSplit(1));
        $("#totalPrice").html(commaSplit(totalprice) + ' TL')
    }
    function del_row(row){
        totalprice-=parseFloat($(`[name='price_${row}']`).val())* parseFloat($(`[name='amount_${row}']`).val());
        $("tr#tr_row_"+row).remove();
        $("#totalPrice").html(commaSplit(totalprice) + ' TL')

    }
</script>