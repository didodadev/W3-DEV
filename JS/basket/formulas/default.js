//eski sürümle uyuşum için insanlık namına konan kodlar
var basket = 1;
//extensions
/** Satırdan excange oranları üretir */
basketService.getRates = function( viewModel ) {
    let moneyIndex = moneyArray.indexOf(viewModel.other_money().toUpperCase());
    if (moneyIndex >= 0) {
        return { rate1: rate1Array[moneyIndex], rate2: rate2Array[moneyIndex] };
    } else {
        return { rate1: 1, rate2: 1 };
    }
};
/** Tutar yuvarlama */
basketService.priceRoundNumber = function() {
    return basketService.get("price_round_number");
};
/** Sepet altı yuvarlama */
basketService.basketTotalRoundNumber = function() {
    return basketService.get("basket_total_round_number");
};
/** otv hesaplama şekli */
basketService.otvCalcType = function() {
    return basketService.get("otv_calc_type");
};
/** miktar yuvarlama */
basketService.amountRound = function() {
    return basketService.get("amount_round");
};
/** peryod yılı */
basketService.periodYear = function() {
    return basketService.get("period_year");
};
/** kullanıcı para birimi */
basketService.epMoney = function() {
    return basketService.get("ep_money");
};
/** indirim sabit çarpanı */
basketService.indirimFixNumber = function() {
    return 100000000000000000000;
};
/** full fuseaction */
basketService.wmo_fuseaction = function() {
    return basketService.get("wmo_fuseaction");
};
/** fuseaction module */
basketService.wmo_module = function() {
    return basketService.get("wmo_module");
};
/** fuseaction action */
basketService.wmo_action = function () {
    return basketService.get("wmo_action");
}
/** fuseaction event */
basketService.wmo_event = function() {
    return basketService.get("wmo_event");
};
/** basket id */
basketService.basket_id = function() {
    return basketService.get("basket_id");
};
/** basket money types */
basketService.money_bskt_money_types = function() {
    return basketService.get("money_bskt_money_types");
};

basketService.basket_spect_type = function() {
    return basketService.get("basket_spect_type");
};
basketService.sepetTaxArray = function() {
    return basketService.get("sepetTaxArray");
};
basketService.popupDetailPromotion = function(prom_id) {
    windowopen("/index.cfm?fuseaction=objects.popup_detail_promotion_unique&prom_id=" + prom_id, 'medium');
};
basketService.sale_product = function() {
    return basketService.get("sale_product");
}
basketService.line_number = function() {
    return basketService.get("line_number");
}

if ([1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0) {
    var temp_paymethod = '';
    var temp_card_paymethod = '';
    var temp_paymethod_vehicle = '';
}

//methods

/**
 * Miktar hesaplar
 * @param {string} fieldName baz alınan alanın id si (basket header da ki id)
 * @param {object} basketRow satır objesi
 */
function amount_hesapla( fieldName, basketRow ) {
    basketRow.amount = basketRow.amount;
    basketRow.amount_other = wrk_round( basketManager.hasShownItem("amount2") ? basketRow.amount2 : basketRow.amount_other, basketService.priceRoundNumber() );
    if( basketService.get("display_list").indexOf('is_use_add_unit') >= 0 ){
        if ( basketRow.unit2 != '' ) {
            let row_multipler = wrkBrowserStorage().getItem(`multipler_${basketRow.product_id}_${basketRow.unit2}`);
            if (row_multipler == null) {
                let get_multipler = wrk_query( "SELECT ISNULL(MULTIPLIER,1) MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID =" + basketRow.product_id + " AND ADD_UNIT = '" + basketRow.unit2 + "'", "dsn3" );
                row_multipler = get_multipler.MULTIPLIER[0];
                wrkBrowserStorage().setItem(`multipler_${basketRow.product_id}_${basketRow.unit2}`, row_multipler);
            }
            if ( fieldName == "amount" && row_multipler !== undefined ) {
                basketRow.amount_other = wrk_round( basketRow.amount / row_multipler, basketService.priceRoundNumber() );
                basketRow.amount2 = basketRow.amount_other;
            } else if ( (fieldName == "amount_other" || fieldName == "amount2") && row_multipler !== undefined ) {
                basketRow.amount = basketRow.amount_other * row_multipler;
            }
        }
    }
    return basketRow;
};

/**
 * İndirim kontrollerini yaparak gerekli düzenlemleri yapar
 * @param {object} basketRow satır objesi
 */
function discount_control( basketRow ) {
    for (let key in basketRow) {
        if (basketRow.hasOwnProperty(key) && key.indexOf("disc_") >= 0) {
            let element = basketRow[key];
            if (element > 100 || element < 0) {
                basketRow[key] = 0;
                throw lng_indirim_degeri_hatali;
            }
        }
    }
    return basketRow;
};

/**
 * Promosyon kontrollerini yaparak promosyonları yönetir
 * @param {object} basketRow satır objesi
 */
function control_row_prom( basketRow ) {
    let control_prom = false;

    if ( basketRow.row_promotion_id !== undefined && basketRow.row_promotion_id.length > 0 && basketRow.is_promotion !== undefined && basketRow.is_promotion == 0 ) {
        basketRow.row_stock_amount = wrk_round( basketRow.amount, basketService.amountRound() );
        control_prom = true;
    }

    if (control_prom === false) return basketRow;

    let free_prom_row = 0;
    let prom_comp_id = $("#basket_main_div #company_id").val();
    let member_price_cat = '-2';

    if ( $("#basket_main_div #basket_member_pricecat").length > 0 && $("#basket_main_div #basket_member_pricecat").val().length > 0 ) {
        member_price_cat = $("#basket_main_div #basket_member_pricecat").val();
    }

    if ( basketManagerObject.basketItems().length > 1 ) {
        free_prom_row = basketManagerObject.basketItems().filter( m => m.is_promotion == 1 && m.row_promotion_id == row_prom_id && m.prom_relation_id == row_prom_relation_id ).length;
    }

    let prom_date = js_date( $("#basket_main_div #" + $("#basket_main_div #search_process_date").val() ).val().toString() );
    let list_param = null;

    if ( $("#basket_main_div #company_id").length > 0 && $("#basket_main_div #company_id").val().length > 0 ) {
        list_param = basketRow.row_stock_amount + "*" +  $("#basket_main_div #company_id").val() + "*" + member_price_cat + "*" + basketRow.stock_id + "*" + prom_date + "*" + basketRow.row_promotion_id;
    } else {
        list_param = basketRow.row_stock_amount + "*0*" + member_price_cat + "*" + basketRow.stock_id + "*" + prom_date + "*" + basketRow.row_promotion_id;
    }
    let get_row_proms = wrk_safe_query( "obj_get_row_proms", "dsn3", "1", list_param );

    if ( get_row_proms.recordcount ) {
        let free_stock_multipler = parseInt( basketRow.row_stock_amount / get_row_proms.LIMIT_VALUE );

        if (get_row_proms.PROM_ID != row_prom_id) {
            viewmodel.items.row_promotion_id( get_row_proms.PROM_ID );
        }
        if (free_prom_row != 0) {
            //
        } else {
            //
        }
    } else if (free_prom_row != 0) {
        //
    }
    return basketRow;
};

/**
 * Yeni satır ekler
 * @param {int} product_id Ürün id si
 * @param {int} stock_id stok id si
 * @param {string|null} stock_code stok kodu
 * @param {string|null} barcod barkod
 * @param {string|null} manufact_code üretici kodu
 * @param {string|null} product_name ürün adı
 * @param {int} unit_id_ birim id si
 * @param {int} unit_ birim adı
 * @param {int|null} spect_id spek id
 * @param {string|null} spect_name spek adı
 * @param {float} price birim fiyat
 * @param {float|null} price_other diğer türden birim fiyat
 * @param {float} tax vergi oranı
 * @param {string} duedate evrak vade tarihi
 * @param {float} d1 indirim1
 * @param {float} d2 indirim2
 * @param {float} d3 indirim3
 * @param {float} d4 indirim4
 * @param {float} d5 indirim5
 * @param {float} d6 indirim6
 * @param {float} d7 indirim7
 * @param {float} d8 indirim8
 * @param {float} d9 indirim9
 * @param {float} d10 indirim10
 * @param {string} deliver_date sevk tarihi
 * @param {int} deliver_dept sevk departmanı
 * @param {string|null} department_head departman adı
 * @param {string|null} lot_no lot numarası
 * @param {string} money para birimi
 * @param {int|null} row_ship_id satır sevk id irsaliye satırını belirtir
 * @param {float} amount_ miktar
 * @param {string|null} product_account_code ürün muhasebe kodu
 * @param {int} is_inventory 
 * @param {int} is_production üretim de kullanılacağı
 * @param {float|null} net_maliyet net maliyet tutarı
 * @param {float|null} flt_marj maliyet marjı
 * @param {float|null} extra_cost extra maliyet
 * @param {int|null} row_promotion_id promosyon id
 * @param {float|null} promosyon_yuzde promosyon uygulama yüzdesi
 * @param {float|null} promosyon_maliyet promosyonun maliyeti
 * @param {float|null} iskonto_tutar iskonto tutarı
 * @param {int} is_promotion promosyon satırı mı
 * @param {int} prom_stock_id promosyon ürünün stok id si
 * @param {float|null} otv otv tutarı
 * @param {string|null} product_name_other diğer ürün adı (takma ad)
 * @param {float} amount_other diğer birim cinsinden miktarı
 * @param {int} unit_other diğer birim
 * @param {float|null} ek_tutar ek tutar
 * @param {int} shelf_number raf no
 * @param {int} row_unique_relation_id satır ilişki no
 * @param {int|null} row_catalog_id katalog id
 * @param {int} toplam_hesap_yap toplam hesap yapılması gerekli mi
 * @param {int} is_commission komisyon satırı mı
 * @param {any} basket_extra_info 
 * @param {int|null} prom_relation_id promosyon ilişki id
 * @param {string|null} reserve_date rezerve tarihi
 * @param {float} list_price liste fiyatı
 * @param {int|null} number_of_installment taksit adedi, taksitli satışlarda kullanılır
 * @param {int} price_cat fiyat listesi
 * @param {int} karma_product_id karma ürün id si
 * @param {int|null} row_service_id ?
 * @param {any} ek_tutar_price ?
 * @param {int} wrk_row_relation_id satır ilişki id
 * @param {int} related_action_id ilişkili action id
 * @param {string} related_action_table ilişkili action tablosu
 * @param {float|null} row_width satır genişliği
 * @param {float|null} row_depth satır derinliği
 * @param {float|null} row_height satır yüksekliği
 * @param {string|null} to_shelf_number hedef raf no
 * @param {int|null} row_project_id satırın ilişkili proje id
 * @param {string|null} row_project_name satırın ilişkili proje adı
 * @param {float|null} row_otv_amount otv tutarı
 * @param {string} action_window_name ekran adı ?
 * @param {int|null} row_paymethod_id satırın ödeme yöntemi id si (çoklu ödeme yöntemi ihtimali ile)
 * @param {string|null} special_code ?
 * @param {int|null} basket_employee_id çalışan id
 * @param {string|null} basket_employee çalışan adı
 * @param {int|null} row_work_id iş id
 * @param {string|null} row_work_name iş adı
 * @param {int|null} row_exp_center_id masraf merkezi id
 * @param {string|null} row_exp_center_name masraf merkezi adı
 * @param {int|null} row_exp_item_id masraf merkezi ?
 * @param {string|null} row_exp_item_name masraf merkezi ?
 * @param {string|null} row_acc_code satır muhasebe kodu
 * @param {any} select_info_extra ?
 * @param {any} detail_info_extra ?
 * @param {string|null} gtip_number gtip numarası
 * @param {int|null} row_activity_id activity id
 * @param {int|null} row_subscription_id abonelik id
 * @param {string|null} row_subscription_name abonelik adı
 * @param {int|null} row_assetp_id dijital varlık id
 * @param {string|null} row_assetp_name dijital varlık adı
 * @param {float|null} row_bsmv_rate bsmv oranı
 * @param {float|null} row_bsmv_amount bsmv tutarı
 * @param {float|null} row_bsmv_currency bsmv para birimi
 * @param {float|null} row_oiv_rate oiv oranı
 * @param {float|null} row_oiv_amount oiv tutarı
 * @param {float|null} row_tevkifat_rate tevkifat oranı
 * @param {float|null} row_volume Hacim
 * @param {float|null} row_specific_weight Özgül Ağırlık
 * @param {float|null} row_tevkifat_amount tevkifat tutarı
 * @param {any} reason_code_info ?
 * @param {int|null} row_tevkifat_id tevkifat id
 */
function add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other,tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id,amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_name_other,amount_other,unit_other,ek_tutar,shelf_number,row_unique_relation_id,row_catalog_id,toplam_hesap_yap,is_commission,basket_extra_info,prom_relation_id,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,wrk_row_relation_id,related_action_id,related_action_table,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,row_otv_amount,action_window_name,row_paymethod_id,special_code,basket_employee_id,basket_employee,row_work_id,row_work_name, row_exp_center_id, row_exp_center_name, row_exp_item_id, row_exp_item_name, row_acc_code,select_info_extra,detail_info_extra,gtip_number,row_activity_id,row_subscription_id,row_subscription_name,row_assetp_id,row_assetp_name,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,reason_code_info,row_tevkifat_id,row_specific_weight)
{
    otv = (otv && otv != '') ? otv : 0;
    if (action_window_name != undefined && action_window_name != '' && action_window_name != basketService.get("basket_unique_code")) {
        alert('Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil!\nFiyat Listesi Ekranınızı Yenilemelisiniz!');
		return false;
    }

    if ( isNaN(ek_tutar) ) var ek_tutar = 0;
    var ek_tutar_system = 0;
    var ek_tutar_marj = 0;
    var ek_tutar_cost = 0;
    var ek_tutar_other_total = 0;
    var row_cost_total = 0;
    var indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
    var price_net = price;
    if ( isNaN(amount_) || amount_==0) var amount_ = 1;
	if ( isNaN(price_cat) ) var price_cat='';
	if ( isNaN(ek_tutar_price) || ek_tutar_price.length == 0 ) var ek_tutar_price = 0;
	if ( isNaN(list_price) || list_price =='' ) var list_price = price;
	if ( isNaN(list_price_) || list_price_ =='' ) var list_price_ = price;
	if ( isNaN(number_of_installment) || number_of_installment =='' ) var number_of_installment=0;
	if ( isNaN(row_width) ) var row_width='';
	if ( isNaN(price_other) ) var price_other=0;
	if ( isNaN(flt_marj) || flt_marj == '' ) var flt_marj=0;
	if ( isNaN(row_depth) ) var row_depth='';
	if ( isNaN(row_height) ) var row_height='';
	if ( isNaN(to_shelf_number) ) var to_shelf_number='';
	if ( isNaN(karma_product_id) ) var karma_product_id='';
	if ( isNaN(row_project_id) ) var row_project_id='';
	if ( isNaN(row_work_id) ) var row_work_id='';
	if ( isNaN(row_exp_center_id) ) var row_exp_center_id='';
	if ( isNaN(row_exp_item_id) ) var row_exp_item_id='';
	if ( !iskonto_tutar ) var iskonto_tutar = 0;
	if ( row_paymethod_id == undefined ) var row_paymethod_id='';
	if ( row_project_name == undefined ) var row_project_name='';
	if ( row_work_name == undefined ) var row_work_name='';
	if ( row_exp_center_name == undefined ) var row_exp_center_name='';
	if ( row_exp_item_name == undefined ) var row_exp_item_name='';
	if ( row_acc_code == undefined ) var row_acc_code='';
	if ( prom_relation_id == undefined ) var prom_relation_id='';
	if ( row_service_id == undefined ) var row_service_id = '';
	if ( wrk_row_relation_id == undefined ) wrk_row_relation_id='';
	if ( special_code == undefined ) special_code='';
	if ( basket_employee_id == undefined ) basket_employee_id='';
    if ( basket_employee == undefined ) basket_employee='';
    if ( row_specific_weight == undefined ) row_specific_weight='';
    
    if (basketService.periodYear() >= 2009) {
        if ( money !== undefined && money == 'YTL' ) {
            money = basketService.epMoney();
        }
    } else if (basketService.periodYear() < 2009) {
        if ( money !== undefined && money == 'TL') {
            money = basketService.epMoney();
        }
    }

    if (row_project_id != '' && row_project_name == '') {
        row_project_name = wrkBrowserStorage().getItem( "obj_get_pro_name_" + row_project_id );
        if (row_project_name == null) {
            let get_pro_name = wrk_safe_query( "obj_get_pro_name", 'dsn', 0, row_project_id );
            if (get_pro_name.recordcount > 0) {
                row_project_name = String(get_pro_name.PROJECT_HEAD);
                wrkBrowserStorage().setItem( "obj_get_pro_name_" + row_project_id, row_project_name );
            } else {
                row_project_name = '';
            }
        }
    }

    if (row_work_id != '' && row_work_name == '') {
        row_work_name = wrkBrowserStorage().getItem( "obj_get_work_name_" + row_work_id );
        if (row_work_name == null) {
            let get_work_name = wrk_safe_query('obj_get_work_name','dsn',0,row_work_id);
            if (get_work_name.recordcount > 0) {
                row_work_name = String(get_work_name.WORK_HEAD);
                wrkBrowserStorage().setItem( "obj_get_work_name_" + row_work_id, row_work_name );
            } else {
                row_work_name = '';
            }
        }
    }

    if (isNaN(amount_other) || amount_other == '') var amount_other = 1;

    if (ek_tutar_price != '' && ek_tutar_price > 0) {
        ek_tutar_cost = ek_tutar_price * amount_other;
        if (ek_tutar != '' && ek_tutar > 0) {
            ek_tutar_marj = ((ek_tutar * 100) / ek_tutar_cost) - 100;
        } else {
            ek_tutar = ek_tutar_cost;
        }
    }

    if ( (iskonto_tutar != '') || (ek_tutar != '' && ek_tutar > 0) ) {
        var moneyArrayLen = moneyArray.length;
        for (let moni = 0; moni < moneyArrayLen; moni++) {
            if (moneyArray[moni] == money) {
                price_net -= iskonto_tutar * rate2Array[moni] / rate1Array[moni];
                price_net += ek_tutar * rate2Array[moni] / rate1Array[moni];
                ek_tutar_system = ek_tutar * rate2Array[moni] / rate1Array[moni];
            }
        }
    }

    if (promosyon_yuzde != '') price_net -= price_net * promosyon_yuzde / 100;
    price_net = wrk_round( price_net * indirim_carpan / basketService.indirimFixNumber(), basketService.priceRoundNumber() );
    var net_total = wrk_round( price_net * amount_, basketService.priceRoundNumber() );
    var ek_tutar_total = wrk_round( ek_tutar_system * amount_, basketService.priceRoundNumber() );

    if (isNaN(row_otv_amount) || row_otv_amount == undefined || row_otv_amount == '' || row_otv_amount == 0) {
        var row_otv_total = net_total * otv / 100;
    } else {
        var row_otv_total = row_otv_amount;
    }
    if ( basketService.get("display_list").indexOf('otv_from_tax_price') >= 0 ) {
        var row_tax_total = (net_total + row_otv_total) * tax / 100;
    } else {
        var row_tax_total = net_total * tax / 100;
    }

    var price_net_doviz = price_other;
    if (iskonto_tutar != '') price_net_doviz -= iskonto_tutar;
    if (ek_tutar != '' && ek_tutar > 0) {
        price_net_doviz = parseFloat(price_net_doviz.toString()) + parseFloat(ek_tutar.toString());
        ek_tutar_other_total = ek_tutar * amount_;
    }

    temp_wrk_row_id = 'WRK' + js_create_unique_id();
    if (reserve_date == undefined) reserve_date = '';
    if (row_catalog_id == undefined) var row_catalog_id = '';
    if (related_action_id == undefined) var related_action_id = '';
    if (related_action_table == undefined) var related_action_table = '';
    if (promosyon_yuzde != '') price_net_doviz -= price_net_doviz * promosyon_yuzde / 100;
    price_net_doviz = wrk_round(price_net_doviz * indirim_carpan / basketService.indirimFixNumber(), basketService.priceRoundNumber());
    var other_money_value = parseFloat(price_net_doviz.toString()) * parseFloat(amount_.toString());
    var row_total = (parseFloat(price.toString()) + parseFloat(ek_tutar_system)) * amount_;
    var tax_total = (net_total + row_tax_total + row_otv_total) / amount_;
    var row_lasttotal = net_total + row_tax_total + row_otv_total;
    var other_money_gross_total = other_money_value * (100 + (parseFloat(tax.toString()) + (parseFloat(otv.toString()) * parseFloat(tax.toString()) / 100)) + parseFloat(otv.toString())) / 100;

    if (net_maliyet != '' && net_maliyet != 0 && extra_cost != '') {
        var extra_cost_rate = parseFloat( extra_cost ) / parseFloat(net_maliyet) * 100;
    }
    if (net_maliyet != '' && net_maliyet != 0) {
        row_cost_total += parseFloat( net_maliyet );
    }
    if (extra_cost != '' && extra_cost != 0) {
        row_cost_total += parseFloat( extra_cost );
    }

    if (basketManager.hasShownItem("amount")) {
        darali = amount_;
    } else {
        darali = 1;
    }

    let get_product_unit = wrkBrowserStorage().getJSON("prdp_get_unit2_all_" + product_id);
    if (get_product_unit == null) {
        get_product_unit = wrk_safe_query('prdp_get_unit2_all' ,'dsn3' ,0 ,product_id);
        wrkBrowserStorage().setJSON("prdp_get_unit2_all_" + product_id, get_product_unit);
    }
    unit2_extra = [];
    for (let kk = 0; kk < get_product_unit.recordcount; kk++) {
        /*
        let unit_line = {};
        unit_line.selected = get_product_unit.ADD_UNIT[kk] == unit_other;
        unit_line.value = get_product_unit.ADD_UNIT[kk];
        */
        if (get_product_unit.ADD_UNIT[kk] != unit_)
            unit2_extra.push(get_product_unit.ADD_UNIT[kk]);
    }

    if (shelf_number != undefined && shelf_number != '') {
        var get_shelf_name =wrk_safe_query('obj_get_shelf_name','dsn3',0,shelf_number);
        if ( get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '' ) {
            var temp_shelf_number_ = String(get_shelf_name.SHELF_CODE);
        } else {
            var temp_shelf_number_ = '';
        }
    } else {
        var temp_shelf_number_ = '';
    }

    if ( to_shelf_number != undefined && to_shelf_number != '' ) {
        var get_shelf_name = wrk_safe_query('obj_get_shelf_name','dsn3', 0, to_shelf_number);
		if( get_shelf_name.recordcount && get_shelf_name.SHELF_CODE != '' ) {
			var temp_shelf_number2_ = String( get_shelf_name.SHELF_CODE );
        } else {
			var temp_shelf_number2_ = '';
        }
    } else {
        var temp_shelf_number2_ = '';
    }

    let container_number = '';
	let container_quantity = '';
	let delivery_country = '';
	let delivery_city = '';
    let delivery_county = '';
    
    row_subscription_id = '';
    row_subscription_name = '';
    row_assetp_id = '';
    row_assetp_name = '';

	row_activity_id = (row_activity_id != '') ? row_activity_id : '';
	row_bsmv_rate = (row_bsmv_rate != '') ? row_bsmv_rate : 0;
	row_oiv_rate = (row_oiv_rate != '') ? row_oiv_rate : 0;
    row_bsmv_currency  = 0.0;
    row_oiv_amount = 0.0;
    row_tevkifat_rate = 0.0;
    row_tevkifat_amount = 0.0;
    row_specific_weight = (row_specific_weight != '') ? parseFloat(row_specific_weight) : 0.0;

    newRowNumber = basketManagerObject.basketItems().length - 1;
    let basketItem = {};
    basketItem.PRODUCT_ID = parseInt(product_id);
    basketItem.ACTION_ROW_ID = 0;
    basketItem.WRK_ROW_ID = temp_wrk_row_id;
    basketItem.WRK_ROW_RELATION_ID = wrk_row_relation_id;
    basketItem.RELATED_ACTION_ID = related_action_id;
    basketItem.RELATED_ACTION_TABLE = related_action_table;
    basketItem.KARMA_PRODUCT_ID = karma_product_id;
    basketItem.IS_INVENTORY = parseInt(is_inventory);
    basketItem.ROW_PAYMETHOD_ID = row_paymethod_id;
    basketItem.IS_PRODUCTION = parseInt(is_production);
    basketItem.PRICE_CAT = price_cat;
    basketItem.STOCK_ID = parseInt(stock_id);
    basketItem.UNIT_ID = parseInt(unit_id_);
    basketItem.ROW_SHIP_ID = row_ship_id;
    basketItem.IS_PROMOTION = parseInt(is_promotion);
    basketItem.PROM_STOCK_ID = prom_stock_id;
    basketItem.ROW_PROMOTION_ID = row_promotion_id;
    basketItem.ROW_SERVICE_ID = row_service_id;
    basketItem.ROW_UNIQUE_RELATION_ID = row_unique_relation_id;
    basketItem.ROW_CATALOG_ID = row_catalog_id;
    basketItem.PROM_RELATION_ID = prom_relation_id;
    basketItem.INDIRIM_TOTAL = indirim_carpan;
    basketItem.INDIRIM_CARPAN = indirim_carpan;
    basketItem.EK_TUTAR_TOTAL = ek_tutar_total;
    basketItem.IS_COMMISSION = is_commission;
    basketItem.STOCK_CODE = stock_code;
    basketItem.BARCOD = barcod;
    basketItem.ROW_VOLUME = 0;
    basketItem.ROW_SPECIFIC_WEIGHT = row_specific_weight;
    basketItem.SPECIAL_CODE = special_code;
    basketItem.MANUFACT_CODE = manufact_code;
    basketItem.PRODUCT_NAME = product_name;
    basketItem.UNIT = unit_;
    basketItem.PRODUCT_NAME_OTHER = product_name_other;
    basketItem.CONTAINER_NUMBER = container_number;
    basketItem.CONTAINER_QUANTITY = container_quantity;
    basketItem.DELIVERY_COUNTRY = delivery_country;
    basketItem.DELIVERY_CITY = delivery_city;
    basketItem.DELIVERY_COUNTY = delivery_county;
    basketItem.GTIP_NUMBER = gtip_number;
    basketItem.AMOUNT = parseFloat(amount_);
    basketItem.AMOUNT_OTHER = parseFloat(amount_other);
    basketItem.AMOUNT2 = parseFloat(amount_other);
    basketItem.UNIT2_EXTRA = unit2_extra;
    basketItem.UNIT_OTHER = unit_other;
    basketItem.UNIT2 = unit_other;
    basketItem.EK_TUTAR = parseFloat(ek_tutar);
    basketItem.EK_TUTAR_PRICE = parseFloat(ek_tutar_price);
    basketItem.EK_TUTAR_COST = parseFloat(ek_tutar_cost);
    basketItem.EK_TUTAR_MARJ = parseFloat(ek_tutar_marj);
    basketItem.EK_TUTAR_OTHER_TOTAL = parseFloat(ek_tutar_other_total);
    basketItem.SPECT_ID = spect_id;
    basketItem.SPECT_NAME = spect_name;
    basketItem.LIST_PRICE = parseFloat(list_price);
    basketItem.LIST_PRICE_DISCOUNT = '';
    basketItem.TAX_PRICE = parseFloat(tax_total);
    basketItem.PRICE = parseFloat(price);
    basketItem.PRICE_OTHER = parseFloat(price_other);
    basketItem.PRICE_NET = parseFloat(price_net);
    basketItem.PRICE_NET_DOVIZ = parseFloat(price_net_doviz);
    basketItem.TAX = parseFloat(tax);
    basketItem.TAX_PERCENT = parseFloat(tax);
    basketItem.OTV = parseFloat(otv);
    basketItem.OTV_ORAN = parseFloat(otv);
    basketItem.DUEDATE = duedate;
    basketItem.NUMBER_OF_INSTALLMENT = number_of_installment;
    basketItem.ISKONTO_TUTAR = parseFloat(iskonto_tutar);
    basketItem.DISC_OUNT = parseFloat(d1);
    basketItem.DISC_OUNT2_ = parseFloat(d2);
    basketItem.DISC_OUNT3_ = parseFloat(d3);
    basketItem.DISC_OUNT4_ = parseFloat(d4);
    basketItem.DISC_OUNT5_ = parseFloat(d5);
    basketItem.DISC_OUNT6_ = parseFloat(d6);
    basketItem.DISC_OUNT7_ = parseFloat(d7);
    basketItem.DISC_OUNT8_ = parseFloat(d8);
    basketItem.DISC_OUNT9_ = parseFloat(d9);
    basketItem.DISC_OUNT10_ = parseFloat(d10);
    basketItem.ROW_TOTAL = row_total;
    basketItem.ROW_NETTOTAL = net_total;
    basketItem.ROW_TAXTOTAL = row_tax_total;
    basketItem.ROW_OTVTOTAL = row_otv_total;
    basketItem.ROW_LASTTOTAL = row_lasttotal;
    basketItem.OTHER_MONEY = money;
    basketItem.OTHER_MONEY_VALUE = other_money_value;
    basketItem.OTHER_MONEY_GROSSTOTAL = other_money_gross_total;
    basketItem.DELIVER_DATE = deliver_date;
    basketItem.RESERVE_DATE = reserve_date;
    basketItem.DELIVER_DEPT = deliver_dept;
    basketItem.BASKET_ROW_DEPARTMENT = department_head;
    basketItem.SHELF_NUMBER = shelf_number;
    basketItem.SHELF_NUMBER_TXT = temp_shelf_number_;
    basketItem.PBS_ID = '';
    basketItem.PBS_CODE = '';
    basketItem.TO_SHELF_NUMBER = to_shelf_number;
    basketItem.TO_SHELF_NUMBER_TXT = temp_shelf_number2_;
    basketItem.IS_PARSE = '';
    basketItem.LOT_NO = lot_no;
    basketItem.NET_MALIYET = net_maliyet;
    basketItem.MARJ = parseFloat(flt_marj);
    basketItem.EXTRA_COST = parseFloat(extra_cost);
    basketItem.EXTRA_COST_RATE = parseFloat(extra_cost_rate);
    basketItem.ROW_COST_TOTAL = parseFloat(row_cost_total);
    basketItem.DARA = 0;
    basketItem.DARALI = darali;
    basketItem.PROMOSYON_YUZDE = promosyon_yuzde;
    basketItem.PROMOSYON_MALIYET = promosyon_maliyet;
    basketItem.ROW_WIDTH = row_width;
    basketItem.ROW_DEPTH = row_depth;
    basketItem.ROW_HEIGHT = row_height;
    basketItem.BASKET_EXTRA_INFO = basket_extra_info;
    basketItem.SELECT_INFO_EXTRA = select_info_extra;
    basketItem.BASKET_EMPLOYEE = basket_employee;
    basketItem.BASKET_EMPLOYEE_ID = basket_employee_id;
    basketItem.ROW_PROJECT_ID = row_project_id;
    basketItem.ROW_PROJECT_NAME = row_project_name;
    basketItem.ROW_WORK_ID = row_work_id;
    basketItem.ROW_WORK_NAME = row_work_name;
    basketItem.ROW_EXP_CENTER_ID = row_exp_center_id;
    basketItem.ROW_EXP_CENTER_NAME = row_exp_center_name;
    basketItem.ROW_ACTIVITY_ID = row_activity_id;
    basketItem.ROW_ACC_CODE = row_acc_code;
    basketItem.ROW_SUBSCRIPTION_ID = row_subscription_id;
    basketItem.ROW_SUBSCRIPTION_NAME = row_subscription_name;
    basketItem.ROW_ASSETP_ID = row_assetp_id;
    basketItem.ROW_ASSETP_NAME = row_assetp_name;
    basketItem.ROW_BSMV_RATE = row_bsmv_rate;
    basketItem.ROW_BSMV_AMOUNT = row_bsmv_amount;
    basketItem.ROW_BSMV_CURRENCY = row_bsmv_currency;
    basketItem.ROW_OIV_RATE = row_oiv_rate;
    basketItem.ROW_OIV_AMOUNT = row_oiv_amount;
    basketItem.ROW_TEVKIFAT_RATE = row_tevkifat_rate;
    basketItem.ROW_TEVKIFAT_AMOUNT = row_tevkifat_amount;
    basketItem.RESERVE_TYPE = -1;
    basketItem.ORDER_CURRENCY = -1;
    basketItem.REASON_CODE = reason_code_info;
    basketItem.DELIVERY_CONDITION = '';
    basketItem.CONTAINER_TYPE = '';
    basketItem.DELIVERY_TYPE = '';
    basketItem.ROW_EXP_ITEM_ID = row_exp_item_id;
    basketItem.ROW_TEVKIFAT_ID = row_tevkifat_id;
    basketItem.IS_SERIAL_NO = '';
    if ( ( basketService.wmo_fuseaction().indexOf('add') >= 0 || basketService.wmo_event() == 'add' ) && [11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10].indexOf( basketService.basket_id() ) ) {
        my_serial_ctrl = wrk_safe_query('chk_product_serial1','dsn3',0,product_id);
		basketItem.IS_SERIAL_NO = my_serial_ctrl.IS_SERIAL_NO[0];
    }
    basketManager.setBasketItems([basketItem]);
    basketService.basketRowCalculate()('other_money', basketManagerObject.basketItems().length - 1)
    if (toplam_hesap_yap != 0) {
        basketService.basketSummaryCalculate()(0);
    }
    basketManager.setPaging();
    return true;

};

