<cfsetting showdebugoutput="yes">
<cf_xml_page_edit>
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.process_id" default="">
<cfparam name="attributes.process_number" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.group" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfif not isdefined("attributes.invoice_number") and not isdefined("url.service_id")>
	<cfparam name="attributes.process_cat_id" default="">
<cfelse>
	<cfparam name="attributes.process_cat_id" default="">
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfset attributes.date2=''>
	<cfelse>
	<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
<cfset attributes.date1=''>
<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
</cfif>
</cfif>
<cfif isdefined("attributes.is_filtre")>
	<cfinclude template="../query/get_serial_row_list.cfm">
<cfelse>
	<cfset get_serial_row_list.recordcount = 0>
</cfif>
<cfset adres="&is_filtre=1">
<cfif len(attributes.lot_no)>
	<cfset adres = "#adres#&lot_no=#attributes.lot_no#">
</cfif>
<cfif len(attributes.process_cat_id)>
	<cfset adres = "#adres#&process_cat_id=#attributes.process_cat_id#">
</cfif>
<cfif len(attributes.belge_no)>
	<cfset adres = "#adres#&belge_no=#attributes.belge_no#">
</cfif>	
<cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
	<cfset adres = "#adres#&invoice_number=#attributes.invoice_number#">
</cfif>			
<cfif isdate(attributes.date1)>
	<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
</cfif>
<cfif isdate(attributes.date2)>
	<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
</cfif>
<cfif len(attributes.company_id) and len(attributes.company)>
	<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
<cfelseif len(attributes.consumer_id) and len(attributes.company)>
	<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
</cfif>
<cfif len(attributes.employee_id) and len(attributes.employee)>
	<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
</cfif>
<cfif len(attributes.stock_id) and len(attributes.product_name)>
	<cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_name=#attributes.product_name#">
</cfif>
<cfif len(attributes.department_id) and len(attributes.department_name)>
	<cfset adres = "#adres#&department_id=#attributes.department_id#&department_name=#attributes.department_name#">
