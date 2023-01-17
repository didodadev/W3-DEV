<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset get_result = queries.get_prod_result_quality(
    branch: attributes.branch,
    warehouse: attributes.warehouse,
    station : attributes.station,
    start_date : attributes.start_date,
    finish_date : attributes.finish_date,
    stock_id : attributes.stock_id,
    product_name : attributes.stock_id 
)>
<cfif get_result.recordcount>
    <cfparam name="attributes.totalrecords" default=#get_result.recordcount#>
<cfelse>
    <cfparam name="attributes.totalrecords" default=0>
</cfif>

<cf_box title="#getLang('','Kalite Başarımına Göre Üretim Sonuçları','65435')#">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='45343.Kontrol No'></th>
                <th><cf_get_lang dictionary_id='40015.Üretim No'></th>
                <th><cf_get_lang dictionary_id='56969.Giriş Depo'></th>
                <th><cf_get_lang dictionary_id='58834.İstasyon'></th>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                <th><cf_get_lang dictionary_id='57657.Ürün'>-<cf_get_lang dictionary_id='36199.Açıklama'></th>
                <th class="text-right"><cf_get_lang dictionary_id='39137.Üretim Miktar'></th>
                <cfif get_quality_success.recordCount>
                    <cfoutput query="get_quality_success">
                        <th>#SUCCESS#</th>
                    </cfoutput>
                </cfif>
            </tr>
        </thead>
        <tbody>
            <cfif get_result.recordcount>
                <cfoutput query="get_result" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#q_control_no#</td>
                        <td>
                           #PROCESS_NUMBER#
                        </td>
                        <td>
                            <cfif len(department_in)>
                                <cfset get_dep_detail = queries.get_dep_detail(department_id:department_in)>
                                #get_dep_detail.DEPARTMENT_HEAD#
                            </cfif>
                        </td>
                        <td>
                            <cfif len(STATION_NAME)>
                                <cfset get_station = queries.get_station(station_id:STATION_NAME)>
                                #get_station.STATION_NAME#
                            </cfif>
                        </td>
                        <td>
                            <cfset get_stock_info = queries.get_stock_info(stock_id:stock_id)>
                            #get_stock_info.STOCK_CODE#
                        </td>
                        <td>
                            #get_stock_info.PRODUCT_NAME#
                        </td>
                        <td class="text-right">#TLFormat(quantity)#</td>
                        <cfif get_quality_success.recordCount>
                            <cfloop query="get_quality_success">
                                <cfif len(get_result.or_q_id)>
                                    <td class="text-right">
                                        <cfquery name="get_succes_type" datasource="#dsn3#">
                                            SELECT ISNULL(AMOUNT,0) AMOUNT FROM ORDER_RESULT_QUALITY_SUCCESS_TYPE
                                            WHERE ORDER_RESULT_QUALITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_result.or_q_id#">
                                            AND SUCCESS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#SUCCESS_ID#">
                                        </cfquery>
                                       <cfif len(get_succes_type.AMOUNT)>#get_succes_type.AMOUNT#<cfelse>0</cfif>
                                    </td>
                                <cfelse>
                                    <td class="text-right">0</td>
                                </cfif>
                            </cfloop>
                        </cfif>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif get_result.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
		</div>
	</cfif>
    <cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#attributes.fuseaction##url_str#">
</cf_box>