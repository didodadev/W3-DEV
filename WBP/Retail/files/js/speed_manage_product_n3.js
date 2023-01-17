show_g = 1;

function g_button_action() {

    setTimeout(function() {
        if (show_g == 1) {
            show_g = 0;
            try {
                $('#jqxgrid').jqxGrid('removegroup', 'product_cat');
            } catch (e) {

            }
            $('#jqxgrid').jqxGrid('removegroup', 'product_cat');
            grid_duzenle();
            header_duzenle();
        } else {
            show_g = 1;
            $('#jqxgrid').jqxGrid('addgroup', 'product_cat');
            grid_duzenle();
            header_duzenle();
        }
    }, 100);
}

function tum_dept_price_hide(dept_id) {
    $('div[data-role="dept_price_table"]').hide();
    show('dept_prices_' + dept_id);
}

function get_row_departments(row_id) {
    document.getElementById("message_div_main_header_info").innerHTML = 'Şube Bazlı Fiyat Tanımla';
    document.getElementById("message_div_main").style.height = 300 + "px";
    document.getElementById("message_div_main").style.width = 400 + "px";
    document.getElementById("message_div_main").style.top = (document.body.offsetHeight - 300) / 2 + "px";
    document.getElementById("message_div_main").style.left = (document.body.offsetWidth - 400) / 2 + "px";
    document.getElementById("message_div_main").style.zIndex = 99999;
    document.getElementById('message_div_main_body').style.overflowY = 'auto';


    if (parseInt(row_id) < 0) {
        dept_list = document.getElementById('head_price_departments').value;
    } else {
        dept_list = $('#jqxgrid').jqxGrid('getcellvalue', row_id, 'price_departments');
    }
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_departments&row_id=' + row_id + '&dept_list=' + dept_list, 'message_div_main_body');
    show('message_div_main');
}

function get_pro_prices(row_id) {
    document.getElementById("message_div_main_header_info").innerHTML = 'Fiyat Yazılmamış Teklifler';
    document.getElementById("message_div_main").style.height = 350 + "px";
    document.getElementById("message_div_main").style.width = 1100 + "px";
    document.getElementById("message_div_main").style.top = (document.body.offsetHeight - 350) / 2 + "px";
    document.getElementById("message_div_main").style.left = (document.body.offsetWidth - 1100) / 2 + "px";
    document.getElementById("message_div_main").style.zIndex = 99999;
    document.getElementById('message_div_main_body').style.overflowY = 'auto';

    sayi_ = $('#jqxgrid').jqxGrid('getcellvalue', row_id, 'product_price_change_count');
    parcala_ = $('#jqxgrid').jqxGrid('getcellvalue', row_id, 'product_price_change_detail');

    if (sayi_ > 0) {
        icerik_ = '<table border="1" cellpadding="2" cellspacing="0">';
        icerik_ += '<thead>';
        icerik_ += '<tr class="color-list" style="height:25px;">';
        icerik_ += '<th class="formbold" style="background-color:#66cdaa;">Fiyat Tipi</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Br. Alş Kdvsiz</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">İskonto Yüzde</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">İskonto Tutar</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. KDVsiz</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. KDVli</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Baş.</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Btş.</th>';
        icerik_ += '<th class="formbold" style="background-color:#ffebcd;">Al. Kar</th>';
        icerik_ += '<th class="formbold" style="background-color:#66cdaa;">A. Aktif</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Fiyat</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş KDVli</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">GF Ort. D.</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Kar</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Baş.</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Stş Btş.</th>';
        icerik_ += '<th class="formbold" style="background-color:#66cdaa;">S. Aktif</th>';
        icerik_ += '<th class="formbold" style="background-color:#deb887;">Vade</th>';
        icerik_ += '<th class="formbold">Mağaza</th>';
        icerik_ += '</tr>';
        icerik_ += '</thead>';
        icerik_ += '<tbody>';


        for (var m = 1; m <= sayi_; m++) {
            sira_eleman_ = list_getat(parcala_, m, '*');
            if (sira_eleman_ != '') {
                icerik_ += '<tr>';
                try {
                    for (var k = 2; k <= 20; k++) {
                        if (k == 2 || k == 11 || k == 18)
                            icerik_ += '<td style="background-color:#66cdaa;">';
                        else if (k < 11)
                            icerik_ += '<td style="background-color:#ffebcd;">';
                        else
                            icerik_ += '<td style="background-color:#deb887;">';
                        sira_no_ = k;
                        if (sira_no_ == 2) {
                            deger_ = parseInt(list_getat(sira_eleman_, k, ';'));
                            if (deger_ != '')
                                icerik_ += '<a href="javascript://" class="tableyazi" onclick="change_pro_prices(' + row_id + ',' + m + ')">' + eval("j_price_type_" + deger_) + '</a>';
                        } else {
                            if (k == 11 || k == 18) {
                                if (list_getat(sira_eleman_, 11, ';') == 0 && list_getat(sira_eleman_, 18, ';') == 0)
                                    icerik_ += 'Teklif';
                                else
                                    icerik_ += list_getat(sira_eleman_, k, ';');
                            } else
                                icerik_ += list_getat(sira_eleman_, k, ';');
                        }
                        icerik_ += '</td>';
                    }
                } catch (e) {
                    alert(sira_eleman_);
                    alert(sira_no_);
                }
            }

            icerik_ += '<td><a href="javascript://" onclick="del_pro_prices(' + row_id + ',' + m + ')"><img src="/images/delete_list.gif"></a></td>';
            icerik_ += '</tr>';
        }

        icerik_ += '</tbody>';
        icerik_ += '</table>';
    } else {
        icerik_ = 'Bu Ürün İçin Fiyat Tanımı Yapılmamış!';
    }

    document.getElementById('message_div_main_body').innerHTML = icerik_;
    show('message_div_main');
}

function change_pro_prices(product_id, fiyat_sira) {
    sayi_ = document.getElementById('product_price_change_count_' + product_id).value;
    parcala_ = document.getElementById('product_price_change_detail_' + product_id).value;

    if (sayi_ > 0) {
        for (var m = 1; m <= sayi_; m++) {
            if (m == fiyat_sira) {
                sira_eleman_ = list_getat(parcala_, m, '*');
                for (var k = 2; k <= 20; k++) {
                    //icerik_ += '<td>';
                    sira_no_ = k;

                    deger_ = list_getat(sira_eleman_, k, ';');

                    if (sira_no_ == 2)
                        document.getElementById('price_type_' + product_id).value = deger_;

                    if (sira_no_ == 3)
                        document.getElementById('NEW_ALIS_START_' + product_id).value = deger_;

                    if (sira_no_ == 4)
                        document.getElementById('sales_discount_' + product_id).value = deger_;

                    if (sira_no_ == 5)
                        document.getElementById('p_discount_manuel_' + product_id).value = deger_;

                    if (sira_no_ == 6)
                        document.getElementById('NEW_ALIS_' + product_id).value = deger_;

                    if (sira_no_ == 7)
                        document.getElementById('NEW_ALIS_KDVLI_' + product_id).value = deger_;

                    if (sira_no_ == 8)
                        document.getElementById('p_startdate_' + product_id).value = deger_;

                    if (sira_no_ == 9)
                        document.getElementById('p_finishdate_' + product_id).value = deger_;

                    if (sira_no_ == 10)
                        document.getElementById('p_marj_' + product_id).value = deger_;

                    if (sira_no_ == 11) {
                        if (deger_ == 1)
                            document.getElementById('is_active_p_' + product_id).checked = true;
                        else
                            document.getElementById('is_active_p_' + product_id).checked = false;
                    }

                    if (sira_no_ == 12)
                        document.getElementById('FIRST_SATIS_PRICE_' + product_id).value = deger_;

                    if (sira_no_ == 13)
                        document.getElementById('FIRST_SATIS_PRICE_KDV_' + product_id).value = deger_;

                    if (sira_no_ == 14)
                        document.getElementById('READ_FIRST_SATIS_PRICE_RATE_' + product_id).value = deger_;

                    if (sira_no_ == 15)
                        document.getElementById('p_ss_marj_' + product_id).value = deger_;

                    if (sira_no_ == 16)
                        document.getElementById('startdate_' + product_id).value = deger_;

                    if (sira_no_ == 17)
                        document.getElementById('finishdate_' + product_id).value = deger_;

                    if (sira_no_ == 18) {
                        if (deger_ == 1)
                            document.getElementById('is_active_s_' + product_id).checked = true;
                        else
                            document.getElementById('is_active_s_' + product_id).checked = false;
                    }

                    if (sira_no_ == 19)
                        document.getElementById('p_dueday_' + product_id).value = deger_;

                    if (sira_no_ == 20) {
                        document.getElementById('product_price_change_lastrowid_' + product_id).value = deger_;
                    }
                }
            }
        }
    }
    del_pro_prices(row_id, fiyat_sira);
    //p_discount_calc(product_id);
}

function del_pro_prices(row_id, fiyat_sira) {
    document.getElementById('message_div_main_body').innerHTML = 'Bekleyiniz!';

    sayi_ = $('#jqxgrid').jqxGrid('getcellvalue', row_id, 'product_price_change_count');
    parcala_ = $('#jqxgrid').jqxGrid('getcellvalue', row_id, 'product_price_change_detail');

    new_list_ = '';


    for (var sm = 1; sm <= sayi_; sm++) {
        if (sm != fiyat_sira) {
            sira_eleman_ = list_getat(parcala_, sm, '*');

            if (new_list_ != '') {
                new_list_ += '*' + sira_eleman_;
            } else {
                new_list_ = sira_eleman_;
            }
        }
    }

    $('#jqxgrid').jqxGrid('setcellvalue', row_id, 'product_price_change_count', parseInt(sayi_ - 1));
    $('#jqxgrid').jqxGrid('setcellvalue', row_id, 'product_price_change_detail', new_list_);

    get_pro_prices(row_id);
}

function first_satis_price_renderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
    ret_p = ret.product_id;
    ret_t = ret.row_type;

    img_ = '<img style="margin-left:10px;margin-top:8px;" src="/images/pod_edit.gif"/>';

    if (ret_t == 1)
        return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px; text-align:right;">' + commaSplit(value) + '</td><td width="15">' + '<a onclick="open_price_window(' + row + ');" style="float:left;">' + img_ + '</a></td><td width="2"></td></tr></table>';
    else
        return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px;">' + value + '</td><tr></table>';
}

function companyrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

    ret = ret.product_code;
    r_product = list_getat(ret, 1, '_');
    r_stock = list_getat(ret, 2, '_');

    if (r_stock == 0) {
        img_ = '<img style="margin-left:10px;margin-top:8px;" src="/images/plus_list.gif"/>';
        return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px;">' + value + '</td><td width="15">' + '<a onclick="open_company_list(' + row + ');" style="float:left;">' + img_ + '</a></td><td width="2"></td></tr></table>';
    }
}

function cellsrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    if (value < 0) {
        return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color:red;">' + commaSplit(value) + '</span>';
    } else {
        return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + ';">' + commaSplit(value) + '</span>';
    }
}

function cellsrenderer2(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    {
        return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color:orange;">' + commaSplit(value) + '</span>';
    }
}

function pricedetailrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    if (value != '') {
        var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
        ret = ret.product_code;
        r_product = list_getat(ret, 1, '_');
        var imajlar = '<a onclick="get_product_price_detail(' + r_product + ',' + row + ');" style="float:left;">' + '<img style="margin-left:5px;margin-top:8px;" src="/images/fiyatlar.gif"/>' + '</a>';
        if (usertype_ == 0) {
            imajlar += '<a onclick="set_new_price(' + row + ',0,1);" style="float:left;">' + '<img style="margin-left:3px;margin-top:7px;" src="/images/menu_shop.gif"/>' + '</a>';
            imajlar += '<a onclick="get_pro_prices(' + row + ');" style="float:left;">' + '<img style="margin-left:3px;margin-top:5px;" src="/images/shema_list.gif"/>' + '</a>';
            imajlar += '<a onclick="get_row_departments(' + row + ');" style="float:left;">' + '<img style="margin-left:3px;margin-top:2px;" src="/images/branch_black.gif"/>' + '</a>';
        }
        return imajlar;
    }
}

function rivalrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    if (value != '') {
        var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
        ret = ret.product_code;
        r_product = list_getat(ret, 1, '_');
        return '<a onclick="get_rival_price_list(' + r_product + ');" style="color:blue;font-weight:bold;margin-right:2px;margin-top:5px;float: ' + columnproperties.cellsalign + '">' + commaSplit(value) + '</button>';
    }
}

function stockdetayrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
    ret = ret.product_code;
    r_product = list_getat(ret, 1, '_');
    r_stock = list_getat(ret, 2, '_');
    if (r_stock == 0)
        return '<a onclick="get_stock_list(' + r_product + ',\'product\');" style="font-weight:bold;margin-right:2px;margin-top:5px;float: ' + columnproperties.cellsalign + '">' + commaSplit(value) + '</a>';
    else
        return '<a onclick="get_stock_list(' + r_stock + ',\'stock\');" style="font-weight:bold;margin-right:2px;margin-top:5px;float: ' + columnproperties.cellsalign + '">' + commaSplit(value) + '</a>';
}

function yoldakistokrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
    pname_ = ret.product_name;
    ret = ret.product_code;
    r_product = list_getat(ret, 1, '_');
    r_stock = list_getat(ret, 2, '_');

    return '<a onclick="get_yoldaki_stok(' + r_product + ',\'' + pname_ + '\');" style="color:#FF00CC;font-weight:bold;margin-right:2px;margin-top:5px;float: ' + columnproperties.cellsalign + '">' + commaSplit(value) + '</a>';
}

function maliyetrenderer(row, columnfield, value, defaulthtml, columnproperties, rowdata) {
    if (value != '') {
        var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
        r_stock = ret.stock_id;
        ret_p = ret.product_code;
        r_product = list_getat(ret_p, 1, '_');
        if (r_stock != '')
            return '<a onclick="get_cost_list(' + r_product + ',' + r_stock + ');" style="color:blue;font-weight:bold;margin-right:2px;margin-top:5px;float: ' + columnproperties.cellsalign + '">' + commaSplit(value) + '</a>';
    }
}

function get_standart_dates() {
    $("#jqxgrid").jqxGrid('beginupdate');
    old_ = $("#jqxgrid").jqxGrid('getcolumnproperty', 'standart_alis', 'hidden');

    if (old_ == false) {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_baslangic', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_baslangic', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'eski_standart_alis_kdvli', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_indirim_yuzde', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_indirim_tutar', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_oran', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_liste', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_kdvli', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_kar', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_kar', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_kdv', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'eski_standart_satis_kdvli', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'is_standart_satis_aktif', 'hidden', true);
    } else {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_baslangic', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_baslangic', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'eski_standart_alis_kdvli', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_indirim_yuzde', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_indirim_tutar', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_oran', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_liste', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_kdvli', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_alis_kar', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_kar', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'standart_satis_kdv', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'eski_standart_satis_kdvli', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'is_standart_satis_aktif', 'hidden', false);
    }
    $("#jqxgrid").jqxGrid('endupdate');
}

function get_activite_dates() {
    $("#jqxgrid").jqxGrid('beginupdate');
    old_ = $("#jqxgrid").jqxGrid('getcolumnproperty', 'startdate', 'hidden');

    if (old_ == false) {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'startdate', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'finishdate', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'p_startdate', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'p_finishdate', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'price_type', 'hidden', true);
    } else {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'startdate', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'finishdate', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'p_startdate', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'p_finishdate', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'price_type', 'hidden', false);
    }
    $("#jqxgrid").jqxGrid('endupdate');
}

function get_siparis_dates() {
    $("#jqxgrid").jqxGrid('beginupdate');
    old_ = $("#jqxgrid").jqxGrid('getcolumnproperty', 'siparis_tarih_1', 'hidden');

    if (old_ == false) {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tarih_1', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_onay', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_k', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_p', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_1', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_kdv_1', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'oneri_siparis', 'hidden', true);
    } else {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tarih_1', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_onay', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_k', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_p', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_1', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_kdv_1', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'oneri_siparis', 'hidden', false);
    }
    $("#jqxgrid").jqxGrid('endupdate');
}

function get_siparis_dates2() {
    $("#jqxgrid").jqxGrid('beginupdate');
    old_ = $("#jqxgrid").jqxGrid('getcolumnproperty', 'siparis_tarih_2', 'hidden');

    if (old_ == false) {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tarih_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_onay_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_k_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_p_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_kdv_2', 'hidden', true);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'oneri_siparis2', 'hidden', true);
    } else {
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tarih_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_onay_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_k_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_miktar_p_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'siparis_tutar_kdv_2', 'hidden', false);
        $("#jqxgrid").jqxGrid('setcolumnproperty', 'oneri_siparis2', 'hidden', false);
    }
    $("#jqxgrid").jqxGrid('endupdate');
}


function grid_duzenle() {
    var position = $('#jqxgrid').jqxGrid('scrollposition');
    $("#jqxgrid").jqxGrid('applyfilters');
    var left_ = position.left;
    var top_ = position.top;
    $('#jqxgrid').jqxGrid('scrolloffset', top_, left_);
    hide('message_div_main');
}

function header_duzenle() {
    $("#div_active_row").jqxCheckBox({ width: 20, height: 20, checked: true });
    $("#div_is_purchase").jqxCheckBox({ width: 20, height: 20, checked: true });
    $("#div_is_sales").jqxCheckBox({ width: 20, height: 20, checked: true });
    $("#div_is_purchase_c").jqxCheckBox({ width: 20, height: 20, checked: true });
    $("#div_is_purchase_m").jqxCheckBox({ width: 20, height: 20, checked: true });
    $("#div_is_active_p").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_is_active_s").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_siparis_onay").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_siparis_onay_2").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_siparis_sevk").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_siparis_sevk_2").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_is_standart_satis_aktif").jqxCheckBox({ width: 20, height: 20, checked: false });
    $("#div_p_product_type").jqxCheckBox({ width: 20, height: 20, checked: true });
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=product_name', 'div_product_name');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=standart_alis_baslangic', 'div_standart_alis_baslangic');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=startdate', 'div_startdate');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=finishdate', 'div_finishdate');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=startdate', 'div_startdate');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=standart_satis_baslangic', 'div_standart_satis_baslangic');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=p_startdate', 'div_p_startdate');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=p_finishdate', 'div_p_finishdate');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=standart_satis_kar', 'div_standart_satis_kar');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=p_ss_marj', 'div_p_ss_marj');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=standart_satis_kdv', 'div_standart_satis_kdv');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=price_type', 'div_price_type');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=siparis_miktar', 'div_siparis_miktar');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=siparis_miktar_2', 'div_siparis_miktar_2');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=siparis_miktar_k', 'div_siparis_miktar_k');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=siparis_miktar_k_2', 'div_siparis_miktar_k_2');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=company_name', 'div_company_name');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=product_id', 'div_product_id');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=add_stock_gun', 'div_add_stock_gun');
    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_table_object&type=dueday', 'div_dueday');
    $("#div_active_row").change(function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getdisplayrows');
        var eleman_sayisi = rows.length;

        var rows_all = $('#jqxgrid').jqxGrid('getboundrows');

        deger_ = 0;
        for (var m = 0; m < eleman_sayisi; m++) {
            var data = $('#jqxgrid').jqxGrid('getrowboundindex', m);
            if (data != undefined) {
                rows_all[data].active_row = checked;
                alt_sayisi_ = parseInt(rows_all[data].sub_rows_count);
                if (alt_sayisi_ > 0) {
                    for (var cc = 1; cc <= alt_sayisi_; cc++) {
                        rows_all[data + cc].active_row = checked;
                    }
                }
                //$("#jqxgrid").jqxGrid('setcellvalue',data,"active_row",checked)
            }
        }
        grid_duzenle();
    });

    $("#div_p_product_type").change(function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        deger_ = 0;
        for (var m = 0; m < eleman_sayisi; m++) {
            rows[m].p_product_type = checked;
        }
        grid_duzenle();
    });

    $("#div_is_purchase").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_purchase = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_purchase_c").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_purchase_c = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_purchase_m").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_purchase_m = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_sales").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_sales = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_active_p").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_active_p = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_active_s").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_active_s = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_siparis_onay").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].siparis_onay = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_siparis_onay_2").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].siparis_onay_2 = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_siparis_sevk").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].siparis_sevk = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_siparis_sevk_2").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].siparis_sevk_2 = checked;
            }
        }
        grid_duzenle();
    });

    $("#div_is_standart_satis_aktif").bind('change', function(event) {
        var checked = event.args.checked;
        var rows = $('#jqxgrid').jqxGrid('getboundrows');
        var eleman_sayisi = rows.length;

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                rows[m].is_standart_satis_aktif = checked;
            }
        }
        grid_duzenle();
    });
}

