<cfinclude template="../../header.cfm">

<cfset sample_analysis = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis") />

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.analysis_method" default="">
<cfparam name="attributes.requesting_employee_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.from_company_id" default="">
<cfparam name="attributes.from_partner_id" default="">
<cfparam name="attributes.from_consumer_id" default="">
<cfparam name="attributes.requesting_employee_id" default="">
<cfparam name="attributes.requesting_employee_name" default="">
<cfparam name="attributes.sample_employee_id" default="">
<cfparam name="attributes.sample_company_id" default="">
<cfparam name="attributes.sample_partner_id" default="">
<cfparam name="attributes.sample_consumer_id" default="">
<cfparam name="attributes.sample_employee_name" default="">
<cfparam name="attributes.sample_date1" default="">
<cfparam name="attributes.sample_date2" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.analyse_date1" default="">
<cfparam name="attributes.analyse_date2" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.serial_no" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
	<cfif len(attributes.sample_date1)><cf_date tarih="attributes.sample_date1"></cfif>
	<cfif len(attributes.sample_date2)><cf_date tarih="attributes.sample_date2"></cfif>
	<cfif len(attributes.analyse_date1)><cf_date tarih="attributes.analyse_date1"></cfif>
	<cfif len(attributes.analyse_date2)><cf_date tarih="attributes.analyse_date2"></cfif>

	<cfset getLabTest = sample_analysis.getLabTest(
		keyword: attributes.keyword,
		analysis_method : attributes.analysis_method,
		stock_id : attributes.stock_id,
		requesting_employee_id : attributes.requesting_employee_id,
		sample_date1 : attributes.sample_date1,
		sample_date2 : attributes.sample_date2,
		analyse_date1: attributes.analyse_date1,
		analyse_date2: attributes.analyse_date2,
		stock_id: attributes.stock_id,
		requesting_employee_name: attributes.requesting_employee_name,
		requesting_employee_id: attributes.requesting_employee_id,
		sample_employee_id: attributes.sample_employee_id,
		sample_employee_name: attributes.sample_employee_name,
		consumer_id : attributes.consumer_id, 
		company_id : attributes.company_id,
		member_type : attributes.member_type,
		member_name : attributes.member_name,
		spect_main_id : attributes.spect_main_id,
		spect_name : attributes.spect_name,
		serial_no : attributes.serial_no
    ) />
<cfelse>
	<cfset getLabTest.recordcount=0>
</cfif>
<cfquery name="quality_control_type" datasource="#dsn3#">
	SELECT
		TYPE_ID,
		QUALITY_CONTROL_TYPE
	FROM
		QUALITY_CONTROL_TYPE
