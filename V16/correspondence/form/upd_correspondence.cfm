<cf_catalystHeader>
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.start_date" default="">
<cfinclude template="../query/get_det_correspondence.cfm">
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT CORRCAT_ID,DETAIL,CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery> 
<cfscript>
	to_list = "";
	cc_list = "";
</cfscript>
<cfloop list="#get_det_correspondence.to_emp#" index="i">
	<cfset to_list = to_list & 'emp-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.to_pars#" index="i">
	<cfset to_list = to_list & 'par-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.to_cons#" index="i">
	<cfset to_list = to_list & 'con-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.to_adr#" index="i">
	<cfset to_list = to_list & 'adr-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.cc_emp#" index="i">
	<cfset cc_list = cc_list & 'emp-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.cc_pars#" index="i">
	<cfset cc_list = cc_list & 'emp-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.cc_cons#" index="i">
	<cfset cc_list = cc_list & 'emp-#i#,'>
</cfloop>
<cfloop list="#get_det_correspondence.cc_adr#" index="i">
	<cfset cc_list = cc_list & 'emp-#i#,'>
</cfloop>
<cfif fuseaction contains "popup">
	<cfset is_popup = 1>
<cfelse>
	<cfset is_popup = 0>
</cfif>

<div class="col col-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58718.Düzenle'></cfsavecontent>
	<cf_box title='#title#' resize="1">
		<cfform name="form_add_correspondence" enctype="multipart/form-data" action="#request.self#?fuseaction=correspondence.upd_correspondence_process&id=#url.id#" method="POST">
			<input type="hidden" name = "id" value="<cfoutput>#url.id#</cfoutput>">
				<cf_box_elements vertical="1">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='51184.Yazışma No'></label>
							<input type="text" name="correspondence_number" id="correspondence_number" style="width:83px;" maxlength="50" value="<cfoutput>#get_det_correspondence.correspondence_number#</cfoutput>">
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58859.Süreç'></label>
							<cf_workcube_process is_upd='0' select_value='#get_det_correspondence.cor_stage#' process_cat_width='100' is_detail='1'>
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57630.tip'></label>
							<cf_wrk_special_definition width_info="85" type_info='4' field_id="special_definition_id" selected_value='#get_det_correspondence.special_definition_id#'>
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='58640.Şablon'></label>
							<select name="CORRCAT_ID" style="text-align:right">
								<option value="" selected> <cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_cat">
									<option value="#corrcat_id#"<cfif isDefined("attributes.corrcat_id") and (attributes.corrcat_id eq corrcat_id)>selected<cfelseif get_det_correspondence.category eq corrcat_id>selected</cfif>>#corrcat#</option>
								</cfoutput>
							</select>
							<cfoutput>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_correspondence&action=pdf&id=#url.id#&module=correspondence','page')"></a>
							</cfoutput>
						</div>
					</div>        
					<div class="col col-12">
						<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12"> 
							<label><cf_get_lang dictionary_id='48076.Gönderilen'></label>
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#to_list#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='51067.Gönderilecek Kişi !'></cfsavecontent>
								<cfinput type="text" name="emp_name" required="yes" message="#message#" value="#get_det_correspondence.mail_to#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=form_add_correspondence.emp_id&names=form_add_correspondence.emp_name')"></span>
							</div>
						</div>
						<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
							<label><cf_get_lang dictionary_id='51073.Bilgi Verilen'></label>
							<div class="input-group">
								<input type="hidden" name="emp_id_cc" id="emp_id_cc" value="<cfoutput>#cc_list#</cfoutput>">
								<cfinput type="text" name="emp_name_cc" value="#get_det_correspondence.mail_cc#"onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=form_add_correspondence.emp_id_cc&names=form_add_correspondence.emp_name_cc')"></span>
							</div>
						</div>
                        
					</div> 
					<div class="col col-12">
                        <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='57480.Konu'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu !'></cfsavecontent>
							<cfinput type="text" name="subject" id="subject" required="Yes" message="#message#" value="#get_det_correspondence.subject#">
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='58053.başlangıç tarihi'></cfsavecontent>
								<cfinput type="text" name="start_date" id="start_date" value="#dateformat(get_det_correspondence.cor_startdate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" style="width:70px;" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="form-group col col-2 col-md-3 col-sm-3">
                            <label><cf_get_lang dictionary_id='57691.Dosya'></label>
							<input type="hidden" name="old_attachment" id="old_attachment" value="<cfoutput>#get_det_correspondence.attachment_file#</cfoutput>">
							<input type="file" name="attachment" id="attachment" style="width:300px;">
                        </div>
					</div>
					<cfif get_det_correspondence.attachment_file neq ''>
						<div class="form-group col col-2 col-md-3 col-sm-3"> 
							<label><strong><cf_get_lang dictionary_id='51111.Ekli Dosya'></strong>: <cfoutput><a href="#file_web_path#emp_mails/#get_det_correspondence.record_emp#/sendbox/attachments/#get_det_correspondence.attachment_file#" target="_blank" class="tableyazi">#get_det_correspondence.attachment_file#</a></cfoutput></label>
						</div>
					</cfif>
					<cfset attributes.employee_id = get_det_correspondence.record_emp>
					<cfinclude template="../query/get_employee_name.cfm">
					<!---<div class="col col-12">
						<div class="form-group col col-1 col-md-3 col-sm-3 col-xs-6">
							<label><cf_get_lang dictionary_id='81.Aktif'></label>
							<input type="checkbox" name="is_read" id="is_read" value="0" width="50" alt="<cf_get_lang dictionary_id ='81.Aktif'>" <cfif get_det_correspondence.is_read eq 0>checked</cfif>>
						</div>
						<div class="form-group col col-1 col-md-3 col-sm-3 col-xs-6">
							<label><cf_get_lang dictionary_id='63.Mail Gönder'></label>
							<input type="checkbox" name="email" id="email" value="email" width="50" alt="<cf_get_lang dictionary_id ='63.Mail Gönder'>">
						</div>
					</div>--->
				</cf_box_elements>
				<cfif isdefined("attributes.CORRCAT_ID")>
					<cfinclude template="../query/get_corrs.cfm">   
					<cfset template = SETUP_CORR.DETAIL>
				<cfelse>
					<cfset template = get_det_correspondence.message>
				</cfif>
				<cfmodule template="/fckeditor/fckeditor.cfm"
					toolbarset="Default"
					basepath="/fckeditor/"
					instancename="message"
					value="#get_det_correspondence.message#"
					width="100%"
					height="400">
				<cf_box_footer>
					<cf_record_info query_name="get_det_correspondence">
						<cf_workcube_buttons 
						is_upd='1' type_format="1"
						delete_page_url='#request.self#?fuseaction=correspondence.emptypopup_del_correspondence&id=#url.id#&head=#get_det_correspondence.subject#' 
						add_function='sendEmail()'>
				</cf_box_footer>
			</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	<cfif isdefined("attributes.corrcat_id")>
		document.form_add_correspondence.special_definition_id.value = '<cfoutput>#attributes.special_definition_id#</cfoutput>';
		document.getElementById('start_date').value = '<cfoutput>#attributes.start_date#</cfoutput>';
		document.getElementById('correspondence_number').value = '<cfoutput>#attributes.correspondence_number#</cfoutput>';
		document.getElementById('emp_id').value = '<cfoutput>#attributes.emp_id#</cfoutput>';
		document.getElementById('emp_name').value = '<cfoutput>#attributes.emp_name#</cfoutput>';
		document.getElementById('emp_id_cc').value = '<cfoutput>#attributes.emp_id_cc#</cfoutput>';
		document.getElementById('emp_name_cc').value = '<cfoutput>#attributes.emp_name_cc#</cfoutput>';
		document.getElementById('subject').value = '<cfoutput>#attributes.subject#</cfoutput>';
		document.getElementById('attachment').value = '<cfoutput>#attributes.attachment#</cfoutput>';
		<cfif isdefined("attributes.is_read")>
			document.getElementById('is_read').checked = true;
		<cfelse>
			document.getElementById('is_read').checked = false;
		</cfif>
		<cfif isdefined("attributes.email")>
			document.getElementById('email').checked = true;
		<cfelse>
			document.getElementById('email').checked = false;
		</cfif>
	</cfif>	
	function temizle(obj_name)
	{
		if(obj_name == 1)
		{
			document.getElementById('emp_id').value='';
			document.getElementById('emp_name').value='';
		}
		if(obj_name == 2)
		{
			document.getElementById('emp_id_cc').value='';
			document.getElementById('emp_name_cc').value='';
		}
	} 
	function sendEmail()
	{
		 if ((document.getElementById('email').checked == true) && (document.getElementById('emp_name').value == ""))
		 {
			 alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='51067.Gönderilecek Kişi !'>");
			 return false;
		 }
		 if (document.getElementById('subject').value == "")
		 {
			 alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu !'>");
			 return false;
		 }		 
		return true;		 
	}
</script>
