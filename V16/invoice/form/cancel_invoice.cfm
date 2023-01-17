<cf_xml_page_edit fuseact="invoice.popup_cancel_invoice">
<cfinclude template="../../invoice/query/get_inv_cancel_types.cfm">
<cfif isdefined("attributes.invoice_id")>
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
            INVOICE_ID = #url.invoice_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_SALE_DET" datasource="#DSN2#">
        SELECT
            ISNULL(IS_IPTAL,0) IS_IPTAL,
            CANCEL_TYPE_ID,
            UPDATE_EMP,
            UPDATE_DATE,
            EXPENSE_DATE AS INVOICE_DATE
        FROM
            EXPENSE_ITEM_PLANS
        WHERE
            EXPENSE_ID = #url.expense_id#
	</cfquery>
</cfif> 

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
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Fatura İptal',58750)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_cancel" method="post" action="#request.self#?fuseaction=invoice.emptypopup_cancel_invoice">
		<cfif isdefined("url.invoice_id")><input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#url.invoice_id#</cfoutput>"></cfif>
        <cfif isdefined("url.expense_id")><input type="hidden" name="expense_id" id="expense_id" value="<cfoutput>#url.expense_id#</cfoutput>"></cfif>
        <cf_box_elements>
            <div class="col col-12 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-date">
                    <label class="col col-4"><cf_get_lang dictionary_id="57748.İptal Tarihi"></label>
                    <div class="col col-8"> 
                        <cfif isdefined("url.invoice_id")><input type="text" name="invoice_date" id="invoice_date" value="<cfoutput>#dateformat(get_sale_det.invoice_date,'dd/mm/yyyy')#</cfoutput>" readonly style="width:140px;"></cfif>
                        <cfif isdefined("url.expense_id")><input type="text" name="expense_date" id="expense_date" value="<cfoutput>#dateformat(get_sale_det.invoice_date,'dd/mm/yyyy')#</cfoutput>" readonly style="width:140px;"></cfif>
                    </div>
                </div>
                <div class="form-group" id="item-cancel_type_id">    
                    <label class="col col-4"><cf_get_lang dictionary_id='58825.İptal Nedeni'></label>
                    <div class="col col-8">
                        <select name="cancel_type_id" id="cancel_type_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_inv_cancel_types">
                                <option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-9">
                <cfoutput>
                    <cfif len(get_sale_det.update_emp)>
                        <cf_record_info query_name='get_sale_det'>
                    </cfif>
                </cfoutput>
            </div>
            <div class="col col-3">
                <cfif get_sale_det.is_iptal eq 0>
                    <cf_workcube_buttons is_upd='0' insert_alert='#getLang('','Fatura İptal Edilecektir. Emin misiniz?',59863)#' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('list_cancel' , #attributes.modal_id#)"),DE(""))#">
                <cfelse>
                    <label style="text-align:right;"><font color="FF0000"><cf_get_lang dictionary_id="59833.Fatura İptal Edildi">.</font></label>
                </cfif>
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		<cfif isdefined("url.invoice_id")>if(!chk_period(list_cancel.invoice_date,"İşlem")) return false;</cfif>
		<cfif isdefined("url.expense_id")>if(!chk_period(list_cancel.expense_date,"İşlem")) return false;</cfif>
		return true;
	}
</script>