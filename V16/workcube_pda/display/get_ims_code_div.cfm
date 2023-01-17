<cf_get_lang_set module_name="objects">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_IMS_CODE" datasource="#DSN#">
	SELECT 
		IMS_CODE_ID,
		IMS_CODE,
		IMS_CODE_NAME
	FROM 
		SETUP_IMS_CODE 
	WHERE
		IMS_CODE_ID IS NOT NULL 
		<cfif isdefined('session.pda.member_ims_code_name_like') and len(session.pda.member_ims_code_name_like)>
			AND IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pda.member_ims_code_name_like#">
		</cfif>
		<cfif len(attributes.keyword)>
			AND 
			(
				IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
				IMS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
	ORDER BY 
		IMS_CODE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang no='952.IMS Bölge Kodları'></cfsavecontent>
<cf_box title="<cfoutput>#message#</cfoutput>" body_style="overflow-y:scroll;height:100px;">
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
  	<tr class="color-border">
    	<td>
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
				<tr class="color-header" style="height:22px;">		
					<td class="form-title"><cf_get_lang_main no='75.No'></td>
					<td class="form-title"><cf_get_lang no='953.IMS Kod Numarası'></td>
					<td class="form-title"><cf_get_lang no='954.IMS Bölge Adı'></td>
				</tr>
				<cfif get_ims_code.recordcount>
					<cfoutput query="get_ims_code">		
						<tr onMouseOver="this.bgColor='#colorlist#';" onMouseOut="this.bgColor='#colorrow#';" bgcolor="#colorrow#" style="height:20px;">
							<td style="width:20px;">#currentrow#</td>
							<td><a href="javascript://" class="tableyazi"  onClick="add_ims_code_div('#ims_code#','#ims_code_id#','#ims_code_name#')">#ims_code#</a></td>
							<td>#ims_code_name#</td>
						</tr>		
					</cfoutput>
          		<cfelse>
			  		<tr class="color-row" style="height:20px;">
						<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
			  		</tr>
        		</cfif>
      		</table>
    	</td>
  	</tr>
</table>
</cf_box>
<cf_get_lang_set module_name="objects"><!--- sayfanin en ustunde acilisi var --->
