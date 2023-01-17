<!---<cfif isdefined('session.pp')>--->
	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(action_id:attributes.pid) />
	<cfelse>
		<cfset getRelationAsset.recordcount = 0>
	</cfif>
	<cfif getRelationAsset.recordcount>
        <cflocation url="#file_web_path##getRelationAsset.ASSETCAT_PATH#/#getRelationAsset.asset_file_name#" addtoken="no">
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<!---<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
--->
