<cfif isdefined("session.ww.userid") and len(session.ww.userid)>
	<cfquery name="GET_CONSUMER" datasource="#DSN#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
<cfelseif isdefined("session.pp.userid")>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
</cfif>
<cfquery name="GET_INTERACTION_CAT" datasource="#DSN#">
	SELECT 
		INTERACTIONCAT_ID,
#dsn_alias#.Get_Dynamic_Language(INTERACTIONCAT_ID,'#session_base.language#','SETUP_INTERACTION_CAT','INTERACTIONCAT',NULL,NULL,INTERACTIONCAT) AS INTERACTIONCAT,
		IS_SERVICE_HELP 
	FROM 
		SETUP_INTERACTION_CAT 
	WHERE 
		INTERACTIONCAT IS NOT NULL 
	ORDER BY INTERACTIONCAT
</cfquery>
<cfquery name="GET_ASSETCAT" datasource="#DSN#">
	SELECT ASSETCAT_ID,ASSETCAT FROM ASSET_CAT WHERE IS_INTERNET = 1 AND IS_INTERNET IS NOT NULL
</cfquery>
<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY
</cfquery>
<cfparam name="attributes.app_name" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.workcube_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.pid" default="">
<cfparam name="attributes.file_name" default="">
<cfparam name="attributes.is_elect_asset_cat" default="">
<cfparam name="attributes.is_cont_doc_type" default="">
<cfparam name="attributes.interaction_cat" default="">
<cfparam name="attributes.commethod_id" default="6">
<br />
<cf_form_box>
    <cfform name="add_helpdesk" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_service_help" enctype="multipart/form-data">
	<table align="left" cellpadding="2" cellspacing="2">
        <cfif fusebox.fuseaction contains 'popup_'>
            <input type="hidden" name="is_popup" id="is_popup" value="1">
        </cfif>
        <input type="hidden" name="app_name" id="app_name" value="<cfoutput>#attributes.app_name#</cfoutput>">
        <input type="hidden" name="app_cat" id="app_cat" value="<cfoutput>#attributes.commethod_id#</cfoutput>">
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
        <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
        <input type="hidden" name="assetcat_id" id="assetcat_id" value="<cfif isdefined('attributes.is_elect_asset_cat') and len(attributes.is_elect_asset_cat)><cfoutput>#attributes.is_elect_asset_cat#</cfoutput></cfif>">
        <input type="hidden" name="property_id" id="property_id" value="<cfif isdefined('attributes.is_cont_doc_type')><cfoutput>#attributes.is_cont_doc_type#</cfoutput></cfif>">
        <input type="hidden" name="workcube_id" id="workcube_id" value="<cfoutput>#attributes.workcube_id#</cfoutput>">
        <input type="hidden" name="is_security" id="is_security" value="<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>1<cfelse>0</cfif>" />
        <cfif isdefined('attributes.report_url') and len('attributes.report_url')>
            <cfif isdefined('attributes.cpid')>
                <cfset degisken = 'cpid=#attributes.cpid#'>
            <cfelseif isdefined('attributes.pid')>
                <cfset degisken = 'pid=#attributes.pid#'>
            </cfif>
            <input type="hidden" name="report_url" id="report_url" value="<cfoutput>#attributes.report_url#&#degisken#</cfoutput>">
        </cfif>
        <tr>
            <td class="txtbold" colspan="2" style="font-size:11px;color: #FF8000; height:30px; text-align:left;"><cf_get_lang no='38.Bizimle iletişime geçmek için aşağıdaki formu doldurmanız yeterli'>...</td>
        </tr>
        <cfif isdefined('attributes.is_category') and attributes.is_category eq 1>
            <tr>
                <td style="text-align:left;"><cf_get_lang_main no='74.Kategori'> *</td>
                <td style="text-align:left;">
                    <select name="interaction_cat" id="interaction_cat" style="width:240px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_interaction_cat">
                        <cfif is_service_help eq 1>
                            <option value="#interactioncat_id#">#interactioncat#</option>
                        </cfif>
                        </cfoutput>	  
                    </select>
                </td>
            </tr>
        <cfelseif isdefined('attributes.cat_id')>
            <tr>
                <td colspan="2"><input type="hidden" name="interaction_cat" id="interaction_cat" style="width:240px;" value="<cfoutput>#attributes.cat_id#</cfoutput>" /></td>
            </tr>
        </cfif>
        <tr>
            <td style="text-align:left;"><cf_get_lang_main no='1408.Başlık'> *</td>
            <td style="text-align:left;"><cfsavecontent variable="msg">Lütfen Bir Konu Başlığı Giriniz !</cfsavecontent>
                <cfinput type="text" name="detail" id="detail" value="" required="yes" message="#msg#" style="width:235px;">
            </td>
        </tr>
        <tr>
            <td valign="top" style="text-align:left;"><cf_get_lang_main no='68.Konu'> *</td>
            <td width="330" style="text-align:left;">
                <textarea style="width:240px; height:110px;"  
                    onchange="counter(this.form.subject,this.form.detailLen,1000);return ismaxlength(this);" 
                    name="subject" id="subject"  maxlength="1000" 
                    onkeydown="counter(this.form.subject,this.form.detailLen,1000);return ismaxlength(this);" 
                    onkeyup="counter(this.form.subject,this.form.detailLen,1000);return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
                    <input type="text" name="detailLen"  id="detailLen" size="1"  style="width:30px;" value="1000" readonly />
            </td>
        </tr>
        <cfif isdefined("attributes.is_file") and attributes.is_file eq 1>
            <tr>
                <td style="text-align:left;"><cf_get_lang_main no = '279.Dosya'></td>
                <td style="text-align:left;"><input type="file" name="file_name" id="file_name" style="width:240px;" value="1"></td>
            </tr>
        </cfif>
        <tr>
            <td style="text-align:left;"><cf_get_lang_main no='158.Ad Soyad'> *</td>
            <td style="text-align:left;">
                <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <input type="text" name="applicant_name" id="applicant_name" value="<cfoutput>#session.ww.name# #session.ww.surname#</cfoutput>" readonly maxlength="255" style="width:235px;">
                <cfelseif isdefined("session.pp.userid")>
                    <input type="text" name="applicant_name" id="applicant_name" value="<cfoutput>#session.pp.name# #session.pp.surname#</cfoutput>" readonly maxlength="255" style="width:235px;">
                <cfelseif isdefined("attributes.app_name") and len(attributes.app_name)>
                    <input type="text" name="applicant_name" id="applicant_name" value="<cfoutput>#attributes.app_name#</cfoutput>" readonly maxlength="255" style="width:235px;">
                <cfelse>
                    <input type="text" name="applicant_name" id="applicant_name" value="" maxlength="255" style="width:240px;">
                </cfif>
            </td>
        </tr>
        <tr>
            <td style="text-align:left;"><cf_get_lang_main no='16.E-Mail'> *</td>
            <td style="text-align:left;">
                <cfsavecontent variable="alert"><cf_get_lang no ='1562.Lutfen Mail Alanına Gecerli Bir Mail Adresi Giriniz'> !</cfsavecontent>
                <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <cfinput type="text" name="applicant_mail" id="applicant_mail" value="#get_consumer.consumer_email#" required="yes" validate="email" message="#alert#" style="width:240px;">
                <cfelseif isdefined("session.pp.userid")>
                    <cfinput type="text" name="applicant_mail" id="applicant_mail" value="#get_partner.company_partner_email#" required="yes" validate="email" message="#alert#" style="width:240px;">
                <cfelseif isdefined("attributes.email") and len(attributes.email)>
                    <cfinput type="text" name="applicant_mail" id="applicant_mail" value="#attributes.email#" required="yes" validate="email" message="#alert#" style="width:240px;">
                <cfelse>
                    <cfinput type="text" name="applicant_mail" id="applicant_mail" value="" validate="email" required="yes" message="#alert#" style="width:240px;">
                </cfif>
            </td>
        </tr>
        <cfif isdefined('attributes.is_telephone') and attributes.is_telephone eq 1>
            <tr>
                <td style="text-align:left;"><cf_get_lang no='1635.Kod/Telefon'></td>
                <td style="text-align:left;"><cfinput type="text" name="tel_code" id="tel_code" validate="integer" message="Telefon Kodu Hatalı!" maxlength="4" onKeyUp="isNumber(this);" style="width:60px;">
                    <cfinput type="text" name="tel_no" id="tel_no" validate="integer" message="Telefon No Hatalı!" maxlength="10" onKeyUp="isNumber(this);" style="width:177px;">
                </td>
            </tr>
        </cfif>
        <cfif isdefined('attributes.is_security') and attributes.is_security eq 1>
            <script type="text/javascript">
                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.security_capcha_page</cfoutput>','security_capcha_code');
            </script>
            <tr>
                <td colspan="2">
                    <div id="security_capcha_code" style="display:none;"></div>
                </td>
            </tr>
        </cfif>
        <tr>
            <td colspan="2" style="text-align:left;"><cf_get_lang no='41.İletişim talebinize mutlaka cevap verilecektir'></td>
        </tr>
    </table>
    <cf_form_box_footer><cf_workcube_buttons is_upd='0' is_cancel='0' add_function='controlService()' class="button"></cf_form_box_footer>
    </cfform>
