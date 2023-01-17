<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = date_add('d',-3,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
<cfinclude template="../query/get_sayimlar.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_sales_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr>
  <td valign="top">
	
	<table width="98%" align="center" cellpadding="0" cellspacing="0">
     <tr>
      <td class="headbold" height="35">Dönem Başı\Devir Sayımlar</td>
	  <td style="text-align:right;">
		   
	   <table>
       <cfform name="search_form" method="post" action="#request.self#?fuseaction=store.list_sayim">
		<tr>
         <td><cf_get_lang_main no='48.Filtre'></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='89.başlangıç'></cfsavecontent>
			<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
			<cf_wrk_date_image date_field="startdate"></td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='90.Bitiş'></cfsavecontent>
			<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
			<cf_wrk_date_image date_field="finishdate"></td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" style="width:25px;"></td>
			<td><input type="image" border="0" src="images/ara.gif" onClick="return date_check(document.search_form.startdate,document.search_form.finishdate,'Bitiş Tarihi Başlangıç Tarihinden Küçük !');"></td>
          </tr>
		  </cfform>
        </table>
		  </td>
        </tr>
      </table>
      <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr class="color-border" >
          <td>
            <table cellpadding="2" cellspacing="1" border="0" width="100%">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang_main no='41.Şube'></td>
                <td class="form-title" width="65"><cf_get_lang_main no='56.Belge'></td>
				<td class="form-title" width="65">Açıklama</td>
				<td class="form-title" width="150" align="left">Toplam Maliyet</td>
                <td class="form-title" width="110">Kaydeden</td>
                <td width="95" class="form-title"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
                <td width="15"><a href="<cfoutput>#request.self#?fuseaction=store.form_add_sayim</cfoutput>"><img src="/images/plus_square.gif" title="Ekle" border="0" align="absmiddle"></a></td>
              </tr>
			   <cfoutput query="get_sales_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
               <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>#BRANCH_NAME#</td>
				<td><a href="#file_web_path#store#dir_seperator##FILE_NAME#"><img src="/images/attach.gif" border="0" align="absmiddle"></a>&nbsp;<a href="#request.self#?fuseaction=store.form_upd_sayim&file_id=#GIRIS_ID#" class="tableyazi">#FILE_NAME#</a></td>
				<td>#DESCRIPTION#</td>
				<td style="text-align:right;">#TlFormat(toplam_maliyet)#<cfif toplam_maliyet gt 0> #session.ep.money#</cfif></td>
				<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
				<td>#dateformat(date_add("h",session.ep.time_zone,RECORD_DATE),dateformat_style)#</td>
				<td><a href="javascript://"  onclick="delete_sayim(#giris_id#);"><img src="/images/delete.gif" title="Dosya Sil" border="0" align="absmiddle"></a></td>
                </tr> 
				</cfoutput>
				<cfif not get_sales_imports.recordcount>
              	<tr class="color-row" height="20">
                	<td colspan="11"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	            </tr>
				</cfif>
            </table>
          </td>
        </tr>
      </table>
	  <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
		<cfset url_string = ''>
		<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
			<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
			<cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
		</cfif>
		<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr>
			<td>
		  	<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="store.list_sayim#url_string#">
			</td>
		  <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
		</tr>
		</table>
	  </cfif>
	<br/>    
    </td>
  </tr>
</table>
<form name="delete_form" id="delete_form" method="post" action="<cfoutput>#request.self#?fuseaction=store.emptypopup_del_sayim</cfoutput>">
	<input type="hidden" name="file_id" id="file_id" value="">
</form>
<script language="JavaScript" type="text/javascript">
function delete_sayim(entry_id){
	if(confirm('Dosyayı silmek istediğinizden eminmisiniz?'))
	{
		document.delete_form.file_id.value = entry_id;
		document.delete_form.submit();
	}
}
</script>