/**
 * Satır bilgileri tek bir obje üzerinden gelir
 * @param {object} rowObj
 */
function row_object(rowObj){
    data = rowObj.data;
    add_basket_row(data.PRODUCT_ID, data.STOCK_ID, data.STOCK_CODE, data.BARCOD, data.MANUFACT_CODE, data.PRODUCT_NAME, data.UNIT_ID, data.UNIT, data.SPECT_ID, data.SPECT_NAME, data.PRICE, data.PRICE_OTHER, data.TAX, data.DUEDATE, data.D1, data.D2, data.D3, data.D4, data.D5, data.D6, data.D7, data.D8, data.D9, data.D10, data.DELIVER_DATE, data.DELIVER_DEPT, data.DEPARTMENT_HEAD, data.LOT_NO, data.MONEY, data.ROW_SHIP_ID, data.AMOUNT_, data.PRODUCT_ACCOUNT_CODE, data.IS_INVENTORY, data.IS_PRODUCTION, data.NET_MALIYET, data.MARJ, data.EXTRA_COST, data.ROW_PROMOTION_ID, data.PROMOSYON_YUZDE, data.PROMOSYON_MALIYET, data.ISKONTO_TUTAR, data.IS_PROMOTION, data.PROM_STOCK_ID, data.OTV, data.PRODUCT_NAME_OTHER, data.AMOUNT_OHTER, data.UNIT_OTHER, data.EK_TUTAR, data.SHELF_NUMBER, data.ROW_UNIQUE_RELATION_ID, data.ROW_CATALOG_ID, data.TOPLAM_HESAP_YAP, data.IS_COMMISSION, data.BASKET_EXTRA_INFO, data.PROM_RELATION_ID, data.RESERVE_DATE, data.LIST_PRICE, data.NUMBER_OF_INSTALLMENT, data.PRICE_CAT, data.KARMA_PRODUCT_ID, data.ROW_SERVICE_ID, data.EK_TUTAR_PRICE, data.WRK_ROW_RELATION_ID, data.RELATED_ACTION_ID, data.RELATED_ACTION_TABLE, data.ROW_WIDTH, data.ROW_DEPTH, data.ROW_HEIGHT, data.TO_SHELF_NUMBER, data.ROW_PROJECT_ID, data.ROW_PROJECT_NAME, data.ROW_OTV_AMOUNT, data.ACTION_WINDOW_NAME, data.ROW_PAYMETHOD_ID, data.SPECIAL_CODE, data.BASKET_EMPLOYEE_ID, data.BASKET_EMPLOYEE, data.ROW_WORK_ID, data.ROW_WORK_NAME, data.ROW_EXP_CENTER_ID, data.ROW_EXP_CENTER_NAME, data.ROW_EXP_ITEM_ID, data.ROW_EXP_ITEM_NAME, data.ROW_ACC_CODE, data.SELECT_INFO_EXTRA, data.DETAIL_INFO_EXTRA, data.GTIP_NUMBER, data.ROW_ACTIVITY_ID, data.ROW_SUBSCRIPTION_ID, data.ROW_SUBSCRIPTION_NAME, data.ROW_ASSETP_ID, data.ROW_ASSETP_NAME, data.ROW_BSMV_RATE, data.ROW_BSMV_AMOUNT, data.ROW_BSMV_CURRENCY, data.ROW_OIV_RATE, data.ROW_OIV_AMOUNT, data.ROW_TEVKIFAT_RATE, data.ROW_TEVKIFAT_AMOUNT, data.REASON_CODE_INFO, data.ROW_TEVKIFAT_ID );
}
/**
 * Satır kopyalar
 * @param {object} viewModel satır
 */
function copy_row(viewModel) {
    basketManager.setBasketItems([ko.toJS(viewModel)]);
    basketService.basketRowCalculate()('other_money', basketManagerObject.basketItems().length - 1)
    basketService.basketSummaryCalculate()(0);
    basketManager.setPaging();
}

/**
 * Satır temizler
 * @param {int} rowNum satır no
 * @param {bool|int|null} recalculate alt toplamlar hesaplansınmı
 */
function clear_row(rowNum, recalculate) {
    basketManagerObject.basketItems.splice(rowNum, 1);

    if (basketManager.hasShownItem("deliver_dept_assortment")) {
        if (departmentArray[rowNum] != undefined) {
            let deptArrayLen = departmentArray[rowNum].length;
            for (let di = 1; di <= deptArrayLen; di++) {
                try { departmentArray[rowNum][counter2][0] = 0; }
                catch(e){}
            }
        }
    }
    if (recalculate === undefined || recalculate === null || recalculate === true ) {
        toplam_hesapla(0);
    }
    basketManager.setPaging();
    return true;
}

/**
 * Add fonksiyonu ile benzerdir
 */
function upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,flt_marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id, otv, product_name_other, update_product_row_id, is_commission, row_catalog_id,row_unique_relation_id,amount_other,unit_other,ek_tutar,shelf_number,basket_extra_info,prom_relation_id,reserve_type_,order_currency_,toplam_hesap,reserve_date,list_price,number_of_installment,price_cat,karma_product_id,row_service_id,ek_tutar_price,row_width,row_depth,row_height,to_shelf_number,row_project_id,row_project_name,action_window_name,row_paymethod_id,pbs_id,pbs_code,special_code,basket_employee_id,basket_employee,row_work_id,row_work_name,row_exp_center_id,row_exp_center_name,row_exp_item_id,row_exp_item_name,row_acc_code,select_info_extra,detail_info_extra,price_other_calc,gtip_number,row_activity_id,row_subscription_id,row_subscription_name,row_assetp_id,row_assetp_name,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,reason_code_info,row_tevkifat_id,row_specific_weight) {

    reason_code_info = '';
    delivery_condition_info = '';
    container_type_info = '';
    delivery_type_info = '';
    container_number = '';
    container_quantity = '';
    delivery_country = '';
    delivery_city = '';
    delivery_county = '';
    
    row_subscription_id = '';
    row_subscription_name = '';
    row_assetp_id = '';
    row_assetp_name = '';
    row_activity_id = row_activity_id != '' ? row_activity_id : '';
    row_bsmv_rate = row_bsmv_rate != '' ? row_bsmv_rate : 0;
    row_specific_weight = row_specific_weight != '' ? row_specific_weight : 0;
    row_oiv_rate = row_oiv_rate != '' ? row_oiv_rate : 0;
    row_bsmv_currency = 0.0;
    row_bsmv_amount = 0.0;
    row_oiv_amount = 0.0;
    row_tevkifat_rate = 0.0;
    row_tevkifat_amount = 0.0;

    let my_serial_ctrl = null;

    if ( ( basketService.wmo_module().indexOf('add') >= 0 || basketService.wmo_event() == 'add' ) && [11,12,47,48,1,20,2,18,31,32,11,15,17,47,49,10].indexOf( basketService.basket_id() ) ) {
        my_serial_ctrl = wrkBrowserStorage().getJSON("chk_product_serial1_" + product_id);
        if (my_serial_ctrl == null) {
            my_serial_ctrl = wrk_safe_query("chk_product_serial1", "dsn3", 0, product_id);
            wrkBrowserStorage().setJSON("chk_product_serial1_" + product_id, my_serial_ctrl);
        }
    }

    if (( my_serial_ctrl == null || ( my_serial_ctrl != null && my_serial_ctrl.IS_SERIAL_NO == 1 )) && action_window_name != undefined && action_window_name != "" && action_window_name != basketService.get("basket_unique_code")) {
        alert("Çalıştığınız Ekran Mevcut Sepet İle Uyumlu Değil!\nFiyat Listesi Ekranınızı Yenilemelisiniz!");
        return false;
    }

    let ek_tutar_other_total = 0;
    let ek_tutar_total = 0;
    let ek_tutar_marj = 0;
    let ek_tutar_cost = 0;
    let temp_wkr_row_id = 'WRK' + js_create_unique_id();

    if (isNaN(row_width)) row_width = '';
    if (isNaN(row_depth)) row_depth = '';
    if (isNaN(row_height)) row_height = '';
    if (isNaN(to_shelf_number)) to_shelf_number = '';
    if (isNaN(shelf_number)) shelf_number = '';
    if (isNaN(pbs_id)) pbs_id = '';
    if (isNaN(pbs_code)) pbs_code = '';
    if (iskonto_tutar == undefined || isNaN(iskonto_tutar)) iskonto_tutar = 0;
    if (isNaN(ek_tutar_price)) ek_tutar_price = 0;
    if (isNaN(row_project_id)) row_project_id = 0;
    if (row_project_name == undefined) row_project_name = '';
    if (row_paymethod_id == undefined) row_paymethod_id = '';
    if (isNaN(row_work_id)) row_work_id = 0;
    if (row_work_name == undefined) row_work_name = '';
    if (isNaN(row_exp_center_id)) row_exp_center_id = 0;
    if (row_exp_center_name == undefined) row_exp_center_name = '';
    if (isNaN(row_exp_item_id)) row_exp_item_id = 0;
    if (row_exp_item_name == undefined) row_exp_item_name = '';
    if (row_acc_code == undefined) row_acc_code = '';

    let price_net = price;
    let price_net_doviz = price_other;
    if(isNaN(amount_other) || amount_other == '') amount_other = 1;

    if (ek_tutar_price != '') {
        if ( isNaN(amount_other) || amount_other == '' ) amount_other = 1;
        ek_tutar_cost = ek_tutar_price * amount_other;
        if (ek_tutar != '' && ek_tutar != 0) {
            ek_tutar_marj = (ek_tutar * 100 / ek_tutar_cost) - 100;
        } else {
            ek_tutar = ek_tutar_cost;
        }
    }

    if (iskonto_tutar != 0 || ek_tutar != 0) {
        price_net_doviz = parseFloat(price_net_doviz.toString()) + parseFloat(ek_tutar.toString());
        price_net_doviz = price_net_doviz - parseFloat(iskonto_tutar.toString());
        ek_tutar_other_total = ek_tutar * amount_;
        for (let mi = 0; mi < moneyArray.length; mi++) {
            if (moneyArray[mi] == money) {
                ek_tutar_total = ek_tutar * rate2Array[mi] / rate1Array[mi] * amount_;
                price_net -= iskonto_tutar * rate2Array[mi] / rate1Array[mi];
                price_net += ek_tutar * rate2Array[mi] / rate1Array[mi];
            }
        }
    }

    if (isNaN(list_price) || list_price == '') list_price = price;
    if (isNaN(number_of_installment) || number_of_installment == '') number_of_installment = 0;
    if (price_cat == undefined) price_cat = '';
    if (isNaN(karma_product_id)) karma_product_id = '';
    if (isNaN(row_service_id)) row_service_id = '';
    if (isNaN(row_catalog_id)) row_catalog_id = '';
    if (isNaN(flt_marj) || flt_marj.length == 0) flt_marj = 0;
    if (reserve_date == undefined) reserve_date='';

    let upd_shelf_number = '';
    let upd_to_shelf_number = '';
    if (shelf_number != '' || to_shelf_number != '') {
        let listParam = shelf_number + "*" + to_shelf_number;
        let shelf_name_sql = "obj_get_shelf_name_2";
        if (shelf_number != '' && to_shelf_number != '') {
            shelf_name_sql = "obj_get_shelf_name_3";
        } else if (shelf_number != '') {
            shelf_name_sql = "obj_get_shelf_name_4";
        } else if (to_shelf_number != '') {
            shelf_name_sql = "obj_get_shelf_name_5";
        }

        let get_shelf_name = wrkBrowserStorage().getJSON(shelf_name_sql);
        if (get_shelf_name == null) {
            get_shelf_name = wrk_safe_query(shelf_name_sql, "dsn3");
            wrkBrowserStorage.setJSON(shelf_name_sql, get_shelf_name);
        }
        if (get_shelf_name.recordcount > 0) {
            for (let si = 0; si < get_shelf_name.recordcount; si++) {
                if (shelf_number != '' && get_shelf_name.PRODUCT_PLACE_ID[si] == shelf_number) {
                    upd_shelf_number = String(get_shelf_name.SHELF_CODE[si]);
                } else if (to_shelf_number != '' && get_shelf_name.PRODUCT_PLACE_ID[si] == to_shelf_number) {
                    upd_to_shelf_number = String(get_shelf_name.SHELF_CODE[si]);
                }
            }
        }
    }
    if (row_project_id != '' && row_project_name == '') {
        let get_prjct_name = wrkBrowserStorage().getJSON("obj_get_prjct_name_" + row_project_id);
        if (get_prjct_name == null) {
            get_prjct_name = wrk_safe_query("obj_get_prjct_name", "dsn", 0, row_project_id);
            wrkBrowserStorage().setJSON("obj_get_prjct_name_" + row_project_id, get_prjct_name);
        }
        if (get_prjct_name.recordcount) {
            row_project_name = String(get_prjct_name.PROJECT_HEAD);
        }
    }
    if (row_work_id != '' && row_work_name == '') {
        let get_work_name = wrkBrowserStorage().getJSON("obj_get_work_name_" + row_work_id);
        if (get_work_name == null) {
            get_work_name = wrk_safe_query("obj_get_work_name", "dsn", 0, row_work_id);
            wrkBrowserStorage.setJSON("obj_get_work_name_" + row_work_id, get_work_id);
        }
        if (get_work_name.recordcount) {
            row_work_name = String(get_work_name.WORK_HEAD);
        }
    }
    indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
    price_net = price_net * indirim_carpan / basketService.indirimFixNumber();
    if (promosyon_yuzde != '') price_net_dovz -= price_net_doviz * promosyon_yuzde / 100;
    price_net_doviz = price_net_doviz * indirim_carpan / basketService.indirimFixNumber();
    net_total_doviz = price_other * amount_ * indirim_carpan / basketService.indirimFixNumber();
    net_total = price_net * amount_;
    row_otv_total = net_total * otv / 100;
    if ( basketService.get("display_list").indexOf('otv_from_tax_price') >= 0 ) {
        var row_tax_total = (net_total + row_otv_total) * tax /100;
    } else {
        var row_tax_total = net_total * tax / 100;
    }

    let other_money_value = price_net_doviz * amount_;
    let row_cost_total = 0;
    let extra_cost_rate = 0;

    if (net_maliyet != '' && net_maliyet != 0) {
        row_cost_total += net_maliyet;
        if (extra_cost != '' && extra_cost != 0) {
            extra_cost_rate = (extra_cost / net_maliyet * 100);
            row_cost_total += extra_cost;
        }
    } else {
        net_maliyet = 0;
    }

    let cirow = basketManagerObject.basketItems()[update_product_row_id];
    if (basketManagerObject.basketItems().length > 1) {
        if (cirow.is_promotion() == 0 && cirow.row_promotion_id() != '') {
            var old_prom_relation_id = cirow.prom_relation_id();
        }
    } else {
        cirow.is_commission(0);
    }

    let unit2_extra = [];
    let get_product_unit = wrkBrowserStorage().getJSON("prdp_get_unit2_all_" + product_id);
    if (get_product_unit == null) {
        get_product_unit = wrk_safe_query('prdp_get_unit2_all' ,'dsn3' ,0 ,product_id);
        wrkBrowserStorage().setJSON("prdp_get_unit2_all_" + product_id, get_product_unit);
    }
    for (let kk = 0; kk < get_product_unit.recordcount; kk++) {
        let unit_line = {};
        unit_line.selected = get_product_unit.ADD_UNIT[kk] == unit_other;
        unit_line.value = get_product_unit.ADD_UNIT[kk];
        unit2_extra.push(unit_line);
    }
    
    cirow.row_catalog_id( row_catalog_id );
    //cirow.wrk_row_id( temp_wrk_row_id );
    cirow.row_paymethod_id( row_paymethod_id );
    cirow.price_cat( price_cat );
    cirow.product_id( product_id );
    cirow.is_inventory( is_inventory );
    cirow.row_ship_id( row_ship_id );
    cirow.stock_id( stock_id );
    cirow.lot_no( lot_no );
    cirow.row_unique_relation_id( row_unique_relation_id );
    cirow.prom_relation_id( prom_relation_id );
    cirow.shelf_number( shelf_number );
    cirow.shelf_number_txt( upd_shelf_number );
    //cirow.to_shelf_number( to_shelf_number );
    //cirow.to_shelf_number_txt( to_shelf_number_txt );
    cirow.pbs_id( pbs_id );
    cirow.pbs_code( pbs_code );
    cirow.unit_other( unit_other );
    cirow.unit2_extra( unit2_extra );
    cirow.amount_other( amount_other );
    cirow.product_name_other( product_name_other );
    cirow.container_number( container_number );
    cirow.container_quantity( container_quantity );
    cirow.delivery_country( delivery_country );
    cirow.gtip_number( gtip_number );
    cirow.ek_tutar( ek_tutar );
    cirow.ek_tutar_price( ek_tutar_price );
    cirow.ek_tutar_cost( ek_tutar_cost );
    cirow.ek_tutar_marj( ek_tutar_marj );
    cirow.ek_tutar_total( ek_tutar_total );
    cirow.ek_tutar_other_total( ek_tutar_other_total );
    cirow.stock_code( stock_code );
    cirow.barcod( barcod );
    cirow.special_code( special_code );
    cirow.manufact_code( manufact_code );
    cirow.product_name( product_name );
    cirow.amount( amount_ );
    cirow.unit_id( unit_id_ );
    cirow.product_account_code( product_account_code );
    cirow.unit( unit_ );
    cirow.spect_id( spect_id );
    cirow.spect_name( spect_name );
    cirow.list_price( parseFloat(list_price.toString()) );
    cirow.list_price_discount(0);
    cirow.price( parseFloat(price.toString()) );
    cirow.price_other( parseFloat(price_other.toString()) );
    cirow.price_net( parseFloat(price_net.toString()) );
    cirow.price_net_doviz( parseFloat(price_net_doviz.toString()) );
    cirow.tax( parseFloat(tax.toString()) );
    cirow.tax_percent( parseFloat(tax.toString()) );
    cirow.otv( parseFloat(otv.toString()) );
    cirow.row_total( parseFloat(price.toString()) * parseFloat(amount_.toString()) );
    cirow.row_nettotal( parseFloat(row_nettotal.toString()) );
    cirow.row_otvtotal( parseFloat(row_otv_total.toString()) );
    cirow.row_taxtotal( parseFloat(row_taxtotal.toString()) );
    cirow.row_lasttotal( parseFloat(row_lasttotal.toString()) );
    cirow.tax_price( ( parseFloat(net_total.toString()) + parseFloat(row_taxtotal.toString()) + parseFloat(row_otv_total.toString()) / parseFloat(amount_.toString()) ) );
    cirow.other_money( money );
    cirow.other_money_value( parseFloat(other_money_value.toString()) );
    cirow.other_money_gross_total( parseFloat(other_money_value.toString()) * (100 + parseFloat(tax.toString())) / 100 );
    cirow.deliver_date( deliver_date );
    cirow.reserve_date( reserve_date );
    cirow.deliver_dept( deliver_dept );
    cirow.basket_row_department( department_head );
    cirow.iskonto_tutar( parseFloat(iskonto_tutar.toString()) );
    cirow.net_maliyet( parseFloat(net_maliyet.toString()) );
    cirow.extra_cost( parseFloat(extra_cost.toString()) );
    cirow.extra_cost_rate( parseFloat(extra_cost_rate.toString()) );
    cirow.row_cost_total( parseFloat(row_cost_total.toString()) );
    cirow.marj( parseFloat(flt_marj.toString()) );
    cirow.dara(0);
    cirow.darali( parseFloat(amount_.toString()) );
    cirow.duedate( duedate );
    cirow.number_of_installment( number_of_installment );
    cirow.row_promotion_id( row_promotion_id );
    cirow.promosyon_yuzde(0);
    cirow.promosyon_maliyet(0);
    cirow.prom_stock_id('');
    cirow.indirim1( parseFloat(d1.toString()) );
    cirow.indirim2( parseFloat(d2.toString()) );
    cirow.indirim3( parseFloat(d3.toString()) );
    cirow.indirim4( parseFloat(d4.toString()) );
    cirow.indirim5( parseFloat(d5.toString()) );
    cirow.indirim6( parseFloat(d6.toString()) );
    cirow.indirim7( parseFloat(d7.toString()) );
    cirow.indirim8( parseFloat(d8.toString()) );
    cirow.indirim9( parseFloat(d9.toString()) );
    cirow.indirim10( parseFloat(d10.toString()) );
    cirow.indirim_total( parseFloat(indirim_carpan.toString()) );
    cirow.indirim_carpan( parseFloat(indirim_carpan.toString()) );
    cirow.basket_extra_info( basket_extra_info );
    cirow.select_info_extra( select_info_extra );
    cirow.detail_info_extra( detail_info_extra );
    cirow.order_currency( order_currency_ );
    cirow.reserve_type( reserve_type_ );
    cirow.row_width( row_width );
    cirow.row_height( row_height );
    cirow.row_project_id( row_project_id );
    cirow.row_project_name( row_project_name );
    cirow.row_work_id( row_work_id );
    cirow.row_work_name( row_work_name );
    cirow.row_exp_center_id( row_exp_center_id );
    cirow.row_exp_center_name( row_exp_center_name );
    cirow.row_exp_item_id( row_exp_item_id );
    cirow.row_exp_item_name( row_exp_item_name );
    cirow.row_activity_id( row_activity_id );
    cirow.row_acc_code( row_acc_code );
    cirow.row_subscription_id( row_subscription_id );
    cirow.row_subscription_name( row_subscription_name );
    cirow.row_assetp_id( row_assetp_id );
    cirow.row_assetp_name( row_assetp_name );
    cirow.row_bsmv_rate( row_bsmv_rate );
    cirow.row_specific_weight( row_specific_weight );
    cirow.row_bsmv_amount( row_bsmv_amount );
    cirow.row_bsmv_currency( row_bsmv_currency );
    cirow.row_oiv_amount( row_oiv_amount );
    cirow.row_tevkifat_rate( row_tevkifat_rate );
    cirow.row_tevkifat_amount( row_tevkifat_amount );
    cirow.row_tevkifat_id( row_tevkifat_id );

    if (is_promotion != undefined && is_promotion != '') {
        cirow.is_promotion( is_promotion );
    } else {
        cirow.is_promotion(0);
    }

    if (basketManagerObject.basketItems().length > 0 && old_prom_relation_id != undefined && old_prom_relation_id != '') {
        for (let bi = 0; bi < basketManagerObject.basketItems().length; bi++) {
            if (basketManagerObject.basketItems()[bi].is_promotion() == 1 && basketManagerObject.basketItems()[bi].prom_relation_id() == old_prom_relation_id) {
                clear_row(bi, toplam_hesap !== undefined && toplam_hesap != 1);
            }
        }
    }

    if (toplam_hesap == undefined || toplam_hesap == 1) {
        toplam_hesapla(0);
    }

}

/**
 * Ücretsiz promosyon ekler
 * @param {int} stock_id stok id
 * @param {int} promotion_id promosyon id
 * @param {float} free_stock_price fiyatı
 * @param {string} money para birimi
 * @param {float} free_stock_amount miktar
 * @param {bool|int} is_general genel mi
 * @param {float} free_prom_cost maliyet tutarı
 * @param {int|null} upd_row_no güncellenecek satır no
 * @param {bool|int} is_upd update mi
 * @param {int} prom_relation_id ilişkili promosyon id si
 */
