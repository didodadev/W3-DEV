<cfparam name="attributes.keyword" default="">
<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn#">
    SELECT 
        G_SERVICE_APPCAT.SERVICECAT_ID,
        G_SERVICE_APPCAT.SERVICECAT,
        G_SERVICE_APPCAT_SUB.SERVICE_SUB_CAT_ID,
        SERVICE_SUB_CAT,
        SERVICE_SUB_STATUS_ID,
        SERVICE_SUB_STATUS
    FROM 
        G_SERVICE_APPCAT 
        JOIN G_SERVICE_APPCAT_SUB ON G_SERVICE_APPCAT.SERVICECAT_ID = G_SERVICE_APPCAT_SUB.SERVICECAT_ID 
	    LEFT JOIN G_SERVICE_APPCAT_SUB_STATUS ON G_SERVICE_APPCAT_SUB.SERVICE_SUB_CAT_ID =  G_SERVICE_APPCAT_SUB_STATUS.SERVICE_SUB_CAT_ID
    <cfif len(attributes.keyword)>
    WHERE 	
    	G_SERVICE_APPCAT.SERVICECAT LIKE '%#attributes.keyword#%'
        or
        SERVICE_SUB_CAT  LIKE '%#attributes.keyword#%'
        or
        SERVICE_SUB_STATUS  LIKE '%#attributes.keyword#%'
    </cfif>
</cfquery>

<cfquery name="GET_SERVICE_APPCAT1" dbtype="query">
	SELECT DISTINCT
    	SERVICECAT_ID,
   		SERVICECAT 
    FROM 
    	GET_SERVICE_APPCAT 
    ORDER BY 
    	SERVICECAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB" dbtype="query">
	SELECT  DISTINCT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT ORDER BY SERVICE_SUB_CAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" dbtype="query">
	SELECT DISTINCT
    	SERVICE_SUB_CAT_ID,	 
    	SERVICE_SUB_STATUS_ID,
    	SERVICE_SUB_STATUS
    FROM 
    	GET_SERVICE_APPCAT 
    ORDER BY 
    	SERVICE_SUB_STATUS
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_SERVICE_APPCAT.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	<cfif not isdefined("attributes.coklu_secim")>
		function gonder(service_cat_id,service_sub_cat_id,service_sub_status_id,deger)
		{
			<cfif isDefined("attributes.service_cat_id")>
				opener.<cfoutput>#attributes.service_cat_id#</cfoutput>.value=service_cat_id;
			</cfif>
			<cfif isDefined("attributes.service_sub_cat_id")>
				opener.<cfoutput>#attributes.service_sub_cat_id#</cfoutput>.value=service_sub_cat_id;
			</cfif>
			<cfif isDefined("attributes.service_sub_status_id")>
				opener.<cfoutput>#attributes.service_sub_status_id#</cfoutput>.value=service_sub_status_id;
			</cfif>
			<cfif isDefined("attributes.service_cat")>
				opener.<cfoutput>#attributes.service_cat#</cfoutput>.value=deger;
			</cfif>
			window.close();
		}
	<cfelse>
		function gonder(app_cat_id,app_cat)
		{
		var kontrol =0;
		uzunluk=opener.<cfoutput>#attributes.field_name#</cfoutput>.length;
		for(i=0;i<uzunluk;i++)
		{
			if(opener.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==app_cat)
			{
				kontrol=1;
			}
		}
		
		if(kontrol==0){
			<cfif isDefined("attributes.field_name")>
				x = opener.<cfoutput>#attributes.field_name#</cfoutput>.length;				
				opener.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
				opener.<cfoutput>#attributes.field_id#</cfoutput>.length = parseInt(x + 1);
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = app_cat;
				opener.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = app_cat;
				opener.<cfoutput>#attributes.field_id#</cfoutput>.options[x].value = app_cat_id;
				opener.<cfoutput>#attributes.field_id#</cfoutput>.options[x].text = app_cat_id;
			</cfif>
			}
		}
	</cfif>
</script>
<cfset url_string = "">

<cfif isdefined("attributes.coklu_secim")>
  <cfset url_string = "#url_string#&coklu_secim=#attributes.coklu_secim#">
</cfif>
<cfif isdefined("service_cat_id")>
  <cfset url_string = "#url_string#&service_cat_id=#service_cat_id#">
</cfif>
<cfif isdefined("service_sub_cat_id")>
  <cfset url_string = "#url_string#&service_sub_cat_id=#service_sub_cat_id#">
</cfif>
<cfif isdefined("service_sub_status_id")>
  <cfset url_string = "#url_string#&service_sub_status_id=#service_sub_status_id#">
</cfif>
<cfif isdefined("service_cat")>
  <cfset url_string = "#url_string#&service_cat=#service_cat#">
</cfif>
<cf_big_list_search title="Servis Kategorileri">
	<cf_big_list_search_area>
    <cfform name="search_con" action="#request.self#?fuseaction=objects.popup_list_service_app_cats" method="post">
