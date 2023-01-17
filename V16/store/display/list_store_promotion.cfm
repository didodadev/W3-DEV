<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.record_id" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.catalog_status" default="1">
<cfinclude template="../../product/query/get_price_cats.cfm">
<cfinclude template="../../product/query/get_consumer_cat.cfm">
<cfinclude template="../../product/query/get_campaign_name_with_func.cfm">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>	
	<cfset attributes.startdate = date_add('d',-15,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = date_add('d',15,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_catalog_promotion.cfm">
<cfelse>
	<cfset get_catalog.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_catalog.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" method="post" action="#request.self#?fuseaction=store.list_store_promotion">
<input name="is_form_submitted" id="is_form_submitted" value="1" type="hidden">
	<cf_big_list_search title="#getLang('store',1576)#"> 
		<cf_big_list_search_area>
			<table>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td><cf_get_lang_main no='487.Kaydeden'>
						<input type="hidden" name="record_id"  id="record_id" value="<cfoutput>#attributes.record_id#</cfoutput>">
						<input type="text" name="RECORD_EMP" id="RECORD_EMP"  value="<cfoutput>#attributes.record_emp#</cfoutput>" style="width:125px;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.record_id&field_name=form.RECORD_EMP<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif"></a>
					</td>
					<td>
						<cfsavecontent variable="message">Başlama Tarihi Girmelisiniz !</cfsavecontent>
						<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" style="width:65px;" validate="#validate_style#" required="yes" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="startdate">
					</td>
					<td>
						<cfsavecontent variable="message">Bitiş Tarihi Girmelisiniz !</cfsavecontent>
						<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">			
						<cf_wrk_date_image date_field="finishdate">
					</td>
					<td><select name="catalog_status" id="catalog_status" style="width:60px;">
							<option value="1" <cfif len(attributes.catalog_status) and (attributes.catalog_status eq 1)>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
							<option value="0" <cfif len(attributes.catalog_status) and (attributes.catalog_status eq 0)>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
							<option value="2" <cfif len(attributes.catalog_status) and (attributes.catalog_status eq 2)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
					</td>
					<td><cf_wrk_search_button search_function='kontrol()'></td>
					<td><cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'></td>
				</tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang no='140.Aksiyon'></th>
			<th width="100"><cf_get_lang_main no='34.Kampanya'></th>
			<th width="40"><cf_get_lang_main no='245.Ürün'></th>
			<th width="130"><cf_get_lang_main no='1212.Geçerlilik Tarihi'></th>
			<th width="110"><cf_get_lang_main no='88.Onay'></th>
			<th width="100"><cf_get_lang_main no='71.Kayıt'></th>
			<th width="55"><cf_get_lang_main no='330.Tarih'></th>
			<!-- sil -->
			<th class="header_icn_none"></th>
			<th class="header_icn_none"></th>
			<th class="header_icn_none"></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_catalog.recordcount>
			<cfset employee_id_list=''>
			<cfset camp_list=''>
			<cfoutput query="get_catalog" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif not listfindnocase(camp_list,GET_CATALOG.CAMP_ID)>
					<cfset camp_list=listappend(camp_list, GET_CATALOG.CAMP_ID)>    
				</cfif>
				<cfif not listfindnocase(employee_id_list, GET_CATALOG.RECORD_EMP)>
					<cfset employee_id_list=listappend(employee_id_list,GET_CATALOG.RECORD_EMP)>
				</cfif>
				<cfif not listfindnocase(employee_id_list, GET_CATALOG.VALID_EMP)>
					<cfset employee_id_list=listappend(employee_id_list,GET_CATALOG.VALID_EMP)>
				</cfif>
			</cfoutput> 
			<cfif len(camp_list)>
				<cfset camp_list=listsort(camp_list,"numeric","ASC",",")>
				<cfquery name="get_camp_name" datasource="#DSN3#">
					SELECT CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID IN (#camp_list#) ORDER BY CAMP_ID
				</cfquery>
			</cfif>
			<cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="get_emp_detail" datasource="#dsn#">
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_catalog" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset temp_count = 0>
			<tr>
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=store.detail_promotion&id=#catalog_id#" class="tableyazi">#catalog_head#</a> </td>
				<td>
					<cfif len(camp_id) and camp_id neq 0>
						<cfif get_module_user(15)>
							<a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" class="tableyazi">#get_camp_name.CAMP_HEAD[listfind(camp_list,camp_id,',')]#</a>
						<cfelse>					
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_campaign&campaign_id=#camp_id#','medium');" class="tableyazi">#get_camp_name.CAMP_HEAD[listfind(camp_list,camp_id,',')]#</a>
						</cfif>
					</cfif>
				</td>
				<td>#sayi#</td>
				<td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
				<td>
					<cfif (valid eq 1) or (valid eq 0)>
						<cfif len(valid_emp)>
							#get_emp_detail.employee_name[listfind(employee_id_list,valid_emp,',')]# #get_emp_detail.employee_surname[listfind(employee_id_list,valid_emp,',')]#
							<cfset record_date = date_add('h', session.ep.time_zone, validate_date)>(#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
						<cfelse>
							<cf_get_lang no='128.Bilinmiyor'>
						</cfif>
					<cfelse>
						<cf_get_lang_main no='203.Onay Bekliyor'>
					</cfif>
				</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_catalog.record_emp#','medium');" class="tableyazi">#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]#&nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</a> </td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<!-- sil -->
				<td width="15"><a href="#request.self#?fuseaction=store.detail_promotion&id=#catalog_id#"><img src="/images/update_list.gif" title="<cf_get_lang_main no="52.Güncelle">"></a></td>
				<td width="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.emptypopup_save_action_barcodes&catalog_id=#catalog_id#','small')"><img src="/images/barcode.gif" title="<cf_get_lang no='112.Aksiyon İçin Barcode File Oluştur'>"></a></td>
				<td width="20"><cfif len(camp_id)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.emptypopup_save_action_campaign_barcodes&camp_id=#camp_id#','small')"><img src="/images/barcode_print.gif" title="<cf_get_lang no='109.Kampanya İçin Barcode File Oluştur'>"></a></cfif></td>
				<!-- sil -->
			</tr>
		</cfoutput> 
		<cfelse>  
			<tr>
				<td colspan="11"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_store_promotion">
<cfif isDefined('attributes.catalog_status') and len(attributes.catalog_status)>
	<cfset adres = "#adres#&catalog_status=#attributes.catalog_status#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdate(attributes.startdate) and len(attributes.startdate)>
	<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isdate(attributes.finishdate) and len(attributes.finishdate)>
	<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif len(attributes.record_id) and  len(attributes.record_emp)>
	<cfset adres = '#adres#&record_id=#attributes.record_id#&record_emp=#attributes.record_emp#'>
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#adres#">
<script type="text/javascript">
document.getElementById('keyword').focus();
<!---function kontrol()
{
	<cfif not session.ep.our_company_info.unconditional_list>
	deger = datediff(document.form.startdate.value,document.form.finishdate.value,0);
	if(deger > 90 || deger <= -1)
	{
		alert("Başlangıç ve Bitiş Tarihleri Arasındaki Fark En Çok 90 Gün Olmalıdır !");
		return false;
	}
	</cfif>
	return true;
}--->
function kontrol()
{
	if( !date_check(document.getElementById('startdate'),document.getElementById('finishdate'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
		return false;
	else
		return true;
}
</script>
