<cf_get_lang_set module_name="pos">
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = date_add('d',-3,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.location_in" default="">
<cfparam name="attributes.department_in" default="">
<cfparam name="attributes.txt_departman_in" default="">
<cfinclude template="../query/get_sayimlar.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_sales_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_sayim">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent  variable="message"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
						<input type="hidden" name="location_in" id="location_in" value="<cfoutput>#attributes.location_in#</cfoutput>">
						<input type="hidden" name="department_in" id="department_in" value="<cfoutput>#attributes.department_in#</cfoutput>">
						<cfinput type="text" name="txt_departman_in" value="#attributes.txt_departman_in#"style="width:150px;" placeholder="#message#">
						<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=search_form&field_name=txt_departman_in&field_id=department_in&field_location_id=location_in<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>

					</div>	
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" required="yes" message="#message#"></td>
				</div>
				<div class="form-group">
					<!---<input type="image" border="0" src="images/ara.gif" onClick="return date_check(document.search_form.startdate,document.search_form.finishdate,'<cfoutput>#message#</cfoutput>');">--->
					<cf_wrk_search_button button_type="4" search_function="date_check(document.search_form.startdate,document.search_form.finishdate,'#message#')" is_excel='0'>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<search_function="date_check(search_form.startdate,search_form.finishdate,'#message_date#')">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

	<cfsavecontent variable="message"><cf_get_lang dictionary_id='36078.Dönem Başı'>/ <cf_get_lang dictionary_id='36079.Devir Sayımlar'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57468.Belge'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th align="left"><cf_get_lang dictionary_id ='36080.Toplam Maliyet'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th></th>
					<th></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=pos.list_sayim&event=add</cfoutput>"><i class="fa fa-plus"title="<cf_get_lang dictionary_id='58493.Kayıt Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_sales_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#branch_name# - #comment#</td>
						<td><a href="#file_web_path#store#dir_seperator##FILE_NAME#"><img src="/images/attach.gif"></a>&nbsp;<a href="#request.self#?fuseaction=pos.list_sayim&event=upd&file_id=#GIRIS_ID#" class="tableyazi">#FILE_NAME#</a></td>
						<td>#description#</td>
						<td align="right" style="text-align:right;">#TlFormat(toplam_maliyet)#<cfif toplam_maliyet gt 0> #session.ep.money#</cfif></td>
						<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
						<td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)#</td>
						<td><cfif not len(fis_id)><a href="javascript://" onClick="delete_sayim(#giris_id#,0);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='36082.Dosya Sil'>"></i></a></cfif></td>
						<td><cfif len(fis_id)><a href="javascript://" onClick="delete_sayim(#giris_id#,1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='36016.Stok Fişlerini Sil'>"></i></a></cfif></td>
						<td>
						<cfif session.ep.isBranchAuthorization eq 0>
							<cfif not len(fis_id)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=pos.popup_add_sayim_to_stock_receipt&file_id=#giris_id#&department_in=#department_in#&location_in=#location_in#','small');"><img src="/images/workdevwork.gif" title="<cf_get_lang dictionary_id ='36081.Stok Fişine Çevir'>"></a></cfif>
						</cfif>
						</td>
					</tr> 
				</cfoutput>
				<cfif not get_sales_imports.recordcount>
					<tr>
						<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
			<cfset url_string = ''>
			<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
			</cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
				<cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
			</cfif>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="pos.list_sayim#url_string#">
		</cfif>
		<form name="delete_form" method="post" action="<cfoutput>#request.self#?fuseaction=pos.emptypopup_del_sayim</cfoutput>">
			<input type="hidden" name="file_id" id="file_id" value="">
			<input type="hidden" id="my_type" name="my_type" value="" />
		</form>
	</cf_box>
</div>
<script language="JavaScript" type="text/javascript">
	function delete_sayim(entry_id,type_)
	{
		if(confirm("<cf_get_lang dictionary_id ='36083.Dosyayı Silmek İstediğinizden Emin Misiniz'>?"))
		{
			windowopen('','small','del_sayim');
			document.delete_form.target = 'del_sayim';
			document.delete_form.file_id.value = entry_id;
			document.delete_form.my_type.value = type_;
			document.delete_form.submit();
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