function cellbeginedit_stok_c(row, datafield, columntype, value) {
    var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
    ret_p = ret.row_type;
    if (ret_p == '2' || ret_p == '3') {
        alert('Bu Alan Değiştirilemez!');
        $("#jqxgrid").jqxGrid('setcellvalue', row, datafield, false);

        return false;
    } else {
        var row_all = jQuery("#jqxgrid").jqxGrid('getRowData', row);
        ret_p = row_all.row_type;
        alt_eleman_sayisi = row_all.sub_rows_count;

        if (ret_p == '1' && alt_eleman_sayisi > 0) {
            dongu_ = parseInt(row) + parseInt(alt_eleman_sayisi);
            for (var cc = row; cc <= dongu_; cc++) {
                row_tipi = $('#jqxgrid').jqxGrid('getcellvalue', cc, 'row_type');

                if (row_tipi != '1') {
                    if (value == false)
                        $("#jqxgrid").jqxGrid('setcellvalue', cc, "active_row", true);
                    else
                        $("#jqxgrid").jqxGrid('setcellvalue', cc, "active_row", false);
                }
            }
        } else if (ret_p == '1') {
            $("#jqxgrid").jqxGrid('setcellvalue', row, "active_row", value);
        } else {
            $("#jqxgrid").jqxGrid('setcellvalue', row, "active_row", value);
            return false;
        }
    }
}

function cellclass(row, datafield, value, rowdata) {
    if (page_loaded == 0) {
        //console.log('burada');
        return "" + datafield + "css";
    } else {
        var cells = $('#jqxgrid').jqxGrid('getselectedcells');
        c_eleman_sayisi = cells.length;
        //console.log(c_eleman_sayisi);

        for (var m = 0; m < c_eleman_sayisi; m++) {
            var cell = cells[m];
            row_ = cell.rowindex;

            if (row_ == row && datafield != cell.datafield) {
                return "selectedclassRow";
            } else {
                return "" + datafield + "css";
            }
        }
    }
}

function input_control() {
    if (document.search_product.calc_type.value == '1' || document.search_product.calc_type.value == '3') {
        $("#jqxgrid").jqxGrid('clearfilters');
        var rows = $("#jqxgrid").jqxGrid('getboundrows');
        eleman_sayisi = rows.length;

        selected_ = '';
        for (var ccm = 0; ccm < eleman_sayisi; ccm++) {
            product_id_ = rows[ccm].product_id;
            active_ = rows[ccm].active_row;
            if (product_id_ != '' && active_ == true) {
                if (selected_ == '')
                    selected_ = product_id_;
                else
                    selected_ += ',' + product_id_;
            }
        }
        document.getElementById('search_selected_product_list').value = selected_;

        if (document.getElementById('search_selected_product_list').value == '') {
            alert('Sipariş Hesaplamak İstediğiniz Satırları Seçiniz!');
            return false;
        }
    }
    return true;
}

function handleKeys(event) {
    tus_islem = 1;
    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;

    action_key_list = '19,112,113,114,115,116,117,118,119,120,121,27';
    hareket_key_list = '37,38,39,40';

    if (!(list_find(action_key_list, key) || list_find(hareket_key_list, key))) // 
    {
        return false;
    }
    if (list_find(hareket_key_list, key)) {
        var rows = $('#jqxgrid').jqxGrid('getdisplayrows');
        var eleman_sayisi = rows.length;

        row_list_ = 'a';
        for (var i = 0; i < eleman_sayisi; i++) {
            try {
                var data = $('#jqxgrid').jqxGrid('getrowboundindex', i);
                if (data != undefined) {
                    row_list_ = row_list_ + ',' + data;
                }
            } catch (e) {}
        }
        gercek_satir_sayisi_ = list_len(row_list_);

        var cell = $('#jqxgrid').jqxGrid('getselectedcell');
        var row = cell.rowindex;
        var alan_ = cell.datafield;

        if (key == 38) //ust
        {
            sira_ = list_find(row_list_, row);
            if (sira_ == 2)
                next_row_ = list_getat(row_list_, gercek_satir_sayisi_);
            else
                next_row_ = list_getat(row_list_, sira_ - 1);
            $('#jqxgrid').jqxGrid('endcelledit', row, alan_, false);
            $('#jqxgrid').jqxGrid('unselectcell', row, alan_);
            $('#jqxgrid').jqxGrid('selectcell', next_row_, alan_);
            return true;
        } else if (key == 40) //alt
        {
            sira_ = list_find(row_list_, row);
            if (sira_ == gercek_satir_sayisi_)
                next_row_ = 0;
            else
                next_row_ = list_getat(row_list_, sira_ + 1);
            $('#jqxgrid').jqxGrid('endcelledit', row, alan_, false);
            $('#jqxgrid').jqxGrid('unselectcell', row, alan_);
            $('#jqxgrid').jqxGrid('selectcell', next_row_, alan_);
            return true;
        } else if (key == 37) //sol
        {
            kolonlar_ = document.getElementById('layout_sort_list').value;
            kolon_sayi_ = list_len(kolonlar_);
            sira_ = list_find(kolonlar_, alan_);

            if (sira_ == 1)
                new_col_ = list_getat(kolonlar_, kolon_sayi_);
            else
                new_col_ = list_getat(kolonlar_, sira_ - 1);

            $('#jqxgrid').jqxGrid('endcelledit', row, alan_, false);
            $('#jqxgrid').jqxGrid('unselectcell', row, alan_);
            $('#jqxgrid').jqxGrid('selectcell', row, new_col_);
            return true;
        } else if (key == 39) //sag
        {
            kolonlar_ = document.getElementById('layout_sort_list').value;
            kolon_sayi_ = list_len(kolonlar_);
            sira_ = list_find(kolonlar_, alan_);

            if (sira_ == kolon_sayi_)
                new_col_ = list_getat(kolonlar_, 1);
            else
                new_col_ = list_getat(kolonlar_, sira_ + 1);

            $('#jqxgrid').jqxGrid('endcelledit', row, alan_, false);
            $('#jqxgrid').jqxGrid('unselectcell', row, alan_);
            $('#jqxgrid').jqxGrid('selectcell', row, new_col_);
            return true;
        }
    } else if (list_find(action_key_list, key)) {
        if (key == 112) //F1 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_product_price_detail(r_product, row);
            return true;
        } else if (key == 113) //F2 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret_row.product_code;
            ret_type = ret_row.row_type;

            r_product = list_getat(ret, 1, '_');
            r_stock = list_getat(ret, 2, '_');
            r_dept = list_getat(ret, 3, '_');

            if (ret_type == 3) {
                get_stock_list(r_stock, 'department', r_dept);
            } else {
                if (r_stock == 0) {
                    get_stock_list(r_product, 'product', r_dept);
                } else
                    get_stock_list(r_stock, 'stock', r_dept);
            }
            return true;
        } else if (key == 114) //F3 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_product_relateds(r_product);
            return true;
        } else if (key == 115) //F4 tusuna gorev atama
        {
            seller_limit_table();
            return true;
        } else if (key == 116) //F5 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_rival_price_list(r_product);
            return true;
        } else if (key == 117) //F6 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_product_detail(r_product);
            tus_islem = 0;
            return true;
        } else if (key == 118) //F7 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_product_detail_send(r_product);
            return true;
        } else if (key == 119) //F8 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');

            get_product_detail_send_stock(r_product);
            return true;
        } else if (key == 120) //F9 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');
            r_stock = list_getat(ret, 2, '_');

            get_cost_list(r_product, r_stock);
            return true;
        } else if (key == 121) //F10 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret_row_type = ret_row.row_type;

            if (ret_row_type == 1)
                get_product_kare_bedeli(row);
            else
                alert('Uygulamalara Sadece Ürün Satırından Gidebilirsiniz!');
            return true;
        } else if (key == 19) //pause tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret.product_code;
            r_product = list_getat(ret, 1, '_');
            r_stock = list_getat(ret, 2, '_');

            get_product_tranfers(r_product, r_stock);
            return true;
        } else if (key == 27) {
            try {
                ColdFusion.Window.destroy('price_window', true);
            } catch (e) {}
            f1_pop = 0;

            try {
                ColdFusion.Window.destroy('stock_window', true);
            } catch (e) {}
            f2_pop = 0;

            try {
                ColdFusion.Window.destroy('product_others', true);
            } catch (e) {}
            f3_pop = 0;

            try {
                ColdFusion.Window.destroy('seller_limit', true);
            } catch (e) {}
            f4_pop = 0;

            try {
                ColdFusion.Window.destroy('rival_window', true);
            } catch (e) {}
            f5_pop = 0;

            try {
                ColdFusion.Window.destroy('product_detail_window', true);
            } catch (e) {}
            f6_pop = 0;

            try {
                ColdFusion.Window.destroy('cost_window', true);
            } catch (e) {}
            f9_pop = 0;

            try {
                ColdFusion.Window.destroy('p_transfer_window', true);
            } catch (e) {}
            p_pop = 0;

            $('#jqxgrid').jqxGrid('focus');
            return true;
        }
    }
}

function print_gonder(deger) {
    if (document.getElementById('order_list').value == '-0')
        document.getElementById('order_list').value = deger;
    else
        document.getElementById('order_list').value = document.getElementById('order_list').value + "," + deger;
}

function gonder_print_f() {
    adres_ = 'index.cfm?fuseaction=retail.popup_print_siparis&iframe=1';
    adres_ = adres_ + '&select_order=' + document.getElementById('order_list').value;
    windowopen(adres_, 'page', 'print_popup_siparis');
}

function print_screen() {
    if (f_print == 0) {
        alert('Yapılan Düzenlemeyi Kayıt Etmeden Print Çıktı Alamazsınız');
        return false;
    }

    var rows_all = $('#jqxgrid').jqxGrid('getboundrows');
    var rows = $('#jqxgrid').jqxGrid('getdisplayrows');

    row_list_ = '';

    for (var i = 0; i < rows.length; i++) {
        try {
            var data = $('#jqxgrid').jqxGrid('getrowboundindex', i);
            if (row_list_ == '')
                row_list_ = data;
            else
                row_list_ = row_list_ + ',' + data;
        } catch (e) {}
    }
    document.getElementById('print_note').value = JSON.stringify(rows_all);
    document.getElementById('print_table_code').value = document.getElementById('table_code').value;
    document.getElementById('row_list').value = row_list_;

    windowopen('', 'white_board', 'print_window');
    document.print_form.action = 'index.cfm?fuseaction=retail.popup_print_speed_manage_product';
    document.print_form.target = 'print_window';
    document.print_form.submit();
}

