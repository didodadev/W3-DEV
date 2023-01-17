<cfparam name="attributes.page" default=1>
<cfparam name="modal_id" default="">
<cfparam name="attributes.document" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.pr_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
    url_string = '';
    if (isdefined('attributes.document')) url_string = '#url_string#&document=#attributes.document#';
    if (isdefined('attributes.process_cat')) url_string = '#url_string#&process_cat=#attributes.process_cat#';
    if (isdefined('attributes.field_serial')) url_string = '#url_string#&field_serial=#attributes.field_serial#';
    if (isdefined('attributes.is_form_submitted')) url_string = '#url_string#&is_form_submitted=1';

</cfscript>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_serial" datasource="#dsn3#">
        SELECT
            ORR.SERIAL,
            ORQ.RESULT_NO,
            ORQ.PROCESS_CAT as PROCESS_CAT_
        FROM
            ORDER_RESULT_QUALITY ORQ
        LEFT JOIN
            ORDER_RESULT_QUALITY_ROW ORR ON ORR.OR_Q_ID = ORQ.OR_Q_ID
        WHERE
            ORQ.RESULT_NO= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document#">
            AND ORR.SERIAL IS NOT NULL
            AND ORR.SERIAL <> '' 
            <cfif isDefined("attributes.process_cat") and len(attributes.process_cat)>
                AND PROCESS_CAT_ = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
            </cfif>
        GROUP BY ORR.SERIAL, ORQ.RESULT_NO, ORQ.PROCESS_CAT
    </cfquery>
    
        
<cfelse>
	<cfset get_serial.recordcount = 0>
</cfif>
<cfif get_serial.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_serial.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_serial.recordcount#>
<script>
    function send_serial(serial_no)
    {
    <cfif isdefined("attributes.field_serial")>
		document.<cfoutput>#field_serial#</cfoutput>.value = serial_no;
	</cfif>
    closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
}
</script>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Seri No','57637')#" popup_box="1">
        <cfform name="search_list" action="#request.self#?fuseaction=stock.list_serial_no#url_string#" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="document" value="#attributes.document#"  readonly  placeholder="#getLang('','Belge','57468')#">
                </div>
                <div class="form-group">
                        <select name="process_cat" id="process_cat">
                            <option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
                            <option value="76" <cfif attributes.process_cat eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
                            <option value="171" <cfif attributes.process_cat eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                            <option value="811" <cfif attributes.process_cat eq 811>selected</cfif>><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></option>
                            <option value="-1" <cfif attributes.process_cat eq -1>selected</cfif>><cf_get_lang dictionary_id="36376.Operasyonlar"></option>
                            <option value="-2" <cfif attributes.process_cat eq -2>selected</cfif>><cf_get_lang dictionary_id="57656.Servis"></option>
                        </select>    
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_list','#attributes.modal_id#')"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>		
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57637.Seri No'></th>
                    <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_serial.recordcount>
				    <cfoutput query="get_serial" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="javascript://" onClick="send_serial('#SERIAL#')">#SERIAL#</a></td>
                            <td>
                                <cfif get_serial.PROCESS_CAT_ eq 76><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></cfif>
                                <cfif get_serial.PROCESS_CAT_ eq 171><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfif>
                                <cfif get_serial.PROCESS_CAT_ eq 811><cf_get_lang dictionary_id="29588.İthal Mal Girişi"></cfif>
                                <cfif get_serial.PROCESS_CAT_ eq -1><cf_get_lang dictionary_id="36376.Operasyonlar"></cfif>
                                <cfif get_serial.PROCESS_CAT_ eq -2><cf_get_lang dictionary_id="57656.Servis"></cfif>
                            </td>
                            <td>#RESULT_NO#</td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>	
        <cfif get_serial.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif isDefined('is_form_submitted') and is_form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="stock.list_serial_no#url_string#">
		</cfif>
    </cf_box>
</div>