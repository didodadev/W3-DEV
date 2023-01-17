<cf_papers paper_type="correspondence">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfset correspondence_no = system_paper_no>
<cfparam name="attributes.work_head" default="">
<cfparam name="attributes.subject" default="">
<cfparam name="attributes.mail_from" default="">
<cfparam name="attributes.mail_to" default="">
<cfparam name="attributes.mail" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.correspondence_number" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="mail_body" default="">
<cfset work_company_id = ''>
<cfset work_company_name = ''>
<cfset work_partner_id = ''>
<cfset work_partner_name = ''>
<!---
	yazışma ekle ekranında
to_mail_id = 0 gelyor
	 eğer üye detayından yazışma eklersek
to_mail_id = üye id
membertype = consumer vs geliyor--->
<cfif isdefined('attributes.to_mail_id') and (isdefined("attributes.member_type") and attributes.member_type is 'consumer')>
	<cfquery name="get_Cuns_mail_address" datasource="#DSN#">
		SELECT	
			CONSUMER_EMAIL
		FROM	   
			CONSUMER
		WHERE
			CONSUMER_ID	= #attributes.to_mail_id#		
	</cfquery>
</cfif>
<cfif isDefined('attributes.cpid')>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_EMAIL
		FROM
			COMPANY_PARTNER
		WHERE 
			PARTNER_ID = #attributes.cpid#
	</cfquery>
</cfif>
<cfif isdefined('attributes.to_mail_id') and (isdefined("attributes.member_type") and attributes.member_type is 'company')>
	<cfquery name="get_mail_address" datasource="#DSN#">
		SELECT	
			COMPANY_EMAIL
		FROM	   
			COMPANY
		WHERE
			COMPANY_ID	= #attributes.to_mail_id#		  
	</cfquery>
</cfif>
<cfif isdefined('attributes.mail_id')>
	<cfquery name="get_mail_info" datasource="#DSN#">
		SELECT
			MAIL_TO,			
			MAIL_FROM,
			SUBJECT,
			CONTENT_FILE
		FROM	   
			MAILS
		WHERE
			MAIL_ID	= #attributes.mail_id#		  
	</cfquery>
  <cfif FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.CONTENT_FILE#")> 
  <cffile action="read" file="#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.CONTENT_FILE#" variable="mail_body" charset ="UTF-8">
  </cfif>
</cfif>
<cfif isdefined("get_mail_info.recordcount")>
	<cfset attributes.work_head = get_mail_info.subject>
</cfif>
<cfif isdefined('attributes.mail_id')>
	<cfset attributes.type = 1>
	<cfinclude template="../query/mail_control.cfm">
