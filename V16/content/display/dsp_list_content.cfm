<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
<cf_xml_page_edit>
<cf_get_lang_set module_name="content">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.content_property_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.user_friendly_url" default="">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.language_id" default="#session.ep.language#">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.record_member" default="">
<cfparam name="attributes.record_member_id" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.priority" default="">
<cfparam name="attributes.record_date" default="">
<cfif isdate(attributes.record_date)><cf_date tarih="attributes.record_date"></cfif>
<cfif fusebox.circuit eq 'training_management'><!--- eğitim yönetiminde yalnızca kategorisi Egitim olanların gelmesi icin eklendi--->
	<cfset attributes.is_training = 1>
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<!---<cfinclude template="../query/get_content.cfm">--->
<!--- 		get_content_list_action.dsn = dsn;
 --->		
		<cfset GET_CONTENT = getComponent.get_content_list_fnc(
			record_member_id : '#iif(isdefined("record_member_id"),"record_member_id",DE(""))#' ,
			is_selected_lang : '#iif(isdefined("x_is_selected_language"),"x_is_selected_language",DE(""))#' ,
			record_member : '#iif(isdefined("attributes.record_member"),"attributes.record_member",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#', 
			language_id : '#iif(isdefined("attributes.language_id"),"attributes.language_id",DE(""))#',
			stage_id : '#iif(isdefined("attributes.stage_id"),"attributes.stage_id",DE(""))#',
			priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#',
			status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
			content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
			ana_sayfa : '#iif(isdefined("attributes.ana_sayfa"),"attributes.ana_sayfa",DE(""))#',
			ana_sayfayan : '#iif(isdefined("attributes.ana_sayfayan"),"attributes.ana_sayfayan",DE(""))#',
			bolum_basi : '#iif(isdefined("attributes.bolum_basi"),"attributes.bolum_basi",DE(""))#',
			bolum_yan : '#iif(isdefined("attributes.bolum_yan"),"attributes.bolum_yan",DE(""))#' ,
			ch_bas : '#iif(isdefined("attributes.ch_bas"),"attributes.ch_bas",DE(""))#',
			ch_yan : '#iif(isdefined("attributes.ch_yan"),"attributes.ch_yan",DE(""))#',
			none_tree : '#iif(isdefined("attributes.none_tree"),"attributes.none_tree",DE(""))#' ,
			is_viewed : '#iif(isdefined("attributes.is_viewed"),"attributes.is_viewed",DE(""))#',
			order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#' ,
			is_training: '#iif(isdefined("attributes.is_training"),"attributes.is_training",DE(""))#',
			is_fulltext_search : '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#',
			mail_c : '#iif(isdefined("mail_c"),"mail_c",DE(""))#',
			meta_title:'#iif(isdefined("attributes.meta_title"),"attributes.meta_title",DE(""))#',
			meta_head:'#iif(isdefined("attributes.meta_head"),"attributes.meta_head",DE(""))#',
			meta_keyword:'#iif(isdefined("attributes.meta_keyword"),"attributes.meta_keyword",DE(""))#'

		)>
<cfelse>
	<cfset get_content.recordcount = 0>
</cfif>
	<cfset GET_LANGUAGE = getComponent.GET_LANGUAGE()>
<!--- <cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery> --->
<cfset GET_CONTENT_PROCESS_STAGES=getComponent.GET_CONTENT_PROCESS_STAGES(faction: iif(isdefined("attributes.is_training"),DE("training_management.list_content"),DE("content.")))>
<!--- <cfquery name="GET_CONTENT_PROCESS_STAGES" datasource="#DSN#">
	SELECT 
		PTR.PROCESS_ROW_ID AS STAGE_ID,
		PTR.STAGE STAGE_NAME 
	FROM 
		PROCESS_TYPE PT, 
		PROCESS_TYPE_ROWS PTR 
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.FACTION LIKE 'content.%' AND
		PT.PROCESS_ID = PTR.PROCESS_ID
