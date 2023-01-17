

<cf_xml_page_edit fuseact ="sales.list_opportunity" default_value="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_oppno" default="">
<cfparam name="attributes.keyword_detail" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif not isdefined("attributes.opp_status") and not isDefined('attributes.is_filtre')><cfset attributes.opp_status = 1></cfif>
<cfparam name="attributes.ordertype" default="2">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.order_no" default="">
<cfif not isdefined("attributes.sales_emp_id") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
	<cfset attributes.sales_emp_id = "#session.ep.userid#">
<cfelse>
	<cfparam name="attributes.sales_emp_id" default="">
</cfif>
<cfif not isdefined("attributes.sales_emp") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
	<cfset attributes.sales_emp = "#session.ep.name# #session.ep.surname#">
<cfelse>
	<cfparam name="attributes.sales_emp" default="">
</cfif>
<cfparam name="attributes.sales_member_id" default="">
<cfparam name="attributes.sales_member_type" default="">
<cfparam name="attributes.sales_member_name" default="">
<cfparam name="attributes.record_employee_id" default="">
<cfparam name="attributes.record_employee" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.stock_name" default="">
<cfparam name="attributes.sale_add_option" default="">
<cfparam name="attributes.probability" default="">
<cfparam name="attributes.opp_currency_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfinclude template="/V16/sales/query/get_probability_rate.cfm">
<cfinclude template="/V16/sales/query/get_opp_currencies.cfm">
<cfinclude template="/V16/sales/query/get_sale_add_option.cfm">
<cfif isdefined("attributes.is_filtre")>
  <cfinclude template="../query/get_reqs.cfm">
<cfelse>
  <cfset GET_SAMPLE_REQ.recordcount = 0>
