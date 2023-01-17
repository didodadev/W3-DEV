<cfquery name="GET_LIST_" datasource="#DSN3#">
	SELECT 
		CATALOG_HEAD,
		STARTDATE,
		FINISHDATE 
	FROM
		CATALOG_PROMOTION
	WHERE
		CATALOG_ID = #attributes.catalog_promotion_id# 
</cfquery>
<cfquery name="GET_LIST" datasource="#DSN2#">
	SELECT 
		SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL,
		CPP.UNIT,
		SR.PROCESS_DATE,
		SR.PROCESS_TYPE,
		D.DEPARTMENT_HEAD,
		P.PRODUCT_NAME
	FROM
		#dsn3_alias#.CATALOG_PROMOTION_PRODUCTS CPP,
		STOCKS_ROW SR,
		#dsn_alias#.DEPARTMENT D,
		#dsn1_alias#.PRODUCT P
	WHERE
		CPP.PRODUCT_ID = SR.PRODUCT_ID AND
		SR.STORE = D.DEPARTMENT_ID AND
		CPP.PRODUCT_ID = P.PRODUCT_ID AND 
		CPP.CATALOG_ID = #attributes.catalog_promotion_id# AND 
		SR.PROCESS_DATE BETWEEN #createodbcdate(get_list_.startdate)# AND #createodbcdate(get_list_.finishdate)# 
	GROUP BY
		SR.PROCESS_DATE,
		SR.PROCESS_TYPE,
		CPP.UNIT,
		CPP.PRODUCT_ID,
		D.DEPARTMENT_HEAD,
		P.PRODUCT_NAME
	ORDER BY
		D.DEPARTMENT_HEAD,
		SR.PROCESS_DATE
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_list.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Aksiyon Tarihleri Arasındaki Stok Hareketleri',37516)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cf_grid_list>
			<thead>
       		 <tr>
				<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
				<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='37580.Promosyon Adı'></th>
				<th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
				<th width="200"><cf_get_lang dictionary_id='58578.Belge Türü'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			 </tr>
        </thead>
        <tbody>
			<cfif get_list.recordcount>		
                <cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                        <td>#get_list.department_head#</td>
                        <td height="20">#dateformat(process_date,dateformat_style)#</td> 
                        <td height="20">#get_list_.catalog_head#</td>
                        <td height="20">#get_list.product_name#</td>
                        <td height="20">#get_process_name(process_type)#</td>
                        <td align="right" style="text-align:right;">#AmountFormat(get_list.total)# #get_list.unit#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                    <tr class="color-row">
                        <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                    </tr>
            </cfif>
        </tbody>
		</cf_grid_list>
		<cfset adres="product.popup_list_action_condition_product_stocks&catalog_promotion_id=#attributes.catalog_promotion_id#">
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"> 
	</cf_box>
</div>
