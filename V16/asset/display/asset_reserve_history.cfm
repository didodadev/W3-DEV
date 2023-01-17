<!--- ************************************
STATUS = 0 -> REZERVASYON YAPILABİLİR
STATUS = 1 ->REZERVE EDİLDİ
STATUS = 2 ->TESLİM EDİLDİ

************************* --->

<cfquery name="GET_ASSET_NAME" datasource="#DSN#">
	SELECT 
		ASSETP_ID, 
		ASSETP 
	FROM 
		ASSET_P 
	WHERE	
		ASSETP_ID = #URL.ASSET_ID#
</cfquery>
<cfquery name="GET_ASSETP_RESERVE" datasource="#dsn#">
	SELECT 
		ASSETP_ID, 
		ASSETP_RESID,
		EVENT_ID, 
		DETAIL,
		RECORD_EMP, 
		STARTDATE, 
		FINISHDATE,
		RETURN_DATE,
		STATUS
	FROM 
		ASSET_P_RESERVE
	WHERE 
		ASSETP_ID = #URL.ASSET_ID#
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_assetp_reserve.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang_main no='61.Tarihçe'> :<cfoutput>#GET_ASSET_NAME.ASSETP#</cfoutput></td>
  </tr>
</table>
      <table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border" align="center">
        <tr class="color-header" height="22">
          <td class="form-title" width="243"><cf_get_lang_main no='1713.Olay'></td>
          <td width="219" class="form-title"><cf_get_lang_main no='89.Başlama'></td>
          <td width="342" class="form-title"><cf_get_lang_main no='90.Bitiş'></td>
		  <td width="219" class="form-title"><cf_get_lang dictionary_id="57645.Teslim Tarihi"></td>
          <td width="274" class="form-title"><cf_get_lang_main no='71.Kayıt'></td>
		  <td width="55">&nbsp;</td>
        </tr>
        <cfif GET_ASSETP_RESERVE.RECORDCOUNT>
          <cfoutput query="get_assetp_reserve">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>
                <cfquery name="GET_ASSET_RESERVESS" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						ASSET_P_RESERVE 
					WHERE 
						ASSETP_ID = #attributes.ASSET_ID#
                </cfquery>
                <cfif len(GET_ASSET_RESERVESS.EVENT_ID)>
                  <cfset attributes.EVENT_ID = GET_ASSET_RESERVESS.EVENT_ID>
                  <cfinclude template="../query/get_event_head.cfm">
                  	#EVENT_HEAD.EVENT_HEAD# (<cf_get_lang_main no='1713.Olay'>)
                <cfelseif len(GET_ASSET_RESERVESS.PROJECT_ID)>
                  <cfset attributes.PROJECT_ID = GET_ASSET_RESERVESS.PROJECT_ID>
                  <cfinclude template="../query/get_project_name.cfm">
                    #GET_PROJECT_NAME.PROJECT_HEAD# (<cf_get_lang_main no='4.Proje'>)
                <cfelseif len(GET_ASSET_RESERVESS.CLASS_ID)>
                  <cfset attributes.CLASS_ID = GET_ASSET_RESERVESS.CLASS_ID>
                  <cfinclude template="../query/get_class_name.cfm">
                    #GET_CLASS_NAMES.CLASS_NAME# (<cf_get_lang no='128.Ders'>)
                <cfelse>
                  <cf_get_lang no='73.Olaysız'>
                </cfif>
              </td>
              <td>#dateformat(STARTDATE,dateformat_style)#</td>
              <td>#dateformat(FINISHDATE,dateformat_style)#</td>
			  <td><cfif LEN(GET_ASSETP_RESERVE.RETURN_DATE)>#dateformat(GET_ASSETP_RESERVE.RETURN_DATE,dateformat_style)#</cfif></td>
              <td>#get_emp_info(GET_ASSETP_RESERVE.RECORD_EMP,0,0)#</td>
           	  <td>
			  	<cfif status eq 1>
                  <a href="#request.self#?fuseaction=asset.emptypopup_upd_assetp_reserve&assetp_id=#ASSETP_ID#&ASSETP_RESID=#ASSETP_RESID#"><img src="/images/c_ok.gif" border="0" alt="<cf_get_lang no='17.Teslim Edildi'>" title="<cf_get_lang no='17.Teslim Edildi'>"></a>
				</cfif>
			  </td>
		    </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr>
      <td>
	  <cf_pages 
		  page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="asset.popup_asset_reserve_history">
	  </td>
      <!-- sil --><td height="35"  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>