function add_free_prom(stock_id,promotion_id,free_stock_price,money,free_stock_amount,is_general,free_prom_cost,upd_row_no,is_upd,prom_relation_id) {
    if ( basketService.wmo_module() == 'invoice' || [1,2,4,10,14,18,20,21,33,42,43,51,52].indexOf( basketService.basket_id() ) >= 0 ) {
        let get_stock_proms = wrkBrowserStorage().getJSON("obj_get_stock_proms_2_" + stock_id.toString());
        if (get_stock_proms == null) {
            get_stock_proms = wrk_safe_query("obj_get_stock_proms_2", "dsn3", 0, stock_id);
            wrkBrowserStorage().setJSON("obj_get_stock_proms_2" + stock_id.toString(), get_stock_proms);
        }
        if (get_stock_proms.recordcount) {
            let prom_date = js_date(date_add('d,',1,$("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString()));
            if (get_stock_proms.IS_COST) {
                let listParam = basketService.get("dsn2_alias") + "*" + prom_date + "*" + stock_id;
                var get_stok_cost = wrkBrowserStorage().getJSON("obj_get_stock_cost_" + listParam);
                if (get_stok_cost == null) {
                    get_stok_cost = wrk_safe_query("obj_get_stock_cost", "dsn3", "1", listParam);
                    wrkBrowserStorage().setJSON("obj_get_stock_cost_" + listParam, get_stok_cost);
                }
            }
            if ( basketService.wmo_module() == 'invoice' || [1,2,33,42].indexOf(basketService.basket_id()) >= 0 ) {
                let get_prod_acc = wrkBrowserStorage().getJSON("obj_get_prod_acc_" + get_stock_proms.PRODUCT_ID);
                if (get_prod_acc == null) {
                    get_prod_acc = wrk_safe_query("obj_get_prod_acc", "dsn3", 0, get_stock_proms.PRODUCT_ID);
                    wrkBrowserStorage().setJSON("obj_get_prod_acc_" + get_stock_proms.PRODUCT_ID, get_prod_acc);
                }
                if (get_prod_acc.recordcount) {
                    var product_account_code = get_prod_acc.ACCOUNT_CODE;
                } else {
                    var product_account_code = "";
                }
            } else {
                var product_account_code = "";
            }
            let product_name = get_stock_proms.PRODUCT_NAME + get_stock_proms.PROPERTY;
            let row_promotion_id = promotion_id;
            let promosyon_maliyet = free_prom_cost;
            let prom_stock_id = is_general ? '' : get_stock_proms.STOCK_ID;
            let iskonto_tutar = free_stock_price;
            let price = free_stock_price;
            for (let mi = 0; mi < moneyArray.length; mi++) {
                if (moneyArray[mi] == money) {
                    price = free_stock_price * rate2Array[mi] / rate1Array[mi];
                }
            }
            let price_other = free_stock_price;
            if (get_stock_proms.IS_COST == 1 && get_stok_cost.recordcount) {
                var net_maliyet = get_stok_cost.PURCHASE_NET_SYSTEM;
                var extra_cost = get_stok_cost.PURCHASE_EXTRA_COST_SYSTEM;
            } else {
                var net_maliyet = '';
                var extra_cost = 0;
            }
            let amount = free_stock_amount;
            let row_unique_relation_id = '';
            if (prom_relation_id !== undefined) {
                var prom_relation = prom_relation_id;
            } else {
                var prom_relation = '';
            }
            let toplam_hesap = is_general ? 0 : 1;
            if (is_upd == undefined || is_upd == 0 || is_upd == false) {
                add_basket_row( get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNI, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount, product_account_code, get_stock_proms.IS_INVENTORY, get_stock_proms.IS_PRODUCTION, net_maliyet, '', extra_cost, row_promotion_id, '', promosyon_maliyet, iskonto_tutar, 1, prom_stock_id, 0, '', '', '', 0, '', row_unique_relation_id, '', toplam_hesap, 0, '', prom_relation );
            } else {
                upd_row(get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNIT, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount, product_account_code, get_stock_proms.IS_INVENTORY, get_stock_proms.IS_PRODUCTION, net_maliyet, '', extra_cost, row_promotion_id, '', promosyon_maliyet, iskonto_tutar, 1, prom_stock_id, 0, '', upd_row_no, 0, '', row_unique_relation_id, '', '', 0, '', '', prom_relation_id);
            }
        }
    }
}

/**
 * Genel promosyon hesaplama
 * @param {float} basket_net_val net tutar
 * @param {bool|null} recalculate alt toplam hesaplansın mı
 */
function add_general_prom(basket_net_val, recalculate) {
    if (basketService.wmo_module() == 'invoice' || [1,2,4,10,14,18,20,21,33,42,43,51,52].indexOf(basketService.basket_id()) >= 0) {
        let is_general_prom_found = true;
        let is_free_prom_found = true;
        
        let general_prom_id = '';
        let general_prom_discount = 0;
        let general_prom_limit = 0;
        let general_prom_amount = 0;

        let free_prom_id = '';
        let free_prom_cost = 0;
        let free_prom_limit = 0;
        let free_prom_stock_id = '';
        let free_prom_amount = 0;
        let free_prom_stock_price = 0;
        let free_prom_stock_money = '';

        let get_comp_proms = null;
        if ( $("#basket_main_div #company_id").length != 0 ) {
            let prom_date = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
            let listParam = prom_date + "*" + basket_net_val;
            let new_sql = "obj_get_comp_proms_2";
            if (basket_net_val != undefined && basket_net_val != '' && basket_net_val != 0) {
                new_sql = "obj_get_comp_proms_3";
            }
            get_comp_proms = wrkBrowserStorage().getJSON(new_sql + "_" + listParam);
            if (get_comp_proms == null) {
                get_comp_proms = wrk_safe_query(new_sql, "dsn3", 0, listParam);
                wrkBrowserStorage().setJSON(new_sql + "_" + listParam, get_comp_proms);
            }
        } else {
            get_comp_proms = {};
            get_comp_proms.recordcount = 0;
        }

        let prom_items_free = [];
        let prom_items_discount = [];
        if (get_comp_proms.recordcount) {
            basketManagerObject.basketFooter.is_general_prom(1);
            
            for (let pi = 0; pi < get_comp_proms.recordcount; pi++) {
                if (is_general_prom_found && get_comp_proms.DISCOUNT[pi].length) {
                    for (let mi = 0; mi < moneyArray.length; mi++) {
                        if (moneyArray[mi] == get_comp_proms.LIMIT_CURRENCY[pi]) {
                            general_prom_limit = get_comp_proms.LIMIT_VALUE[pi] * rate2Array[mi] / rate1Array[mi];
                        }
                    }
                    general_prom_id = get_comp_proms.PROM_ID[pi];
                    general_prom_discount = get_comp_proms.DISCOUNT[pi];
                } else if (is_free_prom_found && get_comp_proms.FREE_STOCK_ID[pi].length) {
                    for (let mi = 0; mi < moneyArray.length; mi++) {
                        if (moneyArray[mi] == get_comp_proms.LIMIT_CURRENCY[pi]) {
                            free_prom_limit = get_comp_proms.LIMIT_VALUE[pi] * rate2Array[mi] / rate1Array[mi];
                        }
                    }
                    free_prom_id = get_comp_proms.PROM_ID[pi];
                    free_prom_cost = get_comp_proms.TOTAL_PROMOTION_COST[pi];
                    free_prom_stock_id = get_comp_proms.FREE_STOCK_ID[pi];
                    free_prom_amount = get_comp_proms.FREE_STOCK_AMOUNT[pi];
                    free_prom_stock_price = get_comp_proms.FREE_STOCK_PRICE[pi];
                    free_prom_stock_money = get_comp_proms.AMOUNT_1_MONEY[pi];
                }                
            }
            basketManager.setBasketFooterItem("general_prom_id", general_prom_id);
            basketManager.setBasketFooterItem("general_prom_discount", general_prom_discount);
            basketManager.setBasketFooterItem("general_prom_limit", general_prom_limit);
            basketManager.setBasketFooterItem("general_prom_amount", general_prom_amount);
            basketManager.setBasketFooterItem("free_prom_id", free_prom_id);
            basketManager.setBasketFooterItem("free_prom_cost", free_prom_cost);
            basketManager.setBasketFooterItem("free_prom_limit", free_prom_limit);
            basketManager.setBasketFooterItem("free_prom_stock_id", free_prom_stock_id);
            basketManager.setBasketFooterItem("free_prom_amount", free_prom_amount);
            basketManager.setBasketFooterItem("free_prom_stock_price", free_prom_stock_price);
            basketManager.setBasketFooterItem("free_prom_stock_money", free_prom_stock_money);
            if (recalculate === undefined || recalculate === null || recalculate == true) {
                toplam_hesapla(0);
            }
        } else if (basketManagerObject.basketFooter.is_general_prom()) {
            if (recalculate === undefined || recalculate === null || recalculate == true) {
                toplam_hesapla(0);
            }
        }
        basketManagerObject.basketFooter.prom_items_discount(prom_items_discount);
        basketManagerObject.basketFooter.prom_items_free(prom_items_free);
    }
    return true;
}

/**
 * Komisyon satırı ekler
 * @param {float} commission_price komisyon tutarı
 * @param {bool|int|null} is_upd update mi
 * @param {int|null} upd_row_no update satır no
 */
function add_commission_row(commission_price, is_upd, upd_row_no) {
    if ( !$("#basket_main_div #card_paymethod_id").length != 0 ) {
        return false;
    }

    let new_sql = 'obj_get_card_comms_2';
    if($("#basket_main_div #commethod_id").length != 0 && Number($("#basket_main_div #commethod_id").val()) == 6) {
        new_sql = 'obj_get_card_comms';
    }

    let get_card_comms = wrkBrowserStorage().getJSON(new_sql + "_" + $("#basket_main_div #commethod_id").val());
    if (get_card_comms == null) {
        get_card_comms = wrk_safe_query(new_sql, 'dsn3', 0, $("#basket_main_div #commethod_id").val());
        wrkBrowserStorage().setJSON(new_sql + "_" + $("#basket_main_div #commethod_id").val());
    }

    if (get_card_comms.recordcount) {
        let product_id = get_card_comms.PRODUCT_ID;
        let stock_id = get_card_comms.STOCK_ID;
        let stock_code = get_card_comms.STOCK_CODE;
        let special_code = get_card_comms.STOCK_CODE_2;
        let barcod = get_card_comms.BARCOD;
        let manufact_code = get_card_comms.MANUFACT_CODE;
        let product_name = get_card_comms.PRODUCT_NAME + get_card_comms.PROPERTY;
        let unit_id = get_card_comms.UNIT_ID;
        let unit = get_card_comms.UNIT;
        let special_id = '';
        let spect_id = '';
        let spect_name = '';
        let row_promotion_id = '';
        let promosyon_yuzde = '';
        let promosyon_maliyet = '';
        let is_promotion = 0;
        let prom_stock_id = '';
        let iskonto_tutar = 0;
        let tax = get_card_comms.TAX;
        commission_price = wrk_round( commission_price * 100 / ( 100 + parseFloat(tax) ), basketService.priceRoundNumber() );
        let price = commission_price;
        for (let mi = 0; mi < moneyArray.length; mi++) {
            if (moneyArray[mi] == get_card_comms.MONEY) {
                price = commission_price * rate2Array[mi] / rate1Array[mi];
            }
        }
        let price_other = commission_price;
        let is_inventory = get_card_comms.IS_INVENTORY;
        let is_production = get_card_comms.IS_PRODUCTION;
        let net_maliyet = '';
        let marj = '';
        let extra_cost = 0;
        let money = get_card_comms.MONEY;
        let amount = 1;

        let product_account_code = '';
        let get_prod_acc = wrkBrowserStorage().getJSON("obj_get_prod_acc_3_" + product_id);
        if (get_prod_acc == null) {
            get_prod_acc = wrk_safe_query("obj_get_prod_acc_3", "dsn3", 0, product_id);
            wrkBrowserStorage().setJSON("obj_get_prod_acc_3_" + product_id, get_prod_acc);
        }
        if (get_prod_acc.recordcount) {
            product_account_code = get_prod_acc.ACCOUNT_CODE;
        }
        let row_unique_relation_id = '';

        let toplam_hesap = 0;
        let is_commission = 1;

        if (is_upd != undefined && is_upd == 1 && upd_row_no != undefined) {
            let cirow = basketManagerObject.basketItems()[upd_row_no];
            if (cirow.ORDER_CURRENCY.length) {
                let order_currency = cirow.ORDER_CURRENCY;
                let reserve_type = cirow.RESERVE_TYPE;
                let row_ship_id = cirow.ROW_SHIP_ID;
                let duedate = cirow.DUEDATE;
                upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id, unit, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount, product_account_code, is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,upd_row_no,is_commission,'',row_unique_relation_id,'','','',0,'','','','',order_currency,0);
            }
        } else {
            let row_ship_id = 0;
            let duedate = 0;
            add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id, unit, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,'','','',0,'',row_unique_relation_id,'',toplam_hesap,is_commission,'','','','','',0,'','','','','',0,'','','','','','','','','',special_code);
        }
    }
}

/**
 * Vadeye göre fiyatı düzenler
 * @param {int} from_row satır no
 */
function set_basket_duedate_price(from_row) {
    from_row = from_row != undefined && from_row != null ? from_row : 0;

    let row_duedate = basketManagerObject.basketItems()[from_row].duedate();
    let row_list_price = basketManagerObject.basketItems()[from_row].list_price();
    let row_price_cat = basketManagerObject.basketItems()[from_row].price_cat();

    if (row_duedate != '' && row_price_cat != undefined && row_price_cat != '') {
        let get_price_cat_detail = wrkBrowserStorage().getJSON("obj_get_price_cat_detail_" + row_price_cat);
        if (get_price_cat_detail == null) {
            get_price_cat_detail = wrk_safe_query( "obj_get_price_cat_detail", "dsn3", 0, row_price_cat );
            wrkBrowserStorage().setJSON("obj_get_price_cat_detail_" + row_price_cat, get_price_cat_detail);
        }
        let new_price = row_list_price;
        if (get_price_cat_detail.recordcount != undefined && get_price_cat_detail.recordcount > 0 && get_price_cat_detail.AVG_DUE_DAY != '' && get_price_cat_detail.DUE_DIFF_VALUE != '') {
            if (get_price_cat_detail.AVG_DUE_DAY > row_duedate) {
                new_price = (row_list_price - ( row_list_price * ( parseInt(get_price_cat_detail.AVG_DUE_DAY) - row_duedate ) * (get_price_cat_detail.EARLY_PAYMENT / 30) / 100));
            } else if (get_price_cat_detail.AVG_DUE_DAY < row_duedate) {
                new_price = (row_list_price + ( ( row_list_price * (parseInt(row_duedate) - get_price_cat_detail.AVG_DUE_DAY) * (get_price_cat_detail.DUE_DIFF_VALUE / 30)) / 100 ));
            }
        }
        if (new_price != '' && !isNaN(new_price)) {
            basketManagerObject.basketItems()[from_row].price( wrk_round( new_price, basketService.priceRoundNumber() ) );
            satir_hesapla('price', basketManagerObject.basketItems()[from_row]);
        }
    }
}

/**
 * Vade tarihini işler
 * @param {int} type işlem tipi
 * @param {int} due_date_value vade tarihi değeri
 */
function apply_duedate(type, due_date_value) {
    let set_due_date = '';
    if (type == 2) {
        set_due_date = $("#basket_main_div #set_row_duedate").val();
    } else if (type == 1 && due_date_value != undefined && due_date_value != '') {
        set_due_date = due_date_value;
    }

    if (basketManagerObject.basketItems().length) {
        for (let ri = 0; ri < basketManagerObject.basketItems().length; ri++) {
            let row = basketManagerObject.basketItems()[ri];
            if (type == 1 && (row.duedate() == '' || row.duedate() == 0)) {
                row.duedate(set_due_date);
            } else if (type == 2) {
                row.duedate(set_due_date);
                if (basketManager.hasShownItem("number_of_installment")) {
                    set_basket_duedate_price(ri);
                }
            }
            if (!basketManager.hasShownItem("duedate")) {
                if (type == 1) {
                    basketManagerObject.basketItems()[ri].duedate( set_due_date );
                }
            }
        }
        if (type != 1) {
            set_paper_duedate();
        }
    } else {
        return true;
    }
}

/**
 * Belge vade tarihini düzeltir
 * @param {string} field_name kullanılacak input adı
 * @param {int|null} type işlem tipi
 * @param {bool|int|null} is_row_parse daha öncede satır parse edilmişmi
 */
function change_paper_duedate(field_name, type, is_row_parse) {
    $(document).ready(function () {
        let paper_date = "";
        if (field_name == undefined || field_name == "") paper_date = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val(); 
        else paper_date =  $("#basket_main_div #" + field_name).val();

        if ( $("#basket_main_div #paymethod_id") != undefined && $("#basket_main_div #paymethod_id").val() != "" && $("#basket_main_div #paymethod").val() != "") {
            let paymethod_id = $("#basket_main_div #paymethod_id").val();
            let is_holiday = 0;
            let is_nextday = 0;
            let data = "";
            let add_url = "";
            let callfunction = "";

            if (change_paper_duedate.caller != null) callfunction = change_paper_duedate.caller.toString();
            if (type == 2 || (!callfunction.includes("check_member") && (callfunction.includes("function onchange(event)") || callfunction.includes("function onChange(event)")))) {
                if (type == 1) {
                    add_url = "&due_date="+$("#basket_main_div #basket_due_value_date_").val();
                } else {
                    add_url = "&due_day="+$("#basket_main_div #basket_due_value").val();
                }
            }

            if (paymethod_id != '') {
                $.ajax({ 
                    url: 'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1&action_date=' + paper_date + '&paymethod_id='+paymethod_id + add_url,
                    async: false,
                    success: function (res) {
                        data = res.replace('//""', '');
                        data = $.parseJSON( data );
                    }
                });
                if (data != "") {
                    is_holiday = data.ISHOLIDAY;
                    is_nextday = data.NEXT_DAY;
                    $("#basket_main_div #basket_due_value").val(data.DAYDIFF);
                    $("#basket_main_div #basket_due_value_date_").val(data.DUE_DATE);
                } else {
                    alert("Vade hesaplamasında hata oluştu!");
                }
                if (is_row_parse == undefined) {
                    if (is_holiday) {
                        alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
                    }
                    if (is_nextday) {
                        alert("Ödeme Yönteminde hafta günü seçili. Vade Tarihi Düzenlendi!");
                    }
                }
            }
        }

        if (type != undefined && type == 1) {
            $("#basket_main_div #basket_due_value").val(datediff(paper_date ,$("#basket_main_div #basket_due_value_date_").val(),0));
        } else {
            if(isNumber($("#basket_main_div #basket_due_value").val()) != false && $("#basket_main_div #basket_due_value").val() != 0)
            {
                $("#basket_main_div #basket_due_value_date_").val(date_add('d',parseFloat($("#basket_main_div #basket_due_value").val()),paper_date));
            }
            else
            {
                $("#basket_main_div #basket_due_value_date_").val(paper_date);
                if($("#basket_main_div #basket_due_value").val() == '')
                {
                    $("#basket_main_div #basket_due_value").val(datediff(paper_date,$("#basket_main_div #basket_due_value_date_").val(),0));
                }
            }
        }

        basketManager.setBasketFooterItem("duedate", $("#basket_main_div #basket_due_value").val());
        if (is_row_parse == undefined || is_row_parse == 1) {
            apply_duedate(1, basketManagerObject.basketFooter.duedate());
        }
    });
}

/**
 * Vade tarihini ayarlar
 */
function set_paper_duedate() {
    if (basketManager.hasShownItem("duedate")) {
        let general_total = 0;
        let row_totals = 0;
        if (basketManagerObject.basketItems().length == 1 && basketManagerObject.basketFooter.duedate() != "" && basketManagerObject.basketItems()[0].duedate() != "") {
            basketManager.setBasketFooterItem("duedate", basketManagerObject.basketItems()[0].duedate());
            $("#basket_main_div #basket_due_value").val(basketManagerObject.basketItems()[0].duedate());
        } else {
            for (let di = 0; di < basketManagerObject.basketItems().length; di++) {
                let row = basketManagerObject.basketItems()[di];
                let row_due_date = row.duedate();
                let temp_row_total = row.row_lasttotal();
                general_total = general_total + (row_due_date * temp_row_total);
                row_totals = row_totals + temp_row_total;
            }
            if (row_totals != 0 && basketManagerObject.basketFooter.duedate() != 0) {
                basketManagerObject.basketFooter.duedate(wrk_round(general_total/row_totals, 0));
                $("#basket_main_div #basket_due_value").val(basketManagerObject.basketFooter.duedate());
            }
        }
        let field_name_info = "";
        if ([4,6].indexOf( basketService.basket_id() ) >= 0) {
            if (basketService.get("xml_delivery_date_calculated") == 1) {
                field_name_info = "order_date";
            } else {
                field_name_info = "deliverdate";
            }
        }
        
        if($("#basket_main_div #basket_due_value_date_").length != 0 && $("#basket_main_div #basket_due_value_date_").val().length != 0)
        {
            if(typeof change_due_date != "undefined")
                change_due_date();
            else
                change_paper_duedate(field_name_info,2,0);
        }
    }
}



/**
 * KDV siz Döviz indirimi hesaplar
 */
function kdvsiz_doviz_indirim_hesapla() {
    let yazilan = basketManagerObject.basketFooter.genel_indirim_doviz_net_hesap();
    let total = 0;
    toplam_hesapla(1);
    total = yazilan / basketManagerObject.basketFooter.basket_rate1() * basketManagerObject.basketFooter.basket_rate2();
    basketManagerObject.basketFooter.genel_indirim(total);
    toplam_hesapla(1);
    return false;
}

/**
 * KDV li net indirim hesaplar
 */
function kdvli_net_indirim_hesapla() {
    let genel_t = basketManagerObject.basketFooter.basket_net_total();
    let yazilan = basketManagerObject.basketFooter.genel_indirim_kdvli_hesap();
    let total = 0;
    toplam_hesapla(1);
    let taxArray = basketService.get("generalTaxArray");
    let taxTotalArray = basketService.get("generaltaxArrayTotal");
    if (taxArray.length > 0) {
        let taxArrayLen = taxArray.length;
        for (let ti = 0; ti < taxArrayLen; ti++) {
            if (taxTotalArray[ti] != '' && taxTotalArray[ti] > 0) {
                let oran_deger = ((taxTotalArray[ti] * 100 / taxArray[ti]) + taxTotalArray[ti]);
                let oran_son = ((oran_deger * 100 / genel_t) * yazilan / 100) / (1 + taxArray[ti] / 100);
                total += oran_son;
            }
        }
    }
    basketManager.setBasketFooterItem("genel_indirim", total);
    basketManager.setBasketFooterItem("genel_indirim_doviz_net_hesap", wrk_round( yazilan / basketManagerObject.basketFooter.basket_rate1() * basketManagerObject.basketFooter.basket_rate2(), basketService.basketTotalRoundNumber() ));
    basketManager.setBasketFooterItem("genel_indirim_doviz_brut_hesap", wrk_round( total / basketManagerObject.basketFooter.basket_rate1() * basketManagerObject.basketFooter.basket_rate2(), basketService.basketTotalRoundNumber() ));
    toplam_hesapla(1);
    /* let totalDiscountRate = yazilan * 100 / basketManagerObject.basketFooter.basket_net_total();
    basketManagerObject.basketItems().forEach(bi => {
        bi.disc_ount5_(totalDiscountRate);
        satir_hesapla("disc_ount5_", bi);
    });
    toplam_hesapla(1); */
}

/**
 * Kdv li doviz indirim hesaplar
 */
function kdvli_doviz_indirim_hesapla() {
    let yazilan = basketManagerObject.basketFooter.genel_indirim_doviz_net_hesap();
    let total = 0;
    toplam_hesapla(1);
    total = yazilan / basketManagerObject.basketFooter.basket_rate1() * basketManagerObject.basketFooter.basket_rate2();
    basketManagerObject.basketFooter.genel_indirim_kdvli_hesap(wrk_round(total, basketService.basketTotalRoundNumber()));
    kdvli_net_indirim_hesapla();
}

/**
 * İlişkili satır kaldırır
 * @param {int} karma_prod_row satır no
 */
function clear_related_rows(karma_prod_row) {
    if (basketManagerObject.basketItems().length > 1) {
        let cirow = basketManagerObject.basketItems()[karma_prod_row];
        let uniq_rel_id = cirow.row_unique_relation_id();
        let free_prom_relation_id = '';
        if ( cirow.row_promotion_id().toString() != '' && cirow.is_promotion() == 0 ) {
            free_prom_relation_id = cirow.prom_relation_id();
        }
        if (uniq_rel_id != '' || ( free_prom_relation_id != undefined && free_prom_relation_id != '' )) {
            for (let ri = 0; ri < basketManagerObject.basketItems().length; ri++) {
                let relm = basketManagerObject.basketItems()[ri];
                if ( (uniq_rel_id != '' && relm.row_unique_relation_id() == uniq_rel_id) || (free_prom_relation_id != undefined && free_prom_relation_id != '' && relm.prom_relation_id() == free_prom_relation_id) ) {
                    clear_row(ri, true);
                }
            }
        } else {
            clear_row(karma_prod_row);
        }
    } else {
        clear_row(karma_prod_row);
    }
    return true;
}

/**
 * Satır no ya göre ürün detay popupunu açar
 * @param {int} satir Satır no
 */
function open_product_popup(viewModel) {
    if (basketManager.hasShownItem("product_name")) {
        let url_str = 'index.cfm?fuseaction=objects.popup_detail_product';
        let stock_id = viewModel.items.stock_id();
        let product_id = viewModel.items.product_id();
        let spect_id = viewModel.items.spect_id();
        let spect_name = viewModel.items.spect_name();
        if (spect_id != undefined && spect_id != '' && spect_name != '') {
            url_str += '&spec_id=' + spect_id;
        }
        if (basketService.wmo_module() == "store") {
            url_str += '&is_store_module=1';
        }
        if (product_id != "" && product_id != 0) {
            openBoxDraggable(url_str + '&pid=' + product_id + '&sid=' + stock_id);
        }
    }
}

/**
 * Ürün fiyat geçmişi popupunu açar
 * @param {object} viewModel viewModel
 */
function open_product_price_history(viewModel) {
    let url_str = "index.cfm?fuseaction=objects.popup_std_sale&price_type=purc";
    let product_id = viewModel.items.product_id();
    if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
        url_str=url_str + '&company_id=' + $("#basket_main_div #company_id").val();
    
    if($("#basket_main_div #branch_id").length != 0 && $("#basket_main_div #branch_id").val().length != 0)
        url_str=url_str + '&branch_id=' + $("#basket_main_div #branch_id").val();
    
    if (product_id != "") {
        openBoxDraggable(url_str + '&pid='+ product_id);
    }
}

/**
 * Satır muhasebe kodunu verir
 * @param {int} satir satır no
 */
function open_basket_acc_code_popup(satir) {
    windowopen('/index.cfm?fuseaction=objects.popup_account_plan&satir='+satir+'', 'list');
}

/**
 * Satır Masraf Markezi 
 * @param {int} satir satır no
 */
function basket_exp_center_popup(satir){
    openBoxDraggable('index.cfm?fuseaction=objects.popup_expense_center&satir='+satir);
}

/**
 * Satır Abone
 * @param {int} satir satır no 
 */

function open_subscription_popup(satir){
    openBoxDraggable('index.cfm?fuseaction=objects.popup_list_subscription&satir='+satir);
}

/**
 * Satır Bütçe Kalemi
 * @param {int} satir satır no
 */
function basket_exp_item_popup(satir){
    openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&satir='+satir);
}

/**
 * Satır Fiziki Varlık
 * @param {int} satir satır no
 */
function open_assetp_popup(satir){
	openBoxDraggable('index.cfm?fuseaction=assetcare.popup_list_assetps&event_id=0&satir='+satir);
}
/**
 * Satır Proje
 * @param {int} satir satır no 
 */
function open_basket_project_popup(satir){
    openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&project_head=&satir='+satir);
}
/**
 * Satır İş
 * @param {int} satir satır no
 */
function open_basket_work_popup(satir){
    openBoxDraggable('index.cfm?fuseaction=objects.popup_add_work&satir='+satir);
 }

 /**
  * Satır Satış temsilcisi 
  * @param {int} satir satır no
  */
 
function open_basket_employee_popup(satir){
    if(basketManager.hasShownItem("basket_employee")){
        var field_basket_emp_name_ = 'basket_employee';
        var field_basket_emp_id_ ='basket_employee_id';
        openBoxDraggable('index.cfm?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id='+field_basket_emp_id_+'&field_name='+field_basket_emp_name_+'&satir='+satir);
    }
}

/**
 * Teslimat Depo Seçimi
 * @param {int} satir satır no 
 */
function open_basket_locations(satir){
    var field_name = 'basket_row_departman';
    var field_id ='deliver_dept';
    openBoxDraggable('index.cfm?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name='+field_name+'&field_id='+field_id+'&row_id='+satir+'&satir='+satir);
}

/**
 * Satır rezerve tarihi
 * @param {string} field_name satır alan
 * @param {int} field_row_ satır no
 */
function get_basket_date_reserve(field_name, field_row_){
	windowopen('/index.cfm?fuseaction=objects.popup_calender&alan='+field_name+'&satir='+field_row_,'date');
  }

/** 
 * Satır teslim tarihi
 * @param {string} field_name satır alan
 * @param {int} field_row_ satır no
 */
function get_basket_date_deliver(field_name,field_row_){
	windowopen('/index.cfm?fuseaction=objects.popup_calender&alan='+field_name+'&satir='+field_row_+'&deliver=1','date');
  }

/**
 * Satır spec şeysi 
 * @param {int} satir satır no 
 */

function open_spec(satir){
    if(basketManager.hasShownItem("spec")){

	  var opener_basket_id = basketService.basket_id();
	  if(!satir) satir = 0;
		  
	  var data = basketManagerObject.basketItems()[satir];
	  var row_id = satir;
	  var field_id = data.spect_id();
	  var money_ = data.other_money();
	  var stock_id = data.stock_id();
	  var product_id = data.product_id();
	  var price_catid_ = data.price_cat();
	  var price_ = data.price();
	  var main_stock_amount = filterNumBasket(data.amount(),4);
	  
  
	  var aranan_tarih="";
	  try{
		  if($("#basket_main_div #search_process_date").val().length != 0)
			  aranan_tarih = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
	  }
	  catch(e)
	  {}
	  if(field_id == ''){
		  url_str = 'index.cfm?fuseaction=objects.popup_configurator&type=add&basket_id='+opener_basket_id;
		  // process_type değişkeni
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  // process_type değişkeni
		  if($("#basket_main_div #company_id").length != 0)
			  url_str = url_str+'&company_id=' + $("#basket_main_div #company_id").val();
		  if($("#basket_main_div #consumer_id").length != 0)
			  url_str = url_str + '&consumer_id=' + $("#basket_main_div #consumer_id").val();
        
            for (let mi = 0; mi < basketService.money_bskt_money_types().length; mi++) {
                 url_str = url_str + "&" + moneyArray[mi] + "=" + rate2Array[mi] / rate1Array[mi];
            }
  
            openBoxDraggable(url_str+'&product_id='+product_id+'&row_id='+row_id+'&stock_id='+stock_id+'&money_='+money_+'&price='+filterNum(price_)+'&price_catid='+price_catid_+'&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount,'','ui-draggable-box-large');
	  }
	  else{
		  url_str = 'index.cfm?fuseaction=objects.popup_configurator&type=upd&basket_id='+opener_basket_id;
		  //lokasyon ve department
		  if($("#basket_main_div #location_id").length != 0)
			  var paper_location = $("#basket_main_div #location_id").val();
		  else
			  var paper_location = '';
		  
		  if($("#basket_main_div #department_id").length != 0)
			  var paper_department = $("#basket_main_div #department_id").val();
		  else if($("#basket_main_div #DEPARTMENT_ID").length != 0)//burda eger stok emirden sipars israsliyeye cekilirken duzenlerseniz kaldıralım
			  var paper_department = $("#basket_main_div #DEPARTMENT_ID").val();
		  else
			  var paper_department = '';
		  // process_type değişkeni --->
		  sepet_process_obj = findObj("process_cat");
		  if(sepet_process_obj != null)
			  url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		  else
			  url_str = url_str + '&sepet_process_type=-1';
		  // process_type değişkeni --->
		  if($("#basket_main_div #company_id").length != 0)
			  url_str = url_str+'&company_id=' + $("#basket_main_div #company_id").val();
		  if($("#basket_main_div #consumer_id").length != 0)
			  url_str = url_str + '&consumer_id=' + $("#basket_main_div #consumer_id").val();
              
            for (let mi = 0; mi < basketService.money_bskt_money_types().length; mi++) {
                url_str = url_str + "&" + moneyArray[mi] + "=" + rate2Array[mi] / rate1Array[mi];
            }

            openBoxDraggable(url_str+'&product_id='+product_id+'&id='+field_id+'&row_id='+row_id+'&money_='+money_+'&price='+filterNum(price_)+'&stock_id='+stock_id+'&price_catid='+price_catid_+'&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount+'&paper_location='+paper_location+'&paper_department='+paper_department,'','ui-draggable-box-large');	
	  }
    }
}

function remove_empty_rows() {
    if (basketManagerObject.basketItems().length > 0) {
        basketManagerObject.basketItems().slice(0).forEach(e => {
            if (e.product_id() == 0) {
                basketManagerObject.basketItems.remove(e);
            }
        });
    }
}

/**
 * Ürün muhasebe kodlarını kontrol eder
 */
function check_product_accounts()
{
    remove_empty_rows();
	var prod_list ='';
	if(isDefined('product_id'))
		{
			if(document.form_basket.product_id.length != undefined && document.form_basket.product_id.length >1)
			{
				var bsk_rowCount = document.form_basket.product_id.length;
				var acc_control_prod_id_ = eval('document.form_basket.product_id');
				for(var prd_ii=0; prd_ii<bsk_rowCount; prd_ii++)
				{
					if(acc_control_prod_id_[prd_ii].value!= '' && list_find(prod_list,acc_control_prod_id_[prd_ii].value,',')==0)
					{
					if(list_len(prod_list)==0)
						prod_list=acc_control_prod_id_[prd_ii].value;
					else
						prod_list= prod_list+','+acc_control_prod_id_[prd_ii].value;
					}		
				}
			}
			else if(document.form_basket.product_id[0]!=undefined && document.form_basket.product_id[0].value!=undefined)
			{
				prod_list=document.form_basket.product_id[0].value;
			}
			else
			{
				prod_list=document.form_basket.product_id.value;
			}
		}
	if (process_cat_array[form_basket.process_cat.selectedIndex] == 1 && process_cat_project_based_acc[form_basket.process_cat.selectedIndex] == 0 && process_cat_dept_based_acc[form_basket.process_cat.selectedIndex] == 0) //muhasebe islemi yapılıyor ve proje bazlı muhasebe secili degil ve depo bazlı muhasebe seçili değil
	{
		if(list_len(prod_list))
		{
			if(document.form_basket.location_id != undefined && document.form_basket.department_id.value.length && document.form_basket.department_id != undefined && document.form_basket.location_id.value.length ) 
			{
				var listParam = document.form_basket.department_id.value + "*" + document.form_basket.location_id.value;
				var LOCATION = wrk_safe_query('obj_control_department_location','dsn',0,listParam);	
				location_type_ = LOCATION.LOCATION_TYPE;
				is_scrap_ = LOCATION.IS_SCRAP;
			}
			else
			{
				location_type_ ='';
				is_scrap_ =0;
			}
						
			var new_prod_sql = 'obj_control_basket_prod_acc'
			if(list_find("54,55",process_type_array[form_basket.process_cat.selectedIndex]))
				var new_prod_sql = 'obj_control_basket_prod_acc_2'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 58)
				var new_prod_sql = 'obj_control_basket_prod_acc_3'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 63)
				var new_prod_sql = 'obj_control_basket_prod_acc_4'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 62)
				var new_prod_sql = 'obj_control_basket_prod_acc_5'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 531)
				var new_prod_sql = 'obj_control_basket_prod_acc_6'
			else if(process_type_array[form_basket.process_cat.selectedIndex] == 591)
				var new_prod_sql = 'obj_control_basket_prod_acc_7'
			else if(sale_product!=undefined && sale_product==1)
			{
				if(is_scrap_ == 1)//hurda
					var new_prod_sql = 'obj_control_basket_prod_acc_10'	
				else if (location_type_ == 1) //hammadde lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_11'
				else if (location_type_ == 3)//mamul lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_12'
				else
					var new_prod_sql = 'obj_control_basket_prod_acc_8'
			}
			else
			{
				if (location_type_ == 1) //hammadde lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_13'
				else if (location_type_ == 3)//mamul lokasyonu secilmisse
					var new_prod_sql = 'obj_control_basket_prod_acc_14'
				else
					var new_prod_sql = 'obj_control_basket_prod_acc_9'
			}
			
			var control_basket_prod_acc = wrk_safe_query(new_prod_sql,'dsn3',0,prod_list);
			if(control_basket_prod_acc.recordcount)
			{
				alert_str = '<cf_get_lang dictionary_id="58483.Muhasebe Kodu Tanımlanmamış Ürünler">:\n'
				//alert_str = 'Muhasebe Kodu Tanımlanmamış Ürünler:\n'
				for(var cnt_i=0;cnt_i<control_basket_prod_acc.recordcount;cnt_i=cnt_i+1)
					alert_str = alert_str +' '+control_basket_prod_acc.PRODUCT_NAME[cnt_i] + '\n';
				alert(alert_str);
				return false;
			}
		}
	}
	return true;
}

