<cfsetting showdebugoutput="no">
<div style="text-align:left;">
<!--- E.A storeproca cevrildi 20130109 6 aya silinsin
<cfquery name="get_widget" datasource="#dsn#">
	SELECT URL,WIDGET_SCRIPT,WIDGET_RECORD_COUNT,WIDGET_SHOW_IMAGE FROM MY_SETTINGS_POSITIONS WHERE MENU_POSITION_ID = #attributes.menu_position_id#
</cfquery> --->

<cfstoredproc procedure="GET_WIDGET" datasource="#DSN#">
	<cfprocparam cfsqltype="cf_sql_integer" value="#attributes.menu_position_id#">
	<cfprocresult name="GET_WIDGET">
</cfstoredproc>

<cfif len(get_widget.URL)>
	<cfif len(get_widget.WIDGET_RECORD_COUNT)>
		<cfset record_ = get_widget.WIDGET_RECORD_COUNT>
	<cfelse>
		<cfset record_ = 10>
	</cfif>
	<cfif get_widget.WIDGET_SHOW_IMAGE eq 1>
		<cfset image_ = 1>
	<cfelse>
		<cfset image_ = 0>
	</cfif>
	<cfset attributes.box_page = get_widget.URL>
		<cfif URLDecode(attributes.box_page) contains 'http://www.facebook.com/' and not URLDecode(attributes.box_page) contains 'http://www.facebook.com/feeds'>
			<table style="table-layout:fixed; height:500px;"><tr><td><cfoutput><script src="http://connect.facebook.net/en_US/all.js##xfbml=1"></script><fb:like-box href="#attributes.box_page#" show_faces="true" width="500" height="500" stream="true" header="false"></fb:like-box></cfoutput></td></tr></table>
		<cfelse>
			<cftry>	
				<cfhttp method="get" url="#attributes.box_page#" timeout="60" charset="utf-8"></cfhttp>  
					<cfif find('ISO-8859',cfhttp.FileContent,1)>
                        <cfset lang_ = 'ISO-8859-9'>
                    <cfelseif find('windows-1254',cfhttp.FileContent,1)>
                        <cfset lang_ = 'windows-1254'>
                    <cfelseif find('utf-8',cfhttp.FileContent,1)>
                        <cfset lang_ = 'utf-8'>
                    <cfelse>
                    	<cfset lang_ = 'utf-8'>
                    </cfif>
				<cfhttp method="get" url="#attributes.box_page#" timeout="60" charset="#lang_#"></cfhttp>
				<cfset xml_response_node = xmlparse(REReplace(cfhttp.FileContent, "^[^<]*", "", "all" ))/>
			<cfif isdefined("xml_response_node.rss.channel.item")>
				<cfoutput>
					<cfloop from="1" to="#record_#" index="ccx">
						<cfif arraylen(xml_response_node.rss.channel.item) gte ccx>
							<cfif ccx eq 1><table class="ajax_list"></cfif>
								<cfif image_ eq 0>
									<tr><td><a href="#xml_response_node.rss.channel.item[ccx].link.XmlText#" target="wrk_rss" class="tableyazi">#xml_response_node.rss.channel.item[ccx].title.XmlText#</a></td></tr>
								<cfelse>
									<tr>
										<td>
										<cfif not isdefined("xml_response_node.rss.channel.item.enclosure.XmlAttributes.width")>
											<cfset width_ = 85>
											<cfset height_ = 80>
										<cfelse>
											<cfset width_ = xml_response_node.rss.channel.item[ccx].enclosure.XmlAttributes.width>
											<cfset height_ = xml_response_node.rss.channel.item[ccx].enclosure.XmlAttributes.height>
										</cfif>
										<cfif isdefined("xml_response_node.rss.channel.item.enclosure")>
                                            <img src="#xml_response_node.rss.channel.item[ccx].enclosure.XmlAttributes.url#" width="#width_#" height="#height_#" border="0">
                                            <br />
                                        </cfif>
										<a href="#xml_response_node.rss.channel.item[ccx].link.XmlText#" target="wrk_rss" class="tableyazi">#xml_response_node.rss.channel.item[ccx].title.XmlText#</a>
										<cfif isdefined("xml_response_node.rss.channel.item.enclosure")><br /></cfif>
										</td>
									</tr>
								</cfif>
							<cfif arraylen(xml_response_node.rss.channel.item) eq ccx></table></cfif>
						</cfif>
					</cfloop>
				</cfoutput>
			<cfelse>
				<cfoutput>#xml_response_node.Module.Content[1].XmlText#</cfoutput>
			</cfif>
			<cfcatch type="any"><cf_get_lang dictionary_id='47268.Geçerli Bir XML Girilmedi'>!</cfcatch>
			</cftry>
		</cfif>
<cfelseif len(get_widget.widget_script)>
	<cfoutput>#get_widget.widget_script#</cfoutput>
<cfelse>
	<cf_get_lang dictionary_id='47268.Geçerli Bir XML Girilmedi'>!
</cfif>
</div>