</cfquery> --->

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_content.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("url.chpid") or isdefined("id")>
	<cfinclude template="#fusebox.rootpath#query/get_chapter_name.cfm">
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="58045.Icerik"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfinclude template="dsp_list_content_search.cfm">
	</cf_box>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57480.Konu Başlığı'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='677.Revizyon No'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='58996.Dil'></th>
					<cfif isdefined('x_is_hit') and (x_is_hit eq 1)>
					<th><cf_get_lang dictionary_id='30964.Public'> <cf_get_lang dictionary_id='50539.Hit'></th>
					<th><cf_get_lang dictionary_id='58885.Partner'> <cf_get_lang dictionary_id='50539.Hit'></th>
					<th><cf_get_lang dictionary_id='42717.Employee'> <cf_get_lang dictionary_id='50539.Hit'></th>
					<th><cf_get_lang dictionary_id='59163.Ziyaretçi'> <cf_get_lang dictionary_id='50539.Hit'></th>
					</cfif>
					<cfif isDefined("x_is_show_meta_descriptions") and (x_is_show_meta_descriptions eq 1) and isDefined("GET_CONTENT.META_DESC_HEAD")><th><cf_get_lang dictionary_id='58993.Meta Tanımı'></th></cfif>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<!-- sil -->
					<th class="header_icn_none" width="20"><a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.list_content&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->	
				</tr>
			</thead>
			<tbody>
				<cfif get_content.recordCount>
					<cfset content_property_id_list=''>
					<cfset stage_id_list=''>
					<cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(content_property_id) and content_property_id neq -1 and not listfind(content_property_id_list,content_property_id)>
							<cfset content_property_id_list = Listappend(content_property_id_list,content_property_id)>
						</cfif>
						<cfif len(stage_id) and not listfind(stage_id_list,process_stage)>
							<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
						</cfif>
					</cfoutput>
					<cfif len(content_property_id_list)>
						<cfset content_property_id_list=listsort(content_property_id_list,"numeric","ASC",",")>

						<cfset GET_PROPERTY_NAME=getComponent.GET_PROPERTY_NAME(
							content_property_id_list:content_property_id_list)>
						<!--- <cfquery name="GET_PROPERTY_NAME" datasource="#DSN#">
							SELECT NAME,CONTENT_PROPERTY_ID FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#content_property_id_list#">) ORDER BY CONTENT_PROPERTY_ID
						</cfquery> --->
						<cfset content_property_id_list = listsort(listdeleteduplicates(valuelist(get_property_name.content_property_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(stage_id_list)>
						<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
						<cfset GET_CONTENT_PROCESS_STAGE=getComponent.GET_CONTENT_PROCESS_STAGE(
							stage_id_list:stage_id_list)>
						<!--- <cfquery name="GET_CONTENT_PROCESS_STAGE" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
						</cfquery> --->
						<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
						<cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#currentrow#</td>
								<td>
									<cfif fusebox.circuit neq 'training'>
										<a href="#request.self#?fuseaction=#fusebox.circuit#.list_content&event=det&cntid=#content_id#">#cont_head#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#">#cont_head#</a>
									</cfif>
								</td>
								<td>#contentcat#</td>
								<td>#chapter#</td>
								<td>
									<cfif len(get_content.content_property_id)>
										<cfif get_content.content_property_id eq -1>
											<cf_get_lang dictionary_id='50578.Spot'>
										<cfelse>					
											#get_property_name.name[listfind(content_property_id_list,get_content.content_property_id,',')]#
										</cfif>
									</cfif>
								</td>
								<td>#WRITE_VERSION#</td>
								<td><cfif isdefined("get_content_process_stage.stage") and len(get_content_process_stage.stage)>#get_content_process_stage.stage[listfind(stage_id_list,get_content.process_stage,',')]#</cfif></td>
								<td><cfif get_content.content_status is 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
								<td>#language_id#</td>
								<cfif isdefined('x_is_hit') and (x_is_hit eq 1)>
									<td style="text-align:right">#TLFormat(get_content.hit,0)#</td>
									<td style="text-align:right">#TLFormat(get_content.hit_partner,0)#</td>
									<td style="text-align:right">#TLFormat(get_content.hit_employee,0)#</td>
									<td style="text-align:right">#TLFormat(get_content.hit_guest,0)#</td>
								</cfif>
								<cfif isDefined("x_is_show_meta_descriptions") and (x_is_show_meta_descriptions eq 1) and isDefined("META_DESC_HEAD")>
									<td>#META_DESC_HEAD#</td>
								</cfif>
								<td><cfset d_date=dateadd('h',session.ep.time_zone,record_date)>#dateformat(d_date,dateformat_style)# #timeformat(d_date,timeformat_style)#</td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#encodeForURL(employee_id)#','medium');">#employee_name# #employee_surname#</a></td>
								<!-- sil --><td><a href="#request.self#?fuseaction=#fusebox.circuit#.list_content&event=det&cntid=#content_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>" alt="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td><!-- sil -->
								</tr>
							</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16">
							<cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif>
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.stage_id") and len(attributes.stage_id)>
			<cfset url_str = "#url_str#&stage_id=#attributes.stage_id#">
		</cfif>
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.user_friendly_url)>
			<cfset url_str = "#url_str#&user_friendly_url=#attributes.user_friendly_url#">
		</cfif>
		<cfif len(attributes.order_type)>
			<cfset url_str = "#url_str#&order_type=#attributes.order_type#">
		</cfif>
		<cfif len(attributes.cat)>
			<cfset url_str = "#url_str#&cat=#attributes.cat#">
		</cfif>
		<cfif len(attributes.content_property_id)>
			<cfset url_str = "#url_str#&content_property_id=#attributes.content_property_id#">
		</cfif>
		<cfif len(attributes.status)>
			<cfset url_str = "#url_str#&status=#attributes.status#">
		</cfif>
		<cfif len(attributes.record_member)>
			<cfset url_str = "#url_str#&record_member=#attributes.record_member#">
			<cfset url_str = "#url_str#&record_member_id=#attributes.record_member_id#">
		</cfif>
		<cfif len(attributes.priority)>
			<cfset url_str = "#url_str#&priority=#attributes.priority#">
		</cfif>
		<cfif len(attributes.record_date)>
			<cfset url_str = "#url_str#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
		</cfif>

		<cfif isdefined("attributes.ana_sayfa")>
			<cfset url_str = "#url_str#&ana_sayfa=#attributes.ana_sayfa#">
		</cfif>
		<cfif isdefined("attributes.ana_sayfayan")>
			<cfset url_str = "#url_str#&ana_sayfayan=#attributes.ana_sayfayan#">
		</cfif>
		<cfif isdefined("attributes.bolum_basi")>
			<cfset url_str = "#url_str#&bolum_basi=#attributes.bolum_basi#">
		</cfif>
		<cfif isdefined("attributes.bolum_yan")>
			<cfset url_str = "#url_str#&bolum_yan=#attributes.bolum_yan#">
		</cfif>
		<cfif isdefined("attributes.ch_bas")>
			<cfset url_str = "#url_str#&ch_bas=#attributes.ch_bas#">
		</cfif>
		<cfif isdefined("attributes.ch_yan")>
			<cfset url_str = "#url_str#&ch_yan=#attributes.ch_yan#">
		</cfif>
		<cfif isdefined("attributes.none_tree")>
			<cfset url_str = "#url_str#&none_tree=#attributes.none_tree#">
		</cfif>
		<cfif isdefined("attributes.is_viewed")>
			<cfset url_str = "#url_str#&is_viewed=#attributes.is_viewed#">
		</cfif>
		<cfif isdefined("attributes.language_id")>
			<cfset url_str = "#url_str#&language_id=#attributes.language_id#">
		</cfif>
		<cfif len(attributes.meta_title)>
			<cfset url_str = "#url_str#&meta_title=#attributes.meta_title#">
		</cfif>
		<cfif len(attributes.meta_head)>
			<cfset url_str = "#url_str#&meta_head=#attributes.meta_head#">
		</cfif>
		<cfif len(attributes.meta_keyword)>
			<cfset url_str = "#url_str#&meta_keyword=#attributes.meta_keyword#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#fusebox.circuit#.list_content&#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_content_cat()
	{
		var type = document.getElementById('language_id').value;
		var send_address = "<cfoutput>#request.self#?fuseaction=content.emptypopup_get_content_cat_ajax&cat=#attributes.cat#</cfoutput>&type=";
		send_address += type;
		AjaxPageLoad(send_address,'content_cat_place','1');
	}
	get_content_cat();
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