</cfquery>
<cfparam name="attributes.totalrecords" default=#getLabTest.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_target" method="post" action="#request.self#?fuseaction=lab.sample_analysis">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<select name="analysis_method" id="analysis_method">
						<option value=""><cf_get_lang dictionary_id='64164.Analiz Metodu'><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="quality_control_type">
							<option value="#TYPE_ID#" <cfif attributes.analysis_method eq TYPE_ID>selected</cfif>>#QUALITY_CONTROL_TYPE#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Numune No','62568')#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
						<cfinput type="text" name="stock_code" id="stock_code" value="#attributes.stock_code#" maxlength="255" placeholder="#getLang('','Stok','57452')#">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_target.stock_id&field_code=search_target.stock_code');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="hidden" name="from_company_id" id="from_company_id" value="#attributes.from_company_id#"><!--- kurumsal üyeler için --->
						<cfinput type="hidden" name="from_partner_id" id="from_partner_id" value="#attributes.from_partner_id#"><!--- kurumsal üyeler için --->
						<cfinput type="hidden" name="from_consumer_id" id="from_consumer_id" value="#attributes.from_consumer_id#"><!--- bireysel üyeler için --->   
						<cfinput type="hidden" name="requesting_employee_id" value="#attributes.requesting_employee_id#"><!--- çalışanlar için --->
						<cfinput type="text" name="requesting_employee_name" value="#attributes.requesting_employee_name#" maxlength="255" placeholder="#getLang('','Talep Eden','30829')#">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_target.requesting_employee_id&field_name=search_target.requesting_employee_name&field_partner=search_target.from_partner_id&field_consumer=search_target.from_consumer_id&field_comp_id=search_target.from_company_id&is_form_submitted=1&select_list=1,7,8');"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
								<cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
								<cfinput type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
								<cfinput name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="#attributes.member_name#" autocomplete="off">
								<cfset str_linke_ait="&field_consumer=search_target.consumer_id&field_comp_id=search_target.company_id&field_member_name=search_target.member_name&field_type=search_target.member_type">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.search_target.member_name.value));"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62138.Numune Alım Tarihi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="sample_date1" id="sample_date1" class="width" maxlength="10" value="#dateFormat(attributes.sample_date1,dateformat_style)#" validate="#validate_style#"  placeholder="#getLang('','Başlangıç','57501')#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="sample_date1"></span>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="sample_date2" id="sample_date2" class="width" maxlength="10" value="#dateFormat(attributes.sample_date2,dateformat_style)#" validate="#validate_style#" placeholder="#getLang('','Bitiş','57502')#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="sample_date2"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64165.Analiz Eden'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="sample_employee_id" id="sample_employee_id" value="#attributes.sample_employee_id#"><!--- çalışanlar için --->
								<cfinput type="hidden" name="sample_company_id" id="sample_company_id" value="#attributes.sample_company_id#"><!--- kurumsal üyeler için --->
								<cfinput type="hidden" name="sample_partner_id" id="sample_partner_id" value="#attributes.sample_partner_id#"><!--- kurumsal üyeler için --->
								<cfinput type="hidden" name="sample_consumer_id" id="sample_consumer_id" value="#attributes.sample_consumer_id#"><!--- bireysel üyeler için --->              
								<cfinput type="text" name="sample_employee_name" id="sample_employee_name" value="#attributes.sample_employee_name#" onfocus="AutoComplete_Create('sample_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','sample_consumer_id,sample_company_id,sample_employee_id,sample_partner_id','','3','250');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_target.sample_employee_id&field_name=search_target.sample_employee_name&field_partner=search_target.sample_partner_id&field_consumer=search_target.sample_consumer_id&field_comp_id=search_target.sample_company_id&is_form_submitted=1&select_list=1,7,8');"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64166.Analiz Tarihi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="analyse_date1" id="analyse_date1" class="width" maxlength="10" value="#dateformat(attributes.analyse_date1,dateformat_style)#" validate="#validate_style#" placeholder="#getLang('','Başlangıç','57501')#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="analyse_date1"></span>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="analyse_date2" id="analyse_date2" class="width" maxlength="10" value="#dateformat(attributes.analyse_date2,dateformat_style)#" validate="#validate_style#" placeholder="#getLang('','Bitiş','57502')#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="analyse_date2"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spekt'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="spect_main_id" id="spect_main_id" value="#attributes.spect_main_id#">
								<cfinput type="text" name="spect_name" id="spect_name" value="#attributes.spect_name#">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="open_spec()"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="serial_no" id="serial_no" value="#attributes.serial_no#">
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Laboratuvar İşlemleri','64096')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='62139.Lab Rapor No'></th>
					<th><cf_get_lang dictionary_id='64168.Lab. Analizi'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th class="text-center"><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='45498.Lot No'></th>
					<th><cf_get_lang dictionary_id='57637.Seri No'></th>
					<th><cf_get_lang dictionary_id='62603.Numune'></th>
					<th><cf_get_lang dictionary_id='62138.Numune Alım Tarihi'></th>
					<th><cf_get_lang dictionary_id='64169.Lab. Giriş Tarihi'></th>
					<th><cf_get_lang dictionary_id='276.Talep Eden'></th>
					<th><cf_get_lang dictionary_id='64165.Analiz Eden'></th>
					<th><i class="fa fa-print"></i></th>
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=lab.sample_analysis&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif getLabTest.recordcount>
					<cfoutput query="getLabTest" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#LAB_REPORT_NO#</td>
							<cfquery name="get_control_type" datasource="#dsn#">
								SELECT
									QT.TYPE_ID,
									QT.QUALITY_CONTROL_TYPE
								FROM
									REFINERY_LAB_TESTS_ROW REFR
								LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QT ON QT.TYPE_ID=REFR.GROUP_ID
								WHERE REFR.REFINERY_LAB_TEST_ID= <cfqueryparam value="#getLabTest.REFINERY_LAB_TEST_ID#">
								GROUP BY 
									QT.TYPE_ID,
									QT.QUALITY_CONTROL_TYPE
							</cfquery>
							<td>
								<cfloop query="get_control_type">
									#get_control_type.QUALITY_CONTROL_TYPE#</br>
								</cfloop>
							</td>
							<td>#DETAIL#</td>
							<td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
								<cfquery name="get_detail" datasource="#dsn#">
									SELECT
									LSR.SERIAL_NO,
									LSR.LOT_NO,
									S.STOCK_CODE,
									LSR.PRODUCT_ID
										FROM 
										REFINERY_LAB_TESTS AS REF
										LEFT JOIN LAB_SAMPLING LS ON REF.REFINERY_LAB_TEST_ID = LS.SAMPLE_ANALYSIS_ID
									LEFT JOIN LAB_SAMPLING_ROW LSR ON LSR.SAMPLING_ID = LS.SAMPLING_ID
									LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID = LSR.STOCK_ID
									WHERE REF.REFINERY_LAB_TEST_ID= <cfqueryparam value="#getLabTest.REFINERY_LAB_TEST_ID#">
								</cfquery>
								<cfquery name="get_serial" dbtype="query">
									SELECT SERIAL_NO FROM get_detail WHERE 1=1 GROUP BY SERIAL_NO
								</cfquery>
								<cfquery name="get_lot" dbtype="query">
									SELECT LOT_NO FROM get_detail WHERE 1=1 GROUP BY LOT_NO
								</cfquery>
								<cfquery name="get_stock" dbtype="query">
									SELECT STOCK_CODE,PRODUCT_ID FROM get_detail WHERE 1=1 GROUP BY STOCK_CODE,PRODUCT_ID
								</cfquery>
							<td>
								<cfloop query="get_stock">
									<a href="#request.self#?fuseaction=product.product_quality&pid=#PRODUCT_ID#" target="_blank">#get_stock.STOCK_CODE#</a>
									<cfif len(get_stock.STOCK_CODE)></br></cfif>
								</cfloop>
							<td>
								<cfloop query="get_lot">
									#get_lot.LOT_NO# <cfif len(get_lot.LOT_NO)></br></cfif>
								</cfloop>
							</td>
							<td>
								<cfloop query="get_serial">
									#get_serial.SERIAL_NO# <cfif len(get_serial.SERIAL_NO)></br></cfif>
								</cfloop>
							</td>
							<td>
								<cfif len(getLabTest.PRODUCT_SAMPLE_ID)>
									<cfquery name="get_sample_name" datasource="#dsn3#">
										SELECT PRODUCT_SAMPLE_NAME FROM PRODUCT_SAMPLE WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getLabTest.PRODUCT_SAMPLE_ID#"> 
									</cfquery>
									<a href="#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#getLabTest.PRODUCT_SAMPLE_ID#" target="_blank">#get_sample_name.PRODUCT_SAMPLE_NAME#</a>
								</cfif>
							</td>
							<td>#dateTimeFormat(NUMUNE_DATE,"DD-MM-YYYY HH:mm:ss")#</td>
							<td>#dateTimeFormat(ANALYSE_DATE,"DD-MM-YYYY HH:mm:ss")#</td>
							<td>#get_emp_info(REQUESTING_EMPLOYE_ID,0,0)#</td>
							<td>#get_emp_info(SAMPLE_EMPLOYEE_ID,0,0)#</td>
							<td><a href="#request.self#?fuseaction=objects.popup_print_files&action_id=#refinery_lab_test_id#&action=lab.sample_analysis" target="_blank"><i class="fa fa-print"></i></a></td>
							<td><a href="#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#REFINERY_LAB_TEST_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif getLabTest.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
			</div>
		</cfif>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.stock_id)>
				<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
			</cfif>
			<cfif len(attributes.analysis_method)>
				<cfset url_str = "#url_str#&analysis_method=#attributes.analysis_method#">
			</cfif>
			<cfif len(attributes.requesting_employee_id)>
				<cfset url_str = "#url_str#&requesting_employee_id=#attributes.requesting_employee_id#">
			</cfif>
			<cfif len(attributes.consumer_id)>
				<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.company_id)>
				<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
			</cfif>
			<cfif len(attributes.member_type)>
				<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
			</cfif>
			<cfif len(attributes.member_name)>
				<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
			</cfif>
			<cfif len(attributes.from_company_id)>
				<cfset url_str = "#url_str#&from_company_id=#attributes.from_company_id#">
			</cfif>
			<cfif len(attributes.from_partner_id)>
				<cfset url_str = "#url_str#&from_partner_id=#attributes.from_partner_id#">
			</cfif>
			<cfif len(attributes.from_consumer_id)>
				<cfset url_str = "#url_str#&from_consumer_id=#attributes.from_consumer_id#">
			</cfif>
			<cfif len(attributes.requesting_employee_id)>
				<cfset url_str = "#url_str#&requesting_employee_id=#attributes.requesting_employee_id#">
			</cfif>
			<cfif len(attributes.requesting_employee_name)>
				<cfset url_str = "#url_str#&requesting_employee_name=#attributes.requesting_employee_name#">
			</cfif>
			<cfif len(attributes.sample_employee_id)>
				<cfset url_str = "#url_str#&sample_employee_id=#attributes.sample_employee_id#">
			</cfif>
			<cfif len(attributes.sample_company_id)>
				<cfset url_str = "#url_str#&sample_company_id=#attributes.sample_company_id#">
			</cfif>
			<cfif len(attributes.sample_partner_id)>
				<cfset url_str = "#url_str#&sample_partner_id=#attributes.sample_partner_id#">
			</cfif>
			<cfif len(attributes.sample_consumer_id)>
				<cfset url_str = "#url_str#&sample_consumer_id=#attributes.sample_consumer_id#">
			</cfif>
			<cfif len(attributes.sample_employee_name)>
				<cfset url_str = "#url_str#&sample_employee_name=#attributes.sample_employee_name#">
			</cfif>
			<cfif len(attributes.sample_date1)>
				<cfset url_str = "#url_str#&sample_date1=#attributes.sample_date1#">
			</cfif>
			<cfif len(attributes.sample_date2)>
				<cfset url_str = "#url_str#&sample_date2=#attributes.sample_date2#">
			</cfif>
			<cfif len(attributes.stock_id)>
				<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
			</cfif>
			<cfif len(attributes.stock_code)>
				<cfset url_str = "#url_str#&stock_code=#attributes.stock_code#">
			</cfif>
			<cfif len(attributes.analyse_date1)>
				<cfset url_str = "#url_str#&analyse_date1=#attributes.analyse_date1#">
			</cfif>
			<cfif len(attributes.analyse_date2)>
				<cfset url_str = "#url_str#&analyse_date2=#attributes.analyse_date2#">
			</cfif>
			<cfif len(attributes.spect_main_id)>
				<cfset url_str = "#url_str#&spect_main_id=#attributes.spect_main_id#">
			</cfif>
			<cfif len(attributes.spect_name)>
				<cfset url_str = "#url_str#&spect_name=#attributes.spect_name#">
			</cfif>
			<cfif len(attributes.serial_no)>
				<cfset url_str = "#url_str#&serial_no=#attributes.serial_no#">
			</cfif>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="lab.sample_analysis#url_str#">
		</cfif>
	</cf_box>
</div>
<script>
	function open_spec() {
		if(document.getElementById('stock_id').value=="" || document.getElementById('stock_code').value == "" ){
            alert("<cf_get_lang dictionary_id='64170.Spekt Seçmek İçin Önce Stok Seçimi Yapmalısınız.'>");
            return false;
        }
        else{
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search_target.spect_main_id&field_name=search_target.spect_name&is_display=1&stock_id='+document.getElementById('stock_id').value);
    	}
	}
</script>