</cfif>
<cfif len(attributes.location_id) and len(attributes.department_name)>
	<cfset adres = "#adres#&location_id=#attributes.location_id#">
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
	<cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_serial_row_list.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_serial" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations">
			<input type="hidden" name="is_filtre" id="is_filtre" value="1">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<input type="text" name="serial_no" placeholder="#getLang(225,'Seri No',57637)#" id="serial_no" value="#attributes.serial_no#" maxlength="50">
					</div>
					<div class="form-group">
						<input type="text" maxlength="50" placeholder="#getLang(321,'Lot No',45498)#" name="lot_no" id="lot_no" value="#attributes.lot_no#">
					</div>
					<div class="form-group">
						<input type="text" maxlength="50" placeholder="#getLang(468,'Belge No',57880)#" name="belge_no" id="belge_no" value="#attributes.belge_no#">
					</div>
					<div class="form-group">
						<cf_wrkdepartmentlocation 
							returninputvalue="department_name,department_id,location_id"
							returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
							fieldname="department_name"
							fieldid="location_id"
							department_fldid="department_id"
							department_id="#attributes.department_id#"
							location_id="#attributes.location_id#"
							location_name="#attributes.department_name#"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
							placeholder="#getLang(1351,'Depo',58763)#">
					</div>
					<div class="form-group">
						<cfset process_cat_id_ship_list = "70,71,72,73,74,75,76,77,78,79,81,811,84,88">
						<cfset process_cat_id_service_list = "85,86,140,141">
						<cfset process_cat_id_plug_list = "110,11,111,112,113,114,115,119,1190,1131,116,118,1182">
						<cfset process_cat_id_product_list = "171,1194">
						<cfset process_cat_id_system_list = "1193">
						<select name="process_cat_id" id="process_cat_id">
							<option value="" selected><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
							<optgroup label="<cf_get_lang dictionary_id='45485.İrsaliyeler'>">
								<cfloop list="#process_cat_id_ship_list#" index="aa">
									<option value="#aa#" <cfif attributes.process_cat_id eq aa>selected</cfif>>#get_process_name(aa)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang dictionary_id='45503.Servis ve RMA'>">
								<cfloop list="#process_cat_id_service_list#" index="bb">
									<option value="#bb#" <cfif attributes.process_cat_id eq bb>selected</cfif>>#get_process_name(bb)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang dictionary_id='45504.Fişler'>">
								<cfloop list="#process_cat_id_plug_list#" index="cc">
									<option value="#cc#" <cfif attributes.process_cat_id eq cc>selected</cfif>>#get_process_name(cc)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="<cf_get_lang dictionary_id='57456.Üretim'>">
								<cfloop list="#process_cat_id_product_list#" index="dd">
									<option value="#dd#" <cfif attributes.process_cat_id eq dd>selected</cfif>>#get_process_name(dd)#</option>
								</cfloop>
							</optgroup>
							<optgroup label="Sistem">
								<cfloop list="#process_cat_id_system_list#" index="ee">
									<option value="#ee#" <cfif attributes.process_cat_id eq ee>selected</cfif>>#get_process_name(ee)#</option>
								</cfloop>
							</optgroup>
						</select>
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber (this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">	                        
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='input_control()'>
					</div>
					<div class="form-group">
						<a href="javascript://" class="ui-btn ui-btn-gray" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_separated_lot')"><i class="fa fa-print" title="#getLang(176,'Toplu Lot No Yazdır',45353)#"></i></a>
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-invoice_number">
							<label class="col col-12"><cf_get_lang dictionary_id='58133.Fatura No'></label>
							<div class="col col-12">
								<input type="text" name="invoice_number" id="invoice_number" maxlength="50"  value="<cfif isdefined("attributes.invoice_number")>#attributes.invoice_number#</cfif>">
							</div>
						</div>
						<div class="form-group" id="item-company">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12"> 
								<div class="input-group">
									<cfif len(attributes.company_id)>
									<cfset attributes.company = get_par_info(attributes.company_id,1,1,0)>
									<cfelseif len(attributes.consumer_id)>
									<cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
									</cfif>
									<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
									<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
									<input type="text" name="company" id="company" value="#attributes.company#" readonly>
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=list_serial.company&field_comp_id=list_serial.company_id&field_consumer=list_serial.consumer_id&field_member_name=list_serial.company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3&keyword='+encodeURIComponent(document.list_serial.company.value));"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-employee">
							<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">			
									<input type="text" name="employee" id="employee" value="#attributes.employee#" readonly>
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_emps&field_id=list_serial.employee_id&field_name=list_serial.employee&select_list=1');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-date">
							<label class="col col-12">#getLang(330,'Tarih',57742)#</label>
							<div class="col col-12"> 
								<div class="input-group">
									<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
										<cfinput type="text" name="date1" maxlength="10" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" >
										<cfelse>
										<cfinput type="text" name="date1" maxlength="10" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" message="#getLang('','Lütfen Tarih Giriniz',58503)#!">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
									<span class="input-group-addon no-bg"></span>
									<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
										<cfinput type="text" name="date2" maxlength="10" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" >
										<cfelse>
										<cfinput type="text" name="date2" maxlength="10" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" message="#getLang('','Lütfen Tarih Giriniz',58503)#!">
									</cfif> 
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-product_name">
							<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
							<div class="col col-12">
								<div class="input-group">
									<!--- <cf_wrk_products form_name = 'list_serial' product_name='product_name' stock_id='stock_id'> --->
									<input type="hidden" maxlength="50" name="stock_id" id="stock_id" <cfif len("attributes.stock_id") and len(attributes.product_name)>value="#attributes.stock_id#"</cfif>>
									<input type="text" name="product_name" id="product_name" maxlength="50" value="<cfif len(attributes.stock_id) and len(attributes.product_name)>#attributes.product_name#</cfif>" passthrough="readonly=yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_name,stock_id','','3','200');">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&field_id=list_serial.stock_id&field_name=list_serial.product_name&keyword='+encodeURIComponent(document.list_serial.product_name.value));"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-project_head">
							<label class="col col-12"><cf_get_lang dictionary_id ='57416.proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" maxlength="50" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)>#attributes.project_id#</cfif>">
									<input type="text" maxlength="50" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)>#attributes.project_head#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>                  
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(274,'Seri ve Lot İşlemleri',45451)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead> 
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></thd>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th> 
					<th><cf_get_lang dictionary_id='45273.Giriş Depo'></th>
					<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
					<th>1.<cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'> 1</th>
					<th>2.<cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'> 2</th>
					<th><cf_get_lang dictionary_id ='45581.T Giriş'></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-qrcode" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"></i></th><!-- sil -->
					<th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_serial_row_list.recordcount>
				<cfset stock_list = ''>
				<cfset main_stock_list = ''>
				<cfset dept_id_list = ''>
				<cfset main_dept_id_list = ''>
				<cfset project_name_list = "">
				<cfoutput query="get_serial_row_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset stock_list = listappend(stock_list,get_serial_row_list.stock_id,',')>
				<cfif block_type neq 3>
					<cfset dept_= department_in>
					<cfset dept2_= department_out>
				<cfelse>
					<cfset dept_= listfirst(department_in,'-')>
					<cfset dept2_= listfirst(department_out,'-')>
				</cfif>
				<cfif len(dept_) and not listfind(dept_id_list,dept_)>
					<cfset dept_id_list=listappend(dept_id_list,dept_)>
				</cfif>
				<cfif len(dept2_) and  not listfind(dept_id_list,dept2_)>
					<cfset dept_id_list=listappend(dept_id_list,dept2_)>
				</cfif>
				<cfif isdefined('project_id') and len(project_id) and not listfind(project_name_list,project_id)>
					<cfset project_name_list = Listappend(project_name_list,project_id)>
				</cfif>        
				</cfoutput>
					<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
					<cfquery name="GET_STOCK_INFO" datasource="#DSN3#">
						SELECT
							PRODUCT.PRODUCT_NAME,
							PRODUCT.PRODUCT_CODE_2,
							STOCKS.STOCK_CODE,
							STOCKS.BARCOD,
							STOCKS.STOCK_ID,
							PRODUCT.MANUFACT_CODE
						FROM
							PRODUCT,
							STOCKS 
						WHERE 
							STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
							STOCKS.STOCK_ID IN (#stock_list#)
						ORDER BY
							STOCKS.STOCK_ID
					</cfquery>
					<cfset main_stock_list = listsort(listdeleteduplicates(valuelist(get_stock_info.stock_id,',')),'numeric','ASC',',')>
					<cfif listlen(dept_id_list)>
					<cfset dept_id_list = listsort(dept_id_list,"numeric","ASC",",")>
						<cfquery name="GET_DEP_DETAIL" datasource="#DSN#" >
							SELECT
								DEPARTMENT_ID,
								DEPARTMENT_HEAD
							FROM 
								DEPARTMENT
							WHERE
								DEPARTMENT_ID IN (#dept_id_list#)
							ORDER BY
								DEPARTMENT_ID
						</cfquery> 
					<cfset main_dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(project_name_list)>
						<cfquery name="project" datasource="#dsn#">
							SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
						</cfquery>
						<cfset project_name_list = listsort(listdeleteduplicates(valuelist(project.project_id,',')),"numeric","ASC",",")>
					</cfif>     
					<cfoutput query="get_serial_row_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif purchase_sales eq 0>
							<cfswitch expression="#PROCESS_CAT#">
								<cfcase value="761">
									<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_marketplace_ship&ship_id=">
								</cfcase>
								<cfcase value="82">
									<cfset url_param = "#request.self#?fuseaction=invent.add_invent_purchase&event=upd&ship_id=">
								</cfcase>
								<cfcase value="171">
									<cfset url_param = "#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#P_ORDER_ID#&pr_order_id=">
								</cfcase>
								<cfcase value="811">
									<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
								</cfcase>
								<cfcase value="116">
									<cfif stock_exchange_type eq 0>
										<cfset url_param="#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id=">
									<cfelse>
										<cfset url_param="#request.self#?fuseaction=stock.form_add_spec_exchange&event=upd&exchange_id=">
									</cfif>
								</cfcase>
								<cfcase value="1194">
									<cfset url_param = "#request.self#?fuseaction=prod.demands&event=upd&upd=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>
						<cfelseif purchase_sales eq 1>
							<cfswitch expression="#PROCESS_CAT#">
								<cfcase value="81">
									<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=">
								</cfcase>
								<cfcase value="811">
									<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&ship_id=">
								</cfcase>
								<cfcase value="83">
									<cfset url_param = "#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=">
								</cfcase>
								<cfcase value="1193">
									<cfset url_param = "#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>
						<cfelse>
							<cfswitch expression="#PROCESS_CAT#">
								<cfcase value="114">
									<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_ship_open_fis&event=upd&upd_id=">
								</cfcase>
								<cfcase value="118">
									<cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=">
								</cfcase>
								<cfcase value="116">
									<cfif stock_exchange_type eq 0>
										<cfset url_param="#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id=">
									<cfelse>
										<cfset url_param="#request.self#?fuseaction=stock.form_add_spec_exchange&event=upd&exchange_id=">
									</cfif>
								</cfcase>
								<cfdefaultcase>
									<cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=">
								</cfdefaultcase>
							</cfswitch>
						</cfif>
					<tr>
						<td>#currentrow#</td>
						<cfset attributes.stock_id = stock_id>
						<cfif isdefined("process_cat")>
							<cfset attributes.process_cat = process_cat>
						<cfelse>
							<cfset attributes.process_cat = 0>
						</cfif>
						<cfset attributes.process_id = process_id>
						<td>#get_process_name(attributes.process_cat)#</td>
						<td>
							<cfif PROCESS_CAT neq 1190>
								<a href="#url_param##process_id#"class="tableyazi">#process_number#</a>
							<cfelse>
								#process_number#
							</cfif>
						</td>
						<td>#dateformat(process_date,dateformat_style)#</td>
						<td>#get_stock_info.stock_code[listfind(main_stock_list,stock_id,',')]#</td>
						<td>#get_stock_info.barcod[listfind(main_stock_list,stock_id,',')]#</td>
						<td>#get_stock_info.PRODUCT_CODE_2[listfind(main_stock_list,stock_id,',')]#</td>
						<td>#get_stock_info.product_name[listfind(main_stock_list,stock_id,',')]#</td>
						<td><cfif isdefined("get_serial_row_list.project_id") and len(get_serial_row_list.project_id)> 
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#project.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#project.project_head[listfind(project_name_list,project_id,',')]#</a></td>
							<cfelse>
								<cf_get_lang dictionary_id='58459.projesiz'>
							</cfif>
						</td> 
						<td>
						<cfif len(department_in)>#get_dep_detail.department_head[listfind(main_dept_id_list,listfirst(department_in,'-'),',')]#</cfif>
						</td>
						<td>
						<cfif len(department_out)>
							<cfif block_type neq 3>
								#get_dep_detail.department_head[listfind(main_dept_id_list,department_out,',')]#
							<cfelse>
								#get_dep_detail.department_head[listfind(main_dept_id_list,listfirst(department_out,'-'),',')]#
							</cfif>
						</cfif>	
						</td>
						<cfset attributes.spect_id = spect_id>
						<td align="center"><cfif isdefined("unit")>#unit#</cfif></td>
						<td align="center">
							#quantity#
							<cfquery name="get_this_product_all_quantity" dbtype="query">
								SELECT 
									SUM(QUANTITY) AS TOTAL_PRODUCT 
								FROM 
									get_serial_row_list 
								WHERE 
									STOCK_ID = #stock_id# AND
									PRODUCT_ID = #product_id# AND
									<cfif attributes.process_cat_id eq 1190>
									PROCESS_NUMBER = '#PROCESS_NUMBER#' AND
									<cfelse>
									PROCESS_ID = #process_id# AND
									</cfif>
									PROCESS_CAT = #attributes.process_cat#
									<cfif len(attributes.spect_id)>AND SPECT_ID = #attributes.spect_id#</cfif>
							</cfquery>
							<cfif get_this_product_all_quantity.recordcount and len(get_this_product_all_quantity.TOTAL_PRODUCT)>
								<cfset total_ = get_this_product_all_quantity.TOTAL_PRODUCT>
							<cfelse>
								<cfset total_ = 0>
							</cfif>
							<cfif total_ gt quantity>(#total_#)</cfif>
						</td>
						<td><cfif isdefined("unit2")>#unit2#</cfif></td>
						<td><cfif isdefined("QUANTITY2")>#QUANTITY2#</cfif></td>
						<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
							SELECT
								SG.LOT_NO,
								SG.SERIAL_NO
							FROM
								SERVICE_GUARANTY_NEW AS SG
							WHERE
								STOCK_ID = #attributes.STOCK_ID# AND
								<cfif attributes.process_cat_id eq 1190>
									PROCESS_NO = '#PROCESS_NUMBER#' AND
								<cfelse>
									PROCESS_ID = #attributes.process_id# AND
								</cfif>
								PROCESS_CAT = #attributes.process_cat#
								<cfif not listfind('171,1193,1194',attributes.process_cat)>
									AND SG.PERIOD_ID = #session.ep.period_id#
								</cfif>
								<cfif attributes.process_cat_id eq 116>
									AND SG.IN_OUT = 1
								</cfif>
								<cfif len(attributes.spect_id)>AND SG.SPECT_ID = #attributes.spect_id#</cfif>
								<cfif not isdefined("attributes.main_stock_id") or not len(attributes.main_stock_id)>
								AND SG.MAIN_STOCK_ID IS NULL
								<cfelse>
								AND SG.MAIN_STOCK_ID=#attributes.main_stock_id#
								</cfif>
								AND SG.WRK_ROW_ID = '#get_serial_row_list.WRK_ROW_ID#'
							<cfif listfind("81,811,113",process_cat )>
								GROUP BY SERIAL_NO,LOT_NO
							</cfif>
						</cfquery>
						<cfset deger = get_serial_info.recordcount>
						<cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
						<cfset amount_invoice = deger>
						</cfif>
						<td align="center">#deger#</td>
						<!-- sil -->
						<td width="20">
							<a href="#request.self#?fuseaction=stock.list_serial_operations&event=det<cfif isdefined("QUANTITY2")>&product_amount_2=#QUANTITY2#</cfif>&product_amount=#quantity#&recorded_count=<cfif quantity gte deger>#deger#<cfelse>#quantity#</cfif>&is_delivered=#is_delivered#&product_id=#get_serial_row_list.product_id#&stock_id=#get_serial_row_list.stock_id#&process_number=#URLEncodedFormat(process_number)#&process_date=#dateformat(process_date,dateformat_style)#&process_cat=#attributes.process_cat#&process_id=#process_id#&sale_product=#purchase_sales#&company_id=#company_id#&con_id=#consumer_id#&location_out=#location_out#&department_out=#department_out#&location_in=#location_in#&department_in=#department_in#&is_serial_no=1&guaranty_cat=&guaranty_startdate=&wrk_row_id=#get_serial_row_list.wrk_row_id#&lot_no=#get_serial_row_list.lot_no#&spect_id=<cfif len(get_serial_row_list.spect_id)>#get_serial_row_list.spect_id#</cfif><cfif session.ep.isBranchAuthorization>&is_store=1</cfif><cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>&amount_invoice=<cfif quantity gte deger>#deger#<cfelse>#quantity#</cfif></cfif>">
								<i class="fa fa-qrcode" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"></i>
							</a>
						</td>
						<td width="20" align="center"><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#process_cat#&action_id=#process_id#&action_row_id=#stock_id#&print_type=192','print_page');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
						<!-- sil -->
					</tr>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="18"><cfif isdefined("attributes.is_filtre")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations#adres#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('serial_no').focus();
function input_control()
{
	if((list_serial.process_cat_id.value.length == 0) && (list_serial.invoice_number.value.length == 0))
	{
		alert("<cf_get_lang dictionary_id='45500.İşlem Tipi Seçmeli veya Fatura No Girmelisiniz'>!");
		return false;
	}
		
	if((list_serial.serial_no.value.length == 0) && (list_serial.lot_no.value.length == 0) && 
		(list_serial.belge_no.value.length == 0) && (list_serial.date1.value.length == 0) && (list_serial.date2.value.length == 0) &&
		(list_serial.company.value.length == 0 || list_serial.company_id.value.length == 0) &&
		(list_serial.employee.value.length == 0 || list_serial.employee_id.value.length == 0) && (list_serial.process_cat_id.value.length == 0)) 
	{
	   alert ("<cf_get_lang dictionary_id='45499.En Az Bir Alanda Filtre Etmelisiniz'> !"); 
	   return false;
	}
	else
		return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
