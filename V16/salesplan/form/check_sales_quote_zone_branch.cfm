<cfparam name="attributes.quote_year" default="#session.ep.period_year#">
<cfif not isdefined("attributes.is_submit")>
<cfquery name="GET_SALES_ZONES_B" datasource="#DSN#">
	SELECT 
		B.BRANCH_NAME,
		SZ.SZ_NAME,
		SZ.SZ_ID,
		SZ.RESPONSIBLE_BRANCH_ID 
	FROM
		BRANCH B,
		SALES_ZONES SZ
	WHERE
		SZ.RESPONSIBLE_BRANCH_ID = B.BRANCH_ID AND
		B.BRANCH_ID IN 
		(
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = #session.ep.position_code#
		)
	ORDER BY
		SZ.SZ_NAME
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" width="100%" align="center" height="100%">
  <tr class="color-border">
    <td>
	<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
	<cfform name="form_basket" action="" method="post">
	<input type="hidden" name="is_submit" id="is_submit" value="1">
	  <tr class="color-list" height="35">
		<td class="headbold"><cf_get_lang no='60.Şube Bazında Satış Hedefi'></td>
	  </tr>
	  <tr class="color-row">
		<td valign="top">
		<table>
		  <tr>
		  	<td><cf_get_lang_main no='247.Satış Bölgesi'> / <cf_get_lang_main no='41.Şube'></td>
		    <td>
			  <select name="branch_id" id="branch_id">
			  <cfoutput query="get_sales_zones_b">
				<option value="#sz_id#-#responsible_branch_id#">#sz_name# / #branch_name#</option>
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
		  <tr>
		  	<td height="35" colspan="4" align="right" style="text-align:right;"> <cf_workcube_buttons is_upd='0' insert_info='Hedef Ver' insert_alert=''> </td>
		  </tr>
		</table>
		</td>
	  </tr>
	</cfform>
	</table>
    </td>
  </tr>
</table>
<cfelse>
	<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#DSN#">
		SELECT 
			SQ.SALES_QUOTE_ID 
		FROM 
			SALES_QUOTES_GROUP SQ,
			SALES_QUOTES_GROUP_ROWS SQR 
		WHERE 
			SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID AND
			SQ.QUOTE_TYPE = 1 AND
			SQR.BRANCH_ID = #listgetat(attributes.branch_id,2,'-')# AND
			SQ.QUOTE_YEAR = #attributes.quote_year# AND
			SQ.SALES_ZONE_ID = #listgetat(attributes.branch_id,1,'-')#
	</cfquery>
	<cfif get_sales_quote_zone.recordcount>
	  <cflocation url="#request.self#?fuseaction=salesplan.popup_upd_sales_quote_zone_branch&SALES_QUOTE_ID=#get_sales_quote_zone.sales_quate_id#&branch_id=#listgetat(attributes.branch_id,2,'-')#" addtoken="no">
	<cfelse>
	  <cflocation url="#request.self#?fuseaction=salesplan.popup_add_sales_quote_zone_branch&SALES_ZONE_ID=#listgetat(attributes.branch_id,1,'-')#&branch_id=#listgetat(attributes.branch_id,2,'-')#&quote_year=#attributes.quote_year#" addtoken="no">
	</cfif>
</cfif>
