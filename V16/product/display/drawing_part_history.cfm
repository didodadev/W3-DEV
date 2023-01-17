<cfquery name="getolddpl" datasource="#dsn3#">
	SELECT 
		(SELECT TOP 1 DPL_ID FROM DRAWING_PART DPO WHERE DPO.ASSET_ID = A.RELATED_ASSET_ID) AS OLD_DPL_ID,
		(SELECT TOP 1 DPL_NO FROM DRAWING_PART DPO WHERE DPO.ASSET_ID = A.RELATED_ASSET_ID) AS OLD_DPL_NO
	FROM 
		DRAWING_PART DP,
		#dsn_alias#.ASSET A
	WHERE 
		A.ASSET_ID = DP.ASSET_ID AND
		DP.DPL_ID = #attributes.dpl_id#
</cfquery>
<cfparam name="attributes.old_dpl_id" default="#getolddpl.old_dpl_id#">
<cfparam name="attributes.old_dpl_no" default="#getolddpl.old_dpl_no#">
<cfif len(attributes.old_dpl_id)>
	<cfquery name="getDPLRow" datasource="#DSN3#">
		SELECT
			ISNULL((SELECT QUANTITY FROM DRAWING_PART WHERE DPL_ID = #attributes.old_dpl_id#),0) AS MAIN_QUANTITY_OLD,
			ISNULL((SELECT QUANTITY FROM DRAWING_PART WHERE DPL_ID = #attributes.dpl_id#),0) AS MAIN_QUANTITY,
			DPR1.PRODUCT_ID,
			CASE WHEN 
				DPR1.DPL_ID = #attributes.old_dpl_id#
			THEN
				DPR1.QUANTITY
			ELSE
			CASE WHEN DPR1.DPL_ID = #attributes.old_dpl_id# THEN
				ISNULL((SELECT DPR2.QUANTITY FROM DRAWING_PART_ROW DPR2 WHERE DPR2.DPL_ID = #attributes.dpl_id# AND DPR1.PRODUCT_ID = DPR2.PRODUCT_ID),0)
			ELSE 
				0 END
			END AS ESKI,
			CASE WHEN DPR1.DPL_ID = #attributes.old_dpl_id# THEN
				ISNULL((SELECT DPR2.QUANTITY FROM DRAWING_PART_ROW DPR2 WHERE DPR2.DPL_ID = #attributes.dpl_id# AND DPR1.PRODUCT_ID = DPR2.PRODUCT_ID),0)
			ELSE 
				DPR1.QUANTITY END AS YENI
		FROM
			DRAWING_PART_ROW DPR1
		WHERE
			(
			DPR1.DPL_ID = #attributes.dpl_id# AND
			DPR1.PRODUCT_ID NOT IN (SELECT DPR2.PRODUCT_ID FROM DRAWING_PART_ROW DPR2 WHERE DPR2.DPL_ID = #attributes.old_dpl_id#)
			) OR
			DPR1.DPL_ID = #attributes.old_dpl_id#
	</cfquery>
<cfelse>
	<cfset getDPLRow.recordcount = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37133.DPL Karşılaştırma'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<cfform name="search_dpl" action="#request.self#?fuseaction=product.popup_drawing_part_history&dpl_id=#attributes.dpl_id#" method="post">
			<table>
					<tr>
						<td><cf_get_lang dictionary_id='37246.Eski DPL'> 
							<input type="hidden" name="old_dpl_id" id="old_dpl_id" value="<cfoutput>#attributes.old_dpl_id#</cfoutput>"> 
							<input type="text" name="old_dpl_no" id="old_dpl_no" value="<cfoutput>#attributes.old_dpl_no#</cfoutput>" style="width:130px;">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_drawing_parts&field_id=search_dpl.old_dpl_id&field_name=search_dpl.old_dpl_no'</cfoutput>,'medium');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</td>
						<td>
							<cf_wrk_search_button>
						</td>
					</tr>
			</table>
		</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='37247.Malzeme'></th>
			<th><cf_get_lang dictionary_id='58674.Yeni'> <cf_get_lang dictionary_id='37017.DPL'></th>
			<th><cf_get_lang dictionary_id='37246.Eski DPL'></th>
			<th><cf_get_lang dictionary_id='58583.Fark'> </th>
		</tr>
	</thead>
	<tbody>
		<cfif getDPLRow.recordcount>
		  <cfoutput query="getDPLRow" group="product_id">
			<tr>
				<td>#currentrow#</td>
				<td>#get_product_name(product_id)#</td>
				<td><cfset q2 = (MAIN_QUANTITY*YENI)>
					#q2#
				</td>
				<td><cfset q1 = MAIN_QUANTITY_OLD*ESKI>
					#q1#
				</td>
				<td>#q2-q1#</td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr>
				<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>	  
	</tbody>
</cf_medium_list>
