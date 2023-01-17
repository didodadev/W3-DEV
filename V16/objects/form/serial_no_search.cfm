<cfquery name="get_stock_id" datasource="#dsn3#">
	SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33860.Seri No Ara'></cfsavecontent>
    <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_property" action="#request.self#?fuseaction=objects.popup_serial_no_search" method="post">
            <cf_box_search>
                <div class="form-group">
                    <input type="text" name="serial_no" id="serial_no"  value="<cfoutput>#attributes.serial_no#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57637.Serial No.'>" required="yes">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()#iif(isdefined("attributes.draggable"),DE("&&loadPopupBox('add_property' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
            <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cfif isdefined("attributes.is_store")>
                <input type="hidden" name="is_store" id="is_store" value="1">
            </cfif>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='57637.Seri No'></th>
                    <th><cf_get_lang dictionary_id ='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id ='33902.Stok Adı'></th>
                </tr>
            </thead>
            <cfif isdefined("attributes.form_submitted")>
                <cfquery name="get_seri_no" datasource="#dsn3#">
                    SELECT DISTINCT
                        SERIAL_NO,
                        STOCK_ID
                    FROM
                        SERVICE_GUARANTY_NEW
                    WHERE
                        SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#">
                        <cfif isdefined("attributes.is_store")>
                            AND 
                            (
                            DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
                            )
                        </cfif>
                </cfquery>
                <cfif get_seri_no.recordcount>
                    <cfquery name="get_product_name" datasource="#dsn3#">
                        SELECT
                            PRODUCT_NAME,
                            PROPERTY,
                            BARCOD
                        FROM
                            STOCKS
                        WHERE
                            STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_seri_no.STOCK_ID#">
                    </cfquery>
                </cfif>
            <cfelse>
                <cfset get_seri_no.RecordCount = 0>
            </cfif>
            <tbody>
                <cfif get_seri_no.RecordCount>
                    <cfoutput query="get_seri_no">
                        <tr>
                            <td>#serial_no#</td>
                            <td>#get_product_name.barcod#</td>
                            <td>#get_product_name.product_name# #get_product_name.property#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr> 
                        <td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<script>
    function kontrol() {
        if($('#serial_no').val()==""){
            alert("<cf_get_lang dictionary_id='41875.Please Enter Serial No.'>");
            return false;
        }
        return true;
    }
</script>
