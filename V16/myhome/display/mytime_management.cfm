<cfif not isdefined("sayac")><cfset sayac=0></cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.stage_id" default="">
<cfparam name="attributes.activity" default="">
<cfset temp_startdate = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
<cfparam name="attributes.startdate" default="#dateformat(temp_startdate,dateformat_style)#">
<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
	<cfset temp_finishdate = date_add('d',7,attributes.startdate)>
	<cfset tmp_finishdate = '#day(temp_finishdate)#/#month(temp_finishdate)#/#year(temp_finishdate)#'>
<cfelse>
	<cfset tmp_finishdate = ''>
</cfif>
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">

</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_time_cost_detail.cfm">
<cfelse>
	<cfset get_time_cost.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_time_cost.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="get_time_cost_cats" datasource="#dsn#">
	SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_activity" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box add_href="#request.self#?fuseaction=myhome.mytime_management&event=add">
		<cfform name="search" action="#request.self#?fuseaction=myhome.mytime_management" method="post">
			<cf_box_search>
				<div class="form-group" id="form_ul_keyword">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="time_cost_cat">
					<select name="cat_id" id="cat_id">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_time_cost_cats">
							<option value="#time_cost_cat_id#" <cfif attributes.cat_id eq time_cost_cat_id>selected</cfif>>#time_cost_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="process_stage">
					<select name="stage_id" id="stage_id">
						<option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
						<cfoutput query="get_process_stage">
							<option value="#process_row_id#" <cfif attributes.stage_id eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group medium" id="start_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama girmelisiniz'></cfsavecontent>
						<cfinput value="#dateformat(attributes.startdate,dateformat_style)#"  type="text" name="startdate" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group medium" id="finish_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
						<cfinput value="#dateformat(attributes.finishdate,dateformat_style)#" type="text" name="finishdate" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button search_function="kontrol()" button_type="4">
				</div>   	          
			</cf_box_search>
			<cf_box_search_detail search_function="kontrol()">
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-activity">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='31087.Aktivite'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<select name="activity" id="activity">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_activity">
										<option value="#activity_id#"<cfif attributes.activity eq activity_id>selected</cfif>>#activity_name#</option>
									</cfoutput> 
								</select>                 	
							</div>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.member_name') and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" style="width:140px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,partner_id','','3','250');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_consumer=search.consumer_id&field_comp_id=search.company_id&field_member_name=search.member_name&field_partner=search.partner_id&select_list=7,8</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','search','3','250');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=search.project_head&project_id=search.project_id</cfoutput>');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Zaman Harcamaları','57561')#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th width="50"><cf_get_lang dictionary_id='29513.Süre'></th>
					<th width="50"><cf_get_lang dictionary_id='57658.Üye'></th>
					<th width="65"><cf_get_lang dictionary_id='58445.İş'></th>
					<th width="70"><cf_get_lang dictionary_id='32374.Aktiviteler'></th>
					<th><cf_get_lang dictionary_id='29510.Olay'></th>
					<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57656.Servis'></th>
					<th><cf_get_lang dictionary_id='31990.Mesai Türü'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th><cf_get_lang dictionary_id='31750.Arge Gününe Dahil'></th>
					<th width="15" class="text-center"><span href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.mytime_management&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_time_cost.recordcount and isdefined("attributes.is_form_submitted")>
					<cfoutput query="get_time_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfif fusebox.circuit eq 'myhome'>
								<cfset time_cost_id_ = contentEncryptingandDecodingAES(isEncode:1,content:time_cost_id,accountKey:'wrk')>
							<cfelse>
								<cfset time_cost_id_ = time_cost_id>
							</cfif>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=myhome.mytime_management&event=upd&time_cost_id=#time_cost_id_#" class="tableyazi">#comment#</a></td> 
							<td><cfset tarih=dateformat(event_date,dateformat_style)>#Tarih#</td>
							<td>
								<cfif not len(bug_id) and len(finish) and len(start) and len(finish_min) and len(start_min)>
									<cfset totalhour=finish-start>
									<cfset totalminute=finish_min-start_min>
									<cfif totalminute lt 0>
										<cfset totalminute=abs(totalminute)>
										<cfset totalminute=60-totalminute>
										<cfset totalhour=totalhour-1>
									</cfif>
									<cfif totalminute lt 10>
										<cfset totalminute="0#totalminute#">
									</cfif>
									<cfset mytime="#totalhour#:#totalminute# Saat">
									<cfif totalhour eq 0>
										<cfset mytime="#totalminute# Dakika">
									</cfif>
									#mytime#
								<cfelse>
									<cfset totalminute = expensed_minute mod 60>
									<cfset totalhour = (expensed_minute-totalminute)/60>
									#totalhour#:#totalminute#<cf_get_lang dictionary_id='57491.Saat'>
								</cfif> 
							</td>
							<td>
								<cfif len(company_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#member_name#</a>
								<cfelseif len(consumer_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#member_name#</a>
								</cfif>
							</td>
							<td>#work_head#</td>
							<td>#activity_name#</td>
							<td>#event_head#</td>
							<td>#expense#</td>
							<td>#project_head#</td>
							<td>#service_head#</td> 
							<td>
								<cfif get_time_cost.OVERTIME_TYPE eq 1>
									<cf_get_lang dictionary_id='32287.Normal'>
								<cfelseif get_time_cost.OVERTIME_TYPE eq 2>
									<cf_get_lang dictionary_id='31547.Fazla Mesai'>
								<cfelseif get_time_cost.OVERTIME_TYPE eq 3>
									<cf_get_lang dictionary_id='31472.Hafta Sonu'>
								<cfelseif get_time_cost.OVERTIME_TYPE eq 4>
									<cf_get_lang dictionary_id='31473.Resmi Tatil'>
								</cfif>
							</td>
							<td>
								<cfif len(get_time_cost.class_id)>
                                    <cfquery name="get_class" datasource="#dsn#">
                                        SELECT CLASS_ID, CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_time_cost.class_id#">
                                    </cfquery>
                                </cfif>
								<cfif len(get_time_cost.class_id)>#get_class.class_name#</cfif>
							</td>
							<td>
								<cfif get_time_cost.is_rd_ssk eq 0>
									<cf_get_lang dictionary_id = "57496.Hayır">
								<cfelseif get_time_cost.is_rd_ssk eq 1>
									<cf_get_lang dictionary_id = "57495.Evet">
								</cfif>
							</td>
							<td class="text-center"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.mytime_management&event=upd&time_cost_id=#time_cost_id_#')"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>	 
		<cfif get_time_cost.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</p>
			</div>
		</cfif>
	</cf_box>
</div>
<cfset adres = ''>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfscript>
		if (isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted))
			adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#';
		if (isdefined("attributes.keyword") and len(attributes.keyword))
			adres = '#adres#&keyword=#attributes.keyword#';
		if (isdefined("attributes.cat_id") and len(attributes.cat_id))
			adres = '#adres#&cat_id=#attributes.cat_id#';
		if (isdefined("attributes.stage_id") and len(attributes.stage_id))
			adres = '#adres#&stage_id=#attributes.stage_id#';
		if (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name))
			adres = '#adres#&consumer_id=#attributes.consumer_id#';
		if (isdefined("attributes.partner_id") and len(attributes.partner_id) and isdefined("attributes.member_name") and len(attributes.member_name))
			adres = '#adres#&partner_id=#attributes.partner_id#';
		if (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_name") and len(attributes.member_name))
			adres = '#adres#&company_id=#attributes.company_id#';
		if (isdefined("attributes.member_name") and len(attributes.member_name))
			adres = '#adres#&member_name=#attributes.member_name#';
		if (isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head))
			adres = '#adres#&project_id=#attributes.project_id#';
		if (isdefined("attributes.project_head") and len(attributes.project_head))
			adres = '#adres#&project_head=#attributes.project_head#';
		if (len(attributes.activity))
			adres = '#adres#&activity=#attributes.activity#';
	</cfscript>
	<cf_paging
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="myhome.mytime_management#adres#">
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<script type="text/javascript">
	function kontrol()
	{
		return date_check(document.getElementById('startdate'),document.getElementById('finishdate'),"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	}
</script>