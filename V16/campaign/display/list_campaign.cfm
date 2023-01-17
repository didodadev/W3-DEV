<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.camp_type" default=''>
<cfquery name="GET_CAMP_TYPES" datasource="#dsn3#">
	SELECT CAMP_TYPE_ID,CAMP_TYPE FROM CAMPAIGN_TYPES ORDER BY CAMP_TYPE
</cfquery>
<cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
	<cfelse>
		<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_dates=''>
	<cfelse>
		<cfset attributes.start_dates= date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
        <cfset attributes.finish_dates=''>
    <cfelse>
        <cfset attributes.finish_dates= date_add('d',7,wrk_get_today())>
       </cfif>
</cfif>
<cfinclude template="../query/get_campaign_cats.cfm">
<cfif attributes.is_filter>
	<cfinclude template="../query/get_campaigns.cfm">
<cfelse>
	<cfset campaigns.recordcount = 0>
</cfif>
<cfset url_str = "">
<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
<cfif isdefined("camp_type")><cfset url_str = "#url_str#&camp_type=#attributes.camp_type#"></cfif>
<cfif isdefined("is_active")><cfset url_str = "#url_str#&is_active=#attributes.is_active#"></cfif>
<cfif len(attributes.start_dates)><cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#"></cfif>
<cfif len(attributes.finish_dates)><cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#"></cfif>
<cfset url_str = "#url_str#&is_filter=#attributes.is_filter#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#campaigns.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" id="search" method="post" action="#request.self#?fuseaction=campaign.list_campaign">
			<input type="hidden" name="is_filter" id="is_filter" value="5">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
					</div>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
							<input type="hidden" name="par_id" id="par_id" value="#attributes.par_id#">
							<input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
							<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
							<input type="text" name="member_name" id="member_name" value="#attributes.member_name#" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','par_id,cons_id,emp_id,member_type','','3','225');" autocomplete="off" placeholder="<cf_get_lang dictionary_id='49336.Lider'>"/>
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search.emp_id&field_name=search.member_name&field_type=search.member_type&field_partner=search.par_id&field_consumer=search.cons_id&select_list=1,7,8','list');"></span>
						</div>
					</div>
					<div class="form-group">
						<select name="camp_type" id="camp_type">
							<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
							<cfloop query="get_camp_types">
								<option value="#camp_type_id#" <cfif attributes.camp_type eq camp_type_id>selected</cfif>>#camp_type#</option>
								<cfquery name="GET_CAMPAIGN_CATS" datasource="#DSN3#">
									SELECT CAMP_CAT_ID,CAMP_CAT_NAME FROM CAMPAIGN_CATS WHERE  CAMP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_types.camp_type_id#">  ORDER BY CAMP_CAT_NAME
								</cfquery>
								<cfloop query="get_campaign_cats">
									<option value="#get_camp_types.camp_type_id#_#camp_cat_id#" <cfif listlen(attributes.camp_type,'_') eq 2 and listgetat(attributes.camp_type,2,'_') eq camp_cat_id>selected</cfif>>&nbsp;&nbsp;#camp_cat_name#</option> 
								</cfloop>
							</cfloop>
						</select>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerlerini Kontrol ediniz'>!</cfsavecontent>
							<cfsavecontent variable="place"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
							<cfif session.ep.our_company_info.unconditional_list>
								<cfinput name="start_dates" id="start_dates" validate="#validate_style#" maxlength="10" placeholder="#place#" value="#dateformat(attributes.start_dates,dateformat_style)#" message="#message#">
							<cfelse>
								<cfinput name="start_dates" id="start_dates" validate="#validate_style#" maxlength="10" placeholder="#place#" value="#dateformat(attributes.start_dates,dateformat_style)#" message="#message#" required="yes">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span> 
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerlerini Kontrol ediniz'>!</cfsavecontent>
							<cfsavecontent variable="place2"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
							<cfif session.ep.our_company_info.unconditional_list>
								<cfinput name="finish_dates" id="finish_dates" validate="#validate_style#" maxlength="10" placeholder="#place2#" value="#dateformat(attributes.finish_dates,dateformat_style)#" message="#message#">
							<cfelse>
								<cfinput name="finish_dates" id="finish_dates" validate="#validate_style#" maxlength="10" placeholder="#place2#" value="#dateformat(attributes.finish_dates,dateformat_style)#" message="#message#" required="yes">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span> 
						</div>
					</div>
					<div class="form-group">
						<select name="is_active" id="is_active">
							<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
							<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
						</select>               
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='kontrol()'>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</cfoutput>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1,'Kampanyalar',49321)#" uidrop="1" hide_table_column="1" resize="1" collapsable="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='49335.Yürürlülük Tarihi'></th>
					<th><cf_get_lang dictionary_id='49336.Lider'></th>
					<th><cf_get_lang dictionary_id='57756.Süreç'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.list_campaign&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif campaigns.recordcount>
					<cfset get_stage_list=''>
					<cfset camp_cat_list =''>
					<cfset leader_list = '' >
					<cfoutput query="campaigns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(PROCESS_STAGE) and not listfind(get_stage_list,PROCESS_STAGE)>
							<cfset get_stage_list = Listappend(get_stage_list,PROCESS_STAGE)>
						</cfif>
						<cfif len(camp_cat_id) and not listfind(camp_cat_list,camp_cat_id)>
							<cfset camp_cat_list = ListAppend(camp_cat_list,camp_cat_id)>
						</cfif>
						<cfif len(leader_employee_id) and not listfind(leader_list,leader_employee_id)>
							<cfset leader_list = ListAppend(leader_list,leader_employee_id)>
						</cfif>
					</cfoutput>
					<cfif len(leader_list)>
						<cfset leader_list=listsort(leader_list,"numeric","ASC",",")>
						<cfquery name="get_leader_name" datasource="#dsn#">
							SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#leader_list#">) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset leader_list = listsort(listdeleteduplicates(valuelist(get_leader_name.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(get_stage_list)>
						<cfset get_stage_list=listsort(get_stage_list,"numeric","ASC",",")>
						<cfquery name="GET_STAGE" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#get_stage_list#">) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset get_stage_list = listsort(listdeleteduplicates(valuelist(GET_STAGE.PROCESS_ROW_ID,',')),'numeric','ASC',',')>				
					</cfif>
					<cfif len(camp_cat_list)>
						<cfset camp_cat_list=listsort(camp_cat_list,"numeric","ASC",",")>
						<cfquery name="get_camp_cat_name" datasource="#dsn3#">
							SELECT CAMP_CAT_ID,CAMP_CAT_NAME FROM CAMPAIGN_CATS WHERE CAMP_CAT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#camp_cat_list#">) ORDER BY CAMP_CAT_ID
						</cfquery>
						<cfset camp_cat_list = listsort(listdeleteduplicates(valuelist(get_camp_cat_name.CAMP_CAT_ID,',')),'numeric','ASC',',')>				
					</cfif>
					<cfoutput query="campaigns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td width="75">#camp_no#</td>
							<td><a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" class="tableyazi">#camp_head#</a></td>             
							<td>#get_camp_cat_name.camp_cat_name[listfind(camp_cat_list,campaigns.camp_cat_id,',')]#</td>
							<td>#dateformat(date_add('h',session.ep.time_zone,camp_startdate),dateformat_style)# - #dateformat(date_add('h',session.ep.time_zone,camp_finishdate),dateformat_style)#</td>
							<td><cfif len(leader_employee_id)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#leader_employee_id#','medium');" class="tableyazi">
									#get_leader_name.employee_name[listfind(leader_list,leader_employee_id,',')]# 
									#get_leader_name.employee_surname[listfind(leader_list,leader_employee_id,',')]#
								</a>
							</cfif>
							</td>
							<td><cfif len(process_stage)>#get_stage.stage[listfind(get_stage_list,campaigns.process_stage,',')]#</cfif></td>
							<!-- sil --><td style="text-align:center"><a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cfif attributes.is_filter><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="campaign.list_campaign#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{	
	if(document.getElementById("start_dates") != "" && document.getElementById("finish_dates") != "")
	{
		if(!date_check(document.getElementById("start_dates"),document.getElementById("finish_dates"),"<cf_get_lang dictionary_id='57806.Tarih Araligini Kontrol Ediniz'>!"))
		{
			return false;
		}
	}
	return true;
}
</script>