function update_order() {
    if (document.info_form.order_code.value == '' && document.info_form.order_id.value == '' && document.info_form.order_company_code.value == '') {
        alert('Güncelleme Yapabileceğiniz Bir Sipariş Bulunamadı!');
        return false;
    }

    $("#jqxgrid").jqxGrid('clearfilters');
    var rows = $('#jqxgrid').jqxGrid('getboundrows');

    document.getElementById('print_note').value = JSON.stringify(rows);
    document.print_form.order_company_order_list.value = document.info_form.order_company_order_list.value;

    adress_ = 'index.cfm?fuseaction=retail.popup_update_order_speed_manage_product';
    if (document.info_form.order_code.value != '') {
        adress_ = adress_ + '&order_code=' + document.info_form.order_code.value;
    }
    if (document.info_form.order_id.value != '') {
        adress_ = adress_ + '&order_id=' + document.info_form.order_id.value;
    }
    if (document.info_form.order_company_code.value != '') {
        adress_ = adress_ + '&order_company_code=' + document.info_form.order_company_code.value;
        adress_ = adress_ + '&order_date=' + document.info_form.order_date.value;
    }

    adress_ = adress_ + '&department_id_list=' + document.info_form.department_id_list.value;

    windowopen('', 'white_board', 'update_order_window');
    document.print_form.action = adress_;
    document.print_form.target = 'update_order_window';
    document.print_form.submit();
}

function gonder_price_new(r_row_id, price, discount_list, manuel_discount, row_id, start_, finish_, p_start_, p_finish_, margin_, p_margin_, satis_, satis_kdv_, p_type_, is_active_s_, is_active_p_, new_alis_, new_alis_kdvli_, p_product_type_, d_list) {
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'new_alis_start', filterNum(price));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'sales_discount', discount_list);
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_discount_manuel', filterNum(manuel_discount));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'new_alis', filterNum(new_alis_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'new_alis_kdvli', filterNum(new_alis_kdvli_));

    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'startdate', start_);
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'finishdate', finish_);
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_startdate', p_start_);
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_finishdate', p_finish_);

    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'product_price_change_lastrowid', row_id);
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_ss_marj', filterNum(margin_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'alis_kar', filterNum(p_margin_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'first_satis_price', filterNum(satis_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'first_satis_price_kdv', filterNum(satis_kdv_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'price_type', eval('j_price_type_' + p_type_));
    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'price_type_id', p_type_);
    if (is_active_s_ == 0)
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'is_active_s', false);
    else
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'is_active_s', true);

    if (is_active_p_ == 0)
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'is_active_p', false);
    else
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'is_active_p', true);

    if (p_product_type_ == 0)
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_product_type', false);
    else
        $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'p_product_type', true);

    $("#jqxgrid").jqxGrid('setcellvalue', r_row_id, 'price_departments', d_list);

    hesapla_satis(r_row_id, 'kdvli', 'first_satis_price_kdv', filterNum(satis_kdv_));
    get_product_price_detail();
    grid_duzenle();
    //hesapla_satis(r_row_id,'kdvli','first_satis_price_kdv',filterNum(satis_kdv_));
    //p_discount_calc(r_row_id,'new_alis_start',filterNum(price));
}

function goster_seller_limit_rows(pcat) {
    rel_ = "row_code='product_cat_" + pcat + "'";
    col1 = $("#manage_table_seller_limit_all tr[" + rel_ + "]");
    col1.toggle();
}

function goster_seller_limit_rows_eksi(pcat) {
    rel_ = "row_code='product_cat_" + pcat + "'";
    col1 = $("#manage_table_seller_limit_eksi tr[" + rel_ + "]");
    col1.toggle();
}

function goster_seller_limit_rows_arti(pcat) {
    rel_ = "row_code='product_cat_" + pcat + "'";
    col1 = $("#manage_table_seller_limit_arti tr[" + rel_ + "]");
    col1.toggle();
}

function get_seller_table(type) {
    $("#manage_table_seller_limit_eksi").hide();
    $("#manage_table_seller_limit_all").hide();
    $("#manage_table_seller_limit_arti").hide();

    if (type == '0')
        $("#manage_table_seller_limit_eksi").show();
    else if (type == '1')
        $("#manage_table_seller_limit_arti").show();
    else
        $("#manage_table_seller_limit_all").show();
}


function add_product() {
    adres_ = 'index.cfm?fuseaction=retail.popup_add_row_to_speed_manage_product&new_page=1';
    adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
    adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
    windowopen(adres_, 'page', 'add_product_wind');
    add_product_wind.focus();
}

function del_manage_row(row) {
    if (confirm('Ürünü Listeden Kaldırmak İstediğinize Emin misiniz?')) {
        var rows = $("#jqxgrid").jqxGrid('getboundrows');
        var ret = jQuery("#jqxgrid").jqxGrid('getRowData', row);
        ret_p = ret.ReportsTo;
        ret_t = ret.row_type;
        ret_s = ret.sub_rows_count;

        var id = $("#jqxgrid").jqxGrid('getrowid', row);
        id_list_ = id;

        var rowIDs = new Array();
        rowIDs.push(rows[row].uid);

        if (ret_s > 0) {
            for (var c = 1; c <= ret_s; c++) {
                var ret_ic = jQuery("#jqxgrid").jqxGrid('getRowData', (row + c));
                ret_p_ic = ret_ic.ReportsTo;

                if (ret_p_ic == ret_p) {
                    rowIDs.push(rows[row + c].uid);
                }
            }
        }
        $("#jqxgrid").jqxGrid('deleterow', rowIDs);

        eleman_sayisi = list_len(document.getElementById('all_product_list').value);
        ilk_deger_ = document.getElementById('all_product_list').value;

        yeni_liste = '';

        for (var m = 1; m <= eleman_sayisi; m++) {
            deger_ = list_getat(ilk_deger_, m);
            if (deger_ != ret_p) {
                if (yeni_liste == '')
                    yeni_liste = '' + deger_;
                else
                    yeni_liste = yeni_liste + ',' + deger_;
            }
        }
        document.getElementById('all_product_list').value = yeni_liste;

        if (document.getElementById('table_id').value != '') {
            adress_ = 'index.cfm?fuseaction=retail.emptypopup_del_product_from_table&product_id=' + ret.product_id + '&table_id=' + document.getElementById('table_id').value;
            AjaxPageLoad(adress_, 'speed_action_div', '1');
        }
    } else {
        return false;
    }
}

function save_list() {
    if (document.getElementById('all_product_list').value == '') {
        alert('Ürün Seçiniz!');
        return false;
    }

    //set_line_numbers();

    document.getElementById("message_div_main_header_info").innerHTML = 'Liste Yap';
    document.getElementById("message_div_main").style.height = 220 + "px";
    document.getElementById("message_div_main").style.width = 300 + "px";
    document.getElementById("message_div_main").style.top = (document.body.offsetHeight - 220) / 2 + "px";
    document.getElementById("message_div_main").style.left = (document.body.offsetWidth - 300) / 2 + "px";
    document.getElementById("message_div_main").style.zIndex = 99999;

    document.getElementById('message_div_main_body').style.overflowY = 'auto';
    show_hide('message_div_main');

    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_list_save_screen', 'message_div_main_body', '1');
}

function open_price_window(row) {
    windowopen('index.cfm?fuseaction=retail.popup_calc_price_window&row_id=' + row, 'medium', 'fiyat_hesapla');
}

function hesapla_first_sales_std(row, type, alan_adi, base_deger, is_update) {
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];

    ilk_ = parseFloat(last_row.c_standart_satis);
    kdv_ = parseFloat(last_row.satis_kdv);
    alis_ = parseFloat(last_row.standart_alis);


    satis_ = parseFloat(last_row.standart_satis);
    satis_kdv_ = parseFloat(last_row.standart_satis_kdv);


    if (type == '3') {
        marj_ = base_deger;
        if (marj_ == '')
            marj_ = 0;

        marj_ = parseFloat(marj_);

        alis_ilk_ = parseFloat(last_row.standart_alis_liste);
        alis_ = alis_ilk_ * ((100 + kdv_) / 100);

        kdv_li_deger_ = wrk_round(alis_ / (100 - marj_) * 100);

        satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) / 100), 4));

        last_row.standart_satis = wrk_round(satis_, 4);
        last_row.standart_satis_kdv = kdv_li_deger_;

        //alis kar hesabi
        s_kar = marj_;
        a_kar = wrk_round(s_kar / (100 - s_kar) * 100);

        last_row.standart_alis_kar = a_kar;
        //alis kar hesabi
    }
    oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
    last_row.standart_satis_oran = oran_;

    if (is_update == 1) {
        datarow = last_row;
        $("#jqxgrid").jqxGrid('updaterow', last_row.uid, datarow, true);
        event.stopPropagation();
        return true;
    } else {
        rows_ic[row] = last_row;
        datarow = last_row;
        $("#jqxgrid").jqxGrid('updaterow', last_row.uid, datarow, false);
    }

    f_print = 0;
}