//events

/**
 * Alt toplam işlemleri
 * @param {float} from_sa_amount tutar
 * @param {int} from_new_row satır no
 * @param {bool|int|null} is_from_upd bu değişken kullanılmamaktadır, güncelleme mi diye kontrol ediyor ancak from new row a bakılıyor
 */
var toplam_hesapla = function( from_sa_amount, from_new_row, is_from_upd ) {
    var toplam = 0;
    var indirim = 0;
    var vergi = 0;
    var otv_vergisi = 0;
    var net = 0;
    var re_toplam_hesapla = 0;
    var prom_display = '<span style="color: #ff0000">Promosyon!</span>';
    var taxArray = [];
    var taxTotalArray = [];
    var otvTotalArray = [];
    var rate_flag = false;
    var commission_row = 0;
    var oivTotal = 0.0;
    var bsmvTotal = 0.0;
    var otvArray = [];
    var otvDiscountTotal = 0.0;

    var toplam_hesapla_in = function(is_take_commission, new_row) {
        toplam = 0;
        vergi = 0;
        otv_vergisi = 0;
        net = 0;
        var tax_flag = false;
        var otv_flag = false;
        taxArray = [];
        taxTotalArray = [];
        var unitArray = [];
        var unitTotalArray = [];
        otvArray = [];
        otvTotalArray = [];

        if (basketManagerObject.basketItems().length > 1) {
            if (new_row !== undefined && new_row != '') {
                let line_data = basketManagerObject.basketItems()[new_row];
                toplam = basketManagerObject.basketItems().reduce(function(acc, val) { return acc + val.row_total() }, 0.0);
                net = basketManagerObject.basketItems().reduce(function(acc, val) { return acc + val.row_nettotal() }, 0.0);
                if (is_take_commission) {
                    toplam = toplam + line_data.row_total();
                    net = net + line_data.row_nettotal();

                    if (basketManagerObject.basketFooter.general_taxs().length > 0) {
                        let taxLen = basketManagerObject.basketFooter.general_taxs().length;
                        for (let ti = 0; ti < taxLen; ti++) {
                            taxArray[ti] = basketManagerObject.basketFooter.general_taxs()[ti];
                            if (taxArray[ti] == line_data.tax_percent()) {
                                tax_flag = true;
                                taxTotalArray[ti] = wrk_round( basketService.get("generaltaxArrayTotal")[ti], basketService.basketTotalRoundNumber() ) + line_data.row_taxtotal();
                            } else {
                                taxTotalArray[ti] = basketService.get("generaltaxArrayTotal")[ti];
                            }
                        }
                    } else {
                        if (basketService.sepetTaxArray() !== undefined && basketService.sepetTaxArray() !== null) {
                            for (let si = 0; si < basketService.sepetTaxArray().length; si++) {
                                taxArray.push( basketService.sepetTaxArray()[si][0] );
                                if (basketService.sepetTaxArray()[si][0] == line_data.tax()) {
                                    tax_flag = true;
                                    taxTotalArray[taxArray.length-1] = wrk_round( basketService.sepetTaxArray()[si][1], basketService.priceRoundNumber() ) + line_data.row_taxtotal();
                                }
                            }
                        } 
                    }

                    if (!tax_flag) {
                        taxArray.push( line_data.tax() );
                        taxTotalArray.push( line_data.row_taxtotal() );
                    }

                    if (basketService.get("generalotvArray").length > 0) {
                        let gnotvArrayLen = basketService.get("generalotvArray").length;
                        for (let gi = 0; gi < gnotvArrayLen; gi++) {
                            otvArray[gi] = basketService.get("generalotvArray")[gi];
                            if( basketService.get("otv_calc_type") == '' ){
                                if (otvArray[gi] == line_data.otv_oran()) {
                                    otv_flag = true;
                                    otvTotalArray[gi] = wrk_round( basketService.get("generalotvArray")[gi], basketService.basketTotalRoundNumber() ) + line_data.row_otvtotal();
                                } else {
                                    otvTotalArray[gi] = basketService.get("generalotvArrayTotal")[gi];
                                }
                            }else{
                                if (otvArray[gi] == line_data.other_money()) {
                                    otv_flag = true;
                                    otvTotalArray[gi] = wrk_round( basketService.get("generalotvArray")[gi], basketService.basketTotalRoundNumber() ) + line_data.row_otvtotal();
                                } else {
                                    otvTotalArray[gi] = basketService.get("generalotvArrayTotal")[gi];
                                }
                            }
                        }
                    } else {
                        otvArray.push(0);
                        otvTotalArray.push(0);
                        if (otvArray[otvArray.length-1] == line_data.row_otvtotal()) {
                            otv_flag = true;
                            otvTotalArray[otvArray.length-1] = wrk_round( otvTotalArray[otvArray.length-1], basketService.basketTotalRoundNumber() ) + line_data.row_otvtotal();
                        }
                    }

                    if ( !otv_flag ) {
                        if( basketService.get("otv_calc_type") == '' ){
                            otvArray.push(line_data.otv_oran());
                        }else{
                            otvArray.push(line_data.other_money());
                        }
                        otvTotalArray.push(line_data.row_otvtotal());
                    }

                }

            } else {

                for (let ci = 0; ci < basketManagerObject.basketItems().length; ci++) {
                    let cirow = basketManagerObject.basketItems()[ci];
                    let taxLine = 0;

                    if (cirow.is_commission() == 1) {
                        commission_row = ci;
                    }
                    if (cirow.is_commission() != 1 || is_take_commission) {
                        toplam += cirow.row_total();
                        net += cirow.row_nettotal();
                        tax_flag = false;
                        taxLine = cirow.tax();
                    }
                    if (taxArray.length > 0) {
                        let taxArrayLen = taxArray.length;
                        for (let m = 0; m < taxArrayLen; m++) {
                            if (taxArray[m] == taxLine) {
                                tax_flag = true;
                                taxTotalArray[m] += cirow.row_taxtotal();
                                break;
                            }
                        }
                    }
                    if (!tax_flag) {
                        taxArray.push(taxLine);
                        taxTotalArray.push(cirow.row_taxtotal());
                    }

                    otv_flag = false;
                    if (otvArray.length != 0) {
                        let otvArrayLen = otvArray.length;
                        for (let oi = 0; oi < otvArrayLen; oi++) {
                            if( basketService.get("otv_calc_type") == '' ){
                                if (otvArray[oi] == cirow.otv()) {
                                    otv_flag = true;
                                    otvTotalArray[oi] += cirow.row_otvtotal();
                                    break;
                                }
                            }else{
                                if (otvArray[oi] == cirow.other_money()) {
                                    otv_flag = true;
                                    otvTotalArray[oi] += cirow.row_otvtotal();
                                    break;
                                }
                            }
                        }
                    }

                    if (!otv_flag) {
                        if( basketService.get("otv_calc_type") == '' ) otvArray[otvArray.length] = cirow.otv();
                        else otvArray[otvArray.length] = cirow.other_money();
                        otvTotalArray[otvTotalArray.length] = cirow.row_otvtotal();
                    }
                }
            }

        } else if (basketManagerObject.basketItems().length == 1) {

            let srow = basketManagerObject.basketItems()[0];
            toplam = srow.row_total();
            net = srow.row_nettotal();
            taxArray[0] = srow.tax_percent();
            taxTotalArray[0] = srow.row_taxtotal();

            if (srow.row_otvtotal() && srow.otv_oran()) {
                if ( isNaN(srow.otv_oran()) ) {
                    otvArray[0] = 0;
                } else {
                    if( basketService.get("otv_calc_type") == '' ) otvArray[0] = srow.otv_oran();
                    else otvArray[0] = srow.other_money();
                }

                if ( isNaN(srow.row_otvtotal()) ) {
                    otvTotalArray[0] = 0;
                } else {
                    otvTotalArray[0] = srow.row_otvtotal();
                }
            }
        }

        

        let taxLen = taxArray.length;
        if (taxLen > 0) {
            if (from_new_row == undefined || (from_new_row !== undefined && from_new_row == '')) {
                basketService.set("generalTaxArray", []);
                basketService.set("generaltaxArrayTotal", []);
            }

            for (let m = 0; m < taxLen; m++) {
                basketService.get("generalTaxArray")[m] = taxArray[m];
                basketService.get("generaltaxArrayTotal")[m] = taxTotalArray[m];
                vergi += wrk_round( taxTotalArray[m], basketService.priceRoundNumber() );
            }
            basketManager.setBasketFooterItem("general_taxs", basketService.get("generalTaxArray").map((m,i) => { return { rate: m, total: taxTotalArray[i] }; } ));
        }
    
        let otvlen = otvArray.length;
        if (otvlen != 0) {
            if (from_new_row === undefined || ( from_new_row !== undefined && from_new_row == '' )) {
                basketService.set("generalotvArray", []);
                basketService.set("generalotvArrayTotal", []);
            }
            for (let oi = 0; oi < otvlen; oi++) {
                if (otvTotalArray[oi] == undefined || isNaN(otvTotalArray[oi])) {
                    otvTotalArray[oi] = 0;
                }
                basketService.get("generalotvArray")[oi] = otvArray[oi];
                basketService.get("generalotvArrayTotal")[oi] = otvTotalArray[oi];
                otv_vergisi += otvTotalArray[oi]; 
            }
        }
                

        let totalAmount = new Array();
        let totalUnits = new Array();
        let totalBsmvAmount = new Array();
        let totalBsmv = new Array();
        let totalOivAmount = new Array();
        let totalOiv = new Array();
        let totalTevkifatAmount = new Array();
        let totalTevkifat = new Array();

        basketManagerObject.basketFooter.is_tevkifat(false);
        basketManagerObject.basketItems().forEach(elm => {
            if  (
                basketManager.hasShownItem("row_oiv_rate") && basketManager.hasShownItem("row_oiv_amount")
                ) {
                if ( elm.row_oiv_rate() > 0 ) {
                    if ( totalOivAmount.length > 0 ) {
                        if ( totalOiv.indexOf( elm.row_oiv_rate() ) == -1 ) {
                            totalOivAmount.push( { rate: elm.row_oiv_rate(), amount: parseFloat( elm.row_oiv_amount().toString() ) } );
                            totalOiv.push( elm.row_oiv_rate() );
                        } else {
                            totalOivAmount[ totalOiv.indexOf( elm.row_oiv_rate() ) ].amount += elm.row_oiv_amount();
                        }
                    } else {
                        totalOivAmount.push( { rate: elm.row_oiv_rate(), amount: parseFloat( elm.row_oiv_amount().toString() ) } );
                    }
                }
                oivTotal += parseFloat( elm.row_oiv_amount().toString() );
            }
            if( basketManager.hasShownItem("otv_type") && basketManager.hasShownItem("otv_discount") ){
                if ( elm.otv_type() > 0 ) {
                    otvDiscountTotal += parseFloat( elm.row_otvtotal() );
                }else{
                    otvDiscountTotal += 0;
                }   
            }

            if ( elm.row_bsmv_rate() > 0 ) {
                if ( totalBsmvAmount.length > 0 ) {
                    if ( totalBsmv.indexOf( elm.row_bsmv_rate() ) == -1 ) {
                        totalBsmvAmount.push( { rate: elm.row_bsmv_rate(), amount: parseFloat( elm.row_bsmv_amount().toString() ) } );
                        totalBsmv.push( elm.row_bsmv_rate() );
                    } else {
                        totalBsmvAmount[ totalBsmv.indexOf( elm.row_bsmv_rate() ) ].amount += elm.row_bsmv_amount();
                    }
                } else {
                    totalBsmvAmount.push( { rate: elm.row_bsmv_rate(), amount: parseFloat( elm.row_bsmv_amount().toString() ) } );
                    totalBsmv.push( elm.row_bsmv_amount() );
                }
            }
            bsmvTotal += elm.row_bsmv_amount();

            if ( elm.row_tevkifat_rate() > 0 ) {
                if ( totalTevkifatAmount.length > 0 ) {
                    if ( totalTevkifat.indexOf( elm.row_tevkifat_rate() ) == -1 ) {
                        totalTevkifatAmount.push( { rate: elm.row_tevkifat_rate(), amount: parseFloat( elm.row_tevkifat_amount().toString() ) } );
                        totalTevkifat.push( elm.row_tevkifat_rate() );
                    } else {
                        totalTevkifatAmount[ totalTevkifat.indexOf( elm.row_tevkifat_rate() ) ].amount += elm.row_tevkifat_amount();
                    }
                } else {
                    totalTevkifatAmount.push( { rate: elm.row_tevkifat_rate(), amount: parseFloat( elm.row_tevkifat_amount().toString() ) } );
                    totalTevkifat.push( elm.row_tevkifat_rate() );
                }
                basketManagerObject.basketFooter.is_tevkifat( true );
            }

            if ( totalAmount.length > 0 ) {
                if ( totalUnits.indexOf( elm.unit() ) == -1 ) {
                    totalAmount.push( { unit: elm.unit(), amount: parseFloat( elm.amount().toString() ) } );
                    totalUnits.push( elm.unit() );
                } else {
                    totalAmount[totalUnits.indexOf( elm.unit() )].amount += parseFloat( elm.amount().toString() );
                } 
            } else {
                    totalAmount.push( { unit: elm.unit(), amount: parseFloat( elm.amount().toString() ) } );
                    totalUnits.push( elm.unit() );
                }
            }
        );

        basketManager.setBasketFooterItem( "totalAmount", totalAmount );

        if (basketManager.hasShownItem("row_oiv_rate")) {
            basketManager.setBasketFooterItem( "totalOivAmount", totalOivAmount );
        }

        if (basketManager.hasShownItem("row_bsmv_rate")) {
            basketManager.setBasketFooterItem( "totalBsmvAmount", totalBsmvAmount );
        }
        if ( basketManager.hasShownItem("otv_type") && basketManager.hasShownItem("otv_discount") ) {
            basketManager.setBasketFooterItem( "TotalOtvDiscount", commaSplit( otvDiscountTotal, basketService.basketTotalRoundNumber()) );
        }
        
        basketManager.setBasketFooterItem( "total_oiv_default", wrk_round( oivTotal, basketService.basketTotalRoundNumber() ) );
        basketManager.setBasketFooterItem( "total_oiv", wrk_round( oivTotal, basketService.basketTotalRoundNumber() ) );
        basketManager.setBasketFooterItem( "total_bsmv_default", wrk_round( bsmvTotal, basketService.basketTotalRoundNumber() ) );
        basketManager.setBasketFooterItem( "total_bsmv", wrk_round( bsmvTotal, basketService.basketTotalRoundNumber() ) );

        indirim = toplam - net;
    }

    if (from_new_row != undefined && from_new_row != '') {
        toplam_hesapla_in(0, from_new_row);
    } else {
        toplam_hesapla_in(0);
    }

    if (basketService.wmo_module() == 'invoice' || [1,2,3,4,5,10,14,15,20,21,33,38,42,43,46,51,52].indexOf(basketService.basket_id()) >= 0 ) {
        if ( basketService.get("display_list").indexOf('is_promotion') >= 0 ) {
            var toplam_hesapla_prom = function(from_sa_amount) {
                let rowcount = basketManagerObject.basketItems().length;
                let old_general_prom_discount = basketManagerObject.basketFooter.old_general_prom_amount();
                let old_general_indirim = basketManagerObject.basketFooter.genel_indirim();

                if (from_sa_amount === undefined || from_sa_amount === null) {
                    
                    if (basketManagerObject.basketFooter.is_general_prom()) {
                        var general_prom_limit = wrk_round( basketManagerObject.basketFooter.general_prom_limit(), basketService.priceRoundNumber() );
                        if (net >= general_prom_limit) {
                            basketManager.setBasketFooterItem("general_prom_limit", wrk_round( net * basketManagerObject.basketFooter.general_prom_discount() / 100, basketService.basketTotalRoundNumber() ) );

                            let new_genel_indirim = 0;
                            if ( basketManagerObject.basketFooter.general_prom_amount() > 0 ) {
                                new_genel_indirim = ( parseFloat( old_general_indirim.toString(), basketService.basketTotalRoundNumber() ) - parseFloat( old_general_prom_discount, basketService.basketTotalRoundNumber() ) + parseFloat( basketManagerObject.basketFooter.general_prom_amount().toString(), basketService.basketTotalRoundNumber() ) );
                            } else {
                                new_genel_indirim = ( parseFloat( old_general_indirim.toString(), basketService.basketTotalRoundNumber() ) - parseFloat( old_general_prom_discount.toString(), basketService.basketTotalRoundNumber() ) );
                            }
                            basketManager.setBasketFooterItem("genel_indirim", wrk_round( new_genel_indirim,  basketService.basketTotalRoundNumber() ) );
                        } else {
                            basketManager.setBasketFooterItem( "general_prom_amount", wrk_round(0));
                            basketManager.setBasketFooterItem( wrk_round((old_general_indirim - old_general_prom_discount), basketService.basketTotalRoundNumber()) );
                        }

                        let free_prom_limit = basketManagerObject.basketFooter.free_prom_limit();
                        let free_prom_found = 0;
                        
                        if ( basketManagerObject.basketFooter.free_prom_stock_id() > 0) {
                            let v = basketManagerObject.basketFooter.free_prom_stock_id();
                            for (let vi = 0; vi < rowcount; vi++) {
                                if ( basketManagerObject.basketItems()[vi].is_promotion() && basketManagerObject.basketFooter.free_prom_stock_id() > 0 && basketManagerObject.basketItems()[vi].stock_id == v ) {
                                    free_prom_found = vi;
                                }
                            }

                            if ( net >= free_prom_limit && basketManagerObject.basketFooter.free_prom_stock_id() > 0 ) {
                                //let free_price = null;
                                if (free_prom_found == 0) {
                                    add_free_prom( basketManagerObject.basketFooter.free_prom_stock_id(), basketManagerObject.basketFooter.free_prom_stock_id(),  )
                                    re_toplam_hesapla = 1;
                                }
                            } else if (free_prom_found > 0) {
                                basketManagerObject.basketItems.slice(free_prom_found, 1);
                                re_toplam_hesapla = 1;
                            }

                            let prom_list = [];
                            for (let ci = 0; ci < rowcount; ci++) {
                                if (basketManagerObject.basketItems()[ci].is_promotion() != 0) {
                                    prom_list.push( { amount: basketManagerObject.basketItems()[ci].amount(), unit: basketManagerObject.basketItems()[ci].unit(), product: basketManagerObject.basketItems()[ci].product_name() } );
                                }
                            }
                            basketManager.setBasketFooterItem("prom_list", prom_list);
                        }
                    }
                } else {
                    basketManagerObject.basketFooter.prom_items_discount([]);
                    basketManagerObject.basketFooter.genel_indirim( old_general_indirim - old_general_prom_discount );
                    
                    if (basketManagerObject.basketFooter.free_prom_stock_id() > 0) {
                        for (let ci = 0; ci < rowcount; ci++) {
                            if (!!basketService.get("changeable_value")['is_promotion'][ci] && basketService.get("changeable_value")['prom_stock_id'][ci].length == 0 && basketManagerObject.basketItems()[ci].prom_id() == basketManagerObject.basketFooter.free_prom_stock_id()) {
                                basketManagerObject.basketItems.splice(ci, 1);
                                re_toplam_hesapla = 1;
                            }
                        }
                    }
                    basketManager.setBasketFooterItem("prom_list", []);
                }
            }
            toplam_hesapla_prom(from_sa_amount);
        }
        if ( basketManagerObject.basketFooter.commission_rate() > 0 ) {
            toplam_hesapla_in(0);
            if (from_new_row !== undefined && from_new_row != '') {
                if (rowcount > 1) {
                    for (let ci = 1; ci <= rowcount; ci++) {
                        if (basketManagerObject.basketItems()[ci-1].is_commission() == 1) {
                            commission_row = ci;
                        }
                    }
                }
            }

            let not_com_total = 0;
            for (let ci = 0; ci <= rowcount; ci++) {
                if (basketManagerObject.basketItems()[ci].is_commission() == 0) {
                    let get_prod_control = wrk_safe_query( 'obj_get_prod_control', 'dsn3', 0, basketManagerObject.basketItems()[ci].product_id() );
                    if (get_prod_control.COM_CONTROL == 0) {
                        not_com_total = parseFloat(not_com_total + filterNum( basketManagerObject.basketItems()[ci].row_lasttotal(), basketService.priceRoundNumber() ));
                    }
                }
            }

            let new_com_total = wrk_round( parseFloat( net + vergi + otv_vergisi - not_com_total), basketService.priceRoundNumber() );
            let commission_price = wrk_round( new_com_total * basketManagerObject.basketFooter.commission_rate() / 100, basketService.priceRoundNumber() );
            if (commission_price > 0) {
                if (commission_row > 0) {
                    add_commission_row(commission_price, 1, commission_row);
                } else {
                    add_commission_row(commission_price);
                }
            } else {
                if (commission_row) {
                    basketManagerObject.basketItems.splice(commission_row, 1);
                }
            }
            re_toplam_hesapla = 1;
        } else if (commission_row) {
            basketManagerObject.basketItems.splice(commission_row, 1);
            re_toplam_hesapla = 1;
        }
        if (re_toplam_hesapla !== undefined && re_toplam_hesapla == 1) {
            toplam_hesapla_in(1);
        }

        let sa_percent = 0;
        let sa_amount = basketManagerObject.basketFooter.genel_indirim();

        if (toplam) {
            if ( basketManagerObject.basketFooter.genel_indirim() > 0 && sa_amount > 0 && net >= sa_amount ) {
                sa_percent = ( sa_amount / net ) * 100;
                vergi = wrk_round( vergi * (100 - sa_percent) / 100, basketService.basketTotalRoundNumber() );
                otv_vergisi = wrk_round( otv_vergisi * (100 - sa_percent) / 100, basketService.basketTotalRoundNumber() );
                indirim = indirim + sa_amount;
                basketManager.setBasketFooterItem("genel_indirim", wrk_round( sa_amount, basketService.basketTotalRoundNumber() ));
                net = net - sa_amount;
                for (let mm = 0; mm < taxArray.length; mm++) {
                    taxTotalArray[mm] = wrk_round(taxTotalArray[mm] * (100 - sa_percent) / 100, basketService.basketTotalRoundNumber());
                }
                for (let zz = 0; zz < otvArray.length; zz++) {
                    otvTotalArray[zz] = wrk_round(otvTotalArray[zz] * (100 - sa_percent) / 100, basketService.basketTotalRoundNumber());                          
                }
            } else {
                basketManager.setBasketFooterItem("genel_indirim", 0);
            }
        } else {
            basketManager.setBasketFooterItem("genel_indirim", 0);
        }
    }

    basketManager.setBasketFooterItem("general_otv", otvArray.map((v,i) => { return { rate: v, total: otvTotalArray[i] }; }));
    basketManager.setBasketFooterItem("general_taxs", taxArray.map((m,i) => { return { rate: m, total: taxTotalArray[i] }; } ));

    if (basketService.wmo_module() == 'invoice' && [1,2,18,20,33,42,43].indexOf(basketService.basket_id()) >= 0) {
        if ( basketManagerObject.basketFooter.is_tevkifat() ) {
            let tev_kdv_list = [];
            let bey_kdv_list = [];
            var vergi = 0;
            basketManagerObject.basketItems().forEach(e => {
                var bline = ko.toJS(e);
                if ( basketManagerObject.basketFooter.is_tevkifat() && bline.row_tevkifat_rate >= 0 && bline.row_tevkifat_rate <= 100 ) {
                    bey_kdv = wrk_round(bline.row_tevkifat_amount, basketService.basketTotalRoundNumber());
                    let tev_kdv_filtered = tev_kdv_list.filter(mexp => mexp.rate == bline.tax);
                    
                    if (tev_kdv_filtered.length > 0) {
                        tev_kdv_filtered[0].total = wrk_round(tev_kdv_filtered[0].total - bey_kdv, basketService.basketTotalRoundNumber());
                    } else {
                        tev_kdv_list.push({ rate: bline.tax, total: wrk_round(taxTotalArray[taxArray.indexOf(bline.tax)] - bey_kdv, basketService.basketTotalRoundNumber()) });
                    }
                   
                    let bey_kdv_filtered = bey_kdv_list.filter(mexp => mexp.rate == bline.tax);
                    if (bey_kdv_filtered.length > 0) {
                        bey_kdv_filtered[0].total += wrk_round(bey_kdv, basketService.basketTotalRoundNumber());
                    } else {
                        bey_kdv_list.push({ rate: bline.tax, total: wrk_round(bey_kdv, basketService.basketTotalRoundNumber()) });
                    }
                    vergi += wrk_round(bline.row_tevkifat_amount, basketService.basketTotalRoundNumber());
                }
                
            });
            //vergi = taxTotalArray.reduce((acc, elm) => acc + elm, 0);
            basketManager.setBasketFooterItem("tev_kdv_list", tev_kdv_list);
            basketManager.setBasketFooterItem("bey_kdv_list", bey_kdv_list);
            basketService.set("generalTaxArray", taxArray);
            basketService.set("generaltaxArrayTotal", taxTotalArray);
            basketManager.setBasketFooterItem("general_taxs", taxArray.map((m,i) => { return { rate: m, total: taxTotalArray[i] }; } ));
        }
        
    }
            
    let stopaj = 0;
    if (['form_copy_bill','form_add_bill','detail_invoice_sale','add_sale_invoice_from_order','form_add_bill_from_ship','form_add_bill_other','detail_invoice_other','form_add_bill_purchase','detail_invoice_purchase','form_copy_bill_purchase','add_purchase_invoice_from_order'].indexOf(basketService.wmo_action()) >= 0) {
        let stopaj_yuzde = parseFloat( basketManagerObject.basketFooter.stopaj_yuzde() );
        if ( (stopaj_yuzde < 0) || (stopaj_yuzde > 99.99) ) {
            alert('Stopaj oranı !');
            stopaj_yuzde = 0;
        }
        stopaj = wrk_round( net * stopaj_yuzde / 100, basketService.basketTotalRoundNumber() );
        basketManager.setBasketFooterItem("stopaj_yuzde", stopaj_yuzde);
        basketManager.setBasketFooterItem("stopaj", wrk_round( stopaj, basketService.basketTotalRoundNumber() ));
    }
    vergi = wrk_round( vergi, basketService.basketTotalRoundNumber() );
    net += vergi;
    net += otv_vergisi;
    net += oivTotal;
    net += bsmvTotal;
    net -= stopaj;
    net -= otvDiscountTotal;
    
    basketManager.setBasketFooterItem( "basket_gross_total", wrk_round( toplam, basketService.basketTotalRoundNumber() ) );
    basketManager.setBasketFooterItem( "basket_discount_total", wrk_round( indirim, basketService.basketTotalRoundNumber() ) );
    basketManager.setBasketFooterItem( "basket_tax_total", wrk_round( vergi, basketService.basketTotalRoundNumber() ) );
    basketManager.setBasketFooterItem( "basket_otv_total", wrk_round( otv_vergisi, basketService.basketTotalRoundNumber() ) );
    basketManager.setBasketFooterItem( "basket_net_total", wrk_round( net, basketService.basketTotalRoundNumber() ) )


    for (let mi = 0; mi < basketService.money_bskt_money_types().length; mi++) {
        const m = basketService.money_bskt_money_types()[mi];
        if ( basketManagerObject.basketFooter.basketCurrencyType() != '' && ( basketManagerObject.basketFooter.basketCurrencyType() == m || (typeof default_basket_money !== 'undefined' && default_basket_money == m)) ) {
            rate_flag = true;
            rate1 = rate1Array[mi];
            rate2 = rate2Array[mi];
            money = moneyArray[mi];
        }
    }

    if ( !rate_flag ) {
        rate1 = 1;
        rate2 = 1;
        money = basketService.get("base_money");
    }

    basketManager.setBasketFooterItem("basket_rate1", rate1);
    basketManager.setBasketFooterItem("basket_rate2", rate2);
    basketManager.setBasketFooterItem("basket_money", money);

    let oivTotalCurrency = 0;
    let bsmvTotalCurrency = 0;

    if ( rate2 > 0 ) {
        toplam = wrk_round( toplam * rate1/rate2, basketService.basketTotalRoundNumber() );
        indirim = wrk_round( indirim * rate1/rate2, basketService.basketTotalRoundNumber() );
        vergi = wrk_round( vergi * rate1/rate2, basketService.basketTotalRoundNumber() );
        otv_vergisi = wrk_round( otv_vergisi * rate1/rate2, basketService.basketTotalRoundNumber() );
        oivTotalCurrency = wrk_round( oivTotal * rate1/rate2, basketService.basketTotalRoundNumber() );
        bsmvTotalCurrency = wrk_round( bsmvTotal * rate1/rate2, basketService.basketTotalRoundNumber() );

        if (['form_copy_bill','form_add_bill','detail_invoice_sale','add_sale_invoice_from_order','form_add_bill_from_ship','form_add_bill_other','detail_invoice_other','form_add_bill_purchase','detail_invoice_purchase','form_copy_bill_purchase','add_purchase_invoice_from_order'].indexOf(basketService.wmo_action()) >= 0) {
            net = wrk_round( (net - stopaj) * rate1/rate2, basketService.basketTotalRoundNumber() );
        } else {
            net = wrk_round( net * rate1/rate2, basketService.basketTotalRoundNumber() );
        }
    } else {
        toplam = 0;
        indirim = 0;
        vergi = 0,
        otv_vergisi = 0;
        oivTotalCurrency = 0;
        bsmvTotalCurrency = 0;
        net = 0;
    }

    basketManager.setBasketFooterItem("total_wanted", toplam);
    basketManager.setBasketFooterItem("total_tax_wanted", vergi);
    basketManager.setBasketFooterItem("total_otv_wanted", otv_vergisi);
    basketManager.setBasketFooterItem("total_oiv_wanted", oivTotalCurrency);
    basketManager.setBasketFooterItem("total_bsmv_wanted", bsmvTotalCurrency);
    basketManager.setBasketFooterItem("total_discount_wanted", indirim);
    basketManager.setBasketFooterItem("net_total_wanted", net);

    //++ kdv liste
    //++ otv liste

    if ([1,2,20,42,43].indexOf(basketService.basket_id()) >= 0) {
        let basket_yuvarlama = basketManagerObject.basketFooter.yuvarlama();
        
        if ( basketManagerObject.basketFooter.basket_net_total() > 0 ) {
            let flt_value = wrk_round( basketManagerObject.basketFooter.basket_net_total() - stopaj, basketService.basketTotalRoundNumber() );
            basket_yuvarlama = filterNum(basket_yuvarlama, basketService.basketTotalRoundNumber());
            flt_value += basket_yuvarlama;
            basketManager.setBasketFooterItem( "basket_net_total", flt_value );
            
        } else {
            basketManager.setBasketFooterItem("yuvarlama", 0);
        }
    }

    if (basketManager.hasShownItem("duedate")) {
        set_paper_duedate()
    }

    if (basketService.basket_id() == 51 && ( basketService.get("is_kontrol_from_update") == false || ( basketService.get("is_kontrol_from_update") == true && basketService.get("kontrol_from_update") == 0 ) )) {
        //++ add_voucher_row()
    }

    if (basketService.basket_id() == 52) {
        toplam_tahsilat()
    }

    if ( basketService.get("display_list").indexOf('is_risc') >= 0 ) {
        // bu fonksiyon v2 için default.js tarafına taşınacak..iA
        //toplam_limit_hesapla()
    }

    if (basketService.get("is_retail")) {
        if ( typeof(genel_kontrol) != 'undefined' ) {
            genel_kontrol()
        }
    }

    /* if (from_sa_amount == 0) {
        kdvsiz_doviz_indirim_hesapla();
        kdvli_doviz_indirim_hesapla();
    } */

    let dusulecek_vergi_default = basketManagerObject.basketFooter.basket_tax_total();
    let dusulecek_vergi_wanted = basketManagerObject.basketFooter.total_tax_wanted();
    let brut_basket_toplam_default = basketManagerObject.basketFooter.basket_net_total();
    let brut_basket_toplam_wanted = basketManagerObject.basketFooter.net_total_wanted();
    if (basketManager.hasShownItem("otv")) {
        dusulecek_vergi_default += basketManagerObject.basketFooter.basket_otv_total();
        dusulecek_vergi_wanted += basketManagerObject.basketFooter.total_otv_wanted();
    }
    //if (basketManager.hasShownItem("oiv")) {
    if (basketManager.hasShownItem("row_oiv_rate")) {
        dusulecek_vergi_default += basketManagerObject.basketFooter.total_oiv_default();
        dusulecek_vergi_wanted += basketManagerObject.basketFooter.total_oiv_wanted();
    }
    if (basketManager.hasShownItem("bsmv")) {
        dusulecek_vergi_default += basketManagerObject.basketFooter.total_bsmv_default();
        dusulecek_vergi_wanted += basketManagerObject.basketFooter.total_bsmv_wanted();
    }

    brut_basket_toplam_default = brut_basket_toplam_default - dusulecek_vergi_default;
    brut_basket_toplam_wanted = brut_basket_toplam_wanted - dusulecek_vergi_wanted;

    basketManager.setBasketFooterItem("brut_total_default", wrk_round(brut_basket_toplam_default, basketService.basketTotalRoundNumber()));
    basketManager.setBasketFooterItem("brut_total_wanted", wrk_round(brut_basket_toplam_wanted, basketService.basketTotalRoundNumber()));

    return true;

};

