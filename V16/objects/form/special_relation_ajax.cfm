<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57637.Seri No'></th>
            <th><cf_get_lang dictionary_id='57800.Işlem tipi'></th>
            <th><cf_get_lang dictionary_id='57574.Şirket'></th> 
            <!--- <th width="15"><a href="javascript://" onClick="open_add_specify_('<cfoutput>#attributes.product_serial_no#</cfoutput>','<cfoutput>#attributes.seri_stock_id#</cfoutput>');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></th> --->
        </tr>
    </thead>
    <tbody>
        <cfquery name="get_specify" datasource="#dsn3#">
            SELECT * FROM SERVICE_GUARANTY_NEW WHERE (PROCESS_CAT=1191 OR PROCESS_CAT=1192) AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#">
        </cfquery>
        <cfif get_specify.recordcount>
            <cfoutput query="get_specify">
                <tr class="color-row">
                    <td><a href="javascript://" onclick="open_update_specify('#guaranty_id#','#attributes.product_serial_no#','#attributes.seri_stock_id#');" class="tableyazi">#SERIAL_NO#</a></td>
                    <td><cfif PROCESS_CAT eq 1191><cf_get_lang dictionary_id='32858.Özel Giriş'><cfelse><cf_get_lang dictionary_id='32903.Özel çıkış'></cfif></td>
                    <td>&nbsp;</td> 
                    <!--- <td><a href="javascript://" onClick="open_update_specify('#guaranty_id#','#attributes.product_serial_no#','#attributes.seri_stock_id#');"><img src="/images/update_list.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td> --->
                </tr>
            </cfoutput>
        <cfelse>
            <tr height="20" class="color-row"> 
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
