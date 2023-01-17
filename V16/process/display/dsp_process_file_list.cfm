<cfquery name="GET_PROCESS_FILE_HISTORY" datasource="#DSN#">
	SELECT 
		*
	FROM
		PROCESS_FILE_HISTORY
	WHERE
	<cfif isdefined('attributes.process_id')>
		PROCESS_ID = #attributes.process_id#
	<cfelseif isdefined('attributes.process_row_id')>
		PROCESS_ROW_ID = #attributes.process_row_id#
	</cfif>	 
</cfquery>
<cfif isdefined('attributes.process_id')>
	<cfquery name="GET_PROCESS" datasource="#dsn#">
		SELECT PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID = #attributes.process_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_PROCESS" datasource="#dsn#"><!--- AŞAMA AŞAĞIDA TEK Bİ DEĞİŞKEN İİNDE KULLANMAK İÇİN AS PROCESS_NAME YAPILDI. --->
		SELECT STAGE AS PROCESS_NAME FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID =  #attributes.process_row_id#
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_PROCESS_FILE_HISTORY.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="title_">
	<cfif isdefined('attributes.process_id')><cf_get_lang dictionary_id='57756.Süreç'><cfelse><cf_get_lang dictionary_id='57482.Aşama'></cfif><cf_get_lang dictionary_id='57473.Tarihçe'>: <cfoutput>#GET_PROCESS.PROCESS_NAME#</cfoutput>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title_#" closable="1" draggable="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="60"><cf_get_lang dictionary_id='36231.Dosya Tipi'></th>
					<th width="160"><cf_get_lang dictionary_id='29800.Dosya Adı'></th>
					<th><cf_get_lang dictionary_id='36232.Dosya İçerik'></th>
					<th width="75"><cf_get_lang dictionary_id='36233.Uzunluk'></th>
					<th width="100"><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
					<th><cf_get_lang dictionary_id='36234.Güncelleme Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif not GET_PROCESS_FILE_HISTORY.RecordCount>
					<tr>
					<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				<cfelse>
					<cfoutput QUERY="GET_PROCESS_FILE_HISTORY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif TYPE eq 1>
							<cfset length = len(trim(DISPLAY_FILE))>
						<cfelse>
							<cfset length = len(trim(ACTION_FILE))>
						</cfif>
						<tr <cfif length gte 0 and length lte 100>height="40"<cfelse>height="120"</cfif>>
							<td>#currentrow#</td>
							<td><cfif TYPE eq 1>Display<cfelse>Action</cfif></td>
							<td><cfif TYPE eq 1>#DISPLAY_FILE_NAME#<cfelse>#ACTION_FILE_NAME#</cfif></td>
							<td width="100%">
								<div id="dsp" style="width:300px;<cfif length gte 0 and length lte 100>height:40px;<cfelse>height:120px;</cfif> z-index:88; overflow:auto;">
									<cfif TYPE eq 1>#HTMLCodeFormat(DISPLAY_FILE)#<cfelse>#HTMLCodeFormat(ACTION_FILE)#</cfif>
								</div>	
							</td>
							<td>#length# ch</td>
							<td>#get_emp_info(UPDATE_EMP,0,0)#</td>
							<td>#DateFormat(UPDATE_DATE,dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,UPDATE_DATE),timeformat_style)#</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined('attributes.process_id')>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="process.emtypopup_dsp_process_file_history&process_id=#attributes.process_id#">
			<cfelse>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="process.emtypopup_dsp_process_file_history&process_row_id=#attributes.process_row_id#">
			</cfif>
		</cfif>	
	</cf_box>
</div>