basketService.setBasketSummaryCalculator( toplam_hesapla );

/**
 * Satırın verilerini hesaplar
 * @param {string} fieldName değişen elemanın adı
 * @param {object} viewModel satıra ait obje
 * @param {float|null} satir_kdv_tutar satır kdv tutarı (manuel belirilen durumlarda)
 */
var satir_hesapla = function( fieldName, viewModel, satir_kdv_tutar ) {
    
    if (typeof(viewModel) != undefined && viewModel >= 0) {
        viewModel = basketManagerObject.basketItems()[viewModel];
    }
  
    let basketRow = ko.mapping.toJS(viewModel);
    let rates = basketService.getRates(viewModel);
    let tmp_price = basketRow.price;
    
    if(basketRow.row_width != undefined && basketRow.row_height != undefined && basketRow.row_depth != undefined && basketRow.row_specific_weight != 0 && basketRow.row_volume != undefined && basketRow.unit != undefined && basketRow.unit == "KG"  && basketService.get("display_list").indexOf('is_specific_weight') >= 0 ){
    if(((fieldName == "row_width") || (fieldName == "row_height") ||  (fieldName == "row_depth") || (fieldName == "amount2")) && (basketRow.row_width !=0 && basketRow.row_height !=0 && basketRow.row_depth !=0)) {
        basketRow.row_volume = wrk_round((basketRow.row_width * basketRow.row_height * basketRow.row_depth),basketService.priceRoundNumber());
        if(fieldName !=undefined && basketRow.amount2 !=0){
            basketRow.amount=wrk_round( basketRow.row_volume / 1000 * basketRow.row_specific_weight * basketRow.amount2,basketService.priceRoundNumber());
        }
        else{
            basketRow.amount = wrk_round( basketRow.row_volume / 1000 * basketRow.row_specific_weight,basketService.priceRoundNumber());
        }
    }
    }

    if (fieldName == "tax") {
        basketRow.tax_percent = basketRow.tax;
    } else {
        basketRow.tax = basketRow.tax_percent;
    }

    if (fieldName == "amount" || fieldName == "amount_other" || fieldName == "amount2") {
        basketRow = amount_hesapla( fieldName, basketRow );
    }
    
    if ( fieldName.indexOf("disc_") == 0 ) {
        
        try {
            basketRow = discount_control(basketRow);
        } catch (ex) {
            alert(ex.message);
            return false;
        }

        basketRow.indirim_carpan = (100-basketRow.disc_ount) * (100-basketRow.disc_ount2_) * (100-basketRow.disc_ount3_) * (100-basketRow.disc_ount4_) * (100-basketRow.disc_ount5_) * (100-basketRow.disc_ount6_) * (100-basketRow.disc_ount7_) * (100-basketRow.disc_ount8_) * (100-basketRow.disc_ount9_) * (100-basketRow.disc_ount10_);

    }

    if ( basketRow.amount < 0 ) {
        alert(lng_miktar_degeri_hatali);
        viewModel.items.amount(1);
        return false;
    }
    if ( basketRow.price < 0 ) {
        alert(lng_fiyat_degeri_hatali);
        viewModel.items.price(0);
        return false;
    }
    if ( basketRow.amount == 0 ) {
        basketRow.amount == 1;
    }
    basketRow.iskonto_tutar = wrk_round( basketRow.iskonto_tutar * rates.rate2 / rates.rate1, basketService.priceRoundNumber() );

    if ( fieldName == "ek_tutar" || fieldName == "amount" ) {
        basketRow.ek_tutar_other_total = wrk_round( basketRow.ek_tutar * basketRow.amount, basketService.priceRoundNumber() );
        basketRow.ek_tutar = wrk_round( basketRow.ek_tutar * rates.rate2 / rates.rate1, basketService.priceRoundNumber() );
    } else {
        basketRow.ek_tutar = wrk_round( basketRow.ek_tutar_total / basketRow.amount, basketService.priceRoundNumber() );
        basketRow.ek_tutar_other_total = wrk_round( basketRow.ek_tutar * rates.rate1 / rates.rate2 * basketRow.amount, basketService.priceRoundNumber() );
    }

    if ( fieldName == "row_total" ) {
        if (basketRow.amount != 0) {
            basketRow.price = (basketRow.row_total - (basketRow.ek_tutar * basketRow.amount)) / basketRow.amount;
        } else {
            basketRow.price = 0;
        }
        basketRow.price_other = wrk_round( price * rates.rate1 / rates.rate2, basketService.priceRoundNumber() );
    } else if ( fieldName == "price_other" ) {
        basketRow.price = wrk_round( basketRow.price_other * rates.rate2 / rates.rate1, basketService.priceRoundNumber() );
        tmp_price = basketRow.price;
    } else if ( fieldName == "other_money_value" ) {
        if (basketRow.amount != 0) {
            basketRow.price_other = basketRow.other_money_value / basketRow.amount * basketService.indirimFixNumber() / basketRow.indirim_carpan;
        } else {
            basketRow.price_other = 0;
        }
        basketRow.price_other *= 100 / (100 - basketRow.promosyon_yuzde);
        basketRow.price_other += basketRow.iskonto_tutar;
        basketRow.price_other -= basketRow.ek_tutar;
        basketRow.price = basketRow.price_other * rates.rate2 / rates.rate1;
    } else if ( fieldName == "ek_tutar_other_total" ) {
        if (basketRow.ek_tutar_other_total == '') {
            basketRow.ek_tutar_other_total = 0;
        }
        if (basketRow.amount != 0) {
            basketRow.ek_tutar = wrk_round( basketRow.ek_tutar_other_total * rates.rate2 / rates.rate1 / basketRow.amount, basketService.priceRoundNumber() );
        } else {
            basketRow.ek_tutar = 0;
        }
    } else {
        basketRow.price_other = wrk_round( basketRow.price * rates.rate1 / rates.rate2, basketService.priceRoundNumber() );
    }

    basketRow.row_total = wrk_round( (basketRow.price + basketRow.ek_tutar) * basketRow.amount, basketService.basketTotalRoundNumber() );
    basketRow.ek_tutar_total = wrk_round( basketRow.ek_tutar * basketRow.amount, basketService.priceRoundNumber() );
    basketRow.ek_tutar = wrk_round( basketRow.ek_tutar * rates.rate1 / rates.rate2, basketService.priceRoundNumber() );

    tmp_price += basketRow.ek_tutar;
    tmp_price -= basketRow.iskonto_tutar;
    tmp_price -= tmp_price * basketRow.promosyon_yuzde / 100;
    basketRow.price_net = wrk_round( tmp_price * basketRow.indirim_carpan / basketService.indirimFixNumber(), basketService.priceRoundNumber() );
    basketRow.row_nettotal = wrk_round( basketRow.price_net * basketRow.amount, basketService.basketTotalRoundNumber() );

    if ( fieldName != 'row_otvtotal' ) {
        if (basketRow.otv != basketRow.otv_oran) basketRow.otv_oran = basketRow.otv;
        basketRow.row_otvtotal = wrk_round( basketRow.row_nettotal * basketRow.otv_oran / 100, basketService.basketTotalRoundNumber() );
        if (basketService.otvCalcType().toString() == "1") {
            basketRow.row_otvtotal = wrk_round( basketRow.amount * basketRow.otv_oran, basketService.basketTotalRoundNumber() );
            if (basketRow.row_nettotal == 0) {
                basketRow.row_otvtotal = 0;
            }
        }
    }
    
    if ( fieldName != 'row_taxtotal' ) {
        if ( basketService.get("display_list").indexOf('otv_from_tax_price') >= 0 ) {
            if (basketService.basketTotalRoundNumber() == 2) {
                let pre_tax_t = wrk_round( (basketRow.row_total + basketRow.row_otvtotal) * basketRow.tax_percent, basketService.priceRoundNumber() );
                basketRow.row_taxtotal = wrk_round( pre_tax_t / 100, basketService.priceRoundNumber() );
            } else {
                let pre_tax_t = wrk_round( (basketRow.row_nettotal + basketRow.row_otvtotal) / 100, basketService.priceRoundNumber() );
                basketRow.row_taxtotal = wrk_round( pre_tax_t * basketRow.tax_percent, basketService.priceRoundNumber() );
            }
        } else {
            if ( satir_kdv_tutar !== undefined ) {
                basketRow.row_taxtotal = satir_kdv_tutar;
            } else {
                if (basketService.basketTotalRoundNumber() == 2) {
                    if (basketRow.row_nettotal == 0) {
                        basketRow.row_taxtotal = 0;
                    } else {
                        let pre_tax_t = wrk_round( basketRow.row_nettotal * basketRow.tax_percent, basketService.priceRoundNumber() );
                        basketRow.row_taxtotal = wrk_round( pre_tax_t / 100, basketService.priceRoundNumber() );
                    }
                } else {
                    if (basketRow.row_nettotal == 0) {
                        basketRow.row_taxtotal = 0;
                    } else {
                        let pre_tax_t = wrk_round( basketRow.row_nettotal / 100, basketService.priceRoundNumber() );
                        basketRow.row_taxtotal = wrk_round( pre_tax_t * basketRow.tax_percent, basketService.priceRoundNumber() );
                    }
                }
            }
        }

    }
    if ( fieldName == "row_bsmv_amount" ) {
        basketRow.row_bsmv_rate = ( basketRow.row_bsmv_amount > 0 ) ? row_bsmv_amount * 100 / basketRow.row_nettotal : 0;
        basketRow.row_bsmv_currency = basketRow.row_bsmv_amount * rates.rate1 / rates.rate2;
    } else if ( fieldName == "row_bsmv_currency" ) {
        basketRow.row_bsmv_amount = basketRow.row_bsmv_currency * rates.rate1 / rates.rate2;
        basketRow.row_bsmv_rate = ( basketRow.row_bsmv_amount > 0 ) ? basketRow.row_bsmv_amount * 100 / basketRow.row_nettotal : 0;
    } else {
        basketRow.row_bsmv_rate = basketRow.row_bsmv_rate ? wrk_round( basketRow.row_bsmv_rate, basketService.priceRoundNumber() ) : 0; 
        basketRow.row_bsmv_amount = basketRow.row_nettotal * basketRow.row_bsmv_rate / 100;
        basketRow.row_bsmv_currency = ( basketRow.row_bsmv_amount > 0 ) ? basketRow.row_bsmv_amount * rates.rate1 / rates.rate2 : 0;
    }

    if ( fieldName == "row_oiv_amount" ) {
        basketRow.row_oiv_amount = wrk_round( basketRow.row_oiv_amount, basketService.priceRoundNumber() );
        basketRow.row_oiv_rate = ( basketRow.row_oiv_amount > 0 ) ? basketRow.row_oiv_amount * 100 / basketRow.row_nettotal : 0;
    } else {
        basketRow.row_oiv_rate = (basketRow.row_oiv_rate !== undefined && basketRow.row_oiv_rate != null) ? basketRow.row_oiv_rate : 0;
        basketRow.row_oiv_amount = ( basketRow.row_oiv_rate > 0 ) ? basketRow.row_nettotal * basketRow.row_oiv_rate / 100 : 0;
    }

    basketRow.row_lasttotal = basketRow.row_nettotal + basketRow.row_taxtotal + basketRow.row_otvtotal + basketRow.row_oiv_amount + basketRow.row_bsmv_amount;

    if ( basketRow.amount > 0 && fieldName == "tax_price" ) {
    } else if ( basketRow.amount > 0 ) {
        basketRow.tax_price = wrk_round( basketRow.row_lasttotal / basketRow.amount, basketService.priceRoundNumber() );
    } else {
        basketRow.tax_price = 0;
    }

    basketRow.price_net_doviz = wrk_round( basketRow.price_net * rates.rate1 / rates.rate2, basketService.priceRoundNumber() );
    basketRow.other_money_value = wrk_round( basketRow.amount * basketRow.price_net_doviz, basketService.priceRoundNumber() );
    basketRow.other_money_gross_total = basketRow.row_lasttotal * rates.rate1 / rates.rate2;

    if (basketRow.row_taxtotal == 0 && basketRow.row_otvtotal == 0) {
        basketRow.other_money_gross_total = basketRow.other_money_value;
    }

    if ( fieldName == "amount" ) {
        if ( basketService.get("display_list").indexOf('is_promotion') >= 0 ) {
            basketRow = control_row_prom( basketRow );
        }
    }

    if ( basketManager.hasShownItem( "row_tevkifat_id" ) && basketManager.hasShownItem( "row_tevkifat_rate" ) && basketManager.hasShownItem( "row_tevkifat_amount" ) ) {
        if ( fieldName == "row_tevkifat_amount" ) {
            basketRow.row_tevkifat_rate = wrk_round( basketRow.row_tevkifat_amount > 0 ? basketRow.row_tevkifat_amount / basketRow.row_taxtotal : 0, basketService.basketTotalRoundNumber() );
        } else if ( fieldName == "row_tevkifat_id" || fieldName == "row_tevkifat_rate" ) {
            console.log("tevkifat by " + fieldName);
            basketRow.row_tevkifat_amount = wrk_round( basketRow.row_tevkifat_rate * basketRow.row_taxtotal, basketService.basketTotalRoundNumber() );
        }
    }

    if ( basketManager.hasShownItem( "otv_type" ) && basketManager.hasShownItem( "otv_discount" ) ){
        if ( basketRow.otv_type == 1 ){
            basketRow.otv_discount = wrk_round( basketRow.row_otvtotal, basketService.basketTotalRoundNumber() );
        }else{
            basketRow.otv_discount = wrk_round(0, basketService.basketTotalRoundNumber());
        }
    }

    for (let key in basketRow) {
        if (basketRow.hasOwnProperty(key)) {
            let basketVal = basketRow[key];
            if (viewModel[key] !== undefined && !ko.isComputed(viewModel[key])) {
                viewModel[key]( basketVal );
            } else if (ko.isComputed(viewModel[key])) {
            } else {
                viewModel[key] = ko.observable( basketVal );
            }
        }
    }

    toplam_hesapla(0);

};

basketService.setBasketRowCalculator( satir_hesapla );

/**
 * Para birimi toplam alanı eventi
 */
function selectedCurrency() {
    basketManager.setBasketFooterItem("basketCurrencyType", basketManagerObject.basketFooter.basket_money());
    toplam_hesapla(0);
}

/**
 * Genel indirim input eventi
 */
function genelIndirimHesapla() {
    toplam_hesapla(1);
}

/**
 * Yuvarlama alanı eventi
 */
function yuvarlama() {
    toplam_hesapla(0);
}

/**
 * Yuvarlama döviz alanı eventi
 */
function yuvarlama_doviz_hesapla() {
    if (basketManagerObject.basketFooter.yuvarlama_doviz() >= 0) {
        let yazilan = basketManagerObject.basketFooter.yuvarlama_doviz();
        total = 0;
        toplam_hesapla(1);
        total = yazilan / basketManagerObject.basketFooter.basket_rate2();
        basketManagerObject.basketFooter.yuvarlama( total );
        toplam_hesapla(1);
    }
}

function kur_degistir(gelen){
    for( var satir_index = 0 ; satir_index < basketManagerObject.basketItems().length ; satir_index++){
        if(satir_index == basketManagerObject.basketItems().length)
            satir_hesapla('price_other',satir_index,1);
        }
        kdvsiz_doviz_indirim_hesapla();
        kdvli_doviz_indirim_hesapla();
        return true;
}

/**
 * Tevkifat popup geri dönüş eventi
 * Deleted
 function tevkifat_plus_cb() {
     basketManager.setBasketFooterItem("tevkifat_oran", filterNum( $("#temp_tevkifat_oran").val(), basketService.basketTotalRoundNumber()));
     basketManager.setBasketFooterItem("tevkifat_id", $("#temp_tevkifat_id").val());
     toplam_hesapla(0);
}
*/

/**
 * Stopaj poup dönüş eventi
 */
function stopaj_hesapla() {
    basketManager.setBasketFooterItem("stopaj_id", $("#temp_stopaj_rate_id").val());
    basketManager.setBasketFooterItem("stopaj_yuzde", $("#temp_stopaj_yuzde").val());
    toplam_hesapla(0);
}

/**
 * Footer İstisna popup dönüş eventi
 */
function return_istisna(){
    basketManager.setBasketFooterItem("exc_code", $("#temp_exc_code").val());
    basketManager.setBasketFooterItem("exc_article", $("#temp_exc_article").val());
    basketManager.setBasketFooterItem("exc_id", $("#exc_id").val());
}

