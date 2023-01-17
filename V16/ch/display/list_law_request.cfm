<cfparam name="attributes.file_number" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.request_status" default="1">
<cfparam name="attributes.process_stage_type" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_law_request" datasource="#dsn#">
		SELECT
			*
		FROM
			COMPANY_LAW_REQUEST
		WHERE
			1=1
		<cfif isdefined("attributes.file_number") and len(attributes.file_number)>
			AND FILE_NUMBER LIKE '%#attributes.file_number#%'
		</cfif>
		<cfif len(attributes.company_id)>
			AND COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.request_status)>
			AND REQUEST_STATUS = #attributes.request_status#
		</cfif>
		<cfif len(attributes.consumer_id)>
			AND CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.process_stage_type)>
			AND PROCESS_STAGE = #attributes.process_stage_type#
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_law_request.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_law_request.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form_law_request" method="post" action="#request.self#?fuseaction=ch.list_law_request">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<input type="text" name="file_number" maxlength="50" id="file_number" value="<cfoutput>#attributes.file_number#</cfoutput>" placeholder="<cfoutput>#getLang(159,'Dosya No',50132)#</cfoutput>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.member_name)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
						<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.member_name)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
						<input type="text" name="member_name" id="member_name" placeholder="<cfoutput>#getLang('main',107)#</cfoutput>" value="<cfif len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=form_law_request.member_name&field_comp_id=form_law_request.company_id&field_consumer=form_law_request.consumer_id&field_member_name=form_law_request.member_name&select_list=2,3','list');</cfoutput>" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
					</div>
				</div>
				<div class="form-group">
					<cfquery name="GET_LAW_STAGE" datasource="#DSN#">
						SELECT
							PTR.STAGE,
							PTR.PROCESS_ROW_ID 
						FROM
							PROCESS_TYPE_ROWS PTR,
							PROCESS_TYPE_OUR_COMPANY PTO,
							PROCESS_TYPE PT
						WHERE
							PT.IS_ACTIVE = 1 AND
							PTR.PROCESS_ID = PT.PROCESS_ID AND
							PT.PROCESS_ID = PTO.PROCESS_ID AND
							PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ch.list_law_request%">
					</cfquery>
					<select name="process_stage_type" id="process_stage_type" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="GET_LAW_STAGE">
							<option value="#process_row_id#">#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="request_status" id="request_status" style="width:80px;">
						<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="1" <cfif attributes.request_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
						<option value="0" <cfif attributes.request_status eq 0>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(160,'İcra Takip İşlemleri',50133)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="57800.İşlem tipi"></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='50132.Dosya No'></th>
					<th><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='61427.Lehdar'><cf_get_lang dictionary_id='57578.Yetkili'></th>
					<th><cf_get_lang dictionary_id='61428.Lehdar Bilgisi'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='50127.Alacak Tutarı'></th>
					<th><cf_get_lang dictionary_id='57845.Tahsilat'></th>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th><cf_get_lang dictionary_id ='58054.Süreç - Aşama'></th>
					<!-- sil --><th width="20" class="header_icn_none"  nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ch.list_law_request&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_law_request.recordcount>
				<cfset list_company_id=''>
				<cfset list_consumer_id=''>
				<cfset process_list=''>
				<cfset process_cat_list=''>
				<cfoutput query="get_law_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(company_id) and not listfind(list_company_id,company_id)>
						<cfset list_company_id = listappend(list_company_id,company_id)>
					</cfif>
					<cfif len(consumer_id) and not listfind(list_consumer_id,consumer_id)>
						<cfset list_consumer_id = listappend(list_consumer_id,consumer_id)>
					</cfif>
					<cfif len(process_stage) and not listfind(process_list,process_stage)>
						<cfset process_list = listappend(process_list,process_stage)>
					</cfif>
					<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
						<cfset process_cat_list = listappend(process_cat_list,process_cat)>
					</cfif>
				</cfoutput>
				<cfif len(list_company_id)>
					<cfset list_company_id=listsort(list_company_id,"numeric","ASC",",")>
					<cfquery name="get_company_name" datasource="#DSN#">
						SELECT COMPANY_ID,FULLNAME,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#list_company_id#) ORDER BY COMPANY_ID
					</cfquery>
					<cfset list_company_id = listsort(listdeleteduplicates(valuelist(get_company_name.company_id,',')),'numeric','ASC',',')>
				</cfif> 
				<cfif len(list_consumer_id)>
					<cfset list_consumer_id=listsort(list_consumer_id,"numeric","ASC",",")>
					<cfquery name="get_consumer_name" datasource="#DSN#">
						SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#list_consumer_id#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset list_consumer_id = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
				</cfif> 
				<cfif len(process_list)>
					<cfset process_list=listsort(process_list,"numeric","ASC",",")>
					<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
						SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
					</cfquery>
					<cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
				</cfif> 
				<cfif len(process_cat_list)>
					<cfset process_cat_list=listsort(process_cat_list,"numeric","ASC",",")>
					<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
						SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_list#)
					</cfquery>
					<cfset process_cat_list = listsort(listdeleteduplicates(valuelist(get_process_cat.process_cat_id,',')),'numeric','ASC',',')>
				</cfif> 
				<cfoutput query="get_law_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><cfif len(process_cat_list)>#get_process_cat.process_cat[listfind(process_cat_list,process_cat,',')]#</cfif></td>
						<td>
							<cfif len(company_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_company_name.fullname[listfind(list_company_id,company_id,',')]#</a>
							<cfelseif len(consumer_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_name.consumer_name[listfind(list_consumer_id,consumer_id,',')]# #get_consumer_name.consumer_surname[listfind(list_consumer_id,consumer_id,',')]#</a>
							</cfif>
						</td>
						<td><a href="#request.self#?fuseaction=ch.list_law_request&event=upd&id=#law_request_id#" class="tableyazi">#file_number#</a></td>
						<td>
							<cfif len(obligee_company_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#obligee_company_id#','medium');">#get_par_info(obligee_company_id,1,-1,0)#</a>
							<cfelseif len(obligee_consumer_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#obligee_consumer_id#','medium');">#get_cons_info(get_law_request.obligee_consumer_id,0,0)#</a>
							</cfif>
						</td>
						<td>
							<cfif len(obligee_partner_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&company_id=#obligee_company_id#','medium');">#get_par_info(get_law_request.obligee_partner_id,0,-1,0)#</a>
							<cfelseif len(obligee_consumer_id)>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#obligee_consumer_id#','medium');">#get_cons_info(get_law_request.obligee_consumer_id,0,0)#</a>
							</cfif>
						</td>
						<td>#obligee_detail#</td>
						<td>#dateformat(revenue_date,dateformat_style)#</td>
						<td style="text-align:right;"><cfif len(total_amount) and total_amount gt 0>#total_amount# #money_currency#<cfelse>0</cfif></td>
						<td style="text-align:right;"><cfif len(total_revenue) and total_revenue gt 0>#total_revenue# #total_revenue_money_currency#<cfelse>0</cfif></td>
						<td style="text-align:right;"><cfif len(kalan_revenue) and kalan_revenue gt 0>#kalan_revenue# #kalan_revenue_money_currency#<cfelse>0</cfif></td>
						<td><cfif len(process_list)>#get_process_type.stage[listfind(process_list,process_stage,',')]#</cfif></td>
						<!-- sil --><td align="center"><a href="#request.self#?fuseaction=ch.list_law_request&event=upd&id=#law_request_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->  
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="13"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif isdefined ("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.file_number)>
			<cfset url_str = "#url_str#&file_number=#attributes.file_number#">
		</cfif> 
		<cfif len(attributes.request_status)>
			<cfset url_str = "#url_str#&request_status=#attributes.request_status#">
		</cfif> 
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif> 
		<cfif len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif> 
		<cfif len(attributes.member_name)>
			<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
		</cfif> 
		<cfif len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="ch.list_law_request#url_str#">
	</cf_box>
</div>	
<script type="text/javascript">
	document.getElementById('file_number').focus();
</script>
