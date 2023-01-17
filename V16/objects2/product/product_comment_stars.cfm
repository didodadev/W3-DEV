<cfquery name="GET_PRODUCT_COMMENT_" datasource="#DSN3#">
	SELECT 
		COUNT(PRODUCT_COMMENT_ID) AS YORUM_SAYISI,
		SUM(PRODUCT_COMMENT_POINT) AS YORUM_PUANI
	FROM
		PRODUCT_COMMENT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		STAGE_ID = -2
</cfquery>
<cfoutput>
<cfif not get_product_comment_.recordcount or get_product_comment_.yorum_sayisi eq 0>
	<cfif isdefined('attributes.is_product_comment') and (attributes.is_product_comment eq 1 or (attributes.is_product_comment eq 2 and isdefined('session_base.userid')))>
		<cfloop from="1" to="5" index="sss">
			<img src="../objects2/image/point_empty.gif" border="0" align="absmiddle" />
		</cfloop>
		<div style="position:absolute;display:none;margin-left:-300;height:300;width:300;" id="my_add_comment_#this_row_id_#" class="comment_div"></div>
		<a href="javascript://" onClick="gizle_goster(my_add_comment_#this_row_id_#);open_add_comment();" class="tableyazi"><cf_get_lang no='359.Ürüne Yorum Ekle'></a>
	</cfif>
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
	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_view_all_product_comment&product_id=#attributes.product_id#&is_product_comment=#attributes.is_product_comment#','large');" class="tableyazi"><cf_get_lang no ='360.Yorum Oku'> : #get_product_comment_.YORUM_SAYISI#</a>
	<cfif isdefined('attributes.is_product_comment') and (attributes.is_product_comment eq 1 or (attributes.is_product_comment eq 2 and isdefined('session_base.userid')))>
		-
		<div style="position:absolute;display:none;margin-left:-300;height:300;width:300;" id="my_add_comment_#this_row_id_#" class="comment_div"></div>
		<a href="javascript://" onClick="gizle_goster(my_add_comment_#this_row_id_#);open_add_comment();" class="tableyazi"><cf_get_lang no='359.Ürüne Yorum Ekle'></a>
	</cfif>
</cfif>
<script type="text/javascript">
	function yorum_kapat()
	{
		gizle(my_add_comment_#this_row_id_#);
	}
	function open_add_comment()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_add_product_comment&pid='+#attributes.product_id#+'','my_add_comment_#this_row_id_#</cfoutput>',1);
	}
</script>
</cfoutput>
