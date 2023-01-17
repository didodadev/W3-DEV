<cfset get_banner = obj.getBanner(content_id:attributes.cid)>

<cfif get_banner.recordcount>
	<cfoutput query="get_banner">
		<cfif len(banner_file) and not len(url_path)>
			<cfif len(url) and is_flash neq 1>
				<cfif banner_target eq 'popup'>
					<a href="javascript://" onClick="windowopen('#url#','online_contact','#listlast(url,'.')#');" title="#banner_name#">
				<cfelse>
					<cfif url contains 'popup_flvplayer'>
						<a href="javascript://" onClick="windowopen('#url#','video');" title="#banner_name#">
					<cfelseif url contains '.html'>
						<a href="javascript://" onClick="windowopen('#url#','wwide');" title="#banner_name#">
					<cfelse>
						<a href="#url#" target="#banner_target#" title="#banner_name#">
					</cfif>
				</cfif>
					<cfif len(banner_height) and len(banner_width)>
						<img src="content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
					<cfelse>
						<img src="content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
					</cfif>
				</a> 
			<cfelseif is_flash neq 1 and not len(url)>
				<cfif len(banner_height) and len(banner_width)>
					<img src="content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
				<cfelse>
					<img src="content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
				</cfif>
			<cfelse>
				<cfset banner_swf_path = ListFirst(banner_file,'.')>
				<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
				<script type="text/javascript">
					AC_FL_RunContent( 'codebase','','width','#banner_width#','height','#banner_height#','src','/documents/content/banner/#banner_swf_path#','quality','high','wmode','transparent','pluginspage','','flashvars','movie','/documents/content/banner/#banner_swf_path#' ); //end AC code
				</script>
				<noscript>
				<object <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
					<param name="movie" value='<cf_get_server_file output_file="content/banner/#banner_file#" output_server="#banner_server_id#" output_type="4">'/>
					<param name="wmode" value="transparent"/>
					<param name="quality" value="high"/>
					<embed src='content/banner/#banner_file#' quality="high" type="application/x-shockwave-flash" <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> wmode="transparent"></embed>
				</object>
				</noscript>
			</cfif>
		<cfelseif len(url_path)>
			<cfif (len(url)) and (is_flash neq 1)>
				<a href="#url#" target="#banner_target#" title="#banner_name#">
					<cfif len(banner_height) and len(banner_width)>
						<img src="content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
					<cfelse>
						<img src="content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
					</cfif>
				</a> 
			<cfelseif (is_flash neq 1) and (not len(url))>
				<cfif len(banner_height) and len(banner_width)>
					<img src="content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
				<cfelse>
					<img src="content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
				</cfif>
			<cfelse>
				<cfset banner_swf_path = ListFirst(#banner_file#,'.')>
				<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
				<script type="text/javascript">
					AC_FL_RunContent( 'codebase','','width','#banner_width#','height','#banner_height#','src','/documents/content/banner/#banner_swf_path#','quality','high','wmode','transparent','pluginspage','','flashvars','movie','/documents/content/banner/#banner_swf_path#' ); //end AC code
				</script>
				<noscript>
				<object <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
					<param name="movie" value='<cf_get_server_file output_file="content/banner/#banner_file#" output_server="#banner_server_id#" output_type="4" alt="#banner_name#" title="#banner_name#">'/>
					<param name="wmode" value="transparent"/>
					<param name="quality" value="high"/>
					<embed src='content/banner/#banner_file#' quality="high" type="application/x-shockwave-flash" <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> wmode="transparent"></embed>
				</object>
				</noscript>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
