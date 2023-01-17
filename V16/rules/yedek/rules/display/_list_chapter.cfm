<cfinclude template="../query/get_chapter_hier.cfm">
<cfinclude template="../query/get_chapter_count.cfm">

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='15.Literatür Bölümleri'></td>
    <!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> <!-- sil -->
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr height="22" class="color-header">
          <td class="form-title"><cf_get_lang no='17.Bölüm Adı'></td>
          <td width="100" class="form-title"><cf_get_lang no='25.Konu Sayısı'></td>
        </tr>
        <cfif get_chapter_count.recordcount>
          <cfoutput query="get_chapter_count">
            <cfinclude template="../query/count_ch.cfm">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td><a href="#request.self#?fuseaction=rule.list_rule&chapter_id=#chapter_id#" class="tableyazi">#chapter#</a></td>
                <td><cfif COUNT_CH.COUNT>#COUNT_CH.COUNT#<cfelse>0</cfif></td>
              </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<br/>