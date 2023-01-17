function cellclass(row, datafield, value, rowdata) {
    var cells = $('#jqxgrid').jqxGrid('getselectedcells');
    c_eleman_sayisi = cells.length;

    for (var m = 0; m < c_eleman_sayisi; m++) {
        var cell = cells[m];
        row_ = cell.rowindex;

        if (row_ == row && datafield != cell.datafield) {
            return "selectedclassRow";
        } else {
            str = datafield;
            if (str.indexOf("dagilim_") >= 0)
                return "depoihtiyaccss";
            else if (str.indexOf("sube_stock_") >= 0)
                return "depostockcss";
            else if (str.indexOf("yoldaki_") >= 0)
                return "depoyoldakicss";
            else if (str.indexOf("sube_stock_yeterlilik_") >= 0)
                return "depoyetercss";
            else if (str.indexOf("sube_ortalama_satis_") >= 0)
                return "depoortalamacss";
            else if (str.indexOf("reel_dagilim_") >= 0)
                return "dagilimcss";
            else if (str.indexOf("ship_internal_") >= 0)
                return "shipinternalcss";
            else if (str == 'depo_stock')
                return "depo_stockcss";
            else
                return "";
        }
    }
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

function get_sevk_talepler(stock_id, department_id, out_department_id) {
    if (f3_pop == 0) {
        header_ = '<a href="javascript://" onclick="f3_pop=1;get_sevk_talepler();">(X)</a> Dağılım Takip Ekranı';
        ajaxwindow('index.cfm?fuseaction=retail.emptypopup_detail_transfers&stock_id=' + stock_id + '&department_id=' + department_id + '&out_department_id=' + out_department_id, 'list', 'transfer_window', header_);
        f3_pop = 1;
    } else {
        try {
            ColdFusion.Window.destroy('transfer_window', true);
        } catch (e) {}
        f3_pop = 0;
        $('#jqxgrid').jqxGrid('focus');
    }
    //windowopen('index.cfm?fuseaction=retail.popup_detail_product_price&pid=' + product_id,'wide2');
}

function get_stock_list(id_, type, dept) {
    if (f2_pop == 0) {
        header_ = '<a href="javascript://" onclick="f2_pop=3;get_stock_list();">(X)</a> Stok Hareketleri';
        ajaxwindow('index.cfm?fuseaction=retail.popup_product_stocks_pre&stock_id=' + id_ + '&search_department_id=' + dept, 'page_display', 'stock_window', header_);
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


function handleKeys(event) {
    tus_islem = 1;
    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;
    action_key_list = '112,113,114,115,116,117,118,119,120,121,27';

    if (list_find(action_key_list, key)) {
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

            r_product = list_getat(ret, 1, '_');
            r_stock = list_getat(ret, 2, '_');
            r_dept = merkez_depo_id;

            str = cell.datafield;
            if (str.indexOf("ship_internal_") >= 0 || str.indexOf("sube_stock_") >= 0 || str.indexOf("yoldaki_") >= 0 || str.indexOf("sube_stock_yeterlilik_") >= 0 || str.indexOf("sube_ortalama_satis_") >= 0 || str.indexOf("reel_dagilim_") >= 0) {
                sira_ = list_len(str, '_');
                r_dept = list_getat(str, sira_, '_');
            }

            get_stock_list(r_stock, 'department', r_dept);
            return true;
        } else if (key == 114) //F3 tusuna gorev atama
        {
            var cell = $('#jqxgrid').jqxGrid('getselectedcell');
            var row = cell.rowindex;
            var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData', row);

            ret = ret_row.product_code;

            r_product = list_getat(ret, 1, '_');
            r_stock = list_getat(ret, 2, '_');
            r_dept = merkez_depo_id;

            str = cell.datafield;
            if (str.indexOf("ship_internal_") >= 0 || str.indexOf("dagilim_") >= 0 || str.indexOf("sube_stock_") >= 0 || str.indexOf("yoldaki_") >= 0 || str.indexOf("sube_stock_yeterlilik_") >= 0 || str.indexOf("sube_ortalama_satis_") >= 0 || str.indexOf("reel_dagilim_") >= 0) {
                sira_ = list_len(str, '_');
                r_dept = list_getat(str, sira_, '_');
            }

            get_sevk_talepler(r_stock, islem_depo, r_dept);
            return true;
        }
    } else
        return false;
}