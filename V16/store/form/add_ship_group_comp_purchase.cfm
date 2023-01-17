<cfquery name="get_pro_cat_1" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN  (75,77,76,73,74) AND PROCESS_MODULE = 32
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        PROCESS_DATE 
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #SESSION.EP.PERIOD_YEAR#
</cfquery>
<cfquery  name="get_comp_money"  datasource="#dsn#">
	SELECT
		OC.COMP_ID,
		OC.NICK_NAME
	FROM
		SETUP_MONEY SM,
		OUR_COMPANY OC
	WHERE
		OC.COMP_ID=SM.COMPANY_ID AND
		SM.MONEY_STATUS=1 AND
		SM.RATE1=SM.RATE2 AND
		SM.MONEY = '#session.ep.money#' AND		
		OC.COMP_ID = #attributes.OUR_COMPANY_ID#
</cfquery>
<cf_popup_box title="Fatura Kontrol (Şirketler Arası Konsolide)">
    <cfform action="#request.self#?fuseaction=store.emptypopup_add_ship_group_comp" name="add_irs" method="post">
		<input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>">
		<input type="hidden" name="old_period_id" id="old_period_id" value="<cfoutput>#attributes.old_period_id#</cfoutput>">
		<table>
          <tr>
            <td width="100"><cf_get_lang_main no="388.İşlem Tipi"></td>
            <td>
                <select name="process_cat" id="process_cat" style="width:150px;">
                    <cfoutput query="get_pro_cat_1">
                        <option value="#PROCESS_CAT_ID#">#process_cat#</option>
                    </cfoutput>
                </select>
            </td>
          </tr>
          <tr>
            <td><cf_get_lang no="192.Periyot"></td>
            <td>
                <select name="period_id" id="period_id" style="width:150px;" >
                    <cfoutput query="get_period">
                        <option value="#PERIOD_ID#">#PERIOD#</option>
                    </cfoutput>
                </select>
            </td>
          </tr>
          <tr>
            <td><cf_get_lang_main no="1351.Depo">*</td>
            <td>
                <input type="hidden" name="branch_id" id="branch_id">
                <input type="hidden" name="location_id" id="location_id">						
                <input type="hidden" name="department_id" id="department_id">
                <cfsavecontent variable="message">Depo Girmelisiniz!</cfsavecontent>
                <cfinput type="Text"  style="width:150px;" name="txt_departman_" required="yes" message="#message#" passthrough="readonly">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=add_irs&field_name=txt_departman_&field_id=department_id&field_location_id=location_id&branch_id=branch_id&system_company_id=#session.ep.company_id#','medium')" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></cfoutput>
            </td>
          </tr>
          <tr>
            <td><cf_get_lang_main no="363.Teslim Alan"></td>
            <td>
              <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="">
              <cfinput type="text" name="deliver_get" style="width:150px;"  passThrough="readonly">
              <a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_irs.deliver_get&field_emp_id2=add_irs.deliver_get_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1</cfoutput>','medium','popup_list_positions')">
              <img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a>
            </td>
          </tr>
          <tr>
            <td>
                <!--- <cfquery name="get_comp_id" datasource="#DSN#">
                    SELECT COMPANY_ID FROM COMPANY WHERE OUR_COMPANY_ID=#attributes.OUR_COMPANY_ID#
                </cfquery> partner_id çekilmiyordu--->
                <cfquery name="get_comp_id" datasource="#DSN#" maxrows="1">
                    SELECT 
                        C.COMPANY_ID,
                        CP.PARTNER_ID,
                        C.COMPANY_ADDRESS								
                    FROM 
                        COMPANY C,
                        COMPANY_PARTNER CP 
                    WHERE 
                        C.OUR_COMPANY_ID=#attributes.OUR_COMPANY_ID#
                        AND CP.COMPANY_PARTNER_STATUS = 1
                        AND CP.COMPANY_ID = C.COMPANY_ID
                </cfquery>
                <cfif get_comp_id.recordcount>
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_comp_id.COMPANY_ID#</cfoutput>">
                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_comp_id.PARTNER_ID#</cfoutput>">
                    <input type="hidden" name="comp_address" id="comp_address" value="<cfoutput>#get_comp_id.COMPANY_ADDRESS#</cfoutput>">
                </cfif>
            </td>
          </tr>
        </table>
        <cf_popup_box_footer>
			<cfif get_comp_id.recordcount >
                <cfif get_comp_money.recordcount>
                    <cf_workcube_buttons is_upd='0'>
                <cfelse>
                    <font color="red"><cf_get_lang no="193.Firma Sistem Para Birimi Farklıdır">!</font>
                </cfif>
            <cfelse>
                <font color="red"><cf_get_lang no="194.Firmanızı Kurumsal Üye Olarak Ekleyiniz">!</font>
            </cfif>
        </cf_popup_box_footer>
     </cfform>
</cf_popup_box>
