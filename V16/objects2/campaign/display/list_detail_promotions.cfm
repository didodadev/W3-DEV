<cfinclude template="../../query/get_price_cats_moneys.cfm">
<cfquery name="GET_PROMOTIONS" datasource="#DSN3#">
     SELECT
        PROM_ID,
        PROM_NO,
        PROM_HEAD,
		PROM_DETAIL,
        STARTDATE,
        FINISHDATE
     FROM
        PROMOTIONS
     WHERE
        IS_DETAIL = 1 AND
        <cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
        	PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
        <cfelse>
        	PRICE_CATID = 0 AND
        </cfif>
        PROM_STATUS = 1 AND
        STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
        FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  AND
        IS_INTERNET = 1 		
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:100%"> 
    <tr class="color-border"> 
        <td>  
            <table cellspacing="1" cellpadding="2" border="0" style="width:100%">
                <tr class="color-header" style="height:22px;"> 
               		<td style="width:20px;"></td>
                    <td class="form-title" style="width:20%;"><cf_get_lang_main no ='1408.Başlık'></td>
					<td class="form-title"><cf_get_lang_main no ='217.Açıklama'></td>
                    <td class="form-title" align="center" style="width:90px;"><cf_get_lang_main no ='641.Başlangıç Tarihi'></td>
					<td class="form-title" align="center" style="width:80px;"><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
                </tr>
                <cfoutput query="get_promotions">
                    <tr onClick="gizle_goster(prom_detail#currentrow#);connectAjax('#currentrow#','#get_promotions.prom_id#');gizle_goster(prom_goster#currentrow#);gizle_goster(prom_gizle#currentrow#);" <cfif currentrow mod 2>bgcolor="efefef"<cfelse>bgcolor="ffffff"</cfif> style="height:20px;">
                        <td align="center" id="order_row#currentrow#" style="width:20px;">
                            <img id="prom_goster#currentrow#" src="/images/listele.gif" border="0" title="<cf_get_lang_main no ='1184.Göster'>" alt="<cf_get_lang_main no ='1184.Göster'>" />
                            <img id="prom_gizle#currentrow#" src="/images/listele_down.gif" border="0" title="<cf_get_lang_main no ='1216.Gizle'>" alt="<cf_get_lang_main no ='1216.Gizle'>" style="display:none" />
                        </td>
                        <td >#prom_head#</td>
                        <td>#prom_detail#</td>
						<td align="center">#dateformat(startdate,'dd/mm/yyyy')#</td>
						<td align="center">#dateformat(finishdate,'dd/mm/yyyy')#</td>
                    </tr>
                    <tr id="prom_detail#currentrow#" class="color-row" style="display:none">
                        <td colspan="10">
                        	<div align="left" id="prom_detail_info#currentrow#"></div>
                        </td>
                    </tr>
                </cfoutput>
             </table>
         </td>
     </tr>               
</table>
<script type="text/javascript">
	function connectAjax(crtrow,prom_id)
	{
		var bb = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_dsp_promotion_detail&is_product_code_2=1&prom_id='+ prom_id;
		AjaxPageLoad(bb,'prom_detail_info'+crtrow,1);
	}
</script>
      
