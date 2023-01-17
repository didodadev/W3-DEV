 <cf_get_lang_set module_name="stock">
<cf_xml_page_edit fuseact="stock.form_add_fis">
<cfif isnumeric(attributes.upd_id)>
	<cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
	<cfinclude template="../query/get_fis_det.cfm">
	<cfif len(get_fis_det.prod_order_result_number) and len(get_fis_det.prod_order_number)>
		<cfquery name="GET_PROD_ORDER_NO" datasource="#DSN3#">
			SELECT 
				RESULT_NO,
				PR_ORDER_ID,
				PRODUCTION_ORDERS.P_ORDER_ID
			FROM
				PRODUCTION_ORDERS,
				PRODUCTION_ORDER_RESULTS
			WHERE 
				PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
				PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.prod_order_result_number#"> AND
				PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.prod_order_number#">
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_fis_det.recordcount = 0>
</cfif>
<cfscript>
xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cfif not get_fis_det.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse> 
<cfquery name="CONTROL_DISPOSAL" datasource="#DSN#">
    SELECT * FROM WASTE_DISPOSAL_RESULT WHERE DISPOSAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.upd_id#">
</cfquery>
<cfinclude template="../query/get_shipment_method.cfm">
<cfset attributes.cat="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_fis_process">
                <cfquery name="GET_INTERNALDEMAND_RELATION" datasource="#DSN3#">
                    SELECT 
                        DISTINCT 
                        IR.INTERNALDEMAND_ID
                    FROM 
                        INTERNALDEMAND_RELATION IR,
                        INTERNALDEMAND I
                    WHERE 
                        I.INTERNAL_ID = IR.INTERNALDEMAND_ID AND
                        IR.TO_STOCK_FIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.fis_id#"> AND 
                        IR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                </cfquery>
                <cf_basket_form id="upd_fis">
                    <cfoutput>
                        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_fis_process">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="fis_date">
                        <input type="hidden" name="type_id" id="type_id" value="#get_fis_det.fis_type#">
                        <input type="hidden" name="upd_id" id="upd_id" value="#url.upd_id#">
                        <input type="hidden" name="cat" id="cat" value="#get_fis_det.fis_type#">
                        <input type="hidden" name="x_cost_acc" id="x_cost_acc" value="#x_cost_acc#">
                        <input type="hidden" name="del_fis" id="del_fis" value="0">
                        <input type="hidden" name="fis_no" id="fis_no" value="">
                        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                        <input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="#valuelist(get_internaldemand_relation.internaldemand_id)#" >	
                        <input type="hidden" name="is_cost" id="is_cost" value="<cfif get_fis_det.is_cost eq 1>#get_fis_det.is_cost#<cfelse>0</cfif>"><!--- masraf dagılımı yapıldımı kontrol icin--->
                    </cfoutput>
                    <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-form_ul_process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45271.Fis Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat process_cat="#get_fis_det.process_cat#">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_FIS_NO">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fis No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="FIS_NO" required="yes" message="#getLang('','fis no girmelisiniz',45312)#" value="#get_fis_det.fis_number#">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_ref_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans No'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_fis_det.ref_no#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_work_head">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="work_id" id="work_id" value="<cfoutput>#get_fis_det.work_id#</cfoutput>">
                                        <input type="text" name="work_head" id="work_head" value="<cfif len(get_fis_det.work_id)><cfoutput>#get_work_name(get_fis_det.work_id)#</cfoutput></cfif>">
                                        <span class="input-group-addon icon-ellipsis" onclick="o_window();"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-form_ul_fis_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='45290.fis tarihi girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="fis_date" validate="#validate_style#" readonly required="yes" message="#message#" value="#dateformat(get_fis_det.fis_date,dateformat_style)#" onblur="change_money_info('form_basket','fis_date');">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="fis_date" call_function="change_money_info" control_date="#dateformat(get_fis_det.fis_date,dateformat_style)#"></span>
                                    </div>
                                </div>
                                <cfoutput>
                                    <cfif isdefined('get_fis_det.deliver_date') and len(get_fis_det.deliver_date)>
                                        <cfset value_fis_date_h = hour(get_fis_det.deliver_date)>
                                        <cfset value_fis_date_m = minute(get_fis_det.deliver_date)>
                                    <cfelse>
                                        <cfset value_fis_date_h = hour(dateadd('h',session.ep.time_zone,now()))>
                                        <cfset value_fis_date_m = minute(now())>
                                    </cfif>
                                    <div class="col col-2 col-xs-12">				
                                        <cf_wrkTimeFormat name="fis_date_h" value="#value_fis_date_h#">
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <select name="fis_date_m" id="fis_date_m">
                                            <cfloop from="0" to="59" index="i">
                                                <option value="#i#" <cfif value_fis_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
                                            </cfloop>
                                        </select>	
                                    </div>													
                                </cfoutput>     
                            </div>
                            <div class="form-group" id="item-form_ul_txt_departman_out">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfset location_info_=get_location_info(get_fis_det.department_out,get_fis_det.location_out,1,1)>
                                    <cf_wrkdepartmentlocation
                                        returnInputValue="location_out,txt_departman_out_name,department_out,branch_id"
                                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldName="txt_departman_out_name"
                                        fieldid="location_out"
                                        department_fldId="department_out"
                                        branch_fldId="branch_id"
                                        xml_all_depo = "#xml_all_depo_outer#"
                                        branch_id="#listlast(location_info_)#"
                                        department_id="#get_fis_det.department_out#"
                                        location_id="#get_fis_det.location_out#"
                                        location_name="#listfirst(location_info_,',')#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="150">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_txt_department_in">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45273.Giriş Depo'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfset location_out_info_=get_location_info(get_fis_det.department_in,get_fis_det.location_in,1,1)>
                                    <cf_wrkdepartmentlocation
                                        returnInputValue="location_in,department_in_txt,department_in,branch_in_id"
                                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldName="department_in_txt"
                                        fieldid="location_in"
                                        department_fldId="department_in"
                                        branch_fldId="branch_in_id"
                                        xml_all_depo = "#xml_all_depo_entry#"
                                        branch_id="#listlast(location_out_info_)#"
                                        department_id="#get_fis_det.department_in#"
                                        location_id="#get_fis_det.location_in#"
                                        location_name="#listfirst(location_out_info_)#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="150"
                                        call_function="kontrol_giris(0)">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_service_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57656.Servis"></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(get_fis_det.service_id)>
                                        <cfquery name="GET_SERVICE_NO" datasource="#DSN3#">
                                            SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = #get_fis_det.service_id#
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" name="service_id" id="service_id" value="<cfif isdefined("get_fis_det.service_id") and len(get_fis_det.service_id)><cfoutput>#get_fis_det.service_id#</cfoutput></cfif>"/>
                                    <input type="text" name="service_name" id="service_name" value="<cfif isdefined("get_fis_det.service_id") and len(get_fis_det.service_id)><cfoutput>#GET_SERVICE_NO.SERVICE_NO#</cfoutput></cfif>" readonly/>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-form_ul_prod_order">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45276.Üretim Emir No'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_fis_det.prod_order_number)>
                                            <cfquery name="GET_PRODUCTION_ORDER" datasource="#DSN3#">
                                                SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #get_fis_det.prod_order_number#
                                            </cfquery>				  
                                        </cfif>
                                        <input type="hidden" name="prod_order_number" id="prod_order_number" value="<cfoutput>#get_fis_det.prod_order_number#</cfoutput>"> 
                                        <input type="text" name="prod_order" id="prod_order" value="<cfif len(get_fis_det.prod_order_number)><cfoutput>#get_production_order.p_order_no#</cfoutput></cfif>">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_prod_order&field_id=form_basket.prod_order_number&field_name=form_basket.prod_order</cfoutput>&keyword='+encodeURIComponent(document.form_basket.prod_order.value));"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_project_head">
                                <label class="col col-4 col-xs-12"><cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang dictionary_id='29523.Cikis Proje'></cfif></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <cfif len(get_fis_det.project_id)>
                                                <cfquery name="GET_PROJECT" datasource="#DSN#">
                                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
                                                </cfquery>
                                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_fis_det.project_id#</cfoutput>"> 
                                                <input type="text" name="project_head" id="project_head" onfocus="if(kontrol_cikis())AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125'); else return true;" value="<cfoutput>#get_project_name(get_fis_det.project_id)#</cfoutput>" onchange="if(document.getElementById('project_head').value==''){document.getElementById('project_id').value='';}">
                                            <cfelse>
                                                <input type="hidden" name="project_id" id="project_id" value=""> 
                                                <input type="text" name="project_head" id="project_head" onfocus="if(kontrol_cikis())AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125'); else return true;" onchange="if(document.getElementById('project_head').value==''){document.getElementById('project_id').value='';}" value="">
                                            </cfif>
                                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                            <cfif len(get_fis_det.project_id)>
                                                <span class="input-group-addon icon-ellipsis" onclick="if(document.getElementById('project_id').value!='')windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_list_project_actions&from_paper=STOCK_FIS&id='+document.getElementById('project_id').value+'','horizantal');else alert("<cf_get_lang dictionary_id='29523.Çıkış Proje Seçiniz'>");"></span>
                                            </cfif>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_project_head_in">
                                <label class="col col-4 col-xs-12"><cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang dictionary_id='29757.Giris Proje'></cfif></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <cfif len(get_fis_det.project_id_in)>
                                                <cfquery name="GET_PROJECT" datasource="#DSN#">
                                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.project_id_in#">
                                                </cfquery>
                                                <input type="hidden" name="project_id_in" id="project_id_in" value="<cfoutput>#get_fis_det.project_id_in#</cfoutput>"> 
                                                <input type="text" name="project_head_in" id="project_head_in" onfocus="AutoComplete_Create('project_head_in','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_in','','3','125');" value="<cfoutput>#get_project_name(get_fis_det.project_id_in)#</cfoutput>">
                                            <cfelse>
                                                <input type="hidden" name="project_id_in" id="project_id_in" value=""> 
                                                <input type="text" name="project_head_in" id="project_head_in" onfocus="AutoComplete_Create('project_head_in','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_in','','3','125');" value="">
                                            </cfif>
                                            <span class="input-group-addon icon-ellipsis" onclick="if(kontrol_giris(1))openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_in&project_head=form_basket.project_head_in');else return true;"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_txt_subscription">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_subscriptions width_info='125' subscription_id= "#get_fis_det.subscription_id#" fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <cfoutput>
                                <div class="form-group" id="item-form_ul_member_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="company_id" id="company_id" value="#get_fis_det.company_id#">
                                            <input type="hidden" name="partner_id" id="partner_id" value="#get_fis_det.partner_id#">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="#get_fis_det.consumer_id#">
                                            <input type="hidden" name="employee_id" id="employee_id" value="#get_fis_det.employee_id#">
                                            <input type="hidden" name="member_type" id="member_type" value="<cfif len(get_fis_det.partner_id)>partner<cfelseif len(get_fis_det.consumer_id)>consumer<cfelseif len(get_fis_det.employee_id)>employee</cfif>">
                                            <cfif len(get_fis_det.partner_id)>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45288.Teslim Alan Girmelisiniz'> !</cfsavecontent>
                                                <cfinput type="text" name="member_name" id="member_name" value="#get_par_info(get_fis_det.partner_id,0,0,0)#" required="yes" message="#message#" readonly="yes">
                                            <cfelseif len(get_fis_det.consumer_id)>
                                                <cfinput type="text" name="member_name" id="member_name" value="#get_cons_info(get_fis_det.consumer_id,0,0)#" required="yes" message="#message#" readonly="yes">
                                            <cfelseif len(get_fis_det.employee_id)>
                                                <cfinput type="text" name="member_name" id="member_name" value="#get_emp_info(get_fis_det.employee_id,0,0)#" required="yes" message="#message#" readonly="yes">
                                            </cfif>
                                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_id=form_basket.company_id&field_emp_id=form_basket.employee_id&field_name=form_basket.member_name&field_type=form_basket.member_type&select_list=1,7,8');"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>
                            <div class="form-group" id="item-form_ul_detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="detail" id="detail" style="width:140px;height:40px;"><cfoutput>#get_fis_det.fis_detail#</cfoutput></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_is_productions">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45596.Üretime Giden'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="is_productions" id="is_productions" value="" <cfif get_fis_det.is_production eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-wrk_add_info">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-22" info_id="#attributes.upd_id#" upd_page = "1" colspan="6">
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6 col-xs-12">
                            <cf_record_info query_name="get_fis_det">
                        </div>
                        <div class="col col-6 col-xs-12 text-right">
                            <cfif len(get_fis_det.prod_order_result_number) and len (get_fis_det.prod_order_number)>
                                <font color="#FF0000"><cf_get_lang dictionary_id ='45598.Bu Stok Fişi'> <b><cfoutput><a href="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#GET_PROD_ORDER_NO.P_ORDER_ID#&pr_order_id=#GET_PROD_ORDER_NO.PR_ORDER_ID#" target="_blank">#GET_PROD_ORDER_NO.RESULT_NO#</a></cfoutput></b><cf_get_lang dictionary_id ='45597.numarali üretim sonuç ekranından güncellenebilir'></font>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' is_delete=1 add_function='kontrol_kayit()' del_function='kontrol2()'>
                            </cfif>
                        </div>
                    </cf_box_footer>
                </cf_basket_form>
                <cfif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
                    <cfset attributes.basket_id = 19> 
                    <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
                        SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 19 AND B_TYPE=1 AND TITLE = 'is_project_selected'
                    </cfquery>
                <cfelse>
                    <cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
                        SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 12 AND B_TYPE=1 AND TITLE = 'is_project_selected'
                    </cfquery>
                    <cfset attributes.basket_id = 12>
                </cfif>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<script type="text/javascript">

    function kontrol_giris(type)
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = eval("form_basket.ct_process_type_" + deger );
        if(list_find('111,112', fis_no.value))
        {
            if(type == 0)
			alert("<cf_get_lang dictionary_id ='45411.Sarf ve Fire Fişleri için Giriş Deposu Seçemezsiniz'>!");
			else
			alert("<cf_get_lang dictionary_id ='45249.Sarf ve Fire Fişleri için Giriş Proje Seçemezsiniz'>!");
            return false;
        }
        return true;
    }
    function o_window()
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = eval("form_basket.ct_process_type_" + deger );
        if(list_find('111,112', fis_no.value) && document.getElementById('project_id').value!='')
        {
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&sarf_project_id='+document.getElementById('project_id').value);
        }
        else
        {
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head');
        }
    }
    function kontrol2()
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = eval("form_basket.ct_process_type_" + deger );
		$("#fis_no").val(eval("form_basket.ct_process_type_" + deger ));
        if(!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if(!chk_period(form_basket.fis_date,"İşlem")) return false;
        form_basket.del_fis.value =1;
		if(check_stock_action('form_basket') && list_find('110,113,115', fis_no.value))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				if(listfind('113,115',fis_no.value)) is_purchase_info = 1; else is_purchase_info = 0;
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,1,1)) return false;
			}
		}
		if(list_find('110,115,119', fis_no.value))
			{
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
						if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
							if(row_count != undefined){
								for(i=0;i<row_count;i++){
									if(window.basket.items[i].STOCK_ID.length != 0){
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
										if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
											if(window.basket.items[i].LOT_NO.length == 0){
												alert((i+1)+'. <cf_get_lang dictionary_id ='59292.satırdaki'> '+ window.basket.items[i].PRODUCT_NAME + ' <cf_get_lang dictionary_id ='59288.ürünü için lot no takibi yapılmaktadı'>!');
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
										alert((1)+'. <cf_get_lang dictionary_id ='59292.satırdaki'> '+ window.basket.items[0].PRODUCT_NAME + ' <cf_get_lang dictionary_id ='59288.ürünü için lot no takibi yapılmaktadı'>!');
										return false;
										}
									}
								}
							}
						}			
				</cfif>	
			}
        return true;
    }
    
    function kontrol_cikis()
    {
        deger=parseInt(window.document.form_basket.process_cat.value);
        var fis_no = eval("form_basket.ct_process_type_" + deger );
        if(list_find('110,115,119', fis_no.value))
        {
            alert("<cf_get_lang dictionary_id ='45599.Üretimden Gelen Ürünler ve Sayım Fişi için Çıkış  Deposu Seçemezsiniz'>");
            document.getElementById("project_head").blur();
            return false;
        }
        return true;
    }
    
    function kontrol_kayit()
    {
        if(!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if(!chk_period(form_basket.fis_date,"İşlem")) return false;
		if(!paper_control(form_basket.FIS_NO,'STOCK_FIS',true,<cfoutput>'#attributes.upd_id#','#get_fis_det.fis_number#'</cfoutput>)) return false;
        var is_fis_cost = true;
        if(document.form_basket.is_cost.value==0) 
            is_fis_cost = false;
        if (is_fis_cost && !confirm("<cf_get_lang dictionary_id ='45600.Güncellediğiniz Belgenin Masraf Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
        deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
        if(deger != "")
        {

            var fis_no = eval("form_basket.ct_process_type_" + deger );
            if(list_find('110,115,119', fis_no.value))
            {
                if(form_basket.department_in.value == "" || form_basket.department_in_txt.value == "")
                {
                    alert("<cf_get_lang dictionary_id ='45601.Giriş Deposunu Seçmelisiniz'> !");
                    return false;
                }
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
                    {
                        alert("<cf_get_lang dictionary_id='29757.Giriş Proje'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
                        return false;
                    }
                </cfif>
            }
            if(list_find('111,112', fis_no.value))
            {
                if(form_basket.department_out.value == "" || form_basket.txt_departman_out_name.value == "")
                {
                    alert("<cf_get_lang dictionary_id ='45602.Çıkış Deposunu Seçmelisiniz'>!");					
                    return false;
                }

                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
                    {
                        alert("<cf_get_lang dictionary_id='29523.Çıkış Proje'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
                        return false;
                    }
                </cfif>

            }
            if(list_find('113,114',fis_no.value))
            {
                if(form_basket.department_in.value == "" || form_basket.department_in_txt.value == "" || form_basket.department_out.value == "" || form_basket.txt_departman_out_name.value == "" )
                {
                    alert("<cf_get_lang dictionary_id ='45603.Giriş ve Çıkış Depolarını Seçmelisiniz'>!");
                    return false;
                }
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                
                    if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
                    {
                        alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29757.Giris Proje'>");
                        return false;
                    }
                </cfif>
                <cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
                    if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
                    {
                        alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29523.Cikis Proje'>");
                        return false;
                    }
                </cfif>										
            }
            if(check_stock_action('form_basket') && list_find('110,113,115', fis_no.value))
            {
                var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
                if(basket_zero_stock_status.IS_SELECTED != 1)
                {
                    if(fis_no.value == 113) is_purchase_info = 1; else is_purchase_info = 0;
                    var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
                    var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
                    if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,0,is_purchase_info)) return false;
                }
            }
            if(check_stock_action('form_basket') && list_find('110,111,112,113', fis_no.value))
            {
                var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0, <cfoutput>#attributes.basket_id#</cfoutput>);
                if(basket_zero_stock_status.IS_SELECTED != 1)
                {
                    if(!zero_stock_control(form_basket.department_out.value,form_basket.location_out.value,form_basket.upd_id.value,fis_no.value)) return false;
                }
            }
			saveForm();
            return false;
        }
        else
        {
            alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!");
            return false;
        }
    }
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
