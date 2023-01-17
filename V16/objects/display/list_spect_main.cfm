<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="objects.popup_list_spect_main">
<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and isdefined("session_base") and isdefined("session_base.company_id") and listfind(fusebox.spect_company_list,session_base.company_id)>
	<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfset new_dsn3_alias = "#dsn#_#fusebox.use_spect_company#">
<cfelseif isdefined("dsn3")>
	<cfset new_dsn3 = dsn3>
	<cfset new_dsn3_alias = dsn3_alias>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT * FROM STOCKS_LOCATION WHERE STATUS = 1
</cfquery>
<!--- spec ekleme veya gonder_invoce fonksiyonlarını çalıştıracaksanız stok_id mutlaka gelmeli ama sadece main_spec_list olarak çalışacak ve aşağı spec_id ve isim atacaksa ozaman product_id ilede çalışabilir--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.spect_status" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date="">
</cfif>
<cfif isdefined('attributes.process_date') and len(attributes.process_date)>
	<cf_date tarih="attributes.process_date">
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT RATE1,RATE2,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id# AND MONEY_STATUS = 1 AND COMPANY_ID = <cfif isdefined('session.ep')>#SESSION.EP.COMPANY_ID#<cfelseif isdefined('session.pp')>#session.pp.our_company_id#</cfif>
</cfquery>
<cfscript> 
	wrkUrlStrings('url_str','p_order_row_id','product_id','is_demontaj','process_date','SPECT_CHANGE','PR_ORDER_ID','P_ORDER_ID','last_spect','function_name','main_to_add_spect','field_main_id','field_id','field_var_id','field_name','insert_spec','stock_id','BASKET_ID','COMPANY_ID','CONSUMER_ID','MAIN_STOCK_AMOUNT','PAPER_DEPARTMENT','PAPER_LOCATION','ROW_ID','SEARCH_PROCESS_DATE','create_main_spect_and_add_new_spect_id','sepet_process_type','money_','price_catid','price');
