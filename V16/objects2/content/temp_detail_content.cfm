<cfsetting showdebugoutput="no">
<cfset attributes.cid = attributes.id>
<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="1">
	SELECT
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.CONT_BODY,
		C.CONT_SUMMARY, 
		C.RECORD_MEMBER,
		C.UPDATE_MEMBER,
		C.HIT,
		C.HIT_PARTNER,
		C.IS_DSP_HEADER,
		C.IS_DSP_SUMMARY,
		C.CATALOG_ID,
		C.CHAPTER_ID,
		C.CONTENT_PROPERTY_ID,
		C.RECORD_DATE
	FROM
		CONTENT C
	WHERE 
		C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		<cfif isdefined("session.pp.company_category")>
			C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
		<cfelseif isdefined("session.ww.consumer_category")>
			C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
		<cfelseif isdefined("session.cp")>
			CAREER_VIEW = 1  AND
		<cfelse>
			INTERNET_VIEW = 1  AND
		</cfif>
		C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	ORDER BY
		C.CONTENT_ID DESC
</cfquery>
<cfinclude template="../query/get_chapter_menu.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_content_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cfinclude template="../query/get_content_property.cfm">

<cfif len(get_content.catalog_id) neq 0 and get_content.catalog_id neq 0 and get_content.IS_CATALOG_CONTENT IS 1>
	<cfset CATALOG_ID = GET_CONTENT.CATALOG_ID>
</cfif>

<cfif isdefined("url.pid")>
	<input type="Hidden" name="product_id_" id="product_id_" value="<cfoutput>#url.pid#</cfoutput>">
</cfif>

<input type="Hidden" name="cntid" id="cntid" value="<cfoutput>#attributes.cid#</cfoutput>">
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>

<table width="590">
  <tr height="18">
    <td width="65" class="txtbold"><cf_get_lang_main no='583.Bölüm'></td>
    <td> 
	<cfoutput query="get_chapter_menu"> 
	 <cfif get_content.CHAPTER_ID is CHAPTER_ID>#chapter#</cfif> 
	</cfoutput> 
    </td>
  </tr>
  <tr height="18">
    <td class="txtbold"><cf_get_lang_main no='218.Tip'></td>
    <td><cfoutput query="get_CONTENT_PROPERTY">					
		  <cfif get_content.CONTENT_PROPERTY_ID is CONTENT_PROPERTY_ID>#name#</cfif>
		</cfoutput>
	</td>
  </tr>
  <tr height="18">
    <td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
    <td><cfoutput>#get_content.cont_head# </cfoutput></td>
  </tr>
  <tr height="20" valign="top">
    <td class="txtbold"><cf_get_lang_main no='640.Özet'></td>
    <td><cfoutput>#get_content.cont_summary#</cfoutput></td>
  </tr>
</table>
<table width="590">
	<tr>
		<td class="headbold">
		<hr>
		</td>
	</tr>
	<tr>
		<td><cfoutput>#get_content.cont_body#</cfoutput></td>
	</tr> 
</table>
<table width="590">
	<tr>
	<td>
	<cfoutput>
		<cf_get_lang_main no='771.Yazan'> : 
		#get_emp_info(get_content.record_member,0,0)#<br/>
		<cfif len(get_content.record_date)>
		<cf_get_lang_main no='772.Yazım Tarihi'> :#dateformat(date_add('h',session_base.time_zone,get_content.record_date),'dd/mm/yy')# #timeformat(date_add('h',session_base.time_zone,get_content.record_date),'HH:MM')#
		</cfif>
	</cfoutput>
	</td>
	</tr>
</table>
