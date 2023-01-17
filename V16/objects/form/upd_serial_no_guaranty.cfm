<cfinclude template="../query/get_guaranty_cat.cfm">
<cfinclude template="../query/get_guaranty_detail.cfm">
<cfsavecontent variable="txt">
	<cf_get_lang dictionary_id='47111.Garanti ve Ürün Takibi'>
</cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#txt#">
        <cfform name="form_basket" action="#request.self#?fuseaction=objects.upd_serialno_guaranty" method="post">
            <input type="hidden" name="guaranty_id" id="guaranty_id" value="<cfoutput>#GET_GUARANTY_DETAIL.GUARANTY_ID#</cfoutput>">
            <input type="hidden" name="id" id="id" value="<cfoutput>#GET_GUARANTY_DETAIL.GUARANTY_ID#</cfoutput>">
            <input type="hidden" name="old_seri_no" id="old_seri_no" value="<cfoutput>#GET_GUARANTY_DETAIL.SERIAL_NO#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_purchase_sales">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='57756.Durum'></label></div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6">
								<label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="0" <cfif GET_GUARANTY_DETAIL.is_purchase is 1>checked</cfif>><cf_get_lang dictionary_id='58176.Alış'></label>
                                <label><input type="checkbox" name="is_rma" id="is_rma" value="1" <cfif GET_GUARANTY_DETAIL.is_rma eq 1>checked</cfif>><cf_get_lang dictionary_id ='33239.Üreticide'></label>
                                <label><input type="checkbox" name="in_out" id="in_out" value="1" <cfif GET_GUARANTY_DETAIL.IN_OUT is 1>checked</cfif>><cf_get_lang dictionary_id ='33237.Satılabilir'></label>
                                <label><input type="checkbox" name="is_return" id="is_return" value="1" <cfif GET_GUARANTY_DETAIL.is_return eq 1>checked</cfif>><cf_get_lang dictionary_id='29418.İade'></label>
							</div>
							<div class="col col-6">
								<label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="1" <cfif GET_GUARANTY_DETAIL.is_sale is 1>checked</cfif>><cf_get_lang dictionary_id ='57448.Satış'></label>
                                <label><input type="checkbox" name="is_service" id="is_service" value="1" <cfif GET_GUARANTY_DETAIL.is_service eq 1>checked</cfif>><cf_get_lang dictionary_id ='33240.Serviste'></label>
                                    <label><input type="checkbox" name="is_trash" id="is_trash" value="1" <cfif GET_GUARANTY_DETAIL.is_trash eq 1>checked</cfif>><cf_get_lang dictionary_id='29471.Fire'></label>
							</div>
						</div>
					</div>
                    <div class="form-group" id="item-serial_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'> *</label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33774.Seri No Girmelisiniz'> !</cfsavecontent>
                            <cfinput name="serial_no" type="text" maxlength="30" value="#GET_GUARANTY_DETAIL.SERIAL_NO#" required="yes" message="#message#">
                        </div> 
                    </div>
                    <div class="form-group" id="item-stock_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>*</label>
                            <cfquery name="GET_PRO_NAME" datasource="#DSN3#">
                            SELECT 
                                P.PRODUCT_NAME,
                                S.PROPERTY
                            FROM 
                                PRODUCT P, 
                                STOCKS S
                            WHERE 
                                S.STOCK_ID = #GET_GUARANTY_DETAIL.STOCK_ID# AND 
                                S.PRODUCT_ID = P.PRODUCT_ID
                        </cfquery>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="stock_id" id="stock_id" value="<cfif len(GET_GUARANTY_DETAIL.STOCK_ID)><cfoutput>#GET_GUARANTY_DETAIL.STOCK_ID#</cfoutput></cfif>">
                                <cfinput type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','200');"  required="yes" value="#GET_PRO_NAME.PRODUCT_NAME#-#GET_PRO_NAME.PROPERTY#">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57657.Ürün'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id&field_name=form_basket.product_name&keyword='+encodeURIComponent(document.form_basket.product_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-get_guaranty_detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58524.Departman - Lokasyon'>*</label>
                        <div class="col col-9 col-xs-12">
                                <cf_wrkdepartmentlocation
                                    returnInputValue="location_id,department_name,department_id"
                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldName="department_name"
                                    fieldId="location_id"
                                    department_fldId="department_id"
                                    department_id="#get_guaranty_detail.department_id#"
                                    location_id="#get_guaranty_detail.location_id#"
                                    location_name="#get_location_info(get_guaranty_detail.department_id,get_guaranty_detail.location_id)#"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    width="150">
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33243.Alış Garanti Başlama'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" value="#dateformat(now(),dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-guarantycat_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33244.Alış Garanti Kategorisi'>*</label>
                        <div class="col col-9 col-xs-12">
                            <select name="guarantycat_id" id="guarantycat_id">
                            <option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="GET_GUARANTY_CAT">
                                <option value="#GUARANTYCAT_ID#" <cfif GET_GUARANTY_CAT.GUARANTYCAT_ID eq GET_GUARANTY_DETAIL.PURCHASE_GUARANTY_CATID>selected</cfif>>#GUARANTYCAT#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33856.Alış Garanti Bitiş'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="finish_date" value="#dateformat(GET_GUARANTY_DETAIL.PURCHASE_FINISH_DATE,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sale_start_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33245.Satış Garanti Başlama'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="sale_start_date" value="#dateformat(GET_GUARANTY_DETAIL.SALE_START_DATE,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="sale_start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sale-guarantycat_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33246.Satış Garanti Kategorisi'>*</label>
                        <div class="col col-9 col-xs-12">
                            <select name="sale_guarantycat_id" id="sale_guarantycat_id">
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="GET_GUARANTY_CAT">
                                        <option value="#GUARANTYCAT_ID#" <cfif GET_GUARANTY_CAT.GUARANTYCAT_ID eq GET_GUARANTY_DETAIL.SALE_GUARANTY_CATID>selected</cfif>>#GUARANTYCAT#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-sale_finish_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33857.Satış Garanti Bitiş'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="sale_finish_date" value="#dateformat(GET_GUARANTY_DETAIL.SALE_FINISH_DATE,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="sale_finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-update_time">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='33247.Süre Uzatma'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="update_time" id="update_time" value="<cfif len(get_guaranty_detail.UPDATE_TIME)><cfoutput>#GET_GUARANTY_DETAIL.UPDATE_TIME#</cfoutput></cfif>">
                        </div>
                    </div>
                    <div class="form-group" id="item-lot_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='32916.Lot No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="lot_no" id="" value="<cfif len(get_guaranty_detail.UPDATE_TIME)><cfoutput>#GET_GUARANTY_DETAIL.LOT_NO#</cfoutput></cfif>">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_guaranty_detail">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='chk_form()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function chk_form()
	{
		if(document.getElementById('product_name').value== "")
		{
			alert("<cf_get_lang dictionary_id='45986.Ürün Girmelisiniz'>!");
			return false;
		}
		
		if(document.getElementById('department_name').value== "")

		{
			alert("<cf_get_lang dictionary_id='57572.Departman'>-<cf_get_lang dictionary_id='45248.Lokasyon Girmelisiniz'> !");
			return false;
		}
		
		if(document.getElementById('guarantycat_id').value== "")
		{
			alert("<cf_get_lang dictionary_id='60223.Alış Garanti Kategorisi Girmelisiniz'>!");
			return false;
		}	
		
		if(document.getElementById('sale_guarantycat_id').value== "")
		{
			alert("<cf_get_lang dictionary_id='60224.Satış Garanti Kategorisi Girmelisiniz'>!");
			return false;
		}	
	        return true;
}
</script>