function std_p_discount_calc(row, alan_adi, base_deger) {
    /*
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];
    */
    last_row = $('#jqxgrid').jqxGrid('getrowdata', row);

    kdv_ = last_row.standart_alis_kdvli;
    alis_kdv = parseFloat(last_row.standart_alis_kdv);

    if (alan_adi == 'standart_alis')
        base_deger_ = base_deger;
    else
        base_deger_ = last_row.standart_alis;

    if (alan_adi == 'standart_alis_indirim_yuzde')
        indirim_kolon = base_deger;
    else
        indirim_kolon = last_row.standart_alis_indirim_yuzde;

    if (alan_adi == 'standart_alis_indirim_tutar')
        manuel_indirim_kolon = base_deger;
    else
        manuel_indirim_kolon = last_row.standart_alis_indirim_tutar;

    indirim_kolon = indirim_kolon + '';
    if (indirim_kolon.indexOf("+") > 0) {
        eleman_sayisi = list_len(indirim_kolon, '+');
        for (var m = 1; m <= eleman_sayisi; m++) {
            dis1 = list_getat(indirim_kolon, m, '+');
            dis1 = filterNum(dis1, 4);
            base_deger_ = base_deger_ - (base_deger_ * dis1 / 100);
        }
    } else {
        dis1 = indirim_kolon;
        dis1 = filterNum(dis1, 4);
        base_deger_ = base_deger_ - (base_deger_ * dis1 / 100);
    }


    if (manuel_indirim_kolon != '') {
        manuel_ = manuel_indirim_kolon;
        base_deger_ = base_deger_ - manuel_;
    }
    base_deger_ = wrk_round(base_deger_, 4);

    last_row.standart_alis_liste = wrk_round(base_deger_, 4);
    last_row.standart_alis_kdvli = wrk_round(base_deger_ * (1 + (alis_kdv / 100)), 4);

    deger_new = wrk_round(base_deger_, 4);
    deger_old = last_row.info_standart_alis;

    deger_ortalama_ = wrk_round(100 * deger_new / deger_old) - 100;

    last_row.standart_alis_oran = wrk_round(deger_ortalama_, 2);

    type = 'kdvli';
    satis_kdv = parseFloat(last_row.satis_kdv);
    satis_kdvsiz = last_row.standart_satis;
    satis_kdvli = last_row.standart_satis_kdv;

    satis_kdv_rank = 1 + (satis_kdv / 100);

    alis_ilk_ = last_row.standart_alis_liste;

    alis_kdvli = alis_ilk_ * ((100 + satis_kdv) / 100);

    kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));

    satis_kdvsiz = wrk_round(satis_kdvsiz, 4);
    satis_kdvli = wrk_round(satis_kdvli, 4);
    kar_ = wrk_round(kar_, 2);

    last_row.standart_satis_kar = kar_;
    last_row.standart_satis = satis_kdvsiz;
    last_row.standart_satis_kdv = satis_kdvli;

    //alis kar hesabi
    s_kar = kar_;
    a_kar = s_kar / (100 - s_kar) * 100;
    last_row.standart_alis_kar = wrk_round(a_kar, 2);
    //alis kar hesabi

    ilk_ = last_row.c_standart_satis;
    oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);
    last_row.standart_satis_oran = oran_;

    /*
    rows_ic[row] = last_row;
    datarow = last_row;
    */
    $("#jqxgrid").jqxGrid('updaterow', last_row.uid, last_row, false);

    f_print = 0;
}

function hesapla_standart_satis(row, type, alan_adi, base_deger, is_update) {
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];

    satis_kdv = parseFloat(last_row.satis_kdv);

    if (alan_adi == 'standart_satis')
        satis_kdvsiz = base_deger;
    else
        satis_kdvsiz = last_row.standart_satis;

    if (alan_adi == 'standart_satis_kdv')
        satis_kdvli = base_deger;
    else
        satis_kdvli = last_row.standart_satis_kdv;


    satis_kdv_rank = 1 + (satis_kdv / 100);

    if (type == 'kdv') {
        satis_kdvli = satis_kdvsiz * satis_kdv_rank;
    }
    if (type == 'kdvli') {
        satis_kdvsiz = satis_kdvli / satis_kdv_rank;
    }
    if (type == 'kdvsiz') {
        satis_kdvli = satis_kdvsiz * satis_kdv_rank;
    }

    alis_ilk_ = last_row.standart_alis_liste;

    alis_kdvli = wrk_round(alis_ilk_ * ((100 + satis_kdv) / 100));
    kar_ = 100 - wrk_round(alis_kdvli / satis_kdvli * 100);

    satis_kdvli = wrk_round(satis_kdvli, 4);
    satis_kdvsiz = wrk_round(satis_kdvsiz, 4);

    kar_ = wrk_round(kar_, 2);

    //alis kar hesabi
    s_kar = kar_;
    a_kar = s_kar / (100 - s_kar) * 100;

    //alis kar hesabi

    ilk_ = last_row.c_standart_satis;
    oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);

    last_row.standart_satis_kar = kar_;
    last_row.standart_alis_kar = wrk_round(a_kar, 2);
    last_row.standart_satis_oran = oran_;

    if (alan_adi == 'standart_satis')
        last_row.standart_satis_kdv = satis_kdvli;
    else
        last_row.standart_satis = satis_kdvsiz;

    rows_ic[row] = last_row;
    $("#jqxgrid").jqxGrid('updaterow', last_row.uid, last_row, false);

    f_print = 0;
}


function p_discount_calc(row, alan_adi, base_deger, is_update) {
    /*
    var id = $( "#jqxgrid" ).jqxGrid('getrowid',row);	
    var last_row = $('#jqxgrid').jqxGrid('getrowdatabyid',id);
    */
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];

    kdv_ = last_row.new_alis_kdvli;
    alis_kdv = last_row.standart_alis_kdv;

    if (alan_adi == 'new_alis_start')
        base_deger_ = base_deger;
    else
        base_deger_ = last_row.new_alis_start;

    if (alan_adi == 'sales_discount')
        indirim_kolon = base_deger;
    else
        indirim_kolon = last_row.sales_discount;

    if (alan_adi == 'p_discount_manuel')
        manuel_indirim_kolon = base_deger;
    else
        manuel_indirim_kolon = last_row.p_discount_manuel;

    indirim_kolon = indirim_kolon + '';
    if (indirim_kolon.indexOf("+") > 0) {
        eleman_sayisi = list_len(indirim_kolon, '+');
        for (var m = 1; m <= eleman_sayisi; m++) {
            dis1 = list_getat(indirim_kolon, m, '+');
            dis1 = filterNum(dis1, 4);
            base_deger_ = base_deger_ - (base_deger_ * dis1 / 100);
        }
    } else {
        dis1 = indirim_kolon;
        dis1 = filterNum(dis1, 4);
        base_deger_ = base_deger_ - (base_deger_ * dis1 / 100);
    }

    if (manuel_indirim_kolon != '') {
        manuel_ = manuel_indirim_kolon;
        base_deger_ = base_deger_ - manuel_;
    }
    base_deger_ = wrk_round(base_deger_, 4);


    last_row.new_alis = wrk_round(base_deger_, 4);
    last_row.new_alis_kdvli = wrk_round(base_deger_ * (1 + (alis_kdv / 100)), 4);
    //alis tarafi bitti

    avantaj = 0;
    satis_kdv = last_row.satis_kdv;
    satis_kdv_rank = 1 + (satis_kdv / 100);


    satis_kdvsiz = last_row.first_satis_price;
    satis_kdvli = last_row.first_satis_price_kdv;

    aktif_fiyat = last_row.c_standart_satis_kdv;
    fiyat_fark = aktif_fiyat - satis_kdvli;

    if (aktif_fiyat > 0) {
        avantaj = wrk_round(fiyat_fark / aktif_fiyat * 100, 1);
    }


    alis_ilk_ = wrk_round(base_deger_, 4);
    alis_kdvli = alis_ilk_ * satis_kdv_rank;

    kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));

    satis_kdvsiz = wrk_round(satis_kdvsiz, 4);
    satis_kdvli = wrk_round(satis_kdvli, 4);

    kar_ = wrk_round(kar_, 2);

    last_row.p_ss_marj = kar_;
    last_row.first_satis_price = satis_kdvsiz;
    last_row.first_satis_price_kdv = satis_kdvli;

    last_row.avantaj_oran = avantaj;

    //alis kar hesabi
    s_kar = kar_;
    a_kar = s_kar / (100 - s_kar) * 100;
    last_row.alis_kar = wrk_round(a_kar);
    //alis kar hesabi

    ilk_ = last_row.c_standart_satis;
    oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);
    last_row.satis_standart_satis_oran = oran_;

    //rows_ic[row] = last_row;
    //datarow = last_row;
    $("#jqxgrid").jqxGrid('updaterow', last_row.uid, last_row, false);
    if (is_update == 1)
        grid_duzenle();

    f_print = 0;
}

function hesapla_satis(row, type, alan_adi, base_deger, is_update) {
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];

    avantaj = 0;
    satis_kdv = parseFloat(last_row.satis_kdv);
    satis_kdv_rank = 1 + (satis_kdv / 100);


    if (alan_adi == 'first_satis_price')
        satis_kdvsiz = base_deger;
    else
        satis_kdvsiz = last_row.first_satis_price;

    if (alan_adi == 'first_satis_price_kdv')
        satis_kdvli = base_deger;
    else
        satis_kdvli = last_row.first_satis_price_kdv;

    aktif_fiyat = last_row.c_standart_satis_kdv;
    fiyat_fark = aktif_fiyat - satis_kdvli;

    if (aktif_fiyat > 0) {
        avantaj = wrk_round(fiyat_fark / aktif_fiyat * 100, 1);
    }

    if (type == 'kdv') {
        satis_kdvli = satis_kdvsiz * satis_kdv_rank;
    }
    if (type == 'kdvli') {
        satis_kdvsiz = satis_kdvli / satis_kdv_rank;
    }
    if (type == 'kdvsiz') {
        satis_kdvli = satis_kdvsiz * satis_kdv_rank;
    }

    alis_ilk_ = last_row.new_alis;
    alis_kdvli = alis_ilk_ * satis_kdv_rank;

    kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));

    satis_kdvsiz = wrk_round(satis_kdvsiz, 4);
    satis_kdvli = wrk_round(satis_kdvli, 4);

    kar_ = wrk_round(kar_, 2);

    //alis kar hesabi
    s_kar = kar_;
    a_kar = wrk_round(s_kar / (100 - s_kar) * 100);

    //alis kar hesabi

    ilk_ = last_row.c_standart_satis;
    oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);


    if (alan_adi == 'first_satis_price')
        last_row.first_satis_price_kdv = satis_kdvli;
    else
        last_row.first_satis_price = satis_kdvsiz;

    last_row.p_ss_marj = kar_;
    last_row.avantaj_oran = avantaj;
    last_row.alis_kar = a_kar;
    last_row.satis_standart_satis_oran = oran_;
    //rows_ic[row] = last_row;
    $("#jqxgrid").jqxGrid('updaterow', last_row.uid, last_row, false);

    f_print = 0;
}

