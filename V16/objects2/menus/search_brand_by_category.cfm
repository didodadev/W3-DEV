<cfparam name="attributes.keyword" default="">
<cfquery name="GET_UST_GRUPS" datasource="#DSN1#">
	SELECT 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.HIERARCHY,
		PC.LIST_ORDER_NO
	FROM 
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PC.IS_PUBLIC = 1 AND
		PC.HIERARCHY NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.%">
	ORDER BY 
		PC.LIST_ORDER_NO,PC.HIERARCHY
</cfquery>

<form name="katalog" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.view_product_list" method="post">
<table>
	<tr class="color-row">
		<td style="vertical-align:top;">
			<select name="anagrup" id="anagrup" style="width:197px;height:110px;" size="8" onChange="showaltgroups()">
				<option value=""><cf_get_lang no='1038.Tüm Gruplar'></option>
				<cfoutput query="get_ust_grups">
					<option value="#product_catid#">#product_cat#</option>
				</cfoutput>
			</select>
		</td>
		<td style="vertical-align:top;">
        	<div id="altgroups_place">
            	<select name="altgrup" style="width:197px;height:110px;" size="8" onChange="showaltbrands()">
                	<option value=""><cf_get_lang no='1040.Tüm Alt Gruplar'></option>
                </select>
            </div>
        </td>
		<td>
        	<div id="brand_place">
            	<select name="marka" style="width:197px;height:110px;" size="8">
                	<option value=""><cf_get_lang no='1039.Tüm Markalar'></option>
                </select>
            </div>
        </td>
	</tr>
</table>
</form>

<script type="text/javascript">
	function showaltgroups()
	{
		var tmp = document.getElementById('anagrup').value;
		
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altgroups&anagrup_id=";
		send_address +=tmp;
		AjaxPageLoad(send_address,'altgroups_place');
		
		var tmp = document.getElementById('anagrup').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altbrands&altgrup_id=";
		send_address +=tmp;
		AjaxPageLoad(send_address,'brand_place');
	}
	
	function showaltbrands()
	{
		var tmp = document.getElementById('altgrup').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altbrands&altgrup_id=";
		send_address +=tmp;
		AjaxPageLoad(send_address,'brand_place');
	}
</script>
