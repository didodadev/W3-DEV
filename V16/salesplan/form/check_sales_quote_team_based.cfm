<cfparam name="attributes.quote_year" default= #session.ep.period_year#>
<cfif not isdefined("attributes.is_submit")>
<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
	SELECT 
		SZ.SZ_NAME,
		SZ.SZ_ID,
		SZ.RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM
		SALES_ZONES SZ,
		BRANCH B
	WHERE
		B.BRANCH_ID = SZ.RESPONSIBLE_BRANCH_ID
		<cfif isdefined("attributes.sales_zone_id")>
		AND	SZ.SZ_ID = #attributes.sales_zone_id#
		</cfif>
		AND
		B.BRANCH_ID IN 
		(
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = #session.ep.position_code#
		)
	ORDER BY SZ.SZ_NAME
</cfquery>
<cf_box title="#getLang('salesplan',104)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--Takım Bazında Satış Hedefi-->
  <cfform name="form_basket" action="" method="post">
      <input type="hidden" name="is_submit" id="is_submit" value="1">
      <table>
        <tr>
          <td><cf_get_lang_main no='247.Satış Bölgesi'> / <cf_get_lang_main no='41.Şube'></td>
          <td>
            <select name="team_id" id="team_id">
              <cfoutput query="GET_SALES_ZONES_TEAM">
                <option value="#SZ_ID#-#RESPONSIBLE_BRANCH_ID#">#sz_name# / #BRANCH_NAME#</option>
              </cfoutput>
            </select>
          </td>
        </tr>
        <tr>
          <td><cf_get_lang_main no='1060.Dönem'></td>
          <td>
            <select name="quote_year" id="quote_year" style="width:65px;">
              <cfoutput>
                <cfloop from="#session.ep.period_year#" to="2020" index="i">
                  <option value="#i#" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
                </cfloop>
              </cfoutput>
            </select>
          </td>
        </tr>
      </table>
     <cf_box_footer><cf_workcube_buttons is_upd='0' insert_info='Hedef Ver' insert_alert=''></cf_box_footer>
  </cfform>
</cf_box>
<cfelse>
<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#dsn#">
SELECT SQ.SALES_QUOTE_ID FROM SALES_QUOTES_GROUP SQ WHERE QUOTE_TYPE = 2 AND
SQ.QUOTE_YEAR = #attributes.quote_year# AND	SQ.SALES_ZONE_ID = #listgetat(attributes.team_id,1,'-')#
</cfquery>
<cfif GET_SALES_QUOTE_ZONE.recordcount>
  <cflocation url="#request.self#?fuseaction=salesplan.popup_upd_sales_quote_team_based&SALES_QUOTE_ID=#GET_SALES_QUOTE_ZONE.SALES_QUOTE_ID#&branch_id=#listgetat(attributes.team_id,2,'-')#" addtoken="no">
  <cfelse>
  <cflocation url="#request.self#?fuseaction=salesplan.popup_add_sales_quote_team_based&SALES_ZONE_ID=#listgetat(attributes.team_id,1,'-')#&branch_id=#listgetat(attributes.team_id,2,'-')#&quote_year=#attributes.quote_year#" addtoken="no">
</cfif>
</cfif>

