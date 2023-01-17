<!--- File: list_company_partner.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 11.10.2019
    Controller: -
    Description: Kurumsal üye çalışanlar listeleme alını sorguları member_company sayfasına taşındı .​
 --->
<cfsetting showdebugoutput="no">
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfif isdefined("is_active") and is_active eq 1>
	<cfparam name="attributes.partner_status" default="1">
<cfelse>
	<cfparam name="attributes.partner_status" default="">
</cfif>
<cfif not isDefined("url.brid")>
	<cfset GET_PARTNER = company_cmp.GET_PARTNER_EMP(
						partner_status:'#iIf(isdefined("attributes.partner_status") and len(attributes.partner_status),"attributes.partner_status",DE(""))#',
						is_only_active_partners:'#iIf(isdefined("is_only_active_partners") and len(is_only_active_partners),"is_only_active_partners",DE(""))#',
						cpid:'#iIf(isdefined("url.cpid") and len(url.cpid),"url.cpid",DE(""))#',
						pid:'#iIf(isdefined("url.pid") and len(url.pid),"url.pid",DE(""))#'
					)>
<cfelse>
    <cfset GET_PARTNER = company_cmp.GET_PARTNER_SECOND(
						brid:'#iIf(isdefined("url.brid") and len(url.brid),"url.brid",DE(""))#' 
					)>
</cfif>  
<cfform name="form_partner" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=#attributes.partner_status#">
	<cf_box_search more="0">
		<div class="form-group">
			<select name="partner_status" id="partner_status" style="width:60px;">
				<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
				<option value="1" <cfif attributes.partner_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
				<option value="0" <cfif attributes.partner_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
			</select>
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" search_function="connectAjax_partner()">
		</div>
	</cf_box_search>
</cfform>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='57453.Şube'></th>
			<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
			<th><cf_get_lang dictionary_id='58143.İletişim'></th>
			<th><cf_get_lang dictionary_id='57756.Durumu'></th>
		</tr>
    </thead>
    <tbody>
	<cfif get_partner.recordcount>
		<cfset im_cats = ''>
		<cfoutput query="get_partner">
			<cfif len(get_partner.IMCAT_ID)>
				<cfset im_cats = listappend(im_cats,IMCAT_ID)>
			</cfif>
			<cfif len(get_partner.IMCAT2_ID)>
				<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
			</cfif>
		</cfoutput>
		<cfif listlen(im_cats)>
			<cfset get_ims = company_cmp.get_imscat(im_cats:im_cats)> 
			<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_partner">
			<tr <cfif company_partner_status eq 0>style="color:999999;"</cfif>>
				<td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#partner_id#" <cfif company_partner_status eq 0>style="color:999999;"<cfelse>class="tableyazi"</cfif>>#company_partner_name# #company_partner_surname#</a></td>
				<td><cfif (compbranch_id eq 0) or not len(compbranch_id)>
					<cf_get_lang dictionary_id='30319.Merkez Ofis'>
					<cfelse>
					<cfset GET_PARTNER_BRANCH = company_cmp.GET_PARTNER_BRANCH(PARTNER_ID:get_partner.PARTNER_ID)>  
						#get_partner_branch.compbranch__name#
					</cfif>
			
				</td>
				<td>#title#</td>
				<td>
					<ul class="ui-icon-list" style="justify-content:left!important">
					<cfif len(company_partner_email)><li><a href="mailto:#company_partner_email#"><i class="fa fa-envelope" title="E-mail:#company_partner_email#"></i></a></li></cfif>
					<cfif len(company_partner_tel)><li><a href="javascript://"><i class="fa fa-phone" title="Tel:#company_partner_telcode#-#company_partner_tel#"></i></a></li></cfif>
					<cfif len(company_partner_fax)><li><a href="javascript://"><i class="fa fa-fax" title="Fax:#company_partner_telcode#-#company_partner_fax#"></i></a></li></cfif>
					<cfif len(mobiltel)><li><a href="javascript://" <cfif session.ep.our_company_info.sms eq 1>onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#PARTNER_ID#&sms_action=#fuseaction#','small','popup_form_send_sms');"</cfif>><i class="fa fa-mobile-phone" alt="#mobil_code#-#mobiltel#" title="#mobil_code#-#mobiltel#"></i></a></li></cfif>
					<cfif Len(IMCAT_ID) and isdefined('get_ims.IMCAT_ICON')>
						<cfset IMCAT_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT_ID,',')]>
						<cfset IMCAT_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT_ID,',')]>
					<cfelse>
						<cfset IMCAT_ICON = "">
						<cfset IMCAT_LINK_TYPE = "">
					</cfif>
					<cfif Len(IMCAT2_ID) and isdefined('get_ims.IMCAT_ICON')>
						<cfset IMCAT2_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT2_ID,',')]>
						<cfset IMCAT2_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT2_ID,',')]>
					<cfelse>
						<cfset IMCAT2_ICON = "">
						<cfset IMCAT2_LINK_TYPE = "">
					</cfif>
				</ul>
					#IMsgIcon()#
				</td>
				<td><cfif get_partner.company_partner_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><font color="999999"><cf_get_lang dictionary_id='57494.Pasif'></font></cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
		</tr>
	</cfif>
    </tbody>
	<div style="width:300px;display:none;" id="show_partner_message"></div>
</cf_ajax_list>
<script type="text/javascript">
	function connectAjax_partner()
	{	
		  partnr_status = document.getElementById("partner_status").value ;
		AjaxFormSubmit(form_partner,'show_partner_message',0,' ',' ','<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active='+partnr_status</cfoutput>,'body_list_company_partner');
	}
</script>
