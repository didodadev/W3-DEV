<cfif isdefined('session.pp.userid')>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfset getMemberFollow = createObject("component","worknet.objects.worknet_objects").getMemberFollow(member_id:session.pp.userid,keyword:attributes.keyword)>
    <cfparam name="attributes.totalrecords" default="#getMemberFollow.recordcount#">
    
    <div class="haber_liste" style="background-color:#FFF;margin:10px; width:675px; height:100%;">    
        <div class="haber_liste_1" style="width:675px;">
            <cfform name="search" action="" method="post">
                <div class="haber_liste_11" style="width:200px;"><h1><cf_get_lang no='74.Kontak Listem'></h1></div>
                <div class="haber_liste_12" style="width:32px;margin:-37px 0px 9px 0px;">
                    <input class="arama_btn" name="" type="submit" value="" style=" border:none;">
                </div>
                <div class="haber_liste_12" style="margin:-40px 20px 0px 0px;">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
                </div>
            </cfform>
        </div>
    
        <div class="haber_liste_2" style="background-color:#FFF; width:675px;">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
               <tr class="mesaj_31">
                <td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
                <td class="mesaj_311_1"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></td>
                <td class="mesaj_311_1"><cf_get_lang_main no='1195.Firma'></td>
               </tr>
            <cfif getMemberFollow.recordcount>
                <cfoutput query="getMemberFollow" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                        <td class="tablo1">#currentrow#</td>
                        <td class="tablo1">
                            <a href="javascript://" onclick="gonder('#PARTNER_ID#','#NICKNAME#-#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#');">#company_partner_name# #company_partner_surname#</a>
                        </td>
                        <td class="tablo2">
                           <a href="javascript://" onclick="gonder('#PARTNER_ID#','#NICKNAME#-#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#');">#fullname#</a>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr class="mesaj_34">
                  <td class="tablo1" colspan="5"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
           </table>
        </div>
        <div class="haber_liste_3">
            <ul>
                <cfif attributes.totalrecords gt attributes.maxrows>
                    <cfset urlstr="&keyword=#attributes.keyword#">
					<cfif isdefined('field_id') and len(field_id)>
						<cfset urlstr="#urlstr#&field_id=#field_id#&field_name=#field_name#">
					</cfif>
					<cfif isdefined('field_name') and len(field_name)>
						<cfset urlstr="#urlstr#&field_name=#field_name#">
					</cfif>
                    <cf_paging page="#attributes.page#" 
                    page_type="3"
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#attributes.fuseaction##urlstr#">
                          
                </cfif>
            </ul>
        </div>
    </div>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>

<script type="text/javascript">
	function gonder(id,name)
	{
		window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		window.close();
	}
</script>
