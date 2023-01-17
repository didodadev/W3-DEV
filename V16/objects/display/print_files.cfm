<!--- 
	Author : Uğur Hamurpet
    Update Date : 03/05/2020
	Desc : 	WOC - Workcube Output Center
			Preview print template
			Save new WOC document ( PDF, EXCEL, DOC ) in to WOC task list and run all list.
			If you choose Mail or Archive from Output Type, WOC will create a file in documents/woc path.
			Output Types : {
				Mail : WOC wants to mail settings and it sends mail by the mail settings after the create WOC document.
				Print : WOC doesn't need any settings. Output, print template preview in template window.
				Archive : WOC wants to archive settings and it creates a new digital asset document by the arcihe setting.
			}
--->

<cf_xml_page_edit fuseact="objects.popup_print_files">
	<cfparam name="attributes.form_kontrol" default="">
	<cfparam name="attributes.woc_action_type" default="">
	<cfparam name="attributes.woc_list" default="">
	<cfparam name="attributes.iid" default="">
	<cfparam name="attributes.action_id" default="">
	<cfparam name="attributes.action_type" default="0">
	<cfparam name="attributes.action" default="">
	
	<cfif len( attributes.woc_list )>
		<cfset attributes.action_type = ( len( attributes.woc_action_type ) ) ? listFirst( attributes.woc_action_type ) : 0 />
		<cfset attributes.iid = attributes.action_id = listFirst( attributes.woc_list ) />
	</cfif>
	
	<cfset attributes.iid = attributes.action_id = ( isdefined("attributes.action_id") and len( attributes.action_id ) ) 
													? attributes.action_id 
													: ( isdefined("attributes.iid") and len( attributes.iid ) ) ? attributes.iid : ''  />
	
	<cfset woc = createObject("component","V16/objects/cfc/woc") />
	<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
	<cfif not len(attributes.action)>
		<script>
			$(document).one('ready',function(){
				var urlAux = document.referrer.split('=')[1].split('&')[0];
				location.href= $(location).attr('href')+'&action='+urlAux;
			});
		</script>
	</cfif>
	<cfset is_new_template = "">
	<cfif isdefined('attributes.print_type')>
		<cfset get_det_form = getPrintTemplate.GET( print_type : attributes.print_type )>
		<cfif get_det_form.recordcount>
			<cfquery name="GET_DEFAULT_" dbtype="query">
				SELECT FORM_ID FROM GET_DET_FORM WHERE IS_DEFAULT = 1
			</cfquery>
			<cfif GET_DEFAULT_.recordcount>
				<cfset attributes.form_type = get_default_.form_id>
			</cfif>
			<cfset is_new_template = 0>
		</cfif>
	<cfelseif len(attributes.action)>
		<cfset get_templates = getPrintTemplate.get_templates( action : attributes.action )>
		<cfif get_templates.recordcount>
			<cfset attributes.template_id = get_templates.WRK_OUTPUT_TEMPLATE_ID>
			<cfset is_new_template = 1>
		</cfif>
	</cfif>
	
	<cfset address = "" />
	<cfif listLen( cgi.QUERY_STRING, "&" )>
		<cfloop list="#cgi.QUERY_STRING#" index="value" delimiters="&">
			<cfif listFirst( value, "=" ) neq 'fuseaction' and listFirst( value, "=" ) neq 'woc_action_type' and listFirst( value, "=" ) neq 'woc_list'>
				<cfset address = '#address#&#listFirst( value, "=" )#=#listLast( value, "=" )#' />
			</cfif>
		</cfloop>
		<cfif isdefined("attributes.action_type") and len( attributes.action_type )><cfset address = '#address#&action_type=#attributes.action_type#' /></cfif>
		<cfif isdefined("attributes.action_id") and len( attributes.action_id )><cfset address = '#address#&action_id=#attributes.action_id#' /></cfif>
		<cfif isdefined("attributes.woc_list") and len( attributes.woc_list )><cfset address = '#address#&woc_list=#attributes.woc_list#' /></cfif>
		<cfif isdefined("attributes.iid") and len( attributes.iid )><cfset address = '#address#&iid=#attributes.iid#' /></cfif>
	</cfif>
	
	<!--- Eğitim yönetiminden çağrılmışsa eğer class id yi alıp katılımcıları çekecek --->
	<cfif isdefined("attributes.print_type") and len(attributes.print_type) and attributes.print_type eq 321><!--- Katılımcılar --->
		<cfinclude template="../display/list_class_attenders.cfm">
	</cfif>
	<cfif isdefined("attributes.print_type") and len(attributes.print_type) and attributes.print_type eq 320><!--- Eğitimci --->
		<cfinclude template="../display/list_class_trainer.cfm">
	</cfif>
	<cfif isDefined('x_control_efatura') and x_control_efatura neq 0 and session.ep.our_company_info.is_efatura eq 1 and (isdefined("action_type") and listfind('48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,65,66,67,68,690,691,591,592,531,532,69,121',action_type) and isdefined("attributes.iid") or isdefined("attributes.print_type") and attributes.print_type eq 230)>	
		<cfquery name="CHK_EINVOICE" datasource="#DSN2#">
			<cfif isdefined("attributes.print_type") and attributes.print_type eq 230>
				SELECT 
					CASE
						WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
						WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
					END AS 
						USE_EFATURA
				FROM 
					EXPENSE_ITEM_PLANS EIP
						LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = EIP.CH_COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= EIP.EXPENSE_DATE
						LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EIP.CH_CONSUMER_ID AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= EIP.EXPENSE_DATE
				WHERE
					EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
					(COMPANY.COMPANY_ID IS NOT NULL OR CONSUMER.CONSUMER_ID IS NOT NULL)
			<cfelse>
				SELECT 
					CASE
						WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
						WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
					END AS 
						USE_EFATURA
				FROM 
					INVOICE
						LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= INVOICE.INVOICE_DATE
						LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= INVOICE.INVOICE_DATE
				WHERE
					INVOICE.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
					(COMPANY.COMPANY_ID IS NOT NULL OR CONSUMER.CONSUMER_ID IS NOT NULL)
			</cfif>
		</cfquery>
		<cfif chk_einvoice.recordcount>
			<cfif x_control_efatura eq 1>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='34664.E-Fatura Olan Bir Belgeyi Bastıramazsınız'>");
					this.close();
				</script>
			<cfelse>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='34675.E-Fatura Olan Bir Belgeyi Bastırmak İstiyorsunuz'>!");
				</script>
			</cfif>	
		</cfif> 
	</cfif>
	<cfif isDefined('x_control_earsiv') and x_control_earsiv neq 0 and session.ep.our_company_info.is_earchive eq 1 and (isdefined("action_type") and listfind('48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,65,66,67,68,690,691,591,592,531,532,69,121',action_type) and isdefined("attributes.iid") or isdefined("attributes.print_type") and attributes.print_type eq 230)>
		<cfquery name="CHK_EARCHIVE" datasource="#DSN2#">
			<cfif isdefined("attributes.print_type") and attributes.print_type eq 230>
				SELECT 
					EIP.EXPENSE_ID
				FROM 
					EXPENSE_ITEM_PLANS EIP,
					EARCHIVE_RELATION ER,
					#dsn3_alias#.SETUP_PROCESS_CAT SPC 
				WHERE  
					EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
					EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
					INVOICE_TYPE_CODE IS NOT NULL AND 
					EXPENSE_DATE >=#createodbcdatetime(session.ep.our_company_info.earchive_date)# AND
					EIP.EXPENSE_ID = ER.ACTION_ID
			<cfelse>
				SELECT 
					EIP.INVOICE_ID
				FROM 
					INVOICE EIP,
					EARCHIVE_RELATION ER,
					#dsn3_alias#.SETUP_PROCESS_CAT SPC 
				WHERE  
					EIP.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> AND
					EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
					INVOICE_TYPE_CODE IS NOT NULL AND 
					INVOICE_DATE >=#createodbcdatetime(session.ep.our_company_info.earchive_date)# AND
					EIP.INVOICE_ID = ER.ACTION_ID
			</cfif>
		</cfquery>
		<cfif chk_earchive.recordcount>
			<cfif x_control_earsiv eq 1>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='34682.E-Arşiv Olan Bir Belgeyi Bastıramazsınız'>!");
					this.close();
				</script>
			<cfelse>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='34677.E-Arşiv Olan Bir Belgeyi Bastırmak İstiyorsunuz'>!");
				</script>
			</cfif>
		</cfif>       
	</cfif>
	
	<style> 
		table#taskDetail td{padding: 25px !important; text-align: center; font-size: 18px !important;}
		table#taskDetail th{padding: 10px !important; text-align: center; font-size: 14px !important;}
		.checkbox-content{border: solid 1px #eeeeee;}
		.checkbox-header{padding: 6px; color: #000000; background-color: #eeeeee; font-size: 16px;}
	</style>
	
	<iframe name="printer" id="printer" style = "display:none;" scrolling="yes" frameborder="0"></iframe>
	
	<div class="flowcard" id="woc-app">
		<h4 class="flowcard-header">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"><img src="images/helpdesklogo.png" title="Homepage"/></a>
			<label class="flowlabel" style="border-right:none !important;"><i class="fa fa-clipboard"></i>Output Center</label>
			<label class="flowlabel" style="float:right; margin-top:10px;"><i class="fa fa-shield"></i></label>
		</h4>
		<div class="flowcard-body col col-12 mt-3 scrollbar" id="flowcard-body">
			<div class="row">
				<div class="col col-8 col-md-7 col-xs-12">
					<cfsavecontent variable="title"><cf_get_lang dictionary_id='58640.Şablon'></cfsavecontent>
					<cfsavecontent variable="temp"><cf_get_lang dictionary_id='43261.Şablon Tasarımları'></cfsavecontent>
					<cf_box id="woc_preview_box" title="#title#" collapsable="1" closable="0" edit_href="#iif(get_module_power_user(47),DE('javascript:designer()'),DE(''))#" edit_href_title="#temp#">
						<cfif isdefined("attributes.form_type") or isdefined("attributes.template_id")>
							<iframe name="auto_print_page" id="auto_print_page" style = "width:100%;" scrolling="no" frameborder="0" src="<cfoutput>/V16/objects/cfc/woc.cfc?method=preview#address#&#iif(isdefined("attributes.form_type"),DE('form_type=##attributes.form_type##'),DE('template_id=##attributes.template_id##'))#</cfoutput>" <!--- onload="resizeIframe()" --->></iframe>
						<cfelse>
							<iframe name="auto_print_page" id="auto_print_page" style = "width:100%;display:none;min-height:500px;max-height:500px;" scrolling="no" frameborder="0" src=""></iframe>
							<div style="text-align:center;padding:70px 0;" id="auto_print_page_message"><h4><cf_get_lang dictionary_id='32718.Otomatik Baskı Şablonu Oluşturulmamış'>!</h4></div>
						</cfif>
					</cf_box>
					<div id="table_taskList">
						<cfsavecontent variable="title"><cf_get_lang dictionary_id='31030.Görevler'></cfsavecontent>
						<cf_box title="#title#" collapsable="0" closable="0">
							<cf_grid_list>
								<thead>
									<tr>
										<th style="width:50px;"><cf_get_lang dictionary_id="32690.Sıra No"></th>
										<th style="width:20px;" class="text-center"><i class="fa fa-minus"></i></th>
										<th>WO</th>
										<th class="text-center" title="Output Type">O</th>
										<th class="text-center" title="Format">F</th>
										<th><cf_get_lang dictionary_id="31754.Gönderen"></th>
										<th><cf_get_lang dictionary_id="30631.Tarih"></th>
										<th class="text-center"><i class="fa fa-1-5x fa-bookmark-o"></i></th>
									</tr>
								</thead>
								<tbody>
									<template v-if = "taskList.length">
										<tr v-for = "(task, index) in taskList" v-bind:key = "index" class="taskRow">
											<td> <input type="hidden" :id = "'woj_id_' + task.woj_id" :value = "task.woj_id"> {{ task.row }} </td>
											<td><a href="javascript://" v-if = "task.woj_delivery_type.val != 'print' && !runStatus" v-on:click = "removeWoc(index,task.woj_id)"><i class="fa fa-minus"></i></a></td>
											<td> {{ task.woj_fuseaction }} </td>
											<td class="text-center"> <i :class="'icn-md ' + task.woj_delivery_type.iconclass" :title="task.woj_delivery_type.val"></i> </td>
											<td class="text-center"> <i v-if = "typeof(task.woj_output_type.iconclass) != undefined" :class="'icn-md ' + task.woj_output_type.iconclass" :title="task.woj_output_type.val"></i> </td>
											<td> {{ task.woj_sender }} </td>
											<td> {{ task.record_date }} </td>
											<td class="text-center"> <i :class="'fa fa-1-5x ' + task.is_complete"></i> </td>
										</tr>
									</template>
									<template v-else><tr><td colspan = "8" class="text-center" style="padding:30px !important;"><cf_get_lang dictionary_id='64310.Görev listeniz Boş'></td></tr></template>
								</tbody>
							</cf_grid_list>
						</cf_box>
					</div>
				</div>
				<div class="col col-4 col-md-5 col-xs-12">
					<cf_box collapsable="0" closable="0">
						<cf_box_elements vertical = "1">
							<div class="col col-12">
								<cfform name="addwoc" id="addwoc" action="V16/objects/cfc/woc.cfc?method=insert" method="post">
									<input type="hidden" id="action_id" name="action_id" v-model="action_id">
									<input type="hidden" id="woc_action_type" name="woc_action_type" v-model="woc_action_type">
									<input type="hidden" id="woc_list" name="woc_list" v-model="woc_list">
									<input type="hidden" id="group_key" name="group_key" v-model="group_key">
									<input type="hidden" id="parameters" name="parameters" v-model="compParameters">
									<cfinput type="hidden" id="is_new_template" name="is_new_template" value="#is_new_template#">
									<div class="row">
										<cfif (isdefined('Get_Det_Form') and Get_Det_Form.RecordCount) or (isdefined('get_templates') and get_templates.RecordCount)>
											<div class="form-group" id="item-form_type">
												<label class="col col-12"><cf_get_lang dictionary_id='58640.Şablon'>*</label>
												<div class="col col-12">
													<cfset IS_XML=0>
													<select  name="form_type" id="form_type" style="width:200px;" onchange="javascript:preview();" required>
														<option value=""><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
														<cfif isdefined('get_det_form')>
															<cfoutput query="get_det_form">
																<option <cfif IS_XML eq 1>style="color:0000FF"</cfif> value="<cfif IS_XML eq 1>1<cfelse>0</cfif>,#form_id#" <cfif IS_DEFAULT eq 1>selected</cfif> >#name# - #print_name#</option> 
															</cfoutput>
														<cfelse>
															<cfoutput query="get_templates">
																<option value="#WRK_OUTPUT_TEMPLATE_ID#" <cfif isdefined('attributes.template_id') and attributes.template_id eq WRK_OUTPUT_TEMPLATE_ID>selected</cfif>>#WRK_OUTPUT_TEMPLATE_NAME#</option> 
															</cfoutput>
														</cfif>
													</select>
												</div>
											</div>
										</cfif>
										<div class="form-group" id="item-delivery_type">
											<label class="col col-12"><cf_get_lang dictionary_id ="61014.Çıktı Tipi">*</label>
											<div class="col col-12">
												<select id="delivery_type" name="delivery_type" v-model = "delivery_type" required>
													<option value=""><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
													<option value="1"><cf_get_lang dictionary_id = "29463.Mail"></option>
													<option value="2"><cf_get_lang dictionary_id = "57474.Print"></option>
													<option value="4"><cf_get_lang dictionary_id = "43675.İndir"></option>
													<option value="3"><cf_get_lang dictionary_id = "64311.Arşiv"></option>
												</select>
											</div>
										</div>
										<div class="form-group" id="item-output_type" :style = "{ display : (delivery_type == 1 || delivery_type == 3 || delivery_type == 4) ? 'inline' : 'none' }">
											<label class="col col-12"><cf_get_lang dictionary_id = "58594.Format">*</label>
											<div class="col col-12">
												<select id="output_type" name="output_type" v-model = "output_type">
													<option value=""><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
													<option value="1">PDF</option>
													<option value="2">EXCEL</option>
													<option value="3">DOC</option>
												</select>
											</div>
										</div>
										<div class="form-group" id="item-output_file_name" :style = "{ display : (delivery_type == 1 || delivery_type == 3 || delivery_type == 4) ? 'inline' : 'none' }">
											<label class="col col-12"><cf_get_lang dictionary_id ="29800.Dosya Adı">*</label>
											<div class="col col-12">
												<input type="text" id="output_file_name" name="output_file_name" v-model = "output_file_name">
											</div>
										</div>
										<div class="form-group" id="item-fuseaction" :style = "{ display : (delivery_type == 1 || delivery_type == 3) ? 'inline' : 'none' }">
											<label class="col col-12"><cf_get_lang dictionary_id ="36185.Fuseaction"></label>
											<div class="col col-12">
												<cfinput type="text" id="output_fuseaction" name="output_fuseaction" value="#isdefined("attributes.action") ? attributes.action : ReplaceNoCase(ListFirst(ListLast( cgi.http_referer, '?' ),'&'),'fuseaction=','')#">
											</div>
										</div>
										<div class="col col-12 mt-1 mb-1" :style = "{ display : (delivery_type == 1) ? 'inline' : 'none' }">
											<cfsavecontent variable="title"><cf_get_lang dictionary_id ="60828.Mail Bilgileri"></cfsavecontent>
											<cf_seperator id="mail_area" header="#title#">
											<div id="mail_area">
												<div class="form-group message-info" id="item-trail">
													<div class="checkbox checbox-switch">
														<label style="width: auto; text-align: left;">
															<input type="checkbox" name="trail" id="trail" value="1" checked/>
															<span></span>
															<cf_get_lang dictionary_id="33129.Maile Şirket Logo ve Antetini Ekle">
														</label>
													</div>
												</div>
												<div class="form-group" id="item-emp_name">
													<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
														<label><cf_get_lang dictionary_id='57924.Kime'></label>
													</div>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<div class="input-group mb-2">
															<input type="hidden" name="emp_id" id="emp_id">
															<input type="text" name="emp_name" id="emp_name">
															<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=addwoc.emp_id&names=addwoc.emp_name')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
															<span class="input-group-addon icon-envelope-o btnPointer" v-on:click = "getMail()" title="<cf_get_lang dictionary_id ="60869.Mail adresini getir">" :style = "{display : (woc_list.split(',').length == 1) ? '' : 'none'}"></span>
														</div>
														<span :style = "{display : (woc_list.split(',').length == 1) ? 'inline' : 'none'}"><i class="icon-envelope-o"></i> : <cf_get_lang dictionary_id ="60829.Mail adresini üye bilgilerinden getirmenizi sağlar">!</span>
														<div class="checkbox checbox-switch" :style = "{display : (woc_list.split(',').length > 1) ? 'inline' : 'none'}">
															<label style="width: auto; text-align: left;">
																<input type="checkbox" name="mail_send_type" id="mail_send_type" value="1"/>
																<span></span>
																<cf_get_lang dictionary_id='60867.Maili sadece seçilen kişilere gönder'>
															</label>
															<label class="mt-1" style="cursor:default;">( <cf_get_lang dictionary_id='60868.Üye bilgilerindeki mail adresine göndermez'>! )</label>
														</div>
													</div>
												</div>
												<div class="form-group" id="item-emp_name_cc">
													<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
														<label><cf_get_lang dictionary_id='47860.CC'></label>
													</div>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<div class="input-group">
															<input type="hidden" name="emp_id_cc" id="emp_id_cc">
															<input type="text" name="emp_name_cc" id="emp_name_cc">
															<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=addwoc.emp_id_cc&names=addwoc.emp_name_cc')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
														</div>
													</div>
												</div>
												<div class="form-group" id="item-emp_name_bcc">
													<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
														<label><cf_get_lang dictionary_id='32945.BCC'></label>
													</div>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<div class="input-group">
															<input type="hidden" name="emp_id_bcc" id="emp_id_bcc">
															<input type="text" name="emp_name_bcc" id="emp_name_bcc">
															<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=addwoc.emp_id_bcc&names=addwoc.emp_name_bcc')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
														</div>
													</div>
												</div>
												<div class="form-group" id="item-subject">
													<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
														<label><cf_get_lang dictionary_id='57480.Konu'> *</label>
													</div>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<input type="text" name="subject" id="subject" maxlength="255" v-model = "subject">
													</div>
												</div>
												<div class="form-group" id="item-template">
													<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
														<cf_get_lang dictionary_id='58640.Şablon'>
													</div>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<select name="pursuit_templates" id="pursuit_templates" style="width:113px;" onchange="pursuitTemplate(this.value)">
															<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
															<cfquery name="get_pursuit_templates" datasource="#dsn#">
																SELECT 
																	* 
																FROM 
																	TEMPLATE_FORMS
																WHERE
																	IS_PURSUIT_TEMPLATE = 1	
																	<cfif isDefined("attributes.pursuit_template_id")>		
																		AND TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pursuit_template_id#">
																	</cfif>			
																ORDER BY 
																	TEMPLATE_HEAD	
															</cfquery>
															<cfoutput query="get_pursuit_templates">
																<option value="#template_id#"<cfif isDefined("attributes.pursuit_templates") and (attributes.pursuit_templates eq template_id)> selected</cfif>>#template_head#</option>
															</cfoutput>
														</select>
													</div>
												</div>
												<div class="form-group" id="item-mail_detail">
													<div class="col col-12">
														<div id="fckedit">
															<cfmodule
																template="/fckeditor/fckeditor.cfm"
																toolbarset="Basic"
																basepath="/fckeditor/"
																instancename="mail_detail"
																value=""
																valign="top"
																width="435"
																height="180">
														</div>
													</div>
												</div>
											</div>
										</div>
										<div class="col col-12 mt-1 mb-1" :style = "{ display : (delivery_type == 3) ? 'inline' : 'none' }">
											<cfsavecontent variable="title"><cf_get_lang dictionary_id ="60830.Arşiv Bilgileri"></cfsavecontent>
											<cf_seperator id="archive_area" header="#title#">
											<div id="archive_area">
												<div class="form-group message-info" id="item-trail">
													<div class="checkbox checbox-switch">
														<label style="width: auto; text-align: left;">
															<input type="checkbox" name="asset_auto_download" id="asset_auto_download" value="1"/>
															<span></span>
															<cf_get_lang dictionary_id ="60831.Görev çalıştıktan sonra dosyayı indir">
														</label>
													</div>
												</div>
												<div class="form-group" id="item-fuseaction">
													<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id ='57880.Belge No'>*</label>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<input type="text" id="asset_no" name="asset_no" v-model = "asset_no">
													</div>
												</div>
												<div class="form-group" id="item-process_stage">
													<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<cf_workcube_process is_upd = '0' fusepath = "asset.list_asset" is_detail = '0'>
													</div>
												</div>
												<div class="form-group" id="item-fuseaction">
													<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='31186.Varlık Kategorisi'>*</label>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<div class="input-group">
															<input type="hidden" name="assetcat_id" id="assetcat_id">
															<input type="text" name="assetcat_name" id="assetcat_name" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
															<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=addwoc&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
														</div>
													</div>
												</div>
												<div class="form-group" id="item-fuseaction">
													<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='34703.Doküman Tipi'>*</label>
													<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
														<cf_wrk_selectlang
															name="property_id"
															width="250"
															table_name="CONTENT_PROPERTY"
															option_name="NAME"
															value=""
															option_value="CONTENT_PROPERTY_ID"
															onchange="sel_digital_asset_group();">
													</div>
												</div>
												<div class="form-group" id="item-position_cat_id_all">
													<cfquery name="GET_DIGITAL_ASSET" datasource="#DSN#">
														SELECT GROUP_NAME,GROUP_ID FROM DIGITAL_ASSET_GROUP ORDER BY GROUP_NAME
													</cfquery>
													<div class="checkbox-content">
														<div class="checkbox-header"><cf_get_lang dictionary_id = "47693.Dijital Varlık Grupları"></div>
														<div class="scrollbar" style="position:relative; height:200px; z-index:88; overflow:auto;">
															<cfoutput query="get_digital_asset">
																<div class="col col-12">
																	<label class="container">#group_name#
																		<input type="checkbox" name="digital_assets" id="digital_assets" value="#group_id#" >
																		<span class="checkmark"></span>
																	</label>
																</div>
															</cfoutput>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="row formContentFooter">
										<button type="button" class="ui-wrk-btn ui-wrk-btn-success ui-btn-sm" id="save" v-on:click = "addWoc('save')" :style = "{ display : (delivery_type != 2 && delivery_type != 4) ? 'inline' : 'none' }"><cf_get_lang dictionary_id = "57461.Kaydet"></button>
										<button type="button" class="ui-wrk-btn ui-wrk-btn-success ui-btn-sm" id="print" v-on:click = "addWoc('print')" :style = "{ display : (delivery_type == 2) ? 'inline' : 'none' }"><cf_get_lang dictionary_id = "57474.Yazdır"></button>
										<button type="button" class="ui-wrk-btn ui-wrk-btn-success ui-btn-sm" id="download" v-on:click = "addWoc('download')" :style = "{ display : (delivery_type == 4) ? 'inline' : 'none' }"><cf_get_lang dictionary_id = "43675.İndir"></button>
									</div>
								</cfform>
							</div>
						</cf_box_elements>
					</cf_box>
					<cfsavecontent variable="title"><cf_get_lang dictionary_id ="60832.Aktif Görevler"></cfsavecontent>
					<cf_box title="#title#" collapsable="0" closable="0">
						<div class="ui-card">
							<div class="ui-card-item">
								<table class="ajax_list" id="taskDetail">
									<thead>
										<th><cf_get_lang dictionary_id ="35989.Bekleyen"></th>
										<th><cf_get_lang dictionary_id ="40550.Tamamlanan"></th>
									</thead>
									<tbody>
										<tr><td id="waitingCount">{{ waitingCount }}</td><td id="completedCount">{{ completedCount }}</td></tr>
									</tbody>
								</table>
								<button type="button" id="runWoc" class="ui-wrk-btn ui-wrk-btn-success ui-btn-block mt-1 ml-0" v-on:click = "runWoc()" :disabled = "waitingCount == 0"><cf_get_lang dictionary_id ="60837.Görevleri Tamamla"></button>
							</div>
						</div>
					</cf_box>
				</div>
			</div>
		</div>
	</div>
	
	<cfset wocList = woc.select() />
	<cfset wocCounter = woc.counter() />
	
	<cfset outputTypes = {1 : { val : 'PDF', iconclass : 'icon-file-pdf-o' }, 2 : { val : 'EXCEL', iconclass : 'icon-file-excel-o' }, 3 : { val : 'DOC', iconclass : 'icon-file-text-o' }} />
	<cfset deliveryTypes = {1 : { val : 'Mail', iconclass : 'icon-envelope-o' }, 2 : { val : 'Print', iconclass : 'icon-print' }, 3 : { val : 'Archive', iconclass : 'icon-save' }} />
	
	<cf_papers paper_type="ASSET">
	<cfset system_paper_no=paper_code & '-' & paper_number>
	<cfset system_paper_no_add=paper_number>
	<cfset asset_no = len(paper_number) ? system_paper_no : ''>
	
	
	
	<script src="/JS/assets/plugins/vue.js"></script>
	<script>
	<cfif isdefined("attributes.template_id") and len(attributes.template_id) and (isdefined('get_det_form') or isdefined('get_templates'))>
	$( document ).ready(function() {
		$("#form_type").val("<cfoutput><cfif isdefined('get_det_form') and get_det_form.is_xml eq 1>1,<cfelseif isdefined('get_det_form')>0,</cfif>#attributes.template_id#</cfoutput>");
		preview();
	});
	</cfif>
		function pursuitTemplate(pursuitId)
		{
			var pursuit_adres_ = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_pursuit_template&pursuit_template_id=</cfoutput>"+pursuitId;
			AjaxPageLoad(pursuit_adres_,'item-mail_detail',1,"İçerik Yükleniyor!");
		}
	
		function requiredControl() {
			var response = true;
			$( "form[ name = addwoc ] input:required, form[ name = addwoc ] select:required" ).map(function () { 
				if( $.trim($( this ).val()) == '' ){
					$( this ).css({ cssText : "border-color : red !important" });
					response = false;
				}else $( this ).css({ cssText : "border-color : #ddd !important" });
			});
	
			if( $("#delivery_type").val() == 1 || $("#delivery_type").val() == 3 ){
				
				if( $.trim( $("#output_file_name").val() ) == '' ){
					$("#output_file_name").css({ cssText : "border-color : red !important" });
					response = false;
				}else $("#output_file_name").css({ cssText : "border-color : #ddd !important" });
	
				if( $.trim( $("#output_type").val() ) == '' ){
					$("#output_type").css({ cssText : "border-color : red !important" });
					response = false;
				}else $("#output_type").css({ cssText : "border-color : #ddd !important" });
	
				if( $("#delivery_type").val() == 1 ){
	
					<!--- Toplu çıktılama isteklerinde mail kişi alanı sadece tek bir kayıt olacaksa zorunludur --->
					<cfif not len( attributes.woc_list ) or (isdefined("attributes.woc_list") and listLen( attributes.woc_list ) eq 1)>
					if( $.trim($("#emp_name").val()) == '' ){
						$("#emp_name").css({ cssText : "border-color : red !important" });
						response = false;
					}else $("#emp_name").css({ cssText : "border-color : #ddd !important" });
					</cfif>
	
					if( $.trim($("#subject").val()) == '' ){
						$("#subject").css({ cssText : "border-color : red !important" });
						response = false;
					}else $("#subject").css({ cssText : "border-color : #ddd !important" });
	
					//Yapilan sablon secimi düzenlemesinden sonra bu alandan dolayi kaydetmiyordu, yoruma aldiktan sonra sorun duzeldi.
					//$("textarea[name=mail_detail]").css({"visibility" : "visible"}).val( decodeURIComponent(CKEDITOR.instances['mail_detail'].getData()) );
					
	
					if( $.trim( $("textarea[name=mail_detail]").val() ) == '' ) response = false;
	
				}else if( $("#delivery_type").val() == 3 ){
	
					if( $.trim($("#asset_no").val()) == '' ){
						$("#asset_no").css({ cssText : "border-color : red !important" });
						response = false;
					}else{
						paper_control(document.addwoc.asset_no,'ASSET');
						$("#asset_no").css({ cssText : "border-color : #ddd !important" });
					}
	
					if( $.trim($("#assetcat_id").val()) == '' || $.trim($("#assetcat_name").val()) == '' ){
						$("#assetcat_name").css({ cssText : "border-color : red !important" });
						response = false;
					}else $("#assetcat_name").css({ cssText : "border-color : #ddd !important" });
	
					if( $.trim($("#property_id").val()) == ''){
						$("#property_id").css({ cssText : "border-color : red !important" });
						response = false;
					}else $("#property_id").css({ cssText : "border-color : #ddd !important" });
	
				}
	
			}else if( $("#delivery_type").val() == 4 ){
				if( $.trim( $("#output_file_name").val() ) == '' ){
					$("#output_file_name").css({ cssText : "border-color : red !important" });
					response = false;
				}else $("#output_file_name").css({ cssText : "border-color : #ddd !important" });
	
				if( $.trim( $("#output_type").val() ) == '' ){
					$("#output_type").css({ cssText : "border-color : red !important" });
					response = false;
				}else $("#output_type").css({ cssText : "border-color : #ddd !important" });
			}
	
			return response;
		}
	
		var wocList = [
			<cfif wocList.recordcount>
				<cfoutput query="wocList">
					{
						'row' : #currentrow#, 
						'woj_id' : '#woj_id#', 
						'woj_fuseaction' : '#woj_fuseaction#', 
						'woj_output_type' : #LCase(Replace(SerializeJson( len( woj_output_type ) ? outputTypes[woj_output_type] : {} ),"//",""))#, 
						'woj_delivery_type' : #LCase(Replace(SerializeJson(deliveryTypes[woj_delivery_type]),"//",""))#, 
						'woj_sender' : '#employee_name# #employee_surname#', 
						'record_date' : '#dateformat(record_date,dateformat_style)# #dateformat(record_date,timeformat_style)#',
						'is_complete' : '#is_complete ? "fa-bookmark text-success" : "fa-bookmark-o"#'
					} #wocList.recordcount gt currentrow ? ',' : '' #
				</cfoutput>
			</cfif>
		];
	
		var outputTypes = JSON.parse('<cfoutput>#LCase(Replace(SerializeJson(outputTypes),"//",""))#</cfoutput>');
		var deliveryTypes = JSON.parse('<cfoutput>#LCase(Replace(SerializeJson(deliveryTypes),"//",""))#</cfoutput>');
		var completedCount = <cfoutput># wocCounter.recordcount ? wocCounter.COMPLETED_COUNT : 0 #</cfoutput>;
		var waitingCount = <cfoutput># wocCounter.recordcount ? wocCounter.WAITING_COUNT : 0 #</cfoutput>;
	
		function createWocList( data ) {
	
			if( data.record_date != null ){
				var date = new Date( data.record_date );
				data.record_date = date.getDate() +"/"+ ((date.getMonth().toString().length == 1) ? "0" + date.getMonth() : date.getMonth()) + "/" + date.getFullYear() + " " + date.getHours() + ":" + date.getMinutes();
			}
	
			return {
				row : data.row != null ? data.row : "",
				woj_id : data.woj_id != null ? data.woj_id : "",
				woj_fuseaction : data.woj_fuseaction != null ? data.woj_fuseaction : "",
				woj_output_type : ( data.woj_output_type != null && data.woj_output_type != '' ) ? outputTypes[data.woj_output_type] : {},
				woj_delivery_type : data.woj_delivery_type != null ? deliveryTypes[data.woj_delivery_type] : {},
				woj_sender : (data.woj_sender != null) ? data.woj_sender : "",
				record_date : data.record_date != null ? data.record_date : "",
				is_complete : data.is_complete != null ? ((data.is_complete) ? 'fa-bookmark text-success' : 'fa-bookmark-o') : ""
			}
	
		}
	
		function sendRequest( woj_id,is_new_template, callback, is_completed = false ) {
			
			/* Çalıştırılmak istenilen woc'un daha önce çalıştırılmış olma ihtimaline karşı kontrol edilir */
			var flag =  $("input#woj_id_"+ woj_id +"").closest('tr').find('td:last-child i');
	
			/* Woc daha önce çalıştırılmamışsa çalıştırma isteği gönderilir */
			if( !flag.hasClass( 'text-success' ) || is_completed ){
	
				if( !is_completed ) flag.removeClass('fa-bookmark-o fa-bookmark').addClass('fa-cog fa-spin font-yellow-casablanca');
	
				var data = new FormData();
				data.append('woj_id', woj_id);
				data.append('is_new_template', is_new_template);

				if( is_completed ) data.append('is_completed', 1);
	
				AjaxControlPostDataJson( "V16/objects/cfc/woc.cfc?method=run", data, callback );
			
			}else{
	
				/* Woc daha önce çalıştırılmışsa bir sonraki woc kaydına geçilir */
				var row = parseInt($("div#table_taskList table tr.taskRow").index( $("input#woj_id_"+ woj_id +"").closest('tr.taskRow') )) + 1;
				
				if( $("div#table_taskList table tr.taskRow:eq("+row+") td:first-child input[type = hidden]").length > 0 ){
					var nextwoj_id = $("div#table_taskList table tr.taskRow:eq("+row+") td:first-child input[type = hidden]").val();
					startRequest( nextwoj_id, row );
				}else endTask();
	
			}
		
		}
		
		var errorCounter = successCounter = 0;
	
		function endTask() {
	
			$("button[id = runWoc]").prop('disabled',false).html('Görevleri Tamamla');
			Swal.fire({
				title: 'Tüm görevler tamamlandı!',
				html:   '<table class="workDevList">'+
						'<tr><td width="50"><b><cf_get_lang dictionary_id='55387.Başarılı'></b></td><td>'+successCounter+'</td></tr>'+
						'<tr><td width="50"><b><cf_get_lang dictionary_id='54686.Hatalı'></b></td><td>'+errorCounter+'</td></tr>'+
						'</table>',
				type: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#1fbb39',
				cancelButtonColor: '#3085d6',
				confirmButtonText: '<cf_get_lang dictionary_id='44097.Devam Et'>',
				cancelButtonText: '<cf_get_lang dictionary_id='54685.Sonuçları İncele'>',
				closeOnConfirm: false,
				allowOutsideClick:false
			}).then((result) => {
				if (result.value) {
					location.reload();
				}
			})
	
		}
	
		/* Woc çalıştırma isteğini başlatır */
	
		function startRequest( woj_id, row ){
	
			/* Woc çalıştırma isteği gönderilir */
	
			sendRequest( woj_id, $('#is_new_template').val(), function( response ){
				
				var flag = $("div#table_taskList table tr.taskRow:eq("+row+") td:last-child").find("i");
				if( response.status ){
					if( response.woc.delivery_type == 3 && response.woc.asset_auto_download ) window.open('<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/objects/cfc/woc.cfc?method=download&woj_id='+response.woc.woj_id+'','Download Woc'); //Gönderim tipi arşivse ve görev çalıştıktan sonra dosyayı indir seçilmişse dosyayı otomatik olarak indirir!
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark text-success');
					successCounter++;
					$("#waitingCount").text( parseInt($("#waitingCount").text()) - 1 );
					$("#completedCount").text( parseInt($("#completedCount").text()) + 1 );
				}else{
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark text-danger').attr({ 'onclick' : 'showTaskMistakeMessage('+row+')' }).css({ 'cursor' : 'pointer' });
					errorCounter++;
						
					$('tr#task_'+row+'').remove();
	
					$(flag).parents('tr').after(
						$('<tr>').attr({ 'id' : 'task_' + row + '' }).append(
							$('<td>').attr({ 'colspan' : 8 }).append(
								$('<table>').addClass('workDevList').css({ 'width' : '100%' }).append(
									$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.message )),
									$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Error Type'), $('<td>').text( response.error.type )),
									$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Error Message'), $('<td>').text( response.error.message )),
									$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Error Detail'), $('<td>').text( response.error.detail ))
								)
							)
						).hide()
					);
	
				}
	
				row += 1;
				if( $("div#table_taskList table tr.taskRow:eq("+row+") td:first-child input[type = hidden]").length > 0 ){
					var nextwoj_id = $("div#table_taskList table tr.taskRow:eq("+row+") td:first-child input[type = hidden]").val();
					startRequest( nextwoj_id, row );
				}else endTask();
	
			});
	
		}
	
		function showTaskMistakeMessage( index ) {
			if( $('tr#task_'+index+'').hasClass("activeTr") ) 
				$('tr#task_'+index+'').hide().removeClass("activeTr");
			else $('tr#task_'+index+'').show().addClass("activeTr");
		}
	
		var newApp = new Vue({
			el : "#woc-app",
			data : {
				form : {}, buttonType : "",
				action_id : "<cfoutput>#isdefined('attributes.iid') ? attributes.iid : attributes.action_id#</cfoutput>",
				action_type : "<cfoutput>#attributes.action_type#</cfoutput>",
				action : "<cfoutput>#attributes.action#</cfoutput>",
				woc_action_type : "<cfoutput>#( len( attributes.woc_action_type ) ) ? attributes.woc_action_type : attributes.action_type#</cfoutput>", 
				woc_list : "<cfoutput>#( len( attributes.woc_list ) ) ? attributes.woc_list : ( isdefined('attributes.iid') ? attributes.iid : attributes.action_id )#</cfoutput>", 
				parameters : "<cfoutput>#address#</cfoutput>",
				output_type : "", delivery_type : 2, output_file_name : "", wocArray : [],
				subject : "",
				asset_no : "<cfoutput>#asset_no#</cfoutput>",
				taskList : wocList,
				completedCount : completedCount,
				waitingCount : waitingCount,
				saveStatus : false,
				runStatus : false
			},
			computed : {
				compParameters : function() {
					
					let newUrl = "";
					this.parameters.split("&").forEach(el => {
						if( el.split("=")[0] == 'action_type' ) newUrl += '&action_type=' + this.action_type;
						/* else if( el.split("=")[0] == 'action_id' ) newUrl += '&action_id=' + this.action_id;
						else if( el.split("=")[0] == 'iid' ) newUrl += '&iid=' + this.action_id;
						else if( el.split("=")[0] == 'action' ) newUrl += '&action=' + this.action; */
						/* Bu şekilde tüm attributesleri alıyor diye kapatıldı */
						else newUrl += '&' + el;
					});
	
					return newUrl;
	
				},
				group_key : function() {
					return (this.woc_list.split(",").length > 1 && this.saveStatus) 
							? (Math.floor(Math.random() * 100000) + "-" + Math.floor(Math.random() * 100000) + "-" + Math.floor(Math.random() * 100000) + "-" + Math.floor(Math.random() * 100000))
							: "";
				}
			},
			methods : {
				addWoc : function ( buttonType ) {
					
					this.buttonType = buttonType;
					//Çıktı tipi print ise çıktı ekranı açılır
					if( this.buttonType == 'save' || this.buttonType == 'download' ){
					
						this.form = $( "form[ name = addwoc ]" );
						this.form.find("button").prop('disabled',true).html('<i class="fa fa-spin fa-spinner"></i>');
						if(requiredControl()){ //Zorunlu alanların kontrolleri yapılır
							
							//Çoklu çıktılama işlemleri için : woc_list ve woc_action_type inputları içerisindeki listeleri parçalayarak array'e doldurur.
							if( ( this.woc_action_type != '' && this.woc_action_type.split(",").length > 0 ) || ( this.woc_list != '' && this.woc_list.split(",").length > 0 ) ){
								var wcList = this.woc_list.split(","), 
									wactList = ( this.woc_action_type != '' && this.woc_action_type.split(",").length > 0 ) ? this.woc_action_type.split(",") : '';
								for (let i = 0; i < wcList.length; i++) this.wocArray.push({ action_type : wactList[i], action_id : wcList[i] });
							}
	
							this.saveStatus = true;
	
							/* Ajax isteği başlatılır. */
							this.startWocSaveRequest( 0 );
	
						}else{
							alert("<cf_get_lang dictionary_id  = '29781.Lütfen zorunlu alanları doldurunuz'>!");
							this.form.find("button#save").prop('disabled',false).html('<cf_get_lang dictionary_id = "57461.Kaydet">');
							this.form.find("button#print").prop('disabled',false).html('<cf_get_lang dictionary_id = "57474.Yazdır">');
							this.form.find("button#download").prop('disabled',false).html('<cf_get_lang dictionary_id = "43675.İndir">');
						}
					
					}else{
						var data = new FormData();
						data.append("wo",$("#output_fuseaction").val());
						data.append("action_id",this.action_id);
						AjaxControlPostDataJson( "V16/objects/cfc/woc.cfc?method=print_counter", data, function(){} );
						print( this.parameters );	
					}
	
				},
				sendWocSaveRequst : function ( callback ) {
					this.form = $( "form[ name = addwoc ]" );// Form değerleri startWocSaveRequest fonksiyonunda değiştirildiğinden yeniden alınır.
					AjaxControlPostDataJson( this.form.attr("action"), new FormData( this.form[0] ), callback );
				},
				startWocSaveRequest : function ( index ) {
	
					/* Vue scope, ajax callback içerisinde this olarak kullanılamadığından vueThis isimli değişkene atanır */
					var vueThis = this;
	
					// Form içerisindeki action_id ve ation_type sıradaki dizi elemanıyla değiştirilir
					this.action_id = this.wocArray[index].action_id;
					this.action_type = this.wocArray[index].action_type;
	
					setTimeout(function() {
						/* Ajax ile woc.cfc?method=insert isteği yapılır ve kayıt işlemleri gerçekleştirilir  */
						vueThis.sendWocSaveRequst( function ( response ){
	
							if( response.status ){

								var res = response.data[0];
								if( res.woj_delivery_type != 4 ){//Gönderi tipi download değilse görev listesine ekler
	
									vueThis.taskList.push(new createWocList({
										row : vueThis.taskList.length + 1,
										woj_id : res.woj_id,
										woj_fuseaction : res.woj_fuseaction,
										woj_output_type : res.woj_output_type,
										woj_delivery_type : res.woj_delivery_type,
										woj_sender : res.employee_name.charAt(0).toUpperCase() + res.employee_name.slice(1) + " " + res.employee_surname.charAt(0).toUpperCase() + res.employee_surname.slice(1),
										record_date : res.record_date,
										is_complete : res.is_complete,
										is_new_template : res.is_new_template
									}));
	
									vueThis.waitingCount++;
	
								}else if( res.woj_delivery_type == 4 ){//Gönderi tipi download ise dosya indirilir
									sendRequest( res.woj_id, res.is_new_template, function( response ) {
										if( response.status ) window.open('<cfoutput>#fusebox.server_machine_list#</cfoutput>/V16/objects/cfc/woc.cfc?method=download&woj_id='+res.woj_id+'&is_new_template='+res.is_new_template+'','Download Woc');
										else alert( response.message );
									}, true );
								}
	
								//Gönderi tipi arşiv seçilmişse dijital arşiv belge numarası artırılır.
								if( res.woj_delivery_type == 3 ){
									var get_paper = workdata('get_paper','ASSET');
									vueThis.asset_no = ( get_paper.recordcount && get_paper.ASSET_NO[0] != undefined && get_paper.ASSET_NO[0] != '' )
														? get_paper.ASSET_NO[0] + '-' + (parseInt(get_paper.ASSET_NUMBER[0]) + 1)
														: '';
								}
	
								if( vueThis.wocArray.length == index + 1 ){
	
									//form elemanlarının değerleri boşaltılır
									$("#emp_id,#emp_name,#emp_id,#emp_id_cc,#emp_name_cc,#emp_id_bcc,#emp_name_bcc,#assetcat_id,#assetcat_name,#property_id").val("");
									for(say=0;say<document.getElementsByName('digital_assets').length;say++) document.getElementsByName('digital_assets')[say].checked = false;
									vueThis.output_type = vueThis.delivery_type = vueThis.output_file_name = vueThis.subject = "";
									vueThis.wocArray = [];
									vueThis.saveStatus = false;
	
									//Butonlardan loader ikonları kaldırılır
									vueThis.form.find("button#save").prop('disabled',false).html('<cf_get_lang dictionary_id = "57461.Kaydet">');
									vueThis.form.find("button#print").prop('disabled',false).html('<cf_get_lang dictionary_id = "57474.Yazdır">');
									vueThis.form.find("button#download").prop('disabled',false).html('<cf_get_lang dictionary_id = "43675.İndir">');
	
								}else vueThis.startWocSaveRequest( index + 1 ); //Henüz wocArray içerisindeki tüm itemler kaydedilmediyse yeniden ajax süreci başlar.
	
							}else{
								alert('<cf_get_lang dictionary_id = "60838.Kayıt Başarısız">');
								vueThis.form.find("button#save").prop('disabled',false).html('<cf_get_lang dictionary_id = "57461.Kaydet">');
								vueThis.form.find("button#print").prop('disabled',false).html('<cf_get_lang dictionary_id = "57474.Yazdır">');
								vueThis.form.find("button#download").prop('disabled',false).html('<cf_get_lang dictionary_id = "43675.İndir">');
							}
	
						});
					}, 100);
	
				},
				removeWoc : function (index,woj_id) {
					if(confirm("<cf_get_lang dictionary_id = '48604.Silmek istediğinizden emin misiniz'>?")){
						var vueThis = this;
						var data = new FormData();
						data.append("woj_id", woj_id);
						AjaxControlPostDataJson( 'V16/objects/cfc/woc.cfc?method=delete', data, function ( response ){
							if( response.status ){
								vueThis.$delete( vueThis.taskList, index );
								vueThis.waitingCount--;
							}else alert('<cf_get_lang dictionary_id = "60841.Silme işlemi sırasında bir hata oluştu">!');
						});
					}
				},
				getMail : function() {
					if( $.trim( $("#output_fuseaction").val() ) != '' ){
						var data = new FormData();
						data.append("wo", $("#output_fuseaction").val());
						data.append("action_id", $("#action_id").val());
						AjaxControlPostDataJson( 'V16/objects/cfc/woc.cfc?method=getMail', data, function ( response ){
							if( response.status ){
								var data = response.data[0];
								if( data.type == 'comp' && data.compmail != '' ) $("#emp_name").val( $("#emp_name").val() + data.compmail + "," );
								else if( data.type == 'cons' && data.conmail != '' ) $("#emp_name").val( $("#emp_name").val() + data.conmail + "," ) ;
								else alert('<cf_get_lang dictionary_id = "60842.Hesabın mail adresi tanımlı değil">!');
							}else alert('<cf_get_lang dictionary_id = "60846.Herhangi bir hesap bulunamadı">!');
						});
					}else alert("<cf_get_lang dictionary_id = '61030.Mail bilgilerinin alınabilmesi için fuseaction alanının doldurulması gereklidir'>!");
				},
				runWoc : function () {
					this.runStatus = true;
					$("button[id = runWoc]").prop('disabled',true).html('<i class="fa fa-spin fa-spinner"></i>');
					errorCounter = successCounter = 0;
					startRequest( $("div#table_taskList table input[type = hidden]:first-child").val(), 0 );
				}
			}
		})
	
		function print() { 
			/* javascript kodları ile doldurulduğu zaman dom dan alıp başka bir yere göndermede hata verdiği için kapatıldı. */
			/* var auto_print_page = window.frames["auto_print_page"]; 
			var printContent = auto_print_page.document.getElementById('woc_preview') != undefined ? auto_print_page.document.getElementById('woc_preview').innerHTML : auto_print_page;
			window.frames['printer'].document.body.innerHTML = printContent; */
			window.frames["auto_print_page"].onbeforeprint = (event) => {  
				auto_print_page.document.getElementById('woc_preview').style.overflow = 'visible'; /* print önizlemede overflow içeriğin tamamı görünmediği için eklendi.  */
			};
			window.frames["auto_print_page"].print();
			auto_print_page.document.getElementById('woc_preview').style.overflow = 'auto';
		}
	
		function preview() {
			is_xml = list_getat(document.addwoc.form_type.value,1,',');//1 ise XML 
			form_type = list_getat(document.addwoc.form_type.value,2,',');
			url = '<cfoutput>/V16/objects/cfc/woc.cfc?method=preview#address#</cfoutput>&'+<cfif isdefined('get_templates')>'template_id='+is_xml<cfelse>'form_type=' + form_type + '&is_xml=' + is_xml</cfif> + '';
			SetIFrameSource('auto_print_page',url);
		}
		function designer(){
			window.open('<cfoutput>#request.self#?fuseaction=objects.popup_print_designer&#iif(isdefined("attributes.iid") and len(attributes.iid),DE("iid=#attributes.iid#&"),DE(""))#action_id=#attributes.action_id#&template_id=</cfoutput>' + document.addwoc.form_type.value,'list');
		}
	
		function resizeIFrame() {
			setTimeout(() => {
	
				var a4Height = 1100,
					a4Width = 795;
	
				var iFrame = document.getElementById("auto_print_page"),
					auto_print_page = window.frames["auto_print_page"],
					wocPreviewHeight = auto_print_page.document.getElementById('woc_preview') != undefined ? auto_print_page.document.getElementById('woc_preview').offsetHeight + 50 : a4Height,
					woc_preview_box_width = $("#woc_preview_box .portBoxBodyStandart").width();
	
				if( wocPreviewHeight > a4Height ){ //İçerik A4 ebatlarından büyükse
	
					iFrame.height = a4Height + 50;
					auto_print_page.document.getElementById('woc_preview').style.height = a4Height;
					auto_print_page.document.getElementById('woc_preview').style.overflow = 'auto';
	
				}else iFrame.height = wocPreviewHeight;
	
				if( woc_preview_box_width < a4Width ){
					auto_print_page.document.getElementById('woc_preview').style.overflow = 'auto';
				}
			}, 500);
		}
		window.addEventListener('DOMContentLoaded', function(e) { resizeIFrame() } );
		$(window).on('resize', function(){ resizeIFrame()});
	
		function SetIFrameSource(cid, url)
		{
			var myframe = document.getElementById(cid);
			show(cid);
			try{hide(cid + '_message');} catch(e){}
			if(myframe !== null)
			{
				if(myframe.src) myframe.src = url; // Explorer eski surum case'i
				else if(myframe.contentWindow !== null && myframe.contentWindow.location !== null) myframe.contentWindow.location = url; // Chrome case'i
				else myframe.setAttribute('src', url); // Explorer yeni surum case'i
				resizeIFrame();
			}
		}
		function kontrol_type(i)
		{
			if (document.getElementById("mail_pdf").checked) mail_pdf = 1;
			else mail_pdf = 0;
			secilen_ = list_getat(document.addwoc.form_type.value,2,',');
			if(secilen_!= '')
			{
				if(i == 1) windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_send_mail_duty_claim#address#&form_type=</cfoutput>'+secilen_+'&mail_pdf='+mail_pdf,'date');
				else if (i == 2) windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_send_mail_mutabakat#address#&form_type=</cfoutput>'+secilen_+'&mail_pdf='+mail_pdf,'date');
			}else alert("<cf_get_lang dictionary_id='34676.Modül içi yazıcı belgesi seçmelisiniz'>!");
		}
		function sel_digital_asset_group()
		{
			for(say=0;say<document.getElementsByName('digital_assets').length;say++) document.getElementsByName('digital_assets')[say].checked = false;
			var GET_ASSET_GROUP = wrk_safe_query('ascr_get_emp_asset_group','dsn',0,document.getElementById('property_id').value);
			if(GET_ASSET_GROUP.recordcount){
				var group_list = '0';
				for(say=0;say<GET_ASSET_GROUP.recordcount;say++) group_list = group_list+','+GET_ASSET_GROUP.GROUP_ID;
				for(say=1;say<=document.getElementsByName("digital_assets").length;say++){
					if(list_find(group_list,document.getElementsByName("digital_assets")[say-1].value)) document.getElementsByName("digital_assets")[say-1].checked = true;
					else document.getElementsByName("digital_assets")[say-1].checked = false;
				}
			}
		}
	</script>