<cfquery name="GET_ORDER_PLUSES" datasource="#dsn3#">
	SELECT
		*
	FROM
		ORDER_PLUS
	WHERE
		ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" height="25" align="center">
  <tr>
    <td class="formbold">Takipler</td>
  </tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
 <cfif get_order_pluses.recordcount>
  <cfoutput query="get_order_pluses">
 <tr class="color-list" height="22">
 	<td class="txtboldblue"><cfif len(plus_subject)>#plus_subject#<cfelse><cf_get_lang_main no='68.Başlık'></cfif></td>
 </tr>
  <tr class="color-row"> 
	<td height="50">
	<b><cf_get_lang_main no='330.Tarih'>:</b> #dateformat(plus_date,'dd/mm/yyyy')#
	<cfif len(employee_id)>
		<b>&nbsp;&nbsp;<cf_get_lang_main no='157.Görevli'>:</b> 
		#get_emp_info(employee_id,0,0)#
	</cfif>
	<cfif len(commethod_id)>
	  &nbsp;&nbsp; <b><cf_get_lang_main no='731.İletişim'>:</b> 
	<cfquery name="GET_COMMETHOD" datasource="#DSN#">
		SELECT 
			* 
		FROM
			SETUP_COMMETHOD
		WHERE
			COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#commethod_id#">
	</cfquery>
	#get_commethod.commethod#<br/>
	</cfif>
	  <br/><br/>
	#plus_content#</td>
  </tr>
  </cfoutput>
<cfelse>
 <tr class="color-row"> 
	<td height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
</tr>
 </cfif>
</table>
