<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.type" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="get_empapp" datasource="#dsn#">
	SELECT NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.empapp_id#" list="yes">)
</cfquery>
<cfquery name="get_select_list" datasource="#dsn#">
	SELECT
		DISTINCT SL.LIST_ID,
		SL.LIST_NAME,
		SL.RECORD_DATE,
		SL.RECORD_EMP,
		SL.LIST_STATUS,
		LR.ROW_STATUS,
		LR.EMPAPP_ID,
		LR.LIST_ROW_ID,
		LR.APP_POS_ID,
		LR.STAGE,
		SL.POSITION_CAT_ID
	FROM
		EMPLOYEES_APP_SEL_LIST SL,
		EMPLOYEES_APP_SEL_LIST_ROWS LR
	WHERE
		SL.LIST_ID=LR.LIST_ID
		AND LR.EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.empapp_id#" list="yes">)
	<cfif isdefined("attributes.app_pos_id") and len(attributes.app_pos_id)>
		AND LR.APP_POS_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.app_pos_id#" list="yes">)
	</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>
		AND LR.ROW_STATUS=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND SL.LIST_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	</cfif>
	ORDER BY 
		SL.RECORD_EMP
</cfquery>
<cfsavecontent variable="table">
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id="55140.Liste Adı"></th>
				<th><cf_get_lang dictionary_id="57742.Tarih"></th>
				<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
				<th><cf_get_lang dictionary_id="57899.Kaydeden"></th>
				<th><cf_get_lang dictionary_id="55533.Liste Durum"></th>
				<th><cf_get_lang dictionary_id="56511.CV Durum"></th>
				<th><cf_get_lang dictionary_id="57482.Aşama"></th>
				<th width="15"><a href="javascript://"><i class="fa fa-folder-open" title="<cf_get_lang no='966.Tüm Değerlendirme ve Yazışmalar'>" border="0"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_select_list.recordcount>
				<cfoutput query="get_select_list" group="LIST_ID">
					<cfif len(POSITION_CAT_ID)>
						<cfset attributes.position_cat_id = get_select_list.POSITION_CAT_ID>
						<cfinclude template="../query/get_position_cat.cfm">
						<cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
					<cfelse>
						<cfset attributes.position_cat_id = "">
						<cfset position_cat = "">
					</cfif>
					<tr>
						<td>#get_select_list.list_name#</td>
						<td>#dateformat(get_select_list.record_date,dateformat_style)#</td>
						<td>#position_cat#</td>
						<td>#get_emp_info(get_select_list.record_emp,0,1)#</td>
						<td><cfif get_select_list.list_status eq 1>Aktif<cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td>
						<td><cfif get_select_list.row_status eq 1>Aktif<cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td>
						<td>
							<cfif len(get_select_list.stage)>
								<cfquery name="get_stage" datasource="#dsn#">
								SELECT 
									PROCESS_TYPE_ROWS.STAGE
								FROM
									PROCESS_TYPE_ROWS
								WHERE
									PROCESS_ROW_ID=#get_select_list.stage#
								</cfquery>
								#get_stage.stage#
							</cfif>
						</td>
						<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_list_app_mail_quiz&list_id=#list_id#&empapp_id=#empapp_id#&list_row_id=#list_row_id#<cfif len(app_pos_id)>&app_pos_id=#app_pos_id#</cfif>');"><i class="fa fa-folder-open" title="<cf_get_lang no='966.Tüm Değerlendirme ve Yazışmalar'>" border="0"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="7"><cf_get_lang dictionary_id="57484.Kayıt Yok"></td></tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cfsavecontent>
<div id="search_div_">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
	
			<cfsavecontent variable="txt"><cf_get_lang dictionary_id="56037.Seçim Listesi"> : <cfoutput>#get_empapp.name# #get_empapp.surname#</cfoutput></cfsavecontent>
			<cfif isdefined("attributes.type") and attributes.type eq 1>
				<cfform name="search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_select_list_empapp">
					<cf_box_search>
						<input type="hidden" name="old" id="old" value="1"> 
						<cfinput type="hidden" name="type" value="#attributes.type#">
						<div class="form-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id="40906.Geçerlilik"></cfsavecontent>
							<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" message="#message1#" maxlength="50" placeholder="#message#">
						</div>
						<div class="form-group">
							<select name="status" id="status">
								<option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
								<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
								<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
							</select>
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4" search_function="control_ajax()">	
						</div>
					</cf_box_search>
				</cfform>
			</cfif>
			<cfif isdefined("attributes.type") and attributes.type eq 2>
				<cf_box title="#getLang('','İlişkili Seçim Listeleri',63749)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
					<cfoutput>#table#</cfoutput>
				</cf_box>
			<cfelse>
				<cfoutput>#table#</cfoutput>
			</cfif>
	</div>
</div>
<script type="text/javascript">
function control_ajax()
	{
		<cfif attributes.type eq 1>
			var form_url = 'keyword=' + $('#keyword').val() + '&status=' + $('#status').val() + '&maxrows=' + $('#maxrows').val() ;
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_select_list_empapp&'+form_url+'<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#&modal_id=#attributes.modal_id#</cfif>&empapp_id=#Replace(attributes.empapp_id,',','')#<cfif isdefined("attributes.type") and attributes.type eq 1>&type=#attributes.type#</cfif></cfoutput>','search_div_');	
		</cfif>
	}
</script>


	
