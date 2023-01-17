<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
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

<cfquery name="get_order" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>

<cfquery name="get_order_product_cats" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS_PRODUCT_CATS WHERE ORDER_ID = #attributes.order_id#
</cfquery>

<cf_popup_box title="Sayım Emri Düzenle">
<cfform name="add_form" action="#request.self#?fuseaction=retail.emptypopup_upd_stock_count_order">
<cfinput type="hidden" name="order_id" value="#attributes.order_id#">
<cfif get_order.count_type gt 1>
	<b style="color:red;">&nbsp;&nbsp;Bu Emri Sadece Ana Emirden Düzenleyebilirsiniz.</b>
<cfelse>
	<table>
    	<tr>
        	<td><input type="checkbox" name="status" id="status" value="1" <cfif get_order.status eq 1>checked</cfif>/> Aktif</td>
            <td>
            <input type="checkbox" name="is_closed" id="is_closed" value="1" <cfif get_order.is_closed eq 1>checked</cfif>/> Sayıma Kapalı
            &nbsp;&nbsp;
            <input type="checkbox" name="is_update" id="is_update" value="1" <cfif get_order.is_update eq 1>checked</cfif>/> Düzeltme Yapılabilir
            </td>
        </tr>
        <tr>
        	<td>İşlem Tarihi</td>
            <td>
            	<cfsavecontent variable="message">İşlem Tarihi Girmelisiniz!</cfsavecontent>
                <cfinput type="text" name="order_date" id="order_date" value="#dateformat(get_order.order_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                <cf_wrk_date_image date_field="order_date">
            </td>
        </tr>
        <tr>
        	<td>İşlem Tipi</td>
            <td>
            	<select name="order_type" id="order_type">
                    <option value="0" <cfif get_order.order_type eq 0>selected</cfif>>Kademesiz</option>
                    <option value="1" <cfif get_order.order_type eq 1>selected</cfif>>Kademeli</option>
                </select>
            </td>
        </tr>
        <tr>
        	<td>Departman</td>
            <td>
            	<select name="department_id" id="department_id">
                    <cfoutput query="GET_ALL_LOCATION"><option value="#department_id#" <cfif get_order.department_id eq department_id>selected</cfif>>#department_head#</option></cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td>Ana Grup</td>
            <td>
              <cfif get_order_product_cats.recordcount>
                	<cfset h_list_ = valuelist(get_order_product_cats.product_cat)>
                <cfelse>
                	<cfset h_list_ = ''>
                </cfif>
                <cf_multiselect_check 
                    query_name="GET_PRODUCT_CAT1"
                    selected_text="" 
                    name="hierarchy1"
                    option_text="Ana Grup" 
                    width="200"
                    height="250"
                    option_name="PRODUCT_CAT_NEW" 
                    option_value="hierarchy"
                    value="#h_list_#">
            </td>
        </tr>
       <!--- <tr>
            <td>Kapama Şekli</td>
            <td>
             	<input type="checkbox" name="kapama_tipi" id="kapama_tipi" checked/> Seçili İse Sadece Sayımı Yapılmış Olanları Kapatır
            </td>
        </tr>--->
    </table>  
    <cf_popup_box_footer>
    	<input type="button" value="Stok Fişi Oluştur" onclick="gonder();" name="gonder_btn"></a><cf_workcube_buttons is_upd="1" delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_stock_count_order&order_id=#attributes.order_id#">
    </cf_popup_box_footer>
</cfif> 
</cfform>
</cf_popup_box>


<script>
	function gonder()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_add_stocks_row_count_order</cfoutput>';
		adres_ += '<cfoutput>&order_date=#get_order.order_date#&order_id=#attributes.order_id#&department_id=#get_order.department_id#&department_head=#GET_ALL_LOCATION.department_head#</cfoutput>';
		windowopen(adres_,'wide2');
		
	}
</script>


