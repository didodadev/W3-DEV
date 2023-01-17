<cfparam name="attributes.type" default="">
<cfscript>
	getObj = CreateObject("component","cfc.system");
</cfscript>
<cfswitch expression = "#attributes.type#">
	<cfcase value="model">  
        <cfinclude template="../../../WDO/modalModel.cfm">
    </cfcase>
    <cfcase value="oldController">
    	<cfinclude template="../../../WDO/modalOldController.cfm">
    </cfcase>
	<cfcase value="controller">
    	<cfinclude template="../../../WDO/modalController.cfm">
    </cfcase>
    <cfcase value="widget">
    	<cfinclude template="../../../WDO/modalWidget.cfm">
    </cfcase>
    <cfcase value="widgetAdd">
        <cfinclude template="../../../WDO/modalWidgetAdd.cfm">
    </cfcase>
    <cfcase value="form">
    	<cfinclude template="../../../WDO/modalForm.cfm">
    </cfcase>
    <cfcase value="list">
    	<cfinclude template="../../../WDO/modalList.cfm">
    </cfcase>
    <cfcase value="components">
    	<cfinclude template="../../../WDO/modalComponents.cfm">
    </cfcase>
    <cfcase value="trigger">
    	<cfinclude template="../../../WDO/modalTrigger.cfm">
    </cfcase>
    <cfcase value="output">
    	<cfinclude template="../../../WDO/modalOutput.cfm">
    </cfcase>
    <cfcase value="db">
    	<cfinclude template="../../../WDO/modalDb.cfm">
    </cfcase>
    <cfcase value="sc">
    	<cfinclude template="../../../WDO/modalSchema.cfm">
    </cfcase>
    <cfcase value="addons">
    	<cfinclude template="../../../WDO/modalAddons.cfm">
    </cfcase>
    <cfcase value="bugs">
    	<cfinclude template="../../../WDO/modalBugs.cfm">
    </cfcase>
    <cfcase value="support">
    	<cfinclude template="../../../WDO/modalSupport.cfm">
    </cfcase>
    <cfcase value="wx">
    	<cfinclude template="../../../WDO/modalWex.cfm">
    </cfcase>
    <cfcase value = "wxAdd">
        <cfinclude template="../../../WDO/modalWexAdd.cfm">
    </cfcase>
    <cfcase value="community">
    	<cfinclude template="../../../WDO/modalCommunity.cfm">
    </cfcase>
    <cfcase value="mm">
    	<cfinclude template="../../../WDO/modalModuleMenu.cfm">
	</cfcase>
	<cfcase value="wo">
    	<cfinclude template="../../../WDO/modalWo.cfm">
    </cfcase>
	<cfcase value="ut">
    	<cfinclude template="../../../WDO/modalUt.cfm">
    </cfcase>
	<cfcase value="converter">
    	<cfinclude template="../../../WDO/modalConverter.cfm">
    </cfcase>
	<cfcase value="mmsorter">
    	<cfinclude template="../../../WDO/modalModuleMenuSorter.cfm">
    </cfcase>
	<cfcase value="woAdd">
    	<cfinclude template="../../../WDO/modalWoAdd.cfm">
    </cfcase>
    <cfcase value="w3Site">
    	<cfinclude template="../../../WDO/modalW3Site.cfm">
    </cfcase>
    <cfcase value="icn">
    	<cfinclude template="../../../css/assets/icons/icons.cfm">
    </cfcase>
    <cfcase value="TST">
    	<cfinclude template="../../../WDO/testPageList.cfm">
    </cfcase>
    <cfcase value="DT">
    	<cfinclude template="../../../WDO/modalDt.cfm">
    </cfcase>
    <cfcase value="event">
        <cfinclude template="../../../WDO/modalEvent.cfm">
    </cfcase>
    <cfcase value="bp">
        <cfinclude template="../../../WDO/modalBestPractice.cfm">
    </cfcase>
    <cfcase value="md">
    	<cfinclude template="../../../WDO/modalMenuDesigner.cfm">
    </cfcase>
    <cfcase value="is">
        <cfinclude template="../../../WDO/modalImpSteps.cfm">
    </cfcase>
    <cfcase value="issorter">
        <cfinclude template="../../../WDO/ImpTaskSorter.cfm">
    </cfcase>
    <cfcase value="qpic">
        <cfinclude template="../../../WDO/modalqpic.cfm">
    </cfcase>
    <cfcase value="map">
        <cfinclude template="../../../WDO/modalMapper.cfm">
    </cfcase>
    <cfcase value="cs">
        <cfinclude template="../../../WDO/modalClassDocument.cfm">
    </cfcase>
    <cfdefaultcase>
    	<cfinclude template="../../../WDO/modalWrkObject.cfm">
    </cfdefaultcase>
</cfswitch>

<script type="text/javascript">
	$(function(){	
		catalystTab(); // assets/custom/script.js tab icin gerekli fonksiyon
	});//ready
</script>