</cfif>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_sample_request%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_SAMPLE_REQ.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_opportunities" >
<input type="hidden" name="is_filtre" id="is_filtre" value="1" />
<cf_big_list_search title="#getLang('textile',4)#">
    <cf_big_list_search_area>
        <div class="row form-inline">
		<!----
            <div class="form-group" id="form_ul_keyword">
                <div class="input-group x-10"><cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('main',68)#"></div>
            </div>
			
		--->
			<div class="form-group">
				<div class="input-group x-5_5"><cfinput type="text" name="keyword_oppno" value="#attributes.keyword_oppno#" placeholder="#getLang('main',75)#"></div>
			</div>
            <div class="form-group" id="form_ul_process_stage">
                <div class="input-group x-11">
                    <cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_type"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="Süreç"
                        value="#attributes.process_stage#">
                </div>
            </div>
            <div class="form-group" id="form_ul_opp_status">
                <div class="input-group x-6_5">
                    <select name="opp_status" id="opp_status">
						<option value=""><cf_get_lang_main no='669.hepsi'>
						<option value="1"<cfif isdefined("attributes.opp_status") and attributes.opp_status eq 1> selected</cfif>><cf_get_lang_main no='81.aktif'>
						<option value="0"<cfif isdefined("attributes.opp_status") and attributes.opp_status eq 0> selected</cfif>><cf_get_lang_main no='82.pasif'>
					</select>
                </div>
            </div>
            <div class="form-group x-3_5">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button>
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
            </div>
        </div>
    </cf_big_list_search_area>
    <cf_big_list_search_detail_area>
    	<cfoutput>
        <div class="row" type="row">
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<!---<div class="form-group" id="form_ul_keyword_detail">
					<label class="col col-12"><cf_get_lang_main no='217.Açıklama'></label>
					<div class="col col-12">
						<cfinput type="text" name="keyword_detail" value="#attributes.keyword_detail#">
					</div>
				</div>--->
				 <div class="form-group" id="form_ul_opportunity_type_id">
                    <label class="col col-12"><cf_get_lang_main no='74.Kategori'></label>
                    <div class="col col-12">
						<cf_multiselect_check
							name="opportunity_type_id"
							data_source="#DSN3#"

							option_name="OPPORTUNITY_TYPE"
							option_value="OPPORTUNITY_TYPE_ID"
							table_name="SETUP_OPPORTUNITY_TYPE"
							value="#attributes.opportunity_type_id#">
					</div>
                </div>
				<div class="form-group" id="form_ul_sales_emp">
                    <label class="col col-12">Müşteri Temsilcisi</label>
                    <div class="col col-12">
                        <div class="input-group">
                        <input type="hidden" name="sales_emp_id"  id="sales_emp_id" value="<cfif len(attributes.sales_emp) and len(attributes.sales_emp_id)>#attributes.sales_emp_id#</cfif>">
                        <input name="sales_emp" type="text" id="sales_emp" onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','135');" value="<cfif len(attributes.sales_emp) and len(attributes.sales_emp_id)>#get_emp_info(attributes.sales_emp_id,0,0)#</cfif>" autocomplete="off">
                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_opportunities.sales_emp_id&field_name=list_opportunities.sales_emp&select_list=1','list');"></span>
                  </div>
                    </div>
                </div>
				<!---
                <div class="form-group" id="form_ul_sales_member_name">
                    <label class="col col-12"><cf_get_lang no='102.Satış Ortağı'></label>
                    <div class="col col-12">
                        <div class="input-group">
                                <input type="hidden" name="sales_member_id" id="sales_member_id" value="#attributes.sales_member_id#">
                                <input type="hidden" name="sales_member_type" id="sales_member_type" value="<cfif attributes.sales_member_type is 'partner'>partner<cfelseif attributes.sales_member_type is 'consumer'>consumer</cfif>">
                                <input name="sales_member_name" type="text" id="sales_member_name"  style="width:110px;" onfocus="AutoComplete_Create('sales_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','sales_member_id,sales_member_id,sales_member_type','','3','250');" value="#attributes.sales_member_name#" autocomplete="off">
                                <cfset str_linke_ait="&field_consumer=list_opportunities.sales_member_id&field_comp_id=list_opportunities.sales_member_id&field_member_name=list_opportunities.sales_member_name&field_type=list_opportunities.sales_member_type">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&select_list=7,8&keyword='+encodeURIComponent(document.list_opportunities.sales_member_name.value),'list');"></span>
                            </div>
                    </div>
                </div>--->
                <div class="form-group" id="form_ul_member_name">
                    <label class="col col-12"><cf_get_lang_main no='45.Müşteri'></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_type)>#attributes.member_type#</cfif>">
                            <input name="member_name" type="text" id="member_name"  style="width:110px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif len(attributes.member_name)>#attributes.member_name#</cfif>" autocomplete="off" />
                            <cfset str_linke_ait="&field_consumer=list_opportunities.consumer_id&field_comp_id=list_opportunities.company_id&field_member_name=list_opportunities.member_name&field_type=list_opportunities.member_type">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&is_period_kontrol=0&select_list=7,8&keyword='+encodeURIComponent(document.list_opportunities.member_name.value),'list');"></span>
                        </div>
                    </div>
                </div>
                
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="form_ul_start_date">
					<label class="col col-6"><cfoutput>#getLang('main',641)#</cfoutput></label>
					<label class="col col-6"><cfoutput>#getLang('main',288)#</cfoutput></label>
					<div class="col col-6">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
							<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div class="col col-6">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
							<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
            	</div>
                <div class="form-group" id="form_ul_stock_name">
                    <label class="col col-12"><cf_get_lang_main no='245.Ürün'></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_name)>value="#attributes.stock_id#"</cfif>>
                            <input name="stock_name" type="text" id="stock_name" onfocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','list_opportunities','3','200');" value="<cfif len(attributes.stock_id) and len(attributes.stock_name)>#attributes.stock_name#</cfif>" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=list_opportunities.stock_id&field_name=list_opportunities.stock_name','list');"></span>
                      </div>
                  </div>
                </div>
                <div class="form-group" id="form_ul_project_head">
                    <label class="col col-12"><cf_get_lang_main no ='4.proje'></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                            <input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head','list');"></span>
                      </div>
                   </div>
                </div>
				
             </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="form_ul_ordertype">
					<label class="col col-12"><cfoutput>#getLang('main',1512)#</cfoutput></label>
					<div class="col col-12">
						<select name="ordertype" id="ordertype">
							<option value="1" <cfif attributes.ordertype eq 1>selected</cfif>>Numune Tarihine Göre Artan</option>
							<option value="2" <cfif attributes.ordertype eq 2>selected</cfif>>Numune Tarihine Göre Azalan</option>
							<option value="3" <cfif attributes.ordertype eq 3>selected</cfif>>Son Güncelleme</option>
							<option value="4" <cfif attributes.ordertype eq 4>selected</cfif>>Takipler</option>
							<option value="5" <cfif attributes.ordertype eq 5>selected</cfif>>Görevliye Göre Artan</option>
							<option value="6" <cfif attributes.ordertype eq 6>selected</cfif>>Görevliye Göre Azalan</option>
							<option value="7" <cfif attributes.ordertype eq 7>selected</cfif>>Projeye Göre Artan</option>
							<option value="8" <cfif attributes.ordertype eq 8>selected</cfif>>Projeye Göre Azalan</option>
							<option value="9" <cfif attributes.ordertype eq 9>selected</cfif>>Numune Noya Göre Artan</option>
							<option value="10" <cfif attributes.ordertype eq 10>selected</cfif>>Numune Noya  Göre Azalan</option>
							<option value="11" <cfif attributes.ordertype eq 11>selected</cfif>><cf_get_lang no="128.ne Göre Artan"></option>
							<option value="12" <cfif attributes.ordertype eq 12>selected</cfif>><cf_get_lang no="129.ne Göre Azalan"></option>
						</select>
					</div>
				</div>
                <div class="form-group" id="form_ul_product_cat">
                    <label class="col col-12"><cf_get_lang_main no='1604.Ürün Kategorisi'></label>
                    <div class="col col-12">
                        <div class="input-group">
                    <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                    <input name="product_cat" type="text" id="product_cat" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" value="<cfif len(attributes.product_cat)>#attributes.product_cat#</cfif>" autocomplete="off">
                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_opportunities.product_cat_id&field_name=list_opportunities.product_cat','list');"></span>
              </div>
                    </div>
                </div>
                <div class="form-group" id="form_ul_sale_add_option">
                    <label class="col col-12"><cf_get_lang no ='12.Satış Özel Tanımı'></label>
                    <div class="col col-12">
				
						
                        <select name="sale_add_option" multiple="multiple" id="sale_add_option" style="width:325px !important;">
                            <option value=""><cf_get_lang no ='12.Satış Özel Tanımı'></option>
                            <cfloop query="get_sale_add_option">
                                <option value="#sales_add_option_id#" <cfif attributes.sale_add_option eq sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
               <!--- <div class="form-group" id="form_ul_opp_currency_id">
                    <label class="col col-12"><cf_get_lang_main no='70.Aşama'></label>
                     <div class="col col-12">
                        <select name="opp_currency_id" id="opp_currency_id">
                            <option value=""><cf_get_lang_main no='70.Aşama'></option>
                            <cfloop query="get_opp_currencies">
                                <option value="#opp_currency_id#" <cfif listfind(attributes.opp_currency_id,opp_currency_id)> selected</cfif>>#opp_currency#</option>
                            </cfloop>
                        </select>
                        </div>
                </div>--->
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
               <div class="form-group" id="form_ul_record_employee">
                    <label class="col col-12"><cf_get_lang_main no='487.Kaydeden'></label>
                    <div class="col col-12">
                        <div class="input-group">
							<input type="hidden" name="record_employee_id" id="record_employee_id" value="<cfif Len(attributes.record_employee)>#attributes.record_employee_id#</cfif>">
							<input type="text" name="record_employee" id="record_employee"  value="<cfif Len(attributes.record_employee)>#attributes.record_employee#</cfif>" style="width:110px;" onfocus="AutoComplete_Create('record_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_employee_id','','3','125');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_opportunities.record_employee_id&field_name=list_opportunities.record_employee&select_list=1,9&branch_related','list','popup_list_positions')"></span>
						</div>
			  		</div>
                </div>
				  <div class="form-group" id="form-order_no">
					  <label class="col col-12">Müşteri Order No</label>
                      <div class="col col-12">
                        <div class="input-group">
							<cfinput type="text" name="order_no" id="order_no" value="#attributes.order_no#" placeholder="Order No ">
						</div>
					 </div>
                </div>
            </div>
    	</div>
        </cfoutput>
    </cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
           <!-- sil --> <th width="1%" colspan="2"></th><!-- sil -->
            <th width="200px">Resim</th>
            <th><cf_get_lang_main no='330.Tarih'></th>
            <th>Termin</th>
            <th><cfoutput>#getLang('textile',4)#</cfoutput><cf_get_lang_main no='75.No'></th>
            <th>Müşteri</th>
            <th>Müşteri Temsilcisi</th>
			<th>Müşteri Order No</th>
            <th>Proje</th>
            <th>Kategori</th>
            <!---<th>Müşteri Temsilcisi</th>--->
            <th>Ürün</th>
            <th>Tasarımcı</th>
           
            <th><cf_get_lang_main no='1447.Süreç'></th>
			<th>Kumaş Fiyat T.</th>
			<th>Aksesuar Fiyat T.</th>
			<th>Modelhane İş.</th>
			<th>İşçilik Fiyat İş.</th>
			<th>Yıkama Talepleri</th>
			<th>Kalıp İş.</th>
			<th>Pastal İş.</th>
            <th>Durum</th>
            <cfif x_update_date eq 1>
            <th><cf_get_lang no='33.Güncelleme Tarihi'></th>
            </cfif>
            <th></th>
            <th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=add"><img src="/images/plus_list.gif"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfset url_="">
        <cfset url_ = "#file_web_path#product/">
        <cfset uploadFolder = application.systemParam.systemParam().upload_folder />
        <cfset path = "#upload_folder#product#dir_seperator#">
        <cfif GET_SAMPLE_REQ.recordcount>
            <cfoutput query="GET_SAMPLE_REQ" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery name="get_related_process" datasource="#dsn3#">
					select TPP.PLAN_TYPE_ID, TPP.PLAN_TYPE, TPP.STAGE_ID, SRPC.COLOR FROM TEXTILE_PRODUCT_PLAN AS TPP LEFT JOIN #DSN#.SAMPLE_REQ_PROCESS_COLOR AS SRPC
					ON TPP.STAGE_ID = SRPC.PROCESS_ROW_ID WHERE REQUEST_ID = #REQ_ID# AND ACTIVE = 1 order by TPP.PLAN_TYPE_ID ASC
				</cfquery>
                <tr>
                   
				<!-- sil -->
                    <td align="center" id="opportunity_plus#currentrow#" class="color-row" onclick="gizle_goster(opportunity_plus_detail#currentrow#);connectAjax('#currentrow#','#company_id#','#req_id#');gizle_goster(opportunity_plus_goster#currentrow#);gizle_goster(opportunity_plus_gizle#currentrow#);">
                            <i id="opportunity_plus_goster#currentrow#" class="fa fa-chevron-circle-right fa-2x" title="Göster"></i>    
                            <i id="opportunity_plus_gizle#currentrow#" class="fa fa-chevron-circle-down fa-2x" title="Gizle" style="display:none"></i>
                    </td>
                <!-- sil -->
                <td>#currentrow#</td>
                <td>
                    <cfset assetFileName=asset_file_name>
                    <cfset asset_id=asset_id>
                    <cfset assetcat_id=assetcat_id>
                    <cfset file_path = '#path##assetFileName#'>
                    <cfif len(assetFileName) and FileExists(file_path)>
                        <cfif len(assetFileName) and FileExists("#uploadFolder#thumbnails/middle/#assetFileName#")>
                            <cfset imagePath = "documents/thumbnails/middle/#assetFileName#">
                        <cfelse>
                            <cfset imagePath = "documents/thumbnails/middle/#assetFileName#" />
                        </cfif>
                        <cfset icon = false>
                    <cfelse>
                        <cfset imagePath = "images/intranet/no-image.png">
                        <cfset icon = true>
                    </cfif>
                    <div class="image" style="width:80px;height:auto;">
                        <cfif icon>
                            <img src="#imagePath#" style="width:60px;margin-left:5px; height:auto;" class="img-thumbnail">
                        <cfelse>
                        <cfset ext=lcase(listlast(assetFileName, '.')) />
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##assetFileName#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
                                <img src="#imagePath#" style="margin-left:5px; width:60px;"class="img-thumbnail" >
                            </a>
                        </cfif>
                    </div>
                </td>
                    <td height="20">
                        <cfif attributes.ordertype eq 4>
                            #dateformat(date_add('h',session.ep.time_zone,plus_date),dateformat_style)#
                        <cfelse>
                            <cfif len(req_date)>
                                #dateformat(date_add('h',session.ep.time_zone,req_date),dateformat_style)#
                            <cfelse>
                                #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#
                            </cfif>
                        </cfif>
                    </td>
                    <td><cfif len(invoice_date)>#dateformat(date_add('h',session.ep.time_zone,invoice_date),dateformat_style)#</cfif></td>
                  
                    <td><a href="#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#req_id#&opp_no=#req_no#" class="tableyazi">#req_no#</a></td>
             
                    <td><cfif len(partner_id)>
                            #FULLNAME# - #PARTNER_NAME_SURNAME#
                        <cfelseif len(consumer_id)>
                            #CONSUMER_NAME#
                        </cfif>
                    </td>
                   <td>#EMPLOYEES_NAME#</td>
				   	<td>#COMPANY_ORDER_NO#</td>
                    <td><cfif isdefined("GET_SAMPLE_REQ.project_id") and len(GET_SAMPLE_REQ.project_id)>
                            <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a>
                        <cfelse>
                            <cf_get_lang_main no='1047.projesiz'>
                        </cfif>
                    </td>
                    <td><cfif len(opportunity_type_id)>#OPPORTUNITY_TYPE#</cfif></td>
                   
                    <!---<td><cfif len(sales_partner_id)>
                            #NICKNAME#
                        <cfelseif Len(sales_consumer_id)>
                            #SATIS_ORTAGI#
                        </cfif>
                    </td>--->
                    <td>
						<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_name#</a>
                    </td>
                    <td>#DESING_EMPLOYEES_NAME#</td>
                    <td><cfif len(req_stage)>#STAGE#</cfif></td>
					<cfif get_related_process.recordcount>
						<cfloop query="get_related_process">
							<cfif PLAN_TYPE_ID neq 1 and PLAN_TYPE_ID NEQ 6>
								<td style="background-color:#get_related_process.COLOR#"></td>
							</cfif>
						</cfloop>
						
					<cfelse>
						<cfloop from="1" to="6" index="i"><td></td></cfloop>
					</cfif>
                    <td><cfif req_status>Aktif<cfelse>Pasif</cfif></td>
                    <cfif x_update_date eq 1>
                        <td>#dateformat(UPDATE_DATE,dateformat_style)#</td>
                    </cfif>
                    <!-- sil -->
                  
                    <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=project.projects&event=kanban&id=#project_id#','page');"><i class="fa fa-flag fa-2x" title="Kanban"></i></a></td>
                    <td align="center"><a href="#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#req_id#&req_no=#req_no#"><i class="fa fa-edit fa-2x" title="Güncelle"></a></td>
                    <!-- sil -->
                </tr>
 				<!-- sil -->
                <tr id="opportunity_plus_detail#currentrow#" class="nohover" style="display:none">
                    <cfquery name="get_opportunity_pluses" datasource="#dsn3#">
                        SELECT OPP_ID,PLUS_CONTENT FROM OPPORTUNITIES_PLUS WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#req_id#"> ORDER BY RECORD_DATE DESC
                    </cfquery>
                    <cfif get_opportunity_pluses.recordcount>
                        <cfset height = 113>
                    <cfelseif get_opportunity_pluses.recordcount and not len(get_opportunity_pluses.plus_content)>
                        <cfset height = 94>
                    <cfelse>
                        <cfset height = 45>
                    </cfif>
                    <td colspan="16">
                        <div align="left" style="height:#height#;overflow:auto;" id="DISPLAY_OPP_PLUS_INFO#currentrow#"></div>
                    </td>
                </tr>
 				<!-- sil -->
            </cfoutput>
        <cfelse>
            <tr>
                <td <cfif x_update_date eq 1>colspan="17"<cfelse>colspan="16"</cfif>><cfif isdefined("attributes.is_filtre")><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset url_str = "&is_filtre=1">