/**
 * alt toplamda tevkifat popup dönüş eventi
 */
 function tevkifat_hesapla(){
    basketManager.setBasketFooterItem("tevkifat_oran", $("#temp_tevkifat_oran").val());
    basketManager.setBasketFooterItem("tevkifat_id", $("#tevkifat_id").val());
    toplam_hesapla(1);
 }

/**
 * Satır güncellemede sepet durumunu kontrol eder
 * @param {int} update_product_row_id güncellenecek satır no
 * @param {bool|int|null} isUpdOrAdd upd mi add mi
 */
function control_comp_selected(update_product_row_id, isUpdOrAdd,prod_config) {
    let rowCount = basketManagerObject.basketItems().length;
    if ([1,11,17,6,10,20,33].indexOf(basketService.basket_id()) >= 0) {
        if ( $("#basket_main_div #branch_id").val() == '' ) {
            alert(lng_once_depo_sec);
            return false;
        }
    }
    if ([4,51].indexOf(basketService.basket_id()) >= 0) {
        if ( $("#basket_main_div #x_required_dep").val() == 1 && $("#basket_main_div #deliver_dept_id").val() == '' ) {
            alert(lng_once_depo_sec);
            return false;
        }
    }

    let is_cost = basketManager.hasShownItem("net_maliyet");
    let is_price = basketManager.hasShownItem("price");
    let is_price_other = basketManager.hasShownItem("price_other");
    let str_tlp_comp = "";

    if ([1,2,4,6,10,11,17,18,20,21].indexOf(basketService.basket_id()) >= 0) {
        str_tlp_comp = "&branch_id=" + $("#basket_main_div #branch_id").val();
    }

    let aranan_tarih = "";
    try {
        if ( $("#basket_main_div #search_process_date").val() != '' ) {
            aranan_tarih = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
        }
        if ( [1,5,6,11,15,17,20,37].indexOf(basketService.basket_id()) >= 0 ) {
            if (aranan_tarih == '') {
                alert(lng_satinalma_indirimi_tarih_bilgisi);
                return false;
            }
        }
    } catch (error) {
    }

    let sepet_process_type = -1;
    if ( $("#process_cat").length > 0 ) {
        sepet_process_type = $("#process_cat")[0].selectedIndex;
        if (sepet_process_type == -1) {
            alert(lng_once_islem_tipi_sec);
            return false;
        }
    }

    if ( basketService.get("display_list").indexOf('is_member_selected') >= 0 ) {
        if (sepet_process_type != 52) { //perakende satış faturası
            if( $("#basket_main_div #company_id").length > 0 && $("#basket_main_div #consumer_id").length > 0 && $("#basket_main_div #partner_name").length > 0 )
			{
				if( $("#basket_main_div #company_id").val().length == 0  && $("#basket_main_div #consumer_id").val() == 0  && $("#basket_main_div #partner_name").val() == 0) {
					alert(lng_once_uye_sec);
					return false;
				}
			}
        }
    }

    let temp_project_id = '';
    if ( (sepet_process_type == -1 || sepet_process_type != 52) && sepet_process_type != 115 ) {
        if( ( $("#basket_main_div #project_id").length > 0 && $("#basket_main_div #project_head").length > 0 ) || $("#basket_main_div #project_id_in").length > 0 && $("#basket_main_div #project_head_in").length > 0 ) {
            if ( ( ($("#basket_main_div #project_id").val().length == 0 || $("#basket_main_div #project_head").val().length == 0 ) && $("#basket_main_div #project_id_in").length == 0) || ( ($("#basket_main_div #project_id").val().length == 0 || $("#basket_main_div #project_head").val().length == 0) && ($("#basket_main_div #project_id_in").length != 0 && ($("#basket_main_div #project_id_in").length == 0 || $("#basket_main_div #project_id_in").val().length == 0)) ) ) {
                if ( basketService.get("display_list").indexOf('is_project_selected') >= 0 ) {
                    alert(lng_once_proje_sec);
                    return false;
                }
            } else {
                if ( $("#basket_main_div #project_id").val().length != 0 ) {
					temp_project_id = $("#basket_main_div #project_id").val();
                } else if( $("#basket_main_div #project_id_in").length != 0 && $("#basket_main_div #project_id_in").val().length != 0 ) {
					temp_project_id = $("#basket_main_div #project_id_in").val();
                }
            }
        }
    }

    if ( basketService.basket_id() == 51 ) {
        if ( $("#basket_main_div #paymethod_id").length > 0 && $("#basket_main_div #paymethod_id").val().length == 0 && $("#basket_main_div #card_paymethod_id").length > 0 && $("#basket_main_div #card_paymethod_id").val().length == 0 )
		{
			alert(lng_odeme_yontemi_sec);
			return false;
		}
    }

    let department_str = "";
    if ([76,81].indexOf(sepet_process_type) >= 0) { //81: depo sevk, 76: alış irsaliye
        if ( $("#basket_main_div #location_id").length > 0 && $("#basket_main_div #location_id").val().length == 0 ) {
			alert(lng_cikis_loc_sec);
			return false;
		} else {
			department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
        }
    }
    if ([111,112,113].indexOf(sepet_process_type) >= 0) { //111:sarf fisi, 112:fire fisi, 113:ambar fisi
        if($("#basket_main_div #location_out").length > 0 && $("#basket_main_div #location_out").val().length == 0) { 
			alert(lng_cikis_loc_sec);
			return false;
		} else {
			department_str = '&department_out=' + $("#basket_main_div #department_out").val() + '&location_out=' + $("#basket_main_div #location_out").val();
        }
    }
    if ([2,10,18,21,48].indexOf(basketService.basket_id()) >= 0) { // Satış Faturası, Stok Satış İrsaliyesi, Şube Satış Faturası, Şube Satış İrsaliyesi, Servis Giriş
		if ( $("#basket_main_div #location_id").length > 0 && $("#basket_main_div #location_id").val().length == 0 ) {
			alert(lng_once_depo_sec);
			return false;
		} else {
			department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
        }
    }
    if ([4,51].indexOf(basketService.basket_id()) >= 0) { // Satış Siparişi, Taksitli Satış
		if ( $("#basket_main_div #deliver_dept_id").length >= 0 && $("#basket_main_div #deliver_dept_id").val().length >= 0 ) {
            department_str = '&department_out=' + $("#basket_main_div #deliver_dept_id").val() + '&location_out=' + $("#basket_main_div #deliver_loc_id").val();
        }
    }
    if ( 7 == basketService.basket_id() ) { // İç Talep
		if( $("#basket_main_div #department_id").length >= 0 && $("#basket_main_div #department_id").val().length >= 0 ) {
            department_str = '&department_out=' + $("#basket_main_div #department_id").val() + '&location_out=' + $("#basket_main_div #location_id").val();
        }
    }
    temp_paymethod = "";
    temp_card_paymethod = "";
    temp_paymethod_vehicle = "";
    if ([1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0) { // Alış Faturası, Satış Faturası, Satış Siparişi, Satın Alma Siparişi, Şube Satış Faturası, Şube Alış Faturası, Müstahsil Makbuzu, Satış Siparişi, Taksitli Satış
		console.log();
        if ( typeof($("#basket_main_div #paymethod_id")) != 'undefined' && typeof($("#basket_main_div #paymethod_id").val()) != 'undefined') {
            if ( $("#basket_main_div #paymethod_id").length >= 0 && $("#basket_main_div #paymethod_id").val().length >= 0 ) {
                temp_paymethod = $("#basket_main_div #paymethod_id").val();//perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
            }
        }
        if ( typeof($("#basket_main_div #card_paymethod_id")) != 'undefined' && typeof($("#basket_main_div #card_paymethod_id").val()) != 'undefined') {
            if ( $("#basket_main_div #card_paymethod_id").length >= 0 && $("#basket_main_div #card_paymethod_id").val().length >= 0 ) { //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
                temp_card_paymethod = $("#basket_main_div #card_paymethod_id").val();
            }
        }
        if ( typeof($("#basket_main_div #paymethod_vehicle")) != 'undefined' && typeof($("#basket_main_div #paymethod_vehicle").val()) != 'undefined') {
            if ( $("#basket_main_div #paymethod_vehicle").length >= 0 && $("#basket_main_div #paymethod_vehicle").val().length >= 0 ) { //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
                temp_paymethod_vehicle = $("#basket_main_div #paymethod_vehicle").val();
            }
        }
    }
    
    let get_money_currency_list_for_popup = basketService.get("basket_money_list")().map(m => m.MONEY_TYPE() + '=' + (m.RATE2() / m.RATE1()).toString()).join("&");
    let satir = -1;
    let temp = '';
    if (update_product_row_id != -1) {
        if (isUpdOrAdd == undefined) {
            satir = update_product_row_id;
        }
        if ( $("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0 ) {
            temp = '&company_id='+$("#basket_main_div #company_id").val();
        } else if ( $("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0 ) {
            temp = '&consumer_id='+$("#basket_main_div #consumer_id").val();
        } else if ( $("#basket_main_div #employee_id").length != 0 && $("#basket_main_div #employee_id").val().length != 0 ) {
            temp = '&employee_id='+$("#basket_main_div #employee_id").val();
        }

        let url_str = '/index.cfm?fuseaction=objects.popup_products&int_basket_id=' + basketService.basket_id();

        if(prod_config != undefined)
        url_str = 'index.cfm?fuseaction=product.configurator&int_basket_id=' + basketService.basket_id();

        if ( basketService.get("wmo_module") == 'store' ) {
            url_str += '&is_store_module=1';
        }
        if ( basketService.get("wmo_action").indexOf("internaldemand") >= 0 ) {
            url_str += '&demand_type=0';
        }
        url_str += '&update_product_row_id=' + update_product_row_id + '&sepet_process_type=' + sepet_process_type;
        if ( [1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0 ) {
            url_str += '&paymethod_id=' + temp_paymethod + '&card_paymethod_id=' + temp_card_paymethod + '&paymethod_vehicle=' + temp_paymethod_vehicle;
        }
        url_str += '&rowCount=' + rowCount + '&is_sale_product=' + (basketManagerObject.basketHeaders()[0].sale_product ? 1 : 0) + '&is_price=' + is_price + '&is_price_other=' + is_price_other + '&is_cost=' + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih + "&project_id=" + temp_project_id + "&" + get_money_currency_list_for_popup + "&satir=" + satir + temp;
        
        if($("#configurator #mpc").val() != undefined)
        url_str+='&keyword='+$("#configurator #mpc").val();
        if(prod_config != undefined)
        openBoxDraggable(url_str);
        else
        windowopen(url_str, "page_horizantal", basketService.get("basket_unique_code"));
    } else {
        var url_str = '';
        url_str = "&int_basket_id=" + basketService.basket_id() + "&sepet_process_type=" + sepet_process_type;
        if ( basketService.wmo_module() == 'store' ) {
            url_str += '&is_store_module=1';
        }
        if ( [1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0 ) {
            url_str += '&paymethod_id' + temp_paymethod + '&card_paymethod_id=' + temp_card_paymethod + '&paymethod_vehicle=' + temp_paymethod_vehicle;
        }
        url_str += '&' + get_money_currency_list_for_popup;
        url_str += '&row_count=' + rowCount + '&is_sale_product=' + (basketManagerObject.basketHeaders()[0].sale_product ? 1 : 0) + '&is_price=' + is_price + "&is_price_other=" + is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih + "&project_id=" + temp_project_id;

        if ( $("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0 ) {
            url_str += '&company_id=' + $("#basket_main_div #company_id").val();
        } else if ( $("#basket_main_div #consumer_id").length >= 0 && $("#basket_main_div #consumer_id").val().length >= 0 ) {
            url_str += '&consumer_id=' + $("#basket_main_div #consumer_id").val();
        } else if ( $("#basket_main_div #employee_id").length >= 0 && $("#basket_main_div #employee_id").val().length >= 0 ) {
            url_str += '&employee_id=' + $("#basket_main_div #employee_id").val();
        }
        $("#url_info").val(url_str);
        $("#paper_process_type").val(sepet_process_type);
        window.frames["_add_prod_"].document.add_speed_prod.url_info.value='';
        window.frames["_add_prod_"].document.add_speed_prod.url_info.value=url_str;
        window.frames["_add_prod_"].document.add_speed_prod.paper_process_type.value='';
        window.frames["_add_prod_"].document.add_speed_prod.paper_process_type.value=sepet_process_type;

    }
    return true;
}

/**
 * Satır silme işlemi ile ilişkili satırları temizler
 * @param {int} idx satır indexi
 */
function row_minus_cb(idx) {
    if (confirm("Satırı silmek istediğinizden emin misiniz?")) {
        clear_row(idx);
    }
}

/**
 * Promosyon detay callback
 */
function general_prom_detail_cb() {
    let general_prom_id = basketManagerObject.basketFooter.general_prom_id();
    windowopen("/index.cfm?fuseaction=objects.popup_detail_promotion_unique&prom_id=" + general_prom_id);
}

/**
 * Ücretsiz promosyon detay callbak
 */
function free_prom_detail_cb() {
    let free_prom_id = basketManagerObject.basketFooter.free_prom_id();
    windowopen("/index.cfm?fuseaction=objects.popup_detail_promotion_unique&prom_id=" + free_prom_id);
}

/**
 * Satırdaki ürünü değiştiren popup için callback
 * @param {int} satir Satır no
 * @param {object} data satır verisi
 */
function updateBasketItemFromPopup(satir, data) {
    for (var prop in data){
        let phead = basketManagerObject.basketHeaders().filter(m => m.id == prop.toLowerCase());
        if (phead != null && phead.isNumeric && data[prop] != "" && !isNaN(data[prop])) {
            basketManagerObject.basketItems()[satir][prop.toLowerCase()]( Number(data[prop]) );
        }else {
            if (prop.toLowerCase() != "basket_row_department") {
                basketManagerObject.basketItems()[satir][prop.toLowerCase()]( data[prop] );
            }
        }
        if (prop.toLowerCase() == "row_exp_center_name") {
            basketManagerObject.basketItems()[satir]["basket_exp_center"]( data[prop] );
        }else if( prop.toLowerCase() == "row_exp_item_name" ) {
            basketManagerObject.basketItems()[satir]["basket_exp_item"]( data[prop] );
        }else if( prop.toLowerCase() == "row_acc_code") {
            basketManagerObject.basketItems()[satir]["basket_acc_code"]( data[prop] );
        }else if( prop.toLowerCase() == "row_project_name") {
            basketManagerObject.basketItems()[satir]["basket_project"]( data[prop] );
        }else if( prop.toLowerCase() == "row_work_name") {
            basketManagerObject.basketItems()[satir]["basket_work"]( data[prop] );
        }else if( prop.toLowerCase() == "spect_name") {
            basketManagerObject.basketItems()[satir]["spec"]( data[prop] );
        }else if( prop.toLowerCase() == "basket_row_department") {
            console.log( data[prop]);
            basketManagerObject.basketItems()[satir]["basket_row_departman"]( data[prop] );
        }
    }
}

/**
 * Lot no popupu açar
 * @param {object(ko)} viewModel view model
 */
function open_lot_no_popup(viewModel) {

    let urlparams = {};
    
    let from_stock_code = viewModel.items.stock_code();
    let product_id = viewModel.items.product_id();
    let stock_id = viewModel.items.stock_id();

    let sepet_process_obj = findObj("process_cat");

    let is_cost = basketManager.hasShownItem("net_maliyet") ? 1 : 0;
    let is_price = basketManager.hasShownItem("price") ? 1 : 0;
    let is_price_other = basketManager.hasShownItem("price_other") ? 1 : 0;
    if ([1,2,4,6,10,11,17,18,20,21].indexOf(basketService.basket_id()) >= 0) {
        urlparams.branch_id = form_basket.branch_id.value;
    }
    let arama_tarih = "";
    let department_str = "";
    let temp_project_id = "";

    urlparams.int_basket_id = basketService.basket_id();
    if (basketService.wmo_module() == 'store') {
        urlparams.is_store_module = 1;
    }
    if (basketService.wmo_action().indexOf("internaldemand") >= 0) {
        urlparams.demand_type = 0;
    }
    urlparams.update_product_row_id = basketManagerObject.basketItems().indexOf(viewModel);
    if ([1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0) {
        urlparams.paymethod_id = temp_paymethod;
        urlparams.card_paymethod_id = temp_card_paymethod;
        urlparams.paymethod_vehicle = temp_paymethod_vehicle;
    }
    basketService.get("basket_money_list")().forEach(e => {
        urlparams[e.MONEY_TYPE()] = filterNum(e.RATE2(), 4)/filterNum(e.RATE1());
    });
    urlparams.rowCount = urlparams.update_product_row_id;
    urlparams.is_sale_product = (basketManagerObject.basketHeaders()[0].sale_product ? 1 : 0);
    urlparams.is_price = is_price;
    urlparams.is_price_other = is_price_other;
    urlparams.is_cost = is_cost;
    urlparams.is_lot_no_based = 1;
    urlparams.satir = urlparams.update_product_row_id;
    urlparams.sepet_process_type = -1;
    if (sepet_process_obj != null) {
        urlparams.sepet_process_type = process_type_array[sepet_process_obj.selectedIndex];
    }
    urlparams.pid = product_id;
    urlparams.sid = stock_id;
    urlparams.keyword = from_stock_code;
    urlparams.sort_type = 1;
    urlparams.prod_order_result_ = 1;
    urlparamstr = $.param(urlparams);
    windowopen('/index.cfm?fuseaction=objects.popup_products&' + urlparamstr, 'list');
}

/**
 * Fiyat popupu açar
 * @param {object(ko)} viewModel view model
 */
function open_price(viewModel) {
    if (viewModel.items.product_id() == "") return;

    let urlparams = {};
    let satir = basketManagerObject.basketItems().indexOf(viewModel);

    urlparams.product_id = viewModel.items.product_id();
    urlparams.stock_id = viewModel.items.stock_id();
    urlparams.product_name = viewModel.items.product_name();
    urlparams.unit = viewModel.items.unit();
    urlparams.pid = urlparams.product_id;
    urlparams.row_id = satir;

    urlparams.sepet_process_type = -1;
    let sepet_process_obj = findObj("process_cat");
	if(sepet_process_obj != null) {
        urlparams.sepet_process_type = process_type_array[sepet_process_obj.selectedIndex];
    }
    
    if ($("#basket_main_div #company_id").length > 0 && $("#basket_main_div #company_id").val().length > 0) {
        urlparams.company_id = $("#basket_main_div #company_id").val();
    }
    if ($("#basket_main_div #consumer_id").length > 0 && $("#basket_main_div #consumer_id").val().length > 0) {
        urlparams.consumer_id = $("#basket_main_div #consumer_id").val();
    }
    if (basketService.wmo_module() == 'store') {
        urlparams.is_store_module = 1;
    }
    basketService.get("basket_money_list")().forEach(e => {
        urlparams[e.MONEY_TYPE()] = filterNum(e.RATE2(), 4)/filterNum(e.RATE1());
    });
    urlparamstr = $.param(urlparams);
	windowopen('/index.cfm?fuseaction=objects.popup_product_price_history_js&' + urlparamstr, 'medium')
}


function saveFormAll(){

    if(!basketManagerObject.basketItems().length){
        alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
        return false;
    }
    let headerValues = {};
    headerValues["basket_id"] = basketService.basket_id();
    headerValues["fuseaction"] = basketService.wmo_module() + "." + basketService.wmo_action();
    headerValues["basket_price_round_number"] = basketService.priceRoundNumber();
    headerValues["basket_spect_type"] = basketService.basket_spect_type();

    $("#basket_main_div div[basket_header]").find("input,select,textarea").each(function(index,element){
        if($(element).is("input") && $(element).attr("type") != undefined && $(element).attr("type").toLowerCase() == "checkbox")
        {
            if($(element).is(":checked")) headerValues[$(element).attr("name")] = 1;
        }
        else if($(element).is("input") && $(element).attr("type") == "radio")
        {
            if ($(element).is(":checked")) headerValues[$(element).attr("name")] = $(element).val();
        }
        else
        {
            if(!($(element).css('visibility') == 'hidden' && $(element).is("textarea")))
            {
                if(!headerValues[$(element).attr("name")])  // purchase.form_add_offer sayfasında workcube_to_cc kullanılıyor. Burada aynı isimli oluşan hidden'lar query sayfasında kontrol ediliyor. Bu yüzden bu kontrol eklendi .
                    headerValues[$(element).attr("name")] = $(element).val();
                else
                    headerValues[$(element).attr("name")] = headerValues[$(element).attr("name")] + ',' + $(element).val();
            }
        }
    })

    /* if( event.nextEvent != '' ){

        var queryPathJSON = $.evalJSON(decodeURIComponent(event.queryPath));
        var nextEventJSON = $.evalJSON(decodeURIComponent(event.nextEvent));
        if($(obj).closest('form').find("input[name='eventName']").length)
        {
            $(obj).closest('form').find("input[name='eventName']").each(function(index,element){
                headerValues['queryPath'] = queryPathJSON[$(element).val()]['queryPath'];
                headerValues['nextEvent'] = nextEventJSON[$(element).val()]['nextEvent'];
            });
        }
        else
        {
            headerValues['queryPath'] = queryPathJSON[event.event]['queryPath'];
            headerValues['nextEvent'] = nextEventJSON[event.event]['nextEvent'];
        }
    }
    
    if( event.woStruct ){
        if( extendControllerFileName != '' ){
            headerValues['extendedControllerFileName'] = extendControllerFileName;
        }
    }
 */
    let basketJSON = {
        header_value_json : headerValues,
        basket_json : basketManager.getBasketJSON(),
        summary_json : basketManager.getSummaryJSON(),
        rates_json : ko.mapping.toJSON(basketServiceObject.sharedVariables.basket_money_list)
    }

    if( $("input#data_action").val() != undefined && $("input#next_page").val() != undefined ) {
        var next_url = $("input#next_page").val();
        var data = new FormData();
            data.append('cfc', $("input#data_action").val().split(":")[0]);
            data.append('function', $("input#data_action").val().split(":")[1]);
            data.append('event', basketService.wmo_event());
            data.append('basketv', 2);
            data.append('form_data', encodeURIComponent($.toJSON(basketJSON)) );
            AjaxControlPostDataJson('/WMO/datagate.cfc?method=basketConverter', data, function(response) {
                if( response.STATUS ){
                    window.location.href = next_url + response.IDENTITY;
                }else{
                    alert(response.MESSAGE);
                }
            });
            return false;
    }else{
        callURLBasket("/index.cfm?fuseaction=objects.emptypopup_basket_converterv2&ajax=1&xmlhttp=1&_cf_nodebug=true",handlerPostBasket,{ basket: encodeURIComponent($.toJSON(basketJSON)) });
        return false;
    }
}

/**
 * Sayfa post edildiğinde gerekli kontrolleri sağlar
 */
function saveForm(){
    var reqWarning = false, requiredControl = true;

    basketManagerObject.basketItems().forEach( (el) => { 
        for( element in el ){ 
            itemProp = basketManager.getBasketColumnProperties(element)[0];
            if( typeof( itemProp ) != 'undefined' && itemProp.isRequired && el[element]() == '') reqWarning = true;
            else reqWarning = false;

            if( reqWarning ){
                alert("Lütfen basketteki zorunlu alanları boş bırakmayınız! : "+ itemProp.title +"");
                requiredControl = false;
                return false;
            }
        }
    });

    if( !requiredControl ) return false;

    tempAmountControl = 0;
    tempRow = 0;

    for(let row=0; row < basketManagerObject.basketItems().length; row++){
        if( parseFloat(basketManagerObject.basketItems()[row].amount())== 0 ){
            tempAmountControl = 1;
            tempRow = row + 1;
        }
    }
    
    if(tempAmountControl){
        alert(tempRow + '. satırdaki miktar değerini kontrol ediniz');
        return false;
    }

    if( xml.use_basket_project_discount_ ){
        if(!check_project_discount_conditions()){//proje bakiye kontrolleri için eklendi 
            return false;
        }
    }

    /* Baskette yapılan sipariş aşamasındaki değişikliğin sipariş detayında tetiklenmesi için eklendi.*/
    if ( check_reserved_rows() ) {
        return (validate().check() && window['_CF_checkform_basket'](this) && saveFormAll());
    }else return false;
   
}

/**
 * Sipariş Belge bazında rezerve seçeneğine bağlı olarak rezerve tiplerini edit eder
 */
function check_reserved_rows(){ 
    var case_ = $("#basket_main_div #reserved").length != 0 && $("#basket_main_div #reserved").is(":checked");
    let response = true;
    basketManagerObject.basketItems().filter( (el) => {
        if( el.reserve_type() == -4 && case_ ){
            alert( 'Bu belgede rezerve edilmiş stoklar var. Rezerve işlemlerini toplu kaldırmak veri ve iş kayıplarına neden olabilir. Rezerv düzenleme işlemlerini satır bazında yapmalısınız' );
            response = false;
        }
    } );

    //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyor
    basketManagerObject.basketItems().filter( (el) => {
        if( [-3, -8].indexOf( el.order_currency() ) == -1 ) el.reserve_type( case_ == true ? -1 : -3 );
    });
    return response;
}

/**
 * taksitli satış ve satış siparişinde xmle baglı olarak cagrılıyor. belgenin teslim tarihini, satırlardaki boş teslim tarihi alanlarına aktarıyor
 * @param {string} date_field_name 
 * @param {string} project_field_name 
 */

function apply_deliver_date(date_field_name, project_field_name){
    /*teslim tarihi kısmı*/
    if(date_field_name != ''){
        if($("#basket_main_div #" + date_field_name).val().length != 0)
            row_deliver_date_ = $("#basket_main_div #" + date_field_name).val();
        else
            row_deliver_date_='';
            
        if(row_deliver_date_ != ''){
            for(let row_db=0; row_db < basketManagerObject.basketItems().length; row_db++){
                if(!(basketManagerObject.basketItems()[row_db].deliver_date().length)){
                    basketManagerObject.basketItems()[row_db].deliver_date( row_deliver_date_ );
                }
            }  
        }
    }
    /*proje kısmı*/
    if(project_field_name != undefined && project_field_name != ''){
        if($("#basket_main_div #" + project_field_name).val().length != 0){
            row_project_id_ = $("#basket_main_div #project_id_in").val();
            row_project_name_ = $("#basket_main_div #project_head_in").val();
        }
        else{
            row_project_id_='';
            row_project_name_='';
        }
        if(row_project_id_ == undefined && $("#basket_main_div #" + project_field_name).val().length != 0){
            row_project_id_ = $("#basket_main_div #project_id").val();
            row_project_name_ = $("#basket_main_div #project_head").val();
        }
        if(row_project_name_ != '' && row_project_id_ != ''){
            for(let row_db=0; row_db < basketManagerObject.basketItems().length; row_db++){
            basketManagerObject.basketItems()[row_db].row_project_id( row_project_id_ );
            basketManagerObject.basketItems()[row_db].row_project_name( row_project_name_ );
            }
        }
    }
	return true;
  }

  /**
   * Vade tarihi alanı resmi tatile ve haftasonu tatiline denk gelirse ilgili vade tarihinin ilk iş gününe alınmasını kontrol ediyor.ödeme yöntemleri sayfasındaki 'Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin' checkbox değerine göre çalışıyor.
   * @param {string} vade_input 
   * @param {int} paymethod_id 
   * @param {int|null} paper_date_field 
   */
 function control_due_date(vade_input, paymethod_id, paper_date_field){
    if(paymethod_id != undefined && paymethod_id != ''){

        var is_holiday = 0;
        var is_nextday = 0;
        var data = "";
        if(paper_date_field == undefined)
            paper_date_field =$("#basket_main_div #" + $("#basket_main_div #search_process_date").val());
        
        $.ajax({ url :'cfc/paymethod_calc.cfc?method=calc_duedate&isAjax=1&action_date=' + paper_date_field.val()+'&paymethod_id='+paymethod_id, async:false,success : function(res){
            data = res.replace('//""','');
            data = $.parseJSON( data );
            }
        });
        if(data != ""){
            paper_date_field.value = data.DUE_DATE;	
            is_holiday = data.ISHOLIDAY;
            is_nextday = data.NEXT_DAY;
            date_diff = data.DAYDIFF;
        }
    
        $("#basket_main_div #basket_due_value").val(date_diff);
        
        if(is_holiday)
            alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
        if(is_nextday)
            alert("Ödeme Yönteminde sonraki hafta günü seçili. Vade Tarihi Ertelendi!");
     }
 
     var tarih_kontrol = 0;
     var paymethod_id_ = 0;
     var pay_type = 0;
     if(paymethod_id != undefined && paymethod_id != ''){	
         paymethod_id_ = paymethod_id;
         pay_type = 1;
     }
     if(paymethod_id_ != 0){
         var sls_pay_control =  wrk_safe_query("sls_pay_control","dsn",0,paymethod_id_);
         if(sls_pay_control.recordcount && sls_pay_control.IS_DATE_CONTROL == 1){			
             resmi_tatil();
             hafta_tatil();
             function resmi_tatil(){
                 var due_date = document.getElementById(vade_input).value;   
                 var listParam = js_date(due_date); 
                 var get_setup_general_offtimes =  wrk_safe_query("get_setup_general_offtimes","dsn",0,listParam);
                 if(get_setup_general_offtimes.recordcount){  
                     gun_farki = get_setup_general_offtimes.FARK;
                     document.getElementById(vade_input).value = date_add('d',parseInt(gun_farki)+parseInt(1),due_date);
                     tarih_kontrol = 1;
                 }
                 if(get_setup_general_offtimes.IS_HALFOFFTIME == 1)
                     resmi_tatil();					
             }
             function hafta_tatil(){
                 var due_date2 =  document.getElementById(vade_input).value; 		
                 var start_d = document.getElementById(vade_input).value.split(/\D+/);// \D sayı olmayan karakterleri temsil ediyor.
                 var d1=new Date(start_d[2]*1, start_d[1]-1, start_d[0]*1);
                 var weekday = d1.getDay();
                 if(weekday==6){
                     document.getElementById(vade_input).value = date_add('d',parseInt(2),due_date2);
                     tarih_kontrol = 1;
                 }
                 else if(weekday==0){
                     document.getElementById(vade_input).value = date_add('d',parseInt(1),due_date2);
                     tarih_kontrol = 1;
                 }
                 resmi_tatil();
             }
             if(tarih_kontrol == 1){
                alert("Ödeme Yönteminde Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin Parametresi Seçili. Vade Tarihi İlk İş Gününe Ertelendi!");
             }
         }
     }
 }

/**
 * 
 * @param {int|null} dep_id 
 * @param {int|null} loc_id 
 * @param {int} is_update 
 * @param {int|null} process_type 
 * @param {int|null} stock_type 
 * @param {int|null} is_del_ 
 * @param {int|null} is_purchase_ 
 * @param {int|null} is_deliver_ 
 */
 function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type,is_del_,is_purchase_,is_deliver_){
    var hata = '';
    var lotno_hata = '';
    var stock_id_list='0';
    var stock_amount_list='0';
    var spec_id_list='0';
    var spec_amount_list='0';
    var main_spec_id_list='0';
    var main_spec_amount_list='0';
    var tree_stock_id_list='';//spec secilmemeis uretilen urunlerin sb lerini almak icin ayrı bir listede tutum  ****** 0 stok id si ürün ağacından gereksiz kayıt döndürüyordu listeyi boşalttım PY
    var tree_stock_amount_list='0';
    var not_stock_id_list='0';//urun agacina uygun specti bulunmayan urunler listesi
    var popup_spec_type=1;
    if(isNaN(is_del_)) var is_del_=0; //alış islemlerinde silme yapılırken, is_del_ 1 olarak gonderilir
    if(isNaN(is_purchase_)) var is_purchase_=0; //alış islemlerinde günceleme yapılırken depo sevk ve ithal mal girişinde 1 gelir, is_purchase_ 1 olarak gonderilir
    if(isNaN(is_deliver_)) var is_deliver_=1; //depo sevk ve ithal mal girişinde teslim alma seçeneği bilgisi gönderilir. 0 ise belgedeki tutar dikkate alınmaz
    //eger baskete secilen popup specli ise stok kontrolleri specli yapılıyor
      
    let att_bskt_id = ( basketService.basket_id() > 0 ? basketService.basket_id() : 1 )
    
	var get_basket_rows_ = wrk_safe_query("obj_get_basket_rows",'dsn3',0,att_bskt_id);
	  
    input_value = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
	if(get_basket_rows_.recordcount && get_basket_rows_.IS_SELECTED == 1)
		paper_date_kontrol = js_date($("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString());
	else
		paper_date_kontrol = basket.hidden_values.today_date;
  
    is_update = is_update.toString();	
	row_count = basketManagerObject.basketItems().length;
	  
	  try{
          if(sessionVariable.is_lot_no == 1){ // Session değerini basket2Variables.cfm de JS değişkenine atadık
			  if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){ //işlem kategorisinde lot no zorunlu olsun seçili ise
				  if(row_count != undefined){
					  for(i=0; i<row_count; i++){
						  var lotNo = String( basketManagerObject.basketItems()[i].lot_no() );
						  varName = "lot_no_" + basketManagerObject.basketItems()[i].stock_id() + lotNo.replace(/-/g, '_').replace(/\./g, '_');
						  this[varName] = 0;
					  } 
					  for(i=0; i<row_count; i++){
						  if( basketManagerObject.basketItems()[i].stock_id().length != 0 ){ /* buraya bak */
							  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[i].stock_id());
							  if( get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0 ){//üründe lot no takibi yapılıyor seçili ise
                                var lotNo = String( basketManagerObject.basketItems()[i].lot_no() );
                                varName = "lot_no_" + basketManagerObject.basketItems()[i].stock_id() + lotNo.replace(/-/g, '_').replace(/\./g, '_');
                                var xxx = String(this[varName]);
                                var yyy = basketManagerObject.basketItems()[i].amount();
                                this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );
							  }
						  }
					  } 
					  for(i=0; i<row_count; i++){
						  if( basketManagerObject.basketItems()[i].stock_id().length != 0){ /* buraya bak */
							  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[i].stock_id());
							  if(get_prod_detail.IS_LOT_NO == 1){ //üründe lot no takibi yapılıyor seçili ise
                                if( basketManagerObject.basketItems()[i].lot_no().length == 0){
                                   alert((i+1)+'. satırdaki '+ basketManagerObject.basketItems()[i].product_name() + ' ürünü için lot no takibi yapılmaktadır!');
                                   return false;
                                }
							  }
							  if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0){ //üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
                                var stock_id_ = basketManagerObject.basketItems()[i].stock_id();
                                var lot_no_ = basketManagerObject.basketItems()[i].lot_no();
                                var lotNo = String( basketManagerObject.basketItems()[i].lot_no() );
                                varName = "lot_no_" + basketManagerObject.basketItems()[i].stock_id() + lotNo.replace(/-/g, '_').replace(/\./g, '_');
                                /*var xxx = String(this[varName]);
                                var yyy = document.form_basket.amount[i].value;
                                this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );*/
								  if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id==''){
									if(stock_type==undefined || stock_type==0){
										if(is_update != 0){
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										  }
										  else{
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
										  }
									  }
									  else{
										  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
									  }
								  }
								  else{
									  if(stock_type==undefined || stock_type==0){
										  if(is_update != 0){
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
										  }
										  else{
											  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
										  }
									  }
									  else{ /* depoya gore kontrol yapılacaksa*/
										url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									  }
								  }
								  $.ajax({
                                        url: url_,
                                        dataType: "text",
                                        cache:false,
                                        async: false,
                                        success: function(read_data) {
                                        data_ = jQuery.parseJSON(read_data);
                                        if(data_.DATA.length != 0){
                                            $.each(data_.DATA,function(i){

                                                var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
                                                var STOCK_ID = data_.DATA[i][1];
                                                var STOCK_CODE = data_.DATA[i][2];
                                                var PRODUCT_NAME = data_.DATA[i][3];
                                                if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1){ // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
                                                // alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
                                                if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
                                                    lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
                                                }
                                                else{
                                                    if(eval(varName) > PRODUCT_TOTAL_STOCK)
                                                        lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
                                                }
                                            });
										}
										  else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
											  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										  else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
											  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									  }
								  });
							  }
						  }
					  }
				}
				  else{
					  if( basketManagerObject.basketItems()[0].stock_id().length != 0){
						  get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[0].stock_id());
						  if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
							  if(basketManagerObject.basketItems()[0].lot_no() == ''){
								  alert((1)+'. satırdaki '+ basketManagerObject.basketItems()[0].product_name() + ' ürünü için lot no takibi yapılmaktadır!');
								  return false;
							  }
						  }
						  if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0){ //üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
                            var stock_id_ = basketManagerObject.basketItems()[0].stock_id();
                            var lot_no_ = basketManagerObject.basketItems()[0].lot_no();
                            var lotNo = String( basketManagerObject.basketItems()[0].lot_no() );
                            varName = "lot_no_" + stock_id_ + lotNo.replace(/-/g, '_').replace(/\./g, '_');
							  
                            var yyy = basketManagerObject.basketItems()[0].amount();
                            this[varName] = parseFloat(filterNum(yyy,price_round_number) );
                            //this[varName] = parseFloat(this[varName]) + parseFloat(document.form_basket.amount.value)
							if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id==''){
                                if(stock_type==undefined || stock_type==0){
                                    if(is_update != 0){
                                        url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
                                    }
                                    else{
                                        url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
                                    }
                                }
								  else{
									  url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
								  }
							  }
							  else{
                                    if(stock_type==undefined || stock_type==0){
                                        if(is_update != 0){
                                            url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
                                        }
                                        else{
                                            url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
                                        }
                                    }
								    else{ /*uretim rezerve ve stoklarda depoya gore kontrol yapılacaksa*/
									    url_= 'V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
								    }   
							  }
							  $.ajax({
									  url: url_,
									  dataType: "text",
									  cache:false,
									  async: false,
									  success: function(read_data) {
									  data_ = jQuery.parseJSON(read_data);
									  if(data_.DATA.length != 0)
									  {
                                        $.each(data_.DATA,function(i){
                                            var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
                                            var STOCK_ID = data_.DATA[i][1];
                                            var STOCK_CODE = data_.DATA[i][2];
                                            var PRODUCT_NAME = data_.DATA[i][3];
                                            if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1){ // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
                                            // alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
                                                if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
                                                    lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
                                            }
                                            else{
                                                if(eval(varName) > PRODUCT_TOTAL_STOCK)
                                                    lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
                                            }
                                        });
									  }
									  else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
										  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									  else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
										  lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
								  }
							  });
						  }
					  }
				}
			}
        }
	  }
	  catch(e)
	  {}
	  
	  if(is_update.indexOf(';') >= 0)	is_update = list_getat(is_update,1,';');
  
	  if( (is_update == 0 && ( $("#basket_main_div #irsaliye_id_listesi").length == 0  || ( $("#basket_main_div #irsaliye_id_listesi").length && ( $("#basket_main_div #irsaliye_id_listesi").val().length == 0 ||  $("#basket_main_div #irsaliye_id_listesi").val().split(";", 1) == '') ))) || (is_update!= 0 )){ //faturaya irsaliye cekilerek baskete eklenmis urunler haricinde olanlar aliniyor
		for (var counter_=0; counter_ < basketManagerObject.basketItems().length; counter_++){
			if(! list_find('4,6',att_bskt_id)|| basketManagerObject.basketItems()[counter_].order_currency() != -3){ //satır asaması kapalıysa stok kontrolu yapılmaz
				if( $("#basket_main_div #order_id_listesi").val() != '' || (((list_getat(basketManagerObject.basketItems()[counter_].row_ship_id(),1,';') == 0 || basketManagerObject.basketItems()[counter_].row_ship_id() ==''))) || list_find('70,71,72,73,74,75,76,77,78,79,80,81,83,85,87,88,811,114,761,115,110,113,111,141',process_type) ){
					if(basketManagerObject.basketItems()[counter_].is_inventory() == 1){
						if(basketManagerObject.basketItems()[counter_].spect_id().length != 0 && basketManagerObject.basketItems()[counter_].spect_id() != 0){ //satırda secilen spec varsa
							var yer=list_find(spec_id_list, basketManagerObject.basketItems()[counter_].spect_id(),',');//aynı olması kucuk bir ihtimal ama koyalım cunku spec idler farklidir ama main ler ayni olabilir
							if(yer){
								top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound()));
								spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
							  }else{
								spec_id_list=spec_id_list +','+ basketManagerObject.basketItems()[counter_].spect_id();
								spec_amount_list=spec_amount_list+','+filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound());
							  }
						  }
						  //artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
						  var yer=list_find(stock_id_list,basketManagerObject.basketItems()[counter_].stock_id(),',');
						  if(yer){
							  top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound()));
							  stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						  }
						  else{
							  stock_id_list=stock_id_list+','+basketManagerObject.basketItems()[counter_].stock_id();
							  stock_amount_list=stock_amount_list+','+filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound());
						  }
						  //specli stok bakılacak ise spec secilmeyen satırların main_specleri bulunuyor
						  if(basketManagerObject.basketItems()[counter_].is_production() == 1 && (basketManagerObject.basketItems()[counter_].spect_id().length == 0 && basketManagerObject.basketItems()[counter_].spect_id() == '')){
							  var get_main_spec = wrk_safe_query("obj_get_main_spec_3",'dsn3',0, basketManagerObject.basketItems()[counter_].stock_id());
							  if(get_main_spec.recordcount){
								  var spec_amount=filterNumBasket( basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound());
								  var yer=list_find(main_spec_id_list,get_main_spec.SPECT_MAIN_ID,',');
								  if(yer){
									  var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
									  main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
								  }
								  else{
									  main_spec_id_list=main_spec_id_list+','+get_main_spec.SPECT_MAIN_ID;
									  main_spec_amount_list=main_spec_amount_list+','+spec_amount;
								  }
							  }else//urune ait main spec yoksa zaten stokta yoktur...
								  not_stock_id_list=not_stock_id_list+','+basketManagerObject.basketItems()[counter_].stock_id();
							    get_main_spec='';
						  }
						  if( basketManagerObject.basketItems()[counter_].is_production() == 1 && ( basketManagerObject.basketItems()[counter_].spect_id().length == 0 && basketManagerObject.basketItems()[counter_].spect_id() == '')){
							var yer=list_find(tree_stock_id_list, basketManagerObject.basketItems()[counter_].stock_id());
							if(yer){
								top_stock_miktar=parseFloat(list_getat(tree_stock_amount_list,yer,','))+parseFloat(filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound()));
								tree_stock_amount_list=list_setat(tree_stock_amount_list,yer,top_stock_miktar,',');
							  }
							  else{
								  if(tree_stock_id_list != ''){
									  tree_stock_id_list=tree_stock_id_list+','+basketManagerObject.basketItems()[counter_].stock_id();
									  tree_stock_amount_list=tree_stock_amount_list+','+filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound());
								  }
								  else{
									  tree_stock_id_list=tree_stock_id_list+basketManagerObject.basketItems()[counter_].stock_id();
									  tree_stock_amount_list=tree_stock_amount_list+filterNumBasket(basketManagerObject.basketItems()[counter_].amount(),basketService.amountRound());
								  }
							  }
						  }
					  }
				  }
			  }
		  }
		  
		  if(list_len(spec_id_list,',')>1){ //satırda secilen spect in sevkte birlestir urunleri
			if(!list_find('81,113', process_type)){ //depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
				//spect satirladındaki sbler için	
				var get_spect_row = wrk_safe_query('obj_get_spect_row','dsn3',0,spec_id_list);
				if(get_spect_row.recordcount){
					  for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++){
						  var spect_carpan=list_getat(spec_amount_list,list_find(spec_id_list,get_spect_row.SPECT_ID[counter_1],','),',');
						  var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
						  if(yer){
							top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],basketService.amountRound())*spect_carpan);
							stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						  }
						  else{
							stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
							stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],basketService.amountRound())*spect_carpan);
						  }
					  }
					  get_spect_row='';
				  }
			  }
			  if(popup_spec_type==1){ //specli stok bakılacaksa 
				//main spec idsini alıyor cunku bunlarında stokları varmı bakılacak
				var get_spect = wrk_safe_query('obj_get_spect','dsn3',0,spec_id_list);
				for (var counter=0; counter < get_spect.recordcount; counter++){
					var yer_1=list_find(spec_id_list,get_spect.SPECT_VAR_ID[counter],',');
					var spec_amount=list_getat(spec_amount_list,yer_1,',');
					var yer=list_find(main_spec_id_list,get_spect.SPECT_MAIN_ID[counter],',');
					if(yer){
						var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
						main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
					  }
					else{
						main_spec_id_list=main_spec_id_list+','+get_spect.SPECT_MAIN_ID[counter];
						main_spec_amount_list=main_spec_amount_list+','+spec_amount;
					}
				  }
				get_spect='';
			  }
		  }
		  
		  var stock_id_count=list_len(stock_id_list,',');
		  //karma koli bilesenleri
		  if(stock_id_count >1){
			  var karma_koli_main_spec_list='';
			  var karmakoli_main_spec_amount_list='';
			  var listParam = dsn.dsn3_alias + "*" + stock_id_list;
			  var get_karma_koli = wrk_safe_query("obj_get_karma_koli",'dsn1',0,listParam);
			  if(get_karma_koli.recordcount){
				for (var counter_1=0; counter_1 < get_karma_koli.recordcount; counter_1++){
					var stock_amount=list_getat(stock_amount_list,list_find(stock_id_list,get_karma_koli.KARMA_STOCK_ID[counter_1],','),',');
					if(popup_spec_type==1 && get_karma_koli.IS_PRODUCTION ==1 && get_karma_koli.SPEC_MAIN_ID!='' ){ //satırda main spec secilmisse ve specli stok bakılacaksa 
						karmakoli_main_spec_list=karma_koli_main_spec_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1]; //karma koli spec
						karmakoli_main_spec_amount_list=karmakoli_main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount); //karma koli specli miktar
						  
                        var yer=list_find(main_spec_id_list,get_karma_koli.SPEC_MAIN_ID[counter_1],',');
                        if(yer){
                            top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
                            main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
                        }
                        else{
                            main_spec_id_list=main_spec_id_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1];
                            main_spec_amount_list=main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
                        }
					}
					var yer=list_find(stock_id_list,get_karma_koli.STOCK_ID[counter_1],',');
					if(yer){
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else{
						stock_id_list='0';
						stock_id_list=stock_id_list+','+get_karma_koli.STOCK_ID[counter_1];
						stock_amount_list=stock_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
					}
				}
				  if( karma_koli_main_spec_list!='' && list_len(karma_koli_main_spec_list)>1){ //karma koli icerigindeki specli urunlerin sb icerikleri alınıyor
					if(!list_find('81,113', process_type)){//depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
						//spect satirlarındaki sevte birleştirilen urunler için	
						var get_spect_row = wrk_safe_query('obj_get_spect_row_2','dsn3',0,karma_koli_main_spec_list);
						if(get_spect_row.recordcount){
							for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++){
								var spect_carpan=list_getat(karmakoli_main_spec_amount_list,list_find(karma_koli_main_spec_list,get_spect_row.SPECT_ID[counter_1],','),',');
								var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
								if(yer){
									top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],basketService.amountRound())*spect_carpan);
									stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
								}
								else{
									stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
									stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],basketService.amountRound())*spect_carpan);
								}
							  }
							  get_spect_row='';
						  }
					}
				  }
				  get_karma_koli='';
			  }
		  }
		  //agactaki sevkte birlestirler
		  if(list_len(tree_stock_id_list,',')>1){
			var get_tree = wrk_safe_query('obj_get_tree','dsn3',0,tree_stock_id_list);
			if(get_tree.recordcount){
				for (var counter_1=0; counter_1 < get_tree.recordcount; counter_1++){
					var stock_amount=list_getat(tree_stock_amount_list,list_find(tree_stock_id_list,get_tree.STOCK_ID[counter_1],','),',');
					var yer=list_find(stock_id_list,get_tree.RELATED_ID[counter_1],',');
					if(yer){
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],basketService.amountRound())*stock_amount);
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					  }
					else{
						stock_id_list=stock_id_list+','+get_tree.RELATED_ID[counter_1];
						stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],basketService.amountRound())*stock_amount);
					}
				}
				  get_tree='';
			}
		  }
		  //stock kontrolleri
		  
		  if(stock_id_count >1){
              /*sipariste depo bilgisi gonderilmiyor, satılabilir stok kontrol ediliyor , stock_type=1 olarak gonderiliyor*/
			  if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined){
				if(stock_type==undefined || stock_type==0){
					if(is_update != 0){
						var listParam = dsn.dsn3_alias + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +is_update + "*" + process_type;
						var new_sql = 'obj_get_total_stock';
					  }
					  else{
						var listParam = dsn.dsn3_alias + "*" + stock_id_list + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_2';			
					  }
				}
				else{
					if(is_update != 0){
						var listParam = stock_id_list + "*" + dsn.dsn3_alias + "*" + paper_date_kontrol+ "*" +is_update;
						var new_sql='obj_get_total_stock_3';
					}						
					else{
						var listParam = stock_id_list + "*" + dsn.dsn3_alias + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_4';
					}
				}
			  }
			  else{
				  if(stock_type==undefined || stock_type==0){
                    if(is_update != 0){
                        var listParam = dsn.dsn3_alias + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id + "*" + is_update + "*" + process_type;
                        var new_sql = 'obj_get_total_stock_5';
                    }
                    else{
                        var listParam = dsn.dsn3_alias + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id;
                        var new_sql = 'obj_get_total_stock_6';
                    }
                }
				  else{ /*satıs siparisinde depoya gore kontrol yapılacaksa*/
                    var listParam = dsn.dsn3_alias + "*" + stock_id_list + "*" + dep_id + "*" + loc_id + "*" + paper_date_kontrol + "*" + is_update + "*" + dsn.dsn_alias;
                    var new_sql='obj_get_total_stock_7';
                    if(is_update != 0)
                        new_sql= 'obj_get_total_stock_8';				
				}
			  }
			  var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			  //console.log(new_sql);
			  //console.log(listParam);
			  //console.log(get_total_stock);
			  if(get_total_stock.recordcount){
				  var query_stock_id_list='0';
				  for(var cnt=0; cnt < get_total_stock.recordcount; cnt++){
					  query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					  var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					  //console.log(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]));
					  //console.log( parseFloat(list_getat(stock_amount_list,yer,',')));
					  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1){ // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					  // alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(stock_amount_list,yer,',')) )< 0) )
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					  }
					  else{
						  if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < wrk_round(parseFloat(list_getat(stock_amount_list,yer,',')),8))
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					  }
				  }
			  }
			  var diff_stock_id='0';
			  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0){ //alış tipli işlemlerde bu kontrole gerek yok
				for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++){
					var stk_id=list_getat(stock_id_list,lst_cnt,',')
					if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
						diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				  }
				  if(list_len(diff_stock_id,',')>1){
				  //bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
                    var new_sql = 'obj_get_stock_4';
                    if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
                        new_sql = 'obj_get_stock_5';
                    var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_stock_id);
                    for(var cnt=0; cnt < get_stock.recordcount; cnt++)
                        hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
				}
			  }
			  get_total_stock='';
		  }
		  //agac ile ayni bir spec hic olusmadı ise
		  /*
		  if(list_len(not_stock_id_list,',')>1)
		  {
			  var new_sql = 'obj_get_stock_4';
			  if(stock_type!=undefined && stock_type==1)
				  new_sql = 'obj_get_stock_5';
			  var get_stock = wrk_safe_query(new_sql,'dsn3',0,not_stock_id_list);
			  for(var cnt=0; cnt < get_stock.recordcount; cnt++)
				  hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
			  get_stock='';
		  }
		  Üretilen ama ağacı oluşmayan ürünlerde uyarı veriliyordu. Sebebi anlaşılmadığından kapatıldı PY  
		  */
		  //specli stok kontrolleri
		  if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1){ //sepcli stok bakılacaksa 
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined){
				if(stock_type==undefined || stock_type==0){
					if(is_update != 0){
						var listParam = dsn.dsn3_alias + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol + "*" + process_type;
						var new_sql = 'obj_get_total_stock_9';
					}
					else{
						var listParam = dsn.dsn3_alias + "*" + main_spec_id_list + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_10';
					}
				}
				else{
					if(is_update != 0){
						var listParam = main_spec_id_list + "*" + dsn.dsn3_alias + "*" + is_update + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_11';
					}
					else{			
						var listParam = main_spec_id_list + "*" + dsn.dsn3_alias + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_12';
					  }
				  }
			  }
			  else{
				  if(stock_type==undefined || stock_type==0){
					  if(is_update != 0){
						var listParam = dsn.dsn3_alias + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol + "*" + process_type;
						var new_sql = 'obj_get_total_stock_13';
					  }
					  else{
						var listParam = dsn.dsn3_alias + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol + "*" + process_type;
						var new_sql = 'obj_get_total_stock_14';
					  }
				  }
				  else{ /*satıs siparisinde depoya gore kontrol yapılacaksa*/
					var listParam = dsn.dsn3_alias + "*" + main_spec_id_list + "*" + dep_id + "*" + loc_id + "*"+ paper_date_kontrol + "*" + is_update;
					var new_sql='obj_get_total_stock_15';
					if(is_update != 0)
						new_sql='obj_get_total_stock_16';
				  }
					  //form_basket.detail.value=new_sql;
			  }
			  var get_total_stock = wrk_safe_query(new_sql,'dsn2','0',listParam);
			  var query_spec_id_list='0';
			  if(get_total_stock.recordcount){
				  for(var cnt=0; cnt < get_total_stock.recordcount; cnt++){
					  query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					  var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1){ // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					  // alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(main_spec_amount_list,yer,',')) )< 0) )
							  hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					}
					else{
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					  }
				  }
			  }
			  var diff_spec_id='0';
			  if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0){ //alış tipli işlemlerde bu kontrole gerek yok
				for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++){
					var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
					if(!list_find(query_spec_id_list,spc_id,','))
						diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
				  }
				  if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1){//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					var new_sql = 'obj_get_stock_6';
					if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
						new_sql = 'obj_get_stock_7'; //main specte secilmis mi
					var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_spec_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						  hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+') (main spec id:'+get_stock.SPECT_MAIN_ID[cnt]+')\n';
				  }
			  }
			  get_total_stock='';
		  }
	  }
	  if(lotno_hata != ''){
		  if(stock_type==undefined || stock_type==0)
			  alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
		  else
			  alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
		  lotno_hata='';
		  return false;
	  
	  }
	  else if(hata!=''){
		  if(stock_type==undefined || stock_type==0)
			  alert(hata+'\n\nYukarıdaki ürünlerde stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
		  else
			  alert(hata+'\n\nYukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
		  hata='';
		  return false;
	  }
	  else
		  return true;
  }


//ithalat ve ihracat faturalarından cagılıyor ve kdv oranları sıfırlanıyor
function reset_basket_kdv_rates(){
    reset_kdv = 0;
	if( basketManagerObject.basketItems().length ){
		for( i = 0; i < basketManagerObject.basketItems().length; i++){
			if( basketManagerObject.basketItems()[i].tax_percent() != 0 )
				reset_kdv = 1; //sıfırlanacak kdv var mı kontrol ediliyor
            }
            if(reset_kdv == 1){
                if(confirm('Ürünlerin KDV Oranları Sıfırlanacaktır!')){
                    for(var rowNum=0; rowNum < basketManagerObject.basketItems().length; rowNum++ ){
                        if( basketManagerObject.basketItems()[rowNum].tax_percent() != 0 ){
                            basketManagerObject.basketItems()[rowNum].tax_percent(0);
                            basketManagerObject.basketItems()[rowNum].tax(0);
                            satir_hesapla('tax', rowNum, 0); 
                        }
                    }
                    toplam_hesapla(1);
                }
            }
            return true;
        }
	  else 
		  return true;
  }

//ithalat ve ihracat faturalarından cagılıyor ve OTV oranları sıfırlanıyor
function reset_basket_otv_rates()  {
	reset_otv = 0;
	if( basketManagerObject.basketItems().length ){
		for(i = 0; i < basketManagerObject.basketItems().length; i++){
			if( basketManagerObject.basketItems()[i].otv_oran() != 0)
				  reset_otv=1; //sıfırlanacak OTV var mı kontrol ediliyor
		  }
		if(reset_otv == 1){
			if(confirm("Ürünlerin ÖTV Oranları Sıfırlanacaktır!")){
				for( var rowNum = 0; rowNum < basketManagerObject.basketItems().length; rowNum++ ){
					if( basketManagerObject.basketItems()[rowNum].otv_oran() != 0 ){
                        basketManagerObject.basketItems()[rowNum].otv_oran(0);
                        basketManagerObject.basketItems()[rowNum].otv(0);
						satir_hesapla('otv', rowNum, 0); 
					  }
				}
                toplam_hesapla(1);
			  }
		  }
		  return true;
	  }
	  else 
		  return true;
  }

function apply_discount(data_id){ // Basket thead'inde yer alan indirim katsayılarını satırlara yansıtır.
    currRow = eval('basketManagerObject.discount.'+data_id+'()');
    if( eval('basketManagerObject.discount.'+data_id+'()') <= 100 ){
        if( basketManagerObject.basketItems().length ){ 
            for(i = 0; i < basketManagerObject.basketItems().length; i++){
                eval('basketManagerObject.basketItems()[i].'+data_id+'('+currRow+')');
                satir_hesapla(data_id, i); 
            } 
            toplam_hesapla(1);
        }
    }else{  
        alert("Geçerli Değer Girin");
        return false;
    }

  }

function set_price_catid_options(){
    if( basketService.wmo_module == 'store' )
        var is_store_module = 1;
    else
        var is_store_module = 0;    

	  if( basketService.sale_product() == 1 )
		  is_sale_product = 1;
	  else
		  is_sale_product = 0;
		  
	  var sepet_process_obj = findObj("process_cat");
	  if(sepet_process_obj != null) 
		  selected_process_type = process_type_array[sepet_process_obj.selectedIndex]; 
	  else
		  selected_process_type = -1;	
    
    if([1,2,4,6,18,20,33,51].indexOf(basketService.basket_id()) >= 0){
		if($("#basket_main_div #card_paymethod_id").length != 0)
			var temp_card_paymethod =$("#basket_main_div #card_paymethod_id").val(); 
		else 
			var temp_card_paymethod = '';	
		if($("#basket_main_div #paymethod_vehicle").length != 0)
			var temp_paymethod_vehicle =$("#basket_main_div #temp_paymethod_vehicle").val();
		if($("#basket_main_div #paymethod_id").length != 0 &&  $("#basket_main_div #paymethod_id").val().length != 0)
		  {
			var get_pymthd_vehicle_ = wrk_safe_query('obj_get_pymthd_vehicle',"dsn",0, $("#basket_main_div #paymethod_id").val());
			if(get_pymthd_vehicle_.recordcount !=0 && get_pymthd_vehicle_.PAYMENT_VEHICLE != '')
				var temp_paymethod_vehicle=get_pymthd_vehicle_.PAYMENT_VEHICLE;
			else
				var temp_paymethod_vehicle='';
		  }
		else 
			var temp_paymethod_vehicle = '';
	}else{
		  var temp_card_paymethod = '';
		  var temp_paymethod_vehicle = '';
	}
  
	if(is_sale_product == 1){ //satıs 
        
		if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0){
			var get_credit_limit = wrk_safe_query('obj_get_credit_limit',"dsn",0,$("#basket_main_div #company_id").val());
            var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#basket_main_div #company_id").val());
            var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";
			if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1){ //sadece risk tanımında gecerli fiyat listesi gelsin
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 1) ) ';
				else
					str_price_cat_ = str_price_cat_+' 1=2 ';
				str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			}else{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
					str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 1) ) OR ';
				str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
				str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';

                if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
                    str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
                else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
                    str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
                if(is_store_module != undefined && is_store_module==1)
                    str_price_cat_ = str_price_cat_+'AND BRANCH LIKE %,'+list_getat(sessionVariable.user_location,2,'-')+',%';		
				str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			}
                var get_price_cat = wrk_query(str_price_cat_,"dsn3");
                if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
                    var selected_price_catid = get_credit_limit.PRICE_CAT;
                else if(get_price_cat.recordcount != 0)
                    var selected_price_catid=get_price_cat.PRICE_CATID;
		}else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0){
            var get_credit_limit = wrk_safe_query('obj_get_credit_limit_2',"dsn",0,$("#basket_main_div #consumer_id").val());
            var get_comp_cat = wrk_safe_query('obj_get_comp_cat_2',"dsn",0,$("#basket_main_div #consumer_id").val());
            var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE";
            if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1){
                if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
                    var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ')';
                else
                    var str_price_cat_ = str_price_cat_+' 1=2 ';
                str_price_cat_ = str_price_cat_	+'ORDER BY PRICE_CAT';
            }else{
                if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
                    var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ') OR ';
                str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
                if(window.frames["_add_prod_"].document.add_speed_prod.basket_product_list_type.value != 13)
                    str_price_cat_ = str_price_cat_+' AND CONSUMER_CAT LIKE \'%,' +get_comp_cat.CONSUMER_CAT_ID +',%\'';
                else {
                    if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
                        str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
                    else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
                        str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
                    if(is_store_module != undefined && is_store_module==1)
                        str_price_cat_ = str_price_cat_+'AND BRANCH LIKE %,'+list_getat(sessionVariable.user_location,2,'-')+',%';	
                }
                str_price_cat_ = str_price_cat_	+' ) ORDER BY PRICE_CAT';
                }
            var get_price_cat = wrk_query(str_price_cat_,"dsn3");
                
            if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
                var selected_price_catid = get_credit_limit.PRICE_CAT;
            else if(get_price_cat.recordcount != 0){
                if(is_sale_product == 1)
                    var selected_price_catid=-2;
                else
                    var selected_price_catid=-1;
            }
        }else if($("#basket_main_div #employee_id").length != 0 && $("#basket_main_div #employee_id").val().length != 0){
            var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1 ORDER BY PRICE_CAT";
            var get_price_cat = wrk_query(str_price_cat_,"dsn3");
            var selected_price_catid=get_price_cat.PRICE_CATID;
		}
	}
	else{ //alıs tipli islemler

		if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0){
			var str_price_cat_ ="SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE" ;
			var get_credit_limit = wrk_safe_query('obj_get_credit_limit_pur',"dsn",0,$("#basket_main_div #company_id").val());
			var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,$("#basket_main_div #company_id").val());
			if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_purchase.value == 1){
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 0) ) ';
				else
					str_price_cat_ = str_price_cat_+' 1=2 ';
				str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			}else{
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID =' + $("#basket_main_div #company_id").val() + ' AND PC.ACT_TYPE = 2 AND IS_DEFAULT = 1 AND PC.PURCHASE_SALES = 0) ) OR ';
				str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
				if(get_comp_cat.recordcount != 0 && get_comp_cat.COMPANYCAT_ID != '' )
				str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';
				if(window.frames["_add_prod_"].document.add_speed_prod.basket_product_list_type.value != 13)
					if(is_store_module != undefined && is_store_module==1 && selected_process_type != undefined && list_find('49,51,52,54,55,59,60,601,63,591',selected_process_type))
						str_price_cat_ = str_price_cat_+'AND BRANCH LIKE %,'+list_getat(sessionVariable.user_location,2,'-')+',%';	
				else{
					if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
				}
				str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			  }
			  
			  var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
				  var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
			  else if(get_price_cat.recordcount != 0)
				  var selected_price_catid=get_price_cat.PRICE_CATID;
			  else 
				  var selected_price_catid='-1';
		}else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0){
			var str_price_cat_ ="SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";
			var get_credit_limit = wrk_safe_query('obj_get_credit_limit_pur_2',"dsn",0,$("#basket_main_div #consumer_id").val());
		    var get_comp_cat = wrk_safe_query('obj_get_comp_cat_2',"dsn",0,$("#basket_main_div #consumer_id").val());
			  if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_purchase.value == 1){
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID = ' + get_credit_limit.PRICE_CAT_PURCHASE + ')';
				  else
					  var str_price_cat_ = str_price_cat_+' 1=2 ';
				  str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
			}else{
				  if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
					  var str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1 AND PRICE_CATID = ' + get_credit_limit.PRICE_CAT_PURCHASE + ') OR ';
					  
				  str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
			  
				  if(get_comp_cat.recordcount != 0 && get_comp_cat.CONSUMER_CAT_ID != '' )
					  str_price_cat_ = str_price_cat_+' AND CONSUMER_CAT LIKE \'%,' +get_comp_cat.CONSUMER_CAT_ID +',%\'';
				  if(window.frames["_add_prod_"].document.add_speed_prod.basket_product_list_type.value != 13)
					  if(is_store_module != undefined && is_store_module==1 && selected_process_type != undefined)
						  str_price_cat_ = str_price_cat_+'AND BRANCH LIKE %,'+list_getat(sessionVariable.user_location,2,'-')+',%';
				  else 
				  {
					  if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
					  else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
						  str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
				  }
					  
				  str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
			}
            var get_price_cat = wrk_query(str_price_cat_,"dsn3");
            if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
                var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
            else if(get_price_cat.recordcount != 0)
                var selected_price_catid=get_price_cat.PRICE_CATID;
            else 
                var selected_price_catid='-1';
		}else{
			  var str_price_cat_ ='SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1';
				  var get_price_cat = wrk_query(str_price_cat_,"dsn3");
				  
			  if(get_price_cat.recordcount != 0)
				  var selected_price_catid=get_price_cat.PRICE_CATID;
			  else 
				  var selected_price_catid='-1';
			  
		  }
	}
	  var price_cat_len = window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options.length;
	  if(price_cat_len!='') //fiyat listesi selectboxının içerigi silinip yeniden oluşturuluyor
	  { 
		for (var i = price_cat_len- 1; i>0; i--)
			window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options.remove(i);
	  }
	  if(is_sale_product == 1){
		  if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_sales.value != 1 && list_find('2',window.frames["_add_prod_"].document.add_speed_prod.basket_product_list_type.value)==0)
			  window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option(lng_standart_satis,-2);
		  else
			  window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option(lng_standart_alis,'');
	  }
	  else{
		  if(window.frames["_add_prod_"].document.add_speed_prod.dsp_only_member_price_cat_purchase.value != 1 && list_find('2',window.frames["_add_prod_"].document.add_speed_prod.basket_product_list_type.value)==0)
			  window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option(lng_standart_alis,-1);
		  else
			  window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option(lng_seciniz,'');
	  }
	  if(get_price_cat != undefined && get_price_cat.recordcount!=0)
	  {
		  for(var jj=0;jj<get_price_cat.recordcount;jj++)
			  window.frames["_add_prod_"].document.add_speed_prod.price_catid_for_speed_.options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj],false,(get_price_cat.PRICE_CATID[jj]==selected_price_catid)? true : false); //new Option(text, value, defaultSelected, selected)
	  }
}

