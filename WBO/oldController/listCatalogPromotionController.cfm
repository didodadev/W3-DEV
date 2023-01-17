<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
 	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.position_name" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default=""> 
    <cfparam name="attributes.currency" default=""> 
    <cfparam name="attributes.catalog_status" default="">
    <cfparam name="attributes.is_applied" default="">
	<cfif isdefined("attributes.is_submitted")>
        <cfinclude template="../product/query/get_catalog_promotion.cfm">
    <cfelse>
        <cfset get_catalog.recordcount=0>
    </cfif>
    <cfinclude template="../product/query/get_price_cats.cfm"> 
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
		<cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_date =''>
        <cfelse>
            <cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")>
        </cfif>
    </cfif>
    <cfif get_catalog.recordcount>
		  <cfset employee_id_list=''>
		  <cfset record_emp_list=''>
		  <cfset catalog_id_list=''>
          <cfif len(employee_id_list)>
			<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
			<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
				SELECT
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME
				FROM
					EMPLOYEES
				WHERE
					EMPLOYEE_ID IN (#employee_id_list#)
				ORDER BY
					EMPLOYEE_ID
			</cfquery>
		  </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit default_value="1" fuseact="product.form_upd_catalog_promotion">
    <cfif isdefined("attributes.camp_id")>
        <cfquery name="get_camp_info" datasource="#dsn3#">
            SELECT CAMP_HEAD,CAMP_ID,CAMP_STARTDATE,CAMP_FINISHDATE FROM CAMPAIGNS WHERE CAMP_ID = #attributes.camp_id#
        </cfquery>
        <cfset camp_start = date_add("H",session.ep.time_zone,get_camp_info.camp_startdate)>
        <cfset camp_finish = date_add("H",session.ep.time_zone,get_camp_info.camp_finishdate)>
        <cfset camp_id = get_camp_info.camp_id>
        <cfset camp_head = '#get_camp_info.camp_head#(#dateformat(camp_start,'dd/mm/yyyy')#-#dateformat(camp_finish,'dd/mm/yyyy')#)'>
    <cfelse>
        <cfset camp_start = ''>
        <cfset camp_finish = ''>
        <cfset camp_id = ''>
        <cfset camp_head = ''>
    </cfif>
    <cfset module_name="product">
    <cfset var_ = "add_purchase_basket">
    <cfinclude template="../product/query/get_price_cats.cfm">
    <cfinclude template="../product/query/get_company_cat.cfm">
    <!--- Aktif kategorilerin gelmesi için --->
    <cfset attributes.is_active_consumer_cat = 1>
    <cfinclude template="../product/query/get_consumer_cat.cfm">
    <cf_papers paper_type="cat_prom">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit default_value="1" fuseact="product.form_upd_catalog_promotion">
    <cfset module_name="product">
    <cfset var_="upd_purchase_basket">
    <cfinclude template="../product/query/get_price_cats.cfm">
    <cfinclude template="../product/query/get_company_cat.cfm">
    <cfinclude template="../product/query/get_consumer_cat.cfm">
    <cfinclude template="../product/query/get_catalog_promotion_detail.cfm">
    <cfif not get_catalog_detail.recordcount>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
    </cfif>
    <cfif len(get_catalog_detail.camp_id)>
        <cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
            SELECT CAMP_ID,CAMP_HEAD,CAMP_FINISHDATE,CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = #get_catalog_detail.camp_id#
        </cfquery>
    </cfif>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
		$(document).ready(function(){			
			 $('#keyword').focus();
			});       
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <script type="text/javascript">
        function check_all(deger)
        {
            <cfif get_price_cats.recordcount gt 1>
                for(i=0; i<form_basket.PRICE_CATS.length; i++)
                    form_basket.PRICE_CATS[i].checked = deger;
            <cfelseif get_price_cats.recordcount eq 1>
                form_basket.PRICE_CATS.checked = deger;
            </cfif>
        }
        function kontrol()
        {
			unformat_fields();
            product_id_list='';
            x = (250 - form_basket.DETAIL.value.length);
            if ( x < 0)
            { 
                alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'> !");
                return false;
            }
            
            if(form_basket.herkes != undefined)
                temp3 = form_basket.herkes.checked;
            else
                temp3 = 1;
                
            temp1=0;
            if(form_basket.PRICE_CATS != undefined)
            {
                <cfif get_price_cats.recordcount gt 1>
                    for(i=0;i<form_basket.PRICE_CATS.length;i++)
                        if(form_basket.PRICE_CATS[i].checked==1)
                            temp1 = 1;
                <cfelseif get_price_cats.recordcount eq 1>
                    if(form_basket.PRICE_CATS.checked==1)
                        temp1 = 1;
                </cfif>
            }
            
            if(row_count==0)
            {
                alert("<cf_get_lang_main no='313.ürün seçiniz'>");
                return false;
            }
            
            //Fiyat Listesi secili olmasa bile internet secili olma durumu BK 20070307
            if(form_basket.is_public != undefined && form_basket.is_public.checked==1)
                temp1 = 1;
            
            if ((temp1 == 0) && (temp3 == 0))
            {
                alert("<cf_get_lang no ='789.Aksiyonu Fiyat Listesine Bağlamalısınız'> !");
                return false;
            }	
        
            for(var i=1; i<=row_count; i++)
            {
                if(eval("form_basket.disc_ount1"+i) != undefined)
                {
                    var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang no ='792.no lu satırdaki İskonto 1 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='793.no lu satırdaki İskonto 2 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang no ='794.no lu satırdaki İskonto 3 alanındaki değer, 0 ile 100 arasında olmalı '>!"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='795.no lu satırdaki İskonto 4 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + " <cf_get_lang no ='796.no lu satırdaki İskonto 5 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='797.no lu satırdaki İskonto 6 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='798.no lu satırdaki İskonto 7 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='799. no lu satırdaki İskonto 8 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='800.no lu satırdaki İskonto 9 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='801.no lu satırdaki İskonto 10 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                }
                
                //Ayni urun bir satirlarda bir kez secilmeli BK 20100907
                if(eval("document.form_basket.row_kontrol"+i).value==1)	
                {
                    temp_product_id = "'"+eval("form_basket.product_id"+i).value+"'";
                    if(list_find(product_id_list,temp_product_id,','))
                    {
                        alert("Aynı Ürünü Bir Defa Seçebilirsiniz !");
                        return false;
                    }
                    else
                    {
                        if(list_len(product_id_list,',') == 0)
                            product_id_list+=temp_product_id;
                        else
                            product_id_list+=","+temp_product_id;
                    }
                }			
            }	
    
            <cfif isdefined("extra_price_list") and len(extra_price_list)>
                if(form_basket.process_stage.value ==  -2)
                {
                    if(confirm("Kataloğu Yayın Aşamasına Getirdiniz.Ürünler İçin Satırdaki Tüm Fiyat Listelerine Fiyat Yazılacak. Emin misiniz?") == true)
                        return true;
                    else
                        return false;
                }
            </cfif>
            if(date_check(form_basket.startdate,form_basket.finishdate,"<cf_get_lang no ='790.Geçerlilik Tarihleri Hatalı, Lütfen Düzeltin'> !"))
            {
                if(form_basket.kondusyon_date != undefined)
                {
                    if(date_check(form_basket.kondusyon_date,form_basket.finishdate,"<cf_get_lang no ='791.Kondüsyon Tarihi Geçerlilik Bitişinden Önce Olmalı, Lütfen Düzeltin '>!"))
                        return true;
                    else
                        return false;
                }
                else
                    return true;
            }
            else
                return false;
			return true;
        }
        function unformat_fields()
        {
            var round_num_ = "<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>";
            for(var i=1; i<=row_count; i++)
            {
                var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.p_price_kdv"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.row_nettotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);		
                var str_me=eval("form_basket.returning_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.returning_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);	
                var str_me=eval("form_basket.returning_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.rebate_cash_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.rebate_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.extra_product_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.extra_product_2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.return_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.return_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.price_protection_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.unit_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.total_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.new_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.new_marj"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                <cfif isdefined("extra_price_list") and len(extra_price_list)>
                    <cfoutput query="get_price_cat_row">
                        var str_me=eval("form_basket.new_price_kdv#get_price_cat_row.price_catid#"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                    </cfoutput>
                </cfif>
            }
        }
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<script type="text/javascript">
        function check_all(deger)
        {
            <cfif get_price_cats.recordcount gt 1>
                for(i=0; i<form_basket.PRICE_CATS.length; i++)
                    form_basket.PRICE_CATS[i].checked = deger;
            <cfelseif get_price_cats.recordcount eq 1>
                form_basket.PRICE_CATS.checked = deger;
            </cfif>
        }
        
        function kontrol()
        {
			unformat_fields();
            product_id_list='';
            stock_id_list='';
            x = (250 - document.form_basket.detail.value.length);
            if ( x < 0)
            { 
                alert ("<cf_get_lang_main no ='217.Açıklama '> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>!");
                return false;
            }
            if(form_basket.herkes != undefined)
                temp3 = form_basket.herkes.checked;
            else
                temp3 = 1;
            temp1 = 0;
            if(form_basket.PRICE_CATS != undefined)
            {
                <cfif get_price_cats.recordcount gt 1>
                    for(i=0;i<form_basket.PRICE_CATS.length;i++)
                        if (form_basket.PRICE_CATS[i].checked==1)
                            temp1 = 1;
                <cfelseif get_price_cats.recordcount eq 1>
                    if (form_basket.PRICE_CATS.checked==1)
                        temp1 = 1;
                </cfif>
            }
            
            if(row_count==0)
            {
                alert("<cf_get_lang_main no='313.ürün seçiniz'>");
                return false;
            }
                    
            if (form_basket.is_public != undefined && form_basket.is_public.checked==1)
                temp1 = 1;		
            if ((temp1 == 0) && (temp3 == 0))
            {
                alert("<cf_get_lang no ='789.Aksiyonu Fiyat Listesine Bağlamalısınız'> !");
                return false;
            }
            for(var i=1; i<=row_count; i++)
            {
                if(eval("form_basket.disc_ount1"+i) != undefined)
                {
                    var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='792.no lu satırdaki İskonto 1 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='793.no lu satırdaki İskonto 2 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='794.no lu satırdaki İskonto 3 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='795. no lu satırdaki İskonto 4 alanındaki değer, 0 ile 100 arasında olmalı'> !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='796.no lu satırdaki İskonto 5 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='797.no lu satırdaki İskonto 6 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='798.no lu satırdaki İskonto 7 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='799.no lu satırdaki İskonto 8 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='800.no lu satırdaki İskonto 9 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                    var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me_value=filterNum(str_me.value);
                    if(str_me_value < 0 || str_me_value > 100) {alert(i + "<cf_get_lang no ='801.no lu satırdaki İskonto 10 alanındaki değer, 0 ile 100 arasında olmalı'>  !"); str_me.focus(); return false;}
                }
                //Ayni urun bir satirlarda bir kez secilmeli BK 20100907
                if(eval("document.form_basket.row_kontrol"+i).value==1)	
                {
                    if(document.getElementById('stock_id'+i).value=="")
                    {
                        temp_product_id = "'"+eval("form_basket.product_id"+i).value+"'";
                        if(list_find(product_id_list,temp_product_id,','))
                        {
                            alert("Aynı Ürünü Bir Defa Seçebilirsiniz !");
                            return false;
                        }
                        else
                        {
                            if(list_len(product_id_list,',') == 0)
                                product_id_list+=temp_product_id;
                            else
                                product_id_list+=","+temp_product_id;
                        }
                    }
                    else
                    {
                        temp_stock_id = "'"+eval("form_basket.stock_id"+i).value+"'";
                        if(list_find(stock_id_list,temp_stock_id,','))
                        {
                            alert("Aynı Ürünü Bir Defa Seçebilirsiniz !");
                            return false;
                        }
                        else
                        {
                            if(list_len(stock_id_list,',') == 0)
                                stock_id_list+=temp_stock_id;
                            else
                                stock_id_list+=","+temp_stock_id;
                        }		
                    }
                }
            }
        
            <cfif get_catalog_detail.is_applied neq 1 and isdefined("extra_price_list") and len(extra_price_list)>
                if(form_basket.process_stage.value ==  -2)
                {
                    if(confirm("<cf_get_lang no ='939.Kataloğu Yayın Aşamasına Getirdiniz Ürünler İçin Satırdaki Tüm Fiyat Listelerine Fiyat Yazılacak Emin misiniz?'>") == true)
                        return true;
                    else
                        return false;
                }
            </cfif>
            if(date_check(form_basket.startdate,form_basket.finishdate,"<cf_get_lang no ='790.Geçerlilik Tarihleri Hatalı, Lütfen Düzeltin'> !"))
            {
                if(form_basket.kondusyon_date != undefined)
                {
                    if(date_check(form_basket.kondusyon_date,form_basket.finishdate,"<cf_get_lang no ='791.Kondüsyon Tarihi Geçerlilik Bitişinden Önce Olmalı, Lütfen Düzeltin '>!"))
                        return true;
                    else
                        return false;
                }
                else
                    return true;
            }
            else
                return false;
			return true;
        }
        
        function unformat_fields()
        {
            var round_num_ = "<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>";
            for(var i=1; i<=row_count; i++)
            {
                var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.p_price_kdv"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount3"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount4"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount5"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount6"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount7"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount8"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount9"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.disc_ount10"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.row_nettotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.returning_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.returning_price_kdvsiz"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.action_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.returning_price_disc"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);		
                var str_me=eval("form_basket.rebate_cash_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.rebate_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.extra_product_1"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.extra_product_2"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.return_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.return_rate"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.price_protection_day"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.unit_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.total_sale"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.new_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                var str_me=eval("form_basket.new_marj"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
            <cfif isdefined("extra_price_list") and len(extra_price_list)>
                <cfoutput query="get_price_cat_row">
                    var str_me=eval("form_basket.new_price_kdv#get_price_cat_row.price_catid#"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,round_num_);
                </cfoutput>
            </cfif>
            }
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_catalog_promotion';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_catalog_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_catalog_promotion';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_catalog_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_catalog_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_catalog_promotion&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('detail_catalog','detail_catalog_sepet')";


	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_catalog_promotion';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/detail_catalog_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_catalog_promotion.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_catalog_promotion';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##get_catalog_detail.catalog_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_catalog_detail.catalog_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('detail_catalog','detail_catalog_basket')";
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.emptypopup_del_catalog_promotion';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_catalog_promotion.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_catalog_promotion.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_catalog_promotion';
	}
	
	if(attributes.event is 'add')
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		if(isdefined("extra_price_list") and len(extra_price_list)){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'Excel İmport';		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.form_add_catalog_from_file','page')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_catalog_promotion_history&catalog_id=#attributes.id#','longpage','catalog_promotion_history')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=product.form_upd_catalog_promotion&action_name=id&action_id=#attributes.id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[197]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_list_action_condition_product_stocks&catalog_promotion_id=#attributes.id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[455]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_list_catalog_promotion_pluses&catalog_promotion_id=#attributes.id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[841]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.emptypopup_save_action_barcodes&catalog_id=#attributes.id#&x_active_for_barcode_file=#x_active_for_barcode_file#','small')";
		i=5;
		if (get_catalog_detail.is_applied neq 1){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[103]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_cat_prom_actions&catalog_id=#get_catalog_detail.catalog_id#','longpage')";
			i=i+1;
		}
		if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
			if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[839]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_segmentation&catalog_id=#get_catalog_detail.catalog_id#','list_horizantal')";
				i=i+1;
			}
		}
		if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
			if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[838]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_premium&catalog_id=#get_catalog_detail.catalog_id#','horizantal')";
				i=i+1;
			}
		}
		if (not listfindnocase(denied_pages,'product.popup_form_add_copy_catalog_prom')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[825]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_form_add_copy_catalog_prom&id=#get_catalog_detail.catalog_id#','small')";
			i=i+1;
		}
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Save As';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_catalog_promotion&action=excel&module=product#page_code#','page')";
		i=i+1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_catalog_promotion&action=print&module=product#page_code#','page')";
		if (not listfindnocase(denied_pages,'product.form_add_new_catalog_prom')){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['onClick'] = "windowopen('#request.self#?fuseaction=product.form_add_new_catalog_prom&id=#get_catalog_detail.catalog_id#')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_catalog_promotion&event=add','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listCatalogPromotionController';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CATALOG_PROMOTION';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-CATALOG_HEAD','item-startdate','item-process_stage','item-PRICE_CATS']";
	
</cfscript>