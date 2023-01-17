<cfquery name="GET_SHIP_METHOD_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		OFFER.SHIP_METHOD,
		ORDERS.SHIP_METHOD
	FROM
		OFFER,
		ORDERS
	WHERE
		OFFER.SHIP_METHOD = #attributes.ship_method_id# OR ORDERS.SHIP_METHOD = #attributes.ship_method_id#
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT
		MONEY,
		RATE2,
		RATE1
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
	ORDER BY
		MONEY_ID
</cfquery>
<cfquery name="SHIP_METHOD" datasource="#dsn#">
	SELECT
		*
	FROM
		SHIP_METHOD
	WHERE
		SHIP_METHOD_ID = #attributes.ship_method_id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='657.Sevk Yöntemi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_ship_method"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
	<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	  <tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_ship_method.cfm"></td>
		<td>
		<table border="0">
        <cfform name="ship_method" method="post" action="#request.self#?fuseaction=settings.emptypopup_ship_method_upd">
		<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfoutput>#attributes.ship_method_id#</cfoutput>">
		  <tr>
			<td width="100"><cf_get_lang_main no='1703.Sevk Yöntemi'> *</td>
			<td>
			  <cfsavecontent variable="message"><cf_get_lang no='301.Metod Adı girmelisiniz'></cfsavecontent>
			  <cfinput type="text" name="ship_method" value="#ship_method.ship_method#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
			</td>
			<td><cf_language_info 
					table_name="SHIP_METHOD" 
					column_name="SHIP_METHOD" 
					column_id_value="#attributes.ship_method_ID#" 
					maxlength="500" 
					datasource="#dsn#" 
					column_id="SHIP_METHOD_ID" 
					control_type="0"></td>
       	  </tr>
       	  <tr>
         	<td><cf_get_lang_main no='78.Süre (Gün)'></td>
           	<td><cfinput type="text" name="ship_day" value="#ship_method.ship_day#" maxlength="3" onKeyUp="isNumber(this);" style="width:150px;"></td>
			<td></td>
		  </tr>
		  <tr>
          	<td><cf_get_lang no='543.Süre (Saat)'></td>
           	<td><cfinput type="text" name="ship_hour" value="#ship_method.ship_hour#" maxlength="3" style="width:150px;"></td>
			<td></td>
		  </tr>
		  <tr>
		  <tr>
		  	<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
		  	<td><textarea name="calculate" id="calculate" style="width:150px;height:60px;"><cfoutput>#ship_method.calculate#</cfoutput></textarea></td>
			<td valign="top"><cf_language_info 
					table_name="SHIP_METHOD" 
					column_name="CALCULATE" 
					column_id_value="#attributes.ship_method_ID#" 
					maxlength="500" 
					datasource="#dsn#" 
					column_id="SHIP_METHOD_ID" 
					control_type="0">
			</td> 
		  </tr>
		  <tr>
			<td></td>
			<td><input type="checkbox" name="is_opposite" id="is_opposite" <cfif ship_method.is_opposite eq 1>checked</cfif>>&nbsp;<cf_get_lang no='1024.Karşı Ödemeli'></td>
			<td></td>
		  </tr>
		  <tr>
			<td></td>
			<td><input type="checkbox" name="is_internet" id="is_internet" <cfif ship_method.is_internet eq 1>checked</cfif>>&nbsp;<cf_get_lang no='1025.Internet de Gözüksün'>.</td>
			<td></td>
		  </tr>		  
		  <tr>
			<td></td>
		  	<td>
		  	  <cfif get_ship_method_id.recordcount>
		   		<cf_workcube_buttons is_upd='1' is_delete='0'><!--- add_function='kontrol()' --->
		  	  <cfelse>
		   		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_ship_method_del&ship_method_id=#attributes.ship_method_id#'>
		  	  </cfif>
		  	</td>
			<td></td>
		  </tr>
		  <tr>
		 	<td colspan="3">
			  <cfoutput>
			  <cfif len(ship_method.record_emp)>
				<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(ship_method.record_emp,0,0)# - #dateformat(ship_method.record_date,dateformat_style)#
			  </cfif><br/>
			  <cfif len(ship_method.update_emp)>
				<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(ship_method.update_emp,0,0)# - #dateformat(ship_method.update_date,dateformat_style)#
			  </cfif>
			  </cfoutput>
			</td>
		  </tr>
		  </cfform>		  
		</table>
		</td>
	  </tr>
	</table>

