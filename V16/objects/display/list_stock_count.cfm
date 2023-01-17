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
	<cfinclude template="../query/get_stock_open_import.cfm">
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_stock_open_import.recordcount=0>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_stock_count" method="post" action="#request.self#?fuseaction=#url.fuseaction##branch_kontrol#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>		
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
						<input type="text" name="start_date" id="start_date" value="<cfoutput>#attributes.start_date#</cfoutput>" style="width:65px;" placeholder="<cfoutput>#getLang("","",58053)#</cfoutput>" validate="<cfoutput>#validate_style#</cfoutput>" maxlength="10" message="<cfoutput>#message#</cfoutput>">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<input type="text" name="finish_date" id="finish_date" value="<cfoutput>#attributes.finish_date#</cfoutput>" style="width:65px;" placeholder="<cfoutput>#getLang("","",57700)#</cfoutput>" validate="#validate_style#" maxlength="10" message="<cfoutput>#message#</cfoutput>">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="department_id" id="department_id" style="width:250;">
						<option value=""><cf_get_lang dictionary_id='58763.Depo'> <cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_all_location" group="department_id">
							<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
							<cfoutput>
								<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
							</cfoutput>
						</cfoutput>
					</select>	
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="position_code" id="position_code" maxlength="50" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
						<input type="text" name="position_name" id="position_name"  placeholder="<cfoutput>#getLang('main',487)#</cfoutput>" value="<cfif isdefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" style="width:100px;">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_stock_count.position_code&field_name=list_stock_count.position_name&select_list=1&branch_related','list','popup_list_positions')"></span> 
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57537.Kayıt Sayısı Hatası'></cfsavecontent>
					<input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="<cfoutput>#message#</cfoutput>" maxlength="3" onKeyUp="isNumber (this)"  style="width:25px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(list_stock_count.start_date,list_stock_count.finish_date,'#message_date#')">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33885.Sayımlar'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id ='58577.Sira'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id ='33886.Ürün Sayısı'></th>
					<th><cf_get_lang dictionary_id ='57691.Dosya'></th>
					<th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id ='57627.Kayit Tarihi'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_form_import_stock_count&department_id=#listfirst(session.ep.user_location,"-")#<cfif isDefined("is_branch")>&is_branch=1</cfif></cfoutput>','medium','popup_form_import_stock_count');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_stock_open_import.recordcount>
					<cfoutput query="get_stock_open_import" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#dateformat(startdate,dateformat_style)#</td>
							<td>#department_head# - #comment#</td>
							<td>#numberformat(product_count)#</td>
							<td><a href="javascript://"onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&file_name=store/#file_name#','small');" class="tableyazi">#file_name#</a></td>
							<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#dateformat(record_Date,dateformat_style)# (#timeformat(record_Date,timeformat_style)#)</td>
							<!-- sil -->
							<td width="20">	<a href="javascript://" onClick="delete_sayim(#i_id#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.Sil'>" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
							</td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
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
		<form name="delete_form" method="post" action="<cfoutput>#request.self#?fuseaction=objects.emptypopup_del_stock_count</cfoutput>">
			<input type="hidden" name="import_id" id="import_id" value="">
		</form>
	</cf_box>
</div>
<script language="JavaScript" type="text/javascript">
	function delete_sayim(import_id)
	{
		if(confirm("<cf_get_lang dictionary_id ='33888.Dosyayı Silmek İstediğinizden Emin Misiniz'>?"))
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
