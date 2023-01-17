<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("form_submitted")>
	<cfinclude template="../query/get_my_apps.cfm">
	<cfparam name="attributes.totalrecords" default="#get_apps.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfquery name="GET_NOTICESS" datasource="#DSN#">
  SELECT NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES ORDER BY NOTICE_HEAD
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">	
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" placeholder="#message#" value="#attributes.keyword#" style="width:100px;">
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" placeholder="#message#" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>	
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" placeholder="#message#" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>	 
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" maxlength="3" required="yes" onKeyUp="isNumber(this)" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31459.Başvurularım'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="180"><cf_get_lang dictionary_id='31477.İlan Başlığı'></th>
					<th width="180"><cf_get_lang dictionary_id='31362.Başvuru Tarihi'></th>
					<th width="180"><cf_get_lang dictionary_id='58497.Pozisyon'></th>	
					<th width="180"><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("form_submitted") and get_apps.recordcount>
					<cfoutput query="get_apps" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_upd_app_pos&notice_id=#notice_id#&app_pos_id=#APP_POS_ID#','small');" class="tableyazi">#app_pos_id#</a></td>
							<td>
								<cfif len(NOTICE_ID)>
									<cfset notice_id_ = contentEncryptingandDecodingAES(isEncode:1,content:notice_id,accountKey:session.ep.userid)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_notice&notice_id=#notice_id_#','page');" class="tableyazi">#NOTICE_NO#-#NOTICE_HEAD#</a>
								</cfif>
							</td>
							<td>#dateformat(APP_DATE,dateformat_style)#</td>
							<td><a href="#request.self#?fuseaction=myhome.my_profile" class="tableyazi">#name# #surname#</a></td>
							<td><cfif app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<cfif isdefined("form_submitted")><td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td><cfelse><td colspan="6"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td></cfif>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>	
</div>

<cfset adres="">
<cfif len(attributes.keyword)>
	<cfset adres="#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset adres="#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset adres="#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset adres="#adres#&form_submitted=#attributes.form_submitted#">
</cfif>
<cf_paging
	page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#attributes.fuseaction##adres#">

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{	
		if(document.getElementById("start_date") != "" && document.getElementById("finish_date") != "")
		{
			if(!date_check(document.getElementById("start_date"),document.getElementById("finish_date"),"<cf_get_lang dictionary_id='57806.Tarih Araligini Kontrol Ediniz'>!"))
			{
				return false;
			}
		}
		return true;
	}
	</script>