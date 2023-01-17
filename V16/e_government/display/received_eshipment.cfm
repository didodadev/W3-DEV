<!---
    Gelen e-irsaliye listeleme sayfası
--->
<cfquery name="GET_ESHIPMENT_CONTROL" datasource="#DSN#">
	SELECT
        IS_ESHIPMENT
	FROM
    	OUR_COMPANY_INFO
    WHERE
    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfif len(GET_ESHIPMENT_CONTROL.IS_ESHIPMENT) and GET_ESHIPMENT_CONTROL.IS_ESHIPMENT eq 1>
	<cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
	<cfset soap.init()>
	<cfset eshipment = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
	<cfset eshipment.dsn = dsn>
	<cfset eshipment.dsn2 = dsn2>
	<cfset get_vkn = eshipment.get_our_company_fnc(session.ep.company_id)>
	<cfset directory_name = "#upload_folder#eshipment_received/">
	<cfif not DirectoryExists(directory_name)>
		<cfdirectory action="create" directory="#directory_name#">
	</cfif>

	<!--- eirsaliye listesinin okunup alınması 
		<cfinclude template="../query/eshipment_parse.cfm">
	--->

	<!--- Listeleme İşlemleri --->
	<cfparam name="attributes.keyword" default="" />
	<cfparam name="attributes.is_submitted" default="" />
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.createdate_start" default="">
	<cfparam name="attributes.createdate_finish" default="">
	<cfparam name="attributes.issuedate_start" default="">
	<cfparam name="attributes.issuedate_finish" default="">
	<cfparam name="attributes.is_processed" default="">
	<cfparam name="attributes.status" default="">
	<cfparam name="attributes.consumer_id" default="">
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.company" default="">
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.member_type" default="">
	<cfif len(attributes.createdate_start)>
		<cf_date tarih="attributes.createdate_start">
	</cfif>
	<cfif len(attributes.createdate_finish)>
		<cf_date tarih="attributes.createdate_finish">
	</cfif>
	<cfif len(attributes.issuedate_start)>
		<cf_date tarih="attributes.issuedate_start">
	</cfif>
	<cfif len(attributes.issuedate_finish)>
		<cf_date tarih="attributes.issuedate_finish">
	</cfif>

	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isDefined("attributes.is_submitted") and len(attributes.is_submitted)>
		<cfset getReceivedEshipment = eshipment.getReceivedEshipment(startrow:attributes.startrow, maxrows:attributes.maxrows, keyword:attributes.keyword, createdate_start: attributes.createdate_start, createdate_finish: attributes.createdate_finish, issuedate_start: attributes.issuedate_start, issuedate_finish: attributes.issuedate_finish, status: attributes.status, company: attributes.company, is_processed: attributes.is_processed)>
		<cfparam name="attributes.totalrecords" default="#getReceivedEshipment.query_count#">
	<cfelse>
		<cfset getReceivedEshipment.recordcount = 0>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
	
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform name="form_despatch_advice" action="" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box id="search_despatch_advice">
				<cf_box_search>
					<div class="form-group">
						<input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>">
					</div>
					<div class="form-group" id="item-statu">
						<select name="status" id="status">
							<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
							<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57064.Kabul'></option>
							<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='29537.Red'></option>
							<option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57058.Bekliyor'></option>
						</select>
					</div>
					<div class="form-group">
						<select name="is_processed" id="is_processed">
							<option value="0" <cfif attributes.is_processed eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.All'></option>
							<option value="1" <cfif attributes.is_processed eq 1>selected</cfif>><cf_get_lang dictionary_id='57061.processed'></option>
							<option value="2" <cfif attributes.is_processed eq 2>selected</cfif>><cf_get_lang dictionary_id='57063.unproccesed'></option>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-createdate">
							<label><cf_get_lang dictionary_id='45874.İrsaliye Tarihi'></label>
							<div class="col col-6 col-xs-12 pl-0">
								<div class="input-group">
									<input type="text" name="createdate_start" id="createdate_start" value="<cfif len(attributes.createdate_start)><cfoutput>#dateFormat(attributes.createdate_start, dateformat_style)#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="createdate_start"></span>
								</div>
							</div>
							<div class="col col-6 col-xs-12 pl-0">
								<div class="input-group">
									<input type="text" name="createdate_finish" id="createdate_finish" value="<cfif len(attributes.createdate_finish)><cfoutput>#dateFormat(attributes.createdate_finish, dateformat_style)#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="createdate_finish"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-issuedate">
							<label><cf_get_lang dictionary_id='56032.Düzenleme Tarihi'></label>
							<div class="col col-6 col-xs-12 pl-0">
								<div class="input-group">
									<input type="text" name="issuedate_start" id="issuedate_start" value="<cfif len(attributes.issuedate_start)><cfoutput>#dateFormat(attributes.issuedate_start, dateformat_style)#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="issuedate_start"></span>
								</div>
							</div>
							<div class="col col-6 col-xs-12 pl-0">
								<div class="input-group">
									<input type="text" name="issuedate_finish" id="issuedate_finish" value="<cfif len(attributes.issuedate_finish)><cfoutput>#dateFormat(attributes.issuedate_finish, dateformat_style)#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>">
									<span class="input-group-addon"><cf_wrk_date_image date_field="issuedate_finish"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="form_ul_company">
							<label><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
								<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form_despatch_advice.company&field_comp_id=form_despatch_advice.company_id&field_consumer=form_despatch_advice.consumer_id&field_member_name=form_despatch_advice.company&field_emp_id=form_despatch_advice.employee_id&field_name=form_despatch_advice.company&field_type=form_despatch_advice.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&draggable=1&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form_despatch_advice.company.value))"></span>
							</div>
						</div>
					</div>
				</cf_box_search_detail>
			</cf_box>
		</cfform>
		<cfsavecontent variable="title"><cf_get_lang dictionary_id="60919.Gelen E-irsaliye"></cfsavecontent>
		<cf_box hide_table_column="1" uidrop="1" id="list_despatch_advice" title="#title#">
			<cf_grid_list sort="1">
				<thead>
					<tr>
						<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57066.Gönderen'></th>
						<th><cf_get_lang dictionary_id='57066.Gönderen'><br /><cf_get_lang dictionary_id='57068.Vergi No / TCKN'></th>
						<th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='57059.Senaryo'></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<th><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></th>
						<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
						<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
						<th><cf_get_lang dictionary_id='57756.Durum'></th>
						<th><cf_get_lang dictionary_id='57482.Aşama'></th>
						<th width="20"><a href="javascript:void(0)"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></th>
						<th width="20"><a href="javascript://" onclick="cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=stock.received_eshipment&event=add','warning_modal');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th width="20"><a href="javascript:void(0)"><i class="fa fa-thumb-tack" title="İlişkilendir"></i></a></th>
						<!-- sil -->
							<th width="20" class="header_icn_none text-center">(P)</th>
							<th width="20" class="header_icn_none text-center">
								<input type="checkbox" name="row_all_check" id="row_all_check" onClick="all_check($(this))">
								<a href="javascript://" class="mt-1"  onClick="printAll();"><i class="fa fa-print"></i></a>
							</th>
						<!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif getReceivedEshipment.recordcount>
						<cfoutput query="getReceivedEshipment">
							<tr>
								<td>#rownum#</td>
								<td>#PARTY_NAME#</td>
								<td><cf_duxi type="label" name="SENDER_TAX_ID" id="SENDER_TAX_ID" value="#SENDER_TAX_ID#" hint="TCKN/VKN" gdpr="2"></td>
								<td>#ESHIPMENT_ID#</td>
								<td style="text-align:right">#TLFormat(TOTAL_AMOUNT)#</td>
								<td>#PROFILE_ID#</td>
								<td>#DESPATCH_ADVICE_TYPE_CODE#</td>
								<td>#dateformat(CREATE_DATE,dateformat_style)# #timeformat(CREATE_DATE,timeformat_style)#</td>
								<td>#dateformat(dateadd('h',session.ep.time_zone,RECORD_DATE),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,RECORD_DATE),timeformat_style)#</td>
								<td>#dateformat(ISSUE_DATE,dateformat_style)# #timeformat(ISSUE_DATE,timeformat_style)#</td>
								<td>
									<cfif len(STATUS)>
										<cfif STATUS eq 1>
											<font color="009933"><cf_get_lang dictionary_id='57064.Kabul'></font>
										<cfelse>
											<font color="FF0000"><cf_get_lang dictionary_id='29537.Red'></font>
										</cfif>
									<cfelse>
										<cf_get_lang dictionary_id='57058.Bekliyor'>
									</cfif>
								</td>
								<td>#PROCESS_STAGE#</td>
								<td>
									<a target="_blank" href="#request.self#?fuseaction=stock.received_eshipment&event=det&receiving_detail_id=#receiving_detail_id#">
										<i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i>
									</a>
								</td>
								<td>
									<cfif len(ship_id)>
										<cfif get_vkn.TAX_NO eq SENDER_TAX_ID and get_vkn.TAX_NO eq RECEIVER_TAX_ID>
											<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#ship_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										<cfelse>
											<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#ship_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									</cfif>
								</td>
								<td>
									<cfif STATUS neq 1>
                                    	<a href="#request.self#?fuseaction=stock.received_eshipment&event=det&receiving_detail_id=#receiving_detail_id#&associate=1" target="_blank"><i class="fa fa-lg fa-thumb-tack" title="İlişkilendir"></i></a>
									</cfif>
								</td>
								<td class="text-center">#print_count#</td>
                                <!-- sil -->
                                <td class="text-center">
                                    <input type="checkbox" name="row_#rownum#" id="row_check" data-receiving_detail_id="#receiving_detail_id#">
                                </td>
                                <!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
						<td colspan="17"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfif attributes.totalrecords gt attributes.maxrows>    
				<cfset url_str = "#attributes.fuseaction#" />
				<cfif len(attributes.keyword)>
					<cfset url_str = '#url_str#&keyword=#attributes.keyword#' />
				</cfif>
				<cfif len(attributes.is_submitted)>
					<cfset url_str = '#url_str#&is_submitted=#attributes.is_submitted#' />
				</cfif>
				<cfif len(attributes.status)>
					<cfset url_str = '#url_str#&status=#attributes.status#' />
				</cfif>
				<cfif len(attributes.is_processed)>
					<cfset url_str = '#url_str#&is_processed=#attributes.is_processed#' />
				</cfif>
				<cfif len(attributes.consumer_id)>
					<cfset url_str = '#url_str#&consumer_id=#attributes.consumer_id#' />
				</cfif>
				<cfif len(attributes.employee_id)>
					<cfset url_str = '#url_str#&employee_id=#attributes.employee_id#' />
				</cfif>
				<cfif len(attributes.company)>
					<cfset url_str = '#url_str#&company=#attributes.company#' />
				</cfif>
				<cfif len(attributes.company_id)>
					<cfset url_str = '#url_str#&company_id=#attributes.company_id#' />
				</cfif>
				<cfif len(attributes.member_type)>
					<cfset url_str = '#url_str#&cmember_typeonsumer_id=#attributes.member_type#' />
				</cfif>
				<cfif (isdefined('attributes.createdate_start') and len(attributes.createdate_start))>
					<cfset url_str = '#url_str#&createdate_start=#dateformat(attributes.createdate_start,dateformat_style)#' />
				</cfif>
				<cfif (isdefined('attributes.createdate_finish') and len(attributes.createdate_finish))>
					<cfset url_str = '#url_str#&createdate_finish=#dateformat(attributes.createdate_finish,dateformat_style)#' />
				</cfif>
				<cfif (isdefined('attributes.issuedate_start') and len(attributes.issuedate_start))>
					<cfset url_str = '#url_str#&issuedate_start=#dateformat(attributes.issuedate_start,dateformat_style)#' />
				</cfif>
				<cfif (isdefined('attributes.issuedate_finish') and len(attributes.issuedate_finish))>
					<cfset url_str = '#url_str#&issuedate_finish=#dateformat(attributes.issuedate_finish,dateformat_style)#' />
				</cfif>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#url_str#">
			</cfif>
		</cf_box>
		<cfelse>
			<cf_get_lang dictionary_id='57539.Modülünde yetki seviyeniz işlem yapmaya uygun değil!'>
		</cfif>
	</div>
<script type="text/javascript">
	function all_check(e){
        var status = $(e).prop('checked');
        $('input#row_check').each(function() {
            $( this ).prop('checked',status);
        });
    }
	function printAll(){
		select_receiving_detail_id = '0';
		$('input#row_check').each(function() {
			var status = $(this).prop('checked');
			if(status){
				var receiving_detail_id = $( this ).data('receiving_detail_id');
				select_receiving_detail_id += ',' + receiving_detail_id;
			}
		});
		if (select_receiving_detail_id !='0'){
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_eshipment_detail&type=1&print=1&print_id='+select_receiving_detail_id,'wwide');
		}
	}
</script>