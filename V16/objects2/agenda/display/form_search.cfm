<!-- Filtre --> 
<cfinclude template="../query/get_event_cats.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfform name="search_" method="POST" action="">
    <table style="text-align:right;">
        <tr>
            <td><cf_get_lang_main no='48.Filtre'> :</td>
            <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="100" style="width:100px;"></td>
            <td>
                <select name="eventcat_id" id="eventcat_id" style="width:100px;">
                    <option value="0"><cf_get_lang_main no='296.Hepsi'></option>
                    <cfoutput query="get_event_cats">
                    	<cfif isdefined("attributes.eventcat_id")>
                    		<option value="#eventcat_id#" <cfif attributes.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
                    	<cfelse>
                    		<option value="#eventcat_id#">#eventcat#</option>
                    	</cfif>
                    </cfoutput>
                </select>
            </td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihini Yazınız'></cfsavecontent>
                <cfif isdefined("startdate")>
                    <cfinput type="text" name="startdate" id="startdate" value="#dateformat(startdate,'dd/mm/yyyy')#" style="width:70px;" validate="eurodate" maxlength="10" message="#message# !">
                <cfelse>
                    <cfinput type="text" name="startdate" id="startdate" value="" style="width:70px;" validate="eurodate" maxlength="10" message="#message# !">
                </cfif>
                <cf_wrk_date_image date_field="startdate">
            </td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş tarihini Giriniz'></cfsavecontent>
                <cfif isdefined("finishdate")>
                    <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(finishdate,'dd/mm/yyyy')#" style="width:70px;" validate="eurodate" maxlength="10" message="#message# !">
                <cfelse>
                    <cfinput type="text" name="finishdate" id="finishdate" value="" style="width:70px;" validate="eurodate" maxlength="10" message="#message# !">
                </cfif>
                <cf_wrk_date_image date_field="finishdate">
            </td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button search_function='check()'></td>
        </tr>
    </cfform>
</table>
<script type="text/javascript">
function check()
{
	if ( (document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != "") )
		return date_check(document.search_.startdate, document.search_.finishdate, "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'>");
		return true;
}
</script>

