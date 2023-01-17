<cf_xml_page_edit fuseact="invoice.popup_cancel_invoice">
    <cfinclude template="../../invoice/query/get_inv_cancel_types.cfm">

    <cfquery name="GET_SALE_DET" datasource="#DSN2#">
        SELECT
            ISNULL(IS_IPTAL,0) IS_IPTAL,
            CANCEL_TYPE_ID,
            UPDATE_EMP,
            UPDATE_DATE,
            INVOICE_DATE 
        FROM
            INVOICE
        WHERE
            INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
    </cfquery>

    <cfif len(xml_cancel_day) and xml_cancel_day neq 0>
        <cfif month(get_sale_det.invoice_date) neq 12>
            <cfset new_date = createodbcdatetime(DateAdd('d',xml_cancel_day,createodbcdatetime('#year(get_sale_det.invoice_date)#-#month(get_sale_det.invoice_date)+1#-01')))>
        <cfelse>
            <cfset new_date = createodbcdatetime(DateAdd('d',xml_cancel_day,createodbcdatetime('#year(get_sale_det.invoice_date)#-#month(get_sale_det.invoice_date)#-#day(get_sale_det.invoice_date)#')))>
        </cfif>
        <cfset action_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
        <cfif action_date gt new_date>
            <script>
                alert("<cf_get_lang dictionary_id='59862.Fatura İptal Tarihi Geçtiği İçin İptal İşlemi Yapamazsınız'> !");
                this.close();
            </script>
        </cfif>
    </cfif> 
    <cf_box title="Fatura İptal" closable="1" popup_box="1">
        <cfform name="list_cancel" method="post">
           <input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#attributes.invoice_id#</cfoutput>">
            <div class="row">
                <div class="col col-6">
                    <div class="form-group" id="item-date">
                        <label class="col col-12"><cf_get_lang dictionary_id="57748.İptal Tarihi"></label>
                        <div class="col col-12"> 
                            <input type="text" name="invoice_date" id="invoice_date" value="<cfoutput>#dateformat(get_sale_det.invoice_date,'dd/mm/yyyy')#</cfoutput>" readonly>
                         </div>
                    </div>
                    <div class="form-group" id="item-cancel_type_id">    
                        <label class="col col-12"><cf_get_lang dictionary_id='58825.İptal Nedeni'></label>
                        <div class="col col-12">
                            <select name="cancel_type_id" id="cancel_type_id" style="width:140px;">
                                <option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
                                <cfoutput query="get_inv_cancel_types">
                                    <option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="row formContentFooter">
                    <div class="col col-6">
                        <cfoutput>
                            <cfif len(get_sale_det.update_emp)>
                                <br/><cf_get_lang dictionary_id='57703.Son Güncelleme'>: #get_emp_info(get_sale_det.update_emp,0,0)# - #dateformat(get_sale_det.update_date,'dd/mm/yyyy')#
                            </cfif>
                        </cfoutput>
                    </div>
                    <div class="col col-6">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59863.Fatura İptal Edilecektir. Emin misiniz?"></cfsavecontent>
                        <cfif get_sale_det.is_iptal eq 0>
                            <cf_workcube_buttons is_upd='0' insert_alert='#message#' add_function='kontrol()'>
                        <cfelse>
                            <font color="FF0000"><cf_get_lang dictionary_id="59833.Fatura İptal Edildi">.</font>
                        </cfif>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        function kontrol()
        {
            if(!chk_period(list_cancel.invoice_date,"İşlem")) return false;
            return true;
        }
    </script>