<!--- FBS 20120907 Adres Defteri Duzenlendi, Sayfa Tipi; 0 Adres Defteri Listesi, 1 Adres Defteri Mail Gonderim Listesi --->
<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact='correspondence.addressbook'><!---20131023--->
<cfif isdefined("attributes.draggable") and not isdefined('attributes.phone_list')><cfset page_type = 1><cfelse><cfset page_type = 0></cfif>
<cfparam name="attributes.search_type" default="">
<cfparam name="attributes.special_emp" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_group" default="">
<cfparam name="attributes.modal_id" default="">
<cfif isDefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_address.cfm">
<cfelse>
	<cfset get_address.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_address.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif page_type neq 1 and not isdefined('attributes.phone_list')>
	<cf_catalystHeader>
</cfif>
<cfset adres = "&is_form_submitted=1">
<cfset adres="#adres#&search_type=#attributes.search_type#">
<cfset adres="#adres#&special_emp=#attributes.special_emp#">
<cfif isDefined("attributes.names") and Len(attributes.names)><cfset adres = "#adres#&names=#attributes.names#"></cfif>
<cfif isDefined("attributes.mail_id") and Len(attributes.mail_id)><cfset adres = "#adres#&mail_id=#attributes.mail_id#"></cfif>
<cfif isDefined("attributes.phone_list")><cfset adres = "#adres#&phone_list=#attributes.phone_list#"></cfif>
<cfset extra = "">				 
<cfif page_type eq 1>
	<cfif isDefined("attributes.receivers") and Len(attributes.receivers)><cfset extra = "#extra#&receivers=#attributes.receivers#&receivers_no=#attributes.receivers_no#"></cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
	<cf_box title="#getLang('','Adres defteri',57429)#" id="2"  collapsable="0" scroll="1" resize="0"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="adres" is_group="#page_type#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form1" id="form1" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&#adres#">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<cfoutput>
				<input type="hidden" name="is_group" id="is_group" value="#attributes.is_group#">
			</cfoutput>
			<!-- sil --><cf_box_search more="0"> 
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','filtre','57460')#" value="#attributes.keyword#" maxlength="50" style="width:120px;">
				</div>
				<div class="form-group" id="special_emp">
					<select name="special_emp" id="special_emp" >
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif isDefined('attributes.special_emp') and attributes.special_emp eq 1>selected</cfif>><cf_get_lang dictionary_id='51240.Özel Kayıtlar'></option>
						<option value="0" <cfif isDefined('attributes.special_emp') and attributes.special_emp eq 0>selected</cfif>><cf_get_lang dictionary_id='51241.Genel Kayıtlar'></option>
					</select>
				</div>
				<div class="form-group" id="search_type">
					<select name="search_type" id="search_type">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='57979.Özel'></option>
						<cfif IsDefined('is_show_employee_detail') and is_show_employee_detail eq 1><!---20131023--->
							<option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='30368.Çalışan'></option>
						</cfif>
						<option value="2" <cfif isDefined('attributes.search_type') and attributes.search_type is 2>selected</cfif>><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>
						<option value="3" <cfif isDefined('attributes.search_type') and attributes.search_type is 3>selected</cfif>><cf_get_lang dictionary_id='29828.Kurumsal Üye Çalışanı'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">    
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1' , #attributes.modal_id#)"),DE(""))#"><!---  search_function = 'control()' --->
				</div>	
				<cfif page_type neq 1>
					<div class="form-group">
						<cfif not listfindnocase(denied_pages,'correspondence.popup_new_rec')><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=correspondence.popup_new_rec</cfoutput>')" class="ui-btn ui-btn-gray" ><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='58493.Kayıt Ekle'>" title="<cf_get_lang dictionary_id='58493.Kayıt Ekle'>"></i></a></cfif>
					</div>
					<div class="form-group">
						<a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_label')"  class="ui-btn ui-btn-gray2"><i class="fa fa-ticket" alt="<cf_get_lang dictionary_id='34683.Etiket'>" title="<cf_get_lang dictionary_id='34683.Etiket'>"></i></a>
					</div>
					<cfif not isdefined("attributes.draggable")>
						<div class="form-group">
							<a href="javascript:history.go(-1);" class="ui-btn ui-btn-gray"><i class="fa fa-arrow-left"></i></a>
						</div>
					</cfif>							
				</cfif>
			</cf_box_search>
		</cfform>
		<cf_ajax_list> 
			<cfif isDefined("attributes.is_group") and Len(attributes.is_group)><!--- Gruplar --->
				<thead>
					<tr>
						<th colspan="2"><cf_get_lang dictionary_id='58969.Grup Adı'></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_address.RecordCount>
						<cfoutput query="get_address" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif type eq 1>
							<!--- Kullanici Gruplari --->
							<cfquery name="get_names" datasource="#dsn#">
								SELECT
									1 TYPE,
									'emp' MEMBER_TYPE,
									EP.POSITION_CODE MEMBER_CODE,
									EP.EMPLOYEE_NAME MEMBER_NAME,
									EP.EMPLOYEE_SURNAME MEMBER_SURNAME,
									EP.EMPLOYEE_EMAIL MEMBER_EMAIL
								FROM 
									USERS U,
									EMPLOYEE_POSITIONS EP
								WHERE
									LEN(EP.EMPLOYEE_EMAIL) > 1 AND
									U.POSITIONS LIKE '%,' + CAST(EP.POSITION_CODE AS NVARCHAR(50)) + ',%' AND
									U.GROUP_ID = #group_id#
							UNION ALL
								SELECT 
									2 TYPE,
									'par' MEMBER_TYPE,
									CP.PARTNER_ID MEMBER_CODE,
									CP.COMPANY_PARTNER_NAME MEMBER_NAME,
									CP.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
									CP.COMPANY_PARTNER_EMAIL MEMBER_EMAIL
								FROM 
									USERS U,
									COMPANY_PARTNER CP
								WHERE
									LEN(CP.COMPANY_PARTNER_EMAIL) > 1 AND
									U.PARTNERS LIKE '%,' + CAST(CP.PARTNER_ID AS NVARCHAR(50)) + ',%' AND
									U.GROUP_ID = #group_id#
							UNION ALL
								SELECT
									3 TYPE,
									'con' MEMBER_TYPE,
									C.CONSUMER_ID MEMBER_CODE,
									C.CONSUMER_NAME MEMBER_NAME,
									C.CONSUMER_SURNAME MEMBER_SURNAME,
									C.CONSUMER_EMAIL MEMBER_EMAIL
								FROM 
									USERS U,
									CONSUMER C
								WHERE
									LEN(C.CONSUMER_EMAIL) > 1 AND
									U.CONSUMERS LIKE '%,' + CAST(C.CONSUMER_ID AS NVARCHAR(50)) + ',%' AND
									U.GROUP_ID = #group_id#
							</cfquery>
						<cfelse>
							<!--- Is Gruplari --->
							<cfquery name="get_names" datasource="#dsn#">
								SELECT
									1 TYPE,
									'emp' MEMBER_TYPE,
									EMPLOYEE_POSITIONS.EMPLOYEE_ID MEMBER_CODE,
									EMPLOYEE_POSITIONS.EMPLOYEE_NAME MEMBER_NAME,
									EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME MEMBER_SURNAME,
									EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL MEMBER_EMAIL
								FROM 
									EMPLOYEE_POSITIONS,
									WORKGROUP_EMP_PAR
								WHERE
									LEN(EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL) > 1 AND
									EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
									EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
									EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
									WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#group_id#">
							UNION ALL
								SELECT
									2 TYPE,
									'par' MEMBER_TYPE,
									COMPANY_PARTNER.PARTNER_ID MEMBER_CODE,
									COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
									COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
									COMPANY_PARTNER.COMPANY_PARTNER_EMAIL MEMBER_EMAIL
								FROM 
									COMPANY_PARTNER,
									COMPANY,
									WORKGROUP_EMP_PAR
								WHERE
									LEN(COMPANY_PARTNER.COMPANY_PARTNER_EMAIL) > 1 AND
									COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
									COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
									WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#group_id#">
								ORDER BY
									MEMBER_NAME,
									MEMBER_SURNAME,
									MEMBER_EMAIL
							</cfquery>
						</cfif>		
						<cfset w_name_surname = "">
						<cfset w_email = "">			
						<cfset w_pos_code = "">			
						<cfif get_names.recordcount>
							<cfloop query="get_names">
								<cfset w_name_surname = ListAppend(w_name_surname, "#member_name# #member_surname#")>
								<cfset w_email = ListAppend(w_email, "#member_email#")>
								<cfset w_pos_code = ListAppend(w_pos_code, "#member_type#-#member_code#")>
							</cfloop>
						</cfif>
						<tr>
							<td><cfif len(w_name_surname)><a href="javascript://" onClick="don('#w_name_surname#','#w_email#','#w_pos_code#')">#group_name#</a><cfelse>#group_name#</cfif></td>
							<td style="width:15px;"><cfif Len(w_name_surname)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_mail&mails=#w_email#&names=#w_name_surname#','small')"><img src="images/messenger8.gif"></a></cfif></td>
						</tr>	  
						</cfoutput>	    
					<cfelse>
						<tr>
							<td colspan="5" height="20"><cfif isDefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</cfif>
				</tbody>
			<cfelse>
				<thead>
					<tr>
						<th style="width:25px;"><cf_get_lang dictionary_id='57487.No'></th>
						<cfif page_type eq 1><th><cf_get_lang dictionary_id='32508.E-mail'></th></cfif>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<cfif page_type neq 1>
							<th style="width:80px;"><cf_get_lang dictionary_id='58143.İletişim'></th>
							<th style="width:80px;"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=correspondence.popup_new_rec</cfoutput>')"  ><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='58493.Kayıt Ekle'>" title="<cf_get_lang dictionary_id='58493.Kayıt Ekle'>"></i></a></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfif get_address.recordcount>
						<cfoutput query="get_address" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif Len(employee_id)>
								<cfset member_type='employee'>
								<cfset member_id=employee_id>
							<cfelseif Len(consumer_id)>
								<cfset member_type='consumer'>
								<cfset member_id=consumer_id>
							<cfelseif Len(partner_id)>
								<cfset member_type='partner'>
								<cfset member_id=partner_id>
							<cfelse>
								<cfset member_type = "">
								<cfset member_id = "">
							</cfif>
						<cfif not (IsDefined('is_show_employee_detail') and is_show_employee_detail eq 0 and member_type eq 'employee')><!---20131023--->
						<tr>
							<td>#get_address.currentrow#</td>
							<cfif page_type eq 1>
								<td><a href="javascript://" onClick="don('#ab_name# #ab_surname#','#Trim(ab_email)#','#Left(member_type,3)#-#member_id#')">#ab_email#</a></td>
								<td>#ab_name# #ab_surname#</td>
							<cfelseif isdefined("attributes.phone_list")>
								<td><a href="javascript://" onClick="copy_phone('<cfif len(AB_TEL1)>#AB_TELCODE##AB_TEL1#<cfelseif len(AB_TEL2)>#AB_TELCODE##AB_TEL2#<cfelseif len(AB_MOBILCODE) and len(AB_MOBIL)>#AB_MOBILCODE##AB_MOBIL#</cfif>')">#AB_NAME# #AB_SURNAME#</a></td> 
							<cfelse>           	
								<td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=correspondence.popup_upd&id=#ab_id#')">#AB_NAME# #AB_SURNAME#</a></td>
							</cfif>
							<td>#AB_COMPANY#</td>
							<td style="width:150px;"><cfif member_type is 'employee'>
								<cf_get_lang dictionary_id='30368.Çalışan'>
								<cfelseif member_type is 'consumer'>
									<cf_get_lang dictionary_id='57586.Bireysel Üye'>
								<cfelseif member_type is 'partner'>
									<cf_get_lang dictionary_id='29828.Kurumsal Üye Çalışanı'>
								<cfelse>
									<cf_get_lang dictionary_id='57979.Özel'>
								</cfif>
							</td>
							<cfif page_type neq 1>
								<td>
									<cfif isdefined("attributes.phone_list")>
										<cf_santral tel="#iif(len(AB_TEL1),DE('#AB_TELCODE##AB_TEL1#'),DE(''))#" tel2="#iif(len(AB_TEL2),DE('#AB_TELCODE##AB_TEL2#'),DE(''))#"	mobil="#iif(len(AB_MOBILCODE) and len(AB_MOBIL),DE('#AB_MOBILCODE##AB_MOBIL#'),DE(''))#" is_iframe="1">
									<cfelse>
										<ul class="ui-icon-list">
											<cfif len(AB_TEL1)><li><a href="tel://#AB_TELCODE##AB_TEL1#"><i class="fa fa-phone" alt="#AB_TELCODE#-#AB_TEL1#" title="#AB_TELCODE#-#AB_TEL1#"></i></a></li></cfif>
											<cfif len(AB_TEL2)><li><a href="javascript://"><i class="fa fa-phone" alt="#AB_TELCODE#-#AB_TEL2#" title="#AB_TELCODE#-#AB_TEL2#"></i></a></li></cfif>
											<cfif len(AB_FAX)><li><a href="javascript://"><i class="fa fa-fax" alt="#AB_TELCODE# - #AB_FAX#" title="#AB_TELCODE#-#AB_FAX#"></i></a></li></cfif>
											<cfif len(AB_EMAIL)><li><a href="mailto:#AB_EMAIL#"><i class="fa fa-envelope" alt="#AB_EMAIL#" title="#AB_EMAIL#"></i></a></li></cfif>
											<cfif len(AB_MOBILCODE) and len(AB_MOBIL) and (session.ep.our_company_info.sms eq 1)>
												<li>
													<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&sms_action=#fuseaction#','small');">
														<i class="fa fa-mobile-phone" alt="<cf_get_lang dictionary_id='58590.SMS Gönder'>" title="#AB_MOBILCODE#-#AB_MOBIL#"></i>
													</a>
												</li>
											</cfif>
										</ul>
									</cfif>
								</td>
								<td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=correspondence.popup_upd&id=#ab_id#')"><i class="fa fa-pencil" ></i></a></td>
							</cfif>
						</tr>
						</cfif>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="5"><cfif isDefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</cfif>
				</tbody>
			</cfif>
		</cf_ajax_list><!-- sil -->
		<cfif page_type eq 1>
			<cfform name="extra_values" id="extra_values" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
				<cfoutput>
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				<input type="hidden" name="receivers" id="receivers" value="<cfif isDefined("attributes.receivers")>#attributes.receivers#</cfif>">
				<input type="hidden" name="receivers_no" id="receivers_no" value="<cfif isDefined("attributes.receivers_no")>#attributes.receivers_no#</cfif>">
				<input type="hidden" name="keyword" id="keyword" value="<cfif isdefined("attributes.keyword")>#attributes.keyword#</cfif>">
				<input type="hidden" name="page" id="page" value="#attributes.page#">
				<input type="hidden" name="names" id="names" value="<cfif isdefined("attributes.names") and len(attributes.names)>#attributes.names#</cfif>">
				<input type="hidden" name="mail_id" id="mail_id" value="<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>#attributes.mail_id#</cfif>">
				</cfoutput>
			</cfform>
		</cfif>
		<!-- sil -->
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="#adres#&keyword=#attributes.keyword#">
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset adres = '#adres#&draggable=#attributes.draggable#'>
			</cfif>
			<cfif Len(attributes.is_group)><cfset adres = "#adres#&is_group=#attributes.is_group#"></cfif>
			<cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#attributes.fuseaction##adres##extra#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
				
		</cfif>
		<!-- sil -->
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	//Mail Adres Defteri Listesi Kontrolleri
	var name_  = "";
	var no_ = "";
	<cfif isdefined("attributes.names") and len(attributes.names)>
		var name_ = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.names#</cfoutput>.value;
	</cfif>
	<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
		var no_ = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.mail_id#</cfoutput>.value;
	</cfif>

	function don(names,mails,id)
	{
		if (extra_values.receivers.value != '')
			name_ = extra_values.receivers.value;
	
		if (extra_values.receivers_no != '')
			no_ = extra_values.receivers_no.value;						 			 
							 
		if ((mails.indexOf("@") == -1) || (mails.indexOf(".") == -1) || (mails.length < 6))
		{
			alert("<cf_get_lang dictionary_id='32757.Girdiğiniz Mail Geçerli Değil !'>'>");
			return false;			
		}
		if (name_ == "") 
			 name_ = mails + ",";
		else
			if (name_.substr(name_.length-1,1) == ",")
				name_  = name_  + mails + ',';
			else
				name_  = name_  + ',' + mails + ",";
			 
		if (no_ == "")	 
			 no_ = id + ",";
		else
			if (no_.substr(no_.length-1,1) == ",") 
				no_ = no_ + id + ",";
			else
				no_ = no_ + "," + id+ ",";
	
		<cfif isdefined("attributes.names") and len(attributes.names)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.names#</cfoutput>.value  = name_;
		</cfif>
		<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.mail_id#</cfoutput>.value = no_;
		</cfif>
		extra_values.receivers.value = name_;
		extra_values.receivers_no.value = no_;
		<cfif isDefined("attributes.draggable")>loadPopupBox('extra_values' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>document.getElementById("extra_values").submit();</cfif>
	}
	//Mail Adres Defteri Listesi Kontrolleri
	function copy_phone(tel){
		if(tel){
			$("#address_form #keyword").val(tel);
			<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>			
		}
		return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
