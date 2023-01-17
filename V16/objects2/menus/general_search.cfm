<cfsavecontent variable="gensearch">Site içi arama</cfsavecontent>
<table border="0" width="83%" cellspacing="0" cellpadding="0" height="27">
<cfform name="search" action="#request.self#?fuseaction=objects2.general_search_result" method="post">
	<tr>
		<td background="/objects2/image/aramab.jpg" width="202">
			<p align="center">
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				<cfinput type="text" name="keyword" id="keyword" style="width:180px; height:25px; padding-top:4px; border-width:0px;" value="#attributes.keyword#" onFocus="this.value='';" onKeyPress="if(event.keyCode==13) {if (document.getElementById('keyword').value.length < 3) {alert('Lütfen En Az 3 Karakter Giriniz!');return false;}}">
			<cfelse>
				<cfinput type="text" name="keyword" id="keyword" style="width:180px;height:25px; padding-top:4px; border-width:0px;"value="#gensearch#" onFocus="this.value='';" onKeyPress="if(event.keyCode==13) {if (document.getElementById('keyword').value.length < 3) {alert('Lütfen En Az 3 Karakter Giriniz!');return false;}}">
			</cfif>
		</td>
		<td>
			<input type="image" src="/objects2/image/arax.jpg" onClick="if (document.getElementById('keyword').value.length < 3) {alert('Lütfen En Az 3 Karakter Giriniz!');return false;}">
		</td>
	</tr>
</cfform>
</table>


