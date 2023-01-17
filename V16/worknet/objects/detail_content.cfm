<cfset obj = createObject("component","worknet.objects.worknet_objects")>
<cfset getContent = obj.getContents(content_id:attributes.cid) />
<cfoutput>
	<div class="clear_content" style="clear:both; width:910px">		
		<table id="detailContent">
        	<cfif isdefined('attributes.add_this_view') and attributes.add_this_view eq 1> 
				<script type="text/javascript" src="http://s7.addthis.com/js/200/addthis_widget.js"></script>
                    <tr>
                        <td colspan="2">
                        <div style="float:right;" class="addthis_toolbox addthis_default_style " addthis:url='http://#cgi.HTTP_HOST#/#url_friendly_request('worknet.detail_content&cid=#getContent.content_id#','#getContent.user_friendly_url#')#' addthis:title='#getContent.cont_head#' >
                            <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
                            <a class="addthis_button_tweet"></a>
                            <a class="addthis_counter addthis_pill_style"></a>
                        </div>	
                        </td>
                    </tr>
            </cfif>
			<tr>
				<!--- icerik alani --->
				<td>#obj.getContent(content_id:attributes.cid)#</td>
                
				<!--- banner alani --->
				<cfif listlen(attributes.cid,',') eq 1>
					<cfset get_banner_detail = obj.getBanner(content_id:attributes.cid)>
					<cfif len(get_banner_detail)>
						<td style="float:right; margin-left:15px;">
							#get_banner_detail#
						</td>
					</cfif>
				</cfif>
			</tr>
		</table>
        <!--- form grenerator --->
        <cfif isdefined('attributes.is_form_generator') and attributes.is_form_generator eq 1>
    	    <table width="100%">
                <tr>
                    <td><cfinclude template="form_generator.cfm"></td>
                </tr>
	        </table>
        </cfif>
	</div>	
	<!--- ileri geri --->
	<cfif isdefined('attributes.is_navigate') and attributes.is_navigate eq 1 and listlen(attributes.cid,',') eq 1 and getContent.contentcat_id neq 10>
		<div style="clear:both; width:910px; margin-top:10px;" align="center">
        	<table align="center">
            	<tr>
                	<td width="70">
                    	<cfset getNxt = obj.Get_NextPrev(content_id:attributes.cid,type:1) />
						<cfset getPrev = obj.Get_NextPrev(content_id:attributes.cid,type:2) />
                        
						<cfif len(getNxt.CONTENT_ID)>
                            <a href="#url_friendly_request('worknet.detail_content&cid=#getNxt.CONTENT_ID#','#getNxt.USER_FRIENDLY_URL#')#" style="float:right;"><img src="../../documents/templates/worknet/tasarim/sagokkoyu.jpg" title="<cf_get_lang_main no='1431.ileri'>" /></a>
                        <cfelse>
                            <img src="../../documents/templates/worknet/tasarim/sagok.jpg" title="<cf_get_lang_main no='1431.ileri'>" style="float:right;" />
                        </cfif>
                      
						<cfif len(getPrev.CONTENT_ID)>
                            <a href="#url_friendly_request('worknet.detail_content&cid=#getPrev.CONTENT_ID#','#getPrev.USER_FRIENDLY_URL#')#"><img src="../../documents/templates/worknet/tasarim/solokkoyu.jpg" title="<cf_get_lang_main no='20.geri'>" /></a>
                        <cfelse>
                            <img src="../../documents/templates/worknet/tasarim/solok.jpg" title="<cf_get_lang_main no='20.geri'>" />
                        </cfif>
                    </td>
                </tr>
            </table>
		</div>
	</cfif>
</cfoutput>

