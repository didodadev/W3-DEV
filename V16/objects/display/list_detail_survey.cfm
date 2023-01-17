<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.type_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfif attributes.is_filter>
	<cfquery name="get_detail_survey" datasource="#dsn#">
		SELECT 
			SURVEY_MAIN_ID,
			SURVEY_MAIN_HEAD,
			SURVEY_MAIN_DETAILS,
			RECORD_DATE,
			TYPE,
			PROCESS_ROW_ID,
            IS_ACTIVE
		FROM 
			SURVEY_MAIN 
		WHERE
			SURVEY_MAIN_ID IS NOT NULL
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif> 
			<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
				AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
			</cfif>
			<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
				AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#">
			</cfif>
		ORDER BY 
			RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_detail_survey.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_detail_survey.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_catalystHeader>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_detail_survey" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_detail_survey">
			<cf_box_search plus="0">
				<input type="hidden" name="is_filter" id="is_filter" value="5">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#place#"/>
				</div>
				<div class="form-group">
					<select name="type_id" id="type_id">
						<option value=""><cf_get_lang dictionary_id='59088.Tip'></option>
						<cfloop from="1" to="19" index="x">
							<cfoutput>
							<option value="#x#" <cfif isdefined("attributes.type_id") and attributes.type_id eq x>selected</cfif>>
								<cfif x eq 1><cf_get_lang dictionary_id='57612.Fırsat'>
								<cfelseif x eq 2><cf_get_lang dictionary_id='57653.İçerik'>
								<cfelseif x eq 3><cf_get_lang dictionary_id='57446.Kampanya'>
								<cfelseif x eq 4><cf_get_lang dictionary_id='57657.Ürün'>
								<cfelseif x eq 5><cf_get_lang dictionary_id='57416.Proje'>
								<cfelseif x eq 6><cf_get_lang dictionary_id='29776.Deneme Süresi'>
								<cfelseif x eq 7><cf_get_lang dictionary_id='57996.İşe Alım'>
								<cfelseif x eq 8><cf_get_lang dictionary_id='58003.Performans'>
								<cfelseif x eq 9><cf_get_lang dictionary_id='57419.Eğitim'>
								<cfelseif x eq 10><cf_get_lang dictionary_id='29832.İşten Çıkış'>
								<cfelseif x eq 11><cf_get_lang dictionary_id='58445.İş'>
								<cfelseif x eq 12><cf_get_lang dictionary_id='30007.Satış Teklifleri'>
								<cfelseif x eq 13><cf_get_lang dictionary_id='57611.Sipariş'>
								<cfelseif x eq 14><cf_get_lang dictionary_id='58662.Anket'>
								<cfelseif x eq 15><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
								<cfelseif x eq 16><cf_get_lang dictionary_id='29465.Etkinlik'>
								<cfelseif x eq 17><cf_get_lang dictionary_id='60095.Mal Kabul'>
								<cfelseif x eq 18><cf_get_lang dictionary_id='33103.Sevkiyat'>
								<cfelseif x eq 19><cf_get_lang dictionary_id='57438.Call Center'>
								</cfif>
							</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
				<div class="form-group">
					<a id="ui-plus" href="<cfoutput>#request.self#?fuseaction=settings.list_detail_survey&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Form Generator',42264)#">
		<cf_flat_list>
			<thead> 
				<tr> 
					<th style="width:20px;"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29768.Formlar'></th>
					<th><cf_get_lang dictionary_id='57771.Detay'></th>
					<th style="width:50px"><cf_get_lang dictionary_id='57630.Tip'></th>
					<th style="width:50px"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th style="width:65px"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<th width="15" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>&event=add"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id="57582.Ekle">" alt="<cf_get_lang dictionary_id='55185.Form Ekle'>"></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
            <cfif get_detail_survey.recordcount>
				<cfset stage_list =''>
				<cfoutput query="get_detail_survey" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(PROCESS_ROW_ID) and not listfind(stage_list,PROCESS_ROW_ID)>
						<cfset stage_list=listappend(stage_list,PROCESS_ROW_ID)>
					</cfif>
				</cfoutput>
				<cfif len(stage_list)>
					<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
					<cfquery name="PROCESS_TYPE" datasource="#DSN#">
						SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_list#">) ORDER BY PROCESS_ROW_ID
					</cfquery>
					<cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type.process_row_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_detail_survey" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td align="left"><input type="hidden" name="survey_main_id" id="survey_main_id" value="#survey_main_id#">#currentrow#</td>
						<td nowrap="nowrap">
							<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_detail_survey&event=upd&survey_id=#survey_main_id#" class="tableyazi" style="width:200px;">#survey_main_head#</a>
						</td>
						<td>
                            <cfif len(survey_main_details)>
                                #left(survey_main_details,75)#...
                            </cfif>
                        </td>
						<td>
							<cfif type eq 1>
								<cf_get_lang dictionary_id='57612.Fırsat'>
							<cfelseif type eq 2>
								<cf_get_lang dictionary_id='57653.İçerik'>
							<cfelseif type eq 3>
								<cf_get_lang dictionary_id='57446.Kampanya'>
							<cfelseif type eq 4>
								<cf_get_lang dictionary_id='57657.Ürün'>
							<cfelseif type eq 5>
								<cf_get_lang dictionary_id='57416.Proje'>
							<cfelseif type eq 6>
								<cf_get_lang dictionary_id='29776.Deneme Süresi'>
							<cfelseif type eq 7>
								<cf_get_lang dictionary_id='57996.İşe Alım'>
							<cfelseif type eq 8>
								<cf_get_lang dictionary_id='58003.Performans'>
							<cfelseif type eq 9>
								<cf_get_lang dictionary_id='57419.Eğitim'>
							<cfelseif type eq 10>
								<cf_get_lang dictionary_id='29832.İşten Çıkış'>
							<cfelseif type eq 11>
								<cf_get_lang dictionary_id='58445.İş'>
							<cfelseif type eq 12>
								<cf_get_lang dictionary_id='57545.Teklif'>
							<cfelseif type eq 13>
								<cf_get_lang dictionary_id='57611.Sipariş'>
							<cfelseif type eq 14>
								<cf_get_lang dictionary_id='58662.Anket'>
							<cfelseif type eq 15>
								<cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
							<cfelseif type eq 16>
								<cf_get_lang dictionary_id='44020.Etkinlik'>
							<cfelseif type eq 17>
								<cf_get_lang dictionary_id='60095.Mal Kabul'>
							<cfelseif type eq 18>
								<cf_get_lang dictionary_id='33103.Sevkiyat'>
							<cfelseif type eq 19>
								<cf_get_lang dictionary_id='57438.Call Center'>
							</cfif>
						</td>
						<td>#process_type.STAGE[listfind(stage_list,process_row_id,',')]#</td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<!-- sil -->
						<td width="20"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_detail_survey&event=upd&survey_id=#survey_main_id#" title="<cf_get_lang dictionary_id='57464.Güncelle'>"><i class="fa fa-pencil"></a></td>
						<!-- sil -->
					</tr>
				</cfoutput> 
            <cfelse>
                <tr>
                    <td colspan="7"><cfif attributes.is_filter><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                </tr>
			</cfif>
			</tbody>
		</cf_flat_list>

		<cfif get_detail_survey.recordcount gt 0>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.type_id)>
			<cfset url_str = "#url_str#&type_id=#attributes.type_id#">
		</cfif>
		<cfset url_str = "#url_str#&is_filter=#attributes.is_filter#">           
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="settings.list_detail_survey#url_str#"> 
		</cfif>
	</cf_box>
</div>


<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>