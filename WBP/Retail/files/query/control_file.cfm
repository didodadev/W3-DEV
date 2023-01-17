<cfset upload_folder = "#upload_folder#store#dir_seperator##attributes.department_id##dir_seperator#">
<cfif not FileExists("#upload_folder#output.txt")>
	Dosya Henüz Oluşmamış...
    <script>
		check_file();
	</script>
<cfelse>
	<cffile action="read" file="#upload_folder#output.txt" variable="dosyam">
    <cfif not len(dosyam)>
    	<script>
			check_file();
		</script>
    <cfelse>
    	<script>
			duzenle();
		</script>
    </cfif>
</cfif>