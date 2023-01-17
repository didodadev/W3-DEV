<cfsetting showdebugoutput="no">

<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="get_internaldemand" datasource="#DSN3#">
	SELECT
		*
	FROM 
		INTERNALDEMAND 
	WHERE	
		INTERNAL_ID > 0 
        <cfif not session.pda.admin>
        AND INTERNALDEMAND.FROM_POSITION_CODE = #session.pda.userid#  
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
		AND RECORD_DATE >= #attributes.start_date#
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
		AND RECORD_DATE <= #attributes.finish_date#
		</cfif>
	ORDER BY
		 INTERNALDEMAND.RECORD_DATE DESC, INTERNAL_ID DESC
</cfquery> 
<cf_box title="İç Talepler" body_style="overflow-y:scroll;height:100px;">

<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr height="22" class="color-header">		
			<td class="form-title">Kayıt Tarihi</td>
			<td class="form-title">Başlık</td>
		</tr>
		<cfif get_internaldemand.recordcount>
			<cfoutput query="get_internaldemand">		
				<tr height="20"  class="color-row"><!--- onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" --->
					<td>
						<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_internaldemand&internal_id=#internal_id#" class="tableyazi">#dateformat(record_date,'dd/mm/yyyy')#</a>
					</td>
					<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_internaldemand&internal_id=#internal_id#" class="tableyazi">#subject#</a></td>
				</tr>		
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td colspan="2" height="20">Kayıt Bulunamadı !</td>
			</tr>
		</cfif>
	  </table>
	</td>
  </tr>
</table>
</cf_box>

