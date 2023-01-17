<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:10,process_type:1);</cfscript>
<cfquery name="GET_UPD_PURCHASE" datasource="#dsn2#">
	SELECT 
    	DISPATCH_SHIP_ID, 
        SHIP_METHOD, 
        PROCESS_STAGE, 
        SHIP_DATE, 
        DELIVER_DATE, 
        LOCATION_OUT, 
        DEPARTMENT_OUT, 
        DELIVER_EMP, 
        DEPARTMENT_IN, 
        LOCATION_IN, 
        MONEY, 
        RATE1, 
        RATE2, 
        DISCOUNTTOTAL, 
        GROSSTOTAL, 
        NETTOTAL, 
        TAXTOTAL, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_DATE ,
        PAPER_NO
    FROM 
    	SHIP_INTERNAL 
    WHERE 
    	DISPATCH_SHIP_ID = #url.ship_id#
</cfquery>
<cfquery name="GET_SHIP" datasource="#DSN2#">
    SELECT SHIP_ID,SHIP_NUMBER FROM SHIP WHERE DISPATCH_SHIP_ID = #attributes.ship_id#
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_internaldemand">
                <cf_basket_form id="dispatch_internaldemand">
                    <cfoutput>
                        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_internaldemand">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                        <input type="hidden" name="upd_id" id="upd_id" value="#url.ship_id#">
                        <input name="company_id" id="company_id" value="-1" type="hidden">
                    </cfoutput>
                    <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-form_ul_process_stage">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                                <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_upd_purchase.process_stage#' process_cat_width='150' is_detail='1'>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_ship_internal_number">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" name="ship_internal_number" id="ship_internal_number" value="#get_upd_purchase.paper_no#" required="Yes" mmaxlength="50" onBlur="paper_control(this,'SHIP_INTERNAL',false,#url.ship_id#,'#get_upd_purchase.paper_no#','','');"> 
								</div>
							</div>
                            <div class="form-group" id="item-location_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <!--- <input type="hidden" name="location_id" value="<cfoutput>#get_upd_purchase.location_out#</cfoutput>">	
                                    <input type="hidden" name="department_id" value="<cfoutput>#get_upd_purchase.department_out#</cfoutput>"> --->
                                    <cfif len(get_upd_purchase.department_out) and len(get_upd_purchase.location_out)>
                                        <cfset location_info_ = get_location_info(get_upd_purchase.department_out,get_upd_purchase.location_out)>
                                    <cfelse>
                                        <cfset location_info_ = "">
                                    </cfif>
                                    <!--- <cfsavecontent variable="message"><cf_get_lang no='226.Çıkış depo girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="txt_departman_" value="#location_info_#" required="yes" message="#message#" readonly style="width:150px;">
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&field_location_id=location_id','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
                                    <cf_wrkdepartmentlocation
                                        returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                        returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldName="txt_departman_"
                                        fieldid="location_id"
                                        department_fldId="department_id"
                                        department_id="#get_upd_purchase.department_out#"
                                        location_id="#get_upd_purchase.location_out#"
                                        location_name="#location_info_#"
                                        user_level_control="0"
                                        is_store_kontrol = "0"
                                        line_info="1"
                                        width="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-location_in_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(get_upd_purchase.department_in) and len(get_upd_purchase.location_in)>
                                        <cfset location_info_ = get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in)>
                                    <cfelse>
                                        <cfset location_info_ = "">
                                    </cfif>
                                    <cf_wrkdepartmentlocation
                                        returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldName="department_in_txt"
                                        fieldid="location_in_id"
                                        department_fldId="department_in_id"
                                        department_id="#get_upd_purchase.department_in#"
                                        location_id="#get_upd_purchase.location_in#"
                                        location_name="#location_info_#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        line_info="2"
                                        width="150">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-deliver_date_frm">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='41841.Fiili Sevk Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="deliver_date_frm" validate="#validate_style#" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" message="#message#" style="width:150px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                                </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz!'></cfsavecontent>
                                        <cfinput type="text" name="ship_date" required="Yes" message="#message#" validate="#validate_style#"  value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" style="width:150px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date"></span>
                                </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_upd_purchase.ship_method#</cfoutput>">
                                        <cfif len(get_upd_purchase.ship_method)>
                                            <cfset attributes.ship_method_id = get_upd_purchase.ship_method>
                                            <cfinclude template="../query/get_ship_method.cfm">
                                        </cfif>
                                        <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)><cfoutput>#get_ship_method.ship_method#</cfoutput></cfif>" readonly style="width:150px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla Karakter Sayısı'></cfsavecontent>
                                    <textarea style="width:175px; height:75px" name="detail" id="detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_upd_purchase.detail#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6">
                            <cf_record_info query_name='get_upd_purchase'>
                        </div>
                        <div class="col col-6">
                            <cfif not get_ship.recordcount>
                                <cf_workcube_buttons is_upd='1' add_function="depo_control()" delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_internaldemand&event=del&shipDel=1&upd_id=#url.ship_id#&head=#location_info_#'>
                            <cfelse>
                                <font color="red"><cf_get_lang dictionary_id='34407.İşlendi'>!</font>&nbsp; <cf_get_lang dictionary_id='58138.İrsaliye No'> : <cfoutput>#GET_SHIP.SHIP_NUMBER#</cfoutput>
                            </cfif>	
                        </div>
                    </cf_box_footer>                   
                </cf_basket_form>		
                <cfif session.ep.isBranchAuthorization>
                    <cfset attributes.basket_id = 45>
                <cfelse>
                    <cfset attributes.basket_id = 44>
                </cfif>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<script type="text/javascript">
function depo_control()
{

		if(!paper_control(form_basket.ship_internal_number,'SHIP_INTERNAL',false,'',<cfoutput>'#get_upd_purchase.paper_no#'</cfoutput>,'','')) return false;

   	 	if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang dictionary_id='45602.Çıkış Deposunu Seçmelisiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value=="")
		{
		    alert("<cf_get_lang dictionary_id='45601.Giriş Deposunu Seçmelisiniz'>!");
			return false;
		}
		
		if(form_basket.department_in_id.value == form_basket.department_id.value  && form_basket.location_in_id.value == form_basket.location_id.value)
		{
			alert("<cf_get_lang dictionary_id='45351.Giriş ve Çıkış Depoları Aynı Olamaz'>");
			return false;
		}
		else
			return (process_cat_control() && saveForm());
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1447.Süreç'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1631.Çıkış Depo'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang no='96.Giriş Depo'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang no='127.Fiili Sevk Tarihi'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='330.Tarih'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yöntemi'></cfsavecontent>--->
<!---<cfsavecontent variable="header_"><cf_get_lang_main no ='217.Açıklama'></cfsavecontent>--->