</cf_form_box>
<script type="text/javascript">
	function controlService()
	{
		if(document.getElementById('subject').value == "")
		{
			alert("<cf_get_lang no='42.Konu Alani Dolu Olmalidir'> !");
			document.getElementById('subject').focus();
			return false;
		}
		if(trim(document.getElementById('detail').value) =="")
		{
			alert("<cf_get_lang_main no='647.Lütfen Bir Konu Başlığı Giriniz!'>");
			document.getElementById('detail').focus();
			return false;
		}
		/*if(document.add_helpdesk.subject.value.length > 1000)
		{
			alert("<cf_get_lang no='43.Konu Alani En Fazla 1000 Karakter Olmalidir'> !");
			return false;
		}*/
		if(document.add_helpdesk.file_name != undefined)
		{	
			 if(document.getElementById('assetcat_id').value == "" || document.getElementById('property_id').value == "" )
			{
				alert("<cf_get_lang no='1588.Elektronik Varlık Kategorileri Değerini Ve  İçerik Belge ve Tipleri Giriniz'>!");
				return false;
			}
		}
		if(document.add_helpdesk.interaction_cat != undefined)
		{
			if(document.getElementById('interaction_cat').value =="")
			{
				alert("Kategori Seçiniz !");
				document.getElementById('interaction_cat').focus();
				return false;
			}
		}
		if(document.getElementById('applicant_name').value == "")
		{
			alert("<cf_get_lang no='44.Başvuru Yapan Dolu Olmalidir'> !");
			document.getElementById('applicant_name').focus();
			return false;
		}
	
	}
	document.getElementById('detail').select();
	function counter(field, countfield, maxlimit)
	 { 
		if (field.value.length > maxlimit) 
		  {
				
				field.value = field.value.substring(0, maxlimit);
				alert(""+maxlimit+"Karakterden Fazla Yazmayınız !"); 
		   }
		else 
			countfield.value = maxlimit - field.value.length; 
	 } 
	function reset() 
	{ 
			document.getElementById("subject").value=""; 
			document.getElementById("detailLen").value="1000"; 
	}
</script> 