</cfscript>
<cfloop query="GET_MONEY">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfparam name="attributes.select_spect_type" default="1">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif not isdefined('attributes.department_id')>
		<cfquery name="GET_SPECT_VAR" datasource="#new_dsn3#">
			SELECT
				SPECT_MAIN_ID,
				SPECT_MAIN_NAME,
				SPECT_TYPE,
				RECORD_EMP,
                RECORD_PAR,
                RECORD_CON,
				RECORD_DATE,
				(SELECT TOP 1 SP.SPECT_VAR_ID FROM SPECTS SP WHERE SP.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID ORDER BY SP.RECORD_DATE) SPECT_VAR_ID
			FROM
				SPECT_MAIN
			WHERE
			1=1
			<cfif len(attributes.keyword)>
				AND (SPECT_MAIN_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'<cfif isnumeric(attributes.keyword)>OR SPECT_MAIN_ID = #attributes.keyword#</cfif>)
			</cfif>
			<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) >AND STOCK_ID=#attributes.stock_id#</cfif>
			<cfif isdefined('attributes.product_id') and len(attributes.product_id) >AND STOCK_ID IN(SELECT SS.STOCK_ID FROM STOCKS SS WHERE SS.PRODUCT_ID=#attributes.product_id#)</cfif>
			<cfif not len(attributes.spect_status) or attributes.spect_status eq 1>AND SPECT_STATUS = 1<cfelseif attributes.spect_status EQ 0>AND SPECT_STATUS = 0</cfif>
			<cfif len(attributes.start_date)>
				AND SPECT_MAIN.RECORD_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND SPECT_MAIN.RECORD_DATE <= #attributes.finish_date#
			</cfif>
			ORDER BY 
				RECORD_DATE	DESC
		</cfquery>
	<cfelse>
		<cfquery name="GET_SPECT_VAR" datasource="#DSN#">
			SELECT
				SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME,
				SPECT_MAIN.SPECT_TYPE,
				SPECT_MAIN.RECORD_EMP,
                SPECT_MAIN.RECORD_PAR,
                SPECT_MAIN.RECORD_CON,
				SPECT_MAIN.RECORD_DATE,
				SUM(STOCKS_ROW.STOCK_IN-STOCKS_ROW.STOCK_OUT) PRODUCT_STOCK,
				(SELECT TOP 1 SP.SPECT_VAR_ID FROM #new_dsn3_alias#.SPECTS SP WHERE SP.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID ORDER BY SP.RECORD_DATE) SPECT_VAR_ID
			FROM
				#new_dsn3_alias#.SPECT_MAIN SPECT_MAIN,
				#dsn2_alias#.STOCKS_ROW
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID=STOCKS_ROW.SPECT_VAR_ID
			<cfif isdefined('attributes.department_id')>
				<cfif listlen(attributes.department_id,'-') eq 1>
					AND STOCKS_ROW.STORE = #attributes.department_id#
				</cfif>
				<cfif listlen(attributes.department_id,'-') eq 2>
					AND STOCKS_ROW.STORE = #ListFirst(attributes.department_id,'-')#
					AND STOCKS_ROW.STORE_LOCATION =#ListLast(attributes.department_id,'-')#
				</cfif>
			</cfif>  
			<cfif len(attributes.keyword)>
				AND SPECT_MAIN_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
			</cfif>
			<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) >AND SPECT_MAIN.STOCK_ID=#attributes.stock_id#</cfif>
			<cfif isdefined('attributes.product_id') and len(attributes.product_id) >AND SPECT_MAIN.STOCK_ID IN(SELECT SS.STOCK_ID FROM STOCKS SS WHERE SS.PRODUCT_ID=#attributes.product_id#)</cfif>
			<cfif not len(attributes.spect_status) or attributes.spect_status eq 1>AND SPECT_STATUS = 1<cfelseif attributes.spect_status EQ 0>AND SPECT_MAIN.SPECT_STATUS = 0</cfif>
			<cfif isdefined('attributes.process_date') and len(attributes.process_date)>AND PROCESS_DATE <= #attributes.process_date#</cfif><!--- stok miktarı alınacak tarih --->
			<cfif len(attributes.start_date)>
				AND SPECT_MAIN.RECORD_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND SPECT_MAIN.RECORD_DATE <= #attributes.finish_date#
			</cfif>
			GROUP BY
				SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME,
				SPECT_MAIN.SPECT_TYPE,
				SPECT_MAIN.RECORD_EMP,
                SPECT_MAIN.RECORD_PAR,
                SPECT_MAIN.RECORD_CON,
				SPECT_MAIN.RECORD_DATE
			HAVING SUM(STOCKS_ROW.STOCK_IN-STOCKS_ROW.STOCK_OUT) > 0 <!--- eksi stok gelmesin --->
			ORDER BY 
				RECORD_DATE	DESC
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_spect_var.recordcount=0>
</cfif>
<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfinclude template="../../stock/query/get_stores.cfm">
<cfelse>
	<cfset get_spect_var.recordcount=0>
</cfif>
<cfparam name="attributes.maxrows" default="#session_base.maxrows#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_spect_var.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Spekt',57647)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_search_spect_main" action="#request.self#?fuseaction=#attributes.fuseaction##url_str#" method="post">
		<cf_box_search>
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>
			<div class="form-group" id="item-select_spect_type">
				<cfset spect_type__ = url_str>
				<select name="select_spect_type" id="select_spect_type" onChange="go_page(this.value)">
					<option value=""><cf_get_lang dictionary_id='34004.Spec Tipi'></option>
					<option value="0" <cfif attributes.select_spect_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57647.Spec'></option>
					<option value="1" <cfif attributes.select_spect_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='34006.Main Spect'></option>
				</select>
			</div>	
			<cfif not isdefined('session.pp')>
				<div class="form-group" id="item-price_change">	
					<label><input type="checkbox" name="price_change" id="price_change" value="1"<cfif isdefined('attributes.price_change') and attributes.price_change eq 1>checked</cfif>><cf_get_lang dictionary_id ='33935.Fiyat Güncelle'></label> 
				</div>
			</cfif>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_search_spect_main' , #attributes.modal_id#)"),DE(""))#">
				<!--- <cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>  --->
			</div>
		</cf_box_search>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_search_spect_main' , #attributes.modal_id#)"),DE(""))#">
			<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-spect_status">
				<label><cf_get_lang dictionary_id="57756.Durum"></label>
				<select name="spect_status" id="spect_status">
					<option value="1"<cfif isDefined("attributes.spect_status") and (attributes.spect_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0"<cfif isDefined("attributes.spect_status") and (attributes.spect_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					<option value="2"<cfif isDefined("attributes.spect_status") and (attributes.spect_status eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
				</select>
			</div>
			<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-start_date">
				<label><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></label>
				<div class="input-group">
					<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#"validate="#validate_style#" maxlength="10" message="#getLang('','Başlama Tarihi Girmelisiniz',34005)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
				</div>
			</div>	
			<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12" id="item-finish_date">
				<label><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></label>
				<div class="input-group">
					<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#"validate="#validate_style#" maxlength="10" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>
			<cfif isdefined('attributes.department_id')>
				<div class="form-group" id="item-department_id">
					<cfinclude template="../../stock/query/get_stores.cfm">
					<select name="department_id" id="department_id">
						<option value=""><cf_get_lang dictionary_id='33775.Tüm Depolar'></option>
						<cfoutput query="stores">
							<option value="#department_id#"<cfif isdefined('attributes.department_id') and attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
							<cfquery name="GET_LOCATION" dbtype="query">
								SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #stores.department_id[currentrow]#
							</cfquery>		 
							<cfif get_location.recordcount>
								<cfloop from="1" to="#get_location.recordcount#" index="s">
									<option value="#department_id#-#get_location.location_id[s]#" <cfif isdefined('attributes.department_id') and attributes.department_id eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>#get_location.comment[s]#</option>
								</cfloop>
							</cfif>
						</cfoutput>
					</select>
				</div>
			</cfif>
		</cf_box_search_detail>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id ='33091.Spect ID'></th>
				<th><cf_get_lang dictionary_id ='58233.Tanım'></th>
				<cfif isdefined('attributes.department_id')><th><cf_get_lang dictionary_id ='33936.Stok Miktar'></th></cfif>
				<cfif not isdefined('session.pp')>
					<th width="110"><cf_get_lang dictionary_id ='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<!-- sil -->
					<th width="20">
						<cfif not isdefined("attributes.is_from_prod_order")>
							<cfset is_from_prod_order = 0>
						<cfelse>
							<cfset is_from_prod_order = 1>
						</cfif>
						<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
							<a href="<cfoutput>#request.self#?fuseaction=objects.popup_add_spect_list#url_str#&is_from_prod_order=#is_from_prod_order#<cfif isdefined("attributes.add_main_spect")>&add_main_spect=1</cfif></cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='32446.Spec Ekle'>"></i></a>
						<cfelse>
							<a href="javascript://"><i class="fa fa-pencil"></i></a>
						</cfif>
					</th>
				</cfif>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_spect_var.recordcount and form_varmi eq 1>
				<cfoutput query="get_spect_var" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<tr>
						<td>#SPECT_MAIN_ID#</td>
						<td>#SPECT_VAR_ID#</td>
						<cfset my_spect_name = replace(SPECT_MAIN_NAME,"'","","all")>
						<cfset my_spect_name = replace(my_spect_name,'"','','all')>
						<cfset my_spect_name = replace(my_spect_name,'#chr(13)#','','all')>
						<cfset my_spect_name = replace(my_spect_name,'#chr(10)#','','all')>
						<cfif isdefined('attributes.field_id') and isdefined('attributes.create_main_spect_and_add_new_spect_id') or isdefined("attributes.last_spect")><!--- create_main_spect_and_add_new_spect_id => Eğer üretim emrinde main spect seçiliyorsa seçilen main spect'e ait bir spect ekleniyor ve eklenen spect'in id'si üretim emrine gönderiliyor. --->
							<td>
							<!---	<cfif not len(SPECT_VAR_ID)>--->
									<a href="##" onClick="spect_ekle('#SPECT_MAIN_ID#','#SPECT_TYPE#');">#my_spect_name#</a>
							<!---    <cfelse>
									<a href="##" onClick="gonder('#SPECT_MAIN_ID#','#SPECT_VAR_ID#','#my_spect_name#','#SPECT_TYPE#');">#my_spect_name#</a>
								</cfif>--->
							</td>
						<cfelseif isdefined('attributes.BASKET_ID') and isdefined('attributes.MAIN_STOCK_AMOUNT')><!--- fatura yada siparişten geliyorsa --->
							<td><a href="##" onClick="gonder_invoice('#SPECT_MAIN_ID#','#my_spect_name#');">#my_spect_name#</a></td>
						<cfelse>
							<td><a href="##" onClick="gonder('#SPECT_MAIN_ID#','#SPECT_VAR_ID#','#my_spect_name#','#SPECT_TYPE#');">#my_spect_name#</a></td>
						</cfif>
						<cfif isdefined('attributes.department_id')><td class="text-right">#PRODUCT_STOCK#</td></cfif>
						<cfif not isdefined('session.pp')>
							<td>
								<cfif len(RECORD_EMP)>
									#get_emp_info(RECORD_EMP,0,0)#
								<cfelseif len(RECORD_PAR)>
									#get_par_info(RECORD_PAR,0,0,0)#
								<cfelseif len(consumer_id)>
									#get_cons_info(RECORD_CON,0,0)# 
							</cfif>
							</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<!-- sil -->
							<td>
							<cfif not isdefined('attributes.is_display')>
								<a href="#request.self#?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#SPECT_MAIN_ID#&#url_str#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='33606.Spec Güncelle'>"></i></a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects.popup_detail_spec&id=#SPECT_MAIN_ID#"><i class="icon-detail" title="<cf_get_lang dictionary_id ='36794.Spec Detay'>"></i></a>
							</cfif>
							</td>
						</cfif>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="7"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif isdefined("form_varmi") and form_varmi eq 1>
		<cfset url_str = "#url_str#&is_form_submitted=1">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.is_from_prod_order")>
		<cfset url_str = "#url_str#&is_from_prod_order=#attributes.is_from_prod_order#">
	</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##url_str#&keyword=#attributes.keyword#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>

<form name="add_spec" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_main_to_add_spect" method="post">
	<!--- <cfif isdefined('attributes.is_stock')><input type="hidden" name="is_stock" value="1"></cfif> --->
	<cfif isdefined('attributes.location_id')><input type="hidden" name="location_id" id="location_id" value="<cfoutput>#attributes.location_id#</cfoutput>"></cfif>
	<cfif isdefined('attributes.department_id')><input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>"></cfif>
	<input type="hidden" name="spect_id" id="spect_id">
	<input type="hidden" name="x_is_basket_price" id="x_is_basket_price" value="<cfoutput>#x_is_basket_price#</cfoutput>">
	<input type="hidden" name="price_catid" id="price_catid" value="<cfif isdefined('attributes.price_catid')><cfoutput>#attributes.price_catid#</cfoutput></cfif>">
	<input type="hidden" name="price_change" id="price_change" value="0">
	<input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined('attributes.stock_id')><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
	<input type="hidden" name="product_id" id="product_id" value="<cfif isdefined('attributes.product_id')><cfoutput>#attributes.product_id#</cfoutput></cfif>">
	<input type="hidden" name="p_order_row_id" id="p_order_row_id" value="<cfif isdefined('attributes.p_order_row_id') and listlen(attributes.p_order_row_id,',') eq 1><cfoutput>#attributes.p_order_row_id#</cfoutput></cfif>">
	<input type="hidden" name="spect_main_id" id="spect_main_id" value="">
	<input type="hidden" name="spect_main_name" id="spect_main_name" value="">
	<input type="hidden" name="insert_spec" id="insert_spec" value="<cfoutput><cfif isdefined('attributes.insert_spec')>#attributes.insert_spec#</cfif></cfoutput>">
	<cfif isdefined("attributes.row_id")>
		<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_main_id")>
		<input type="hidden" name="field_main_id" id="field_main_id" value="<cfoutput>#attributes.field_main_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_var_id")>
		<input type="hidden" name="field_var_id" id="field_var_id" value="<cfoutput>#attributes.field_var_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.price")>
		<input type="hidden" name="price" id="price" value="<cfoutput>#attributes.price#</cfoutput>">
	</cfif>
	
	<cfif isdefined("attributes.sepet_process_type")>
		<input type="hidden" name="sepet_process_type" id="sepet_process_type" value="<cfoutput>#attributes.sepet_process_type#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.money_")>
		<input type="hidden" name="money_" id="money_" value="<cfoutput>#attributes.money_#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.basket_id")>
		<input type="hidden" name="basket_id" id="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.is_refresh")>
		<input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.form_name")>
		<input type="hidden" name="form_name" id="form_name" value="<cfoutput>#attributes.form_name#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.company_id")>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.consumer_id")>
		<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	</cfif>
	<input type="hidden" name="function_name" id="function_name" value="<cfoutput><cfif isdefined('attributes.function_name')>#attributes.function_name#</cfif></cfoutput>">
	<cfoutput>
	<cfloop query="GET_MONEY">
		<cfif isdefined("attributes.#money#") >
			<input type="hidden" name="#money#" id="#money#" value="#evaluate('attributes.#money#')#">
		</cfif>
	</cfloop>
	<cfif isdefined("attributes.search_process_date")>
		<input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#attributes.search_process_date#</cfoutput>">
	</cfif>
	</cfoutput>
