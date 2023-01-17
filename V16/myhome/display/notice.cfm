<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_CONTENT_FOLLOW FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31028.WorkCube Intranet Duyurusu'></cfsavecontent>
<cf_popup_box title="#message#">
	<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0" height="100%">
		<tr>
			<td valign="top">
			<br/>
			 <cfquery name="get_notice" DATASOURCE="#dsn#">
				  SELECT 
					  RECORD_DATE, 
					  UPDATE_DATE, 
					  RECORD_MEMBER AS RECORD_EMP, 
					  UPDATE_MEMBER AS  UPDATE_EMP,
					  CONT_HEAD, 
					  CONT_BODY,
					  HIT_EMPLOYEE,
					  CONT_SUMMARY
				  FROM 
					  CONTENT 
				  WHERE 
					  CONTENT_ID=#attributes.ID#
			  </cfquery>
					<cfif len(get_notice.HIT_EMPLOYEE)>
						<cfset HIT_EMPLOYEE = get_notice.HIT_EMPLOYEE + 1>
					<cfelse>
						<cfset HIT_EMPLOYEE = 1>
					</cfif>
					<cfquery name="HIT_UPDATE" datasource="#dsn#">
						UPDATE CONTENT SET HIT_EMPLOYEE = #HIT_EMPLOYEE#,LASTVISIT = #NOW()# WHERE CONTENT_ID = #attributes.ID#
					</cfquery>
			  <cfoutput><span class="headbold">#get_notice.CONT_HEAD#</span>
				<br/><br/>
				<cfif len(get_notice.CONT_SUMMARY)><span class="formbold">#get_notice.CONT_SUMMARY#</span><br/><br/></cfif>
			&nbsp;#get_notice.CONT_BODY#
			</cfoutput>
			</td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_record_info query_name="get_notice"></cf_popup_box_footer>
</cf_popup_box>
<cfif get_our_company_info.is_content_follow eq 1>
	<cfquery name="add_content_follows" datasource="#dsn#">
	INSERT INTO CONTENT_FOLLOWS 
				(
				CONTENT_ID,
				EMPLOYEE_ID,
				READ_DATE,
				READ_IP
				)
				VALUES
				(
				#attributes.ID#,
				#session.ep.userid#,
				#now()#,
				'#CGI.REMOTE_ADDR#'
				)
	</cfquery>
</cfif>
<script type="text/javascript"><!--- Bu script sağ tuş koruması ve sayfadan text kopyalanmasını (CTRL + C) engeller FS - 02/07/2007 --->
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
			if ((event.button==2) || (event.button==3)) { alert("Yazı Kopyalayamazsınız!");}
		}
</script>

