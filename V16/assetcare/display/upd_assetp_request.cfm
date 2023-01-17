<cfinclude template="../query/get_usage_purpose.cfm">
<cfquery name="GET_ASSETP_REQUEST" datasource="#DSN#">
	SELECT 
		*
    FROM 
    	ASSET_P_REQUEST
	WHERE 
    	REQUEST_ID = #attributes.request_id#
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT BRAND_ID,BRAND_NAME FROM SETUP_BRAND WHERE MOTORIZED_VEHICLE = 1 ORDER BY BRAND_NAME
</cfquery>
<cfsavecontent variable="right">
	<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_assetp_request_print&request_id=#request_id#','large')"><img src="/images/print.gif" border="0" alt="<cf_get_lang_main no ='62.Yazdır'>" title="<cf_get_lang_main no ='62.Yazdır'>"></a>
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_mail_send&request_id=#request_id#','small')"><img src="/images/mail.gif" alt="<cf_get_lang_main no ='63.Mail Gönder'>" title="<cf_get_lang_main no ='63.Mail Gönder'>" border="0"></a></cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('assetcare',737)#" right_images="#right#">
<cfform name="upd_assetp_request" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_assetp_request">
<input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.request_id#</cfoutput>">
	<table>
		<tr>
			<td><cf_get_lang_main no='74.Kategori'>*</td>
			<td><select name="cat_id" id="cat_id" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_assetp_cats">
						<option value="#assetp_catid#" <cfif get_assetp_request.assetp_catid eq assetp_catid>selected</cfif>>#assetp_cat#
					</cfoutput>
				</select>
			</td>
			<td width="50"><cf_get_lang_main no='344.Durum'></td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='160.Departman'> *</td>
			<td><input type="hidden" name="department_id" id="department_id" value="">
			<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='160.Departman'></cfsavecontent>
			<cfinput type="text" name="department" value="" required="yes" message="#alert#" readonly style="width:150px;">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=department_id&field_name=department','list');">
			<img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='160.Departman'>" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang no='127.Kullanım Amacı'></td>
			<td><select name="usage_purpose_id" id="usage_purpose_id" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_usage_purpose">
						<option value="#usage_purpose_id#" >#usage_purpose#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='82.Talep Eden'> *</td>
			<td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_assetp_request.employee_id#</cfoutput>">
			<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='82.Talep Eden'></cfsavecontent>
			<cfinput type="Text" name="employee" value="#get_emp_info(get_assetp_request.employee_id,0,0)#" required="yes" message="#alert#" readonly style="width:150px;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_assetp_request.employee_id&field_name=upd_assetp_request.employee&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='82.Talep Eden'>" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang no='123.Talep Tarihi'> *</td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'> !</cfsavecontent>
			<cfinput type="text" name="request_date" value="#dateformat(get_assetp_request.request_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#"  required="yes" style="width:150px;">
			<cf_wrk_date_image date_field="request_date"></td>
		</tr>
		<tr>
			<td colspan="4"></td>						
		</tr>
		<tr>
			<td colspan="2" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
			<td colspan="2" class="txtbold"><cf_get_lang_main no='272.Sonuç'></td>
		</tr>
		<tr>
			<td colspan="2"><textarea name="detail" id="detail" style="width:300px;height:80px;"><cfoutput>#get_assetp_request.detail#</cfoutput></textarea></td>
			<td colspan="2">
				<textarea name="result_detail" id="result_detail" style="width:380px;height:80px;"><cfoutput>#get_assetp_request.result_detail#</cfoutput></textarea>
			</td>
		</tr>
		<tr>
			<td valign="top"></td>						
		</tr>
		<tr>
			<td colspan="4"></td>           
		</tr>		
	</table>
	<cf_popup_box_footer>
		<cfif len(get_assetp_request.record_emp)>
		<cfoutput><cf_get_lang_main no ='71.Kayıt'> : #get_emp_info(get_assetp_request.record_emp,0,0)# - #dateformat(get_assetp_request.record_date,dateformat_style)#</cfoutput></cfif>
		<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
	</cf_popup_box_footer>			 
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		x = document.upd_assetp_request.cat_id.selectedIndex;
		if (document.upd_assetp_request.cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='74.Kategori'> !");
			return process_cat_control;
		}		
		
		function process_cat_control()
		{
			if (add_purchase_request.process_cat.length != undefined) /*n tane*/
			{
			for (i=0; i < add_purchase_request.process_cat.length; i++)
				{
				if(document.add_purchase_request.process_cat[i].value == '')
					{
					alert("<cf_get_lang no ='739.Araç Talebi Ekleme Yetkiniz Yok'>!")
					return false;
					}
				}
			}
			else /* 1 tane*/
			{			
			if(document.add_purchase_request.process_cat.value == '')
				{
				alert("<cf_get_lang no ='739.Araç Talebi Ekleme Yetkiniz Yok'>!")
				return false;
				}
			}
		}
		return true;
	}		
</script>
