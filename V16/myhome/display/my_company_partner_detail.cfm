<!--- INSTANT MESSAGE 1-2 ICON ve ENTEGRASYONU Linki | MG 20101130 --->
<cfscript>
	function IMsgIcon2()
	{
		ImSayisi = 2;
		for (Sayac = 1; Sayac <= ImSayisi; Sayac++)
		{
			stil = "style=""cursor: hand;""";
			if (Sayac == 1)
				Say = "";
			else
				Say = Sayac;
			if (Len(Evaluate("IMCAT#Say#_ICON")))
			{
				"Im#Say#Address" = Evaluate("IM#Say#");
				"Link#Say#Type" = Evaluate("IMCAT#Say#_LINK_TYPE");
			}
			else
			{
				"Im#Say#Address" = "Bu Instant Mesajın kategorisi bulunamadı, lütfen IM Bilgilerinizi güncelleyiniz.";
				"IMCAT#Say#_ICON" = "icons_invalid.gif";
				"Link#Say#Type" = "";
			}
			"Link#Say#" = Evaluate("Link#Say#Type") & Evaluate("Im#Say#Address");
			if (Evaluate("Link#Say#Type") == "")
			{
				"Link#Say#" = "##";
				stil = "";
			}
			if (Len(Evaluate("IMCAT#Say#_ID")))
				WriteOutput(" <img onclick=""javascript:location.href='" & Evaluate("Link#Say#") & "';"" src=""/documents/settings/#Evaluate("IMCAT#Say#_ICON")#"" border=""0"" " & stil & " alt=""" & Evaluate("Im#Say#Address") & """>");
		}
	}
</cfscript>
<cf_get_lang_set module_name="myhome">
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT
		CP.COUNTRY COUNTRY_ID,
		*
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		<cfif isdefined("is_only_active_partners") and is_only_active_partners eq 1>
			CP.COMPANY_PARTNER_STATUS = 1 AND
		</cfif>
		CP.COMPANY_ID = #attributes.cpid# AND 
		CP.COMPANY_ID = C.COMPANY_ID
	ORDER BY
		CP.COMPANY_PARTNER_NAME
	</cfquery>
	<cfset list_partner=ValueList(get_partner.partner_id,',')>
	<cfparam name="attributes.totalrecords" default='#get_partner.recordcount#'>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="31385.Kontak Kişiler"></cfsavecontent>
	<cf_ajax_list>
		<cfset im_cats = ''>
		<cfset country_list = "">
		<cfoutput query="get_partner" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif len(country_id) and not listfind(country_list,country_id,',')>
				<cfset country_list = Listappend(country_list,country_id,',')>
			</cfif>
			<cfif len(IMCAT_ID)>
				<cfset im_cats = listappend(im_cats,IMCAT_ID)>
			</cfif>
			<cfif len(IMCAT2_ID)>
				<cfset im_cats = listappend(im_cats,IMCAT2_ID)>
			</cfif>
		</cfoutput>
		<cfif listlen(im_cats)>
			<cfquery name="get_ims" datasource="#DSN#">
				SELECT IMCAT_ICON,IMCAT_LINK_TYPE,IMCAT_ID FROM SETUP_IM WHERE IMCAT_ID IN (#im_cats#)
			</cfquery>
			<cfset im_cats = listsort(listdeleteduplicates(valuelist(get_ims.IMCAT_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif Len(country_list)>
			<cfquery name="get_country_list" datasource="#dsn#">
				SELECT COUNTRY_ID,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
			</cfquery>
			<cfset country_list = ListSort(ListDeleteDuplicates(ValueList(get_country_list.country_id,',')),"numeric","asc",",")>
		</cfif>
		<tbody>
			<cfoutput query="get_partner" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
					<td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#partner_id#" class="tableyazi">#company_partner_name# #company_partner_surname#  - #title#</a></td>
					<td>
						<ul class="ui-icon-list">
						<cfif len(company_partner_email)>
							<li>
							<cfif isdefined("cubemail") and cubemail eq 1>
								<a href="#request.self#?fuseaction=correspondence.cubemail&pid=#partner_id#"><i class="icon-envelope-o" title="E-mail:#company_partner_email#"></i></a>
							<cfelse>
								<a href="mailto:#company_partner_email#"><i class="icon-envelope-o" title="E-mail:#company_partner_email#"></i></a>
							</cfif>
							</li>
						</cfif>
						<!--- <cfif len(company_partner_tel)><li><a href="javascript://"> <i class="fa fa-phone" title="Tel: <cfif len(country_id) and len(get_country_list.country_phone_code[listfind(country_list,country_id,',')])>(#get_country_list.country_phone_code[listfind(country_list,country_id,',')]#) </cfif>#company_partner_telcode# - #company_partner_tel#"></i></a></li></cfif> --->
						<cfif len(company_partner_fax)><li> <a href="javascript://"> <i class="fa fa-fax" title="Fax:#company_partner_fax#"></i></a></li></cfif>
						<cfif len(company_partner_email)><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=correspondence.add_correspondence&to_mail_id=#attributes.cpid#&member_type=company&cpid=#partner_id#','wwide1');"><i class="icon-file-text-o" title="<cf_get_lang dictionary_id='32254.Yazışma ekle'>"></i></a></li></cfif>
						<!--- <cfif len(mobiltel)><li><a href="javascript://" <cfif  session.ep.our_company_info.sms eq 1>onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#partner_id#&sms_action=#fuseaction#','small');"</cfif>><i class="icon-phone" title="#MOBIL_CODE# - #mobiltel#"  alt="#MOBIL_CODE# - #mobiltel#"></i></a></li></cfif> --->
						<cf_santral mobil = "#MOBIL_CODE##mobiltel#" tel = "#company_partner_telcode##company_partner_tel#" list="1"></cf_santral>
						<cfif not isdefined("is_from_finance")>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=call.helpdesk&event=add&partner_id=#get_partner.partner_id#&member_type=partner','project');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='32381.Etkileşim'>"></i></a>
						</cfif>
					</ul>
						<cfif Len(IMCAT_ID)>
							<cfset IMCAT_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT_ID,',')]>
							<cfset IMCAT_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT_ID,',')]>
						<cfelse>
							<cfset IMCAT_ICON = "">
							<cfset IMCAT_LINK_TYPE = "">
						</cfif>
						<cfif Len(IMCAT2_ID)>
							<cfset IMCAT2_ICON = get_ims.IMCAT_ICON[listfind(im_cats,IMCAT2_ID,',')]>
							<cfset IMCAT2_LINK_TYPE = get_ims.IMCAT_LINK_TYPE[listfind(im_cats,IMCAT2_ID,',')]>
						<cfelse>
							<cfset IMCAT2_ICON = "">
							<cfset IMCAT2_LINK_TYPE = "">
						</cfif>
						<cfscript>
							IMsgIcon2();
						</cfscript>
					</td>
					
				</tr>
			</cfoutput>
		</tbody>
	</cf_ajax_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
