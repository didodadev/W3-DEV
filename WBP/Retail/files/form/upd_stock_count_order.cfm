<cfquery name="GET_ALL_LOCATION" datasource="#dsn#">
	SELECT 
    	D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
        (
            (
            D.IS_STORE IN (1,3) AND
            ISNULL(D.IS_PRODUCTION,0) = 0
            )
            OR
            D.DEPARTMENT_ID = #firin_depo_id#
        ) AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.PRODUCT_CAT,
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT
    ORDER BY 
        HIERARCHY ASC
</cfquery>
<cfset hierarchy_list = valuelist(GET_PRODUCT_CAT.HIERARCHY)>
<cfset hierarchy_name_list = valuelist(GET_PRODUCT_CAT.PRODUCT_CAT,'╗')>

<cfquery name="GET_PRODUCT_CAT1" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY NOT LIKE '%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT2" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%' AND
        HIERARCHY NOT LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT3" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="get_order" datasource="#dsn_dev#">
	SELECT 
    	*,
    	ISNULL((SELECT TABLE_CODE FROM STOCK_MANAGE_TABLES WHERE ORDER_ID = #attributes.order_id#),0) AS STOCK_TABLE,
        (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = STOCK_COUNT_ORDERS.DEPARTMENT_ID) DEPARTMENT_HEAD
    FROM 
    	STOCK_COUNT_ORDERS 
    WHERE 
    	ORDER_ID = #attributes.order_id#    
</cfquery>
<cfquery name="get_manage_table" datasource="#dsn_dev#">
	SELECT * FROM STOCK_MANAGE_TABLES WHERE ORDER_ID = #attributes.order_id#    
</cfquery>
<cfquery name="get_order_product_cats" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS_PRODUCT_CATS WHERE ORDER_ID = #attributes.order_id#
</cfquery>

<cfquery name="get_order_products" datasource="#dsn_dev#">
	SELECT 
    	SCOS.STOCK_ID,
        S.PROPERTY
    FROM 
    	STOCK_COUNT_ORDERS_STOCKS SCOS,
        #DSN1_ALIAS#.STOCKS S
    WHERE 
    	SCOS.ORDER_ID = #attributes.order_id# AND
        SCOS.STOCK_ID = S.STOCK_ID
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_form" action="" enctype="multipart/form-data">
            <cfif get_order.STOCK_TABLE eq 0>
            <cfinput type="hidden" id="table_code" name="table_code" value="">
            <cfelse>
            <cfinput type="hidden" id="table_code" name="table_code" value="#get_order.STOCK_TABLE#">
            </cfif>
            <cfinput type="hidden" name="order_id" value="#attributes.order_id#">
            <cfif get_order.count_type gt 1>
                <b style="color:red;">&nbsp;&nbsp;<cf_get_lang dictionary_id='62436.Bu Emri Sadece Ana Emirden Düzenleyebilirsiniz.'></b>
            <cfelse>
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12" type="column" index="1" sort="true">
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="status" id="status" value="1" <cfif get_order.status eq 1>checked</cfif>/> <cf_get_lang dictionary_id='57493.Aktif'>
                            </label>
                        </div>
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_closed" id="is_closed" value="1" <cfif get_order.is_closed eq 1>checked</cfif>/> <cf_get_lang dictionary_id='62437.Sayıma Kapalı'>
                            </label>
                        </div>
                        <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <input type="checkbox" name="is_update" id="is_update" value="1" <cfif get_order.is_update eq 1>checked</cfif>/> <cf_get_lang dictionary_id='62438.Düzeltme Yapılabilir'>
                            </label>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="text" name="order_date" id="order_date" value="#dateformat(get_order.order_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="order_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="text" name="order_detail" value="#get_order.order_detail#" required="yes" message="Sayım Açıklaması Giriniz!" style="width:200px;" maxlength="100">
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="order_type" id="order_type">
                                    <option value="0" <cfif get_order.order_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58430.Kademesiz'></option>
                                    <option value="1" <cfif get_order.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58432.Kademeli'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35449.Departman'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="department_id" id="department_id">
                                    <cfoutput query="GET_ALL_LOCATION"><option value="#department_id#" <cfif get_order.department_id eq department_id>selected</cfif>>#department_head#</option></cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                            <div class="col col-8 col-sm-12">
                                <cfif get_order_product_cats.recordcount>
                                    <cfset h_list_ = valuelist(get_order_product_cats.product_cat)>
                                <cfelse>
                                    <cfset h_list_ = ''>
                                </cfif>
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT1"
                                    selected_text="" 
                                    name="hierarchy1"
                                    option_text="#getLang('','Ana Grup',61641)#" 
                                    width="200"
                                    height="250"
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="#h_list_#">
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'></label>
                            <div class="col col-8 col-sm-12">
                                <cfif get_order_product_cats.recordcount>
                                    <cfset h_list_ = valuelist(get_order_product_cats.product_cat)>
                                <cfelse>
                                    <cfset h_list_ = ''>
                                </cfif>
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT2"
                                    selected_text="" 
                                    name="hierarchy2"
                                    option_text="#getLang('','Alt Grup',61642)#" 
                                    width="200"
                                    height="250"
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="#h_list_#">
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 2</label>
                            <div class="col col-8 col-sm-12">
                                <cfif get_order_product_cats.recordcount>
                                    <cfset h_list_ = valuelist(get_order_product_cats.product_cat)>
                                <cfelse>
                                    <cfset h_list_ = ''>
                                </cfif>
                                <cf_multiselect_check 
                                    query_name="GET_PRODUCT_CAT3"
                                    selected_text="" 
                                    name="hierarchy3"
                                    option_text="#getLang('','Alt Grup',61642)# 2" 
                                    width="200"
                                    height="250"
                                    option_name="PRODUCT_CAT_NEW" 
                                    option_value="hierarchy"
                                    value="#h_list_#">
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57691.Dosya'></label>
                            <div class="col col-8 col-sm-12">
                                <cfinput type="file" name="excel_file">
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57452.Stok'></label>
                            <div class="col col-8 col-sm-12">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=1</cfoutput>','list');"><i class="fa fa-plus"></i></a>
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_stock_count_orders&event=delRow&order_id=#attributes.order_id#</cfoutput>','list');"><i class="fa fa-trash"></i></a>
                            </div>
                        </div>
                        <div id="product_div">
                            <cfoutput query="get_order_products">
                                <div id="selected_product_#stock_id#">
                                    <a href="javascript://" onclick="del_row_p('#stock_id#')"><img src="/images/delete_list.gif"></a>
                                    <input type="hidden" name="search_product_id" value="#stock_id#">
                                    #property#
                                </div>
                            </cfoutput>
                        </div>
                        <cfif get_order.STOCK_TABLE neq 0>
                            <cfquery name="get_stock_row" datasource="#dsn2#">
                                SELECT * FROM STOCKS_ROW WHERE WRK_ROW_ID = '#get_order.STOCK_TABLE#'
                            </cfquery>
                            <div class="form-group">
                                <label color="##ff0000"><cf_get_lang dictionary_id='62439.Bu Sayım Belgesi için Stok Fişi oluşturulmuş. Belgeyi düzenlemek için Stok Fişlerini silmelisiniz'>!!!</label>
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62440.Stok Düzenleme Tablosu'> :</label>
                                <div class="col col-4 col-sm-12">
                                    <cfoutput><a href="#request.self#?fuseaction=retail.manage_stocks&table_code=#get_order.STOCK_TABLE#&is_form_submitted=1" target="_blank" class="tableyazi">#get_order.STOCK_TABLE#</a></cfoutput>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62441.Stok Hareket Sayısı'> :</label>
                                <div class="col col-4 col-sm-12">
                                    <cfoutput>#get_stock_row.recordcount#</cfoutput>
                                </div>
                            </div>
                            <div class="form-group">
                                <input type="button" value="Stok Fişi Sil" onclick="sil_gonder();" name="gonder_sil_btn">
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cfif get_order.STOCK_TABLE eq 0>        	
                        <cfsavecontent variable="extra_">
                            <input type="button" value="<cf_get_lang dictionary_id='62443.Sayım Fişi Oluştur'>" onclick="gonder(0);" name="gonder_btn">   
                            <input type="button" value="<cf_get_lang dictionary_id='62444.Sıfırlama Yaparak Sayım Fişi Oluştur'>" onclick="gonder(1);" name="gonder_btn">
                        </cfsavecontent>
                        <cf_workcube_buttons is_upd="1" extra_info="#extra_#" delete_page_url="#request.self#?fuseaction=retail.list_stock_count_orders&event=del&order_id=#attributes.order_id#">
                    <cfelse>
                        <cf_get_lang dictionary_id='62442.Sayım Fişi Oluşturulduğu İçin Güncelleme Yapılamaz'>!
                    </cfif>
                </cf_box_footer>
            </cfif>
        </cfform>
    </cf_box>
</div>
        	
          


<script>
	function gonder(type)
	{
		if (confirm('<cf_get_lang dictionary_id='62445.Sayım Fişi Oluşturulsun mu'>?')) 
		{	
			adres_ = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_add_stocks_row_count_order</cfoutput>';
			adres_ += '<cfoutput>&order_date=#get_order.order_date#&order_id=#attributes.order_id#&department_id=#get_order.department_id#&department_head=#get_order.department_head#&type=</cfoutput>'+type;
			windowopen(adres_,'small');
		}
	}
	function sil_gonder()
	{
		if (confirm('<cf_get_lang dictionary_id='62446.Sayım Fişi silinsin mi'>?')) 
		{
			adres_ = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_del_count_stock_row_order</cfoutput>';
			adres_ += '<cfoutput>&order_id=#get_order.order_id#&table_code=#get_order.STOCK_TABLE#</cfoutput>';
			windowopen(adres_,'small');	
		}
	}
	function add_row(pid_,pname_,psales_)
	{
		icerik_ = '<div id="selected_product_' + pid_ + '">';
		icerik_ += '<a href="javascript://" onclick="del_row_p(' + pid_ +')">';
		icerik_ += '<i class="fa fa-minus"></i>';
		icerik_ += '</a>';
		icerik_ += '<input type="hidden" name="search_product_id" value="' + pid_ + '">';
		icerik_ += pname_;
		icerik_ += '</div>';
		
		$('#product_div').append(icerik_);
	}
	function del_row_p(pid_)
	{
		$("#selected_product_" + pid_).remove();	
	}

</script>