/**
 * Raf popup
 */
function open_shelf_list(satir, satir_sayisi, list_type, field_id, field_name){
    if( basketManager.hasShownItem("shelf_number_txt") || basketManager.hasShownItem("to_shelf_number_txt") ){
        url_str = '';
        shelf_dept_name = '';
        shelf_loc_name = '';
        if(!satir)
            satir = 0;
        var data = basketManagerObject.basketItems()[satir];
        console.log(data);
        if( field_id == 'to_shelf_number'){ //depo sevk ve ambar fişindeki giriş depo,basketteki raf_no_2 alanıyla kontrol ediliyor
            if( [31,32,49].indexOf(basketService.basket_id()) >= 0 ){ // Stok Sevk İrsaliyesi,İthal Mal Girişi
                shelf_dept_name = 'department_in_id';
                shelf_loc_name = 'location_in_id';
            }
            else if( [10].indexOf(basketService.basket_id()) >= 0 ){ // Toptan Satış İrsaliyesi
                shelf_dept_name = 'department_id';
                shelf_loc_name = 'location_id';	
            }
            else if( [12].indexOf(basketService.basket_id()) >= 0 ){ // Stok Alım İrsaliyesi, Stok Fişi
                sepet_process_obj = findObj("process_cat");
                if(sepet_process_obj != null)
                    control_process_type = process_type_array[sepet_process_obj.selectedIndex];
                else
                    control_process_type = '-1';
                if(control_process_type != undefined && list_find('113', control_process_type)){ //sarf ve fire fisi icin cıkıs deposu
                    shelf_dept_name = 'department_in';
                    shelf_loc_name = 'location_in';
                }
            }
        }else{
            if( [4,6].indexOf(basketService.basket_id()) >= 0 ){ // Satış Siparişi, SatınAlma Siparişi
                shelf_dept_name = 'deliver_dept_id';
                shelf_loc_name = 'deliver_loc_id';	
            }
            else if( [14,15].indexOf(basketService.basket_id()) >= 0 ){ // Stok Alım Siparişi, Stok Satış Siparişi
                shelf_dept_name = 'department_id';
                shelf_loc_name = 'location_id';	
            }
            else if( [7].indexOf(basketService.basket_id()) >= 0 ){ // İç Talep
                shelf_dept_name = 'department_in_id';
                shelf_loc_name = 'location_in_id';	
            }
            else if( [12].indexOf(basketService.basket_id()) >= 0 ){ // Stok Fişi
                sepet_process_obj = findObj("process_cat");
                if(sepet_process_obj != null)
                    control_process_type=process_type_array[sepet_process_obj.selectedIndex];
                else
                    control_process_type='-1';
                if(control_process_type!=undefined && list_find('111,112,113',control_process_type)){ //sarf ve fire fisi icin cıkıs deposu
                    shelf_dept_name = 'department_out';
                    shelf_loc_name = 'location_out';
                }
                else{
                    shelf_dept_name = 'department_in';
                    shelf_loc_name = 'location_in';
                }
            }else{
                shelf_dept_name = 'department_id';
                shelf_loc_name = 'location_id';
            }
            console.log(shelf_dept_name + "  " + shelf_loc_name);
        }
        if(shelf_dept_name != '' && shelf_loc_name != '' && $("#basket_main_div #"+shelf_dept_name).val().length != 0 && $("#basket_main_div #"+shelf_loc_name).val().length != 0){
            var shelf_prod_id = data.product_id();
            var shelf_stock_id = data.stock_id();
            var shelf_stock_amount = filterNumBasket(data.amount(),4);
            
            sepet_process_obj = findObj("process_cat");
            if(sepet_process_obj != null)
                control_process_type=process_type_array[sepet_process_obj.selectedIndex];
            else
                control_process_type='-1';
            kontrol_out = 0;
            if(list_find('111,112,113,81',control_process_type))
                kontrol_out = 1;
            if(list_type == 0) //basket satırında acılan raf listesi
                windowopen('/index.cfm?fuseaction=objects.popup_list_shelves&kontrol_out='+kontrol_out+'&is_basket_kontrol=1&shelf_product_id='+shelf_prod_id+'&shelf_stock_id='+shelf_stock_id+'&form_name=form_basket&field_code='+field_name+'&field_id='+field_id+'&department_id='+$("#basket_main_div #"+shelf_dept_name).val()+'&location_id='+$("#basket_main_div #"+shelf_loc_name).val()+'&row_id='+satir+'&row_count='+satir_sayisi+'&satir='+satir,'small','shelf_list_page');
            else if(list_type ==1) //stok raf dagılım listesi, satır cogaltarak raflara gore dagıtım yapıyor.
                windowopen('/index.cfm?fuseaction=objects.popup_list_stock_shelf_distribution&form_name=form_basket&prod_id='+shelf_prod_id+'&stock_id='+shelf_stock_id+'&prod_amount='+shelf_stock_amount+'&department_id='+$("#basket_main_div #"+shelf_dept_name).val()+'&location_id='+$("#basket_main_div #"+shelf_loc_name).val()+'&bskt_row_id='+satir+'&bskt_row_count='+satir_sayisi+'&satir='+satir,'medium','shelf_list_page');
        }
        else
            alert(lng_once_depo_sec);
    }
}