</cfif>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT CORRCAT_ID,DETAIL,CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery>
<cf_catalystHeader>
<div class="col col-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='58718.Düzenle'></cfsavecontent>
    <cf_box title="#title#" resize="1">
        <cfform name="form_add_correspondence" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=correspondence.add_correspondence_process">
            <input type="hidden" width="50" name="email" id="email" value="<cfif len(attributes.email)><cfoutput>#attributes.email#</cfoutput></cfif>">
                <input type="hidden" name="system_paper_no_add" id="system_paper_no_add" value="<cfif isdefined('system_paper_no_add')><cfoutput>#system_paper_no_add#</cfoutput></cfif>">
                <cf_box_elements vertical="1">
                    <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='51184.Yazışma No'></label>
                        <input type="text" name="correspondence_number" id="correspondence_number" value="" style="width:88px;" maxlength="50">
                    </div>
                    <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'>
                    </div>
                    <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57630.Tip'></label>
                        <cf_wrk_special_definition width_info="85" type_info='4' field_id="special_definition_id">
                    </div>
                    <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58640.Şablon'></label>
                        <select name="CORRCAT_ID" id="CORRCAT_ID"  onchange="document.form_add_correspondence.action = '';document.form_add_correspondence.submit();">
                            <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_cat">
                                <option value="#corrcat_id#"<cfif isDefined("attributes.corrcat_id") and (attributes.corrcat_id eq corrcat_id)> selected</cfif>>#corrcat#</option>
                            </cfoutput>
                        </select>
                    </div>
                    
                    <div class="form-group">
                    <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='48076.Gönderilen'></label>
                        <div class="input-group">
                            <cfif isdefined("attributes.mail_id") and not isdefined("attributes.to_mail_id") and not isdefined("attributes.cpid")>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="">
                                <cfinput type="text" name="emp_name" style="width:500px;" value="#get_mail_info.mail_to#">
                            <!---<cfelseif not isdefined("attributes.to_mail_id") and (isdefined("attributes.member_type") and attributes.member_type is 'company') and isdefined("attributes.cpid")>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="comp-#attributes.to_mail_id#">
                                <cfinput type="text" name="emp_name" style="width:500px;" value="#get_mail_address.company_email#">--->
                            <cfelseif isdefined("attributes.to_mail_id") and (isdefined("attributes.member_type") and attributes.member_type is 'company') and isdefined("attributes.cpid")>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="par-#attributes.to_mail_id#">
                                <cfinput type="text" name="emp_name" style="width:500px;" value="#get_partner.company_partner_email#">
                            <cfelseif isdefined("attributes.cpid")>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="par-#attributes.cpid#">
                                <cfinput type="text" name="emp_name" style="width:500px;" value="#get_partner.company_partner_email#">
                            <cfelseif isdefined("attributes.to_mail_id") and (isdefined("attributes.member_type") and attributes.member_type is 'consumer') and not isdefined("attributes.cid")>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="con-#attributes.to_mail_id#">
                                <cfinput type="text" name="emp_name" style="width:500px;" value="#get_Cuns_mail_address.CONSUMER_EMAIL#">
                            <cfelse>
                                <cfinput type="hidden" name="emp_id" id="emp_id" value="">
                                <cfinput type="text" name="emp_name" id="emp_name" style="width:500px;" value="" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
                            </cfif>
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=form_add_correspondence.emp_id&names=form_add_correspondence.emp_name')"></span>       
                        </div>
                    </div> 
                    <div class="form-group col col col-4 col-md-5 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='51073.Bilgi Verilen'></label>
                        <div class="input-group">
                            <input type="hidden" id="emp_id_cc" name="emp_id_cc">
                            <cfif isdefined("attributes.mail_id")>
                                <cfinput type="text" name="emp_name_cc"  style="width:500px;" value="#get_mail_info.mail_from#">
                            <cfelse>
                                <cfinput type="text" name="emp_name_cc"  style="width:500px;" value="" onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_cc');">
                            </cfif>
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=form_add_correspondence.emp_id_cc&names=form_add_correspondence.emp_name_cc')"></span>
                        </div>
                    </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <cfif isdefined("attributes.mail_id")>
                            <cfinput type="text" name="subject" style="width:500px;" maxlength="100" value="#attributes.work_head#">
                        <cfelse>
                            <cfinput type="text" name="subject" style="width:500px;" maxlength="100" value="">
                        </cfif> 
                    </div>
                    <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='58053.başlangıç tarihi'></cfsavecontent>
                            <cfinput validate="#validate_style#" required="yes" message="#message#" type="text" id="start_date" name="start_date" style="width:75px;" maxlength="10" value="#dateformat(now(),dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                    <div class="form-group col col-2 col-md-3 col-sm-3">
                        <label><cf_get_lang dictionary_id='57691.Dosya'></label>
                        <input name="attachment" type="file" style="width:300px;">
                    </div>
                    
                    <!---<div class="form-group col col-1 col-md-3 col-sm-3 col-xs-6">
                        <label><cf_get_lang dictionary_id='81.Aktif'></label>
                        <input type="checkbox" width="50" name="is_read" id="is_read" value="0" alt="<cf_get_lang dictionary_id='81.Aktif'>" checked>
                    </div> 
                    <div class="form-group col col-1 col-md-3 col-sm-3 col-xs-6">
                        <label><cf_get_lang dictionary_id='63.Mail Gönder'></label>
                        <input type="checkbox" width="50" name="email" id="email" value="email" alt="<cf_get_lang dictionary_id='63.Mail Gönder'>">
                    </div>--->
                    <cfif isdefined("attributes.CORRCAT_ID")>
                        <cfinclude template="../query/get_corrs.cfm">   
                        <cfset template = SETUP_CORR.DETAIL>
                    <cfelse>
                        <cfset template = "">
                    </cfif>
                    <cfif isdefined('attributes.mail_id')><cfset mail_body = HTMLCodeFormat(mail_body)></cfif>
                    <cfmodule template="/fckeditor/fckeditor.cfm"
                        toolbarset="Workcube"
                        basepath="/fckeditor/"
                        instancename="message"
                        value="#template#"
                        width="99%"
                        height="400">
                </cf_box_elements>
            <div class="ui-form-list-btn">
                <cf_workcube_buttons extraFunction='sendEmail2(1)' type_format='1' is_upd='0' add_function='sendEmail()' extraButtonText="#getLang('','Kaydet ve Mail Gönder',40811)#"  extraButton="1"><!--- OnFormSubmit()&& --->
            </div>
        </cfform>
    </cf_box>
