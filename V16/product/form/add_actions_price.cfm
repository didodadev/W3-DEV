<cfsetting showdebugoutput="no">
<cfset bugun = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
<cfquery name="get_product" datasource="#DSN3#">
	SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID=#attributes.pid#
</cfquery>
<cfquery name="GET_CATALOG_PROMOTION" datasource="#DSN3#">
	SELECT
		DISTINCT
		CP.STARTDATE,
		CP.FINISHDATE,
		CP.IS_APPLIED,
		CP.CATALOG_HEAD
	FROM
		CATALOG_PROMOTION_PRODUCTS AS CPP,
		CATALOG_PROMOTION AS CP
	WHERE
		CP.CATALOG_ID = CPP.CATALOG_ID AND
		CPP.PRODUCT_ID = #attributes.PID# AND
		((CP.STARTDATE <= #bugun# AND CP.FINISHDATE >= #bugun#) OR (CP.STARTDATE > #bugun#))
	ORDER BY
		CP.STARTDATE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='58988.Aksiyonlar'></cfsavecontent>
<cf_popup_box title="#message# : #get_product.PRODUCT_NAME#">
<cfif get_catalog_promotion.recordcount>
		<cf_medium_list_search>
			<cf_medium_list>
				<table>
					<cfoutput query="get_catalog_promotion">
                        <tr>
                            <td height="20">
                                <cf_get_lang dictionary_id='37210.Aksiyon'>: <font color="red">#catalog_head# #DateFormat(startdate,dateformat_style)# - #DateFormat(finishdate,dateformat_style)# <cfif is_applied eq 1>(<cf_get_lang dictionary_id='37357.Fiyat oluşturuldu'> !)</cfif></font>
                            </td>
                        </tr>
                     </cfoutput>
                </table>
			</cf_medium_list>
		</cf_medium_list_search>
<cfelse>
	&nbsp;<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
</cfif>
</cf_popup_box>
