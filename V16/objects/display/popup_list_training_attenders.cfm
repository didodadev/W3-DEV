<cfinclude template="../query/get_class_attenders.cfm">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_class_attender.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function dondur(name,id,user_type)
{
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_user_type")>
		opener.<cfoutput>#attributes.field_user_type#</cfoutput>.value = user_type;
	</cfif>
	window.close();
}
</script>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_user_type") and len(attributes.field_user_type)>
	<cfset url_str = "#url_str#&field_user_type=#attributes.field_user_type#">
</cfif>
<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
	<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
</cfif>
<cfform name="form1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_training_attenders">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57590.Katılımcılar'></cfsavecontent>
<cf_medium_list_search title="#message#">
    <cf_medium_list_search_area>  
        <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
		<table>
            <tr> 
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                <td><cf_wrk_search_button></td> 
            </tr>
        </table>
    </cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr> 
			<th width="125"><cf_get_lang dictionary_id='57570.Adı Soyadı'></th>
			<th><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th><cf_get_lang dictionary_id='57453.Şube'></th>
			<th><cf_get_lang dictionary_id='57572.Departman'></th>
			<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_class_attender.recordcount>
			<cfoutput query="get_class_attender" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td><a href="javascript:dondur('#ad# #soyad#','#K_ID#','#type#');" class="tableyazi">#ad#&nbsp;#soyad#</a></td>
					<td>#nick_name#</td>
					<td>#branch_name#</td>
					<td>#departman#</td>
					<td>#position#</td>
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif get_class_attender.recordcount>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
				<td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_training_attenders#url_str#"> 
				</td>
				<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
