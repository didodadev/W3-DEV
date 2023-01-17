<cfquery name="GET_BRAND_TYPE_CATS" datasource="#DSN#">
	SELECT
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,		
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND.BRAND_NAME		
	FROM
		SETUP_BRAND_TYPE_CAT,
		SETUP_BRAND_TYPE,
		SETUP_BRAND		
	WHERE
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
	ORDER BY
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME			
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <cfif get_brand_type_cats.recordcount>
    <cfoutput query="get_brand_type_cats">
	  <tr>
		<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><a href="#request.self#?fuseaction=settings.upd_brand_type_cat&brand_type_cat_id=#brand_type_cat_id#" class="tableyazi">#brand_type_cat_name#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
     	<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
		<td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
