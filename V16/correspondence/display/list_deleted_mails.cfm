<cfset attributes.death = 1>
<cfinclude template="../../objects/query/get_mail.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_mails.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td height="35">
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td height="35" class="headbold"><cf_get_lang_main no='1884.CubeMail'></td>
			<td  style="text-align:right;">
			  <table>
				<cfform action="#request.self#?fuseaction=correspondence.send_mail&type=2" method="post" name="form">
				  <tr>
					<td  class="txtboldblue">&nbsp;</td>
					<td width="50"  style="text-align:right;"><cf_get_lang_main no='48.Filtre'>:</td>
					<td width="100"><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
					<td width="15">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td width="15"><cf_wrk_search_button></td>
				  </tr>
				</cfform>
			  </table>
			</td>
		  </tr>
		</table>
	</td>
  </tr>
  <tr>
    <td>
<table cellspacing="0" cellpadding="0" border="0" width="98%" height="100%" align="center">
<tr class="color-border">
  <td>
    <table cellspacing="1" cellpadding="2" width="100%" height="100%" border="0">
      <tr class="color-list">
        <td width="145" rowspan="2" valign="top" class="color-row"><cfinclude template="../display/mails_menu_tr.cfm">
        </td>
        <td class="txtboldblue" height="17">&nbsp;&nbsp;<cf_get_lang no='46.Silinen Mail'></td>
      </tr>
      <tr class="color-row">
        <td valign="top">
          <table cellspacing="1" cellpadding="2" width="100%" border="0">
            <tr class="color-header" height="20">
              <td width="20" class="form-title">&nbsp;</td>
              <cfoutput>
                <cfset extra_code = "">
                <cfset extra_code = "#extra_code#&page=#attributes.page#">
                <cfset extra_code = "#extra_code#&maxrows=#attributes.maxrows#">
                <cfset extra_code = "#extra_code#&startrow=#attributes.startrow#">
                <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                  <cfset extra_code = "#extra_code#&keyword=#attributes.keyword#">
                </cfif>
                <td width="15" align="center"><a href="##" onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.send_mail&order_attach=&type=2<cfif isDefined("attributes.click_count")>&click_count=#attributes.click_count#</cfif>#extra_code#'"><img src="images/attach.gif" alt="" border="0"></a></td>
                <td><a href="##" class="form-title" onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.send_mail&order_subject=&type=2#extra_code#'"><cf_get_lang_main no='68.Konu'></a></td>
                <td width="125"><a href="##" class="form-title"  onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.send_mail&order_module=&type=2#extra_code#'"><cf_get_lang no='25.Modül'></a></td>
                <td class="form-title" ><cf_get_lang_main no='512.Kime'></td>
                <td width="130"><a href="##" class="form-title" onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.send_mail&order_from=&type=2#extra_code#'"><cf_get_lang no='43.From'></a></td>
                <td width="60"><a href="##" class="form-title" onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.send_mail&order_date=&type=2#extra_code#'"><cf_get_lang_main no='330.Tarih'></a></td>
				<td width="20" align="center"><a href="javascript://" onClick="select_all();"><img src="images/c_ok.gif" alt="<cf_get_lang no='6.Hepsini Seç'>" title="<cf_get_lang no='6.Hepsini Seç'>!" border="0"></a></td>
              </cfoutput> 
			 </tr>
            <cfif GET_MAILS.RecordCount>
              <cfoutput query="GET_MAILS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td align="center"><cfif IS_READ EQ 0><img src="/images/cubelock.gif" alt=""><cfelse><img src="/images/cubexport.gif" alt=""></cfif></td>
                  <td align="center"><cfif Len(ATTACHMENT_FILE)><img src="images/attach.gif" border="0" alt=""></cfif></td>
                  <td><a href="##" class="tableyazi" onClick="javascript:window.location.href='#request.self#?fuseaction=correspondence.<cfif attributes.fuseaction contains 'send_mail'>send_mail&show=dsp_mail<cfelse>dsp_mail</cfif>&mail_id=#MAIL_ID#&type=2';">#SUBJECT#</a></td>
                  <td> #MAIL_MODULE# </td>
				  <cfset attributes.mail_id = MAIL_ID>
					<cfscript>
                    	mails = '';
                    	if(len(ListSort(ValueList(MAIL_TO,","),'textnocase','asc',',')))
                      		mails = ListSort(ValueList(MAIL_TO,","),'textnocase','asc',',');
                    	if(len(ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')) and len(mails))
                      		mails="#mails#,#ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')#";
                    	else if(len(ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')))
                      		mails = ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',');
                    /*	if(len(ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')) and len(mails))
                      		mails="#mails#,#ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')#";
                    	else if(len(ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')))
                      		mails = ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',');*/
                    	mails = ReplaceList(mails, chr(10), '');
                    	mails = ReplaceList(mails, chr(13), '');
					</cfscript>
                  <td><cfif len(mails)><a href="javascript://" title="#mails#" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_mail&mails=#mails#','small')"><cfif Len(mails) GT 30>#Left(mails,30)#...<cfelse>#mails#</cfif></a></cfif></td>
                  <td>
                    <cfquery name="GET_MAILFROM" datasource="#dsn#">
                    SELECT
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                      EMPLOYEE_EMAIL , EMPLOYEE_NAME , EMPLOYEE_SURNAME
                      <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                      COMPANY_PARTNER_EMAIL , COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME
                    </cfif>
                    FROM
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                      EMPLOYEE_POSITIONS
                      <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                      COMPANY_PARTNER
                    </cfif>
                    WHERE
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                      EMPLOYEE_ID=#SENDER#
                      <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                      PARTNER_ID=#SENDER#
                    </cfif>
                    </cfquery>
                    <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                      #GET_MAILFROM.EMPLOYEE_NAME# #GET_MAILFROM.EMPLOYEE_SURNAME#
                      <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                      #GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#
                    </cfif>
                  </td>
                  <td> #dateformat(RECORD_DATE,dateformat_style)# </td>
				 <td><input type="checkbox" name="mail_#MAIL_ID#" id="mail_#MAIL_ID#"></td>
                </tr>
              </cfoutput>
			  <tr>
			  	<td colspan="8" style="text-align:right;"><input type="button" value="<cf_get_lang no ='176.Seçili Olanları Sil'>" onClick="javascript:return eraseSelectedMails();">
				<cfsavecontent variable="message"><cf_get_lang no ='181.Klasörü Boşaltıyorsunuz Emin misiniz'></cfsavecontent>
				<input type="button" value="<cf_get_lang no ='177.Kutuyu Boşalt'>" onClick="javascript:if (confirm("#message#")) toplu_sil(); return false;"></td>
			  </tr>
              <cfelse>
              <tr class="color-row">
                <td colspan="8" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
              </tr>
            </cfif>
          </table>
          <cfif attributes.totalrecords gt attributes.maxrows>
              <table cellpadding="0" cellspacing="0" border="0" height="35" width="98%" align="center">
                <tr>
                  <td>
                    <cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="correspondence.send_mail&type=2&keyword=#attributes.keyword#"></td>
                  <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
                </tr>
              </table>
            </cfif>
        </td>
      </tr>
    </table>
  </td>
</tr>
	<form name="sil_form"  target="_blank" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_del_mail&mail_id=all&type=2">
		<input type="hidden" name="ids" id="ids" value="<cfoutput>#ValueList(GET_MAILS.MAIL_ID)#</cfoutput>">
	</form>
</table>
<script type="text/javascript">
document.getElementById('keyword').focus();
function toplu_sil()
{
	windowopen('','small','sil_kutusu');
	sil_form.target = 'sil_kutusu';
	sil_form.submit();
}

function select_all()
{
	<cfoutput query="GET_MAILS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		if(document.getElementById('mail_#MAIL_ID#').checked)
			document.getElementById('mail_#MAIL_ID#').checked = false;
		else	
			document.getElementById('mail_#MAIL_ID#').checked = true;
	</cfoutput>
	
}
<cfoutput query="GET_MAILS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	if(document.getElementById('mail_#MAIL_ID#').checked)
		mail_id_list += "#MAIL_ID#,";
</cfoutput>		
function eraseSelectedMails()
{
	var mail_id_list = "";
	<cfoutput query="GET_MAILS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		if(document.getElementById('mail_#MAIL_ID#').checked)
			mail_id_list += "#MAIL_ID#,";
	</cfoutput>
	
	if(mail_id_list.length != 0)
		mail_id_list = mail_id_list.substring(0,mail_id_list.length - 1);

	if ((mail_id_list.length != 0) && confirm("<cf_get_lang no ='175.Kayıtlı Maili Siliyorsunuz Emin misiniz'>?")) 
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_del_mail&mail_id=all&type=2&ids=' + mail_id_list,'small'); 
	else	
		return false;
		
	return true;
}	
</script>
