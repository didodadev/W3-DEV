<!--- <cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
	SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery> --->
 <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0" height="100%">
  <tr>
    <td height="35" class="headbold"><!--- Müşteri : <cfoutput>#get_company_name.fullname#</cfoutput> ---></td>
  </tr>
  <tr class="color-border">
    <td>
    <table align="center" width="100%" cellpadding="2" cellspacing="1" height="100%">
    <tr class="color-row">
	  <td width="155" rowspan="2" valign="top">
	  <cfoutput>
	  <table cellpadding="1" cellspacing="1" border="0" width="100%">      
        <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td width="180"><a href="#request.self#?fuseaction=member.popup_general_info&cpid=#attributes.cpid#&iframe=1" target="member_frame" class="tableyazi"><cf_get_lang dictionary_id="57980.Genel Bilgiler"></td>
        </tr>
	    <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td width="180"><cf_get_lang dictionary_id="48396.Ruhsat Bilgisi"></td>
        </tr>
	    <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td><cf_get_lang dictionary_id="57473.Tarihçe"></td>
        </tr>
	    <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td><cf_get_lang dictionary_id="48003.KM Kontrol"></td>
        </tr>
	    <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td><!--- <a href="#request.self#?fuseaction=member.popup_company_operation_info&cpid=#attributes.cpid#&iframe=1" target="member_frame" class="tableyazi"> ---><cf_get_lang dictionary_id="59853.Muayene Bilgileri"><!--- </a> ---></td>
        </tr>
	    <tr class="color-list">
          <td style="text-align:right;"><img src="/images/tree_1.gif"></td>
          <td><cf_get_lang dictionary_id="56134.Kira"></td>
        </tr>
      </table>
	</cfoutput>		
	<td height="100%" align="center" valign="top">
	<cfoutput>
	  <iframe  scrolling="auto" width="100%" height="100%" frameborder="0" name="member_frame" id="member_frame" src="#request.self#?fuseaction=member.popup_general_info&cpid=#attributes.cpid#&iframe=1"></iframe>
	</cfoutput>	</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
