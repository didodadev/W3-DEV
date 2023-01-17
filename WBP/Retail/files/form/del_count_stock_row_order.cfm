
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
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID = #get_order.DEPARTMENT_ID#
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cf_popup_box title="Stok Düzenleme Listesi Silme">
<cfform name="add_form" action="#request.self#?fuseaction=retail.popup_del_stock_count_order">
<cfinput type="hidden" name="order_id" value="#attributes.order_id#">
<cfif get_order.count_type gt 1>
	<b style="color:red;">&nbsp;&nbsp;Bu Emri Sadece Ana Emirden Düzenleyebilirsiniz.</b>
<cfelse>
	<table>
    	<tr>
        	<td colspan="3">Dikkat!!! <BR><BR>Bu sayfa yapılan silme işlemi ile aşağıdaki kayıtlar silinecektir!!!<BR><BR></td>
        </tr>
               <tr>
        	<td>Stok Hareket Tarihi</td>
            <td>:</td>
            <td>
            	<cfoutput>#dateformat(get_order.order_date,'dd/mm/yyyy')#</cfoutput>
            </td>
        </tr>       
        <tr>
        	<td>Departman</td>
            <td>:</td>
            <td>
            	<cfoutput>#GET_ALL_LOCATION.DEPARTMENT_HEAD#</cfoutput>
            </td>
        </tr>
        <tr>
        	<td>Stok Listesi</td>
            <td>:</td>
            <td>
            	<cfoutput>#attributes.table_code#</cfoutput> numaralı Stok Düzenleme Listesi
            </td>
        </tr>
        <tr>
        	<td>Stok Hareketler</td>
            <td>:</td>
            <td>
            	<cfoutput>#attributes.table_code#</cfoutput> Stok Düzenleme Listesinde bulunan stokların hareketleri
            </td>
        </tr>
    </table>  
    <cf_popup_box_footer>
    	&nbsp;<input type="button" value="Stok Fişi Sil" onclick="gonder();" name="gonder_btn"></a>
    </cf_popup_box_footer>
</cfif> 
</cfform>
</cf_popup_box>


<script>
	function gonder()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_del_count_stock_row_order</cfoutput>';
		adres_ += '<cfoutput>&order_id=#attributes.order_id#&table_code=#attributes.table_code#</cfoutput>';
		windowopen(adres_,'wide2');
		close();
	}
</script>