function hesapla_first_sales(row, type, alan_adi, base_deger, is_update) {
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[row];

    ilk_ = last_row.c_standart_satis;
    kdv_ = parseFloat(last_row.satis_kdv);
    alis_ = last_row.new_alis;


    satis_ = last_row.first_satis_price;
    satis_kdv_ = last_row.first_satis_price_kdv;


    if (type == '3') {
        marj_ = base_deger;
        if (marj_ == '')
            marj_ = 0;

        marj_ = parseFloat(marj_);

        alis_ilk_ = last_row.new_alis;
        alis_ = alis_ilk_ * ((100 + kdv_) / 100);;

        kdv_li_deger_ = alis_ / (100 - marj_) * 100;

        satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) / 100), 4));

        last_row.first_satis_price = wrk_round(satis_, 4);
        last_row.first_satis_price_kdv = kdv_li_deger_;

        //alis kar hesabi
        s_kar = marj_;
        a_kar = wrk_round(s_kar / (100 - s_kar) * 100);

        last_row.alis_kar = a_kar;
        //alis kar hesabi
    }

    oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
    last_row.satis_standart_satis_oran = oran_;
    if (is_update == 1) {
        datarow = last_row;
        $("#jqxgrid").jqxGrid('updaterow', last_row.uid, datarow, true);
        event.stopPropagation();
        return true;
    } else {
        rows_ic[row] = last_row;
        datarow = last_row;
        $("#jqxgrid").jqxGrid('updaterow', last_row.uid, datarow, false);
    }

    f_print = 0;
}


function add_del_product_name(type) {
    ek_kelime_ = document.getElementById('head_product_name').value;
    if (ek_kelime_ == '') {
        alert('Koşul Girmediniz!');
        return false;
    }
    ek_kelime_uzunluk_ = ek_kelime_.length;

    var rows = $('#jqxgrid').jqxGrid('getboundrows');
    eleman_sayisi = rows.length;

    ek_deger_ilk_ = document.getElementById('head_product_name').value;
    ek_deger_ = '';
    uzunluk_ = ek_deger_ilk_.length;
    for (var c = 0; c < uzunluk_; c++) {
        char_ = ek_deger_ilk_.substring(c, (c + 1));

        if (char_ == '$' || char_ == '*' || char_ == '?')
            ek_deger_ += "\\";

        ek_deger_ += char_;
    }

    //buldugun yerden sil
    if (type == 'd3') {
        var ek_deger_ = new RegExp(ek_deger_, "g");
        var bosluk_deger = new RegExp("  ", "g");

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                bosluk_ = "";
                deger_ = rows[m].product_name;
                deger_ = deger_.replace(ek_deger_, bosluk_);
                deger_ = deger_.replace(bosluk_deger, ' ');
                deger_ = deger_.replace(bosluk_deger, ' ');
                rows[m].product_name = deger_;
            }
            /*
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
            ret_p = ret.active_row;
            if(ret_p == true || ret_p == 'true')
            {
            	bosluk_ = "";
            	deger_ = ret.product_name;
            	deger_ = 	deger_.replace(ek_deger_,bosluk_);
            	deger_ = 	deger_.replace(bosluk_deger,' ');
            	deger_ = 	deger_.replace(bosluk_deger,' ');
            	$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',deger_);
            }
            */
        }
        grid_duzenle();
    }

    //sondan sil
    if (type == 'd2') {
        ek_deger_ = document.getElementById('head_product_name').value;
        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                bosluk_ = "";
                deger_ = rows[m].product_name;
                deger_uzunluk = deger_.length;
                son_karakterler_ = deger_.substring(deger_uzunluk - ek_kelime_uzunluk_, deger_uzunluk);
                if (son_karakterler_ == ek_deger_)
                    yeni_deger_ = deger_.substring(0, deger_uzunluk - ek_kelime_uzunluk_);
                else
                    yeni_deger_ = deger_;

                rows[m].product_name = yeni_deger_;
            }
            /*
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
            ret_p = ret.active_row;
            if(ret_p == true || ret_p == 'true')
            {
            	deger_ = ret.product_name;
            	deger_uzunluk = deger_.length;
            	son_karakterler_ = deger_.substring(deger_uzunluk-ek_kelime_uzunluk_,deger_uzunluk);
            	if(son_karakterler_ == ek_deger_)
            		yeni_deger_ = deger_.substring(0,deger_uzunluk-ek_kelime_uzunluk_);
            	else
            		yeni_deger_ = deger_;
            		
            	$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger_);	
            }
            */
        }
        grid_duzenle();
    }

    //bastan sil
    if (type == 'd1') {
        var ek_deger_ = new RegExp(ek_deger_, "");
        var bosluk_deger = new RegExp("  ", "g");

        for (var m = 0; m < eleman_sayisi; m++) {
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                bosluk_ = "";
                deger_ = rows[m].product_name;
                deger_ = deger_.replace(ek_deger_, bosluk_);
                deger_ = deger_.replace(bosluk_deger, ' ');
                deger_ = deger_.replace(bosluk_deger, ' ');
                rows[m].product_name = deger_;
            }
            /*
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
            ret_p = ret.active_row;
            if(ret_p == true || ret_p == 'true')
            {
            	bosluk_ = "";
            	deger_ = ret.product_name;
            	deger_ = 	deger_.replace(ek_deger_,bosluk_);
            	deger_ = 	deger_.replace(bosluk_deger,' ');
            	deger_ = 	deger_.replace(bosluk_deger,' ');
            	$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',deger_);
            }
            */
        }
        grid_duzenle();
    }

    //bastan ekle
    if (type == 'a1') {
        for (var m = 0; m < eleman_sayisi; m++) {
            ek_deger_ = document.getElementById('head_product_name').value;
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                bosluk_ = "";
                deger_ = rows[m].product_name;
                ilk_ = list_getat(deger_, 1, ' ');
                son_ = ilk_ + ' ' + ek_deger_ + ' ';
                yeni_deger = deger_.replace(ilk_, son_);
                rows[m].product_name = yeni_deger;
            }
            /*
            ek_deger_ = document.getElementById('head_product_name').value;
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
            ret_p = ret.active_row;
            if(ret_p == true || ret_p == 'true')
            {
            	bosluk_ = "";
            	deger_ = ret.product_name;
            	ilk_ = list_getat(deger_,1,' ');
            	son_ = ilk_ + ' ' + ek_deger_ + ' ';
            	yeni_deger = deger_.replace(ilk_,son_);
            	$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger);
            }
            */
        }
        grid_duzenle();
    }

    //sondan ekle
    if (type == 'a2') {
        for (var m = 0; m < eleman_sayisi; m++) {
            ek_deger_ = document.getElementById('head_product_name').value;
            if (rows[m].active_row == true || rows[m].active_row == 'true') {
                deger_ = rows[m].product_name;
                yeni_deger = deger_ + ' ' + ek_deger_;
                rows[m].product_name = yeni_deger;
            }
            /*
            var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
            ret_p = ret.active_row;
            if(ret_p == true || ret_p == 'true')
            {
            	deger_ = ret.product_name;
            	yeni_deger = deger_ + ' ' + ek_deger_;
            	$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger);
            }
            */
        }
        grid_duzenle();
    }
}


function get_calc_type() {
    c_type_ = document.getElementById('calc_type').value;
    if (c_type_ == '0') {
        hide('calc_table_1');
    } else if (c_type_ == '1') {
        show('calc_table_1');
    } else if (c_type_ == '2') {
        hide('calc_table_1');
    } else if (c_type_ == '3') {
        hide('calc_table_1');
    }
}

function get_product_kare_bedeli(row_id) {
    if (usertype_ == 0) {
        table_code_ = document.getElementById('table_code').value;
        table_secret_code_ = document.getElementById('table_secret_code').value;


        if (row_id == -1) {
            windowopen('index.cfm?fuseaction=retail.popup_make_process_action&table_code=' + table_code_ + '&table_secret_code=' + table_secret_code_, 'wwide1');
        } else {
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', row_id);
            code_ = ret_row.company_code;
            name_ = ret_row.company_name;

            company_id_ = list_getat(code_, 1, '_');
            project_id_ = list_getat(code_, 2, '_');
            comp_ = name_;
            windowopen('index.cfm?fuseaction=retail.popup_make_process_action&table_code=' + table_code_ + '&table_secret_code=' + table_secret_code_ + '&company_id=' + company_id_ + '&project_id=' + project_id_ + '&company_name=' + comp_, 'wwide1');
        }
    }
}

