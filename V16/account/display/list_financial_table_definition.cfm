<cfparam  name="attributes.TABLE_TYPE" default="">
<cfparam  name="attributes.record_emp" default="">
<cfparam  name="attributes.record_name" default="">
<cfparam  name="attributes.author_id" default="">
<cfparam  name="attributes.author_name" default="">
<cfparam  name="attributes.table_name" default="">
<cfparam  name="attributes.process_stage" default="">
<cfparam  name="attributes.record_date" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih = "attributes.record_date">
</cfif>
<cfscript>
	get_defs = createObject("component", "V16.account.cfc.get_financial_audits");
	get_defs.dsn2 = dsn2;
	get_defs.dsn_alias = dsn_alias;
	get_definitions = get_defs.get_definitions_fnc(
	table_name : '#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#',
	table_type : '#iif(isdefined("attributes.table_type"),"attributes.table_type",DE(""))#',
	PROCESS_STAGE : '#iif(isdefined("attributes.PROCESS_STAGE"),"attributes.PROCESS_STAGE",DE(""))#',
	startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
	maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#',
	record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#'
	);
</cfscript>
<cfif get_definitions.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_definitions.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfsavecontent variable="header"><cf_get_lang dictionary_id="60077.Mali tablo tanımlama"></cfsavecontent>
<cfsavecontent variable="alan1"><cf_get_lang dictionary_id='36201.Tablo Adı'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=account.financial_audit_table_definition">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-table_name">
					<div class="col col-12 col-xs-12">
						<cfinput type="text" name="table_name" id="table_name" placeholder="#alan1#">
					</div>
				</div>
				<div class="form-group large" id="item-TABLE_TYPE">
					<select name="TABLE_TYPE" id="TABLE_TYPE">
						<option value=""><cf_get_lang dictionary_id='59088.Tip'></option>
						<option value="7" <cfif attributes.TABLE_TYPE eq 7>selected</cfif>><cf_get_lang dictionary_id='31810.GELIR TABLOSU TANIMLARI'></option>
						<option value="8" <cfif attributes.TABLE_TYPE eq 8>selected</cfif>><cf_get_lang dictionary_id='31811.BILANÇO TABLOSU TANIMLARI'></option>
						<option value="9" <cfif attributes.TABLE_TYPE eq 9>selected</cfif>><cf_get_lang dictionary_id='47395.SATIŞLARIN MALİYETİ TABLOSU TANIMLARI'></option>
						<option value="10" <cfif attributes.TABLE_TYPE eq 10>selected</cfif>><cf_get_lang dictionary_id='47376.NAKİT AKIM TABLOSU TANIMLARI'></option>
						<option value="11" <cfif attributes.TABLE_TYPE eq 11>selected</cfif>><cf_get_lang dictionary_id='47325.FON AKIM TABLOSU TANIMLARI'></option>
					</select>
				</div>
				<div class="form-group" id="item-record_id">
					<div class="input-group">
						<input type="hidden" name="record_id" id="record_id" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_id#</cfoutput></cfif>" >					
						<input type="text" name="record_name" id="record_name" placeholder="<cfoutput>#getLang('main',487)#</cfoutput>" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','record_id','','3','125');"  autocomplete="off" >                    
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search.record_name&field_emp_id=search.record_id&select_list=1','list');return false"></span>
					</div>
				</div> 
				<div class="form-group" id="form_ul_record_date">
					<cfsavecontent variable="message_"><cf_get_lang dictionary_id='57742.Tarihi'></cfsavecontent>
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
						<cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" placeHolder="#message_#" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
					</div>
				</div>
				<div class="form-group medium" id="item-process">
					<cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_select_text='1' process_cat_width='150' is_detail='0'>
				</div> 
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes">
				</div> 
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=account.financial_audit_table_definition&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div><!-- sil -->  
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cf_box title="#header#" uidrop="1" hide_table_column="1">
		 <cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='36201.Tablo Adı'></th>
					<th><cf_get_lang dictionary_id ='59088.Tip'></th>
					<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id ='30631.Tarih'></th>
					<th width="20"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
				</tr>
			</thead>
			<cfif get_definitions.recordcount>
				<tbody>
					<cfoutput query="get_definitions">
						<tr>
							<td>#table_name#</td>
							<td>
								<cfif table_type eq 7>
									<cf_get_lang dictionary_id='31810.GELIR TABLOSU TANIMLARI'>
								<cfelseif  table_type eq 8>
									<cf_get_lang dictionary_id='31811.BILANÇO TABLOSU TANIMLARI'>
								<cfelseif  table_type eq 9>
									<cf_get_lang dictionary_id='47395.SATIŞLARIN MALİYETİ TABLOSU TANIMLARI'>
								<cfelseif  table_type eq 10>
									<cf_get_lang dictionary_id='47376.NAKİT AKIM TABLOSU TANIMLARI'>
								<cfelseif  table_type eq 11>
									<cf_get_lang dictionary_id='47325.FON AKIM TABLOSU TANIMLARI'>
								</cfif>
							</td>
							<td>#stage#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td><a href="#request.self#?fuseaction=account.financial_audit_table_definition&event=upd&audit_id=#financial_audit_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				</tbody>
			</cfif>
		</cf_flat_list> 
		<cfset adres="account.financial_audit_table_definition">
		<cfif isDefined('attributes.table_name') and len(attributes.table_name)>
			<cfset adres = "#adres#&table_name=#attributes.table_name#">
		</cfif>
		<cfif isDefined('attributes.table_type') and len(attributes.table_type)>
			<cfset adres = "#adres#&table_type=#attributes.table_type#">
		</cfif>
		<cfif isDefined('attributes.PROCESS_STAGE') and len(attributes.PROCESS_STAGE)>
			<cfset adres = "#adres#&PROCESS_STAGE=#attributes.PROCESS_STAGE#">
		</cfif>
		<cfif isDefined('attributes.record_date') and len(attributes.record_date)>
			<cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
