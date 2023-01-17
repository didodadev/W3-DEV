<!---
<cfif not fusebox.fuseaction contains 'emptypopup'>
	<style>.fadein{color:red; font-weight:bold; font-size:14px;}</style>
    <script type="text/javascript" src="/extra/js/shortcut.js"></script>
</cfif>
--->
<style>
  .highlightrow 
  {
    background-color: #99FFFF !important;
  }
</style>
<script>
	merkez_depo_id = '<cfoutput>#merkez_depo_id#</cfoutput>';
</script>
<cfset folder_ = "/extra/display/">
<cfinclude template="../../design/layout_menu.cfm">
<!---
<cfif not fusebox.fuseaction contains 'emptypopup'>
<script>
$(function(){
	setInterval(function(){
		$(".fadein").fadeOut("slow").fadeIn("slow");
	}, 1000);
});
</script>
</cfif>
--->