<cfquery name="GET_PROCESS_CAT_FILE_HISTORY" datasource="#DSN3#">
	SELECT 
		*
	FROM
		PROCESS_CAT_HISTORY_FILE
	WHERE
		PROCESS_CAT_ID = #attributes.process_cat_id#
	ORDER BY 
		UPDATE_DATE DESC
</cfquery>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT * FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat_id#
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_PROCESS_CAT_FILE_HISTORY.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('process',89)#: #GET_PROCESS_CAT.PROCESS_CAT#"></cf_medium_list_search>
<cf_basket height="600">
    <table class="medium_list">
        <thead>
            <tr>
              <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
              <th width="60"><cf_get_lang dictionary_id ='36231.Dosya Tipi'></th>
              <th width="160"><cf_get_lang dictionary_id ='29800.Dosya Adı'></th>
              <th><cf_get_lang dictionary_id ='36232.Dosya İçerik'></th>
              <th width="75"><cf_get_lang dictionary_id ='36233.Uzunluk'></th>
              <th width="100"><cf_get_lang dictionary_id ='57891.Güncelleyen'></th>
              <th width="100"><cf_get_lang dictionary_id ='36234.Güncelleme Tarihi'></th>
            </tr>
        </thead>
        <tbody>
         <cfif not GET_PROCESS_CAT_FILE_HISTORY.RecordCount>
              <tr>
                <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
              </tr>
        <cfelse>
            <cfoutput query="GET_PROCESS_CAT_FILE_HISTORY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif TYPE eq 1>
                    <cfset length = len(trim(DISPLAY_FILE))>
                <cfelse>
                    <cfset length = len(trim(ACTION_FILE))>
                </cfif>
                <tr>
                    <td>#currentrow#</td>
                    <td><cfif TYPE eq 1>Display<cfelse>Action</cfif></td>
                    <td><cfif TYPE eq 1>#trim(DISPLAY_FILE_NAME)#<cfelse>#trim(ACTION_FILE_NAME)#</cfif></td>
                    <td><cfif TYPE eq 1><div id="dsp" class="nohover_div">#HTMLCodeFormat(DISPLAY_FILE)#<cfelse>#HTMLCodeFormat(ACTION_FILE)#</cfif></div></td>
                    <td>#length#&nbsp;ch</td>
                    <td>#get_emp_info(UPDATE_EMP,0,0)#</td>
                    <td>#DateFormat(UPDATE_DATE,dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,UPDATE_DATE),timeformat_style)#</td>
                </tr>
            </cfoutput>
        </cfif>
        </tbody>
    </table>
</cf_basket>

<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="30">
    <tr>
      <td>
		<cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="process.emtypopup_dsp_process_cat_file_history&process_cat_id=#attributes.process_cat_id#">
	 </td>
      <!-- sil --><td align="right" class="label" style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#GET_PROCESS_CAT_FILE_HISTORY.recordcount#</cfoutput>&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>	
