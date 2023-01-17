<cfinclude template="../../header.cfm">

<cfset analysis_parameters = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_parameters") />
<cfset sampling = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling") />

<cfset getAnalysisMethods = analysis_parameters.getMethod() />

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.analysis_method" default="">
<cfparam name="attributes.sample_no" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.request_emp_name" default="">
<cfparam name="attributes.request_emp_id" default="">
<cfparam name="attributes.request_partner_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.analysis_emp_name" default="">
<cfparam name="attributes.analysis_emp_id" default="">
<cfparam name="attributes.analysis_partner_id" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.serial_no_1" default="">
<cfparam name="attributes.serial_no_2" default="">
<cfparam name="attributes.sampling_date_start" default="#dateFormat(now(),dateformat_style)#">
<cfparam name="attributes.sampling_date_finish" default="#dateFormat(now(),dateformat_style)#">
<cfparam name="attributes.analysis_date_start" default="#dateFormat(now(),dateformat_style)#">
<cfparam name="attributes.analysis_date_finish" default="#dateFormat(now(),dateformat_style)#">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_txt" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
			
	<cfset getSampling = sampling.getSampling(
		analysis_method: attributes.analysis_method,
		sample_no: attributes.sample_no,
		stock_id: attributes.stock_id,
		product_id: attributes.product_id,
		product_name: attributes.product_name,
		request_emp_name: attributes.request_emp_name,
		request_emp_id: attributes.request_emp_id,
		request_partner_id: attributes.request_partner_id,
		company_id: attributes.company_id,
		consumer_id: attributes.consumer_id,
		employee_id: attributes.employee_id,
		member_type: attributes.member_type,
		company: attributes.company,
		analysis_emp_name: attributes.analysis_emp_name,
		analysis_emp_id: attributes.analysis_emp_id,
		analysis_partner_id: attributes.analysis_partner_id,
		spect_main_id: attributes.spect_main_id,
		spect_name: attributes.spect_name,
		serial_no_1: attributes.serial_no_1,
		serial_no_2: attributes.serial_no_2,
		sampling_date_start: attributes.sampling_date_start,
		sampling_date_finish: attributes.sampling_date_finish,
		analysis_date_start: attributes.analysis_date_start,
		analysis_date_finish: attributes.analysis_date_finish,
		location_id: attributes.location_id,
		department_id: attributes.department_id,
		department_txt: attributes.department_txt
    ) />

