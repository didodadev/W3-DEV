<cfparam name="attributes.type" default="">
<cfquery name="GET_TESTS" datasource="#DSN3#">
    SELECT TEST_HEAD,SERVICE_TEST_ID FROM SERVICE_TEST WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfif attributes.type eq 1>
    <cf_flat_list>
        <tbody>
            <cfif get_tests.recordcount>
                <cfoutput query="get_tests">
                    <tr>
                        <td>#test_head#</td>
                        <td width="20">
                            <cfif not listfindnocase(denied_pages,'service.popup_upd_service_test')>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=service.popup_upd_service_test&service_id=#attributes.service_id#&service_test_id=#service_test_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="2"><cf_get_lang dictionary_id="57484.Kayıt Bulunamadı">! </td>
                </tr>                 
            </cfif>
        </tbody>
    </cf_flat_list>
<cfelseif attributes.type eq 2>
    <cf_flat_list>
        <cfquery name="GET_ORDER_RESULT_QUALITY" datasource="#DSN3#">
            SELECT 
                ORQ.OR_Q_ID,
                ORQ.STOCK_ID,
                S.PRODUCT_NAME,
                PTR.STAGE
            FROM 
                ORDER_RESULT_QUALITY ORQ,
                #dsn_alias#.PROCESS_TYPE_ROWS PTR,
                STOCKS S
            WHERE 
                S.STOCK_ID = ORQ.STOCK_ID AND
                ORQ.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
                PTR.PROCESS_ROW_ID = ORQ.STAGE AND
                ORQ.PROCESS_CAT NOT IN(76,811) AND 
                ORQ.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <tbody>
			<cfoutput query="get_order_result_quality">
                <cfif len(stock_id)>
                    <tr>
                        <td>#stage# - #PRODUCT_NAME#</td>
                        <td width="20">
                            <cfif not listfindnocase(denied_pages,'prod.popup_add_quality_control_report')>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=prod.popup_upd_quality_control_report_rows&or_q_id=#or_q_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='41790.Test Sonucu Güncelle'>"></i></a>
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </cfoutput>
            <cfif not get_order_result_quality.recordcount>
                <tr>
                    <td colspan="2">
                        <cf_get_lang dictionary_id="57484.Kayıt Bulunamadı">!
                    </td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
<cfelse>
    <cf_flat_list>
        <tbody>
            <tr>
                <td><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57657.Ürün"></td>
            </tr>
        </tbody>
    </cf_flat_list>
</cfif>            
