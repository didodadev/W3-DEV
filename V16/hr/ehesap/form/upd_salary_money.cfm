<cf_xml_page_edit fuseact="ehesap.popup_form_add_salary_money">
  <cfinclude template="../query/get_moneys.cfm">
  <cfquery name="get_zones" datasource="#dsn#">
    SELECT ZONE_NAME,ZONE_ID FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
  </cfquery>
  <script type="text/javascript">
    function unformat_fields()
    {
      <cfoutput query="get_moneys">
       upd_salary_money.WORTH_#MONEY#.value = filterNum(upd_salary_money.WORTH_#MONEY#.value,8);
      </cfoutput>
    }
  </script>
  <cfsavecontent variable="message"><cf_get_lang dictionary_id="54346.Döviz Karşılığı"> <cf_get_lang dictionary_id="57464.Güncelle"></cfsavecontent>
  <cf_box title="#message#" add_href="#request.self#?fuseaction=ehesap.popup_form_add_salary_money">
  <cfform name="upd_salary_money" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_salary_money" onsubmit="return (unformat_fields());">
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
            <option value="1" <cfif attributes.salary_month IS 1>selected</cfif>><cf_get_lang dictionary_id='57592.Ocak'></option>
            <option value="2" <cfif attributes.salary_month IS 2>selected</cfif>><cf_get_lang dictionary_id='57593.Şubat'></option>
            <option value="3" <cfif attributes.salary_month IS 3>selected</cfif>><cf_get_lang dictionary_id='57594.Mart'></option>
            <option value="4" <cfif attributes.salary_month IS 4>selected</cfif>><cf_get_lang dictionary_id='57595.Nisan'></option>
            <option value="5" <cfif attributes.salary_month IS 5>selected</cfif>><cf_get_lang dictionary_id='57596.Mayıs'></option>
            <option value="6" <cfif attributes.salary_month IS 6>selected</cfif>><cf_get_lang dictionary_id='57597.Haziran'></option>
            <option value="7" <cfif attributes.salary_month IS 7>selected</cfif>><cf_get_lang dictionary_id='57598.Temmuz'></option>
            <option value="8" <cfif attributes.salary_month IS 8>selected</cfif>><cf_get_lang dictionary_id='57599.Ağustos'></option>
            <option value="9" <cfif attributes.salary_month IS 9>selected</cfif>><cf_get_lang dictionary_id='57600.Eylül'></option>
            <option value="10" <cfif attributes.salary_month IS 10>selected</cfif>><cf_get_lang dictionary_id='57601.Ekim'></option>
            <option value="11" <cfif attributes.salary_month IS 11>selected</cfif>><cf_get_lang dictionary_id='57602.Kasım'></option>
            <option value="12" <cfif attributes.salary_month IS 12>selected</cfif>><cf_get_lang dictionary_id='57603.Aralık'></option>
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
              <option value="#zone_id#" <cfif attributes.zone_id eq zone_id>selected</cfif>>#zone_name#</option>
            </cfoutput>
          </select>
        </div>
      </div>
    </cfif>
   
      <cfoutput query="get_moneys">
        <cfset attributes.money = MONEY>
        <cfinclude template="../query/get_salary_money.cfm">				  
        <cfif GET_SALARY_MONEY.recordcount>
            <cfset money_worth = GET_SALARY_MONEY.WORTH>  
        <cfelse>
            <cfset money_worth = "">  
        </cfif>
      <div class="form-group" >
        <label class="col col-4 col-xs-12">#MONEY#</label>
        <div class="col col-8 col-xs-12">
            <input type="hidden" name="MONEY_#MONEY#" id="MONEY_#MONEY#" value="#MONEY#">
            <cfinput type="text" name="WORTH_#MONEY#" onkeyup="return(FormatCurrency(this,event,8));" value="#TLFormat(money_worth,8)#">
        </div>
    </div>
    </cfoutput>
  

    </div>
      </cf_box_elements>
   <cf_box_footer><cf_record_info query_name="GET_SALARY_MONEY"><cf_workcube_buttons is_upd='1' is_delete='0'></cf_box_footer>
  </cfform>
  </cf_box>
  
  
  