<cfset control = 0> 
<!---sayfaya seçim listesinden geliyor ve toplu mail ise--->
<cfif isdefined('attributes.list_row_id') and len(attributes.list_row_id)>
	<cfquery name="get_empapp_id" datasource="#dsn#">
		SELECT
			EMPAPP_ID,
			LIST_ROW_ID
		FROM 
			EMPLOYEES_APP_SEL_LIST_ROWS
		WHERE
			LIST_ROW_ID IN (#attributes.list_row_id#)
	</cfquery>
	<cfset form.mail="">
	<cfoutput query="get_empapp_id">
		<cfset form.mail=listappend(form.mail,get_empapp_id.empapp_id,',')>
	</cfoutput>
</cfif>
<!---//sayfaya seçim listesinden geliyorsa toplu mail ise--->
<cfif isdefined('attributes.is_performans')>
	<cfif not len(trim(form.mail)) and not len(trim(form.mail_code))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='56664.Mail gönderilecek Kişi Yok,Kontrol Edin! Listeden Mail Göndermek İstediğiniz Kişiler Seçili Olmalı'>");
			window.close();
		</script>
		<cfabort>
	<cfelse>
		<cfset control = 1>
		<cfset mail_list = form.mail>  
	</cfif>
<cfelseif isdefined("attributes.mail_sum") and (not isdefined("form.mail") or not len(trim(form.mail)))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='56664.Mail gönderilecek Kişi Yok,Kontrol Edin! Listeden Mail Göndermek İstediğiniz Kişiler Seçili Olmalı'>");
		window.close();
	</script>
	<cfabort>
<cfelseif isdefined("attributes.mail_sum")  and  isdefined("form.mail")>
	<cfset control = 1>  
	<cfset mail_list = form.mail>
</cfif>
<cfif isdefined('attributes.is_performans')>
	<cfquery name="get_emp_mail" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID,
			EMPLOYEE_EMAIL EMAIL,
			EMPLOYEE_NAME NAME,
			EMPLOYEE_SURNAME SURNAME
		FROM 
			EMPLOYEES 
		WHERE 
			EMPLOYEE_EMAIL <> '' 
			<cfif len(trim(form.mail))>
				AND EMPLOYEE_ID IN (#form.mail#)
			<cfelse>
				AND 0 = 1
			</cfif>
	UNION ALL
		SELECT
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_EMAIL EMAIL,
			EMPLOYEES.EMPLOYEE_NAME NAME,
			EMPLOYEES.EMPLOYEE_SURNAME SURNAME
		FROM 
			EMPLOYEES,
			EMPLOYEE_POSITIONS 
		WHERE 
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_EMAIL <> ''
			<cfif len(trim(form.mail_code))> 
				AND POSITION_CODE IN (#form.mail_code#)
			<cfelse>
				AND 0 = 1
			</cfif>
	</cfquery>
<cfelse>
	<cfquery name="get_emp_mail" datasource="#dsn#">
		SELECT
			EMPAPP_ID,
			EMAIL,
			NAME,
			SURNAME
		FROM 
			EMPLOYEES_APP 
		WHERE 
			EMAIL <> '' 
			<cfif isdefined("attributes.mail_sum") and isdefined("form.mail") and len(form.mail)>
				AND EMPAPP_ID IN (#form.mail#)
			<cfelseif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>
				AND EMPAPP_ID = #attributes.empapp_id#
			</cfif>
		ORDER BY 
			EMPAPP_ID DESC
	</cfquery>
	<cfset form.mail=ValueList(get_emp_mail.empapp_id,',')>
</cfif>
<cfif isdefined('attributes.is_performans')>
	<cfset faction='emptypopup_add_empapp_mail'>
<cfelseif isdefined("attributes.mail_sum")  and  isdefined("form.mail")>
	<cfset faction='emptypopup_add_empapp_mail&cont=1'>
<cfelseif not isdefined("attributes.mail_sum") and not isdefined("form.mail")>
	<cfset faction='emptypopup_add_empapp_mail'>
<cfelse>
	<cfset faction='emptypopup_add_empapp_mail'>
</cfif>
<cfquery name="get_cat" datasource="#DSN#">
	SELECT CORRCAT_ID,DETAIL,CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
	<cf_box title="#getLang('','Mail Gönder','57475')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_app_mail" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=hr.#faction#">
			<cfif isdefined("attributes.app_pos_id")>
				<input type="hidden" name="app_pos_id" id="app_pos_id" value="<cfoutput>#attributes.app_pos_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.list_row_id")>
				<input type="hidden" name="list_row_id" id="list_row_id" value="<cfoutput>#attributes.list_row_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.list_id")>
				<input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.is_performans")>
				<input type="hidden" name="is_performans" id="is_performans" value="<cfoutput>#attributes.is_performans#</cfoutput>">
			</cfif>    
			<cfif isdefined("attributes.kontrol")>
				<input type="hidden" name="kontrol" id="kontrol" value="<cfoutput>#attributes.kontrol#</cfoutput>">
			</cfif>
				<input type="hidden" id="clicked" id="clicked" value="">
			<cfif isdefined("attributes.mail_sum") and len(form.mail)>
				<input type="hidden" name="mail_sum" id="mail_sum" value="<cfoutput>#attributes.mail_sum#</cfoutput>">
			</cfif>
			<cfif isdefined("form.mail")>
				<input type="hidden" name="mail" id="mail" value="<cfoutput>#form.mail#</cfoutput>">
			</cfif>
			<cfif isdefined("form.mail_code")>
				<input type="hidden" name="mail_code" id="mail_code" value="<cfoutput>#form.mail_code#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.is_refresh") and len(attributes.is_refresh)>
				<input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1">
					<div class="form-group" id="item-sablon">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58640.Şablon'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="corrcat" id="corrcat">
								<option value="0" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
								<cfoutput query="get_cat">
								<option value="#CORRCAT_ID#"<cfif isdefined("attributes.CORRCAT") and (attributes.CORRCAT eq CORRCAT_ID)> selected</cfif>>#CORRCAT# 
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-EMPLOYEE_EMAIL">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.mail'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif control eq 0>
								<input type="hidden" name="empapp_id" id="empapp_id" value="<cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)><cfoutput>#attributes.empapp_id#</cfoutput></cfif>">
								<input type="text" name="EMPLOYEE_EMAIL" id="EMPLOYEE_EMAIL" value="<cfoutput>#get_emp_mail.EMAIL#</cfoutput>">
							<cfelse>
								<input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#mail_list#</cfoutput>">
									<cfset emails = valuelist(get_emp_mail.EMAIL,",")>
								<input type="text" name="EMPLOYEE_EMAIL" id="EMPLOYEE_EMAIL" value="<cfoutput>#emails#</cfoutput>">
							</cfif> 
						</div>
					</div>
					<div class="form-group" id="item-header">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
							<cfinput type="text" name="header" value="" required="yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-editor">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div id="fckedit">
								<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarSet="WRKContent"
								basePath="/fckeditor/"
								instanceName="content"
								valign="top"
								value=""
								width="575"
								height="300">
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='55410.Kaydet ve Mail Gönder'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function="control(1)"> 
				<cf_workcube_buttons is_upd='0' type_format="1" add_function='control(0)'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
	


<script type="text/javascript">
	 function control(type)
	 {
		 if (type ==1){
			 $("#clicked").val("&email=true");
		 }
		 add_app_mail.action = add_app_mail.action + add_app_mail.clicked.value; 
		 var aaa = add_app_mail.EMPLOYEE_EMAIL.value;
		 if (((aaa == "") || (aaa.indexOf("@") == -1) || (aaa.indexOf(".") == -1) || (aaa.length < 6)) && (add_app_mail.clicked.value == "&email=true"))
		 { 
		   alert("<cf_get_lang dictionary_id='58484.Lütfen geçerli bir e-mail adresi giriniz'>");
		   add_app_mail.action = "<cfoutput>#request.self#?fuseaction=hr.emptypopup_add_empapp_mail</cfoutput>"; 
		   return false;
		 }
		 return true;
	 }
</script>
<script type="text/javascript">	
	$("#corrcat").change(function(){
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_get_template&template_id='+ $(this).val() +'','fckedit',1);
	});
	
</script>