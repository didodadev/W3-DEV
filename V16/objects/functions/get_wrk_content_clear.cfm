<cffunction name="wrk_content_sub_clear" output="false" returntype="string">
	<cfargument name="cont" required="true" default="">
	<cfargument name="ilk_eleman" required="true" default="">
	<cfargument name="son_eleman" required="true" default="">
	<cfscript>
		start = findnocase(arguments.ilk_eleman,cont,1);
		middle = findnocase(arguments.son_eleman,cont,start + len(arguments.ilk_eleman));
		while((start GT 0) and (middle GT 0))
			{
			cont = removechars(cont,start,middle-start+len(arguments.son_eleman));
			start = findnocase(arguments.ilk_eleman,cont,1);
			middle = findnocase(arguments.son_eleman,cont,start + len(arguments.ilk_eleman));
			}
	</cfscript>
	<cfreturn cont>
</cffunction>
<cffunction name="find_gt_element" output="false" returntype="string">
	<cfargument name="cont" required="true" default="">
	<cfargument name="ilk_eleman" required="true" default="">
	<cfscript>
		start = findnocase(arguments.ilk_eleman,cont,1);
		if(start gt 0)
		{
			kalan_ = left(cont,start);
			aranacak_cumle = mid(cont,findnocase(listlast(kalan_,'<'),kalan_,1)-1,start-findnocase(listlast(kalan_,'<'),kalan_,1)+len(arguments.ilk_eleman)+1);
			if(len(aranacak_cumle))
				cont = wrk_content_sub_clear(cont,aranacak_cumle,'</table>');
			else
				cont = cont;
		}
		else
			cont = cont;
	</cfscript>
	<cfreturn cont>
</cffunction>
<cffunction name="wrk_content_clear" output="false" returntype="string">
	<cfargument name="cont" required="true" type="string" default="">
		<cfscript>
			cont = ReplaceList(cont,'  ','');
			cont = ReplaceList(cont,chr(10),' ');
			cont = ReplaceList(cont,chr(13),' ');
			cont = ReplaceList(cont,chr(39),'');
			cont = Replace(cont,'title=','alt=','all');
		</cfscript>
			<cfset cont = "<!-- sil -->" & trim(arguments.cont) & "<!-- sil -->">
			<cfset cont = wrk_content_sub_clear (cont,'<!-- sil -->','<!-- sil -->')>
			<cfset cont = wrk_content_sub_clear (cont,'<!-- siil -->','<!-- siil -->')>
			<cfset cont = wrk_content_sub_clear (cont,'<script','</script>')>
			<cfset cont = wrk_content_sub_clear (cont,'<InvalidTag','</script>')> <!--- Yukaridaki script ifadesi birsekilde invalidTag olarak degisiyor. Kontrol amacli eklendi. EY20130827 --->
			<cfset cont = wrk_content_sub_clear (cont,'<map','</map>')><!--- Cfchart ile olusuturulan grafiklerde geliyor. Bu etiketin oldugu imaj bulunup silinecek. EY20131001 --->

            <cfloop condition = "findnocase('CFIDE',cont) gt 0">
				<cfset cont = find_gt_element (cont,'CFIDE')><!--- CFIDE etiketi cfchart ile olusuturulan grafiklerde geliyor. Bu etiketin oldugu imaj bulunup silinecek. EY20131001 --->
            </cfloop>
			<cfset cont = find_gt_element (cont,'widows: 0')><!--- Rapor modulunde kullanilan thead fixleme fonksiyonu excel alirken js tarafinda 2 tane daha ayni table'i olusturuyordu diye bu fazlaliklari atiyoruz. Widows parametresini js icinde biz ekliyoruz. Diger sayfalari bozmaz EY20131001 --->
			<cfset cont = find_gt_element (cont,'WIDOWS: 0')><!--- Rapor modulunde kullanilan thead fixleme fonksiyonu excel alirken js tarafinda 2 tane daha ayni table'i olusturuyordu diye bu fazlaliklari atiyoruz. Widows parametresini js icinde biz ekliyoruz. Diger sayfalari bozmaz EY20131001 --->
			<cfif browserDetect() contains 'Chrome'>
                <cfset cont = find_gt_element (cont,'table-layout:fixed;')>
                <cfset cont = find_gt_element (cont,'style="margin: 0px;"')>
                <cfset cont = ReReplaceNoCase(cont,"<link[^>]*>", "", "ALL")>
			</cfif>
			<cfset cont = find_gt_element (cont,'class="big_list_search"')>
       <!---<cfset cont = wrk_content_sub_clear (cont,'<UL>','</UL>')> Bu kısım içerik PDF'i basılmasında gerekli <ul> tagının kullanılmasında sorun yarattığı için kaldırılmıştır.
			<cfset cont = wrk_content_sub_clear (cont,'<ul>','</ul>')>--->
			<cfset cont = ReReplaceNoCase(cont,"<html[^>]*>", "", "ALL")>
            <cfset cont = ReReplaceNoCase(cont,"<section[^>]*>", "", "ALL")>
            <cfset cont = ReReplaceNoCase(cont,"</section>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<div[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</div>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<meta[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<head[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</head[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</html[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<form[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</form>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,'<input type="text[^>]*>', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,'<input[^>]*>', '', 'ALL')>
			<!---<cfset cont = ReReplaceNoCase(cont,'<img[^>]*>', '', 'ALL')>--->
			<cfset cont = ReReplaceNoCase(cont,"<select[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</select[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<option[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</option[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<textarea[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</textarea>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,'onmouseover=[^>]*"', ' ', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,'onmouseout=[^>]*"', ' ', 'ALL')>
            <cfset cont = ReReplaceNoCase(cont,'&nbsp;', ' ', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<font[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</font>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,' class=[^>]*"', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,' role=[^>]*"', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,' style=[^>]*"', '', 'ALL')>
            <cfset cont = trim(cont)>
	<cfreturn cont>
</cffunction>
