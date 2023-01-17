<cfquery name="GET_STOCK_FIS" datasource="#DSN2#">
	SELECT WORK_ID,FIS_ID,FIS_NUMBER FROM STOCK_FIS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_stock_fis.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table class="color-border" cellpadding="2" cellspacing="1" align="center" style="width:98%">
	<tr class="color-header"  style="height:35px;">
		<td class="form-title">Malzeme Kullanım Fişleri</td>
        <td style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_add_stock_receipt&work_id=<cfoutput>#attributes.work_id#</cfoutput><cfif isDefined('attributes.id') and len(attributes.id)>&project_id=<cfoutput>#attributes.id#</cfoutput></cfif>','list');" class="txtsubmenu"><img src="/images/pod_add.gif" border="0" align="absmiddle" class="form_icon"></a></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<table cellpadding="2" cellspacing="1" border="0" style="width:100%">
				<!---<tr class="color-header">
					<td class="form-title" style="width:30px;">No</td>
					<td class="form-title">Fiş Numarası</td>
				</tr>--->
				<cfif get_stock_fis.recordcount>
					<cfoutput query="get_stock_fis">
                        <tr class="color-row">
                            <td>#currentrow# -</td>
                            <td><a href="#request.self#?fuseaction=objects2.popup_upd_stock_receipt&work_id=#id#&fis_id=#fis_id#&project_id=#attributes.id#" class="tableyazi">#fis_number#</a></td>
                        </tr>
                    </cfoutput>
               	<cfelse>
					<tr class="color-row">
						<td colspan="4"><cfif isDefined('attributes.is_form_submitted')>Filtre Ediniz!<cfelse>Kayıt Bulunamadı!</cfif></td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
<br/>
<!---<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_string = ''>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:30px;">
    	<tr>
      		<td> 
            	<cf_pages page="#attributes.page#"
			  		maxrows="#attributes.maxrows#"
			  		totalrecords="#attributes.totalrecords#"
			  		startrow="#attributes.startrow#"
			  		adres="#attributes.fuseaction##url_string#"> </td>
     		<td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_stock_fis.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    	</tr>
  	</table>
</cfif>--->
