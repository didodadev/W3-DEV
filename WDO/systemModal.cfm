<cfparam name="attributes.type" default="workcube_object">
<cfscript>
    getObj = CreateObject("component","cfc.system");
</cfscript>
<cfswitch expression = "#attributes.type#">
	<cfcase value="model">  
        <cfinclude template="modalModel.cfm">
    </cfcase>
    <cfcase value="oldController">
    	<cfinclude template="modalOldController.cfm">
    </cfcase>
	<cfcase value="controller">
    	<cfinclude template="modalController.cfm">
    </cfcase>
    <cfcase value="form">
    	<cfinclude template="modalForm.cfm">
    </cfcase>
    <cfcase value="list">
    	<cfinclude template="modalList.cfm">
    </cfcase>
    <cfcase value="components">
    	<cfinclude template="modalComponents.cfm">
    </cfcase>
    <cfcase value="typetrigger">
    	<cfinclude template="modalTrigger.cfm">
    </cfcase>
    <cfcase value="output">
    	<cfinclude template="modalOutput.cfm">
    </cfcase>
    <cfcase value="db">
    	<cfinclude template="modalDb.cfm">
    </cfcase>
    <cfcase value="addons">
    	<cfinclude template="modalAddons.cfm">
    </cfcase>
    <cfcase value="bugs">
    	<cfinclude template="modalBugs.cfm">
    </cfcase>
    <cfcase value="support">
    	<cfinclude template="modalSupport.cfm">
    </cfcase>
    <cfcase value="wex">
    	<cfinclude template="modalWex.cfm">
    </cfcase>
    <cfcase value="community">
    	<cfinclude template="modalCommunity.cfm">
    </cfcase>
    <cfcase value="mm">
    	<cfinclude template="modalModuleMenu.cfm">
	</cfcase>
	<cfcase value="wo">
    	<cfinclude template="modalWo.cfm">
    </cfcase>
	<cfcase value="ut">
    	<cfinclude template="modalUt.cfm">
    </cfcase>
	<cfcase value="converter">
    	<cfinclude template="modalConverter.cfm">
    </cfcase>
    <cfcase value="widget">
        <cfinclude template="modalWidget.cfm">
    </cfcase>
    <cfcase value="TST">
        <cfinclude template="testPageList.cfm">
    <cfcase value="qpic">
        <cfinclude template="modalqpic.cfm">
    </cfcase>
    <cfcase value="map">
        <cfinclude template="modalMapper.cfm">
    </cfcase>
    <cfdefaultcase>
    	<cfinclude template="modalWrkObject.cfm">
    </cfdefaultcase>
</cfswitch>

<script type="text/javascript">
	$(function(){	
		catalystTab(); // assets/custom/script.js tab icin gerekli fonksiyon
	});//ready
</script>