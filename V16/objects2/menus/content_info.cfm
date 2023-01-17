<cfif isdefined('attributes.list_content_cat_id') and len(attributes.list_content_cat_id)>
	<cfset attributes.cat_id = attributes.list_content_cat_id>
</cfif>
<cfif isdefined('attributes.list_content_chapter_id') and len(attributes.list_content_chapter_id)>
	<cfset attributes.chid = attributes.list_content_chapter_id>
</cfif>
<cfif isdefined('attributes.cid') and len(attributes.cid)>
	<cfquery name="getContentInfo" datasource="#dsn#">
		SELECT 
			C.CONTENT_ID,
			C.CONT_HEAD,
			CCAT.CONTENTCAT,
			CCAT.CONTENTCAT_ID,
			CC.CHAPTER_ID,
			CC.CHAPTER
		FROM 
			CONTENT AS C, 
			CONTENT_CHAPTER AS CC,
			CONTENT_CAT AS CCAT
		WHERE
			C.CHAPTER_ID = CC.CHAPTER_ID AND 
			CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	</cfquery>
	<cfoutput>
	<table>
		<tr>
			<td class="ayakizi">
			<a href="" class="ayakizi"><cf_get_lang no='1603.Anasayfa'></a> > <a href="#request.self#?fuseaction=objects2.view_content_category&cat_id=#getContentInfo.CONTENTCAT_ID#" class="ayakizi">#getContentInfo.CONTENTCAT#</a> > <a href="#request.self#?fuseaction=objects2.view_content_chapter&chid=#getContentInfo.CHAPTER_ID#" class="ayakizi">#getContentInfo.CHAPTER#</a> > #getContentInfo.CONT_HEAD#
			</td>
		</tr>
	</table>
	</cfoutput>
<cfelseif isdefined('attributes.chid') and len(attributes.chid)>
	<cfquery name="getContentInfo" datasource="#dsn#">
		SELECT 
			CCAT.CONTENTCAT,
			CCAT.CONTENTCAT_ID,
			CC.CHAPTER_ID,
			CC.CHAPTER
		FROM 
			CONTENT_CHAPTER AS CC,
			CONTENT_CAT AS CCAT
		WHERE
			CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			CC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chid#">
	</cfquery>
	<cfoutput>
	<table>
		<tr>
			<td class="ayakizi">
				<a href="" class="ayakizi"><cf_get_lang no='1603.Anasayfa'></a> > <a href="#request.self#?fuseaction=objects2.view_content_category&cat_id=#getContentInfo.CONTENTCAT_ID#" class="ayakizi">#getContentInfo.CONTENTCAT#</a> > #getContentInfo.CHAPTER#
			</td>
		</tr>
	</table>
	</cfoutput>
<cfelseif isdefined('attributes.cat_id') and len(attributes.cat_id)>
	<cfquery name="getContentInfo" datasource="#dsn#">
		SELECT 
			CCAT.CONTENTCAT,
			CCAT.CONTENTCAT_ID
		FROM 
			CONTENT_CAT AS CCAT
		WHERE
			CCAT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
	</cfquery>
	<cfoutput>
	<table>
		<tr>
			<td class="ayakizi">
				<a href="" class="ayakizi"><cf_get_lang no='1603.Anasayfa'></a> > #getContentInfo.CONTENTCAT#
			</td>
		</tr>
	</table>
	</cfoutput>
</cfif>
