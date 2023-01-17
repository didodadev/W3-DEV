<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.type') and attributes.type is 'tv'>
	<cfmail to="#attributes.send_email#" from="#attributes.my_email#"
		subject="#attributes.sender# Size İnternetten Bu Videoyu Tavsiye Etti" type="HTML" charset="utf-8">
		<cfoutput>
			<font color="red">#attributes.my_name# #attributes.my_surname#</font> size bu videoyu okumanızı tavsiye ediyor.<br/><br/>
			<b>İçeriğin Adresi :</b>
				<a href="#my_url#"> 
					#my_url#
				</a><br/><br/>
			<b>Gönderenin Yorumu :</b> #attributes.comment#
		</cfoutput>
	</cfmail>
<cfelse>
	<cfmail to="#attributes.send_email#" from="#attributes.my_email#"
		subject="#attributes.my_name# #attributes.my_surname# Size İnternetten Bu İçeriği Tavsiye Etti" type="HTML" charset="utf-8">
		<cfoutput>
			<font color="red">#attributes.my_name# #attributes.my_surname#</font> size bu içeriği okumanızı tavsiye ediyor.<br/><br/>
			<b>İçeriğin Adresi :</b>
				<a href="http://#cgi.HTTP_HOST#/#request.self#?#attributes.my_url#=objects2.detail_content&cid=#attributes.cid#"> 
					http://#cgi.HTTP_HOST#/#request.self#?#attributes.my_url#=objects2.detail_content&cid=#attributes.cid#"> 
				</a><br/><br/>
			<b>Gönderenin Yorumu :</b> #attributes.comment#
		</cfoutput>
	</cfmail>
</cfif>
