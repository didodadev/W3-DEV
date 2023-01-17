<cfsetting showdebugoutput="yes">
<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
<cfset attributes.UPD_ID = URL.SHIP_ID >
<cfset attributes.cat ="" >
<cfinclude template="../query/get_upd_stock_in_from_customs.cfm">
<cfif not get_upd_purchase.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
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
</cfif>
<cfset attributes.basket_id = 49>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_upd_stock_in">
                <cf_basket_form id="custom_ship">
                    <cfoutput>
                        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_stock_in">
                        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                        <input type="hidden" name="type_id" id="type_id" value="#get_upd_purchase.ship_type#">
                        <input type="hidden" name="upd_id" id="upd_id" value="#url.ship_id#">
                        <input type="hidden" name="cat" id="cat" value="#get_upd_purchase.ship_type#">
                        <input type="hidden" name="del_ship" id="del_ship" value="0">
                    </cfoutput>
                    <cf_box_elements>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                        <div class="form-group" id="item-process">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#"> 
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-ship_number">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='726.irsaliye no'> *</label>
                                            <div class="col col-9 col-xs-12"> 
                                                <cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="ship_number" style="width:150px;" value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#"> 
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-ship_method_name">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='1703.Sevk Yönetimi'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <div class="input-group">
                                                    <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_upd_purchase.SHIP_METHOD#</cfoutput>">
                                                    <cfif len(get_upd_purchase.SHIP_METHOD)>
                                                        <cfset attributes.ship_method_id=get_upd_purchase.SHIP_METHOD>
                                                        <cfinclude template="../query/get_ship_method.cfm">
                                                    </cfif>
                                                    <input type="text" name="ship_method_name" id="ship_method_name" readonly style="width:150px;"  value="<cfif len(get_upd_purchase.SHIP_METHOD)><cfoutput>#GET_SHIP_METHOD.SHIP_METHOD#</cfoutput></cfif>" >
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-bill_number">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no ='408.İthalat Faturası'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <div class="input-group">
                                                    <input type="text" name="bill_number" id="bill_number" value="" style="width:150px;">
                                                    <span class="input-group-addon btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=stock.popup_imports_invoice_product_list&invoice_number='+form_basket.bill_number.value+'&dep_id='+form_basket.department_id.value,'list');">?</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                        <div class="form-group" id="item-ship_date">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='330.tarih'> *</label>
                                            <div class="col col-9 col-xs-12"> 
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                                    <cfinput type="text" name="ship_date" required="Yes" message="#message#" validate="#validate_style#"  value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" style="width:80px;" readonly="yes">
                                                    
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="change_money_info" control_date="#dateformat(get_upd_purchase.ship_date,dateformat_style)#"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-deliver_date_frm">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no='127.fiili sevk tarih'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <div class="col col-6 col-xs-12"> 
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang no ='446.Lütfen Fiili Sevk Tarihini Giriniz'></cfsavecontent>
                                                    <cfinput type="text" name="deliver_date_frm" style="width:80px;"  validate="#validate_style#" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" message="#message#" readonly="yes">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm" control_date="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#"></span>&nbsp;
                                                    </div>    </div> 
                                                    <div class="col col-3 col-xs-12"> 
                                                    <cfoutput>										
                                                            <cfif len(get_upd_purchase.deliver_date)>
                                                                <cfset value_deliver_date_h=hour(get_upd_purchase.deliver_date)>
                                                                <cfset value_deliver_date_m=minute(get_upd_purchase.deliver_date)>
                                                            <cfelse>
                                                                <cfset value_deliver_date_h=0>
                                                                <cfset value_deliver_date_m=0>
                                                            </cfif>
                                                            <cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
                                                            </div> 
                                                            <div class="col col-3 col-xs-12"> 
                                                            <select name="deliver_date_m" id="deliver_date_m">
                                                                <cfloop from="0" to="59" index="i">
                                                                    <option value="#i#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                                </cfloop>
                                                            </select>
                                                    </cfoutput>	
                                                </div> 
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-ref_no">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='1382.Referans No'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <input type="text" name="ref_no" id="ref_no" style="width:80px;" value="<cfoutput>#get_upd_purchase.ref_no#</cfoutput>">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-deliver_get">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='363.teslim alan'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <div class="input-group">
                                                    <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfif len(get_upd_purchase.deliver_emp_id)><cfoutput>#get_upd_purchase.deliver_emp_id#</cfoutput></cfif>">
                                                    <cfinput type="text" name="deliver_get" style="width:150px;"  value="#get_emp_info(get_upd_purchase.deliver_emp_id,0,0)#">
                                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                        <div class="form-group" id="item-irsaliye_iptal">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no ='502.İrsaliye İptal'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <input name="irsaliye_iptal" id="irsaliye_iptal" value="1" type="checkbox" <cfif len(get_upd_purchase.is_ship_iptal) and get_upd_purchase.is_ship_iptal eq 1>checked</cfif>>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-is_delivered">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no='39.Teslim Al'></label>
                                            <div class="col col-9 col-xs-12"> 
                                                <input type="checkbox" name="is_delivered" id="is_delivered" value="1" <cfif get_upd_purchase.is_delivered eq 1>checked</cfif>>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-bagli_teklif">
                                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='45739.İlişkili İthalat Faturaları'>:</label>
                                            <div class="col col-9 col-xs-12">
                                                <cfif isdefined("inv_number_list") and len(inv_number_list)>
                                                    <cfoutput>
                                                        <cfloop from="1" to="#listlen(inv_number_list,',')#" index="i">
                                                            #listgetat(inv_number_list,i,',')#<cfif listlen(inv_number_list,',') neq i>,</cfif><cfif i mod 10 eq 0><br /></cfif> 
                                                        </cfloop>
                                                    </cfoutput>
                                                </cfif>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-txt_departman_">
                                            <label class="col col-3 col-xs-12"><cf_get_lang_main no='1631.Çıkış Depo'>*</label>
                                            <div class="col col-9 col-xs-12"> 
                                                <cfset location_info_=get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location,1,1)>
                                                <cf_wrkdepartmentlocation
                                                    returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                    fieldName="txt_departman_"
                                                    fieldid="location_id"
                                                    department_fldId="department_id"
                                                    branch_fldId="branch_id"
                                                    branch_id="#listlast(location_info_)#"
                                                    department_id="#get_upd_purchase.deliver_store_id#"
                                                    location_id="#get_upd_purchase.location#"
                                                    location_name="#listfirst(location_info_,',')#"
                                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                    width="150">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-department_in_txt">
                                            <label class="col col-3 col-xs-12"><cf_get_lang no='96.Giriş Depo'>*</label>
                                            <div class="col col-9 col-xs-12"> 
                                                <cfset location_out_info_=get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in,1,1)>
                                                <cf_wrkdepartmentlocation
                                                    returnInputValue="location_in_id,department_in_txt,department_in_id,branch_in_id"
                                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                    fieldName="department_in_txt"
                                                    fieldid="location_in_id"
                                                    department_fldId="department_in_id"
                                                    branch_fldId="branch_in_id"
                                                    branch_id="#listlast(location_out_info_)#"
                                                    department_id="#get_upd_purchase.department_in#"
                                                    location_id="#get_upd_purchase.location_in#"
                                                    location_name="#listfirst(location_out_info_)#"
                                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                    width="150">
                                            </div>
                                        </div>
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <div class="form-group" id="item-project_head">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <div class="input-group">
                                                        <cfif len(get_upd_purchase.project_id)>
                                                            <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_upd_purchase.project_id#
                                                            </cfquery>
                                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_upd_purchase.project_id#</cfoutput>"> 
                                                            <input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfoutput>#get_project.project_head#</cfoutput>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')" autocomplete="off">
                                                        <cfelse>
                                                            <input type="hidden" name="project_id" id="project_id" value=""> 
                                                            <input type="text" name="project_head" id="project_head" style="width:135px;" value=""  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')" autocomplete="off">
                                                        </cfif>
                                                        <cfoutput>
                                                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                                            <span class="input-group-addon btnPointer" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');">?</span>
                                                        </cfoutput>
                                                    </div>
                                                </div>
                                            </div>
                                        </cfif>                                        
                                    </div>
                        </cf_box_elements>
                            <cf_box_footer>
                                    <div class="col col-6"><cf_record_info query_name='get_upd_purchase'></div>
                                    <div class="col col-6">
                                        <cf_workcube_buttons 
                                            is_upd='1'
                                            is_delete='1'
                                            add_function='depo_control()'
                                            del_function='kontrol2()'>
                                    </div> 
                            </cf_box_footer>
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
		if(!chk_process_cat('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock()) return false;
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value==""||form_basket.department_in_id.value=="")
		{
		    alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value){
			alert("<cf_get_lang no='174.Giriş ve Çıkış Depoları Aynı Olamaz'>");
			return false;
		}
		if(form_basket.is_delivered.checked && form_basket.deliver_get.value == '' )
		{
			alert("<cf_get_lang no ='559.Teslim Alanı Seçmelisiniz'> !");
			return false;
		}
		saveForm();
		return false;	
	}
	function kontrol2()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		form_basket.del_ship.value =1;
		return true;
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('fin_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			var deliver_status = wrk_safe_query("stk_new_sql_ship",'dsn2',0,<cfoutput>#attributes.ship_id#</cfoutput>);
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			if(document.form_basket.is_delivered.checked == true) is_deliver_ = 1; else is_deliver_ = 0;
			// giriş depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1 && (document.form_basket.is_delivered.checked == true || (document.form_basket.is_delivered.checked == false && deliver_status.IS_DELIVERED == 1) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 0) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 1)))
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del,1,is_deliver_)) return false;
			//çıkış depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1)
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del,0)) return false;
		}
		return true;
	}
</script>
