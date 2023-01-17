<cfquery name="GET_PROCESS_TYPE_HISTORY" datasource="#DSN#">
	SELECT 
		*
	FROM
		PROCESS_TYPE_HISTORY
	WHERE
		PROCESS_ID = #attributes.process_id#
	ORDER BY 
		HISTORY_ID DESC
</cfquery>
<cfquery name="GET_PROCESS" datasource="#dsn#">
	SELECT PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID = #attributes.process_id#
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_process_type_history.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="title_">
	<cfif isdefined('attributes.process_id')><cf_get_lang dictionary_id='57756.Süreç'><cfelse><cf_get_lang dictionary_id='57482.Aşama'></cfif>
    <cf_get_lang dictionary_id='57473.Tarihçe'>: <cfoutput>#GET_PROCESS.PROCESS_NAME#</cfoutput>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title_#" draggable="1" closable="1">
		<cfif get_process_type_history.recordcount>
			<cfset temp_ = 0>
			<cfoutput query="get_process_type_history">
				<cfset temp_ = temp_ +1>
					<div class="row" id="history_#temp_#">
						<div class="col col-4">
							<div class="col col-12 padding-5">
								<div class="txtbold col col-6"><cf_get_lang dictionary_id='57487.No'></div>
								<div class="col col-6">#currentrow#</div>
							</div>
							<div class="col col-12 padding-5">
								<div class="txtbold col col-6"><cf_get_lang dictionary_id='58859.Süreç'></div>
								<div class="col col-6">#process_name#</div>
							</div>
							<div class="col col-12 padding-5">
								<div class="txtbold col col-6"><cf_get_lang dictionary_id="36185.Fuseaction"></div>
								<div class="col col-6" title="#faction#">#listfirst(faction)#<strong>...</strong></div>
							</div>
							<div class="col col-12 padding-5">
								<div class="txtbold col col-6"><cf_get_lang dictionary_id='57493.Aktif'></div>
								<div class="col col-6"><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></div>
							</div>
							<div class="col col-12 padding-5">
								<div class="txtbold col col-6"><cf_get_lang dictionary_id='36226.Aşamalar Geriye Dönebilir'></div>
								<div class="col col-6"><cfif is_stage_back eq 1><cf_get_lang dictionary_id='58564.Var'><cfelse><cf_get_lang dictionary_id='58546.Yok'></cfif></div>
							</div>
						</div>
					</div>
				
			</cfoutput>
		<cfelse>
			<div>
				<div colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</div>
			</div>
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
		
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="process.emtypopup_dsp_process_file_history&process_id=#attributes.process_id#">
					
		</cfif>	
	</cf_box>
</div>
