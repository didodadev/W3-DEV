<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfif not isdefined("attributes.chid")>
  <cfquery name="GET_CONTENTCHAPTERID" datasource="#dsn#">
	  SELECT 
		CHAPTER_ID
	  FROM 
		CONTENT
	  WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
  </cfquery>
  <cfset attributes.chid = GET_CONTENTCHAPTERID.CHAPTER_ID>
</cfif>
<cfquery name="GET_CONTENT_HEADERS" datasource="#dsn#">
	SELECT 
		CONTENT_ID, 
		CONT_HEAD
	FROM 
		CONTENT
	WHERE
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chid#"> AND
		STAGE_ID = -2 AND 
		<cfif isdefined("session.pp.company_category")>
			COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
		<cfelseif isdefined("session.ww.consumer_category")>
			CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
		<cfelseif isdefined("session.cp")>
			CAREER_VIEW = 1  AND
		<cfelse>
			INTERNET_VIEW = 1  AND
		</cfif> 
		CONT_POSITION LIKE '%6'
</cfquery>
<cfquery name="GET_CONTENTCHAPTER" datasource="#dsn#">
	SELECT 
		CHAPTER_ID, 
		CHAPTER
	FROM 
		CONTENT_CHAPTER
	WHERE
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chid#">
</cfquery>
<tr>
  <td height="25"><table width="120" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td height="50"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15"></td>
                    <td width="11"><img src="../objects2/image/ok6.png" width="7" height="8" /></td>
                    <td class="SideMenuParentItem"><cfoutput>#GET_CONTENTCHAPTER.CHAPTER#</cfoutput></td>
                  </tr>
                </table></td>
            </tr>
            <tr>
              <td><img src="../objects2/image/line5.png" width="180" height="1" /></td>
            </tr>
            <cfoutput query="GET_CONTENT_HEADERS">
              <tr>
                <td height="25" <cfif isdefined("attributes.cid") and GET_CONTENT_HEADERS.CONTENT_ID eq attributes.cid>class="SideMenuSelectedItem"<cfelse>class="SideMenuItem"</cfif>><table width="70%" border="0" align="center" cellpadding="0" cellspacing="0" >
                    <tr>
                      <td width="8"><img src="../objects2/image/ok7.gif" width="4" height="5" /></td>
                      <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&chid=#attributes.chid#&cid=#GET_CONTENT_HEADERS.CONTENT_ID#">#GET_CONTENT_HEADERS.CONT_HEAD#</a></td>
                    </tr>
                  </table></td>
              </tr>
            </cfoutput>
            <tr>
              <td><img src="../objects2/image/line6.png" width="180" height="1" /></td>
            </tr>
          </table>
         </td>
      </tr>
    </table>
</td></tr></table>

