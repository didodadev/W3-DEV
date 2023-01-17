<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.block_group" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfquery name="GET_BLOCK_GROUP" datasource="#DSN#">
	SELECT 
		BLOCK_GROUP_ID,
		BLOCK_GROUP_NAME
	FROM 
		BLOCK_GROUP
	ORDER BY
		BLOCK_GROUP_NAME
</cfquery>
<cfquery name="GET_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ch.list_block_request%">
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfset attributes.start_date = #dateformat(attributes.start_date,dateformat_style)#>
	<cfset attributes.finish_date = #dateformat(attributes.finish_date,dateformat_style)#>
	<cfquery name="GET_BLOCK_REQUEST" datasource="#DSN#">
		SELECT
			CBR.COMPANY_ID,
			CBR.CONSUMER_ID,
			CBR.COMPANY_BLOCK_ID,
			CBR.PROCESS_STAGE,
			CBR.BLOCK_GROUP_ID,
			CBR.BLOCK_START_DATE,
			CBR.BLOCK_FINISH_DATE,
			CBR.BLOCK_GROUP_ID,
			CBR.RECORD_DATE,
            C.FULLNAME,
            C2.CONSUMER_NAME + ' ' + C2.CONSUMER_SURNAME AS CONSUMER,
            BG.BLOCK_GROUP_NAME,
            PTR.STAGE
		FROM
			COMPANY_BLOCK_REQUEST AS CBR
            LEFT JOIN COMPANY AS C ON C.COMPANY_ID = CBR.COMPANY_ID
            LEFT JOIN CONSUMER AS C2 ON C2.CONSUMER_ID = CBR.CONSUMER_ID
            LEFT JOIN BLOCK_GROUP AS BG ON BG.BLOCK_GROUP_ID = CBR.BLOCK_GROUP_ID
            LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID = CBR.PROCESS_STAGE
		WHERE
			1 = 1
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			AND CBR.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.member_name)>
			AND CBR.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.block_group)>
			AND CBR.BLOCK_GROUP_ID = #attributes.block_group#
		</cfif>
		<cfif len(attributes.process_stage_type)>
			AND CBR.PROCESS_STAGE = #attributes.process_stage_type#
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND CBR.RECORD_DATE >= #createodbcdatetime(attributes.start_date)#
		</cfif>
		<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND CBR.RECORD_DATE <= #createodbcdatetime(attributes.finish_date)#
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_block_request.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_block_request.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_block_request" method="post" action="#request.self#?fuseaction=ch.list_block_request">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class ="form-group">
					<div class="input-group">
						<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.member_name)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
						<input type="hidden" name="company_id"  id="company_id" <cfif len(attributes.member_name)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
						<input type="text" name="member_name" id="member_name" style="width:125px;"  onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');" value="<cfif len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput><cf_get_lang dictionary_id='57519.Cari Hesap'></cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=list_block_request.member_name&field_comp_id=list_block_request.company_id&field_consumer=list_block_request.consumer_id&field_member_name=list_block_request.member_name&select_list=2,3','list');</cfoutput>"></span>
					</div>
				</div>
				<div class ="form-group">
					<select name="block_group" id="block_group" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfoutput query="get_block_group">
							<option value="#block_group_id#" <cfif block_group_id eq attributes.block_group>selected</cfif>>#block_group_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class ="form-group">
					<select name="process_stage_type" id="process_stage_type" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="start_"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" placeholder="#start_#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="finish_"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" placeholder="#finish_#" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(85,'Blok Takip İşlemleri',50058)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='50057.Bloklama Nedeni'></th>
					<th><cf_get_lang dictionary_id ='58054.Süreç - Aşama'></th>
					<th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ch.list_block_request&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_block_request.recordcount>
					<cfoutput query="get_block_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<cfif len(company_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#FULLNAME#</a>
								<cfelseif len(consumer_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#CONSUMER#</a>
								</cfif>
							</td>
							<td>#dateformat(block_start_date,dateformat_style)#</td>
							<td>#dateformat(block_finish_date,dateformat_style)#</td>
							<td>#BLOCK_GROUP_NAME#</td>
							<td>#STAGE#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil --><td align="center"><a href="#request.self#?fuseaction=ch.list_block_request&event=upd&block_id=#company_block_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
			</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif isdefined ("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif> 
		<cfif len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif> 
		<cfif len(attributes.block_group)>
			<cfset url_str = "#url_str#&block_group=#attributes.block_group#">
		</cfif> 
		<cfif len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="ch.list_block_request#url_str#">
	</cf_box>
</div>
<script>
	document.getElementById('member_name').focus();
	function kontrol()
	{
		if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
</script>
