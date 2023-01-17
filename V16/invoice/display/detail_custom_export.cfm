<!---
    File: detail_custom_export.cfm
    Controller: CustomExportController.cfm
    Folder: invoice\form\upd_custom_export.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 2002/02/20 14:23:21
    Description:Dış Ticaret > İhracat İşlemleri detay sayfası.
    History:      
    To Do:
--->
<cf_xml_page_edit fuseact="invoice.list_bill_FTexport">
<cfparam name="attributes.iid" default="#url.export_invoice_id#">
<cfset getComponent = createObject('component','V16.invoice.cfc.custom_export')>
<cfset getCustomDecleration=getComponent.GET_CUSTOM_DECLERATION(export_id:url.export_id)>
<cfset pageHead = "#getlang('main',4549)# : #getCustomDecleration.DECLERATION_NO#">
<cfinclude template="../query/get_sale_det.cfm">
<cf_catalystHeader>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58133.Fatura No'></cfsavecontent>
<cfsavecontent variable="message_1"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></cfsavecontent>
<div class="col col-9 col-xs-12"> <!---///content sol--->
    <cf_box title="#message#: #get_sale_det.invoice_number# / #message_1#: #dateformat(get_sale_det.invoice_date,dateformat_style)#" closable="0" box_page="V16/invoice/form/upd_custom_export.cfm?iid=#attributes.iid#&export_id=#url.export_id#&invoice_paper_no=#get_sale_det.invoice_number#&fatura_date=#dateformat(get_sale_det.invoice_date,dateformat_style)#"></cf_box>

    <cf_box title="#getlang('','Fatura Satırları','64342')#" closable="0">
        <cfparam name="attributes.page" default="1">
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
        <cfscript>
        get_bill_action = createObject("component", "V16.invoice.cfc.get_bill");
        get_bill_action.dsn2 = dsn2;
        get_bill_action.dsn_alias = dsn_alias;
        get_bill_action.dsn3_alias = dsn3_alias;
        get_bill = get_bill_action.get_bill_fnc
            (
                listing_type : 2,
                invoice_id : '#attributes.iid#',
                startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
                );
        </cfscript>    
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='29412.Seri'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th nowrap="nowrap"><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                    <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>  
                    <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57212.KDV siz Toplam'></th>
                    <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                    <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id ='57386.Döviz Net Toplam'></th>
                    <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id ='57391.Tevkifat Oranı'></th>
                    <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_bill.recordcount>
                    <cfoutput query="get_bill">
                        <tr>
                            <td>#get_bill.serial_number#</td>
                            <td>#dateformat(invoice_date,dateformat_style)#</td>
                            <td>#dateformat(record_date,dateformat_style)#</td>			
                            <td>#Member_Code#</td>       
                            <td>#stock_code#</td>
                            <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#name_product#</a></td>
                            <td>#TLFormat(amount)#</td>
                            <td>#TLFormat(price)#</td>
                            <td>
                                <cfif len(get_bill.company_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_bill.company_id#','medium');">#fullname#</a>
                                <cfelseif len(get_bill.con_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_bill.con_id#','medium');">#consumer_name# #consumer_surname#</a>
                                <cfelse>
                                    #get_emp_info(get_bill.employee_id,0,1)#
                                </cfif>
                            </td>
                            <td><cfif len(get_bill.department_id) and LEN(branch_name)>#branch_name#</cfif></td>
                            <td>
                                <cfif isdefined("get_bill.project_id") and len(get_bill.project_id) and get_bill.project_id neq -1> 
                                    <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_bill.project_head#</a></td>
                                <cfelseif get_bill.project_id eq -1>
                                    <cf_get_lang dictionary_id='58459.projesiz'>
                                </cfif>
                            </td>
                            <td>#dateformat(due_date,dateformat_style)#</td>	
                            <td>#TLFormat(get_bill.nettotal + get_bill.otvtotal)# </td>
                            <td>#session.ep.money#</td>
                            <td>#TLFormat(get_bill.nettotal + get_bill.taxtotal + get_bill.otvtotal + get_bill.bsmv_total + get_bill.oiv_total)# </td>
                            <td>#session.ep.money#</td>
                            <td>#TLFormat(get_bill.row_other_value)#</td>
                            <td>#row_money#</td>
                            <td>#TLFormat(get_bill.tevkifat_oran)#</td> 
                            <td><cfif len(paymethod)>#paymethod#<cfelseif len(card_no)>#card_no#</cfif></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<div class="col col-3 col-xs-12"><!---///content sağ--->
    <cf_box title="#getlang('','Fatura Özeti','64358')#" closable="0">
        <cfform name="form_process_invoice" method="post" action="" enctype="multipart/form-data">
            <cf_box_elements vertical="0">
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58133.Fatura No'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfoutput>#get_sale_det.invoice_number#</cfoutput>
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfoutput>#dateformat(get_sale_det.invoice_date,dateformat_style)#</cfoutput>
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='40683.İşlem Kategorisi'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfif len(get_sale_det.process_cat)>
                        <cfset get_invoice_process_cat=getComponent.get_invoice_export_process_cat(process_cat:get_sale_det.process_cat)>
                        <cfoutput>#get_invoice_process_cat.process_cat#</cfoutput>
                        </cfif>
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id="57167.İntaç Tarihi"></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="realization_date" id="realization_date"  value="#dateformat(get_sale_det.realization_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="realization_date" call_function="change_money_info"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id="57629.Açıklama"></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="detail_invoice" id="detail_invoice"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='125' is_detail='1' select_value='#get_sale_det.process_stage#'>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <div class="form-group">
                    <cf_workcube_buttons is_upd='0' add_function='updatedInvoice()'>
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function updatedInvoice() {
        export_invoice_id = <cfoutput>#url.export_invoice_id#</cfoutput>;
		detail_invoice = $("#detail_invoice").val();
		invoice_stage = $("#process_stage").val();
        realization_date = $("#realization_date").val();
        old_process_line = $("#old_process_line").val();
        fuseaction = "<cfoutput>#attributes.fuseaction#</cfoutput>";
        <cfif is_invoice_export_custom eq 1>
            is_invoice_export_custom = 1;
        <cfelse>
            is_invoice_export_custom = 0;
        </cfif>
		$.ajax({ 
            type:'POST',  
            url:'V16/invoice/cfc/custom_export.cfc?method=UPD_INVOICE_EXPORT',
            data: { 
				export_invoice_id : export_invoice_id,
				detail_invoice:detail_invoice,
				invoice_stage:invoice_stage,
                realization_date:realization_date,
                old_process_line:old_process_line,
                is_invoice_export_custom : is_invoice_export_custom,
				fuseaction:fuseaction
            },
            success: function(returnData){
                if(returnData == "true"){
					alert("<cf_get_lang dictionary_id='44003.İşlem Başarılı'>");
				}
				else{
					alert("<cf_get_lang dictionary_id='65273.İlgili fatura için daha önce beyanname kaydı yapılmıştır'>!");
					return false;
                }
            },
            error: function ()
            {
                console.log('CODE:8 please, try again..');
                return false;
            }
        });
		return false;
	}
</script>