<cfinclude template="../query/get_modules.cfm">
<cfform name="add_upgrade_note" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_upgrade_note">
<table cellspacing="0" cellpadding="0" border="0" align="center" width="98%">
	<tr>        
		<td height="35" class="headbold"> Upgrade Note</td>
	</tr>
</table>
<table align="center" width="98%" cellspacing="1" cellpadding="2" border="0" class="color-border">
	<tr class="color-row">
		<td valign="top" colspan="3">
		<table>
			<tr>
				<td width="80"><cf_get_lang_main no='68.Konu'> *</td>
				<td colspan="3"><input type="text" name="note_head" id="note_head" value="" maxlength="200" style="width:387px;">
				</td>
			</tr>
			<tr>
				<td> Release *</td>
				<td width="200">
					<select name="upgrade_version" id="upgrade_version" style="width:68px;">
					<cfoutput>
					<cfloop from="#dateformat(now(),'yyyy')#" to="2009" index="i" step="-1">
						<option value="#i#" <cfif i eq year(now())> selected</cfif>>#i#</option>
					</cfloop>
					</cfoutput>
					</select>
					<select name="upgrade_release" id="upgrade_release" style="width:48px;">
						<option value="1" <cfif listfind('1,2,3',month(now()))> selected</cfif>>01</option>
						<option value="2" <cfif listfind('4,5,6',month(now()))> selected</cfif>>02</option>
						<option value="3" <cfif listfind('7,8,9',month(now()))> selected</cfif>>03</option>
						<option value="4" <cfif listfind('10,11,12',month(now()))> selected</cfif>>04</option>	
					</select>
				</td>
				<td width="80"><cf_get_lang_main no='74.Kategori'> *</td>
				<td width="150">
					<select name="upgrade_cat_id" id="upgrade_cat_id" style="width:100px;">
						<option value=""><cf_get_lang_main no ='322.Seciniz'></option>
						<option value="1"> Main DB</option>
						<option value="2"><cf_get_lang_main no='245.Ürün'> DB</option>
						<option value="3"><cf_get_lang_main no='162.Şirket'> DB</option>
						<option value="4"><cf_get_lang_main no='1060.Dönem'> DB</option>
						<option value="5"><cf_get_lang_main no='22.Rapor'></option>
						<option value="6"><cf_get_lang_main no='1088.Manuel'></option>
						<option value="7"><cf_get_lang no='1570.Dosya Sistemi'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no="1447.Süreç">*</td>
				<td><cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'></td>
				<td><cf_get_lang_main no='330.Tarih'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput type="text" name="note_date" value="" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;">
					<cf_wrk_date_image date_field="note_date">
				</td>
			</tr>
			<tr>
				<td> Developer *</td>
				<td>
					<input type="hidden" name="note_emp_id" id="note_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
					<input type="text" name="note_emp_name" id="note_emp_name" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:120px;" readonly>
					<a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_upgrade_note.note_emp_id&field_name=add_upgrade_note.note_emp_name&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td colspan="2"><cf_workcube_buttons is_upd='0' add_function='form_kontrol()'></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr class="color-row">
		<td>
		<table>
			<tr class="color-row">
				<td class="formbold" onClick="gizle_goster(detail);" style="cursor:pointer;"><cf_get_lang_main no='217.Açıklama'></td>
			</tr>
			<tr class="color-row" id="detail">
				<td>
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="Basic"
						basePath="/fckeditor/"
						instanceName="detail"
						valign="top"
						value=""
						width="600"
						height="180">
				</td>
			</tr>
			<tr class="color-row">
				<td class="formbold" onClick="gizle_goster(code);" style="cursor:pointer;"><cf_get_lang no='1572.Kod Bloğu'></td>
			</tr>
			<tr class="color-row" id="code">
				<td>
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="Basic"
						basePath="/fckeditor/"
						instanceName="code"
						valign="top"
						value=""
						width="600"
						height="180">
				</td>
			</tr>	
		</table>
		</td>
	</tr>
	<tr class="color-row">
		<td valign="top">
		<table>
		<tr height="20">
				<td class="formbold" colspan="2" onClick="gizle_goster(modules);" style="cursor:pointer;"><cf_get_lang no='1604.İlgili Moduller'></td>
			</tr>
		</table>
		<table id="modules">
			<tr>
		<cfparam name="attributes.mode" default="4">
		<cfparam name="attributes.page" default=1>		
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_modules.recordcount>
		<cfoutput query="get_modules" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		  <cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
			<tr height="22">
		  </cfif>
				<td><input type="checkbox" name="LEVEL_ID_#module_id#" id="LEVEL_ID_#module_id#" value="1"></td>
				<td width="150">#module_name# - #module_id#*</td>
		<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
			</tr>
		</cfif>                  
		</cfoutput>
		</table>
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
function form_kontrol()
{
	
	if(document.add_upgrade_note.note_head.value == "")
	{ 
		alert ("<cf_get_lang no='1653.Konu Girmelisiniz'> !");
		return false;
	}

	x = document.add_upgrade_note.upgrade_cat_id.selectedIndex;
	if (document.add_upgrade_note.upgrade_cat_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'> !");
		return false;
	}

	if(document.add_upgrade_note.note_emp_id.value == "" || document.add_upgrade_note.note_emp_name.value == "")
	{ 
		alert ("<cf_get_lang no='1707.Developer Seçmelisiniz'> !");
		return false;
	}

	return process_cat_control();	
	
}	
</script>
