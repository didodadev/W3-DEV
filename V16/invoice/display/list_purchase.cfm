<cf_xml_page_edit fuseact="invoice.list_purchase">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_type" default="2">
<cfparam name="attributes.free_type" default="#x_show_free#">
<cfparam name="attributes.department_id" default="#listgetat(session.ep.user_location,1,'-')#">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
	<cfelse>
		<cfif session.ep.our_company_info.unconditional_list>
			<cfset attributes.start_date = ''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-15,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
	<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date = ''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',15,attributes.start_date)>
	</cfif>
</cfif>
<cfset attributes.xml_is_salaried = xml_is_salaried>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROCESS" datasource="#DSN#"><!--- alıs irsaliye,satış irsaliye asamalari --->
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		(	
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.list_purchase%"> OR
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.form_add_purchase%"> OR
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.form_add_sale%">
		)
	ORDER BY
		PT.PROCESS_NAME,
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_varmi")>
	<cfinclude template="../query/get_purchases.cfm"> 
<cfelse>
	<cfset purchases.recordcount = 0>
</cfif>
<cfif isdefined("x_consignment_delivery") and x_consignment_delivery eq 0>
	<cfset islem_tipi = '76,78,77,80,70,71,72,73,74,88,140,141'><!--- konsinye iade irsaliyeleri görünsün seçeneği hayır ise --->
<cfelse>
	<cfset islem_tipi = '76,78,77,79,80,70,71,72,73,74,75,88,140,141'>
