<cfset packeting = createObject("component", "V16.stock.cfc.packeting")>
<cfset get_package = packeting.GET_PACKAGE(packet_id: attributes.packet_id)>
<cfif get_package.RELATED_TYPE eq 1 and len(get_package.ORDER_ID)>
    <cfset get_order_detail = packeting.get_order_detail(order_id: get_package.ORDER_ID)>
    <cfscript>session_basket_kur_ekle(action_id=get_package.ORDER_ID,table_type_id:3,process_type:1);</cfscript>
    <cfset associated_transaction_paper = get_order_detail.ORDER_NUMBER>
<cfelseif get_package.RELATED_TYPE eq 2 and len(get_package.PROD_RESULT_ID)>
    <cfset get_order_detail = packeting.get_pr_order_detail(pr_order_id: get_package.PROD_RESULT_ID)>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfset associated_transaction_paper = get_order_detail.ORDER_NUMBER>
</cfif>
<cfset get_package_type = packeting.GET_PACKAGE_TYPE()>
<cfset get_warehouse_rate_rows = packeting.GET_PACKAGE_TASKS(packet_id: attributes.packet_id)>
<cfset get_money = packeting.GET_MONEY()>
<cfset get_units = packeting.get_units_funcs()>
<cfset get_warehouse_task_types = packeting.get_warehouse_task_types_funcs()>
<cf_catalystHeader>

    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <div id="basket_main_div">
                <cfform name="form_basket">
                    <cf_basket_form id="add_packet">
                        <cfinput type="hidden" name="packet_id" value="#attributes.packet_id#">
                        <cfif isDefined("get_package.PROD_RESULT_ID") and len(get_package.PROD_RESULT_ID)>
                        <cfinput type="hidden" name="pr_order_id" value="#get_package.PROD_RESULT_ID#">
                        </cfif>
                        <cfif isDefined("get_package.ORDER_ID") and len(get_package.ORDER_ID)>
                        <cfinput type="hidden" name="order_id" value="#get_package.ORDER_ID#">
                        </cfif>
                        <cf_box_elements>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-process_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                                    <div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='1' select_value = '#get_package.PACKAGE_STAGE#'></div>
                                </div>
                                <div class="form-group" id="item-associated_transaction">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49564.İlişkili"><cf_get_lang dictionary_id="57692.İşlem">*</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="associated_transaction" id="associated_transaction">
                                            <option value="">İlişkili İşlem</option>
                                            <option value="1" <cfif get_package.RELATED_TYPE eq 1> selected </cfif>>Sipariş</option>
                                            <option value="2" <cfif get_package.RELATED_TYPE eq 2> selected </cfif>>Üretim Sonucu</option>
                                        </select>  
                                    </div>
                                </div>
                                <div class="form-group" id="item-associated_paper">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49564.İlişkili"><cf_get_lang dictionary_id="57880.Belge No"></label>

                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="associated_transaction_paper" id="associated_transaction_paper" value="<cfoutput>#associated_transaction_paper#</cfoutput>" readonly>
                                    </div>
                                </div>
                                <div class="form-group" id="item-company">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_package.partner_id)>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_package.company_id#</cfoutput>">
                                                <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_package.partner_id#</cfoutput>">	
                                                <input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_package.partner_id,0,1,0)#</cfoutput>" readonly="readonly">	  
                                            <cfelseif len(get_package.consumer_id)>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_package.consumer_id#</cfoutput>">
                                                <input type="hidden" name="company_id" id="company_id" value="">
                                                <input type="hidden" name="partner_id" id="partner_id" value="">	
                                                <input type="text" name="company" id="company" value="" readonly="readonly">
                                            <cfelse>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                <input type="hidden" name="company_id" id="company_id" value="">
                                                <input type="hidden" name="partner_id" id="partner_id" value="">	
                                                <input type="text" name="company" id="company" value="" readonly="readonly">
                                            </cfif>
                                            <cfset str_linke_ait="&field_comp_id=form_basket.company_id&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_name=form_basket.company&field_name=form_basket.member_name">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-member_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_package.partner_id)>
                                            <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_package.partner_id,0,-1,0)#</cfoutput>" readonly>
                                        <cfelseif len(get_package.consumer_id)>
                                            <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_package.consumer_id,0,0)#</cfoutput>" readonly>
                                        <cfelse>
                                            <input type="text" name="member_name" id="member_name" value="" readonly>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group" id="item-project_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_package.project_id#</cfoutput>">
                                            <input type="text" name="project_head"  id="project_head" value="<cfoutput>#get_package.project_head#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-transport_no1">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='400.Paket No'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="paper_no" id="paper_no" value="<cfoutput>#get_package.PACKAGE_NO#</cfoutput>" readonly>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34799.Paket Tipi'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="package_type_id" id="package_type_id">
                                            <option value=""><cf_get_lang dictionary_id='34799.Paket Tipi'></option>
                                            <cfoutput query="get_package_type">
                                                <option value="#PACKAGE_TYPE_ID#" <cfif get_package.PACKAGE_TYPE_ID eq package_type_id>selected</cfif>>#PACKAGE_TYPE#</option>
                                            </cfoutput>
                                        </select>  
                                    </div>
                                </div>
                                <div class="form-group" id="item-location_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33658.Giriş Depo'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif len(get_package.department_id)>
                                            <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
                                                SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_package.department_id#">
                                            </cfquery>
                                            <cf_wrkdepartmentlocation
                                                returninputvalue="location_id,department_name,department_id,branch_id"
                                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldname="department_name"
                                                fieldid="location_id"
                                                department_fldid="department_id"
                                                branch_fldid="branch_id"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                department_id="#get_package.department_id#"
                                                location_name="#get_department.department_head#"
                                                width="170">
                                        <cfelse>
                                            <cf_wrkdepartmentlocation
                                                returnInputValue="location_id,department_name,department_id,branch_id"
                                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldName="department_name"
                                                fieldid="location_id"
                                                department_fldId="department_id"
                                                branch_fldId="branch_id"
                                                user_level_control="#session.ep.our_company_info.is_location_follow#"
                                                width="170">
                                        </cfif>
                                    </div>
                                </div>
                                <div class="form-group" id="item-max-vol">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58909.Max'><cf_get_lang dictionary_id='30114.Hacim'> - <cf_get_lang dictionary_id='58909.Max'><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                                    <div class="col col-4 col-xs-12">
                                        <input type="text" name="max_vol" id="max_vol" value="<cfoutput>#get_package.MAX_VOLUME#</cfoutput>">
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <input type="text" name="max_weight" id="max_weight" value="<cfoutput>#get_package.MAX_WIDTH#</cfoutput>" >
                                    </div>
                                </div> 
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-deliver_id2">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="deliver_id2" id="deliver_id2" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                            <input type="text" name="deliver_name2" id="deliver_name2" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.deliver_id2&field_name=add_packet_ship.deliver_name2&select_list=1');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-action_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="action_date" id="action_date" value="#dateformat(get_package.action_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Lütfen Teslim Tarihi Formatını Doğru Giriniz',45647)#">
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
                                        </div>
                                    </div>
                                </div>  
                                <div class="form-group" id="item-note">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-4 col-xs-12">
                                        <textarea name="note" id="note"><cfoutput>#get_package.DESCRIPTION#</cfoutput></textarea>											
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                        <div class="col col-12 col-md-12 col-xs-12">
                            <cfset attributes.basket_id = 53>
                            <cfset attributes.basket_sub_id = 47>
                            <cfinclude template="../../objects/display/basket.cfm">
                        </div>
                            <cf_seperator title="#getLang('','Paketleme','63751')# #getLang('','İşlemleri','64265')# "  id="packaging_operations">
                            <cfinput type="hidden" name="rowcount" id="rowcount" value="#get_warehouse_rate_rows.recordcount#">
                            <div id="packaging_operations"> 
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th width="20"><a href="javascript:add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                            <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                                            <th><cf_get_lang dictionary_id='40050.Hizmet Kalemi'></th>
                                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                                            <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                                            <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                            <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="add_table">
                                        <cfoutput query="get_warehouse_rate_rows">
                                        <tr id="my_row_#currentrow#">
                                            <td class="text-center"><input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"><a href="javascript:sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                                            <td>#currentrow#</td>
                                            <td><div class="form-group"><select name="warehouse_task_type_id_#currentrow#" id="warehouse_task_type_id_#currentrow#"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfloop query="get_warehouse_task_types"><option value="#WAREHOUSE_TASK_TYPE_ID#" <cfif get_warehouse_task_types.WAREHOUSE_TASK_TYPE_ID eq get_warehouse_rate_rows.TASK_TYPE>selected</cfif>>#WAREHOUSE_TASK_TYPE#</option></cfloop></select></div></td>
                                            <td><div class="form-group"><input type="text" id="rate_info_#currentrow#" name="rate_info_#currentrow#" value="#tlformat(amount)#" onkeyup="row_total('#currentrow#');return(FormatCurrency(this,event,2));"></div></td>
                                            <td><div class="form-group"><select name="unit_id_#currentrow#" id="unit_id_#currentrow#"><cfloop query="get_units"><option value="#unit_id#" <cfif get_units.unit_id eq get_warehouse_rate_rows.unit[currentrow]>selected</cfif>>#unit#</option></cfloop></select></div></td>
                                            <td><div class="form-group"><input type="text" name="price_#currentrow#" id="price_#currentrow#" class="moneybox" value="#tlformat(price)#" onkeyup="row_total('#currentrow#');return(FormatCurrency(this,event,2));"></div></td>
                                            <td><div class="form-group"><select name="price_money_#currentrow#" id="price_money_#currentrow#"><cfloop query="get_money"><option value="#MONEY#">#MONEY#</option></cfloop></select></div></td>
                                            <td><div class="form-group"><input type="text" id="is_bill_#currentrow#" name="is_bill_#currentrow#" readonly class="moneybox"></div></td>
                                        </tr>
                                        </cfoutput>
                                    </tbody>
                                </cf_grid_list>
                            </div>
                        <div class="col col-12">
                            <hr>
                            <div class="ui-form-list flex-list col col-8">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57633.Barkod'></label>
                                        <div class="input-group">
                                        <cfinput type="text" name="barcod" id="barcod" onKeyUp="barcod_control()" value="#get_package.BARCOD#">
                                        <span class="input-group-addon btnPointer" onclick="javascript:document.form_basket.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-qrcode"></i></span>
                                    </div>
                                </div>
                                <div class="form-group" >
                                    <label><cf_get_lang dictionary_id='64266.Üretilen Paket Sayısı'></label>
                                    <cfinput type="number" name="package_num" id="package_num" value="1">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='45880.Etiket'></label>
                                    <select name="etiket" id="etiket"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option></select>
                                </div>
                            </div>
                                <cf_basket_form_button>
                                    <cf_workcube_buttons 
                                                        is_upd='1' 
                                                        add_function='kontrol()'
                                                        data_action = '/V16/stock/cfc/packeting:upd_packeting'
                                                        next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&packet_id=#attributes.packet_id#'
                                                        del_action= '/V16/stock/cfc/packeting:del_packeting:packet_id=#attributes.packet_id#'
							                            del_next_page = '#request.self#?fuseaction=#attributes.fuseaction#'>
                                </cf_basket_form_button>
                            </div>
                        </div>
                    </cf_basket_form>
                </cfform>
            </div>
        </cf_box>
    </div>
    <script>
        $( document ).ready(function() {
            rowCount = "<cfoutput>#get_warehouse_rate_rows.recordcount#</cfoutput>";
            if(rowCount > 0){
                for(i=1; i <= rowCount; i++){
                    row_total(i);
                }
            }
        });
        function sil(sy){
            var my_element=eval("form_basket.row_kontrol_"+sy);
            my_element.value=0;
            var my_element=eval("my_row_"+sy);
            my_element.remove();
        }
        
        
        function add_row(){
            rowCount++;
            var newRow;
            var newCell;
            newRow = add_table.insertRow();
            newRow.setAttribute("name","my_row_" + rowCount);
            newRow.setAttribute("id","my_row_" + rowCount);		
            newRow.setAttribute("NAME","my_row_" + rowCount);
            newRow.setAttribute("ID","my_row_" + rowCount);	
            
            document.getElementById('rowcount').value = rowCount;
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<cfoutput><select style="display:none;" name="rate_unit_id_' + rowCount +'" id="rate_unit_id_' + rowCount +'"><cfloop query="get_units"><option value="#unit_id#">#unit#</option></cfloop></select></cfoutput><input name="rate2_' + rowCount +'" type="hidden" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,2));"><input name="rate1_' + rowCount +'" type="hidden" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,2));"><input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><a style="cursor:pointer;" onClick="sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = rowCount;
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><cfoutput><select name="warehouse_task_type_id_' + rowCount +'" id="warehouse_task_type_id_' + rowCount +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfloop query="get_warehouse_task_types"><option value="#WAREHOUSE_TASK_TYPE_ID#">#WAREHOUSE_TASK_TYPE#</option></cfloop></select></cfoutput></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" id="rate_info_' + rowCount +'"  name="rate_info_' + rowCount +'" onkeyup="row_total('+rowCount+');return(FormatCurrency(this,event,2));" class="moneybox"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><cfoutput><select name="unit_id_' + rowCount +'" id="unit_id_' + rowCount +'"><cfloop query="get_units"><option value="#unit_id#">#unit#</option></cfloop></select></cfoutput></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input name="price_' + rowCount +'" id="price_' + rowCount +'" type="text" class="moneybox" value="" onkeyup="row_total('+rowCount+');return(FormatCurrency(this,event,2));"></div>';
            
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><cfoutput><select name="price_money_' + rowCount +'" id="price_money_' + rowCount +'"><cfloop query="get_money"><option value="#MONEY#">#MONEY#</option></cfloop></cfoutput></div>';
    
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" id="is_bill_' + rowCount +'" name="is_bill_' + rowCount +'" readonly></div>';
        }
    
        function row_total(rowCount) {
            var amount = filterNum(document.getElementById('rate_info_' + rowCount).value);
            var price = filterNum(document.getElementById('price_' + rowCount).value);
            document.getElementById('is_bill_' + rowCount).value = commaSplit( amount * price);
        }
    
        function barcod_control(){
            var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
            barcode = document.getElementById('barcod');
            toplam_ = barcode.value.length;
            deger_ = barcode.value;
            if(toplam_>0)
            {
                for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
                {
                    tus_ = deger_.charAt(this_tus_);
                    cont_ = list_find(prohibited_asci,tus_.charCodeAt());
                    if(cont_>0)
                    {
                        alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!");
                        barcode.value = '';
                        break;
                    }
                }
            }
        }
    
        function kontrol(){
            if( $("#paper_no").val() == "" || $("#package_type_id").val() == '' || $("#department_id").val() == '' || $("#associated_transaction").val() == '' )
            {   
                alert("<cf_get_lang dictionary_id='29722.Zorunlu Alanları Doldurunuz!'>");
                return false;
            } 
            return (saveForm());
        }
    </script>