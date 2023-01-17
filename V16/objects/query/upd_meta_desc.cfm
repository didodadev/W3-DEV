<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<!---25.06.2019 queryler cfcye taşındı--->
<cfset cfc= createObject("component","V16.objects.cfc.get_meta_desc")>
<cfset get_meta_lang=cfc.GetMetaLang(action_id:attributes.action_id,action_type:attributes.action_type,language_id:attributes.language_id,meta_desc_id:attributes.meta_desc_id)>
<cfif get_meta_lang.recordcount>
	<script type="text/javascript">
        alert("<cf_get_lang dictionary_id='62980.Bu Kayıt İçin İlgili Dil Seçeneği İle Meta Girişi Yapılmış'> !");
        history.back();
    </script>
    <cfabort>
</cfif>

<cfset UPD_META_DESCRIPTIONS=cfc.GetUpdMetaDescriptions(meta_title:attributes.meta_title,meta_desc:attributes.meta_desc,meta_keywords:attributes.meta_keywords,language_id:attributes.language_id,meta_desc_id:attributes.meta_desc_id)>

<cfset get_content=cfc.GetContent(action_id:attributes.action_id)>

<cfif isdefined('attributes.content_keyword') and attributes.content_keyword eq 1 and get_content.recordcount>
	<cfset DEL_CONTENTS=cfc.GetDelContents(action_id:attributes.action_id)>

	<cfloop from="1" to="#listlen(attributes.meta_keywords,',')#" index="i">
		<cfif len(trim(listgetat(attributes.meta_keywords,i,',')))>
			<cfset ADD_KEYWORD=cfc.AddKeyword(action_id:attributes.action_id,meta_keywords:trim(listgetat(attributes.meta_keywords,i,',')))>
		</cfif>
	</cfloop>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_get_meta_desc_' );
	</cfif>
</script>
