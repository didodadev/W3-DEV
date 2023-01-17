<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
Description : fileların farkli serverlardan silinmesini saglar.

Parameters :
	output_file :		--- > dosya adi --- required
	output_server :		--- > dosya serveri --- required
Syntax :
	<cf_del_server_file output_file="dosya_adi.gif" output_server="1">
created :
	YO20061107
--->
<cfoutput>
	<cfif attributes.output_server eq caller.fusebox.server_machine>
		<cftry>
			<CFFILE action="DELETE" file="#caller.upload_folder##caller.dir_seperator##attributes.output_file#">
			<cfcatch type="any">#caller.getLang('main',2153)#!</cfcatch>		<!---Dosya Bulunamadı Ancak Veritabanından Silindi --->
		</cftry>		
	<cfelse>
		<cftry>
			#caller.getLang('main',2155)#.<!---  Başka Serverdan Silindi --->
			<cfcatch type="any">#caller.getLang('main',2154)#!</cfcatch>	<!---Dosya Başka Serverdan Silme Hatası --->
		</cftry>
	</cfif>	
</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
