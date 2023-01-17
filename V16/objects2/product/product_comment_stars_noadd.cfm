<cfquery name="GET_PRODUCT_COMMENT_" datasource="#DSN3#">
	SELECT 
		COUNT(PRODUCT_COMMENT_ID) AS YORUM_SAYISI,
		SUM(PRODUCT_COMMENT_POINT) AS YORUM_PUANI
	FROM
		PRODUCT_COMMENT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
		STAGE_ID = -2
</cfquery>
<cfoutput>
	<cfif not get_product_comment_.recordcount or get_product_comment_.yorum_sayisi eq 0>
	<cfelse>
		<cfset oran_ = get_product_comment_.yorum_puani / get_product_comment_.yorum_sayisi>
		<cfif listlen(oran_,'.') eq 2>
			<cfloop from="1" to="#ceiling(oran_)-1#" index="cc">
				<img src="../objects2/image/point_full.gif" border="0" align="absmiddle" />
			</cfloop>
				<img src="../objects2/image/point_half.gif" border="0" align="absmiddle" />
			<cfloop from="1" to="#5 - ceiling(oran_)#" index="cc">
				<img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
			</cfloop>
		<cfelse>
			<cfloop from="1" to="#oran_#" index="cc">
				<img src="../objects2/image/point_full.gif" border="0" align="absmiddle" />
			</cfloop>
			<cfloop from="1" to="#5 - oran_#" index="cc">
				<img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
			</cfloop>
		</cfif>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_view_all_product_comment&product_id=#product_id#&is_product_comment=#attributes.is_product_comment#','large');" class="tableyazi">&nbsp;<cf_get_lang no ='360.Yorum Oku'> : #get_product_comment_.yorum_sayisi#</a>
	</cfif>
</cfoutput>
