<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.search_type" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cf_xml_page_edit fuseact="quality.control_standarts">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="quality_control_type" datasource="#dsn3#">
		SELECT
			0 SORT_TYPE,
			'' AS RESULT_ID,
			TYPE_ID,
			#dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','QUALITY_CONTROL_TYPE','QUALITY_CONTROL_TYPE',NULL,NULL,QUALITY_CONTROL_TYPE) AS QUALITY_CONTROL_TYPE,
			TYPE_DESCRIPTION,
			STANDART_VALUE,
			QUALITY_MEASURE,
			TOLERANCE,
			IS_ACTIVE
		FROM
			QUALITY_CONTROL_TYPE
		WHERE
			<cfif ListFind("1,0",attributes.is_active)>
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
			</cfif>
			<cfif len(attributes.keyword)>
				(
					QUALITY_CONTROL_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					TYPE_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif Len(attributes.process_cat_id)>
				PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
			</cfif>
			1= 1
	<cfif attributes.search_type eq 2>
	UNION ALL
		SELECT
			1 SORT_TYPE,
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW_ID RESULT_ID,
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID TYPE_ID,
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW QUALITY_CONTROL_TYPE,
			QUALITY_CONTROL_ROW.QUALITY_ROW_DESCRIPTION TYPE_DESCRIPTION,
			QUALITY_CONTROL_TYPE.STANDART_VALUE,
			QUALITY_CONTROL_TYPE.QUALITY_MEASURE,
			QUALITY_CONTROL_TYPE.TOLERANCE,
			QUALITY_CONTROL_TYPE.IS_ACTIVE
		FROM
			QUALITY_CONTROL_ROW,
			QUALITY_CONTROL_TYPE
		WHERE
			<cfif ListFind("1,0",attributes.is_active)>
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
			</cfif>
			<cfif len(attributes.keyword)>
				(	QUALITY_CONTROL_TYPE.QUALITY_CONTROL_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					QUALITY_CONTROL_TYPE.TYPE_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif Len(attributes.process_cat_id)>
				QUALITY_CONTROL_TYPE.PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
			</cfif>
			QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID = QUALITY_CONTROL_TYPE.TYPE_ID	
	</cfif>
		ORDER BY
			TYPE_ID,
			SORT_TYPE
	</cfquery>
<cfelse>
	<cfset quality_control_type.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#quality_control_type.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="quality_control" action="#request.self#?fuseaction=quality.control_standarts" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class ="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" maxlength="50" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class ="form-group">
					<select name="process_cat_id" id="process_cat_id" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<option value="76" <cfif attributes.process_cat_id eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
						<option value="171" <cfif attributes.process_cat_id eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
						<option value="811" <cfif attributes.process_cat_id eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
						<option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>><cf_get_lang dictionary_id='54365.Operasyonlar'></option>
						<option value="-2" <cfif attributes.process_cat_id eq -2>selected</cfif>><cf_get_lang dictionary_id='57656.Servis'></option>
					</select>
				</div>
				<div class ="form-group">
					<select name="search_type" id="search_type" style="width:120px;">
						<option value="1" <cfif attributes.search_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
						<option value="2" <cfif attributes.search_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57684.Sonuç'></option>
					</select>
				</div>
				<div class ="form-group">
					<select name="is_active" id="is_active" style="width:60px;">
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this);" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Kalite Kontrol Tanımları',63286)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<cfif attributes.search_type eq 1><th width="20">&nbsp;</th></cfif>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='43698.Kontrol'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="20" class="text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=quality.control_standarts&event=add','','ui-draggable-box-large')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th width="20" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
						<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif quality_control_type.recordcount>
					<cfoutput query="quality_control_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<cfif attributes.search_type eq 1>
							<td id="quality_rows#currentrow#" class="iconL" onClick="gizle_goster(quality_result_rows#currentrow#);connectAjax('#currentrow#','#type_id#');gizle_goster(quality_result_show#currentrow#);gizle_goster(quality_result_hide#currentrow#);">
								<!-- sil -->
								<i class="fa fa-caret-right" id="quality_result_show#currentrow#" title="<cf_get_lang dictionary_id ='58596.Göster'>" alt="<cf_get_lang dictionary_id ='58596.Göster'>"></i>
								<i class="fa fa-caret-right" id="quality_result_hide#currentrow#" title="<cf_get_lang dictionary_id='58628.Gizle'>" alt="<cf_get_lang dictionary_id='58628.Gizle'>" style="display:none"></i>
								<!-- sil -->
							</td>
							</cfif>
							<td>#currentrow#</td>
							<td><cfif SORT_TYPE eq 1>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=updResult&result_id=#result_id#')" class="tableyazi">&nbsp;&nbsp;&nbsp;#QUALITY_CONTROL_TYPE#</a>
								<cfelse>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=upd&type_id=#type_id#','','ui-draggable-box-large')"><b>#QUALITY_CONTROL_TYPE#</b></a>
								</cfif>
							</td>
							<td><cfif SORT_TYPE eq 1>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=updResult&result_id=#result_id#')" class="tableyazi">#TYPE_DESCRIPTION#</a>
								<cfelse>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=upd&type_id=#type_id#','','ui-draggable-box-large')">#TYPE_DESCRIPTION#</a>
								</cfif>
							</td>
							
							<td><cfif is_active eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><cf_get_lang dictionary_id ='57494.Pasif'></cfif></td>
							<!-- sil -->
							<td width="20" ><cfif SORT_TYPE eq 0><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=addResult&type_id=#TYPE_ID#')"><i class="icon-add-on" title="<cf_get_lang dictionary_id='59085.Sonuç'><cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif></td>	
							<td width="20" ><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=quality.control_standarts&event=upd&type_id=#type_id#','','ui-draggable-box-large')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<!-- sil -->
						</tr>
						<!-- sil -->
						<tr id="quality_result_rows#currentrow#" style="display:none;" class="nohover">
							<td>&nbsp;</td>
							<td colspan="9">
								<div align="left" id="display_quality_type_results#currentrow#"></div>
							</td>
						</tr>
						<!-- sil -->
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="9"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "&form_submitted=1&is_active=#attributes.is_active#">
			<cfif Len(attributes.search_type)><cfset url_str = "#url_str#&search_type=#attributes.search_type#"></cfif>
			<cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
			<cfif Len(attributes.process_cat_id)><cfset url_str = "#url_str#&process_cat_id=#attributes.process_cat_id#"></cfif>
			<table cellpadding="0" cellspacing="0" border="0" height="25" width="99%" align="center">
				<tr>
					<td>
					<cf_paging page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="quality.control_standarts#url_str#"> 
					</td>
					<!-- sil -->
					<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	<cfif attributes.search_type eq 1>
		function connectAjax(crtrow,type_id)
		{
			var load_url_ = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopupajax_list_quality_control_results&type_id="+type_id+"&keyword="+document.getElementById("keyword").value;
			AjaxPageLoad(load_url_,'display_quality_type_results'+crtrow,1);
		}
	</cfif>
</script>
