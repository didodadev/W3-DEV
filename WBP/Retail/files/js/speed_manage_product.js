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

function get_new_layout() {

    if (document.getElementById('layout_id').value != '') {


        adress_ = 'index.cfm?fuseaction=retail.popup_change_drag_table';
        adress_ += '&layout_id=' + document.getElementById('layout_id').value;

        document.getElementById("message_div_main_header_info").innerHTML = 'Görünüm';
        document.getElementById("message_div_main").style.height = 200 + "px";
        document.getElementById("message_div_main").style.width = 300 + "px";
        document.getElementById("message_div_main").style.top = (document.body.offsetHeight - 200) / 2 + "px";
        document.getElementById("message_div_main").style.left = (document.body.offsetWidth - 300) / 2 + "px";
        document.getElementById("message_div_main").style.zIndex = 99999;
        document.getElementById('message_div_main_body').style.overflowY = 'auto';
        document.getElementById('message_div_main_body').innerHTML = '<br><br>Görünüm Değiştiriliyor. Lütfen Bekleyiniz!';
        show('message_div_main');
        AjaxPageLoad(adress_, 'speed_action_div');
    }
}