<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>

<cfquery name="GET_ASSET" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		ASSET_P,
		ASSET_P_CAT
	WHERE 
		ASSET_P.STATUS = 1 AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.IT_ASSET = 1
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND ASSET_P.ASSETP LIKE '#attributes.keyword#%'
	</cfif>
	<cfif len(attributes.CAT)>
		AND ASSET_P.ASSETP_CATID = #attributes.CAT#
	</cfif>
	ORDER BY ASSET_P.ASSETP
</cfquery>
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		ASSET_P_CAT 
	WHERE	
		IT_ASSET = 1
</cfquery>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_ASSET.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='130.IT Varlıkları'></td>
    <td  valign="bottom" class="headbold" style="text-align:right;">
      <table>
        <cfform name="list_it_asset" action="#request.self#?fuseaction=asset.list_it_asset" method="post">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td width="120">
              <select name="CAT" id="CAT" style="width:120">
                <option value=""><cf_get_lang no='1.Seçiniz'> 
                <cfoutput QUERY="GET_ASSET_CAT">
                  <option value="#ASSETP_CATID#" <cfif isdefined("attributes.CAT")><cfif attributes.CAT eq ASSETP_CATID>selected</cfif></cfif>>#ASSETP_CAT# 
                </cfoutput>
              </select>
            </td>
            <td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
            <td width="4">&nbsp;</td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
      <table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border" align="center">
        <tr class="color-header" height="22">
          <td class="form-title" width="303"><cf_get_lang_main no='1421.Fiziki Varlık'></td>
          <td width="295" class="form-title"><cf_get_lang_main no='74.Kategori'></td>
          <td width="276" class="form-title"><cf_get_lang_main no='2234.Lokasyon'></td>
          <td width="204" class="form-title"><cf_get_lang_main no='132.Sorumlu'></td>
        </tr>
        <cfif GET_ASSET.recordcount>
			<cfquery name="GET_ASSETP_DEP_ALL" datasource="#dsn#">
			SELECT 
				ZONE.ZONE_NAME, 
				BRANCH.BRANCH_NAME, 
				DEPARTMENT.DEPARTMENT_HEAD,
				DEPARTMENT.DEPARTMENT_ID
			FROM 
				ZONE, 
				BRANCH, 
				DEPARTMENT
			WHERE 
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
				ZONE.ZONE_ID = BRANCH.ZONE_ID
			</cfquery>
          <cfoutput query="GET_ASSET" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif LEN(GET_ASSET.ASSETP_CATID)>
				<cfquery name="GET_ASSET_DEP" dbtype="query">
					SELECT 
						* 
					FROM 
						GET_ASSET_CAT 
					WHERE 
						ASSETP_CATID = #GET_ASSET.ASSETP_CATID#
				</cfquery>
			</cfif>
<!--- IC20050525 kapatildi, performans gozetilmeli... (30 gune silinsin)
 			<cfif LEN(GET_ASSET.POSITION_CODE)>
				<cfquery name="GET_ASSET_EMP" datasource="#DSN#">
					SELECT 
						* 
					FROM 
						EMPLOYEE_POSITIONS 
					WHERE 
						EMPLOYEE_POSITIONS.POSITION_CODE = #GET_ASSET.POSITION_CODE#
				</cfquery>
			</cfif>
 --->		<cfif LEN(GET_ASSET.DEPARTMENT_ID)>
<!--- 				<cfquery name="GET_DEP" datasource="#dsn#">
					SELECT 
						DEPARTMENT_ID,
						DEPARTMENT_HEAD
					FROM 
						DEPARTMENT 
					WHERE 
						DEPARTMENT_ID = #GET_ASSET.DEPARTMENT_ID#
				</cfquery>
			</cfif>
			<cfif LEN(GET_DEP.DEPARTMENT_ID)>--->
				<cfquery name="GET_ASSETP_DEP" dbtype="query">
					SELECT 
						ZONE_NAME, 
						BRANCH_NAME, 
						DEPARTMENT_HEAD
					FROM 
						GET_ASSETP_DEP_ALL
					WHERE 
						DEPARTMENT_ID = #GET_ASSET.DEPARTMENT_ID#
				</cfquery>
			</cfif>
            <cfif GET_ASSET_DEP.IT_ASSET IS 1>
             <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a href="#request.self#?fuseaction=asset.list_asset&event=updp&assetp_id=#assetp_id#" class="tableyazi">#GET_ASSET.ASSETP#</a></td>
                <td>#GET_ASSET_DEP.ASSETP_CAT#</td>
                <td>#GET_ASSETP_DEP.zone_name# / #GET_ASSETP_DEP.branch_name# / #GET_ASSETP_DEP.DEPARTMENT_HEAD#</td>
                <td><cfif len(GET_ASSET.POSITION_CODE)>#get_emp_info(GET_ASSET.POSITION_CODE,1,1)#</cfif></td>
              </tr>
            </cfif>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="7">&nbsp;&nbsp;<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr>
      <td> 
	  <cf_pages page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="ASSET.LIST_IT_ASSET">
	  </td>
      <!-- sil --><td height="35" style="text-align:right;"> 
	  <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
  <br/>
</cfif>
