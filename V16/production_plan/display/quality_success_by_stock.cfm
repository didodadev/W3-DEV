<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset get_result_by_stock = queries.get_quality_success_by_stock(
    branch: attributes.branch,
    warehouse:attributes.warehouse,
    station:attributes.station,
    start_date:attributes.start_date,
    finish_date:attributes.finish_date,
    stock_id : attributes.stock_id,
    product_name : attributes.stock_id 
)>
<cfif get_result_by_stock.recordcount>
    <cfparam name="attributes.totalrecords" default=#get_result_by_stock.recordcount#>
<cfelse>
    <cfparam name="attributes.totalrecords" default=0>
</cfif>
<cfset id_list= valueList(get_result_by_stock.stock_id,",")>
<cfloop list="id_list" index="i" item="b">
    
    
</cfloop>
    <cf_box title="#getLang('','Stok Bazında Kalite Başarımı','65436')#">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
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
            <cfif get_result_by_stock.recordcount>
                <cfoutput query="get_result_by_stock" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfset get_stock_info = queries.get_stock_info(stock_id:stock_id)>
                            #get_stock_info.STOCK_CODE#
                        </td>
                        <td>
                            #get_stock_info.PRODUCT_NAME#
                        </td>
                        <td class="text-right">#TLFormat(TOTAL_AMOUNT)#</td>
                        <cfquery name="get_q_detail" datasource="#dsn3#">
                            SELECT 
                                ORQ.OR_Q_ID,
                                ORQ.SUCCESS_ID
                            FROM 
                                ORDER_RESULT_QUALITY ORQ
                            WHERE ORQ.STOCK_ID = <cfqueryparam value="#stock_id#" cfsqltype="cf_sql_integer">
                            AND ORQ.OR_Q_ID NOT IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW ORQR WHERE ORQR.OR_Q_ID = ORQ.OR_Q_ID AND IS_REPROCESS = 1)
                            AND ORQ.PROCESS_CAT = 171
                        </cfquery>
                        <cfset q_id_list = valueList(get_q_detail.OR_Q_ID)>
                        <cfif get_quality_success.recordCount>
                            <cfloop query="get_quality_success">
                                <td class="text-right">
                                    <cfif listLen(q_id_list)>
                                        <cfquery name="get_succes_type" datasource="#dsn3#">
                                            SELECT SUM(ISNULL(AMOUNT,0)) AMOUNT FROM ORDER_RESULT_QUALITY_SUCCESS_TYPE
                                            WHERE ORDER_RESULT_QUALITY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#q_id_list#" list="yes">)
                                            AND SUCCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SUCCESS_ID#">
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_succes_type.AMOUNT =0>
                                    </cfif>
                                   <cfif len(get_succes_type.AMOUNT)> #get_succes_type.AMOUNT#<cfelse>0</cfif>
                                </td>
                            </cfloop>
                        </cfif>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif get_result_by_stock.recordcount eq 0>
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