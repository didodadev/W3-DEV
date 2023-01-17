<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_form_submit" default="">
<cfparam name="attributes.finishdate" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.startdate" default="#dateformat(date_add('d',-1,now()),'dd/mm/yyyy')#">
<cfparam name="attributes.department_id" default="">
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
<tr>
	<td class="headbold" height="35"><cf_get_lang no='615.Aylık Hakediş Raporu'></td>
</tr>
<tr class="color-border" id="search">
<td colspan="2">
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<!-- sil -->
		<tr class="color-row" height="22"> 
		<td colspan="20">
			<table>
			<cfform name="rapor" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
				<tr>
				   <input type="hidden" value="1" name="is_form_submit" id="is_form_submit">
					<td valign="top"><cf_get_lang_main no='330.Tarih'></td>
					<td>
					 </td>
				 <td valign="top">
					<cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="eurodate" message="Başlangıç Tarihi !" maxlength="10" required="yes">
					<cf_wrk_date_image date_field="startdate">
				 </td>
				 <td valign="top">
					<cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="eurodate" message="Bitiş Tarihi !" maxlength="10" required="yes">
					<cf_wrk_date_image date_field="finishdate">
				 </td>
				 <td valign="top"><input type="submit" value="Kaydet"></td>
			</tr>
			</cfform>
		  </table>
		</td>
	</tr>
	
</table>
</td>	
</tr>
</table>
<cf_date tarih = "attributes.startdate">
<cf_date tarih = "attributes.finishdate">
<cfif len(attributes.is_form_submit)>
	<cfquery name="GET_HAKEDIS" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			SERVICE,
			SERVICE_OPERATION
		WHERE 
			SERVICE.SERVICE_ID=SERVICE_OPERATION.SERVICE_ID AND
			SERVICE.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
				AND FINISH_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
			</cfif>
		ORDER BY 
			SERVICE.FINISH_DATE DESC		
	</cfquery>
			<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
				<tr class="color-header" height="22">
					<td class="form-title"><cf_get_lang_main no='330.Tarih'></td>
					<td class="form-title"><cf_get_lang no='616.Servis Kodu'></td>
					<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
					<td class="form-title"><cf_get_lang_main no='670.Adet'></td>
					<td class="form-title"><cf_get_lang_main no='672.Fiyat'></td>
					<td class="form-title"><cf_get_lang_main no='80.Toplam'></td>
				</tr>
				<cfset geneltoplam=0>
				 <cfoutput query="GET_HAKEDIS">
						<tr height="20" class="color-row">
							<td>#FINISH_DATE#</td>
							<td>#SERVICE_ID#</td>
							<td>#PRODUCT_NAME#</td>   					
							<td>#AMOUNT#</td>
							<td>#PRICE#</td>   					
							<td>#TOTAL_PRICE#</td>
						</tr>
				</cfoutput>
			</table>
</cfif>