</div>
<br/>

<script type="text/javascript">
<cfif isdefined("attributes.CORRCAT_ID")>
	document.form_add_correspondence.special_definition_id.value = '<cfoutput>#attributes.special_definition_id#</cfoutput>';
	document.form_add_correspondence.start_date.value = '<cfoutput>#attributes.start_date#</cfoutput>';
	document.form_add_correspondence.correspondence_number.value = '<cfoutput>#attributes.correspondence_number#</cfoutput>';
	document.form_add_correspondence.emp_id.value = '<cfoutput>#attributes.emp_id#</cfoutput>';
	document.form_add_correspondence.emp_name.value = '<cfoutput>#attributes.emp_name#</cfoutput>';
	document.form_add_correspondence.emp_id_cc.value = '<cfoutput>#attributes.emp_id_cc#</cfoutput>';
	document.form_add_correspondence.emp_name_cc.value = '<cfoutput>#attributes.emp_name_cc#</cfoutput>';
	document.form_add_correspondence.subject.value = '<cfoutput>#attributes.subject#</cfoutput>';
	document.form_add_correspondence.attachment.value = '<cfoutput>#attributes.attachment#</cfoutput>';
	<cfif isdefined("attributes.is_read")>
		document.form_add_correspondence.is_read.checked = true;
	<cfelse>
		document.form_add_correspondence.is_read.checked = false;
	</cfif>
	<cfif isdefined("attributes.email")>
		document.form_add_correspondence.email.checked = true;
	<cfelse>
		document.form_add_correspondence.email.checked = false;
	</cfif>
		
</cfif>
function temizle(obj_name)
{
	if(obj_name == 1)
	{
		form_add_correspondence.emp_id.value='';
		form_add_correspondence.emp_name.value='';
	}
	if(obj_name == 2)
	{
		form_add_correspondence.emp_id_cc.value='';
		form_add_correspondence.emp_name_cc.value='';
	}
} 
function sendEmail()
{
	if(document.form_add_correspondence.system_paper_no_add.value == '' && document.form_add_correspondence.correspondence_number.value == '')
	{
		alert("<cf_get_lang dictionary_id='29687.Lütfen Belge Numaralarını Tanımlayınız'>");
		return false;
	}
	
	 if (form_add_correspondence.subject.value == "")
	 {
		 alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu !'>");
		 return false;
     }
     if (form_add_correspondence.emp_name.value =="") {
         alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='51067.Gönderilecek Kişi !'>");
         return false;
     }
	 return process_cat_control();
}
function sendEmail2()
{  
	if(document.form_add_correspondence.system_paper_no_add.value == '' && document.form_add_correspondence.correspondence_number.value == '')
	{
		alert("<cf_get_lang dictionary_id='29687.Lütfen Belge Numaralarını Tanımlayınız'>");
		return false;
	}
	
	 if (form_add_correspondence.subject.value == "")
	 {
		 alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu !'>");
		 return false;
     }
     if (form_add_correspondence.emp_name.value =="") {
         alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='51067.Gönderilecek Kişi !'>");
         return false;
     }
     document.form_add_correspondence.email.checked = true;
	 return process_cat_control();
}
</script>
