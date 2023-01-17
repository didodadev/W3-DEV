<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.write_date" default="">
<cfif isdefined('attributes.contentCatID') and len(attributes.contentCatID)>
	<cfparam name="attributes.contentCatID" default="#attributes.contentCatID#">
<cfelse>
	<cfparam name="attributes.contentCatID" default="">
</cfif>
<cfif isdefined('attributes.contentChapterId') and len(attributes.contentChapterId)>
	<cfparam name="attributes.contentChapterId" default="#attributes.contentChapterId#">
<cfelse>
	<cfparam name="attributes.contentChapterId" default="">
</cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset getListContent = createObject("component","worknet.objects.worknet_objects").getContents(
		content_cat_id:attributes.contentCatID,
		content_chapter_id:attributes.contentChapterId,
		writing_date_check:attributes.write_date
) />

<cfparam name="attributes.totalrecords" default="#getListContent.recordcount#">
<cfif isdefined('attributes.contentCatID') and len(attributes.contentCatID)>
	<cfset getContenCat = createObject("component","worknet.objects.worknet_objects").getContentCat(cat_id:attributes.contentCatID)>
	<cfset headName = getContenCat.CONTENTCAT>
<cfelseif isdefined('attributes.contentChapterId') and len(attributes.contentChapterId)>
	<cfset getContenChapter = createObject("component","worknet.objects.worknet_objects").getContentChapter(chapter_id:attributes.contentChapterId)>
	<cfset headName = getContenChapter.CHAPTER>
</cfif>

<div class="haber_liste">
	<cfif isdefined('headName') and len(headName)>
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cfoutput>#headName#</cfoutput></h1></div>
           <div class="haber_liste_12" style=" width:100px;">
            <cfform name="date_form" id="date_form" method="post" format="html">
            	<select name="write_date"  id="write_date" onchange="document.getElementById('date_form').submit()" style="border:none;padding-bottom:3px; width:100px;">
            		<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
            			<cfloop from="#year(now())#" to="#year(now())-1#" index="y" step="-1">
   							<cfoutput>         
							<option value="#y#" <cfif attributes.write_date eq y>selected</cfif>> #y#</option>  <!--- Yıl SelectBox --->
							</cfoutput>
						</cfloop>
                </select>
            </cfform>
            </div>
		</div>
	</cfif>
	<div class="haber_liste_2">
		<cfif getListContent.recordcount>
			<cfoutput query="getListContent" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<div class="haber_liste_21">
					<div class="haber_liste_211">
						<cfset getContentImage = createObject("component","worknet.objects.worknet_objects").getContentImage(content_id:content_id,image_size:0) />
						<cfif getContentImage.recordcount>
							<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#"><cf_get_server_file output_file="content/#getContentImage.contimage_small#" image_width="100" image_height="100" output_server="#getContentImage.image_server_id#" output_type="0"></a>
						<cfelse>
							<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
						</cfif>
					</div>
					<div class="haber_liste_212">
						<a href="#url_friendly_request('worknet.detail_content&cid=#content_id#','#user_friendly_url#')#">
							#cont_head# 
							<cfif dateFormat(date_add('d',-2,now()),'yyyymmdd') lte dateFormat(record_date,'yyyymmdd')>
								<font color="red"> - Yeni</font>
							</cfif>
						</a>
						<span>#dateFormat(writing_date,dateformat_style)#</span>
						<samp>#cont_summary#</samp>
					</div>
				</div>
			</cfoutput>
		<cfelse>
			<div class="haber_liste_21">
				<div class="haber_liste_212">
					<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
				</div>
			</div>
		</cfif>
	</div>
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset urlstr="&write_date=#attributes.write_date#">
			<cf_paging page="#attributes.page#" 
			page_type="1"
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##urlstr#">
					
		</cfif>
	</div>
</div>
