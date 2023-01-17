<cf_xml_page_edit fuseact="ehesap.popup_form_add_salary_money">
<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_zones" datasource="#dsn#">
	SELECT ZONE_NAME,ZONE_ID FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
</cfquery>
<script type="text/javascript">
	function unformat_fields()
	{
		<cfoutput query="get_moneys">
		 add_salary_money.WORTH_#MONEY#.value = filterNum(add_salary_money.WORTH_#MONEY#.value,8);
		</cfoutput>
		return true;
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53355.Döviz Karşılığı Ekle"></cfsavecontent>
<cf_box title="#message#">
<cfform name="add_salary_money" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_salary_money">
  <cf_box_elements>
    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" sort="true" index="1">
      <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
            <div class="col col-8 col-xs-12">
              <select name="salary_year" id="salary_year" style="width:100px;" >
                <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                  <cfoutput>
                  <option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
                  </cfoutput>
              </cfloop>					
            </select>
            </div>
      </div>

      <div class="form-group" >
        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
        <div class="col col-8 col-xs-12">
          <select name="salary_month" id="salary_month" style="width:100px;" >
            <option value="1"><cf_get_lang dictionary_id='57592.Ocak'>
            <option value="2"><cf_get_lang dictionary_id='57593.Şubat'>
            <option value="3"><cf_get_lang dictionary_id='57594.Mart'>
            <option value="4"><cf_get_lang dictionary_id='57595.Nisan'>
            <option value="5"><cf_get_lang dictionary_id='57596.Mayıs'>
            <option value="6"><cf_get_lang dictionary_id='57597.Haziran'>
            <option value="7"><cf_get_lang dictionary_id='57598.Temmuz'>
            <option value="8"><cf_get_lang dictionary_id='57599.Ağustos'>
            <option value="9"><cf_get_lang dictionary_id='57600.Eylül'>
            <option value="10"><cf_get_lang dictionary_id='57601.Ekim'>
            <option value="11"><cf_get_lang dictionary_id='57602.Kasım'>
            <option value="12"><cf_get_lang dictionary_id='57603.Aralık'>
        </select>
        </div>
      </div>

      <cfif xml_zone_control eq 1>
        <div class="form-group" >
          <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
          <div class="col col-8 col-xs-12">
            <select name="zone_id" id="zone_id" style="width:100px;">
	      			<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
	      			<cfoutput query="get_zones">
	      				<option value="#zone_id#">#zone_name#</option>
	      			</cfoutput>
	      		</select>
          </div>
        </div>
      </cfif>

      <cfoutput query="get_moneys">
        
      <div class="form-group" >
        <label class="col col-4 col-xs-12">#MONEY#</label>
        <div class="col col-8 col-xs-12">
          <input type="hidden" name="MONEY_#MONEY#" id="MONEY_#MONEY#" value="#MONEY#">
          <cfinput type="text" name="WORTH_#MONEY#" onkeyup="return(FormatCurrency(this,event,8));" style="width:150px;" value="">
        </div>
    </div>
    </cfoutput>


    </div>
  </cf_box_elements>

  <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='unformat_fields()'></cf_box_footer>
</cfform>
</cf_box>
