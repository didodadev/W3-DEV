<table width="200" border="0" cellspacing="0" cellpadding="0" height="200" <cfif not get_images.recordcount>bgcolor="#FF6600"</cfif>>
  <tr>
    <td>
<cfoutput>
<cfif (len(get_images.url)) and (get_images.is_flash neq 1)>
<a href="#get_images.url#" target="_blank"><img src="#file_web_path#content/banner/#get_images.banner_file#" title="#get_images.detail#" width="200" height="200" border="0"></a>
<cfelseif (get_images.is_flash neq 1) and (not len(get_images.url))>
<img src="#file_web_path#content/banner/#get_images.banner_file#" title="#get_images.detail#" width="200" height="200" border="0">
<cfelse>
<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" width="200" height="200">
  <PARAM name="movie" value="#file_web_path#content/banner/#get_images.banner_file#">
  <PARAM name="quality" value="high">
  <EMBED src="#file_web_path#content/banner/#get_images.banner_file#" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="200" height="200"></EMBED>
</OBJECT>
</cfif>
</cfoutput>
</td>
  </tr>
</table>