<cfif GET_SAMPLE_REQ.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3">
				<cfif len(attributes.keyword)>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
                <cfif len(attributes.keyword_detail)>
					<cfset url_str = "#url_str#&keyword_detail=#attributes.keyword_detail#">
				</cfif>
                <cfif len(attributes.keyword_oppno)>
					<cfset url_str = "#url_str#&keyword_oppno=#attributes.keyword_oppno#">
				</cfif>
				<cfif isdate(attributes.start_date)>
					<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
				</cfif>
				<cfif isdate(attributes.finish_date)>
					<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
				</cfif>
				<cfif isdefined("attributes.opp_status") and Len(attributes.opp_status)>
					<cfset url_str = "#url_str#&opp_status=#attributes.opp_status#">
				</cfif>
				<cfif len(attributes.ordertype)>
					<cfset url_str = "#url_str#&ordertype=#attributes.ordertype#">
				</cfif>
				<cfif len(attributes.member_type) and len(attributes.member_name)>
					<cfset url_str = "#url_str#&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
				<cfif len(attributes.company_id)>
					<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
				<cfelse>
					<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
				</cfif>
				</cfif>
				<cfif len(attributes.sales_emp_id) and len(attributes.sales_emp)>
					<cfset url_str = "#url_str#&sales_emp_id=#attributes.sales_emp_id#&sales_emp=#attributes.sales_emp#">
				</cfif>
				<cfif len(attributes.sales_member_type) and len(attributes.sales_member_name) and len(attributes.sales_member_id)>
					<cfset url_str ="#url_str#&sales_member_type=#attributes.sales_member_type#&sales_member_id=#attributes.sales_member_id#&sales_member_name=#attributes.sales_member_name#">
				</cfif>
				<cfif len(attributes.record_employee_id) and len(attributes.record_employee)>
					<cfset url_str = "#url_str#&record_employee_id=#attributes.record_employee_id#&record_employee=#attributes.record_employee#">
				</cfif>
				<cfif len(attributes.process_stage)>
					<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
				</cfif>
				<cfif len(attributes.opportunity_type_id)>
					<cfset url_str = "#url_str#&opportunity_type_id=#attributes.opportunity_type_id#">
				</cfif>
				<cfif len(attributes.product_cat_id) and len(attributes.product_cat)>
					<cfset url_str = '#url_str#&product_cat_id=#attributes.product_cat_id#&product_cat=#attributes.product_cat#'>
				</cfif>
				<cfif len(attributes.stock_id) and len(attributes.stock_name)>
					<cfset url_str = '#url_str#&stock_id=#attributes.stock_id#&stock_name=#attributes.stock_name#'>
				</cfif>
				<cfif len(attributes.sale_add_option)>
					<cfset url_str = "#url_str#&sale_add_option=#attributes.sale_add_option#">
				</cfif>
				<cfif len(attributes.probability)>
					<cfset url_str = "#url_str#&probability=#attributes.probability#">
				</cfif>
				<cfif len(attributes.opp_currency_id)>
					<cfset url_str = "#url_str#&opp_currency_id=#attributes.opp_currency_id#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
				   <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
				   <cfset url_str = "#url_str#&project_head=#attributes.project_head#">
				</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="textile.list_sample_request#url_str#">
			</td>
		</tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
$(document).ready(function(){

	$("select#sale_add_option").select2();
});
document.getElementById('keyword').focus();
function connectAjax(crtrow,company_id,req_id)
{
	var load_url_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.emptypopup_critics&req_id='+req_id+'&company_id='+company_id;
	AjaxPageLoad(load_url_,'DISPLAY_OPP_PLUS_INFO'+crtrow,1);
}

</script>
