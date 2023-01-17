<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="stock.add_stock_in_from_customs">
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfparam name="attributes.ship_date" default="#dateformat(now(),dateformat_style)#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">    
        <cf_box>
            <div id="basket_main_div">
                <cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_add_stock_in">
                    <cf_basket_form id="add_stock_in">
                        <cfoutput>
                            <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_stock_in">
                            <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                            <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                            <input type="hidden" name="paper_number" id="paper_number" value="<cfif isdefined("paper_number")>#paper_number#</cfif>">
                            <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
                        </cfoutput>
                        <cf_box_elements>
                                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                            <div class="form-group" id="item-process">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <cf_workcube_process_cat>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-ship_number">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='726.irsaliye no'> *</label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'>!</cfsavecontent>
                                                    <cfif isdefined("paper_full")>
                                                        <cfinput type="text" name="ship_number" style="width:150px;"  required="Yes"  message="#message#" maxlength="50" value="#paper_full#" >
                                                    <cfelse>
                                                        <cfinput type="text" name="ship_number" style="width:150px;"  required="Yes"  message="#message#" maxlength="50" value="" >					
                                                    </cfif>  
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-ship_method_name">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1703.Sevk Yönetimi'></label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <div class="input-group">
                                                        <input type="hidden" name="ship_method" id="ship_method" value="">
                                                        <input type="text" name="ship_method_name" id="ship_method_name"  style="width:150px;" readonly  value="" >
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
                                                        <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
                                                        <cfinput type="text" required="Yes" message="#message#" validate="#validate_style#" readonly="yes" name="ship_date" style="width:80px;" value="#attributes.ship_date#">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="change_money_info"></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-deliver_date_frm">
                                                <label class="col col-3 col-xs-12"><cf_get_lang no='127.fiili sevk tarih'></label>
                                                <div class="col col-6 col-xs-12"> 
                                                    <div class="input-group">
                                                        <cfsavecontent variable="message"><cf_get_lang no ='446.Lütfen Fiili Sevk Tarihini Giriniz'></cfsavecontent>
                                                        <cfinput type="text" name="deliver_date_frm" id="deliver_date_frm" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" style="width:80px;" message="#message#">
                                                        <cfset get_date_bugun = dateformat(now(),dateformat_style)>
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm" call_function="change_money_info"></span>&nbsp;
                                                        </div>  </div>
                                                        <div class="col col-3 col-xs-12"> 
                                                        <cfoutput>			  <div class="col col-6 col-xs-12"> 								
                                                                <cfif isdefined('get_date_bugun')>
                                                                    <cfset value_deliver_date_h = hour(now())>
                                                                    <cfset value_deliver_date_m = minute(now())>
                                                                <cfelse>
                                                                    <cfset value_deliver_date_h = 0>
                                                                    <cfset value_deliver_date_m = 0>
                                                                </cfif>
                                                                <cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
                                                                </div> <div class="col col-6 col-xs-12"> 
                                                                <select name="deliver_date_m" id="deliver_date_m">
                                                                    <cfloop from="0" to="59" index="i">
                                                                        <option value="#i#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
                                                                    </cfloop>
                                                                </select>	
                                                        </cfoutput>       
                                                    </div> </div>
                                            
                                            </div>
                                            <div class="form-group" id="item-ref_no">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1382.Referans No'></label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <input type="text" name="ref_no" id="ref_no" value="" style="width:80px;">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                            <div class="form-group" id="item-txt_departman_">
                                                <label class="col col-3 col-xs-12"><cf_get_lang_main no='1631.Çıkış Depo'>*</label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <cfif len(listgetat(session.ep.user_location, 1, '-'))>
                                                        <cfquery name="GET_NAME_OF_DEP" datasource="#dsn#">
                                                            SELECT
                                                                SL.PRIORITY,SL.LOCATION_ID,
                                                                D.DEPARTMENT_HEAD,SL.DEPARTMENT_ID,D.BRANCH_ID
                                                            FROM
                                                                DEPARTMENT D,
                                                                STOCKS_LOCATION SL
                                                            WHERE
                                                                SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND	
                                                                D.DEPARTMENT_ID = #listgetat(session.ep.user_location, 1, '-')# AND 
                                                                IS_STORE <> 2 AND
                                                                SL.PRIORITY=1					
                                                        </cfquery>
                                                        <cfset txt_department_name=get_name_of_dep.department_head>
                                                        <cf_wrkdepartmentlocation
                                                            returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                            fieldName="txt_departman_"
                                                            fieldId="location_id"
                                                            department_fldId="department_id"
                                                            branch_fldId="branch_id"
                                                            branch_id="#get_name_of_dep.branch_id#"
                                                            department_id="#get_name_of_dep.department_id#"
                                                            location_id="#get_name_of_dep.location_id#"
                                                            location_name="#txt_department_name#"
                                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                            line_info = 1
                                                            width="150">
                                                    <cfelse>
                                                        <cf_wrkdepartmentlocation
                                                            returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                            fieldName="txt_departman_"
                                                            fieldId="location_id"
                                                            department_fldId="department_id"
                                                            branch_fldId="branch_id"
                                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                            line_info = 1
                                                            width="150">
                                                    </cfif>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-department_in_txt">
                                                <label class="col col-3 col-xs-12"><cf_get_lang no='96.Giriş Depo'>*</label>
                                                <div class="col col-9 col-xs-12"> 
                                                    <cf_wrkdepartmentlocation
                                                        returnInputValue="location_in_id,department_in_txt,department_in_id,branch_in_id"
                                                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                        fieldName="department_in_txt"
                                                        fieldid="location_in_id"
                                                        department_fldId="department_in_id"
                                                        branch_fldId="branch_in_id"
                                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                        line_info = 2
                                                        width="150">
                                                </div>
                                            </div>
                                            <cfif session.ep.our_company_info.project_followup eq 1>
                                                <div class="form-group" id="item-project_head">
                                                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                                    <div class="col col-9 col-xs-12"> 
                                                        <div class="input-group">
                                                            <cfoutput>
                                                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')>#attributes.pj_id#</cfif>"> 
                                                                <input type="text" name="project_head" id="project_head" style="width:150px;" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)>#GET_PROJECT_NAME(attributes.pj_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')" autocomplete="off">
                                                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                                                <span class="input-group-addon btnPointer" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang_main no="1385.Proje Seçiniz">');">?</span>
                                                            </cfoutput>
                                                        </div>
                                                    </div>
                                                </div>
                                            </cfif>
                                        </div>
                                    </cf_box_elements>
                                <cf_box_footer>
                                        <div class="col col-12"><cf_workcube_buttons is_upd='0' add_function="control_depo()"></div> 
                                </cf_box_footer>                 
                    </cf_basket_form>
                    <cfset attributes.basket_id = 49>			
                    <cfset attributes.form_add = 1 >
                    <cfinclude template="../../objects/display/basket.cfm">
                </cfform>
            </div>
    </cf_box>