/**
 * 
 * @param {int} row_no 
 */
// Seri No ekleme popup'ını açar.
function add_seri_no(row_no,warning)
{
        sale_product_ = 0;
        if(row_no) row_no_ = row_no;
        else row_no_ = 0;
        amount = basketManagerObject.basketItems()[row_no_].amount();
        amount_other = basketManagerObject.basketItems()[row_no_].amount_other();
        product_id = basketManagerObject.basketItems()[row_no_].product_id();
        stock_id = basketManagerObject.basketItems()[row_no_].stock_id();
        wrk_row_id = basketManagerObject.basketItems()[row_no_].wrk_row_id();
        lot_no_row = basketManagerObject.basketItems()[row_no_].lot_no();
        var location_out_id_ = '';
        var department_out_id_ = '';
        process_date_ = $("#basket_main_div #" + $("#basket_main_div #search_process_date").val()).val().toString();
        if($("#basket_main_div #is_delivered").is(":checked") == true)
            is_delivered = 1;
        else
            is_delivered = 0;
        var sepet_process_obj = findObj("process_cat");
        process_cat = process_type_array[sepet_process_obj.selectedIndex];
        if(process_cat == 811){
            if($("#basket_main_div #location_in_id").val().length != 0){
                if($("#basket_main_div #location_in_id").val() == ''){
                    alert('Giriş Depo Seçmelisiniz!');
                    return false;	
                }
                else{
                    var location_id_ = $("#basket_main_div #location_in_id").val();
                    var department_id_ = $("#basket_main_div #department_in_id").val();
                }
            }
            else{
                var location_id_ = '';
                var department_id_ = '';
            }	
            sale_product_ = 1;
        }
        else if (process_cat == 81){
            if(document.form_basket.location_id != undefined){
                var location_out_id_ = document.form_basket.location_id.value;
                var department_out_id_ = document.form_basket.department_id.value;
            }
            else{
                var location_out_id_ = '';
                var department_out_id_ = '';
            }
            sale_product_ = 1;
        }
        else if (process_cat == 111 || process_cat == 112 || process_cat == 113|| process_cat == 114|| process_cat == 115|| process_cat == 110|| process_cat == 119){
            if($("#basket_main_div #location_out").val().length != 0){
                var location_out_id_ = $("#basket_main_div #location_out").val();
                var department_out_id_ = $("#basket_main_div #department_out").val();
                var location_id_ = $("#basket_main_div #location_out").val();
                var department_id_ = $("#basket_main_div #department_out").val();
            }
            else{
                var location_out_id_ = '';
                var department_out_id_ = '';
                var location_id_ = '';
                var department_id_ = '';
            }
            if($("#basket_main_div #location_in").val().length != 0){
                var location_id_ = $("#basket_main_div #location_in").val();
                var department_id_ = $("#basket_main_div #department_in").val();
            }
            else{
                var location_id_ = '';
                var department_id_ = '';
            }
        }
        else{
            if($("#basket_main_div #location_id").val().length != 0){
                if(process_cat == 71){
                    var location_out_id_ = $("#basket_main_div #location_id").val();
                    var department_out_id_ = $("#basket_main_div #department_id").val();
                    var location_id_ = $("#basket_main_div #location_id").val();
                    var department_id_ = $("#basket_main_div #department_id").val();
                }
                else{
                    var location_id_ = $("#basket_main_div #location_id").val();
                    var department_id_ = $("#basket_main_div #department_id").val();
                }
            }
            else{
                var location_id_ = '';
                var department_id_ = '';
            }
        }
        
        if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
            company_id_ = $("#basket_main_div #company_id").val();
        else
            company_id_ = '';
        if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
            consumer_id_ = $("#basket_main_div #consumer_id").val();
        else
            consumer_id_ = '';

        if( [11,47,48,31,32,15,17,11,49,10,14].indexOf(basketService.basket_id()) >= 0 ) paper_number_ =  $("#basket_main_div #ship_number").val();
        else if( [1,2,18,20].indexOf(basketService.basket_id()) >= 0 ) paper_number_ =  $("#basket_main_div #ship_number").val();
        else if( [12].indexOf(basketService.basket_id()) >= 0 ) paper_number_ = $("#basket_main_div #fis_no_").val();
        
        if( basketService.wmo_event() == 'add' ){
             alert(warning);
            return false;
        }else{
            var win = window.open('/index.cfm?fuseaction=stock.list_serial_operations&event=det&is_line=1&is_delivered='+is_delivered+'&process_number='+paper_number_+'&product_amount='+amount+'&product_amount_2='+amount_other+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date_+'&process_cat='+process_cat+'&process_id=0&wrk_row_id='+wrk_row_id+'&lot_no='+lot_no_row+'&sale_product='+sale_product_+'&company_id='+company_id_+'&con_id='+consumer_id_+'&location_out='+location_out_id_+'&department_out='+department_out_id_+'&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id='+( sessionVariable.isBranchAuthorization == 1 ? '&is_store=1' : ''), '_blank');	
            win.focus();
        }
}

/**
 * Noktarları temizleyip virgülü uçurur.
 * @param {int} str 
 * @param {int} no_of_decimal 
 */

function filterNumBasket(str,no_of_decimal)
{
    str = str.toString();
    if (str == undefined || str.length == 0) return '';
    if(!no_of_decimal && no_of_decimal!=0)
        no_of_decimal=2;
    decimal_carpan = Math.pow(10,no_of_decimal);
    if(str!=0) return (Math.round(str*decimal_carpan)/decimal_carpan);
    else return  0;
}

// *** factory

function popup_factory(fieldName, fieldData, viewModel,headerName) {
    switch (fieldName) {
        case 'other_money':
            basketManager.setActivePopup("template_other_money", viewModel,headerName);
            break;
        case 'reason_code':
            basketManager.setActivePopup("template_reason_code", fieldData,headerName);
            break;
        case 'otv_type':
            basketManager.setActivePopup("template_otv_type", fieldData,headerName);
            break;
        case 'delivery_condition':
            basketManager.setActivePopup("template_delivery_condition", fieldData,headerName);
            break;
        case 'container_type':
            basketManager.setActivePopup("template_container_type", fieldData,headerName);
            break;
        case 'delivery_type':
            basketManager.setActivePopup("template_delivery_type", fieldData,headerName);
            break;
        case 'product_detail_popup':
            open_product_popup(fieldData);
            break;
        case 'product_price_history_popup':
            open_product_price_history(fieldData);
            break;
        case 'price_popup':
            open_price(fieldData);
            break;
        case 'basket_acc_code_popup':
            open_basket_acc_code_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'lot_no_popup':
            open_lot_no_popup(fieldData);
            break;
        case 'unit2':
            basketManager.setActivePopup("template_unit2", viewModel,headerName);
            break;
        case 'row_tevkifat_id':
            basketManager.setActivePopup("template_tevkifat_rates", viewModel,headerName);
            break;
        case 'department_popup':
            open_basket_locations(basketManagerObject.basketItems.indexOf(fieldData.items));
            break;
        case 'order_currency':
            basketManager.setActivePopup("template_order_currency", fieldData,headerName);
            break;
        case 'reserve_type':
            basketManager.setActivePopup("template_reserve_type", fieldData,headerName);
            break;
        case 'row_activity_id':
            basketManager.setActivePopup("template_activity_id", fieldData,headerName);
            break;
        case 'basket_extra_info':
            basketManager.setActivePopup("template_basket_extra_info", fieldData,headerName);
            break;
        case 'select_info_extra':
            basketManager.setActivePopup("template_select_info_extra", fieldData,headerName);
            break;
        case 'basket_exp_center_popup':
            basket_exp_center_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'basket_exp_item_popup':
            basket_exp_item_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'row_subscription_popup':
            open_subscription_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'row_assetp_popup':
            open_assetp_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'row_project_popup':
            open_basket_project_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'row_work_popup':
            open_basket_work_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'basket_employee_popup':
            open_basket_employee_popup(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'reserve_date_popup':
            get_basket_date_reserve('reserve_date', basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'deliver_date_popup':
            get_basket_date_deliver('deliver_date', basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'spect_name_popup':
            open_spec(basketManagerObject.basketItems().indexOf(fieldData.items));
            break;
        case 'shelf_list':
            open_shelf_list(basketManagerObject.basketItems().indexOf(fieldData.items), basketManagerObject.basketItems().indexOf(fieldData.items), 0, 'shelf_number', 'shelf_number_txt');
            break;
        case 'shelf_list_info':
            open_shelf_list(basketManagerObject.basketItems().indexOf(fieldData.items), basketManagerObject.basketItems().indexOf(fieldData.items), 1, 'shelf_number', 'shelf_number_txt');
            break;
        case 'to_shelf_list':
            open_shelf_list(basketManagerObject.basketItems().indexOf(fieldData.items), basketManagerObject.basketItems().indexOf(fieldData.items), 0, 'to_shelf_number', 'to_shelf_number_txt');
            break;
        default:
            break;
    }
}

function tripoint_factory(fieldName, viewModel) {
    switch (fieldName) {
        case 'product_name':
            return [{ 'name' : 'product_detail_popup', 'icon' : 'fa fa-ellipsis-v' }, { 'name' : 'product_price_history_popup', 'icon' : 'fa fa-history' }];
        case 'basket_acc_code':
            return [{ 'name' : 'basket_acc_code_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_exp_item':
            return [{ 'name' : 'basket_exp_item_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_exp_center':
            return [{ 'name' : 'basket_exp_center_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'lot_no':
            return [{ 'name' : 'lot_no_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'price':
            return [{ 'name' : 'price_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_row_departman':
            return [{ 'name' : 'department_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'row_subscription_name':
            return [{ 'name' : 'row_subscription_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'row_assetp_name':
            return [{ 'name' : 'row_assetp_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_project':
            return [{ 'name' : 'row_project_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_work':
            return [{ 'name' : 'row_work_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'basket_employee':
            return [{ 'name' : 'basket_employee_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'reserve_date':
            return [{ 'name' : 'reserve_date_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'deliver_date':
            return [{ 'name' : 'deliver_date_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'spec':
            return [{ 'name' : 'spect_name_popup', 'icon' : 'fa fa-ellipsis-v' }];
        case 'shelf_number_txt':
            return [{ 'name' : 'shelf_list', 'icon' : 'fa fa-info' }, { 'name' : 'shelf_list_info', 'icon' : 'fa fa-ellipsis-v' }];
        case 'to_shelf_number_txt':
            return [{ 'name' : 'to_shelf_list', 'icon' : 'fa fa-info' }];
        default:
            break;
    }
}

function lv_factory(fieldName, value) {
    switch (fieldName) {
        case 'delivery_condition':
            return value() == '' ? '' : basketService.get("delivery_condition").filter(m => m.ID == value())[0].TEXT;
        case 'container_type':
            return value() == '' ? '' : basketService.get("container_type").filter(m => m.ID == value())[0].TEXT;
        case 'delivery_type':
            return value() == '' ? '' : basketService.get("delivery_type").filter(m => m.ID == value())[0].TEXT;
        case 'row_tevkifat_id':
                if( value() == '' ) return_value = ''
                else if( value() == undefined ) return_value = ''
                else return_value = basketService.get("tevkifat_rates").filter(m => m.ID == value()).map(m => m.CODE.toString() + " - " + m.RATEDISP)[0];  
            return return_value;
        case 'order_currency':
            return value() == '' ? '' : basketService.get('order_currency_list').filter(m => m.ID == value())[0].TEXT;
        case 'reserve_type':
            return value() == '' ? '' : basketService.get('reserve_type_list').filter(m => m.ID == value())[0].TEXT;
        case 'row_activity_id':
            return value() == '' ? '' : basketService.get('activity_types').filter(m => m.ID == value())[0].TEXT;
        case 'select_info_extra':
            return value() == '' ? basketService.get('select_info_extra_list')[0].TEXT : basketService.get('select_info_extra_list').filter(m => m.ID == value())[0].TEXT;
        case 'basket_extra_info':
            return value() == '' ? basketService.get('basket_info_list')[0].TEXT : basketService.get('basket_info_list').filter(m => m.ID == value())[0].TEXT;
        case 'otv_type' :
            return value() == '' ? basketService.get('otv_indirim_list')[0].TEXT : basketService.get('otv_indirim_list').filter(m => m.ID == value())[0].TEXT;
        default:
            return value();
    }
}

/**
  * Makes an ajax request to the given url and calls specified function for the results
  * 
  *  @param string url 			Target url
  *  @param function callback 	Function will be called for the results with the parameters as ordered: target, data, status, jqXHR
  *  @param string data			Data as string. Default is null
  *  @param any target 			Reference object which associated the ajax request
*/
 function callURLBasket(url, callback, data, target, async){   
     // Make method POST if data parameter is specified
     var method = (data != null) ? "POST": "GET";
     $.ajax({
         async: async != null ? async: true,
         url: url,
         type: method,
         data: data,
         success: function(responseData, status, jqXHR)
         { 
             callback(target, responseData, status, jqXHR); 
         }
     });
 }
 function handlerPostBasket(target, responseData, status, jqXHR){
     responseData = $.trim(responseData);
    
     $('#working_div_main').css("display", "none");
     
     if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
     //console.log(responseData);
 
     ajax_request_script(responseData);
     //console.log(responseData);
     
     var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
     while (SCRIPT_REGEX.test(responseData)) {
         responseData = responseData.replace(SCRIPT_REGEX, "");
     }
     responseData = responseData.replace(/<!-- sil -->/g, '');
     responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');

 }



// *** init
$(document).ready(function() {
    if (basketManager.hasShownItem("deliver_dept_assorment") && basketService.basket_id() == 5 && basketManagerObject.basketItems()[0].department_array != undefined) {
        departmentArray = [];
        for (let di = 0; di < basketManagerObject.basketItems().length; di++) {
            const row = basketManagerObject.basketItems()[di];
            departmentArray[di] = [];
            for (let ri = 0; ri < row.department_array().length; ri++) {
                const dep = row.department_array()[ri];
                departmentArray[di][ri] = [];
                departmentArray[di][ri][0] = row.department_array().AMOUNT;
                departmentArray[di][ri][1] = row.department_array().DEPARTMENT_ID;
                departmentArray[di][ri][2] = row.department_array().LOCATION_ID;
            }
        }
    }
    basketManagerObject.basketFooter.basket_money.subscribe(selectedCurrency);
    setTimeout(() => { 
        basketManagerObject.basketItems().forEach(e => basketService.basketRowCalculate()('', e));
        toplam_hesapla(0) ;
    }, 500);
});