<cf_box title="#getLang('','Workshare',61915)#" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="warning" method="post" action="#request.self#?fuseaction=myhome.emptypopup_add_warning">
		<input name="record_num" id="record_num" type="hidden" value="0">
		<cfoutput>
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<div class="col col-12 col-xs-12">
							<textarea name="warning_description" id="warning_description" style="height:80px;" placeholder="<cf_get_lang dictionary_id='61081.Bildirimi Yazınız'>*"></textarea>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<cfif isdefined("attributes.act") and not len(attributes.act)><cfset attributes.act = 'myhome.welcome'></cfif>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='30973.Bağlantı Yolu'>*</label>
						<div class="col col-12">
							<input type="text" name="url_link_dsp" id="url_link_dsp" value="<cfif isdefined("attributes.act")>#employee_domain##request.self#?fuseaction=#attributes.act#</cfif>" disabled="disabled">
							<input type="hidden" name="url_link"  id="url_link" value="<cfif isdefined("attributes.act")>#request.self#?fuseaction=#attributes.act#</cfif>">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='61082.Erişim Kodu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="text" name="access_code" id="access_code" readonly>
								<span class="input-group-addon">
									<i class="fa fa-lock" onclick="setAccessCode(this)"></i>
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='61084.Paylaşım Tipi'>*</label>
						<div class="col col-12">
							<select name="is_checker_update_authority" id="is_checker_update_authority">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0"><cf_get_lang dictionary_id='38734.Görüntüle'></option>
								<option value="1"><cf_get_lang dictionary_id='57464.Güncelle'></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='61083.Bildirim Tipi'>*</label>
						<div class="col col-12">
							<select name="notice_type" id="notice_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='61054.Yorum Al'></option>
								<option value="2"><cf_get_lang dictionary_id='30389.Onay İste'></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='61085.Ortam'></label>
						<div class="col col-12">
							<select name="notice_type" id="notice_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='30430.Tüm Çalışanlar'> - <cf_get_lang dictionary_id='29659.Intranet'></option>
								<option value="2"><cf_get_lang dictionary_id='36219.Tüm Kurumsal Üyeler'> - <cf_get_lang dictionary_id='58019.Extranet'></option>
								<option value="3"><cf_get_lang dictionary_id='36215.Tüm Bireysel Üyeler'> - <cf_get_lang dictionary_id='40213.Internet'></option>
								<option value="4"><cf_get_lang dictionary_id='62427.Workchain'></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="text" name="warning_password" id="warning_password" readonly>
								<span class="input-group-addon">
									<i class="fa fa-key" onclick="if(document.getElementById('access_code').value != '') document.getElementById('warning_password').value = Math.floor(Math.random() * 999999) + 1;"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='31431.Son cevap'>*</label>
						<div class="col col-6 col-md-6 col-xs-12">
							<div class="input-group">
								<input type="text" name="response_date0" id="response_date0" required="yes" maxlength="10" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">
								<span class="input-group-addon"><cf_wrk_date_image date_field="response_date0"></span>
							</div>
						</div>
						<div class="col col-3 col-md-3 col-xs-12">
							<cf_wrkTimeFormat name="response_clock0" id="response_clock0" value="#NumberFormat('0','00')#">
						</div>
						<div class="col col-3 col-md-3 col-xs-12">
							<select name="response_min0" id="response_min0">
								<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
								</cfloop>			  
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='61086.Ajandaya Kaydet'><input type="checkbox" name="is_agenda" id="is_agenda" value="1" /></div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='61088.Paylaşım Yapılanlar'>*</cfsavecontent>
						<cf_workcube_to_cc 
							is_update="0" 
							to_dsp_name="#txt_1#" 
							form_name="warning" 
							str_list_param="1,7,8" 
							data_type="1"> 
					</div>
				</div>
			</cf_box_elements>
		</cfoutput>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
					<!---
					<div class="form-group">
						<label class="col col-3 col-md-3 col-xs-12"><cf_get_lang no='675.Email Uyarı'></label>
						<div class="col col-9 col-md-9 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message2"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz '>!</cfsavecontent>
								<cfinput validate="#validate_style#" message="#message2#" type="text" name="email_startdate0" maxlength="10" >
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="email_startdate0"></span>
								<span class="input-group-addon no-bg"></span>
								<span class="input-group-addon no-bg">
									<cf_wrkTimeFormat name="email_start_clock0" id="email_start_clock0" value="#NumberFormat('0','00')#">
								</span>
								<span class="input-group-addon no-bg">
									<select name="email_start_min0" id="email_start_min0">
										<cfloop from="0" to="55" index="a" step="5">
										<cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
										</cfloop>			  
									</select>	
								</span>
							</div>
						</div>
					</div>
					--->
					
					<!--- <div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30828.Talep'></label>
						<cfquery name="get_setup_warning" datasource="#dsn#">
							SELECT * FROM SETUP_WARNINGS ORDER BY SETUP_WARNING
						</cfquery>
						<div class="col col-9 col-md-9 col-xs-12">
							<select name="warning_head0" id="warning_head0">
								<cfoutput query="get_setup_warning">
									<option value="#setup_warning#-#setup_warning_id#">#setup_warning#</option>
								</cfoutput>  
							</select>
						</div>
					</div> --->	