</div>
<script type="text/javascript">
	function control_depo()
	{
		if(!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
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
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
			if(form_basket.product_id != undefined && form_basket.product_id.length != undefined && form_basket.product_id.length >1)
			{
				var bsk_rowCount_ = form_basket.product_id.length;
				prod_name_list = '';
				for(var str_i_r=0; str_i_r < bsk_rowCount_; str_i_r++)
				{
					if(document.form_basket.product_id[str_i_r].value != '')
					{
						wrk_row_id_ = document.form_basket.wrk_row_id[str_i_r].value;
						amount_ = filterNum(document.form_basket.Amount[str_i_r].value);
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, document.form_basket.product_id[str_i_r].value);
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						var get_serial_control = wrk_query(str1_,'dsn3');
						if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
						{
							prod_name_list = prod_name_list + eval(str_i_r +1) + '.Satır : ' + document.form_basket.product_name[str_i_r].value + '\n';
						}
					}
				}
				if(prod_name_list!='')
				{
					alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
					return false;
				}
			}
			else if(document.all.product_id != undefined && document.all.product_id.value != '')
			{
				prod_id_ = document.all.product_id.value;
				wrk_row_id_ = document.all.wrk_row_id.value;
				amount_ = filterNum(document.all.Amount.value);
				product_serial_control_ = wrk_safe_query("chk_product_serial1",'dsn3',0,prod_id_);
				str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
				get_serial_control_ = wrk_query(str1_,'dsn3');
				if(product_serial_control_.IS_SERIAL_NO == 1 && get_serial_control_.recordcount != amount_)
				{
                    product_name = product_serial_control_.PRODUCT_NAME;
					alert( '1.Satır : ' +product_name+" Adlı Ürün İçin Seri Numarası Girmelisiniz!");
					return false;
				}
			}		
		</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value){
			alert("<cf_get_lang no='174.Giriş ve Çıkış Depoları Aynı Olamaz'>!");
			return false;
		}
		else{
			saveForm();
			return false;	
		}			
	}
	function irs_tip_sec()
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<=max_sel;my_i++)
		{
			deger = form_basket.process_cat.options[my_i].value;
			if(deger!="")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger );
				if(fis_no.value == 811)
				{
					form_basket.process_cat.options[my_i].selected = true;
					my_i = max_sel + 1;
				}
			}
		}
	}
	function chck_zero_stock()
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value,0)) return false;
			}
		}
		return true;
	}
	irs_tip_sec();
</script>