<cfelse>
	<cfset getSampling.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default=#getSampling.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=lab.sampling">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-12">Analiz Metodu</label>
						<select name="analysis_method" id="analysis_method">
							<option value="">Seçiniz</option>
						</select>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-5">Numune No</label>
						<div class="col col-7">
							<cfinput type="text" name="sample_no" value="#attributes.sample_no#">
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_product_name">
						<label class="col col-2"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-10">
							<div class="input-group">
									<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
									<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
									<input type="text"   name="product_name"  id="product_name" style="width:140px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form.stock_id&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form.product_name.value),'list');"></span>
								</div>
							</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_request_emp">
						<label class="col col-3">Talep Eden</label>
						<div class="col col-9">
							<div class="input-group">
								<input type="hidden" name="request_emp_id" id="request_emp_id" value="<cfif isdefined("attributes.request_emp_id") and len(attributes.request_emp_id)><cfoutput>#attributes.request_emp_id#</cfoutput></cfif>">
								<input type="hidden" name="request_partner_id" id="request_partner_id" value="<cfif isdefined("attributes.request_partner_id") and len(attributes.request_partner_id)><cfoutput>#attributes.request_partner_id#</cfoutput></cfif>" >
								<input type="text" name="request_emp_name" id="request_emp_name" value="<cfif isdefined("attributes.request_emp_name") and len(attributes.request_emp_name)><cfoutput>#attributes.request_emp_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('request_emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','request_emp_id,request_partner_id','','3','250');">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.request_emp_name&field_partner=form.request_partner_id&field_EMP_id=form.request_emp_id</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
								<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&field_type=form.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_analysis_emp">
						<label class="col col-12">Analiz Eden</label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="analysis_emp_id" id="analysis_emp_id" value="<cfif isdefined("attributes.analysis_emp_id") and len(attributes.analysis_emp_id)><cfoutput>#attributes.analysis_emp_id#</cfoutput></cfif>">
								<input type="hidden" name="analysis_partner_id" id="analysis_partner_id" value="<cfif isdefined("attributes.analysis_partner_id") and len(attributes.analysis_partner_id)><cfoutput>#attributes.analysis_partner_id#</cfoutput></cfif>" >
								<input type="text" name="analysis_emp_name" id="analysis_emp_name" value="<cfif isdefined("attributes.analysis_emp_name") and len(attributes.analysis_emp_name)><cfoutput>#attributes.analysis_emp_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('analysis_emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','analysis_emp_id,analysis_partner_id','','3','250');">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.analysis_emp_name&field_partner=form.analysis_partner_id&field_EMP_id=form.analysis_emp_id</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="item-spect_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57647.Spekt'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif isdefined('attributes.spect_main_id') and len(attributes.spect_main_id)><cfoutput>#attributes.spect_main_id#</cfoutput></cfif>">
								<input type="text" name="spect_name" id="spect_name" style="width:150px;" value="<cfif isdefined('attributes.spect_name') and len(attributes.spect_name)><cfoutput>#attributes.spect_name#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="product_control();"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-12">Seri No</label>
						<div class = "row">
							<div class = "col col-6">
								<cfinput type="text" name="serial_no_1" style="width:50px;" value="#attributes.serial_no_1#" maxlength="255">
							</div>
							<div class = "col col-6">
								<cfinput type="text" name="serial_no_2" style="width:50px;" value="#attributes.serial_no_2#" maxlength="255">
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_start_date">
						<label class="col col-12">Numune Alım Tarihi</label>
						<div class="col col-12">
							<div class="col col-6 pl-0">
								<div class="input-group">
									<cfinput type="text" name="sampling_date_start" value="#dateformat(attributes.sampling_date_start, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="sampling_date_start"></span>
								</div>
							</div>
							<div class="col col-6 pl-0">
								<div class="input-group">
									<cfinput type="text" name="sampling_date_finish" value="#dateformat(attributes.sampling_date_finish, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="sampling_date_finish"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_start_date">
						<label class="col col-12">Analiz Tarihi</label>
						<div class="col col-12">
							<div class="col col-6 pl-0">
								<div class="input-group">
									<cfinput type="text" name="analysis_date_start" value="#dateformat(attributes.analysis_date_start, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="analysis_date_start"></span>
								</div>
							</div>
							<div class="col col-6 pl-0">
								<div class="input-group">
									<cfinput type="text" name="analysis_date_finish" value="#dateformat(attributes.analysis_date_finish, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="analysis_date_finish"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group" id="form_ul_department_txt">
						<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
						<div class="col col-12">
										<cf_wrkdepartmentlocation 
											returninputvalue="location_id,department_txt,department_id"
											returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
											fieldname="department_txt"
											fieldid="location_id"
											department_fldid="department_id"
											department_id="#attributes.department_id#"
											location_id="#attributes.location_id#"
											location_name="#attributes.department_txt#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											user_location = "0"
											width="140">
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head">Stoklardan Numune Alımı</cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
					<th>Lab No</th>
					<th>Lab Analizi</th>
					<th>Açıklama</th>
					<th>Süreç</th>
					<th>Stok Kodu</th>
					<th>Lot No</th>
					<th>Seri No</th>
					<th>N. Alım Tarihi</th>
					<th>Lab. Giriş Tarihi</th>
					<th>Talep Eden</th>
					<th>Analiz Eden</th>
					<th class="header_icn_none"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=lab.sampling&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif getSampling.recordcount>
					<cfoutput query="getSampling" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>

							<td>lab no</td>
							<td>lab analizi</td>
							<td>açıklama</td>
							<td>süreç</td>
							<td>stok kodu</td>
							<td>lot no</td>
							<td>süreç</td>
							<td>süreç</td>
							<td>süreç</td>
							<td>süreç</td>



							<td style="text-align:center;"><a href="javascript://" target="" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_type=961&id=#sampling_id#','WOC');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
							<td><a href="#request.self#?fuseaction=lab.sampling&event=upd&sampling_id=#sampling_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.process_stage)>
				<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
			</cfif>
			<cfif len(attributes.analyze_cat)>
				<cfset url_str = "#url_str#&analyze_cat=#attributes.analyze_cat#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="lab.sampling#url_str#">
		</cfif>
	</cf_box>
</div>

<script type = "text/javascript">
	function product_control(){/*Ürün seçmeden spec seçemesin.*/
		if(document.getElementById('product_id').value=="" || document.getElementById('product_name').value == "" ){
			alert("<cf_get_lang dictionary_id ='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=form.spect_main_id&field_name=form.spect_name&is_display=1&product_id='+document.getElementById('product_id').value,'list');
	}
</script>