<cfinclude template="../query/get_event.cfm">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.all_events" default="">
<script type="text/javascript">
	/* 20060808 FA kaldirdi 90 gün sonra siline
	opener.time_cost.work_head.value = "";
	opener.time_cost.crm_head.value = "";
	opener.time_cost.emp_name.value = "";
	opener.time_cost.expense.value = "";
	opener.time_cost.project_head.value="";
	opener.time_cost.islem.value = "event";*/

function add_user(id,name)
{
	window.close();
	<cfif isdefined("attributes.field_name")>
	opener.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
	opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
}
</script>
<cfset url_str="" >
<cfif isdefined("attributes.field_id")>
  <cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
  <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfoutput>
    <table class="harfler">
      <tr>
        <td>&nbsp;</td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=A">A</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=B">B</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=C">C</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Ç">Ç</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=D">D</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=E">E</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=F">F</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=G">G</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=H">H</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=I">I</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=İ">İ</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=J">J</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=K">K</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=L">L</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=M">M</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=N">N</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=O">O</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Ö">Ö</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=P">P</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Q">Q</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=R">R</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=S">S</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Ş">Ş</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=T">T</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=U">U</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Ü">Ü</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=V">V</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=W">W</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=X">X</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Y">Y</a></td>
        <td><a href="#request.self#?fuseaction=myhome.popup_add_event&keyword=Z">Z</a></td>
        <td>&nbsp;</td>
      </tr>
    </table>
</cfoutput>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31026.Olaylar'></cfsavecontent>
<cf_medium_list_search title="#message#">
    <cf_medium_list_search_area>
    <cfform name="search_event" action="#request.self#?fuseaction=myhome.popup_add_event&#url_str#" method="post">
        <table>
            <tr>
                <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                <td><cf_get_lang dictionary_id='31060.Tüm Olaylar'>
                <input type="Checkbox" name="all_events" id="all_events" value="1" <cfif attributes.all_events eq 1>checked</cfif>></td>
                <td valign="middle">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
                    <cfinput value="#dateformat(attributes.startdate,dateformat_style)#" type="text" validate="#validate_style#" message="#message#" name="startdate" style="width:65px;">
                </td>
                <td valign="middle"><cf_wrk_date_image date_field="startdate"></td>
                <td valign="middle">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                    <cfinput value="#dateformat(attributes.finishdate,dateformat_style)#"  type="text" name="finishdate" validate="#validate_style#" message="#message#" style="width:65px;">
                </td>
                <td valign="middle"><cf_wrk_date_image date_field="finishdate"></td>
                <td>
                <td><cf_wrk_search_button></td>
            </tr>
        </table>
    </cfform>
    </cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='29510.Olay'></th>
            <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
            <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
        </tr>
    </thead>
    <tbody>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_event.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_event.recordcount>
		<cfoutput query="get_event" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td width="50">#event_ID#</td>
                <td><a href="javascript://"  onclick="add_user('#event_id#','#event_head#')" class="tableyazi">#event_head#</a></td>
                <td>#dateformat(get_event.startdate,dateformat_style)#</td>
                <td>#dateformat(get_event.finishdate,dateformat_style)#</td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows> 

<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#" >
</cfif>
<cfif isDefined('attributes.startdate') and len(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isDefined('attributes.finishdate') and len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isDefined('attributes.all_events') and len(attributes.all_events)>
	<cfset url_str = "#url_str#&all_events=#attributes.all_events#">
</cfif>
  <table width="99%" align="center">
    <tr>
      <td>
	  <cf_pages page="#attributes.page#"
	  	 maxrows="#attributes.maxrows#" 
		 totalrecords="#attributes.totalrecords#" 
		 startrow="#attributes.startrow#" 
		 adres="myhome.popup_add_event&#url_str#"></td>
      <!-- sil --><td" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
