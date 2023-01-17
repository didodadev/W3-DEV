<cfset my_now_start = CreateDateTime(year(now()),month(now()),day(now()),00,00,00)>
<cfset my_now_finish = CreateDateTime(year(now()),month(now()),day(now()),23,59,59)>
<cfset my_tomorrow_start = date_add('h',+22,my_now_start)>
<cfset my_tomorrow_finish = date_add('h',+33,my_now_start)>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cf_box>
    <cfform name="add_export_promotion" action="#request.self#?fuseaction=objects.emptypopupflush_export_promotion" method="post">
      <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
          <div class="form-group" id="item-target_pos">
            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'> *</label>
            <div class="col col-8 col-sm-12">
              <select name="target_pos" id="target_pos" style="width:169px;">
                <option value="-1"><cf_get_lang dictionary_id='45932.Genius'></option>
              </select>
            </div>
          </div>
          <div class="form-group" id="item-startdate">
            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'> *</label>
              <div class="col col-4 col-sm-12">
                <div class="input-group">
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                  <cfinput type="text" name="startdate" value="#DateFormat(my_tomorrow_start,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:67px;">
                  <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                </div>  
              </div>
              <div class="col col-2 col-sm-12">
                <select name="start_hour" id="start_hour" style="width:38px">
                  <cfloop from="0" to="23" index="i">
                    <cfoutput><option value="#i#" <cfif i eq timeformat(my_tomorrow_start,'HH')>selected</cfif>>#NumberFormat(i,'00')#</option></cfoutput>
                  </cfloop>
                </select>    
              </div>
              <div class="col col-2 col-sm-12">
                <select name="start_min" id="start_min" style="width:38px">				
                  <cfloop from="0" to="55" index="i" step="5">
                    <cfoutput><option value="#i#" <cfif i eq timeformat(my_tomorrow_start,'MM')>selected</cfif>>#NumberFormat(i,'00')#</option></cfoutput>
                  </cfloop>
                </select>    
              </div>
          </div>
          <div class="form-group" id="item-finishdate">
            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'> *</label>
              <div class="col col-4 col-sm-12">
                <div class="input-group">
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="finishdate" value="#DateFormat(my_tomorrow_finish,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:67px;">               
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                </div>
              </div>
              <div class="col col-2 col-sm-12">
                <select name="finish_hour" id="finish_hour" style="width:38px">
                  <cfoutput>
                  <cfloop from="0" to="23" index="i">
                    <option value="#i#" <cfif i eq timeformat(my_tomorrow_finish,'HH')>selected</cfif>>#NumberFormat(i,'00')#</option>
                  </cfloop>
                  </cfoutput>
                </select>	  
              </div>
              <div class="col col-2 col-sm-12">
                <select name="finish_min" id="finish_min" style="width:38px">
                  <cfloop from="0" to="55" index="i" step="5">
                  <cfoutput><option value="#i#" <cfif i eq timeformat(my_tomorrow_finish,'MM')>selected</cfif>>#NumberFormat(i,'00')#</option></cfoutput>
                  </cfloop>
                </select>	  
              </div>
          </div>
        </div>
      </cf_box_elements>
      <cf_box_footer>
        <cf_workcube_buttons is_upd='0' add_function='form_chk()'>
      </cf_box_footer>
    </cfform>
  </cf_box>
</div>



<script type="text/javascript">
function form_chk()
{
	/*if(add_export_promotion.branch_id.value.length == 0)
	{
		alert("Şube Seçiniz !");
		return false;
	}*/
	
	if((add_export_promotion.startdate.value !="") && (add_export_promotion.finishdate.value !="")) 
	{
		if(add_export_promotion.startdate.value == add_export_promotion.finishdate.value)
		{
			if((add_export_promotion.start_hour.value == add_export_promotion.finish_hour.value) && (add_export_promotion.start_min.value == add_export_promotion.finish_min.value))
			{
				alert("<cf_get_lang dictionary_id ='34037.Başlangıç Tarihi ve Bitiş Tarihi Aynı Olamaz'> !");
				return false;
			}
		}
		return date_check(add_export_promotion.startdate,add_export_promotion.finishdate,"<cf_get_lang dictionary_id ='33707.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'> !");
	}
	
	if(time_check(add_prom.startdate, add_prom.start_clock, add_prom.start_minute, add_prom.finishdate,  add_prom.finish_clock, add_prom.finish_minute, "<cf_get_lang dictionary_id ='34038.Promosyon Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !")) return true; else return false;
	//return true;
}
</script>
