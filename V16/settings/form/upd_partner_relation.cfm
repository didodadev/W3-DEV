<!--- kurumsal-bireysel-sistem ilişki üye tipleri için ortak sayfadır--->
<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
	<cfquery name="GET_RELATION_ID" datasource="#DSN#"><!--- bu tanımlarla kayıtt yapılmımı kontrolü --->
		SELECT PARTNER_RELATION_ID FROM COMPANY_PARTNER_RELATION WHERE PARTNER_RELATION_ID=#URL.PARTNER_RELATION_ID#
	</cfquery>
<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
	<cfquery name="GET_RELATION_ID" datasource="#DSN#">
		SELECT RELATION_ID FROM CONSUMER_TO_CONSUMER WHERE CONSUMER_RELATION_ID=#URL.PARTNER_RELATION_ID#
	</cfquery>
<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
	<cfquery name="GET_RELATION_ID" datasource="#DSN3#">
		SELECT SUBS_ROW_ID FROM SUBSCRIPTION_CONTRACT_RELATIONS WHERE RELATION_TYPE_ID=#URL.PARTNER_RELATION_ID#
	</cfquery>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="35" class="headbold"><cfif attributes.relation_type_info eq 1><cf_get_lang no='696.Kurumsal Üye İlişkisi Güncelle'><cfelseif attributes.relation_type_info eq 2><cf_get_lang no='605.Bireysel Üye İlişkisi Güncelle'><cfelseif attributes.relation_type_info eq 3><cf_get_lang no ='2145.Sistem İlişkisi Güncelle'></cfif></td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=settings.form_add_partner_relation&relation_type_info=#attributes.relation_type_info#</cfoutput>"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_partner_relation.cfm"></td>
		<td valign="top">
			<table>
				<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_partner_relation&relation_type_info=#attributes.relation_type_info#" method="post" name="position">
					<input type="hidden" name="PARTNER_RELATION_ID" id="PARTNER_RELATION_ID" value="<cfoutput>#URL.PARTNER_RELATION_ID#</cfoutput>">
					<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
						<cfquery name="get_relation_detail" datasource="#dsn#">
							SELECT
								PARTNER_RELATION RELATION_NAME,
								DETAIL,
								RECORD_DATE,
								RECORD_EMP,
								UPDATE_DATE,
								UPDATE_EMP
							FROM
								SETUP_PARTNER_RELATION
							WHERE
								PARTNER_RELATION_ID=#attributes.partner_relation_id#
						</cfquery>
					<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
						<cfquery name="get_relation_detail" datasource="#dsn#">
							SELECT
								CONSUMER_RELATION RELATION_NAME,
								CONSUMER_RELATION_DETAIL DETAIL,
								RECORD_DATE,
								RECORD_EMP,
								UPDATE_DATE,
								UPDATE_EMP
							FROM
								SETUP_CONSUMER_RELATION
							WHERE
								CONSUMER_RELATION_ID=#attributes.partner_relation_id#
						</cfquery>
					<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
						<cfquery name="get_relation_detail" datasource="#dsn#">
							SELECT
								SUBSCRIPTION_RELATION RELATION_NAME,
								DETAIL,
								RECORD_DATE,
								RECORD_EMP,
								UPDATE_DATE,
								UPDATE_EMP
							FROM
								SETUP_SUBSCRIPTION_RELATION
							WHERE
								SUBSCRIPTION_RELATION_ID=#attributes.partner_relation_id#
						</cfquery>
					</cfif>
					<tr>
						<td width="75"><cf_get_lang_main no='68.Başlık'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
							<cfinput type="Text" name="PARTNER_RELATION" size="40" value="#get_relation_detail.RELATION_NAME#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
						</td>
					</tr>
					<tr> 
						<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
						<td><textarea name="detail" id="detail" style="width:200px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı :100"><cfoutput>#get_relation_detail.DETAIL#</cfoutput></textarea></td>
					</tr>
					<tr>
						<td colspan="2" align="right" style="text-align:right;">
							<cfif GET_RELATION_ID.recordcount>
								<cf_workcube_buttons is_upd='1' is_delete='0'>				
							<cfelse>					 
								<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_partner_relation&partner_relation_id=#URL.partner_relation_id#&relation_type_info=#attributes.relation_type_info#'> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">
						<cfoutput>
							<cf_get_lang_main no='487.Kaydeden'> :
							<cfif len(get_relation_detail.record_emp)>#get_emp_info(get_relation_detail.record_emp,0,0)#</cfif>
							<cfif len(get_relation_detail.record_date)>- #dateformat(get_relation_detail.record_date,dateformat_style)#</cfif>
							<cfif len(get_relation_detail.update_date)>
								<br/>
								<cf_get_lang_main no='479.Guncelleyen'> :
								#get_emp_info(get_relation_detail.update_emp,0,0)# - #dateformat(get_relation_detail.update_date,dateformat_style)#
							</cfif>
						</cfoutput>
						</td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
