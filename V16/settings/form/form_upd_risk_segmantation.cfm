<cfquery name="GET_RISK_SEGMANTATION" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_RISK_SEGMANTATION
	WHERE
		SEGMANTATION_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1200.Risk Segmentasyonu'></td>
	<td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=settings.form_add_risk_segmantation</cfoutput>"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
	<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	  <tr>
	  	<td class="color-row" width="200" valign="top"><cfinclude template="../display/list_risk_segmantation.cfm"></td>
	  	<td class="color-row" valign="top">
		<table>
		<cfform name="upd_risk_segmantation" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_risk_segmantation">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">		  
		  <tr>
			<td width="80"><cf_get_lang no='1358.Segmentasyon'> *</td>    
			<td>
			  <cfsavecontent variable="message"><cf_get_lang no='1359.Segmentasyon Girmelisiniz'> !</cfsavecontent>
			  <cfinput type="text" name="segmentation" maxlength="10" value="#get_risk_segmantation.segmantation#" required="yes" message="#message#" style="width=175px;"></td>
		  </tr>
		  <tr>
			<td width="80"><cf_get_lang no='1437.Min Limit'> *</td>    
			<td>
			  <cfsavecontent variable="message"><cf_get_lang no='1360.Min Limit Girmelisiniz'> !</cfsavecontent>
			  <cfinput type="text" name="min_limit" maxlength="20" value="#get_risk_segmantation.min_limit#" required="yes" message="#message#" style="width=175px;">
			</td>
		  </tr>
		  <tr>
			<td width="80"><cf_get_lang no='1438.Max Limit'> *</td>    
			<td>
			  <cfsavecontent variable="message"><cf_get_lang no='1361.Max Limit Girmelisiniz'> !</cfsavecontent>
			  <cfinput type="text" name="max_limit" maxlength="20" value="#get_risk_segmantation.max_limit#" required="yes" message="#message#" style="width=175px;">
			</td>
		  </tr>
		  <tr>
			<td></td>
			<td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
		  </tr>
		  <tr>
			<td colspan="3"><p><br/>
			  <cfoutput>
			  <cfif len(get_risk_segmantation.record_emp)>
				<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_risk_segmantation.record_emp,0,0)# - #dateformat(get_risk_segmantation.record_date,dateformat_style)#
			  </cfif><br/>
			  <cfif len(get_risk_segmantation.update_emp)>
				<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_risk_segmantation.update_emp,0,0)# - #dateformat(get_risk_segmantation.update_date,dateformat_style)#
			  </cfif>
			  </cfoutput>
			</td>
		  </tr>
	 	</cfform>
		</table>
		</td>
	  </tr>
	</table>
