<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.row_id")><cfset attributes.row_id = 1></cfif>
<cfquery name="GET_STOCK_LAST_SPECT_LOCATION_REPORT" datasource="#DSN2#">
	get_stock_last_spect_location_function '#attributes.stock_id#'
</cfquery>
<cfquery name="GET_STOCKS_ALL" dbtype="query">
	SELECT 
		SUM(SALEABLE_STOCK) AS TOPLAM, 
		SPECT_MAIN_ID,
        SPECT_MAIN_NAME,
		PRODUCT_ID
	FROM
		GET_STOCK_LAST_SPECT_LOCATION_REPORT
	WHERE
		1 = 1
		<cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            WHERE
                DEPARTMENT_ID IN (#session.ww.department_ids#)
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            WHERE
                DEPARTMENT_ID IN (#session.pp.department_ids#)
        </cfif>
	GROUP BY
		SPECT_MAIN_ID,
        SPECT_MAIN_NAME,
		PRODUCT_ID
</cfquery>
<cfset body_class = "body">
<cfset body2_class = "body">
<cfset table_class="pod_box">
<cfset tr_class="header">
<cfset td_class="txtboldblue">
<table cellspacing="1" cellpadding="2" border="0" align="center" class="<cfoutput>#table_class#</cfoutput>" style="width:300px;">
	<tr class="<cfoutput>#tr_class#</cfoutput>" style="height:22px;">
		<td colspan="2" class="<cfoutput>#td_class#</cfoutput>">&nbsp;
	        <div style="float:right;margin-top:-15;"><a href="javascript://" onClick="gizle(show_stock_spect_detail_row<cfoutput>#attributes.row_id#</cfoutput>);"><img style="cursor:pointer;" src="images/pod_close.gif" border="0"></a></div>
        </td>
	</tr>
    <tr class="<cfoutput>#body2_class#</cfoutput>">
        <td class="<cfoutput>#td_class#</cfoutput>" style="width:45px;"><cf_get_lang_main no='235.Spec'></td>
        <td class="<cfoutput>#td_class#</cfoutput>" align="center" style="width:90px;"><cf_get_lang_main no='223.Miktar'>-<cf_get_lang_main no='224.Birim'></td>
    </tr>
	<cfoutput query="get_stocks_all">
		<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='#body_class#';" class="#body_class#" style="height:20px;">
			<td>#spect_main_id#-#spect_main_name#</td>
			<td style="text-align:right;">
				<cfif attributes.stock_limit neq 0>
					<cfif toplam lte 0>0
					<cfelseif toplam lte 20>#toplam#
					<cfelseif toplam gt 20>20+
					</cfif>
				<cfelse>
					<cfif toplam lte 0>0
					<cfelseif toplam lte 20>#toplam#
					<cfelseif toplam gt 20>20+
					</cfif>
				</cfif>
			</td>
		</tr>
	</cfoutput>
	<cfif not get_stocks_all.recordcount>
		<tr class="color-row" style="height:22px;">
			<td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		</tr>
	</cfif>
</table>
<cfabort>
