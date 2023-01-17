<cfparam name="attributes.modal_id" default="">
<cfset attributes.act = replace(replace(attributes.act,'|','&','all'),'-','=','all') />
<cfquery name="select_this_denides" datasource="#dsn#">
	SELECT 
		DPL.*,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
		EP.POSITION_CODE
	FROM 
		DENIED_PAGES_LOCK DPL,
		EMPLOYEE_POSITIONS EP
	WHERE 
		DPL.DENIED_PAGE = '#attributes.act#' AND
		DPL.POSITION_CODE = EP.POSITION_CODE
</cfquery>
<cfquery name="get_comp" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD ORDER BY PERIOD
</cfquery>
<cfquery name="get_denied_pages_" datasource="#dsn#">
	SELECT
		DENIED_PAGE
	FROM
		DENIED_PAGES_LOCK
	WHERE
		DENIED_PAGE LIKE '%#attributes.act#%'
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kayıt Kilidi',29982)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_notes" method="post" action="#request.self#?fuseaction=objects.emptypopup_denied_pages_lock">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="1">
					<input type="hidden" name="del_denied_id" id="del_denied_id" value="">
					<div class="form-group" id="item-denied_page">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57581.Sayfa'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="denied_page" id="denied_page" value="<cfoutput>#urlDecode(attributes.act)#</cfoutput>" readonly>
						</div>
					</div>
					<cfif not select_this_denides.recordcount>
						<div class="form-group" id="item-period_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32483.Dönem Kontrol Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="period_control" id="period_control" value="1">
							</div>
						</div>	
						<div class="form-group" id="item-company_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32485.Şirket Kontrol Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="company_control" id="company_control" value="1">
							</div>
						</div>	
						<div class="form-group" id="item-company_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32660.Kilit Tipi'> <cf_get_lang dictionary_id='58575.İzin'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="denied_type" id="denied_type" value="1" checked>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-period_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32483.Dönem Kontrol Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="period_control" id="period_control" value="1" <cfif listlen(select_this_denides.period_id)>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-company_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32485.Şirket Kontrol Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="company_control" id="company_control" value="1" <cfif listlen(select_this_denides.our_company_id)>checked</cfif>>
							</div>
						</div>    
						<div class="form-group" id="item-company_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32660.Kilit Tipi'><cf_get_lang dictionary_id='58575.İzin'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="denied_type" id="denied_type" value="1" <cfif select_this_denides.denied_type eq 1>checked</cfif>>
							</div>
						</div>
						
					</cfif>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" index="2">
					<cfif select_this_denides.recordcount>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cf_workcube_to_cc 
								is_update="1" 
								to_dsp_name="#getLang('','Kullanıcılar','58992')#" 
								form_name="add_notes" 
								str_list_param="1" 
								action_dsn="#DSN#"
								str_action_names="POSITION_CODE AS TO_POS_CODE"
								action_table="DENIED_PAGES_LOCK"
								action_id_name="DENIED_PAGE"
								action_id="#select_this_denides.DENIED_PAGE#"
								data_type="2">
						</div>
					<cfelse>
						<cfif isdefined("attributes.pages_id") and len(attributes.pages_id)>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<cf_workcube_to_cc 
									is_update="1" 
									to_dsp_name="#getLang('','Kullanıcılar','58992')#" 
									form_name="add_notes" 
									str_list_param="1" 
									action_dsn="#DSN#"
									str_action_names="EMPLOYEE_ID AS to_emp"
									action_table="WORKGROUP_EMP_PAR"
									action_id_name="WORKGROUP_ID"
									action_id="#attributes.pages_id#"
									data_type="2">
							</div>
						<cfelse>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<cf_workcube_to_cc is_update="0" to_dsp_name="#getLang('','Kullanıcılar','58992')#" form_name="add_notes" str_list_param="1" data_type="1">
							</div>
						</cfif>
					</cfif>
				</div>
				<div class="col col-12 col-xs-12" style="padding-left:10px;">
					<label><font color="red"><cf_get_lang dictionary_id='60260.Kilit Tipi seçili olursa yukarıdaki kullanıcılar sayfaya girer! Seçili olmazsa yukarıdaki kullanıcılar dışındaki diğer kullanıcılar girer'>!</font></label>
				</div>
			</cf_box_elements>
			<div class="row">
				<div class="col col-6">
					<cf_grid_list table_width="450">
						<thead>
							<th><cf_get_lang dictionary_id='29531.Şirketler'></th>
							<th width="20"></th>
						</thead>
						<cfoutput query="get_comp">
							<tbody>
								<td>#nick_name#</td>
								<td class="text-center"><input type="checkbox" name="our_company_id" id="our_company_id" value="#comp_id#" <cfif select_this_denides.recordcount and listfindnocase(select_this_denides.OUR_COMPANY_ID,comp_id)>checked</cfif>></td>
							</tbody>
						</cfoutput>
					</cf_grid_list>
				</div>
				<div class="col col-6">
					<cf_grid_list table_width="450">
						<thead>
							<th><cf_get_lang dictionary_id='32476.Dönemler'></th>
							<th width="20"></th>
						</thead>
						<cfoutput query="get_periods">
							<tbody>
								<td>#PERIOD#</td>
								<td class="text-center"><input type="checkbox" name="period_id" id="period_id" value="#period_id#" <cfif select_this_denides.recordcount and listfindnocase(select_this_denides.PERIOD_ID,period_id)>checked</cfif>></td>
							</tbody>
						</cfoutput>
					</cf_grid_list>
				</div>
			</div>
			<cf_box_footer>
				<div class="col col-6">
					<cfif len(select_this_denides.update_emp)>
						<cf_record_info query_name="select_this_denides">
					</cfif>
				</div>
				<div class="col col-6">
					<cfif select_this_denides.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='1' del_function="del_kontrol()" add_function='kontrol()'>
					<cfelse>
						<cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'>
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById('company_control').checked == true && document.getElementById('period_control').checked == true)
	{
		alert("<cf_get_lang dictionary_id='60264.Hem Şirket Hem Dönem Kontrolü yapamazsınız'>!");
		return false;
	}
	if(document.add_notes.company_control.checked==true)
	{
		kontrol_ = 1;
		<cfif get_comp.recordcount eq 1>
			if(document.add_notes.our_company_id.checked==true)
				kontrol_ = 0;
		<cfelse>
			<cfoutput query="get_comp">
				if(document.add_notes.our_company_id[#currentrow#-1].checked==true)
					kontrol_ = 0;
			</cfoutput>
		</cfif>
		if(kontrol_==1)
		{
			alert("<cf_get_lang dictionary_id='55700.Şirket Seçmelisiniz!'>");
			return false;
		}
	}
		
	if(document.add_notes.period_control.checked==true)
	{
		kontrol_ = 1;
		
		<cfif get_periods.recordcount eq 1>
			if(document.add_notes.period_id.checked==true)
				kontrol_ = 0;
		<cfelse>
			<cfoutput query="get_periods">
				if(document.add_notes.period_id[#currentrow#-1].checked==true)
					kontrol_ = 0;
			</cfoutput>
		</cfif>
		if(kontrol_==1)
		{
			alert("<cf_get_lang dictionary_id='43274.Dönem Seçmelisiniz'>!");
			return false;
		}
	}
	kontrol_ = 0;
	<cfif get_periods.recordcount eq 1>
		if(kontrol_ == 0 && document.add_notes.period_control.checked==false && document.add_notes.period_id.checked==true)
			kontrol_ = 1;
	<cfelse>
		<cfoutput query="get_periods">
			if(kontrol_ == 0 && document.add_notes.period_control.checked==false && document.add_notes.period_id[#currentrow#-1].checked==true)
				kontrol_ = 1;
		</cfoutput>
	</cfif>
	if(kontrol_==1)
	{
		alert("<cf_get_lang dictionary_id='60265.Dönem Seçtiniz'>! <cf_get_lang dictionary_id='60266.Dönem Kontrol Yapılsın Seçmelisiniz'>!");
		return false;
	}
	kontrol_ = 0;
	<cfif get_comp.recordcount eq 1>
		if(kontrol_ == 0 && document.add_notes.company_control.checked==false && document.add_notes.our_company_id.checked==true)
			kontrol_ = 1;
	<cfelse>
		<cfoutput query="get_comp">
			if(kontrol_ == 0 && document.add_notes.company_control.checked==false && document.add_notes.our_company_id[#currentrow#-1].checked==true)
				kontrol_ = 1;
		</cfoutput>
	</cfif>
	if(kontrol_==1)
	{
		alert("<cf_get_lang dictionary_id='60267.Şirket Seçtiniz'>! <cf_get_lang dictionary_id='60268.Şirket Kontrol Yapılsın Seçmelisiniz'>!");
		return false;
	}
	
	<cfif isdefined("attributes.draggable")>loadPopupBox('add_notes' , <cfoutput>#attributes.modal_id#</cfoutput>); return false;<cfelse>return true;</cfif>
}
function del_kontrol()
{
	add_notes.del_denied_id.value = 1;
	<cfif isdefined("attributes.draggable")>loadPopupBox('add_notes' , <cfoutput>#attributes.modal_id#</cfoutput>); return false;<cfelse>return true;</cfif>
}

</script>
