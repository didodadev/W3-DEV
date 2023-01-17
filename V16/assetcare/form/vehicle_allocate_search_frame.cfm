<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.start_date2" default="#dateformat(date_add('m',-1,now()),dateformat_style)#">
<cfparam name="attributes.finish_date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.is_submitted" default="0">

<cfquery name="get_ship" datasource="#dsn#">
	SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD ORDER BY SHIP_METHOD_ID 
</cfquery>

<cfif len( attributes.start_date2 ) and isDate( attributes.start_date2 )>
	<cf_date tarih='attributes.start_date2'>
	<!--- <cfset attributes.start_date = date_add("h",attributes.start_hour,attributes.start_date)>
	<cfset attributes.start_date = date_add("n",attributes.start_min,attributes.start_date)> --->
</cfif>
<cfif len( attributes.finish_date2 ) and isDate( attributes.finish_date2 )>
	<cf_date tarih='attributes.finish_date2'>
	<!--- <cfset attributes.finish_date = date_add("h",attributes.finish_hour,attributes.finish_date)>
	<cfset attributes.finish_date = date_add("n",attributes.finish_min,attributes.finish_date)> --->
</cfif>

<cf_box>
  <cfform  method="post" name="search_allocate">
    <cf_box_search>
      <input type="hidden" name="is_submitted" value="1">
      <div class="form-group">
        <cf_get_lang dictionary_id='58081.Hepsi'>
        <input name="is_offtime" id="is_offtime" type="radio" value="2" checked>&nbsp;&nbsp;&nbsp;&nbsp;
        <cf_get_lang dictionary_id='48237.Mesai İçi'> 
        <input name="is_offtime" id="is_offtime" value="0" type="radio">&nbsp;&nbsp;&nbsp;&nbsp;
        <cf_get_lang dictionary_id='48229.Mesai Dışı'> 
        <input name="is_offtime" id="is_offtime" type="radio"  value="1">
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='29453.Plaka'></cfsavecontent>
          <input type="hidden" name="assetp_id" id="assetp_id" value=""> 
          <cfinput type="Text" name="assetp" value="" placeholder="#place#" style="width:155px;" readonly> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_name=search_allocate.assetp&field_id=search_allocate.assetp_id','list','popup_list_ship_vehicles');"></span>
        </div>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='48350.Tah Edilen Şube'></cfsavecontent>
          <input type="hidden" name="branch_id" id="branch_id" value=""><cfinput type="Text" name="branch" value="" placeholder="#place#" style="width:155px;" readonly> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_allocate.branch&field_branch_id=search_allocate.branch_id&is_get_all','list','popup_list_branches');"></span>
        </div>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57655.Baş Tarihi'></cfsavecontent>
          <cfinput type="text" name="start_date2" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date2, dateformat_style)#" placeholder="#place#" style="width:68px"> 
          <span class="input-group-addon"><cf_wrk_date_image date_field="start_date2"></span>
        </div>
      </div>
      <!---
      <div class="form-group">
        <cf_wrkTimeFormat  name="start_hour" id="start_hour" value="0">	
        <select name="start_min" id="start_min">
          <cfloop from="0" to="55" index="i" step="5">
            <option value=<cfoutput>"#i#"</cfoutput>><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
          </cfloop>
        </select>
      </div>--->
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bit Tarihi'></cfsavecontent>
          <cfinput type="text" name="finish_date2" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.finish_date2, dateformat_style)#" placeholder="#place#" style="width:68px"> 
          <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date2"></span>
        </div>
      </div>
      <!---
      <div class="form-group">
        <cf_wrkTimeFormat  name="finish_hour" id="finish_hour" value="0">	
        <select name="finish_min" id="finish_min">
          <cfloop from="0" to="55" index="i" step="5">
            <option value=<cfoutput>"#i#"</cfoutput>><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
          </cfloop>
        </select>
      </div>--->
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='48351.Tahsis Edilen'></cfsavecontent>
          <input name="employee_id" id="employee_id" type="hidden" value="">
          <cfinput type="text" placeholder="#place#" name="employee" maxlength="10" style="width:155px" readonly> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_allocate.employee_id&field_name=search_allocate.employee','list','popup_list_positions');"></span>
        </div>
      </div>
      <div class="form-group small">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
      </div>
      <div class="form-group">
        <cf_wrk_search_button search_function='kontrol()' button_type="4">
      </div>
    </cf_box_search>
  </cfform>
</cf_box>
<script type="text/javascript">	
function kontrol()
{
	if(document.search_allocate.maxrows.value>200)
	{
		alert("<cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>");
		return false;
	}
	return true;
}
</script>

