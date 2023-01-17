<cfquery name="GET_HELP" datasource="#dsn#">
		SELECT
			H.HELP_ID,
			H.HELP_HEAD,
			H.HELP_TOPIC,
			H.RECORD_DATE AS RECORD_DATE,
			H.RECORD_MEMBER,
			H.HELP_FUSEACTION,
			H.HELP_CIRCUIT,
			H.IS_STANDARD
		FROM 
			HELP_DESK H
		WHERE 
			H.RECORD_ID = E.EMPLOYEE_ID 
			<cfif isDefined("attributes.keyword") and (len(attributes.keyword) eq 1)>
				AND H.HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			<cfelseif isDefined("attributes.keyword") and (len(attributes.keyword) gt 1)>
				AND 
				(
				H.HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
				H.HELP_TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
				H.HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
</cfquery>
<table width="98%" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-list">
		<td class="formbold" colspan="4" height="25">&nbsp;<cf_get_lang no='366.Kurum İçi Geliştirilmiş Yardımlar'></td>
	</tr>
	<tr>
		<td colspan="4" class="color-row">
			<table>
				<!-- Filtre -->
				<cfform name="help_search" action="#request.self#?fuseaction=objects2.popup_welcome" method="post">
					<tr>
						<td>
							<cf_get_lang_main no='48.Filtre'>
							<cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#">
						</td>
						<td valign="middle">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"onkeyup="isNumber(this);" onblur="isNumber(this);">
							<cf_wrk_search_button>
						</td>
					</tr>
					</cfform>
				</table>
			</td>
	</tr>
    <tr class="color-header" height="22">
		<td class="form-title" width="50"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
		<td class="form-title" width="125"><cf_get_lang_main no='487.Kaydeden'></td>
		<td class="form-title" width="90"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
	</tr>
		<cfif get_help.recordcount>
          <cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#help_id#</td>
              <td><a href="#request.self#?fuseaction=help.popup_view_help&help_id=#get_help.help_id#" class="tableyazi">#help_head#</a></td>
              <td>#name# #surname#</td>
              <td>#dateformat(get_help.record_date,'dd/mm/yyyy')#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="6"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
          </tr>
        </cfif>
      </table>
