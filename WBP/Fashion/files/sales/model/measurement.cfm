<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.proclist" default="">
<!---<cfdump var="#[attributes.req_id, attributes.proclist]#" abort>--->
<!---
Query bağlanmadı zaten tablo çokta doğru olmayacaktı o yüzden basitçe gelen veriyi açıklayayım.
req_id: bu forma attributes dan geliyordu ordan da buraya geliyor
proclist: bu yapılan listedeki istasyonların id lerini aralarına virgül koyarak getiriyor. cfloop ile dönmen mümkün olsun diye böyle yaptım.

Bu iki veri dışında bir şey yok tabloda da sanırım bu iki sütun var gibi görünüyor tabi planınız da başka alanlarda varmı bilmiyorum
	---->
	
<cfobject name="predefined" component="WBP.Fashion.files.cfc.station_process">
<cfset get_predefineds = predefined.get_predefineds(attributes.req_id)>

<cfif get_predefineds.recordcount gt 0>
			<cfscript>
				predefined.clear_predefined_rows(get_predefineds.PREDEFINED_ID);
			</cfscript>
				<cfloop list="#attributes.proclist#" index="p">
					<cfscript>
						predefined.insert_predefined_row(get_predefineds.PREDEFINED_ID,p);
					</cfscript>
				</cfloop>
<cfelse>
		<cfset key=predefined.insert_predefined('master',attributes.req_id)>
		<cfloop list="#attributes.proclist#" index="p">
			<cfscript>
				predefined.insert_predefined_row(key,p);
			</cfscript>
		</cfloop>
</cfif>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=textile.stretching_test&event=measurement&req_id=#attributes.req_id#</cfoutput>';
</script>