</cfif>
<cfif session.ep.our_company_info.guaranty_followup>
	<cfset islem_tipi = islem_tipi&',85,86'>
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT CC.COMPANYCAT_ID,CC.COMPANYCAT FROM COMPANY_CAT CC,COMPANY_CAT_OUR_COMPANY CCOC WHERE CC.COMPANYCAT_ID = CCOC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID = #session.ep.company_id# ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CC.CONSCAT_ID,CC.CONSCAT FROM CONSUMER_CAT CC,CONSUMER_CAT_OUR_COMPANY CCOC WHERE CC.CONSCAT_ID = CCOC.CONSCAT_ID AND CCOC.OUR_COMPANY_ID = #session.ep.company_id# ORDER BY CONSCAT
</cfquery>
	<cfif purchases.recordcount>
		<cfparam name="attributes.totalrecords" default="#purchases.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=invoice.list_purchase">
			<cf_box_search> 
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="member_cat_type" id="member_cat_type" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id="57025.Uye Kategorileri"></option>
						<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
							<cfoutput query="get_company_cat">
							<option value="1-#companycat_id#" <cfif listfind(attributes.member_cat_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
							</cfoutput>
						</optgroup>
						<optgroup label="<cf_get_lang dictionary_id ='58040.Bireysel Üye Kategorileri'>">
							<cfoutput query="get_consumer_cat">
							<option value="2-#conscat_id#" <cfif listfind(attributes.member_cat_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;#conscat#</option>
							</cfoutput>
						</optgroup>
					</select>
				</div>			
				<div class="form-group">
					<select name="order_type" id="order_type" style="width:100px;">
						<option value="" <cfif not len(attributes.order_type)> selected</cfif>><cf_get_lang dictionary_id='57129.Emir Durumu'></option>
						<option value="1" <cfif attributes.order_type eq 1> selected</cfif>><cf_get_lang dictionary_id='57229.Kesilmiş'></option>
						<option value="2" <cfif attributes.order_type eq 2> selected</cfif>><cf_get_lang dictionary_id='57099.Kesilmemiş'></option>										
					</select>
				</div>
				<div class="form-group">
					<select name="free_type" id="free_type" style="width:100px;">
						<option value="" <cfif not len(attributes.free_type)> selected</cfif>><cf_get_lang dictionary_id='57123.Emir'> <cf_get_lang dictionary_id='58651.Türü'></option>
						<option value="1" <cfif attributes.free_type eq 1> selected</cfif>><cf_get_lang dictionary_id='57395.Bedelli'></option>
						<option value="2" <cfif attributes.free_type eq 2> selected</cfif>><cf_get_lang dictionary_id='29399.Bedelsiz'></option>										
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" maxlength="3" range="1,250">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_type">
						<label class="col col-12"><cf_get_lang dictionary_id='29430.İrsaliye Tipi'></label>
						<div class="col col-12">
							<input name="form_varmi" id="form_varmi" value="1" type="hidden">
							<select name="cat" id="cat">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_process_cat" group="process_type">
								<option value="#process_type#" <cfif '#process_type#' is attributes.cat>selected</cfif>>#get_process_name(process_type)#</option>										
								<cfoutput>
									<option value="#process_type#-#process_cat_id#" <cfif attributes.cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
								</cfoutput>
								</cfoutput>
								<option value="0"<cfif attributes.cat eq 0> Selected</cfif>><cf_get_lang dictionary_id='57272.İrsaliyesiz Siparişler'></option>
							</select>
						</div>
					</div>
					<cfif xml_show_process_stage eq 1>
						<div class="form-group" id="item-process_stage">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-12 col-xs-12">
								<select name="process_stage" id="process_stage">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_process" group="process_id">
										<optgroup label="#process_name#"></optgroup>
										<cfoutput>
										<option value="#get_process.process_row_id#" <cfif Len(attributes.process_stage) and attributes.process_stage eq get_process.process_row_id>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_process.stage#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-department_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
						<div class="col col-12">
							<cfinclude template="../query/get_stores.cfm">
							<select name="department_id" id="department_id" style="width:150px;">
								<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="stores">
								<option value="#department_id#" <cfif attributes.department_id eq department_id> Selected</cfif>>#department_head#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
					<cfif x_zone_list eq 1>
						<div class="form-group" id="item-zone_id">
							<label class="col col-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
							<div class="col col-12">
								<cf_wrk_Zones fieldId='zone_id' selected_value='#attributes.zone_id#' width="100">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
								<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input name="company" type="text" id="company" style="width:135px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
								<input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat_code) and len(attributes.category_name)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
								<input name="category_name" type="text" id="category_name" style="width:100px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form.cat_id&field_code=form.product_cat_code&field_name=form.category_name</cfoutput>');"></span>
							</div>
						</div>
					</div> 	
				</div>
				<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-date">
						<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="eurodate" maxlength="10">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfif session.ep.our_company_info.unconditional_list>
									<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="eurodate" maxlength="10">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>                
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
								<input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>"  onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="show_cat();"></span>
							</div>
						</div>
					</div>
					
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57528.Fatura Kesim Emirleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58784.Referans'></th>
					<th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
					<cfif x_show_detail eq 1><th><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
					<cfif xml_serial_info eq 1><th><cf_get_lang dictionary_id='29412.Seri'></th></cfif>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<cfif xml_show_process_stage eq 1>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					</cfif>
					<th width="20"><cfif attributes.order_type neq 1><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='57273.Faturala'>"></i></cfif></th>
				</tr>
			</thead>
			<tbody>
				<cfif purchases.recordcount>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfset dept_id_list=''>
					<cfset process_cat_id_list=''>
					<cfset serial_process_id_list=''>
					<cfset row_process_id_list=''>
					<cfoutput query="purchases" >
						<cfif listfindnocase('70,71,72,83',ACTION_TYPE)>
							<cfset serial_process_id_list=listappend(serial_process_id_list,action_id)>
							<cfset row_process_id_list=listappend(row_process_id_list,action_id)>
						</cfif>
						<cfif len(company_id)>
							<cfif not listfind(company_id_list,company_id)>
								<cfset company_id_list=listappend(company_id_list,company_id)>
							</cfif>
						<cfelseif len(consumer_id)>
							<cfif not listfind(consumer_id_list,consumer_id)>
								<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
							</cfif>
						</cfif>
						<cfif len(purchases.department_in) and not listfind(dept_id_list,purchases.department_in)>
							<cfset dept_id_list=listappend(dept_id_list,purchases.department_in)>
						</cfif>
						<cfif len(purchases.deliver_store_id) and not listfind(dept_id_list,purchases.deliver_store_id)>
							<cfset dept_id_list=listappend(dept_id_list,purchases.deliver_store_id)>
						</cfif>
						<!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
						<cfif x_show_process_cat eq 1>
							<cfif len(purchases.process_cat) and (purchases.process_cat neq 0) and not listfind(process_cat_id_list,purchases.process_cat)>
								<cfset process_cat_id_list=listappend(process_cat_id_list,purchases.process_cat)>
							</cfif>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="GET_COMPANY" datasource="#DSN#">
							SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(dept_id_list)>
						<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
						<cfquery name="GET_DEPT_NAME" datasource="#DSN#">
							SELECT 
								DEPARTMENT_HEAD 
								FROM 
								DEPARTMENT
							WHERE 
								DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#dept_id_list#">) 
							ORDER BY	
								DEPARTMENT_ID
						</cfquery>
					</cfif>
					<!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
					<cfif len(process_cat_id_list) and x_show_process_cat eq 1>					
						<cfquery name="GET_PROCESS_CAT_ROW" dbtype="query">
							SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#process_cat_id_list#">) ORDER BY	PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(row_process_id_list)>
						<cfquery name="get_row_info" datasource="#dsn2#">
							SELECT 
								SUM(SHIP_ROW.AMOUNT) AS ROW_COUNT,
								SHIP_ID
							FROM 
								SHIP_ROW,
								#dsn3_alias#.STOCKS STOCKS
							WHERE 
								SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND 
								SHIP_ROW.SHIP_ID IN (#row_process_id_list#) AND 
								STOCKS.IS_SERIAL_NO = 1
							GROUP BY
								SHIP_ROW.SHIP_ID
						</cfquery>
						<cfset row_process_id_list = listsort(listdeleteduplicates(valuelist(get_row_info.SHIP_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(serial_process_id_list)>
						<cfquery name="get_serial_info" datasource="#dsn3#">
							SELECT 
								COUNT(GUARANTY_ID) AS ROW_COUNT,
								PROCESS_ID
							FROM 
								SERVICE_GUARANTY_NEW 
							WHERE 
								PROCESS_ID IN (#serial_process_id_list#)
								AND PERIOD_ID = #session.ep.period_id#
								AND PROCESS_CAT IN (70,71,72,83)
							GROUP BY
								PROCESS_ID
						</cfquery>
						<cfset serial_process_id_list = listsort(listdeleteduplicates(valuelist(get_serial_info.PROCESS_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfset sum_price = 0>
					<cfoutput query="purchases" >
						<tr>
							<td>#currentrow#</td>
						<td>#dateformat(action_date,dateformat_style)#</td>
						<td>
							<cfif purchase_sales eq 0 and attributes.cat neq 0>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="761">
									<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
								</cfcase>
								<cfcase value="82">
									<cfset url_param = "#request.self#?fuseaction=invent.add_invent_purchase&event=upd&&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>
						<cfelseif purchase_sales eq 1 and attributes.cat neq 0>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="81">
									<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
								</cfcase>
								<cfcase value="811">
									<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
								</cfcase>
								<cfcase value="83">
									<cfset url_param = "#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>				
						<cfelseif attributes.cat neq 0>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="114">
									<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
								</cfcase>
								<cfcase value="118">
									<cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=">
								</cfcase>
								<cfcase value="1182">
									<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
								</cfcase>
								<cfcase value="116">
									<cfif stock_exchange_type eq 0>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
									<cfelse>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_spec_exchange&exchange_id=">
									</cfif>
								</cfcase>
								<cfdefaultcase>
									<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
								</cfdefaultcase>
							</cfswitch>
							<cfelse>
								<cfset url_param="#request.self#?fuseaction=stock.list_command&event=det&order_id=">
						</cfif>
						<a href="#url_param##action_id#"class="tableyazi">#action_number#</a>
						</td>
						<td><cfif action_type eq 0>#order_head#<cfelse>#get_process_name(action_type)#</cfif>
							<cfif x_show_process_cat eq 1 and len(process_cat_id_list) and len(purchases.process_cat)>
								- #get_process_cat_row.process_cat[listfind(process_cat_id_list,purchases.process_cat,',')]#
							</cfif>
						</td>
						<cfif x_show_detail eq 1><td>#ship_detail#</td></cfif>
						<cfif xml_serial_info eq 1><td>
							<cfif listfindnocase('70,71,72,83',action_type)>
								<cfif listfindnocase(row_process_id_list,action_id) and not listfindnocase(serial_process_id_list,action_id)>
									Seri No Eksik!
								<cfelseif listfindnocase(row_process_id_list,action_id) and listfindnocase(serial_process_id_list,action_id)>
									<cfif get_row_info.ROW_COUNT[listfind(row_process_id_list,action_id)] gt get_serial_info.ROW_COUNT[listfind(serial_process_id_list,action_id)]>
										Seri No Eksik!	
									<cfelse>
										Seri No Tamam!
									</cfif>
								<cfelse>
									-
								</cfif>
							<cfelse>
								-
							</cfif></td></cfif>
						<td><cfif len(company_id) and company_id neq 0>
								#get_company.nickname[listfind(company_id_list,purchases.company_id,',')]#
							<cfelseif len(consumer_id)>
								#get_consumer.consumer_name[listfind(consumer_id_list,purchases.consumer_id,',')]# &nbsp; #get_consumer.consumer_surname[listfind(consumer_id_list,purchases.consumer_id,',')]#
							<cfelseif len(employee_id)>
								#get_emp_info(employee_id,0,0)#
							</cfif>
						</td>
						<td>
							<cfif len(purchases.department_in)>
								#get_dept_name.department_head[listfind(dept_id_list,purchases.department_in,',')]#
							<cfelseif len(purchases.deliver_store_id)>
								#get_dept_name.department_head[listfind(dept_id_list,purchases.deliver_store_id,',')]#
							</cfif>	
						</td>
						<td class="moneybox">#TLFormat(nettotal)# #session.ep.money#</td>
						<cfset sum_price = sum_price + nettotal>
						<td><cfif len(purchases.invoice_id) and purchases.invoice_id gt 0>#purchases.invoice_number#<cfelse><cf_get_lang dictionary_id='57099.Kesilmemiş'></cfif></td>
						<!-- sil -->
						<cfif xml_show_process_stage eq 1>
							<td>#STAGE#</td>
						  </cfif>
						<td width="20">
							<cfif attributes.order_type neq 1>
								<cfif action_type eq 0>
								<!--- siparisten fatura ekleme linkleri --->
									<cfif purchase_sales eq 0>
										<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&order_id=#action_id#"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='57273.Faturala'>"></i></a>
									<cfelse>
										<a href="#request.self#?fuseaction=invoice.form_add_bill&order_id=#action_id#"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='57273.Faturala'>"/></i></a>
									</cfif>
								<cfelse>
									<cfif purchase_sales eq 1>
										<cfset str_include_2 = "#request.self#?fuseaction=invoice.form_add_bill&ship_id=#action_id#">
									<cfelse>
										<cfset str_include_2 = "#request.self#?fuseaction=invoice.form_add_bill_purchase&ship_id=#action_id#">
									</cfif>
									<a href="#str_include_2#"  onClick="<cfif datediff('d',action_date,now()) gt 7>alert('<cf_get_lang dictionary_id='57393.7 Günden Daha Fazla İrsaliye Tarihi Var'>!');</cfif>"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='57273.Faturala'>"></i></a>
								</cfif>
							</cfif>
						</td><!-- sil -->
						</tr>
					</cfoutput>
					<cfif purchases.recordcount gt 1>
					<tfoot>
						<tr>
							<td colspan="5">&nbsp;</td>
							<td class="bold" align="center"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
							<td class="bold moneybox"><cfoutput>#tlformat(sum_price)# #session.ep.money#</cfoutput></td>
							<!-- sil --><td colspan="3"></td><!-- sil -->
						</tr>
					</tfoot>	
					</cfif>
				<cfelse>
					<tr>
						<td colspan="11"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>        
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "invoice.list_purchase&form_varmi=1&department_id=#department_id#&order_type=#order_type#">
			<cfif isdate(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.company_id)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.consumer_id)>
				<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.cat)>
				<cfset adres = "#adres#&cat=#cat#">
			</cfif>	
			<cfif len(attributes.cat_id)>
				<cfset adres = "#adres#&cat_id=#attributes.cat_id#">
			</cfif>
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				<cfset adres = "#adres#&process_stage=#attributes.process_stage#">
			</cfif>
			<cfif len(attributes.product_id)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#">
			</cfif>
			<cfif len(attributes.member_cat_type)>
				<cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
			</cfif>
			<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
				<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
			</cfif>
			<cfif len(attributes.free_type)>
				<cfset adres = "#adres#&free_type=#attributes.free_type#">
			</cfif>
			<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function show_cat() {
		if (document.getElementById('product_cat_code').value!="" || (document.getElementById('category_name').value!="" ))
        {    
            var product_cat_code_ = document.getElementById('product_cat_code').value;
			var category_name_ = document.getElementById('category_name').value;
            str_irslink = '&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&form_submitted=1&product_cat_code='+product_cat_code_ + '&product_cat='+category_name_; 
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names' + str_irslink , 'list');
            return true;
        }
        else
        {
            str_irslink = '&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>'; 
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names' + str_irslink , 'list');
            return true;
        }
	}
	<!--- <cfif isDefined("attributes.is_post") and attributes.is_post eq 1>
		$("#form").submit();
	</cfif> --->
	function kontrol(){
		
		if(!$("#maxrows").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'> !</cfoutput>"}) 
			return false;
		}
	}
	document.getElementById('keyword').focus();
</script>
