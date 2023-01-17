<!---- İlan Arama ---->
<cfparam name="attributes.keyword" default="">

<cfset get_components_partner = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>

<cfset get_notices = get_components_partner.get_notices(keyword : attributes.keyword)>
<cfset GET_COMPANY_LOGOS = get_components.GET_COMPANIES()>
<cfset GET_CITIES = get_components.GET_CITY()>

<cfset temp_colspan =3>
<cfparam name="attributes.page" default=1>
<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelseif isdefined('session.ww')>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.cp.maxrows#'>
</cfif>

<cfparam name="attributes.totalrecords" default=#get_notices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="main_tree">
    <div class="membership">
    	<h1>Tüm İlanlar</h1><br />
        <cfif get_notices.recordcount>
			<cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfquery name="GET_COMP_LOGO" dbtype="query">
                    SELECT
                        *
                    FROM
                        GET_COMPANY_LOGOS
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#">
                </cfquery>
                <div class="adver_catagori">
                      <table cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="200">&nbsp;
                                    <a href="/#attributes.update_path_url#?notice_id=#notice_id#" title="#position_name#">
                                    <cfif len(get_comp_logo.asset_file_name2)>
                                        <cf_get_server_file output_file="settings/#get_comp_logo.asset_file_name2#" output_server="#get_comp_logo.asset_file_name2_server_id#" output_type="5" image_width="150"  alt="<cf_get_lang dictionary_id='58497.Position'>" title="<cf_get_lang dictionary_id='58497.Position'>">
                                    </cfif>
                                    </a>
                                </td>
                            	<td width="280">
                       		      <table>
                                        <tr>
                                            <td><b style="font-size:12px;"><cf_get_lang_main no='1085.Poziyon'></b></td>
                                        </tr>
                                        <tr>
                                            <td><a href="/#attributes.update_path_url#?notice_id=#notice_id#" title="#position_name#">#position_name#</a></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                   <table>
                                        <tr>
                                            <td><b style="font-size:12px;"><cf_get_lang_main no='559.Şehir'></b></td>
                                        </tr>
                                        <tr>
                                           <td>
                                                 <cfif len(notice_city)>
                                                	<cfset city_list = ''>
                                           			<cfloop from="1" to="#listlen(notice_city)#" index="i">
														<cfset city_list = listappend(city_list,listgetat(notice_city,i,','),',')>
                                                   	</cfloop>
                                                    	<a href="/#attributes.update_path_url#?notice_id=#notice_id#" title="#position_name#">
                                                        <cfquery name="GET_CITY" dbtype="query">
                                                            SELECT
                                                                *
                                                            FROM
                                                                GET_CITIES
                                                            WHERE
                                                               <!--- CITY_ID IN (#listgetat(city_list,1,',')#)--->
                                                               CITY_ID IN (#city_list#)
                                                        </cfquery>
                                                        #get_city.city_name#<br/>
                                                        </a>
                                                  
                                                </cfif>
                                           </td>
                                        </tr>
                                   </table>
                       	    	 </td>
                            </tr>
                      </table>
                </div>
            </cfoutput>
        <cfelse>
			<table align="center" style="background-color:#eff0f1; width:700px; height:30px;">
            	<tr>
                	<td><div style="float:left; width:30px;"><img src="images/caution.gif" height="20" /></div><div style="float:left; line-height:25px;"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</div></td>
                </tr>
            </table>
        </cfif>
        <div align="center">
			<cfif attributes.totalrecords gt attributes.maxrows>
                <cfset adres="">
                <cfif len(attributes.keyword)>
                    <cfset adres="#adres#&keyword=#attributes.keyword#">
                </cfif>
                <cf_pages page="#attributes.page#" 
                        maxrows="#attributes.maxrows#" 
                        totalrecords="#attributes.totalrecords#" 
                        startrow="#attributes.startrow#" 
                        adres="#attributes.fuseaction#&#adres#">
                <cfoutput><cf_get_lang_main  no='128.Toplam Kayıt'> : #get_notices.recordcount#&nbsp;-&nbsp;<cf_get_lang_main  no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
            </cfif>
            <!---<a href="#" title="geri"><img src="temp/images/page_prev.jpg" height="15" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" title="ileri"><img src="temp/images/page_next.jpg" height="15" /></a>--->
        </div>
    </div>
</div>