<script type="text/javascript">
	<cfif not isdefined("attributes.act")>
		document.warning.url_link.value = '<cfoutput>#request.self#?fuseaction=</cfoutput>'+list_getat(window.location,2,'fuseaction=');
		document.warning.url_link_dsp.value = '<cfoutput>#employee_domain##request.self#?fuseaction=</cfoutput>'+list_getat(window.location,2,'fuseaction=');
	</cfif>
	$(document).ready(function(){
		row_count=0;
		main_row_count=0;
		sayac = 0;
		
	});
	function loader_page()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.popup_list_warning</cfoutput>','warnings_div_',1);
		return false;
	}
	function autocomp(no)
	{
		AutoComplete_Create("employee" + no,"MEMBER_NAME,MEMBER_PARTNER_NAME2","MEMBER_PARTNER_NAME2,MEMBER_NAME2","get_member_autocomplete","\'1,2,3\'","POSITION_CODE","position_code" + no,"warning",3,220);
	}

	function kontrol(){
		if(document.getElementById("warning_description").value.length == 0) 
		{
			alert("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>");
			return false;
		}else if (document.warning.warning_description.value.length>1000)
		{
			alert("<cf_get_lang dictionary_id ='31775.Açıklama Alanı Uzunluğu 1000 karakterden fazla olamaz'>!");    
			return false;		
		}
		if(document.getElementById("is_checker_update_authority").value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='61084.Paylaşım Tipi'>!");
			return false;
		}
		if(document.getElementById("notice_type").value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='61083.Bildirim Tipi'>!");
			return false;
		}
		if(document.getElementById("tbl_to_names_row_count").value == "" || document.getElementById("tbl_to_names_row_count").value == 0)
		{
			alert("<cf_get_lang dictionary_id = '53730.En Az Bir Kişi Seçmelisiniz'>!");
			return false;
		}
		if(document.getElementById("response_date0").value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='30767.Son Cevap Tarihi'>!");
			return false;
		}
		return true;
	}
	
	function setAccessCode(element){
		if(element.classList.contains('fa-lock')){
			document.getElementById('access_code').value = '<cfoutput>#CreateUUID()#</cfoutput>';
			document.getElementById('warning_password').removeAttribute('readonly');
			element.classList.remove('fa-lock');
			element.classList.add('fa-unlock');
		}else{
			document.getElementById('access_code').value = '';
			document.getElementById('warning_password').value = '';
			document.getElementById('warning_password').setAttribute('readonly','');
			element.classList.remove('fa-unlock');
			element.classList.add('fa-lock');
			
		}
	}

</script>