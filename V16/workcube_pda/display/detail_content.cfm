<cfset attributes.is_body = 1>
<cfif (isdefined('attributes.is_content_read') and attributes.is_content_read eq 1) and (attributes.fuseaction is 'objects2.detail_content')>
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
			if ((event.button==2) || (event.button==3)) { alert("<cf_get_lang no='151.Yazı Kopyalayamazsınız'>!");}
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
			C.RECORD_MEMBER,
			C.UPDATE_MEMBER,
			C.HIT,
			C.HIT_PARTNER,
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
			C.STAGE_ID = -2 AND
			C.CONTENT_STATUS = 1 AND
			EMPLOYEE_VIEW = 1  AND
            CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">) AND
			C.CONTENT_ID = <cfqueryparam value="#attributes.cid#" cfsqltype="cf_sql_integer">
		ORDER BY
			C.CONTENT_ID DESC
	</cfquery>
    <cfif isdefined("session.pda") and len(get_content.hit)>
	  <cfset hit_ = get_content.hit + 1>
	<cfelse>
	  <cfset hit_ = 1>
	</cfif>
	<cfquery name="HIT_UPDATE" datasource="#dsn#">
		UPDATE
			CONTENT
		SET
			<cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
			<cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
			LASTVISIT = #now()#
		WHERE
			CONTENT_ID = #attributes.cid#
	</cfquery>
  </cftransaction>
</cflock>
<cfif GET_CONTENT.recordcount>
	<cfoutput query="get_content">
	<table width="98%" cellpadding="0" cellspacing="0">
	  <tr>
		<td colspan="3">
			<cfif get_content.is_dsp_header eq 0>
           		<h1 class="headbold">#cont_head#</h1><br><br>
            </cfif>
			<table width="100%" cellpadding="0" cellspacing="0">
				<cfif IS_DSP_SUMMARY eq 0 and len(CONT_SUMMARY)>
				<tr>
					<td class="txtbold">#CONT_SUMMARY#<br><br></td>
				</tr>
				</cfif>
				<cfif isdefined('attributes.is_body') and attributes.is_body eq 1>
					<tr>
						<td>#cont_body#</td>
					</tr>
				</cfif>
			</table>
		</td>
	  </tr>
		<cfif len(get_content.OUTHOR_EMP_ID)>
			<cfset member_id = get_content.OUTHOR_EMP_ID>
			<cfset member_type = 1>
		<cfelseif len(get_content.OUTHOR_CONS_ID)>
			<cfset member_id = get_content.OUTHOR_CONS_ID>
			<cfset member_type = 2>
		<cfelseif len(get_content.OUTHOR_PAR_ID)>
			<cfset member_id = get_content.OUTHOR_PAR_ID>
			<cfset member_type = 3>
		<cfelse>
			<cfset member_id = ''>
		</cfif>
	  <cfif (isdefined("attributes.is_content_outhor") and attributes.is_content_outhor eq 1) and (len(member_id))>
	  <tr>
		<td class="headerprint"><cf_get_lang no='355.Yazar'> : 
			<cfif len(get_content.OUTHOR_EMP_ID)>
				#get_emp_info(get_content.OUTHOR_EMP_ID,0,0)#
			<cfelseif len(get_content.OUTHOR_CONS_ID)>
				#get_cons_info(get_content.OUTHOR_CONS_ID,0,0)#
			<cfelseif len(get_content.OUTHOR_PAR_ID)>
				#get_par_info(get_content.OUTHOR_PAR_ID,1,0,0)#
			</cfif>
			<cfif len(get_content.WRITING_DATE)> - #dateformat(get_content.WRITING_DATE,'dd/mm/yyyy')#</cfif>
		</td>
	  </tr>
	  <tr>
		<td><a href="#request.self#?fuseaction=objects2.view_content_member&member_id=#member_id#&type=#member_type#" class="headerprint"><cf_get_lang no="152.Yazarın diğer yazıları">..</a></td>
	  </tr>
	  </cfif>
	  <tr>
		<cfif isdefined('attributes.is_content_webmail') and attributes.is_content_webmail eq 1>
			<td valign="top"><cfinclude template="content_webmail.cfm"></td>
		</cfif>
		<cfif isdefined('attributes.is_content_print') and  attributes.is_content_print eq 1>
			<td align="right" valign="top" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#attributes.cid#&module=objects2','page');return false;" class="headerprint"></a></td>
		</cfif>
		<cfif isdefined('attributes.is_addthis') and attributes.is_addthis eq 1>
			<td align="right" valign="top" style="text-align:right;"><cfinclude template="add_this.cfm"></td>
		</cfif>
	  </tr>
	</table>
	</cfoutput>
</cfif>
