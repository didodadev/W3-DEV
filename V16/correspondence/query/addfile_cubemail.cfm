<cfsetting showdebugoutput="no">
<script type="text/javascript">
	goster(message_div);
		setTimeout("gizle(message_div);",3000);
</script>
<cfset folder_ = 0>
<cfif DirectoryExists("#folderselectname#\#filename#")>	<!--- Aynı isimle bir dosya varmı diye bakıyorum --->
	<cfset folder_ = 1>
</cfif>
	<cfif folder_ eq 0>
		<cfif not len(folderselectname)>
			<cfdirectory action="create" name="as" directory="#upload_folder#mails\#SESSION.EP.USERID#\#filename#" recurse="yes">
		<cfelse>
			<cfdirectory action="create" name="as" directory="#folderselectname#\#filename#" recurse="yes">
		</cfif>
	</cfif>
<table>
	<tr>
		<td>
			<cfif folder_ eq 0>
				Dosya Oluşturuldu..
			<cfelseif folder_ eq 1>
				<img src="/images/warning.gif" alt="Uyarı">&nbsp;Dosya Oluşturulamadı. Aynı isimle bir dosya mevcut olabilir!
			</cfif> 
		</td>
	</tr>
</table>
