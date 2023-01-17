<cfsetting showdebugoutput="no">
<cfparam name="attributes.divId" default="open_works_prog_">
<cfparam name="attributes.fieldName" default="work_prog">
<cfparam name="attributes.fieldId" default="work_prog_id">
<cfparam name="attributes.rows" default="0">
<cfparam name="attributes.modal_id" default="">
<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
<cfquery name="get_station_times" datasource="#dsn#">
    SELECT 
		SHIFT_NAME,
		SHIFT_ID,
		START_HOUR,
		START_MIN,
		END_HOUR,
		END_MIN
	FROM 
	 	SETUP_SHIFTS 
	WHERE 
		IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='36795.Çalışma Programı'></cfsavecontent>
<cf_box id="works_prog_#attributes.rows#" title="#message#" style="width:320px;" body_style="overflow:auto;" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_ajax_list>
    	<thead>
             <tr>
                  <th width="10" class="txtboldblue" valign="top"><cf_get_lang dictionary_id='57487.No'></th>
                  <th width="100" class="txtboldblue" valign="top"><cf_get_lang dictionary_id="36795.Çalışma Programı"></th>
                  <th width="100" class="txtboldblue" valign="top"><cf_get_lang dictionary_id="63607.Saatler"></th>
             </tr>
        </thead>
        <tbody>
			<cfif get_station_times.recordcount>
                <cfoutput query="get_station_times">
                    <tr>
                        <td valign="top">#currentrow#</td>
                        <td valign="top">
                            <cfset SHIFT_NAME_ = Replace(SHIFT_NAME,"'"," ","all")><cfset SHIFT_NAME_ = Replace(SHIFT_NAME_,'"'," ","all")>
                            <a onClick="add_row_shift('#SHIFT_NAME_#','#SHIFT_ID#');" style="cursor:pointer;">#SHIFT_NAME_#</a>
                        </td valign="top">
                        <td valign="top">[#START_HOUR#:#START_MIN#]-[#END_HOUR#:#END_MIN#]</td>
                    </tr>
                </cfoutput> 
            <cfelse>    
                <tr><td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td></tr>
            </cfif>
        </tbody>
	</cf_ajax_list>
</cf_box>
<script type="text/javascript">
function add_row_shift(name,id){
	<cfoutput>
	document.getElementById('#attributes.fieldName#').value = name;
	document.getElementById('#attributes.fieldId#').value = id;
	document.getElementById('works_prog_#attributes.rows#').style.display ='none';
	document.getElementById('#attributes.divId#').style.display='none';
	</cfoutput>
    closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
}
</script>

