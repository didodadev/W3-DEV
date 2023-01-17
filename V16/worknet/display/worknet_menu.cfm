<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='24.worknet'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no ='5.Üyeler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='226.Üye Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no ='152.Ürünler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='1613.Ürün Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang no='182.Kataloglar'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang no='175.Katalog Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang_main no='115.Talep'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang no='124.Talep Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang_main no='1732.Sosyal Medya'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no="117.Tanımlar"></cfsavecontent>
<cfset f_n_action_list = "worknet.list_dashboard*0*0*#m_dil_1#,worknet.list_company*0*0*#m_dil_2#,worknet.add_member_company*0*0*#m_dil_3#,worknet.list_product*0*0*#m_dil_4#,worknet.add_product*0*0*#m_dil_5#,worknet.list_catalog*0*0*#m_dil_10#,worknet.add_catalog*0*0*#m_dil_11#,worknet.list_demand*0*0*#m_dil_6#,worknet.add_demand*0*0*#m_dil_7#,worknet.list_social_media*0*0*#m_dil_8#,worknet.member_definitions*0*0*#m_dil_9#">
<cfoutput>
<cfswitch expression="#session.ep.design_id#">
<cfcase value="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="27" background="/images/tas2/altarka.jpg">
      <tr>
        <td>
          <table border="0" cellpadding="0" cellspacing="0">
            <tr>
			<cfset c_f_ = 0>
				<cfloop list="#f_n_action_list#" index="mcc">
				  <cfset link_type_ = listgetat(mcc,2,"*")>
					<cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
						<cfset c_f_ = c_f_ + 1>
						<td><cfif c_f_ eq 1>&nbsp;</cfif><cfif link_type_ is '0'><a href="javascript://" oncontextmenu="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','0');" onclick="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','1');" class="<cfif c_f_ eq 1>altbarheader<cfelse>altbar</cfif>">#listgetat(mcc,4,"*")#</a></cfif><cfif c_f_ eq 1>&nbsp;</cfif></td>
					</cfif>
				</cfloop>
            </tr>
          </table>
        </td>
        <td style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm">
        </td>
      </tr>
    </table>
</cfcase>
<cfcase value="3,4,7">
	<div class="menus2">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr>
            	<td>
                	 <table border="0" cellpadding="0" cellspacing="0">
                         <tr>
                            <cfset c_f_ = 0>
                            <cfloop list="#f_n_action_list#" index="mcc">
                                <td>
                                    <cfset link_type_ = listgetat(mcc,2,"*")>
                                    <cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
                                       <cfset c_f_ = c_f_ + 1>
                                       <cfif link_type_ is '0'><a href="javascript://" oncontextmenu="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','0');" onclick="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','1');" class="<cfif c_f_ eq 1>menus2_head<cfelse>menus2_title</cfif>">#listgetat(mcc,4,"*")#</a></cfif>
                                    </cfif>
                                </td>
                            </cfloop>
                        </tr>
                    </table>
                </td>
                <td style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
            </tr>
        </table>
    </div>
</cfcase>
<cfdefaultcase>
    <table border="0" cellpadding="0" cellspacing="0" background="/images/top22back.gif" width="100%" height="27">
      <tr>
        <td>
          <table border="0" cellpadding="0" cellspacing="0">
            <tr>
			<cfset c_f_ = 0>
				<cfloop list="#f_n_action_list#" index="mcc">
				  <cfset link_type_ = listgetat(mcc,2,"*")>
					<cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
						<cfset c_f_ = c_f_ + 1>
						<cfif c_f_ eq 1>
							<td align="center"><cfif link_type_ is '0'><a href="javascript://" oncontextmenu="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','0');" onclick="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','1');" class="topheader">#listgetat(mcc,4,"*")#</a></cfif></td>
						<cfelse>
							<td><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><cfif link_type_ is '0'><a href="javascript://" oncontextmenu="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','0');" onclick="get_page_ajax(this,'#request.self#?fuseaction=#listgetat(mcc,1,"*")#','1');" class="top2">#listgetat(mcc,4,"*")#</a></cfif></td>
							<td><img src="/images/button/sag.gif"></td>
						</cfif>
					</cfif>
				</cfloop>
            </tr>
          </table>
        </td>
        <td align="right"><cfinclude template="../../objects/display/favourites.cfm">
        </td>
      </tr>
    </table>
</cfdefaultcase>
</cfswitch>
</cfoutput> 
<script type="text/javascript">
	function get_page_ajax(element,adres_,type)
	{
		if(type == '1')
			{
			element.href = 'javascript://';
			AjaxPageLoad(adres_+'&ajax_menu=1','worknet',1,'İşleminiz Gerçekleştiriliyor! Lütfen Bekleyiniz!');
			window.location.hash = list_getat(adres_,2,'=');
			return false;
			}
		else
			{
			element.href = adres_;
			}
	}
</script>
