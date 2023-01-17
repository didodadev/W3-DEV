<cfparam name="associated_transaction_paper" default="">
<cfset packeting = createObject("component", "V16.stock.cfc.packeting")>
<cfset get_package_type = packeting.GET_PACKAGE_TYPE()>
<cfset get_money = packeting.GET_MONEY()>
<cfset get_units = packeting.get_units_funcs()>
<cfset get_warehouse_task_types = packeting.get_warehouse_task_types_funcs()>
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfquery name="get_order_detail" datasource="#DSN3#">
        SELECT 
            ORDERS.ORDER_NUMBER,
            ORDERS.ORDER_DATE,
            ORDERS.COMPANY_ID,
            ORDERS.PARTNER_ID,
            ORDERS.CONSUMER_ID,
            ORDERS.PROJECT_ID,
            ORDERS.OTHER_MONEY,
            P.PROJECT_HEAD
        FROM
            ORDERS LEFT JOIN #dsn#.PRO_PROJECTS P ON P.PROJECT_ID = ORDERS.PROJECT_ID
        WHERE
            ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
    </cfquery>
    <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);</cfscript>
<cfelseif isDefined("attributes.pr_order_id") and len(attributes.pr_order_id)>
    <cfquery name="get_order_detail" datasource="#DSN3#">
        SELECT 
            POR.RESULT_NO as ORDER_NUMBER
        FROM
            PRODUCTION_ORDER_RESULTS POR
        WHERE
            POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
    </cfquery>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfelse>
    <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
