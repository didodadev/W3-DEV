
<!--- <cfparam  name="attributes.param_2" default="#attributes.cntid#"> --->
<cfif isDefined("attributes.cntid") AND LEN(attributes.cntid)>
	<cfset attributes.param_2 = attributes.cntid>
</cfif>

<!--- <cfparam  name="attributes.cid" default="#url.cid#">
<cfset attributes.cid = (len(attributes.cid ) ? attributes.cid  : url.cid  )> --->
<cfif isdefined("attributes.list_content_width") and isnumeric(attributes.list_content_width)>
	<cfset my_image_width = attributes.list_content_width>
<cfelse>
	<cfset my_image_width = 350>
</cfif>
<cfif isdefined("attributes.list_content_height") and isnumeric(attributes.list_content_height)>
	<cfset my_image_height = attributes.list_content_height>
<cfelse>
	<cfset my_image_height = 200>
</cfif>

<cfif attributes.content_source eq 1>
    <cfif isdefined('attributes.is_content_read') and attributes.is_content_read eq 1>
		<!--- bu javascript sağ tuş koruması sağlar ve ctrl + c yi yasaklar!! 06/07/2007 FS--->
		<script type="text/javascript">
			var omitformtags=["input", "textarea", "select"]
			omitformtags=omitformtags.join("|")
			function disableselect(e){
				if (omitformtags.indexOf(e.target.tagName.toLowerCase())==-1)
					return false
				}
			function reEnable(){
					return true
				}
			if (typeof document.onselectstart!="undefined")
				document.onselectstart=new Function ("return false")
			else{
				document.onmousedown=disableselect
				document.onmouseup=reEnable
			}
				document.onmousedown=click;
				function click()
			{
				if ((event.button==2) || (event.button==3)) { alert("<cf_get_lang dictionary_id='34472.Yazı Kopyalayamazsınız'>!");}
			}
		</script>
	</cfif>

	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="1">
				SELECT
					C.CONTENT_ID,
					C.CONT_HEAD,
					C.CONT_BODY,
					C.CONT_SUMMARY, 
					C.CHAPTER_ID,
					C.RECORD_MEMBER,
					C.UPDATE_MEMBER,
					C.HIT,
					C.HIT_PARTNER,
					C.HIT_GUEST,
					C.RECORD_DATE,
					C.WRITING_DATE,
					C.UPDATE_DATE,
					C.IS_DSP_HEADER,
					C.IS_DSP_SUMMARY,
					OUTHOR_EMP_ID,
					OUTHOR_CONS_ID,
					OUTHOR_PAR_ID,
					WRITING_DATE
				FROM
					CONTENT C,
					CONTENT_CHAPTER AS CC,
					CONTENT_CAT AS CCAT
				WHERE 
					C.CHAPTER_ID = CC.CHAPTER_ID AND 
					CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
					C.CONTENT_STATUS = 1 AND
					<cfif isdefined("session.pp.company_category")>
						C.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> AND
					<cfelseif isdefined("session.ww.consumer_category")>
						C.CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> AND
					<cfelseif isdefined("session.cp.userid")>
						CAREER_VIEW = 1  AND
					<cfelse>
						INTERNET_VIEW = 1  AND
					</cfif>					
					
					<cfif isdefined('url.cid') and len(url.cid)>
					C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">  AND
					<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
					C.CONTENT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#" list="Yes" separator=",">) AND
					<cfelseif isdefined('attributes.cntid') and len(attributes.cntid)>
					C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
					</cfif>
					C.LANGUAGE_ID = '#session_base.language#'
				ORDER BY
					C.CONTENT_ID DESC
			</cfquery>
			<cfif isdefined("session.ww.userid") and len(get_content.hit)>
				<cfset hit_ = get_content.hit + 1>
			<cfelse>
				<cfset hit_ = 1>
			</cfif>
			<cfif isdefined("session.pp") and len(get_content.hit_partner)>
				<cfset hit_partner_ = get_content.hit_partner + 1>
			<cfelse>
				<cfset hit_partner_ = 1>
			</cfif>
			<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and len(get_content.hit_guest)>
				<cfset hit_guest_ = get_content.hit_guest + 1>
			<cfelse>
				<cfset hit_guest_ = 1>
			</cfif>
			<cfquery name="HIT_UPDATE" datasource="#DSN#">
				UPDATE
					CONTENT
				SET
					<cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
					<cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
					<cfif  not isdefined("session.pp") and not isdefined("session.ww.userid")>HIT_GUEST = #hit_guest_#,</cfif>
					LASTVISIT = #now()#
				WHERE
				<cfif isdefined('url.cid') and len(url.cid)>
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
				<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
				CONTENT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#" list="Yes" separator=",">)
				<cfelseif isdefined('attributes.cntid') and len(attributes.cntid)>
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
				</cfif>
				AND LANGUAGE_ID = '#session_base.language#'
			</cfquery>
			<cfquery name="GET_CONTENT_IMAGE" datasource="#DSN#">
				SELECT
					CONTIMAGE_SMALL
				FROM
					CONTENT_IMAGE
				WHERE 
				<cfif isdefined('url.cid') and len(url.cid)>
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cid#">
				<cfelseif isdefined('attributes.cid') and len(attributes.cid)>
				CONTENT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#" list="Yes" separator=",">)
				<cfelseif isdefined('attributes.cntid') and len(attributes.cntid)>
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
				</cfif>
				AND LANGUAGE_ID = '#session_base.language#'
			</cfquery>
		</cftransaction>
	</cflock>
	<cfif get_content.recordcount>
		<div class="list_content_item_detail">
			<cfoutput query="get_content">
				<cfif isdefined('attributes.is_content_picture') and attributes.is_content_picture eq 1>
					<div class="list_content_item_detail_img">
						<cfif len(get_content_image.contimage_small)>
							<img src="<cf_puxild list="image" row="1" content="/documents/content/#get_content_image.contimage_small#">" style=" width:#my_image_width#; height:#my_image_height#;"/>
						</cfif>
					</div>
				</cfif>
				<cfif isDefined('attributes.is_header') and attributes.is_header eq 1>
					<div class="list_content_item_detail_title">
						<h1><cf_puxild type="head" content="#cont_head#"></h1>																						
					</div>	
				</cfif>	
				<cfif isDefined('attributes.is_summary') and attributes.is_summary eq 1>
					<div class="list_content_item_detail_summary">
						<p>
							<cf_puxild type="description" content="#cont_summary#">
						</p>
					</div>
				</cfif>		
				<cfif isdefined('attributes.is_body') and attributes.is_body eq 1>
					<div class="list_content_item_detail_content">
						#cont_body#
					</div>
				</cfif>
				<cfif len(get_content.outhor_emp_id)>
					<cfset member_id = get_content.outhor_emp_id>
					<cfset member_type = 1>
				<cfelseif len(get_content.outhor_cons_id)>
					<cfset member_id = get_content.outhor_cons_id>
					<cfset member_type = 2>
				<cfelseif len(get_content.outhor_par_id)>
					<cfset member_id = get_content.outhor_par_id>
					<cfset member_type = 3>
				<cfelse>
					<cfset member_id = ''>
				</cfif>
				<cfif (isdefined("attributes.is_content_outhor") and attributes.is_content_outhor eq 1) and (len(member_id))>
					<!--- <cf_get_lang_main no='771.Yazan'> : ---> 
						<div class="list_content_item_detail_author">
							<cfif len(get_content.outhor_emp_id)>
								#get_emp_info(get_content.outhor_emp_id,0,0)#
							<cfelseif len(get_content.outhor_cons_id)>
								#get_cons_info(get_content.outhor_cons_id,0,0)#
							<cfelseif len(get_content.outhor_par_id)>
								#get_par_info(get_content.outhor_par_id,1,0,0)#
							</cfif>
							<span><cfif len(get_content.writing_date)>#dateformat(get_content.writing_date,'dd/mm/yyyy')#</cfif></span>
						</div>					
				</cfif>
		</div>
		<!--- <table cellpadding="0" cellspacing="0" border="0" style="width:100%">
				
				
				<cfif (isdefined("attributes.outhor_all_content") and attributes.outhor_all_content) and (len(member_id))>
                    <cfif isdefined("attributes.outhor_all_content_link") and len(attributes.outhor_all_content_link)>
                        <tr>
                            <td><a href="#attributes.outhor_all_content_link#?member_id=#member_id#" class="headerprint"><cf_get_lang dictionary_id='34473.Yazarın diğer yazıları'>..</a></td>
                        </tr>
                    </cfif> 
                </cfif>	
				<tr>
					<cfif isdefined('attributes.is_content_webmail') and attributes.is_content_webmail eq 1>
						<td style="vertical-align:top;"><cfinclude template="content_webmail.cfm"></td>
					</cfif>
					<cfif isdefined('attributes.is_content_print') and  attributes.is_content_print eq 1>
						<td style="vertical-align:top;text-align:right;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#attributes.cid#&module=objects2','page');return false;" class="headerprint"></a></td>
					</cfif>
					<cfif isdefined('attributes.is_addthis') and attributes.is_addthis eq 1>
						<td style="vertical-align:top;text-align:right;"><cfinclude template="add_this.cfm"></td>
					</cfif>
				</tr>
				<cfif isDefined('attributes.is_publish_date') and len(attributes.is_publish_date)>
					<cfif isDefined('attributes.is_chapter_publish') and len(attributes.is_chapter_publish)>
						<cfif listfind(attributes.is_chapter_publish,get_content.chapter_id,',')>
							<cfif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 2>  
								<cfif len(get_content.record_date)>         
									<tr>
										<td>Yayın Tarihi : #DateFormat(get_content.record_date,'dd/mm/yyyy')#</td>
									</tr>
								</cfif>
							<cfelseif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 1>
								<cfif len(get_content.update_date)> 
									<tr>
										<td>Yayın Tarihi : #DateFormat(get_content.update_date,'dd/mm/yyyy')#</td>
									</tr> 
								</cfif>                   
							<cfelseif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 3>
								<cfif len(get_content.writing_date)> 
									<tr>
										<td>Yayın Tarihi : #DateFormat(get_content.writing_date,'dd/mm/yyyy')#</td>   
									</tr> 
								</cfif>            
							</cfif>
						</cfif>
					<cfelse>
						<cfif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 2>  
							<cfif len(get_content.record_date)>         
								<tr>
									<td>Yayın Tarihi : #DateFormat(get_content.record_date,'dd/mm/yyyy')#</td>
								</tr>
							</cfif>
						<cfelseif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 1>
							<cfif len(get_content.update_date)> 
								<tr>
									<td>Yayın Tarihi : #DateFormat(get_content.update_date,'dd/mm/yyyy')#</td>
								</tr> 
							</cfif>                   
						<cfelseif isDefined('attributes.is_publish_date') and attributes.is_publish_date eq 3>
							<cfif len(get_content.writing_date)> 
								<tr>
									<td>Yayın Tarihi : #DateFormat(get_content.writing_date,'dd/mm/yyyy')#</td>   
								</tr> 
							</cfif>            
						</cfif>                
					</cfif>
				</cfif>
			</table> --->
		</cfoutput>
	</cfif>
<cfelseif attributes.content_source eq 2>
	<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
	<cfset GET_CLASS = METHODS.GET_CLASS_DETAIL(CLASS_ID:attributes.cid)>
	<cfif GET_CLASS.recordcount>
		<cfoutput query="GET_CLASS">		
			<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
				<tr>
					<td>
						<h1 class="conthead">#CLASS_NAME#</h1>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="left">#CLASS_OBJECTIVE#</td>
				</tr>			
			</table>
				<a href="#TRAINING_LINK#">
					<i></i>
					<span>KATIL</span>
				</a>
		</cfoutput>
	</cfif>
</cfif>