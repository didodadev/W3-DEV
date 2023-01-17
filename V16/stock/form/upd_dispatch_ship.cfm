<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="stock.upd_ship_dispatch">
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.basket_id = 32> 
<cfelse>
	<cfset attributes.basket_id = 31>
</cfif>
<cfscript>
xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cfif isnumeric(attributes.ship_id)>
	<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
	<cfset attributes.upd_id = attributes.ship_id>
	<cfset attributes.cat = "">
	<cfset attributes.head = "">
	<cfinclude template="../query/get_upd_purchase.cfm">
<cfelse>
	<cfset get_upd_purchase.recordcount = 0>
</cfif>
<cfif not get_upd_purchase.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="CONTROL_SHIP_RESULT" datasource="#DSN2#">
    SELECT
        SR.SHIP_ID,
        S.SHIP_RESULT_ID
    FROM
        SHIP_RESULT_ROW SR,
        SHIP_RESULT S
    WHERE
        S.SHIP_RESULT_ID = SR.SHIP_RESULT_ID AND
        SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
        S.IS_TYPE IS NULL
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_sale">
                <cf_basket_form id="d_ship">
                    <cfoutput>
                        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_sale">
                        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                        <input type="hidden" name="type_id" id="type_id" value="#get_upd_purchase.ship_type#">
                        <input type="hidden" name="upd_id" id="upd_id" value="#attributes.ship_id#">
                        <input type="hidden" name="cat" id="cat" value="#get_upd_purchase.ship_type#">
                        <input type="hidden" name="head" id="head" value="#get_upd_purchase.ship_number#">
                        <input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="#valuelist(GET_INTERNALDEMAND_RELATION.INTERNALDEMAND_ID)#">	
                        <input type="hidden" name="del_ship" id="del_ship" value="0">
                        <cfif isdefined("attributes.receiving_detail_id")>
                            <input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
                        </cfif>
                        <cf_box_elements>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="form_ul_process_cat">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#">
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_ship_number">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='726.Irsaliye No'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="ship_number" value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#" style="width:150px;"onBlur="paper_control(this,'SHIP',true,'','#get_upd_purchase.ship_number#',add_packetship.company_id.value,add_packetship.consumer_id.value);">
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_ship_method_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Metod'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="ship_method" id="ship_method" value="#get_upd_purchase.ship_method#">
                                            <cfif len(get_upd_purchase.ship_method)>
                                                <cfset attributes.ship_method_id = get_upd_purchase.ship_method>
                                                <cfinclude template="../query/get_ship_method.cfm">
                                            </cfif>
                                            <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)>#get_ship_method.ship_method#</cfif>" readonly style="width:150px;">
                                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <cfif len(get_upd_purchase.dispatch_ship_id)>
                                <div class="form-group" id="form_ul_ship_internal_number">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49564.İlişkili'><cf_get_lang dictionary_id='45959.Sevk Talebi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfquery name="get_ship_internal_number" datasource="#dsn2#">
                                            SELECT PAPER_NO FROM SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #get_upd_purchase.dispatch_ship_id#
                                        </cfquery>
                                            <input type="text" name="ship_internal_number" id="ship_internal_number" value="#get_ship_internal_number.paper_no#" readonly>
                                    </div>
                                </div>
                            </cfif>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group" id="form_ul_ship_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                            <cfinput type="text" name="ship_date" required="Yes" message="#message#" validate="#validate_style#" readonly value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" style="width:80px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="change_money_info" control_date="#dateformat(get_upd_purchase.ship_date,dateformat_style)#"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_deliver_date_frm">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='127.Fiili Sevk Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" name="deliver_date_frm" validate="#validate_style#" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" message="Lütfen Fiili Sevk Tarihini Giriniz !" style="width:80px;">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                                                <cfoutput>										
                                                    <cfif len(get_upd_purchase.deliver_date)>
                                                        <cfset value_deliver_date_h=hour(get_upd_purchase.deliver_date)>
                                                        <cfset value_deliver_date_m=minute(get_upd_purchase.deliver_date)>
                                                    <cfelse>
                                                        <cfset value_deliver_date_h=0>
                                                        <cfset value_deliver_date_m=0>
                                                    </cfif>
                                                </cfoutput>		    
                                            </div>
                                        </div>
                                        <cfoutput>
                                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">												
                                                <cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
                                            </div>
                                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">	
                                                <select name="deliver_date_m" id="deliver_date_m">
                                                    <cfloop from="0" to="59" index="i">
                                                        <option value="#i#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </div>	
                                        </cfoutput>	
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_ref_no">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1372.Ref No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="ref_no" id="ref_no" style="width:100px;" value="#get_upd_purchase.ref_no#">
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_work_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1033.İş'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("get_upd_purchase.work_id") and len(get_upd_purchase.work_id)>#get_upd_purchase.work_id#</cfif>">
                                            <input type="text" name="work_head" id="work_head" style="width:150px;" value="<cfif isdefined("get_upd_purchase.work_id") and len(get_upd_purchase.work_id)>#get_work_name(get_upd_purchase.work_id)#</cfif>">
                                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head','list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="form_ul_txt_departman_">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1631.Çıkış Depo'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkdepartmentlocation 
                                            returninputvalue="location_id,txt_departman_,department_id,branch_id"
                                            returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldname="txt_departman_"
                                            fieldid="location_id"
                                            department_fldid="department_id"
                                            xml_all_depo = "#xml_all_depo_outer#"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            department_id="#get_upd_purchase.deliver_store_id#"
                                            location_id="#get_upd_purchase.location#"
                                            location_name="#get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location)#"
                                            line_info = 1
                                            width="150">
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_location_in_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='96.Giriş Depo'> *</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkdepartmentlocation 
                                            returninputvalue="location_in_id,department_in_txt,department_in_id,branch_id"
                                            returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldname="department_in_txt"
                                            fieldid="location_in_id"
                                            department_fldid="department_in_id"
                                            user_level_control="0"
                                            xml_all_depo = "#xml_all_depo_entry#"
                                            department_id="#get_upd_purchase.department_in#"
                                            location_id="#get_upd_purchase.location_in#"
                                            location_name="#get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in)#"
                                            line_info = 2
                                            is_store_kontrol = "0"
                                            width="150">
                                    </div>
                                </div>
                                    <div class="form-group" id="form_ul_project_head">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='19.Cikis'> <cf_get_lang_main no='4.Proje'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_upd_purchase.project_id)>#get_upd_purchase.project_id#</cfif>"> 
                                                <input type="text" name="project_head" id="project_head" value="<cfif len(get_upd_purchase.project_id)>#get_project_name(get_upd_purchase.project_id)#</cfif>" style="width:150px;">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="form_ul_project_head_in">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='142.Giriş'> <cf_get_lang_main no='4.Proje'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="project_id_in" id="project_id_in" value="<cfif len(get_upd_purchase.project_id_in)>#get_upd_purchase.project_id_in#</cfif>"> 
                                                <input type="text" name="project_head_in" id="project_head_in" value="<cfif len(get_upd_purchase.project_id_in)>#get_project_name(get_upd_purchase.project_id_in)#</cfif>" style="width:150px;">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_in&project_head=form_basket.project_head_in');"></span>
                                            </div>
                                        </div>
                                    </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                <div class="form-group" id="form_ul_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Acıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="detail" id="detail" style="width:150px;height:45px;">#get_upd_purchase.ship_detail#</textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="form_ul_deliver_get">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='363.Teslim Alan'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfif len(get_upd_purchase.deliver_emp_id)>#get_upd_purchase.deliver_emp_id#<cfelseif xml_deliver_emp_automatic eq 1>#session.ep.userid#</cfif>">
                                            <input type="text" name="deliver_get" id="deliver_get" value="<cfif len(get_upd_purchase.deliver_emp_id)>#get_emp_info(get_upd_purchase.deliver_emp_id,0,0)#<cfelseif xml_deliver_emp_automatic eq 1>#get_emp_info(session.ep.userid,0,0)#</cfif>" style="width:150px;" readonly="yes">
                                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id&come=stock','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item_is_delivered">
                                    <div class="col" style="padding-right:0 !important; margin-right:0 !important;">
                                        <input type="checkbox" name="is_delivered" id="is_delivered" value="1" <cfif get_upd_purchase.is_delivered eq 1>checked</cfif>>
                                    </div>
                                    <label class="col col-11">
                                        <cf_get_lang no='39.Teslim Al'>
                                    </label>
                                </div>
                                <div class="form-group" id="form_ul_irsaliye_iptal">
                                    <div class="col" style="padding-right:0 !important; margin-right:0 !important;">
                                        <input name="irsaliye_iptal" id="irsaliye_iptal" value="1" type="checkbox" <cfif len(get_upd_purchase.is_ship_iptal) and get_upd_purchase.is_ship_iptal eq 1>checked</cfif>>
                                    </div>
                                    <label class="col col-11"><cf_get_lang no='502.İrsaliye İptal'>
                                    </label>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cf_box_footer>	
                            <div class="col col-6 col-xs-12">
                                <cf_record_info query_name='get_upd_purchase'>
                            </div>
                            <div class="col col-6 col-xs-12 text-right">
                                <cf_workcube_buttons is_upd='1' is_delete='1' add_function='depo_control()' del_function='kontrol2()'>
                            </div>
                        </cf_box_footer>
                    </cfoutput>
                </cf_basket_form>	
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<cfset location_info_ = get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location,1,1)> 
<form name="add_packetship" id="add_packetship" method="post" action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>list_packetship&event=add">
    <cfoutput>
        <input type="hidden" name="is_sevk" value="1">
        <input type="hidden" name="is_logistic2" id="is_logistic2" value="#attributes.ship_id#">
        <input type="hidden" name="branch_id" id="branch_id" value="#listlast(location_info_,',')#">
        <input type="hidden" name="department_id" id="department_id" value="#get_upd_purchase.deliver_store_id#">
        <input type="hidden" name="location_id" id="location_id" value="#get_upd_purchase.location#">
        <input type="hidden" name="department_name" id="department_name" value="#listfirst(location_info_,',')#">
        <input type="hidden" name="ship_method_id" id="ship_method_id" value="#get_upd_purchase.ship_method#">
        <input type="hidden" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)>#get_ship_method.ship_method#</cfif>">
        <input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
        <input type="hidden" name="company_id" id="company_id" value="#session.ep.company_id#">
        <input type="hidden" name="partner_id" id="partner_id" value="0">
        <cfif len(session.ep.company_id)>
        <input type="hidden" name="company" id="company" value="#get_par_info(session.ep.company_id,1,0,0)#">
        <cfelse>
        <input type="hidden" name="company" id="company" value="">	
        </cfif>
        <cfif len(get_upd_purchase.partner_id)>
        <input type="hidden" name="member_name" id="member_name" value="#get_par_info(get_upd_purchase.partner_id,0,-1,0)#">
        <cfelse>
        <input type="hidden" name="member_name" id="member_name" value="#get_cons_info(get_upd_purchase.consumer_id,0,0)#">	
        </cfif>  
    </cfoutput>
    </form>
