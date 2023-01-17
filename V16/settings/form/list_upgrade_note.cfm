<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>

<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">
<cfparam name="attributes.make_year" default="#dateformat(now(),'yyyy')#">
<cfparam name="attributes.upgrade_period" default="">

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_UPGRADE_NOTES" datasource="#DSN#">
		SELECT 
	        UPGRADE_NOTE_ID, 
            UPGRADE_NOTE_HEAD, 
            UPGRADE_CAT_ID, 
            VERSION, 
            RELEASE, 
            NOTE_STAGE, 
            NOTE_DATE, 
            NOTE_EMP_ID, 
            MODULE_LEVEL_ID, 
            DETAIL, 
            CODE, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE 
        FROM 
        	WRK_UPGRADE_NOTES
	</cfquery>

<cfelse>
	<cfset get_upgrade_notes.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_upgrade_notes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td class="headbold" height="35">Workcube Upgrade Note</td>
		<td align="right" style="text-align:right;">
            <table>
                <cfform name="search_form" method="post" action="#request.self#?fuseaction=settings.list_upgrade_note">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    <tr>
                        <td></td>
                        <td>
                            <select name="upgrade_version" id="upgrade_version" style="width:55px;">
                            <cfoutput>
                            <cfloop from="#dateformat(now(),'yyyy')#" to="2009" index="i" step="-1">
                                <option value="#i#" <cfif i eq attributes.make_year> selected</cfif>>#i#</option>
                            </cfloop>
                            </cfoutput>
                            </select>
                            <select name="upgrade_release" id="upgrade_release" style="width:40px;">
                                <option value="1" <cfif attributes.upgrade_period eq 1> selected</cfif>>01</option>
                                <option value="2" <cfif attributes.upgrade_period eq 2> selected</cfif>>02</option>
                                <option value="3" <cfif attributes.upgrade_period eq 3> selected</cfif>>03</option>
                                <option value="4" <cfif attributes.upgrade_period eq 4> selected</cfif>>04</option>	
                            </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='89.başlangıç'></cfsavecontent>
                            <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <cf_wrk_date_image date_field="startdate">
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='90.Bitiş'></cfsavecontent>
                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <cf_wrk_date_image date_field="finishdate">
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button search_function='search_kontrol()'></td>
                    </tr>
                </cfform>
            </table>
		</td>
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
        <td>
            <table cellpadding="2" cellspacing="1" border="0" width="100%">
                <tr class="color-header" height="22">
                    <td class="form-title"><cf_get_lang no='68.Konu'></td>
                    <td class="form-title" width="20"><cf_get_lang no='2625.Versiyon'></td>
                    <td class="form-title" width="65"><cf_get_lang_main no='56.Belge'></td>
                    <td align="center" width="1%"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_upgrade_note"><img src="/images/plus_square.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0" align="absmiddle"></a></td>
                </tr> 
					<cfset invoice_id_list = ''>
                    <cfif get_upgrade_notes.recordcount>
                        <cfoutput query="get_upgrade_notes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                <td>#upgrade_note_head#</td>
                                <td>#version#</td>
                                <td><td><a href="#request.self#?fuseaction=settings.form_upd_upgrade_note&upgrade_note_id=#upgrade_note_id#"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" border="0"></a></td></td>
                            </tr>
						</cfoutput>
                    <cfelse>
                <tr class="color-row" height="20">
                    <td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
                </tr>
            </cfif>
        </table>
            <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
                <cfset url_string = ''>
                <cfif len(attributes.target_pos)>
                    <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
                </cfif>
                <cfif len(attributes.startdate)>
                    <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
                </cfif>
                <cfif len(attributes.finishdate)>
                    <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
                </cfif>
                <cfif len(attributes.branch_id)>
                    <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
                </cfif>
                <cfif isdefined("attributes.form_submitted")>
                    <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
                </cfif>		
                <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
                    <tr>
                        <td>
                        <cf_pages page="#attributes.page#"
                            maxrows="#attributes.maxrows#"
                            totalrecords="#attributes.totalrecords#"
                            startrow="#attributes.startrow#"
                            adres="pos.list_sales_import#url_string#">
                        </td>
                        <!-- sil -->
                        <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
                        <!-- sil -->
                    </tr>
                </table>
            </cfif>
        </td>
    </tr>
</table><br/> 
<script type="text/javascript">
function search_kontrol()
{
	if ((search_form.startdate.value != "") && (search_form.finishdate.value != ""))
		return date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang no ='63.Bitiş Tarihi Başlangıç Tarihinden Küçük'> !");
			return true;
}
</script>
