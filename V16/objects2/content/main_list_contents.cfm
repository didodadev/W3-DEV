<cfset session_base = "">
<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
	<cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
</cfif>
<cfset cmp = createObject('component','V16.content.cfc.get_content')>
<cfset get_content_list = cmp.get_content_list_fnc(together:1,list_content_maxrow:iif(isdefined('attributes.list_content_maxrow') and len(attributes.list_content_maxrow),'attributes.list_content_maxrow',10),list_content_cat_id:iif(isdefined('attributes.list_content_cat_id') and len(attributes.list_content_cat_id),'attributes.list_content_cat_id',DE('')),list_content_chapter_id:iif(isdefined('attributes.list_content_chapter_id') and len(attributes.list_content_chapter_id),'attributes.list_content_chapter_id',DE('')))>

<div class="list_item">
	<div class="list_item_header">
		<cfif isdefined('attributes.list_content_header_id') and len(attributes.list_content_header_id) and isnumeric(attributes.list_content_header_id)><cf_get_lang dictionary_id='#attributes.list_content_header_id#.'><cfelse><cf_get_lang dictionary_id='47028.Haberler'> ve <cf_get_lang dictionary_id='58118.Duyurular'></cfif>
	</div>
	<div class="list_item_contents">
		<ul>
			<cfoutput query="get_content_list">		
				<li>
					<div class="list_item_content_header">
						<cfset get_friendl_url = cmp.get_publish_page(faction:'content.list_content',event:'det',action_type:'cntid',action_id:content_id)>
						<a href="<cfif isdefined('attributes.list_content_cat_id') and attributes.list_content_cat_id eq 49>https://wiki.workcube.com/#site_language_path#/detail/#CONTENT_ID#<cfelseif isdefined('attributes.list_content_cat_id') and attributes.list_content_cat_id eq 5>http://www.workcube.com/#get_friendl_url.FRIENDLY_URL#<cfelse>http://#get_friendl_url.DOMAIN#/#get_friendl_url.FRIENDLY_URL#</cfif>" target="_blank">#cont_head#</a>
					</div>
					<div class="list_item_content">
						#left(cont_summary,400)#
					</div>
				</li>	
			</cfoutput>
		</ul>
	</div>
</div>