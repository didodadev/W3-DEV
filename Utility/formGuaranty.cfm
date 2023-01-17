<cf_get_lang_set module_name="objects">
<div class="row" type="row">
    <div class="col col-3 col-md-4 col-sm-12" type="column" index="1" sort="true">
    	<cfif attributes.event is 'add'>
            <div class="form-group" id="item-method">
                <label class="col col-3 col-sm-3"><cf_get_lang_main no='1675.Yöntem'></label>
                <div class="col col-8 col-sm-9">
                    <label><input type="radio" name="method" id="method" value="0" <cfif attributes.method eq 0>checked</cfif> onClick="kontrol(this.value)"><cf_get_lang no='359.Ardışık'></label>
                    <label><input type="radio" name="method" id="method" value="1" <cfif attributes.method eq 1>checked</cfif> onClick="kontrol(this.value)"><cf_get_lang no='377.Tek Tek'></label>
                </div>
            </div>
        <cfelse>
            <input type="hidden" name="guaranty_id" id="guaranty_id" value="<cfoutput>#attributes.guaranty_id#</cfoutput>">
            <input type="hidden" name="old_seri_no" id="old_seri_no" value="<cfoutput>#attributes.old_seri_no#</cfoutput>">
            <div class="form-group" id="item-serial_no">
                <label class="col col-3 col-sm-3"><cf_get_lang_main no ='225.Seri No'>*</label>
                <div class="col col-8 col-sm-9">
                    <input name="serial_no" id="serial_no" type="text" maxlength="30" data-msg="<cf_get_lang no ='1384.Seri No Girmelisiniz'>" value="<cfoutput>#GET_GUARANTY_DETAIL.SERIAL_NO#</cfoutput>" required="yes" message="#message#">
                </div>                
             </div>
        </cfif>
        <div class="form-group" id="item-is_purchase_sales">
            <label class="col col-3 col-sm-3 "><cf_get_lang_main no='344.Durum'></label>
            <div class="col col-8 col-sm-9">
                <label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="0" <cfif attributes.is_purchase_sales eq 1>checked</cfif>><cf_get_lang_main no='764.Alış'></label>
                <label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="1" <cfif attributes.is_sale eq 1>checked</cfif>><cf_get_lang_main no='36.Satış'></label>
            </div>                
        </div>
        <div class="form-group" id="item-in_out">
            <label class="col col-3 col-sm-3"></label>
            <div class="col col-8 col-sm-9">
                <label><input type="checkbox" name="in_out" id="in_out" value="1" <cfif attributes.in_out eq 1>checked</cfif>><cf_get_lang no='847.Satılabilir'></label>
                <label><input type="checkbox" name="is_return" id="is_return" value="1" <cfif attributes.is_return eq 1>checked</cfif>><cf_get_lang_main no='1621.İade'></label>
            </div>                
        </div>
        <div class="form-group" id="item-is_rma">
            <label class="col col-3 col-sm-3 "></label>
            <div class="col col-8 col-sm-9">
                <label><input type="checkbox" name="is_rma" id="is_rma" value="1" <cfif attributes.is_rma eq 1>checked</cfif>><cf_get_lang no='849.Üreticide'></label>
                <label><input type="checkbox" name="is_service" id="is_service" value="1" <cfif attributes.is_service eq 1>checked</cfif>><cf_get_lang no='850.Serviste'></label>
                <label><input type="checkbox" name="is_trash" id="is_trash" value="1" <cfif attributes.is_trash eq 1>checked</cfif>><cf_get_lang_main no='1674.Fire'></label>
            </div>                
        </div>
        <div class="form-group" id="item-product_name">
            <label class="col col-3 col-sm-3"><cf_get_lang_main no='245.Ürün'>*</label>
            <div class="col col-8 col-sm-9">
                <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                <div class="input-group">						
                    <input type="text" name="product_name" id="product_name" data-msg="<cf_get_lang_main no='245.Ürün'>" required="yes" value="<cfoutput>#attributes.product_name#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','200');">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id&field_name=form_basket.product_name&keyword='+encodeURIComponent(document.form_basket.product_name.value),'list');"></span>
                </div>
            </div>              
        </div>
        <cfif attributes.event is 'add'>
            <div class="form-group" id="item-amount">
                <label class="col col-3 col-sm-3"><cf_get_lang_main no='223.Miktar'>*</label>
                <div class="col col-8 col-sm-9">
                    <input type="text" name="amount" value="<cfoutput>#attributes.amount#</cfoutput>" class="moneybox" data-msg="<cf_get_lang_main no='223'>" onKeyUp="isNumber(this)" required="yes">   
                </div>                
            </div>
        </cfif>
        <div class="form-group" id="item-department_id">
            <label class="col col-3 col-sm-3"><cf_get_lang_main no='160.Departman'>-<cf_get_lang_main no='2234.Lokasyon'>*</label>
            <div class="col col-8 col-sm-9">
				<cf_wrkdepartmentlocation
                returnInputValue="location_id,department_name,department_id"
                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                fieldName="department_name"
                fieldId="location_id"
                department_fldId="department_id"
                department_id="#attributes.department_id#"
                location_id="#attributes.location_id#"
                location_name="#get_location_info(attributes.department_id,attributes.location_id)#"
                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                data_msg="Departman"
                width="150">
            </div>                
        </div>
        <div class="form-group" id="item-start_date">
            <label class="col col-3 col-sm-3"><cf_get_lang no='853.Alış Garanti Başlama'></label>
            <div class="col col-8 col-sm-9">
                <div class="input-group">
                    <input type="text" name="start_date" id="start_date" value="<cfoutput>#attributes.start_date#</cfoutput>">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                </div>	                           
            </div>   
        </div>
        <div class="form-group" id="item-guarantycat_id">
            <label class="col col-3 col-sm-3"><cf_get_lang no='854.Alış Garanti Kategorisi'>*</label>
            <div class="col col-8 col-sm-9">
                <select name="guarantycat_id" id="guarantycat_id" required="yes" data-msg="<cf_get_lang no='854.Alış Garanti Kategorisi'>">
                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                    <cfoutput query="get_guaranty_cat">
                        <option value="#guarantycat_id#" <cfif len(attributes.guarantycat_id) and attributes.guarantycat_id eq guarantycat_id>selected</cfif>>#guarantycat#</option>
                    </cfoutput>
                </select>
            </div>                
        </div>
		<cfif attributes.event is 'upd'>
            <div class="form-group" id="item-finish_date">
                <label class="col col-3 col-sm-3"><cf_get_lang no ='1466.Alış Garanti Bitiş'></label>
                <div class="col col-8 col-sm-9">
                    <div class="input-group">
                        <input type="text" name="finish_date" id="finish_date" value="<cfoutput>#attributes.finish_date#</cfoutput>">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>	                           
                </div>   
            </div>
		</cfif>
        <div class="form-group" id="item-sale_start_date">
            <label class="col col-3 col-sm-3"><cf_get_lang no='855.Satış Garanti Başlama'></label>
            <div class="col col-8 col-sm-9">
                <div class="input-group">
                    <input type="text" name="sale_start_date" id="sale_start_date" value="<cfoutput>#attributes.sale_start_date#</cfoutput>">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="sale_start_date"></span>
                </div>	                           
            </div>
        </div>
        <div class="form-group" id="item-sale_guarantycat_id">
            <label class="col col-3 col-sm-3"><cf_get_lang no='856.Satış Garanti Kategorisi'>*</label>
            <div class="col col-8 col-sm-9">
                <select name="sale_guarantycat_id" id="sale_guarantycat_id" required="yes" data-msg="<cf_get_lang no='856.Satış Garanti Kategorisi'>">
                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                    <cfoutput query="get_guaranty_cat">
                        <option value="#guarantycat_id#" <cfif len(attributes.sale_guarantycat_id) and attributes.sale_guarantycat_id eq guarantycat_id>selected</cfif>>#guarantycat#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
		<cfif attributes.event is 'upd'>
            <div class="form-group" id="item-sale_finish_date">
                <label class="col col-3 col-sm-3"><cf_get_lang no ='1467.Satış Garanti Bitiş'></label>
                <div class="col col-8 col-sm-9">
                    <div class="input-group">
                        <input type="text" name="sale_finish_date" id="sale_finish_date" value="<cfoutput>#attributes.sale_finish_date#</cfoutput>">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="sale_finish_date"></span>
                    </div>	                           
                </div>   
            </div>
        </cfif>
        <div class="form-group" id="item-update_time">
            <label class="col col-3 col-sm-3"><cf_get_lang no='857.Süre Uzatma'></label>
            <div class="col col-8 col-sm-9">
                <input type="text" name="update_time" id="update_time" value="<cfoutput>#attributes.update_time#</cfoutput>">
            </div>                
        </div>
        <div class="form-group" id="item-lot_no">
            <label class="col col-3 col-sm-3">Lot No</label>
            <div class="col col-8 col-sm-9">
                <input type="text" name="lot_no" id="lot_no" value="<cfoutput>#attributes.lot_no#</cfoutput>">                
            </div>                
        </div>
        <cfif attributes.event is 'add'>
            <div class="form-group" id="item-ship_start_no">
                <label class="col col-3 col-sm-3"><cf_get_lang no='314.Ürün Seri Baş No'>*</label>
                <div class="col col-4 col-sm-4">
                    <input type="text" name="ship_start_no" data-msg="<cf_get_lang no ='1465.Seri No Başlangıç Girmelisiniz'>" id="ship_start_no" value="<cfoutput>#attributes.ship_start_no#</cfoutput>">
                </div> 
                <div class="col col-4 col-sm-4">
                    <input type="text" name="ship_start_text" id="ship_start_text" value="<cfoutput>#attributes.ship_start_text#</cfoutput>">
                </div>                
            </div>
            <div class="form-group" id="item-ship_start_nos">
                <label class="col col-3 col-sm-3"><cf_get_lang no='336.Ürün Seri Nolar'></label>
                <div class="col col-8 col-sm-9">
                    <textarea name="ship_start_nos" id="ship_start_nos" data-msg="<cf_get_lang no ='1384.Seri No Girmelisiniz'>"><cfif len(attributes.ship_start_nos)>#attributes.ship_start_nos#</cfif></textarea>               
                </div>                
            </div>
        </cfif>
    </div>
</div>