</form>

<script type="text/javascript">
document.getElementById('keyword').focus();
function spect_ekle(main_spec_id,spect_type)//üretim emrinde seçilen main spect'e,spect eklenecek ve o eklenen spect yine üretim emrine gönderilecek.
{
	window.location.href="<cfoutput>#request.self#?fuseaction=objects.emptypopup_main_to_add_spect&spect_main_id=" + main_spec_id +"&spect_type="+spect_type+"&#url_str#"</cfoutput>;
}
function gonder_invoice(main_id,name_)
{
	<cfif isdefined("attributes.row_id")>
		<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
			var satir = <cfoutput>#attributes.row_id#</cfoutput>;
		<cfelse>
			var satir = -1;
		</cfif>
		if(window.opener.basket && satir > -1) 
		{
			window.opener.updateBasketItemFromPopup(satir, 
			{ 
				SPECT_ID: main_id, 
				SPECT_NAME: name_
			});
		}
	<cfelse>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('spect_name').value = name_;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('spect_id').value = main_id;
	</cfif>
	document.add_spec.spect_main_name.value=name_;//spect main name
	document.add_spec.spect_main_id.value=main_id;//spect main id
	if(document.form_search_spect_main.price_change.checked==true)
		document.add_spec.price_change.value=1;	
	else
		document.add_spec.price_change.value=0;	
	document.add_spec.submit();
}
function gonder(main_spec_id,spect_var_id,main_spec_name,spect_type)
{
	<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
		<cfif listlen(attributes.field_name,'.') eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = main_spec_name;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.field_name#</cfoutput>').value = 	main_spec_name;
		</cfif>
	<cfelse>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('spect_name').value = 	main_spec_name;
	</cfif>
	<cfif isdefined("attributes.field_var_id") and len(attributes.field_var_id)>
		<cfif listlen(attributes.field_var_id,'.') eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_var_id#</cfoutput>.value = spect_var_id;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.field_var_id#</cfoutput>').value = spect_var_id;
		</cfif>
	<cfelse>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('spect_id') != undefined)
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('spect_id').value = spect_var_id;
	</cfif>
	<cfif isdefined("attributes.field_main_id") and len(attributes.field_main_id)>
		<cfif listlen(attributes.field_main_id,'.') eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_main_id#</cfoutput>.value = main_spec_id;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('<cfoutput>#attributes.field_main_id#</cfoutput>').value = 	main_spec_id;	
		</cfif>	
	</cfif>
	<cfif isdefined("attributes.function_name") and len(attributes.function_name)>
		<cfset _form_name_ = ''>
		<cfif isdefined('attributes.FUNCTION_FORM_NAME')>
			<cfset _form_name_ = '#attributes.FUNCTION_FORM_NAME#'>
		</cfif>
		<cfoutput>opener.#attributes.function_name#('#_form_name_#');</cfoutput>
	</cfif>
	<cfif not(isdefined("attributes.field_main_id") or isdefined("attributes.field_var_id"))>
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id="+main_spec_id;
	<cfelse>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</cfif>
}
</script>
<script type="text/javascript">
	function go_page(type)
	{
		if(type!=1)
		{
			<cfif isdefined("attributes.draggable")>
				openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_spect&only_list=1&field_name=#attributes.field_name#&field_main_id=#attributes.field_main_id#&form_submitted=1<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>&stock_id=#attributes.stock_id#</cfif></cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
			<cfelse>
				window.location.href='<cfoutput>#request.self#?fuseaction=objects.popup_list_spect&only_list=1&form_submitted=1<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>&stock_id=#attributes.stock_id#</cfif></cfoutput>';
			</cfif>
		}
	}
</script>