function get_product_detail(product_id) {
    if (f6_pop == 0) {
        header_ = '<a href="javascript://" onclick="f6_pop=1;get_product_detail();">(X)</a> Ürün Detay Ekranı';
        ajaxwindow('index.cfm?fuseaction=objects.popup_detail_product&pid=' + product_id, 'list', 'product_detail_window', header_);
        f6_pop = 1;
    } else {
        try {
            ColdFusion.Window.destroy('product_detail_window', true);
        } catch (e) {}
        f6_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
    //windowopen('index.cfm?fuseaction=objects.popup_detail_product&pid=' + product_id,'list');
}

function get_product_tranfers(product_id, stock_id) {
    if (p_pop == 0) {
        header_ = '<a href="javascript://" onclick="p_pop=1;get_product_tranfers();">(X)</a> Dağılım Ekranı';

        if (stock_id == '0')
            ajaxwindow('index.cfm?fuseaction=retail.emptypopup_detail_transfers_2&product_id=' + product_id, 'list', 'p_transfer_window', header_);
        else
            ajaxwindow('index.cfm?fuseaction=retail.emptypopup_detail_transfers_2&stock_id=' + stock_id, 'list', 'p_transfer_window', header_);
        p_pop = 1;
    } else {
        try {
            ColdFusion.Window.destroy('p_transfer_window', true);
        } catch (e) {}
        p_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
    //windowopen('index.cfm?fuseaction=objects.popup_detail_product&pid=' + product_id,'list');
}

function get_rival_price_list(product_id) {
    if (usertype_ == 0) {
        if (f5_pop == 0) {
            header_ = '<a href="javascript://" onclick="f5_pop=1;get_rival_price_list();">(X)</a> Rakip Fiyat Ekranı';
            ajaxwindow('index.cfm?fuseaction=retail.popup_detail_rival_prices&pid=' + product_id, 'list', 'rival_window', header_);
            f5_pop = 1;
        } else {
            try {
                ColdFusion.Window.destroy('rival_window', true);
            } catch (e) {}
            f5_pop = 0;
            $('#jqxgrid').jqxGrid('focus');
        }
    }
}

function get_cost_list(product_id, stock_id) {
    if (usertype_ == 0) {
        if (f9_pop == 0) {
            adress_ = 'index.cfm?fuseaction=retail.popup_detail_product_cost&product_id=' + product_id;
            if (stock_id != '')
                adress_ = adress_ + '&stock_id=' + stock_id;

            header_ = '<a href="javascript://" onclick="f9_pop=1;get_cost_list();">(X)</a> Maliyet Ekranı';
            ajaxwindow(adress_, 'list', 'cost_window', header_);
            f9_pop = 1;
        } else {
            try {
                ColdFusion.Window.destroy('cost_window', true);
            } catch (e) {}
            f9_pop = 0;
            $('#jqxgrid').jqxGrid('focus');
        }
    }
    //windowopen('index.cfm?fuseaction=retail.popup_detail_product_cost&product_id=' + product_id +'&stock_id='+stock_id,'list');
}

function get_product_price_detail(product_id, row_id) {
    if (f1_pop == 0) {
        header_ = '<a href="javascript://" onclick="f1_pop=1;get_product_price_detail();">(X)</a> Fiyat Ekranı';
        ajaxwindow('index.cfm?fuseaction=retail.emptypopup_detail_product_price&pid=' + product_id + '&row_id=' + row_id, 'wwide1', 'price_window', header_);
        f1_pop = 1;
    } else {
        try {
            ColdFusion.Window.destroy('price_window', true);
        } catch (e) {}
        f1_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
    //windowopen('index.cfm?fuseaction=retail.popup_detail_product_price&pid=' + product_id,'wide2');
}

function get_product_relateds(product_id) {
    if (usertype_ == 0) {
        if (f3_pop == 0) {
            header_ = '<a href="javascript://" onclick="f3_pop=1;get_product_relateds();">(X)</a> Muadil Ürünler';
            ajaxwindow('index.cfm?fuseaction=retail.emptypopup_detail_product_others&pid=' + r_product, 'adminTv', 'product_others', header_);
            f3_pop = 1;
        } else {
            try {
                ColdFusion.Window.destroy('product_others', true);
            } catch (e) {}
            f3_pop = 0;
            $('#jqxgrid').jqxGrid('focus');
        }
    }
}

function get_product_detail_send(product_id) {
    if (usertype_ == 0) {
        window.open('index.cfm?fuseaction=product.form_upd_product&pid=' + product_id, 'list');
    }
}

function get_product_detail_send_stock(product_id) {
    if (usertype_ == 0) {
        window.open('index.cfm?fuseaction=stock.detail_stock&pid=' + product_id, 'list');
    }
}


function seller_limit_table(table_code) {
    if (f4_pop == 0) {
        if (document.info_form.inner_table_code.value == '') {
            alert('Satıcı Limiti Alabilmek İçin Tabloyu Kayıt Etmelisiniz!');
            return false;
        }

        vade_list = '';
        add_stock_list = '';


        adres_ = 'index.cfm?fuseaction=retail.emptypopup_seller_limit_table';
        adres_ += '&table_code=' + document.info_form.inner_table_code.value;
        adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
        adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;

        header_ = '<a href="javascript://" onclick="seller_limit_table();">(X)</a> Satıcı Limitleri';
        ajaxwindow(adres_, 'wwide1', 'seller_limit', header_);
        f4_pop = 1;
    } else {
        try {
            ColdFusion.Window.destroy('seller_limit', true);
        } catch (e) {}
        f4_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
}

function show_shortcuts() {
    cfmodal('index.cfm?fuseaction=retail.emptypopup_get_short_cuts', 'warning_modal');
}


function get_stock_list(id_, type, dept) {
    if (f2_pop == 0) {
        if (departman_sayisi == 1)
            dept_ = departman_listesi;
        else
            dept_ = dept;
        if (type == 'product')
            header_ = '<a href="javascript://" onclick="f2_pop=3;get_stock_list();">(X)</a> Ürün Hareketleri';
        else if (type == 'stock')
            header_ = '<a href="javascript://" onclick="f2_pop=3;get_stock_list();">(X)</a> Stok Hareketleri';
        else if (type == 'department')
            header_ = '<a href="javascript://" onclick="f2_pop=3;get_stock_list();">(X)</a> Stok Hareketleri';

        if (type == 'product')
            ajaxwindow('index.cfm?fuseaction=retail.popup_product_stocks_pre&&product_id=' + id_ + '&search_department_id=' + dept_, 'page_display', 'stock_window', header_);
        else if (type == 'stock')
            ajaxwindow('index.cfm?fuseaction=retail.popup_product_stocks_pre&stock_id=' + id_ + '&search_department_id=' + dept_, 'page_display', 'stock_window', header_);
        else if (type == 'department')
            ajaxwindow('index.cfm?fuseaction=retail.popup_product_stocks_pre&stock_id=' + id_ + '&search_department_id=' + dept_, 'page_display', 'stock_window', header_);
        f2_pop = 1;
    } else if (f2_pop == 1) {
        view_type_ = 2;
        document.getElementById('view_type').value = "w";
        document.getElementById('view_type_d').value = "w";
        getir();
        f2_pop = 2;
    } else if (f2_pop == 2) {
        view_type_ = 3;
        document.getElementById('view_type').value = "d";
        document.getElementById('view_type_d').value = "d";
        getir();
        f2_pop = 3;
    } else if (f2_pop == 3) {
        try {
            ColdFusion.Window.destroy('stock_window', true);
        } catch (e) {}
        f2_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
}

function get_new_layout() {
    if (document.getElementById('layout_id').value != '') {
        adress_ = 'index.cfm?fuseaction=retail.popup_change_drag_table_new';
        adress_ += '&layout_id=' + document.getElementById('layout_id').value;


        AjaxPageLoad(adress_, 'speed_action_div');
        //windowopen(adress_,'small','layout_window');
    }
}

function save_layout() {
    cfmodal('index.cfm?fuseaction=retail.emptypopup_save_layout_new&layout_id=' + document.getElementById('layout_id').value, 'warning_modal');


    //AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_save_layout_new&layout_id=' + document.getElementById('layout_id').value, 'message_div_main_body', '1');
}

function change_table_col_sh(col_name) {
    if (document.getElementById('sh_' + col_name).checked == true) {
        $("#jqxgrid").jqxGrid('beginupdate');
        $("#jqxgrid").jqxGrid('showcolumn', col_name);
        $("#jqxgrid").jqxGrid('endupdate');
    } else {
        $("#jqxgrid").jqxGrid('beginupdate');
        $("#jqxgrid").jqxGrid('hidecolumn', col_name);
        $("#jqxgrid").jqxGrid('endupdate');
    }
}

function change_table_col_sh2(col_name) {
    $("#jqxgrid").jqxGrid('beginupdate');
    $("#jqxgrid").jqxGrid('hidecolumn', col_name);
    $("#jqxgrid").jqxGrid('endupdate');
}

function open_company_list(row_id) {
    windowopen('index.cfm?fuseaction=objects.popup_list_manufact_comps&row_id=' + row_id, 'list');
}

function callURL(url, callback, data, target, async) {
    // Make method POST if data parameter is specified
    var method = (data != null) ? "POST" : "GET";
    $.ajax({
        async: async != null ? async : true,
        url: url,
        type: method,
        data: data,
        success: function(responseData, status, jqXHR) {
            callback(target, responseData, status, jqXHR);
        },
        error: function(xhr, opt, err) {
            // If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
            if (err != null && err.toString().length != 0) callback(target, err, opt, xhr);
        }
    });
}

function handlerPost(target, responseData, status, jqXHR) {
    responseData = $.trim(responseData);

    if (responseData.substr(0, 2) == '//') responseData = responseData.substr(2, responseData.length - 2);
    //console.log(responseData);
    if (responseData == "1") {
        alert("İşlem başarılı!");
    } else {
        document.getElementById('note').value = responseData;
        hide('message_div_main');
        windowopen('index.cfm?fuseaction=retail.popup_form_add_order2&is_from_add=1&order_id_list=' + responseData, 'page');
    }
    //console.log($.evalJSON(responseData));
}

function callURL_table(url, callback, data, target, async) {
    // Make method POST if data parameter is specified
    var method = (data != null) ? "POST" : "GET";
    $.ajax({
        async: async != null ? async : true,
        url: url,
        type: method,
        data: data,
        success: function(responseData, status, jqXHR) {
            callback(target, responseData, status, jqXHR);
        },
        error: function(xhr, opt, err) {
            // If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
            if (err != null && err.toString().length != 0) callback(target, err, opt, xhr);
        }
    });
}

function handlerPost_table(target, responseData, status, jqXHR) {
    responseData = $.trim(responseData);

    if (responseData.substr(0, 2) == '//') responseData = responseData.substr(2, responseData.length - 2);
    //console.log(responseData);
    if (responseData == "1") {
        alert("İşlem başarılı!");
    } else {
        document.getElementById('note').value = responseData;
        message = '<font color="green" style="font-size:16px;font-weight:bold;">İşlemler Tamamlandı!</font>';

        if (responseData.length > 250) {
            message = '<font color="red" style="font-size:16px;font-weight:bold;">Hata Oluştu!</font>';
        } else {
            if (list_len(responseData, '*') == 1) {
                document.search_product.table_code.value = responseData;
                document.info_form.inner_table_code.value = responseData;
            } else {
                code_ = list_getat(responseData, 1, '*');
                codes_ = list_getat(responseData, 2, '*');
                document.search_product.table_code.value = code_;
                document.info_form.inner_table_code.value = code_;
                message += '<br><b>İşlem Kodları:</b>';

                uzunluk_ = list_len(codes_, '+');
                if (uzunluk_ == 1)
                    message += '<br>' + codes_;
                else {
                    for (var m = 1; m <= uzunluk_; m++) {
                        deger_ = list_getat(codes_, m, '+');
                        message += '<br>' + deger_;
                    }
                }
            }
        }
        document.getElementById('message_div_main_body').innerHTML = '<br><br>' + message + '';
        //hide('message_div_main');
        //windowopen('index.cfm?fuseaction=retail.popup_form_add_order2&yeniden_sev=' + responseData,'page');
    }
    //console.log($.evalJSON(responseData));
}


function open_close_down_product(product_id) {
    if (list_find(open_js_product_id_list, product_id)) {
        open_js_product_id_list = list_setat(open_js_product_id_list, list_find(open_js_product_id_list, product_id), '0');

        var datainformations = $('#jqxgrid').jqxGrid('getdatainformation');
        var eleman_sayisi = datainformations.rowscount;

        for (var m = 0; m < eleman_sayisi; m++) {
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', m);
            r_type = ret_row.row_type;
            r_product = ret_row.ReportsTo;

            if (r_type != '1' && r_product == product_id) {
                $("#jqxgrid").jqxGrid('hiderow', m);
            }
        }
    } else {
        if (open_js_product_id_list != '')
            open_js_product_id_list = open_js_product_id_list + ',' + product_id;
        else
            open_js_product_id_list = '0,' + product_id;

        var datainformations = $('#jqxgrid').jqxGrid('getdatainformation');
        var eleman_sayisi = datainformations.rowscount;

        for (var m = 0; m < eleman_sayisi; m++) {
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', m);
            r_type = ret_row.row_type;
            r_product = ret_row.ReportsTo;

            if (r_type != '1' && r_product == product_id) {
                $("#jqxgrid").jqxGrid('showrow', m);
            }
        }
    }
    return false;
}

function hesapla_row_siparis(alan_adi, deger, rowBoundIndex) {
    var rows_ic = $('#jqxgrid').jqxGrid('getboundrows');
    last_row = rows_ic[rowBoundIndex];

    list_price_ = last_row.list_price;
    list_price_kdv_ = last_row.list_price_kdv;

    if (last_row.carpan != '')
        carpan = parseFloat(last_row.carpan);
    else
        carpan = '';

    if (last_row.carpan2 != '')
        carpan2 = parseFloat(last_row.carpan2);
    else
        carpan2 = '';

    row_siparisler_toplami_ilk = last_row.siparis_miktar + last_row.siparis_miktar_2;
    row_ortalama_miktar = parseFloat(last_row.stok_yeterlilik_suresi_order * last_row.ortalama_satis_gunu);

    if (alan_adi == 'siparis_miktar') {
        if (deger == '' || deger == 0 || deger == null)
            last_row.siparis_miktar = 0;
        else
            last_row.siparis_miktar = -1;
        if (deger == '' || deger == 0 || deger == null) {
            last_row.siparis_tutar_1 = 0;
            last_row.siparis_tutar_kdv_1 = 0;
            last_row.siparis_onay = false;
            last_row.siparis_sevk = false;
        } else {
            last_row.siparis_tutar_1 = wrk_round(deger * list_price_);
            last_row.siparis_tutar_kdv_1 = wrk_round(deger * list_price_kdv_);

            if (carpan != '')
                last_row.siparis_miktar_k = wrk_round(deger / carpan, 2);

            if (carpan2 != '')
                last_row.siparis_miktar_p = wrk_round(deger / carpan2, 2);

            last_row.siparis_onay = true;
            last_row.siparis_sevk = true;
        }
    } else if (alan_adi == 'siparis_miktar_2') {
        if (deger == '' || deger == 0 || deger == null)
            last_row.siparis_miktar_2 = 0;
        else
            last_row.siparis_miktar_2 = -1;
        if (deger == '' || deger == 0 || deger == null) {
            last_row.siparis_tutar_2 = 0;
            last_row.siparis_tutar_kdv_2 = 0;
            last_row.siparis_onay_2 = false;
            last_row.siparis_sevk_2 = false;
        } else {
            last_row.siparis_tutar_2 = wrk_round(deger * list_price_);
            last_row.siparis_tutar_kdv_2 = wrk_round(deger * list_price_kdv_);

            if (carpan != '')
                last_row.siparis_miktar_k_2 = wrk_round(deger / carpan, 2);

            if (carpan2 != '')
                last_row.siparis_miktar_p_2 = wrk_round(deger / carpan2, 2);

            last_row.siparis_onay_2 = true;
            last_row.siparis_sevk_2 = true;
        }
    } else if (alan_adi == 'siparis_miktar_k' || alan_adi == 'siparis_miktar_k_round') {
        if (deger == '' || carpan == '' || deger == 0) {
            last_row.siparis_miktar = 0;
            last_row.siparis_miktar_p = 0;
            last_row.siparis_tutar_1 = 0;
            last_row.siparis_tutar_kdv_1 = 0;
            last_row.siparis_onay = false;
            last_row.siparis_sevk = false;
        } else {
            last_row.siparis_tutar_1 = wrk_round(deger * carpan * list_price_);
            last_row.siparis_tutar_kdv_1 = wrk_round(deger * carpan * list_price_kdv_);
            last_row.siparis_miktar = wrk_round(deger * carpan, 2);

            if (carpan2 != '')
                last_row.siparis_miktar_p = wrk_round(deger * carpan / carpan2, 2);

            last_row.siparis_onay = true;
            last_row.siparis_sevk = true;
        }
    } else if (alan_adi == 'siparis_miktar_k_2' || alan_adi == 'siparis_miktar_k_2_round') {
        if (deger == '' || carpan == '' || deger == 0) {
            last_row.siparis_miktar_2 = 0;
            last_row.siparis_miktar_p_2 = 0;
            last_row.siparis_tutar_2 = 0;
            last_row.siparis_tutar_kdv_2 = 0;
            last_row.siparis_onay_2 = false;
            last_row.siparis_sevk_2 = false;
        } else {
            last_row.siparis_tutar_2 = wrk_round(deger * carpan * list_price_);
            last_row.siparis_tutar_kdv_2 = wrk_round(deger * carpan * list_price_kdv_);
            last_row.siparis_miktar_2 = wrk_round(deger * carpan, 2);

            if (carpan2 != '')
                last_row.siparis_miktar_p_2 = wrk_round(deger * carpan / carpan2, 2);

            last_row.siparis_onay_2 = true;
            last_row.siparis_sevk_2 = true;
        }
    } else if (alan_adi == 'siparis_miktar_p') {
        if (deger == '' || deger == 0 || deger == null)
            last_row.siparis_miktar_p = 0;
        else
            last_row.siparis_miktar_p = -1;
        if (deger == '' || carpan2 == '') {
            last_row.siparis_miktar = 0;
            last_row.siparis_miktar_k = 0;
            last_row.siparis_tutar_1 = 0;
            last_row.siparis_tutar_kdv_1 = 0;
            last_row.siparis_onay = false;
            last_row.siparis_sevk = false;
        } else {
            last_row.siparis_tutar_1 = wrk_round(deger * carpan2 * list_price_);
            last_row.siparis_tutar_kdv_1 = wrk_round(deger * carpan2 * list_price_kdv_);
            last_row.siparis_miktar = wrk_round(deger * carpan2, 2);

            if (carpan != '')
                last_row.siparis_miktar_k = wrk_round(deger * carpan2 / carpan, 2);

            last_row.siparis_onay = true;
            last_row.siparis_sevk = true;
        }
    } else if (alan_adi == 'siparis_miktar_p_2') {
        if (deger == '' || deger == 0 || deger == null)
            last_row.siparis_miktar_p_2 = 0;
        else
            last_row.siparis_miktar_p_2 = -1;
        if (deger == '' || carpan2 == '') {
            last_row.siparis_miktar_2 = 0;
            last_row.siparis_miktar_k_2 = 0;
            last_row.siparis_tutar_2 = 0;
            last_row.siparis_tutar_kdv_2 = 0;
            last_row.siparis_onay_2 = false;
            last_row.siparis_sevk_2 = false;
        } else {
            last_row.siparis_tutar_2 = deger * carpan2 * list_price_;
            last_row.siparis_tutar_kdv_2 = deger * carpan2 * list_price_kdv_;
            last_row.siparis_miktar_2 = wrk_round(deger * carpan2, 2);

            if (carpan != '')
                last_row.siparis_miktar_k_2 = wrk_round(deger * carpan2 / carpan, 2);

            last_row.siparis_onay_2 = true;
            last_row.siparis_sevk_2 = true;
        }
    }
    if (alan_adi == 'siparis_miktar') {
        row_siparisler_toplami_son = deger + last_row.siparis_miktar_2;
    } else if (alan_adi == 'siparis_miktar') {
        row_siparisler_toplami_son = deger + last_row.siparis_miktar;
    } else
        row_siparisler_toplami_son = last_row.siparis_miktar + last_row.siparis_miktar_2;

    row_ortalama_miktar = wrk_round((row_ortalama_miktar - row_siparisler_toplami_ilk + row_siparisler_toplami_son) / last_row.ortalama_satis_gunu);
    if (isNaN(row_ortalama_miktar))
        row_ortalama_miktar = 0;

    last_row.stok_yeterlilik_suresi_order = row_ortalama_miktar;
    rows_ic[rowBoundIndex] = last_row;
    /*
    id_ = rows_ic[rowBoundIndex].uid;
    */
    $("#jqxgrid").jqxGrid('updaterow', last_row.uid, last_row, false);
}

t_muadil = 0;

function sec_muadil(total_record) {
    sayi_ = parseInt(total_record);
    if (sayi_ > 0) {
        for (var k = 1; k <= sayi_; k++) {
            if (t_muadil == 0) {
                document.getElementById('s_product_id_' + k).checked = true;
            } else {
                document.getElementById('s_product_id_' + k).checked = false;
            }
        }
        if (t_muadil == 0) {
            t_muadil = 1;
        } else {
            t_muadil = 0;
        }
    } else {
        alert('Ürün Seçmelisiniz!');
        return false;
    }
}


function gonder_muadil(total_record) {
    sayi_ = parseInt(total_record);

    secili_urun = 0;
    secili_urun_list = '';

    if (sayi_ > 0) {
        for (var k = 1; k <= sayi_; k++) {
            if (document.getElementById('s_product_id_' + k).checked == true) {
                secili_urun = secili_urun + 1;
                if (secili_urun_list == '')
                    secili_urun_list = document.getElementById('s_product_id_' + k).value;
                else
                    secili_urun_list = secili_urun_list + ',' + document.getElementById('s_product_id_' + k).value;
            }
        }

        if (secili_urun > 0) {
            window.open('index.cfm?fuseaction=retail.speed_manage_product_new&selected_product_id=' + secili_urun_list);
        } else {
            alert('Ürün Seçmelisiniz!');
            return false;
        }
    } else {
        alert('Ürün Seçmelisiniz!');
        return false;
    }
}