</cfif>
<cf_catalystHeader>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket">
                <cf_basket_form id="add_packet">
                    <cfif isDefined("attributes.order_id") and len(attributes.order_id)>
                        <cfinput type="hidden" name="order_id" value="#attributes.order_id#">
                    <cfelseif isDefined("attributes.pr_order_id") and len(attributes.pr_order_id)>
                        <cfinput type="hidden" name="pr_order_id" value="#attributes.pr_order_id#">
                    </cfif>
                    <cf_papers paper_type="package" form_name="form_basket" form_field="paper_no">
                    <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                                <div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
                            </div>
                            <div class="form-group" id="item-associated_transaction">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49564.İlişkili"><cf_get_lang dictionary_id="57692.İşlem">*</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="associated_transaction" id="associated_transaction">
                                        <option value="">İlişkili İşlem</option>
                                        <option value="1" <cfif isDefined("attributes.order_id") and len(attributes.order_id)> selected </cfif>>Sipariş</option>
                                        <option value="2" <cfif isDefined("attributes.pr_order_id") and len(attributes.pr_order_id)> selected </cfif>>Üretim Sonucu</option>
                                    </select>  
                                </div>
                            </div>
                            <div class="form-group" id="item-associated_paper">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49564.İlişkili"><cf_get_lang dictionary_id="57880.Belge No"></label>
                                <cfif isDefined("attributes.order_id") or isDefined("attributes.pr_order_id")>
                                    <cfset associated_transaction_paper = get_order_detail.ORDER_NUMBER>
                                </cfif>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="associated_transaction_paper" id="associated_transaction_paper" value="<cfoutput>#associated_transaction_paper#</cfoutput>" readonly>
                                </div>
                            </div>
                            <div class="form-group" id="item-company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_order_detail.consumer_id#</cfoutput>">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order_detail.company_id#</cfoutput>">
                                            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_order_detail.partner_id#</cfoutput>">
                                            <input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_order_detail.company_id,1,0,0)#</cfoutput>" readonly>
                                        <cfelse>
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                            <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                                            <input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" readonly>
                                        </cfif>
                                        <cfset str_linke_ait="&field_comp_id=form_basket.company_id&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_name=form_basket.company&field_name=form_basket.member_name">
                                        <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
                                        <cfelse>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-member_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                                        <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_order_detail.partner_id,0,-1,0)#</cfoutput>" readonly>
                                    <cfelse>
                                        <input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_name")><cfoutput>#attributes.member_name#</cfoutput></cfif>" readonly>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-project_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_order_detail.project_id#</cfoutput>">
                                            <input type="text" name="project_head"  id="project_head" value="<cfoutput>#get_order_detail.project_head#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                        <cfelse>
                                            <input type="hidden" name="project_id" id="project_id" value="">
                                            <input type="text" name="project_head"  id="project_head" value="" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                        </cfif>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_no1">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='400.Paket No'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="paper_no" id="paper_no" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>" readonly>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34799.Paket Tipi'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="package_type_id" id="package_type_id">
                                        <option value=""><cf_get_lang dictionary_id='34799.Paket Tipi'></option>
                                        <cfoutput query="get_package_type">
                                            <option value="#PACKAGE_TYPE_ID#">#PACKAGE_TYPE#</option>
                                        </cfoutput>
                                    </select>  
                                </div>
                            </div>
                            <div class="form-group" id="item-location_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33658.Giriş Depo'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("attributes.location_id")>
                                        <cf_wrkdepartmentlocation
                                            returnInputValue="location_id,department_name,department_id,branch_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldName="department_name"
                                            fieldid="location_id"
                                            department_fldId="department_id"
                                            branch_fldId="branch_id"
                                            branch_id="#attributes.branch_id#"
                                            department_id="#attributes.department_id#"
                                            location_id="#attributes.location_id#"
                                            user_level_control="#session.ep.our_company_info.is_location_follow#"
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
                                    <input type="text" name="max_vol" id="max_vol" value="">
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <input type="text" name="max_weight" id="max_weight" value="" >
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
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=form_basket.deliver_id2&field_name=form_basket.deliver_name2&select_list=1');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="action_date" id="action_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" message="#getLang('','Lütfen Teslim Tarihi Formatını Doğru Giriniz',45647)#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
                                    </div>
                                </div>
                            </div>  
                            <div class="form-group" id="item-note">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-4 col-xs-12">
                                    <textarea name="note" id="note"></textarea>											
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <div class="col col-12 col-md-12 col-xs-12">
                        <cfset attributes.basket_id = 53>
                        <cfif isDefined("attributes.order_id") or isDefined("attributes.pr_order_id")>
                            <cfset attributes.basket_sub_id = 47>
                        <cfelse>
                            <cfset attributes.form_add = 1>
                        </cfif>
                        <cfinclude template="../../objects/display/basket.cfm">
                    </div>
                    <cf_seperator title="#getLang('','Paketleme','63751')# #getLang('','İşlemleri','64265')# "  id="packaging_operations">
                    <cfinput type="hidden" name="rowcount" id="rowcount">
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
                            </tbody>
                        </cf_grid_list>
                    </div>
                    <div class="col col-12">
                        <hr>
                        <div class="ui-form-list flex-list col col-8">
                            <div class="form-group">
                                <label><cf_get_lang dictionary_id='57633.Barkod'></label>
                                    <div class="input-group">
                                    <cfinput type="text" name="barcod" id="barcod" onKeyUp="barcod_control()">
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
                            <div class="form-group"> 
                                <cf_basket_form_button>
                                <cf_workcube_buttons 
                                                    is_upd='0' 
                                                    add_function='kontrol()'
                                                    data_action = '/V16/stock/cfc/packeting:add_packeting'
                                                    next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&packet_id='>
                                </cf_basket_form_button>
                            </div>
                        </div>
                    </div>
                </cf_basket_form>
            </cfform>
        </div>
    </cf_box>
</div>
<script>
    function sil(sy){
        var my_element=eval("form_basket.row_kontrol_"+sy);
        my_element.value=0;
        var my_element=eval("my_row_"+sy);
        my_element.style.display="none";
    }
    
    rowCount = 0;
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
        return ( saveForm());
    }
</script>