<div class="row">    
    <div class="col col-12 form-inline"> 
            	<cfif isdefined("attributes.coklu_secim")>
                    <cfinput type="hidden" name="coklu_secim" value="#attributes.coklu_secim#">
                </cfif>
                <cfif isdefined("attributes.service_cat_id")>
                	<cfinput type="hidden" name="service_cat_id" value="#attributes.service_cat_id#">
                </cfif>
                 <cfif isdefined("attributes.service_sub_cat_id")>
                	<cfinput type="hidden" name="service_sub_cat_id" value="#attributes.service_sub_cat_id#">
                </cfif>
                 <cfif isdefined("attributes.service_sub_status_id")>
                	<cfinput type="hidden" name="service_sub_status_id" value="#attributes.service_sub_status_id#">
                </cfif>
                <cfif isdefined("attributes.service_cat")>
                	<cfinput type="hidden" name="service_cat" value="#attributes.service_cat#">
                </cfif>
                <cfif isdefined("attributes.field_id")>
                	<cfinput type="hidden" name="field_id" value="#attributes.field_id#">
                </cfif>
                <cfif isdefined("attributes.field_name")>
                	<cfinput type="hidden" name="field_name" value="#attributes.field_name#">
                </cfif>
            <div class="form-group" id="item-keyword">
        	<div class="input-group x-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <cfinput type="text" name="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
            </div>
        </div>
    <div class="form-group x-3_5"> 
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
        </div>
    <div class="form-group">
            <cf_wrk_search_button>
            </div> 
        </div>
    </div>
    </cfform>
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_medium_list>
<thead>
    <tr>		
        <th><cf_get_lang dictionary_id='41722.Servis Kategorisi'></th>
    </tr>
</thead>
<tbody>
<cfif GET_SERVICE_APPCAT.recordcount>
	<cfoutput query="GET_SERVICE_APPCAT1" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
    <tr>
      <td><cfif not isdefined("attributes.coklu_secim")><a href="javascript://" onclick="gonder('#SERVICECAT_ID#','','','#SERVICECAT#');" class="tableyazi"><strong>#SERVICECAT#</strong></a><cfelse><a href="javascript://" onclick="gonder('#SERVICECAT_ID#-*-*','#SERVICECAT#');" class="tableyazi"><strong>#SERVICECAT#</strong></a></cfif></td>
    </tr>
    <cfset my_service_cat_id = SERVICECAT_ID>
    <cfset my_service_cat = SERVICECAT>
    <cfquery name="GET_MY_APPCAT_SUB" dbtype="query">
        SELECT * FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #my_service_cat_id#
    </cfquery>			
    <cfloop query="GET_MY_APPCAT_SUB">				
        <cfif SERVICE_SUB_CAT contains (attributes.keyword)>
            <tr>
              <td>&nbsp;&nbsp;&nbsp;<cfif not isdefined("attributes.coklu_secim")><a href="javascript://" onclick="gonder('#my_service_cat_id#','#SERVICE_SUB_CAT_ID#','','#my_service_cat# - #SERVICE_SUB_CAT#');" class="tableyazi"><U>#SERVICE_SUB_CAT#</U></a><cfelse><a href="javascript://" onclick="gonder('#my_service_cat_id#-#SERVICE_SUB_CAT_ID#-*','#my_service_cat# - #SERVICE_SUB_CAT#');" class="tableyazi"><U>#SERVICE_SUB_CAT#</U></a></cfif></td>
            </tr>
        </cfif>
        <cfset my_service_sub_cat_id = SERVICE_SUB_CAT_ID>
        <cfset my_service_sub_cat = SERVICE_SUB_CAT>
        <cfquery name="GET_MY_APPCAT_SUB_STATUS" dbtype="query">
            SELECT * FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID = #my_service_sub_cat_id#
        </cfquery>
        <cfloop query="GET_MY_APPCAT_SUB_STATUS">
            <cfif len(GET_MY_APPCAT_SUB_STATUS.SERVICE_SUB_STATUS) and GET_MY_APPCAT_SUB_STATUS.SERVICE_SUB_STATUS contains (attributes.keyword)>
            <tr>
                <td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfif not isdefined("attributes.coklu_secim")>
                        <a href="javascript://" onclick="gonder('#my_service_cat_id#','#my_service_sub_cat_id#','#SERVICE_SUB_STATUS_ID#','#my_service_cat# - #my_service_sub_cat# - #SERVICE_SUB_STATUS#');" class="tableyazi">#SERVICE_SUB_STATUS#</a>
                    <cfelse>
                        <a href="javascript://" onclick="gonder('#my_service_cat_id#-#my_service_sub_cat_id#-#SERVICE_SUB_STATUS_ID#','#my_service_cat# - #my_service_sub_cat# - #SERVICE_SUB_STATUS#');" class="tableyazi">#SERVICE_SUB_STATUS#</a>
                    </cfif>
                </td>
            </tr>
            </cfif>
        </cfloop>
    </cfloop>
    </cfoutput>
<cfelse>
    <tr>
        <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
    </tr>
</cfif>
</tbody>
</cf_medium_list>
<cf_popup_box_footer>
<cfif attributes.maxrows lt attributes.totalrecords>
    <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
        <tr>
            <td><cf_pages
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="objects.popup_list_service_app_cats#url_string#&keyword=#attributes.keyword#"></td>
            <!-- sil -->
            <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
        </tr>
    </table>
</cfif>
</cf_popup_box_footer>