<script type="text/javascript">
function get_packetship() 
{
	<cfif control_ship_result.recordcount>
		document.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&ship_result_id=#control_ship_result.SHIP_RESULT_ID#</cfoutput>';
	</cfif>
}
	function depo_control()
	{	
		if(!paper_control(form_basket.ship_number,'SHIP',true,'',<cfoutput>'#get_upd_purchase.ship_number#'</cfoutput>,add_packetship.company_id.value,add_packetship.consumer_id.value)) return false;
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(form_basket.is_delivered.checked)
		{
			if(form_basket.department_in_id.value == "" )
			{
				alert("<cf_get_lang no='138.Teslim Edilecek Depo Bilgisini Seçiniz'>");
				return false;
			}				
			// Xml den gelen parametre secilmis ise 
			<cfif xml_deliver_required eq 1>
				if(form_basket.deliver_get.value == "" )
				{
					alert("<cf_get_lang no='111.Teslim Alan Girmelisiniz'> !");
					return false;
				}
			</cfif>	
				
			if(form_basket.department_in_id.value != "" || form_basket.location_in_id.value != "")
			{ 
				var dep_loc = form_basket.department_in_id.value+'-'+form_basket.location_in_id.value;				
                get_dept = wrk_safe_query('stk_dept_ctrl','dsn',0,dep_loc);
				if(get_dept.recordcount == 0)
				{
					alert("<cf_get_lang dictionary_id='51200.Giriş depoda yetkili değilsiniz.Bu nedenle işlemi gerçekleştiremezsiniz.'>");
					return false;
				}
			}  
		}
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value == "")
		{
			alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value == "")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		<cfif isdefined("xml_select_same_dept") and xml_select_same_dept eq 0>
			if((form_basket.department_in_id.value == form_basket.department_id.value) && (form_basket.location_in_id.value == form_basket.location_id.value) )
			{
				alert("Giriş ve Çıkış Depoda Aynı Lokasyon Seçilemez!");
				return false;
			}
		</cfif>
        <cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
            if( window.basketManager !== undefined ){
				row_count = basketManagerObject.basketItems().length;
				if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
					if(row_count != undefined){
						for(i=0;i<row_count;i++){
							if( basketManagerObject.basketItems()[i].stock_id().length != 0){
								get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[i].stock_id());
								if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
									if(basketManagerObject.basketItems()[i].lot_no() == 0){
										alert((i+1)+'. satırdaki '+ basketManagerObject.basketItems()[i].product_name() + ' ürünü için lot no takibi yapılmaktadır!');
										return false;
									}
								}
							}
						}
					}
				}
			}else{
                row_count = window.basket.items.length;
                if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){ //işlem kategorisinde lot no zorunlu olsun seçili ise
                    if(row_count != undefined){
                        for(i=0;i<row_count;i++){
                            if(window.basket.items[i].STOCK_ID.length != 0){
                                get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
                                if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
                                    if(window.basket.items[i].LOT_NO.length == 0){
                                        alert((i+1)+'. satırdaki '+ window.basket.items[i].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
                                        return false;
                                        }
                                    }
                                }
                            }
                        }
                    }
                else{
                    if(window.basket.items[0].STOCK_ID.length != 0){
                        get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[0].STOCK_ID);
                            if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
                                if(window.basket.items[0].LOT_NO == ''){
                                    alert((1)+'. satırdaki '+ window.basket.items[0].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
                                    return false;
                                }
                            }
                        }
                    }
            }
		</cfif>
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('fin_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			var deliver_status = wrk_safe_query("stk_new_sql_ship",'dsn2',0,<cfoutput>#attributes.ship_id#</cfoutput>);
			if(document.form_basket.is_delivered.checked == true) is_deliver_ = 1; else is_deliver_ = 0;
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			// giriş depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1 && ((document.form_basket.is_delivered.checked == false && deliver_status.IS_DELIVERED == 1) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 0) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 1)))
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,0,1,is_deliver_)) return false;
			//cikis depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1)
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value)) return false;
		}
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head_in';
			project_field_id = 'project_id_in';
			apply_deliver_date('',project_field_name,project_field_id);
        </cfif>
        <cfif session.ep.our_company_info.is_eshipment>
            var xml_chk_eshipment = wrk_safe_query("chk_eshipment_count",'dsn2',0,'<cfoutput>#attributes.ship_id#</cfoutput>');

            if(xml_chk_eshipment.recordcount > 0){
                <cfif xml_upd_eshipment eq 0>
                    alert("<cf_get_lang dictionary_id='61202.e-İrsaliye olarak gönderilmiş irsaliye güncellenemez'>");
                        return false;
                <cfelse>
                    if( confirm( "<cf_get_lang dictionary_id='61203.e-İrsaliye olarak gönderilmiş İrsaliyeyi güncellemek istiyor musunuz ?'>" ) );
                    else return false;
                </cfif>
            }
        </cfif>
        
		saveForm();
		return false;	
	}
	function kontrol2()
	{
        <cfif session.ep.our_company_info.is_eshipment>
            var check_eshipment = wrk_safe_query("chk_eshipment_count",'dsn2',0,'<cfoutput>#attributes.ship_id#</cfoutput>');
            if(check_eshipment.recordcount > 0)
            {
                alert("<cf_get_lang dictionary_id='61035.İrsaliye ile ilişkili e-irsaliye oldugundan silinemez'>");
                return false;
            }
        </cfif>
    
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		form_basket.del_ship.value =1;
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,1,1)) return false;
			}
		}
		return true;
	}
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
