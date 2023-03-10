<cf_get_lang_set module_name="objects">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.department_id" default="0">
<cfparam name="attributes.start_date" default="" >
<cfparam name="attributes.finish_date" default="" >
<cfparam name="attributes.page" default=1>
<cfif isdefined("is_branch")>
	<cfset branch_kontrol = "&is_branch=1">
<cfelse>
	<cfset branch_kontrol = "">
</cfif>
<cfif isdefined("is_submitted")>
	<cfset arama_yapilmali = 0>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
		<cfset attributes.finish_date=date_add("h",23,attributes.finish_date)>
		<cfset attributes.finish_date=date_add("n",59,attributes.finish_date)>
		<cfset attributes.finish_date=date_add("s",59,attributes.finish_date)>
	</cfif>
	<cfquery name="get_stock_open_import" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
            FILE_TYPE,
			(SELECT PC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PC WHERE PC.PRODUCT_CATID=FILE_IMPORTS.PRODUCT_CATID) PRODUCT_CAT,
			I_ID,
			FILE_NAME,
			FILE_SIZE,
			STARTDATE,
			FINISHDATE,
			SOURCE_SYSTEM,
			PRODUCT_COUNT,
			FILE_IMPORTS.RECORD_DATE,
			FILE_IMPORTS.RECORD_EMP,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			STOCKS_LOCATION.COMMENT
		FROM
			FILE_IMPORTS,
			#DSN_ALIAS#.EMPLOYEES EMPLOYEES,
			#DSN_ALIAS#.DEPARTMENT DEPARTMENT,
			#DSN_ALIAS#.STOCKS_LOCATION STOCKS_LOCATION
		WHERE
			DEPARTMENT.DEPARTMENT_ID = FILE_IMPORTS.DEPARTMENT_ID AND
			FILE_IMPORTS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND
			DEPARTMENT.DEPARTMENT_ID = STOCKS_LOCATION.DEPARTMENT_ID AND
			FILE_IMPORTS.DEPARTMENT_LOCATION = STOCKS_LOCATION.LOCATION_ID AND
			FILE_IMPORTS.PROCESS_TYPE = -5 <!--- Stok Sayım İmport --->
			<cfif isDefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)>
				AND FILE_IMPORTS.RECORD_EMP = #attributes.position_code#
			</cfif>
			<cfif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 1>
				AND FILE_IMPORTS.DEPARTMENT_ID = #attributes.department_id#
			<cfelseif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 2>
				AND FILE_IMPORTS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
				AND FILE_IMPORTS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
			<cfelse>
				<cfif session.ep.our_company_info.is_location_follow eq 1>
					AND
					(
						CAST(FILE_IMPORTS.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(FILE_IMPORTS.DEPARTMENT_LOCATION AS NVARCHAR) IN (SELECT LOCATION_CODE FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
						OR
						FILE_IMPORTS.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
					)
				</cfif>
			</cfif>
			<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND FILE_IMPORTS.RECORD_DATE BETWEEN  #attributes.start_date# AND  #attributes.finish_date#
			</cfif>
		ORDER BY
			FILE_IMPORTS.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_stock_open_import.recordcount=0>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <> 2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif session.ep.our_company_info.is_location_follow eq 1>
			AND
			(
				CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				OR
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
			)
		</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_open_import.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_stock_count" method="post" action="#request.self#?fuseaction=#url.fuseaction##branch_kontrol#">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
<cf_big_list_search title="#lang_array.item[1495]#"> 
	<cf_big_list_search_area>		
		<table>
			<tr>		  
				<td><cf_get_lang_main no ='215.Kayıt Tarihi'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
					<input type="text" name="start_date" id="start_date" value="<cfoutput>#attributes.start_date#</cfoutput>" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="start_date">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
					<input type="text" name="finish_date" id="finish_date" value="<cfoutput>#attributes.finish_date#</cfoutput>" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
					<cf_wrk_date_image date_field="finish_date">
				</td>
				<td><cf_get_lang_main no='1351.Depo'></td>
				<td>
					<select name="department_id" id="department_id" style="width:250;">
						<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
						<cfoutput query="get_all_location" group="department_id">
							<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
							<cfoutput>
								<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang_main no='82.Pasif'></cfif></option>
							</cfoutput>
						</cfoutput>
					</select>	
				</td>
				<td><cf_get_lang_main no ='487.Kaydeden'></td>
				<td>
					<input type="hidden" name="position_code" id="position_code" maxlength="50" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
					<input type="text" name="position_name" id="position_name" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" style="width:100px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_stock_count.position_code&field_name=list_stock_count.position_name&select_list=1&branch_related','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no ='487.Kaydeden'>"></a> 
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='1983.Sayı Hatası'></cfsavecontent>
					<input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="Kayıt Sayısı Hatalı" maxlength="3" onKeyUp="isNumber (this)"  style="width:25px;">
				</td>
				<td><cfsavecontent variable="message_date"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button search_function="date_check(list_stock_count.start_date,list_stock_count.finish_date,'#message_date#')">
				</td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no ='1165. Sira'></th>
			<th width="65"><cf_get_lang_main no ='330.Tarih'></th>
			<th width="100"><cf_get_lang_main no='1351.Depo'></th>
			<th width="100">Kategori</th>
			<th width="85">Sayım Tipi</th>
			<th width="85"><cf_get_lang no ='1496.Ürün Sayısı'></th>
			<th><cf_get_lang_main no ='279.Dosya'></th>
			<th width="150"><cf_get_lang_main no ='71.Kayıt'></th>
			<th width="100"><cf_get_lang_main no ='215.Kayit Tarihi'></th>
			<!-- sil --><th width="15" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_form_import_stock_count&department_id=#listfirst(session.ep.user_location,"-")#<cfif isDefined("is_branch")>&is_branch=1</cfif></cfoutput>','medium','popup_form_import_stock_count');"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no ='170.Ekle'>" title="<cf_get_lang_main no ='170.Ekle'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_stock_open_import.recordcount>
			<cfoutput query="get_stock_open_import" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="35">#currentrow#</td>
					<td>#dateformat(startdate,"dd/mm/yyyy")#</td>
					<td>#department_head# - #comment#</td>
					<td>#product_cat#</td>
					<td><cfif file_type eq 3>Fark Sayımı<cfelseif file_type eq 2>2.Sayım<cfelse>1.Sayım</cfif></td>
					<td>#numberformat(product_count)#</td>
					<td><a href="javascript://"onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&file_name=store/#file_name#','small');" class="tableyazi">#file_name#</a></td>
					<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#dateformat(record_Date,"dd/mm/yyyy")# (#timeformat(record_Date,"HH:MM")#)</td>
					<!-- sil -->
					<td width="15">	<a href="javascript://" onClick="delete_sayim(#i_id#);"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no ='51.Sil'>" title="<cf_get_lang_main no ='51.Sil'>"></a>
					</td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="11"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_string = "">
<cfif isDefined("is_branch") and len(is_branch)>
	<cfset url_string = "#url_string#&is_branch=1">
</cfif>
<cfif isDefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isDefined("attributes.position_code") and len(attributes.position_code)>
	<cfset url_string = "#url_string#&position_code=#attributes.position_code#">
</cfif>
<cfif isDefined("attributes.position_name") and len(attributes.position_name)>
	<cfset url_string = "#url_string#&position_name=#attributes.position_name#">
</cfif>
<cfif isDefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_string = "#url_string#&start_date=#attributes.start_date#">
</cfif>
<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_string = "#url_string#&finish_date=#attributes.finish_date#">
</cfif>
<cfset url_string = "#url_string#&department_id=#attributes.department_id#">
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url.fuseaction##url_string#">
<form name="delete_form" method="post" action="<cfoutput>#request.self#?fuseaction=retail.emptypopup_del_stock_count</cfoutput>">
	<input type="hidden" name="import_id" id="import_id" value="">
</form>
<script language="JavaScript" type="text/javascript">
	function delete_sayim(import_id)
	{
		if(confirm("<cf_get_lang no ='1498.Dosyayı Silmek İstediğinizden Emin Misiniz'>?"))
		{
			windowopen('','small','del_sayim');
			document.delete_form.target = 'del_sayim';
			document.delete_form.import_id.value = import_id;
			document.delete_form.submit();
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<script type="text/javascript">
	document.getElementById('position_name').focus();
</script>